package com.campus.ordering.service.impl;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.dto.BatchOrderCreateDTO;
import com.campus.ordering.dto.OrderCreateDTO;
import com.campus.ordering.dto.ShopPaymentDTO;
import com.campus.ordering.entity.*;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.mapper.*;
import com.campus.ordering.service.OrderService;
import com.campus.ordering.vo.AdminOrderDetailVO;
import com.campus.ordering.vo.AdminOrderVO;
import com.campus.ordering.vo.OrderItemVO;
import com.campus.ordering.vo.OrderStatusLogVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
public class OrderServiceImpl implements OrderService {

    @Resource
    private OrderInfoMapper orderInfoMapper;
    @Resource
    private OrderItemMapper orderItemMapper;
    @Resource
    private OrderStatusLogMapper orderStatusLogMapper;
    @Resource
    private ShopInfoMapper shopInfoMapper;
    @Resource
    private ProductInfoMapper productInfoMapper;
    @Resource
    private ProductSpecMapper productSpecMapper;
    
    @Resource
    private UserAddressMapper userAddressMapper;
    @Resource
    private SysUserMapper sysUserMapper;

    @Resource
    private ShoppingCartMapper shoppingCartMapper;

    @Value("${system.order.expire-minutes}")
    private Integer expireMinutes;

    @Override
    public Object getSettleInfo(List<Long> cartIds, Long userId) {
        if (cartIds == null || cartIds.isEmpty()) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "请选择要结算的商品");
        }
        // 1. 查询要结算的商品
        List<ShoppingCart> cartList = shoppingCartMapper.selectList(new LambdaQueryWrapper<ShoppingCart>()
                .in(ShoppingCart::getCartId, cartIds)
                .eq(ShoppingCart::getUserId, userId)
                .eq(ShoppingCart::getIsDeleted, 0));

        // 2. 补全商品详情（商品名称、价格、图片等）
        for (ShoppingCart cart : cartList) {
            ProductInfo product = productInfoMapper.selectById(cart.getProductId());
            if (product != null) {
                cart.setProductName(product.getProductName());
                cart.setProductImage(product.getProductImage());
                ShopInfo shop = shopInfoMapper.selectById(product.getShopId());
                if (shop != null) {
                    cart.setShopName(shop.getShopName());
                    cart.setDeliveryFee(shop.getDeliveryFee());
                    cart.setWxQrcode(shop.getWxQrcode());
                    cart.setAliQrcode(shop.getAliQrcode());
                }
                if (cart.getSpecId() != null) {
                    ProductSpec spec = productSpecMapper.selectById(cart.getSpecId());
                    if (spec != null) {
                        cart.setProductPrice(spec.getSpecPrice());
                    } else {
                        cart.setProductPrice(product.getPrice());
                    }
                } else {
                    cart.setProductPrice(product.getPrice());
                }
            }
        }

        // 3. 查询收货地址列表
        List<UserAddress> addressList = userAddressMapper.selectList(new LambdaQueryWrapper<UserAddress>()
                .eq(UserAddress::getUserId, userId)
                .eq(UserAddress::getIsDeleted, 0)
                .orderByDesc(UserAddress::getIsDefault));

        // 4. 封装返回结果
        Map<String, Object> result = new java.util.HashMap<>();
        result.put("cartList", cartList);
        result.put("addressList", addressList);
        
        // 5. 设置默认选中的地址 ID
        if (!addressList.isEmpty()) {
            UserAddress defaultAddress = addressList.stream()
                    .filter(a -> Integer.valueOf(1).equals(a.getIsDefault()))
                    .findFirst()
                    .orElse(addressList.get(0));
            result.put("defaultAddressId", defaultAddress.getAddressId());
        }
        
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String createOrder(OrderCreateDTO dto, Long userId) {
        // 1. 校验店铺
        ShopInfo shop = shopInfoMapper.selectById(dto.getShopId());
        if (shop == null || shop.getShopStatus() != 1) {
            throw new BusinessException(ResultCode.ERROR, "店铺不存在或未营业");
        }

        // 2. 校验收货地址
        UserAddress address = userAddressMapper.selectOne(new LambdaQueryWrapper<UserAddress>()
                .eq(UserAddress::getAddressId, dto.getAddressId())
                .eq(UserAddress::getUserId, userId)
                .eq(UserAddress::getIsDeleted, 0));
        if (address == null) {
            throw new BusinessException(ResultCode.ERROR, "收货地址不存在");
        }

        // 3. 生成订单号（雪花算法）
        String orderNo = IdUtil.getSnowflakeNextIdStr();

        // 4. 计算订单金额
        BigDecimal productAmount = BigDecimal.ZERO;
        List<OrderItem> itemList = new ArrayList<>();

        for (OrderCreateDTO.OrderItemDTO itemDTO : dto.getItemList()) {
            // 校验商品
            ProductInfo product = productInfoMapper.selectById(itemDTO.getProductId());
            if (product == null || product.getProductStatus() != 1 || !product.getShopId().equals(dto.getShopId())) {
                throw new BusinessException(ResultCode.ERROR, "商品不存在或已下架");
            }

            // 校验规格
            BigDecimal price = product.getPrice();
            if (itemDTO.getSpecId() != null) {
                ProductSpec spec = productSpecMapper.selectById(itemDTO.getSpecId());
                if (spec == null || !spec.getProductId().equals(product.getProductId())) {
                    throw new BusinessException(ResultCode.ERROR, "商品规格不存在");
                }
                price = spec.getSpecPrice();
                // 扣减库存
                spec.setStock(spec.getStock() - itemDTO.getProductNum());
                productSpecMapper.updateById(spec);
            }

            // 计算小计
            BigDecimal totalPrice = price.multiply(BigDecimal.valueOf(itemDTO.getProductNum()));
            productAmount = productAmount.add(totalPrice);

            // 封装订单项
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderNo(orderNo);
            orderItem.setProductId(product.getProductId());
            orderItem.setProductName(product.getProductName());
            orderItem.setProductImage(product.getProductImage());
            orderItem.setSpecId(itemDTO.getSpecId());
            orderItem.setProductPrice(price);
            orderItem.setProductNum(itemDTO.getProductNum());
            orderItem.setTotalPrice(totalPrice);
            itemList.add(orderItem);
        }

        // 5. 校验起送金额
        if (productAmount.compareTo(shop.getMinOrderAmount()) < 0) {
            throw new BusinessException(ResultCode.ERROR, "未达到店铺起送金额");
        }

        // 6. 封装订单主表
        OrderInfo order = new OrderInfo();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setShopId(dto.getShopId());
        order.setReceiverName(address.getReceiverName());
        order.setReceiverPhone(address.getReceiverPhone());
        order.setReceiverAddress(address.getCampusArea() + address.getAddressDetail());
        order.setProductAmount(productAmount);
        order.setDeliveryFee(shop.getDeliveryFee());
        order.setTotalAmount(productAmount.add(shop.getDeliveryFee()));
        order.setPayAmount(order.getTotalAmount());
        order.setOrderStatus(0); // 待支付
        order.setPayStatus(0); // 未支付
        order.setOrderRemark(dto.getOrderRemark());
        order.setExpireTime(LocalDateTime.now().plusMinutes(expireMinutes));
        orderInfoMapper.insert(order);

        // 7. 批量插入订单项
        for (OrderItem item : itemList) {
            item.setOrderId(order.getOrderId());
        }
        orderItemMapper.batchInsert(itemList);

        // 8. 记录订单状态日志
        saveOrderStatusLog(order.getOrderId(), orderNo, null, 0, "用户下单", userId, sysUserMapper.selectById(userId).getUserName());

        return orderNo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public List<ShopPaymentDTO> createBatchOrder(BatchOrderCreateDTO dto, Long userId) {
        log.info("createBatchOrder called, userId: {}, dto: {}", userId, dto);
        List<ShopPaymentDTO> paymentList = new ArrayList<>();

        try {
        for (BatchOrderCreateDTO.ShopOrderDTO shopOrder : dto.getShopOrders()) {
            log.info("Processing shop order: {}", shopOrder);
            ShopInfo shop = shopInfoMapper.selectById(shopOrder.getShopId());
            if (shop == null || shop.getShopStatus() != 1) {
                throw new BusinessException(ResultCode.ERROR, "店铺不存在或未营业: " + shopOrder.getShopName());
            }

            if ((shop.getWxQrcode() == null || shop.getWxQrcode().isEmpty()) &&
                (shop.getAliQrcode() == null || shop.getAliQrcode().isEmpty())) {
                throw new BusinessException(ResultCode.ERROR, "店铺 " + shop.getShopName() + " 未设置收款码");
            }

            UserAddress address = userAddressMapper.selectOne(new LambdaQueryWrapper<UserAddress>()
                    .eq(UserAddress::getAddressId, dto.getAddressId())
                    .eq(UserAddress::getUserId, userId)
                    .eq(UserAddress::getIsDeleted, 0));
            if (address == null) {
                throw new BusinessException(ResultCode.ERROR, "收货地址不存在");
            }

            String orderNo = IdUtil.getSnowflakeNextIdStr();
            BigDecimal productAmount = BigDecimal.ZERO;
            List<OrderItem> itemList = new ArrayList<>();

            for (BatchOrderCreateDTO.OrderItemDTO itemDTO : shopOrder.getItemList()) {
                ProductInfo product = productInfoMapper.selectById(itemDTO.getProductId());
                if (product == null || product.getProductStatus() != 1 || !product.getShopId().equals(shopOrder.getShopId())) {
                    throw new BusinessException(ResultCode.ERROR, "商品不存在或已下架");
                }

                BigDecimal price = product.getPrice();
                if (itemDTO.getSpecId() != null) {
                    ProductSpec spec = productSpecMapper.selectById(itemDTO.getSpecId());
                    if (spec != null && spec.getProductId().equals(product.getProductId())) {
                        price = spec.getSpecPrice();
                        spec.setStock(spec.getStock() - itemDTO.getProductNum());
                        productSpecMapper.updateById(spec);
                    }
                }

                BigDecimal totalPrice = price.multiply(BigDecimal.valueOf(itemDTO.getProductNum()));
                productAmount = productAmount.add(totalPrice);

                OrderItem orderItem = new OrderItem();
                orderItem.setOrderNo(orderNo);
                orderItem.setProductId(product.getProductId());
                orderItem.setProductName(product.getProductName());
                orderItem.setProductImage(product.getProductImage());
                orderItem.setSpecId(itemDTO.getSpecId());
                orderItem.setProductPrice(price);
                orderItem.setProductNum(itemDTO.getProductNum());
                orderItem.setTotalPrice(totalPrice);
                itemList.add(orderItem);
            }

            if (productAmount.compareTo(shop.getMinOrderAmount()) < 0) {
                throw new BusinessException(ResultCode.ERROR, shop.getShopName() + " 未达到起送金额");
            }

            BigDecimal deliveryFee = shop.getDeliveryFee() != null ? shop.getDeliveryFee() : BigDecimal.ZERO;
            BigDecimal totalAmount = productAmount.add(deliveryFee);

            OrderInfo order = new OrderInfo();
            order.setOrderNo(orderNo);
            order.setUserId(userId);
            order.setShopId(shop.getShopId());
            order.setReceiverName(address.getReceiverName());
            order.setReceiverPhone(address.getReceiverPhone());
            order.setReceiverAddress(address.getCampusArea() + address.getAddressDetail());
            order.setProductAmount(productAmount);
            order.setDeliveryFee(deliveryFee);
            order.setTotalAmount(totalAmount);
            order.setPayAmount(totalAmount);
            order.setOrderStatus(0);
            order.setPayStatus(0);
            order.setPayType("wx".equals(shopOrder.getPayType()) ? 1 : 2);
            order.setOrderRemark(shopOrder.getOrderRemark());
            order.setExpireTime(LocalDateTime.now().plusMinutes(15));
            orderInfoMapper.insert(order);

            for (OrderItem item : itemList) {
                item.setOrderId(order.getOrderId());
            }
            orderItemMapper.batchInsert(itemList);

            saveOrderStatusLog(order.getOrderId(), orderNo, null, 0, "用户下单", userId, sysUserMapper.selectById(userId).getUserName());

            ShopPaymentDTO paymentDTO = new ShopPaymentDTO();
            paymentDTO.setShopId(shop.getShopId());
            paymentDTO.setShopName(shop.getShopName());
            paymentDTO.setOrderId(order.getOrderId());
            paymentDTO.setOrderNo(orderNo);
            paymentDTO.setPayAmount(totalAmount);
            paymentDTO.setPayType("wx".equals(shopOrder.getPayType()) ? 1 : 2);
            paymentDTO.setWxQrcode(shop.getWxQrcode());
            paymentDTO.setAliQrcode(shop.getAliQrcode());
            paymentList.add(paymentDTO);
        }
        } catch (Exception e) {
            log.error("createBatchOrder error", e);
            throw e;
        }

        return paymentList;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelOrder(Long orderId, Long userId) {
        OrderInfo order = orderInfoMapper.selectById(orderId);
        checkOrderOwner(order, userId);

        // 仅待支付订单可取消
        if (order.getOrderStatus() != 0) {
            throw new BusinessException(ResultCode.ORDER_STATUS_ERROR, "仅待支付订单可取消");
        }

        // 更新订单状态
        order.setOrderStatus(6);
        order.setCancelTime(LocalDateTime.now());
        order.setCancelReason("用户主动取消");
        orderInfoMapper.updateById(order);

        // 记录日志
        SysUser user = sysUserMapper.selectById(userId);
        saveOrderStatusLog(orderId, order.getOrderNo(), 0, 6, "用户取消订单", userId, user.getUserName());

        // 回滚库存
        rollbackStock(orderId);
    }

    @Override
    public IPage<OrderInfo> getStudentOrderList(Long userId, Integer status, String keyword, Integer page, Integer size) {
        Page<OrderInfo> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<OrderInfo> wrapper = new LambdaQueryWrapper<OrderInfo>()
                .eq(OrderInfo::getUserId, userId)
                .eq(OrderInfo::getIsDeleted, 0)
                .orderByDesc(OrderInfo::getCreateTime);
        if (status != null) {
            wrapper.eq(OrderInfo::getOrderStatus, status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.like(OrderInfo::getOrderNo, keyword);
        }
        IPage<OrderInfo> result = orderInfoMapper.selectPage(pageParam, wrapper);
        
        for (OrderInfo order : result.getRecords()) {
            LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
            itemWrapper.eq(OrderItem::getOrderId, order.getOrderId())
                       .eq(OrderItem::getIsDeleted, 0);
            List<OrderItem> items = orderItemMapper.selectList(itemWrapper);
            order.setItemList(items);
        }
        
        return result;
    }

    @Override
    public OrderInfo getOrderDetail(Long orderId, Long userId) {
        OrderInfo order = orderInfoMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(ResultCode.ERROR, "订单不存在");
        }
        
        // 校验订单归属
        if (!order.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.ERROR, "无权查看该订单");
        }
        
        // 查询订单项
        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getOrderId, orderId)
                   .eq(OrderItem::getIsDeleted, 0);
        List<OrderItem> items = orderItemMapper.selectList(itemWrapper);
        order.setItemList(items);
        
        return order;
    }

    @Override
    public IPage<OrderInfo> getMerchantOrderList(Long shopId, Integer status, Integer page, Integer size) {
        Page<OrderInfo> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<OrderInfo> wrapper = new LambdaQueryWrapper<OrderInfo>()
                .eq(OrderInfo::getShopId, shopId)
                .eq(OrderInfo::getIsDeleted, 0)
                .orderByDesc(OrderInfo::getCreateTime);
        if (status != null) {
            wrapper.eq(OrderInfo::getOrderStatus, status);
        }
        IPage<OrderInfo> result = orderInfoMapper.selectPage(pageParam, wrapper);
        
        for (OrderInfo order : result.getRecords()) {
            LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
            itemWrapper.eq(OrderItem::getOrderId, order.getOrderId())
                       .eq(OrderItem::getIsDeleted, 0);
            List<OrderItem> items = orderItemMapper.selectList(itemWrapper);
            order.setItemList(items);
        }
        
        return result;
    }

    @Override
    public IPage<AdminOrderVO> getAdminOrderList(Integer status, String keyword, Integer page, Integer size) {
        Page<AdminOrderVO> pageParam = new Page<>(page, size);
        return orderInfoMapper.selectAdminOrderPage(pageParam, status, keyword);
    }

    @Override
    public AdminOrderDetailVO getAdminOrderDetail(Long orderId) {
        OrderInfo order = orderInfoMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "订单不存在");
        }
        
        // 查询用户信息
        SysUser user = sysUserMapper.selectById(order.getUserId());
        
        // 查询店铺信息
        ShopInfo shop = shopInfoMapper.selectById(order.getShopId());
        
        // 查询订单项
        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> items = orderItemMapper.selectList(itemWrapper);
        
        // 查询订单状态日志
        LambdaQueryWrapper<OrderStatusLog> logWrapper = new LambdaQueryWrapper<>();
        logWrapper.eq(OrderStatusLog::getOrderId, orderId)
                  .orderByDesc(OrderStatusLog::getOperationTime);
        List<OrderStatusLog> logs = orderStatusLogMapper.selectList(logWrapper);
        
        // 构建详情 VO
        AdminOrderDetailVO detail = new AdminOrderDetailVO();
        detail.setOrderId(order.getOrderId());
        detail.setOrderNo(order.getOrderNo());
        detail.setUserId(order.getUserId());
        detail.setShopId(order.getShopId());
        detail.setReceiverName(order.getReceiverName());
        detail.setReceiverPhone(order.getReceiverPhone());
        detail.setReceiverAddress(order.getReceiverAddress());
        detail.setTotalAmount(order.getTotalAmount());
        detail.setProductAmount(order.getProductAmount());
        detail.setDeliveryFee(order.getDeliveryFee());
        detail.setDiscountAmount(order.getDiscountAmount());
        detail.setPayAmount(order.getPayAmount());
        detail.setPayType(order.getPayType());
        detail.setOrderStatus(order.getOrderStatus());
        detail.setPayStatus(order.getPayStatus());
        detail.setOrderRemark(order.getOrderRemark());
        detail.setPayTime(order.getPayTime());
        detail.setAcceptTime(order.getAcceptTime());
        detail.setDeliveryTime(order.getDeliveryTime());
        detail.setFinishTime(order.getFinishTime());
        detail.setCreateTime(order.getCreateTime());
        
        // 设置用户编号和手机号
        if (user != null) {
            detail.setUserNo(user.getUserNo());
            detail.setUserPhone(user.getPhone());
        }
        
        // 设置店铺名
        if (shop != null) {
            detail.setShopName(shop.getShopName());
        }
        
        // 转换订单项
        List<OrderItemVO> itemVOList = items.stream().map(item -> {
            OrderItemVO vo = new OrderItemVO();
            vo.setOrderItemId(item.getItemId());
            vo.setProductId(item.getProductId());
            vo.setProductName(item.getProductName());
            vo.setProductImage(item.getProductImage());
            vo.setSpecName(item.getSpecName());
            vo.setPrice(item.getProductPrice());
            vo.setQuantity(item.getProductNum());
            vo.setSubTotal(item.getTotalPrice());
            return vo;
        }).collect(Collectors.toList());
        detail.setItems(itemVOList);
        
        // 转换状态日志
        List<OrderStatusLogVO> logVOList = logs.stream().map(log -> {
            OrderStatusLogVO vo = new OrderStatusLogVO();
            vo.setId(log.getLogId());
            vo.setOrderId(log.getOrderId());
            vo.setOrderNo(log.getOrderNo());
            vo.setBeforeStatus(log.getPreStatus());
            vo.setAfterStatus(log.getCurrentStatus());
            vo.setDescription(log.getOperationRemark());
            vo.setOperatorId(log.getOperationUserId());
            vo.setOperatorName(log.getOperationUserName());
            vo.setCreateTime(log.getOperationTime());
            return vo;
        }).collect(Collectors.toList());
        detail.setStatusLogs(logVOList);
        
        return detail;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void acceptOrder(Long orderId, Long merchantUserId) {
        OrderInfo order = orderInfoMapper.selectById(orderId);
        checkMerchantOrderOwner(order, merchantUserId);

        // 仅待接单订单可接单
        if (order.getOrderStatus() != 1) {
            throw new BusinessException(ResultCode.ORDER_STATUS_ERROR, "仅待接单订单可操作");
        }

        // 更新订单状态
        order.setOrderStatus(2);
        order.setAcceptTime(LocalDateTime.now());
        orderInfoMapper.updateById(order);

        // 记录日志
        SysUser user = sysUserMapper.selectById(merchantUserId);
        saveOrderStatusLog(orderId, order.getOrderNo(), 1, 2, "商家接单", merchantUserId, user.getUserName());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rejectOrder(Long orderId, String rejectReason, Long merchantUserId) {
        OrderInfo order = orderInfoMapper.selectById(orderId);
        checkMerchantOrderOwner(order, merchantUserId);

        // 仅待接单订单可拒单
        if (order.getOrderStatus() != 1) {
            throw new BusinessException(ResultCode.ORDER_STATUS_ERROR, "仅待接单订单可操作");
        }

        // 更新订单状态
        order.setOrderStatus(6);
        order.setCancelTime(LocalDateTime.now());
        order.setCancelReason(rejectReason);
        orderInfoMapper.updateById(order);

        // 记录日志
        SysUser user = sysUserMapper.selectById(merchantUserId);
        saveOrderStatusLog(orderId, order.getOrderNo(), 1, 6, "商家拒单", merchantUserId, user.getUserName());

        // 回滚库存+触发退款
        rollbackStock(orderId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateOrderStatus(Long orderId, Integer status, Long operationUserId, String operationUserName) {
        OrderInfo order = orderInfoMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }

        Integer preStatus = order.getOrderStatus();
        order.setOrderStatus(status);

        // 状态流转特殊处理
        switch (status) {
            case 3:
                order.setDeliveryTime(LocalDateTime.now());
                break;
            case 5:
                order.setFinishTime(LocalDateTime.now());
                break;
        }
        orderInfoMapper.updateById(order);

        // 记录日志
        saveOrderStatusLog(orderId, order.getOrderNo(), preStatus, status, "订单状态更新", operationUserId, operationUserName);
    }

    // 私有方法：校验订单归属
    private void checkOrderOwner(OrderInfo order, Long userId) {
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        if (!order.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.FORBIDDEN, "无权操作该订单");
        }
    }

    // 私有方法：校验商家订单归属
    private void checkMerchantOrderOwner(OrderInfo order, Long merchantUserId) {
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        ShopInfo shop = shopInfoMapper.selectById(order.getShopId());
        if (!shop.getMerchantUserId().equals(merchantUserId)) {
            throw new BusinessException(ResultCode.FORBIDDEN, "无权操作该订单");
        }
    }

    // 私有方法：保存订单状态日志
    private void saveOrderStatusLog(Long orderId, String orderNo, Integer preStatus, Integer currentStatus,
                                    String operationType, Long operationUserId, String operationUserName) {
        OrderStatusLog log = new OrderStatusLog();
        log.setOrderId(orderId);
        log.setOrderNo(orderNo);
        log.setPreStatus(preStatus);
        log.setCurrentStatus(currentStatus);
        log.setOperationType(operationType);
        log.setOperationUserId(operationUserId);
        log.setOperationUserName(operationUserName);
        orderStatusLogMapper.insert(log);
    }

    // 私有方法：回滚库存
    private void rollbackStock(Long orderId) {
        List<OrderItem> itemList = orderItemMapper.selectList(new LambdaQueryWrapper<OrderItem>()
                .eq(OrderItem::getOrderId, orderId)
                .eq(OrderItem::getIsDeleted, 0));
        for (OrderItem item : itemList) {
            if (item.getSpecId() != null) {
                ProductSpec spec = productSpecMapper.selectById(item.getSpecId());
                spec.setStock(spec.getStock() + item.getProductNum());
                productSpecMapper.updateById(spec);
            }
        }
    }

    @Override
    public Object getShopStatistics(Long shopId) {
        LocalDateTime todayStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        LocalDateTime monthStart = LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0).withNano(0);
        
        LambdaQueryWrapper<OrderInfo> todayWrapper = new LambdaQueryWrapper<>();
        todayWrapper.eq(OrderInfo::getShopId, shopId)
                    .eq(OrderInfo::getIsDeleted, 0)
                    .in(OrderInfo::getOrderStatus, 1, 2, 3, 4, 5)
                    .ge(OrderInfo::getCreateTime, todayStart);
        Long todayOrders = orderInfoMapper.selectCount(todayWrapper);
        
        LambdaQueryWrapper<OrderInfo> todayRevenueWrapper = new LambdaQueryWrapper<>();
        todayRevenueWrapper.eq(OrderInfo::getShopId, shopId)
                    .eq(OrderInfo::getIsDeleted, 0)
                    .in(OrderInfo::getOrderStatus, 1, 2, 3, 4, 5)
                    .ge(OrderInfo::getCreateTime, todayStart);
        List<OrderInfo> todayOrderList = orderInfoMapper.selectList(todayRevenueWrapper);
        BigDecimal todayRevenue = todayOrderList.stream()
                .map(OrderInfo::getPayAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        LambdaQueryWrapper<OrderInfo> monthWrapper = new LambdaQueryWrapper<>();
        monthWrapper.eq(OrderInfo::getShopId, shopId)
                    .eq(OrderInfo::getIsDeleted, 0)
                    .in(OrderInfo::getOrderStatus, 1, 2, 3, 4, 5)
                    .ge(OrderInfo::getCreateTime, monthStart);
        Long monthOrders = orderInfoMapper.selectCount(monthWrapper);
        
        LambdaQueryWrapper<OrderInfo> monthRevenueWrapper = new LambdaQueryWrapper<>();
        monthRevenueWrapper.eq(OrderInfo::getShopId, shopId)
                    .eq(OrderInfo::getIsDeleted, 0)
                    .in(OrderInfo::getOrderStatus, 1, 2, 3, 4, 5)
                    .ge(OrderInfo::getCreateTime, monthStart);
        List<OrderInfo> monthOrderList = orderInfoMapper.selectList(monthRevenueWrapper);
        BigDecimal monthRevenue = monthOrderList.stream()
                .map(OrderInfo::getPayAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        Map<String, Object> result = new java.util.HashMap<>();
        result.put("todayOrders", todayOrders);
        result.put("todayRevenue", todayRevenue);
        result.put("monthOrders", monthOrders);
        result.put("monthRevenue", monthRevenue);
        return result;
    }
}
