package com.campus.ordering.task;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.campus.ordering.entity.OrderInfo;
import com.campus.ordering.entity.OrderItem;
import com.campus.ordering.entity.OrderStatusLog;
import com.campus.ordering.entity.ProductSpec;
import com.campus.ordering.mapper.OrderInfoMapper;
import com.campus.ordering.mapper.OrderItemMapper;
import com.campus.ordering.mapper.OrderStatusLogMapper;
import com.campus.ordering.mapper.ProductSpecMapper;
import com.campus.ordering.service.OrderWebSocketService;
import com.campus.ordering.service.SysConfigService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Component
public class OrderTimeoutTask {

    @Resource
    private OrderInfoMapper orderInfoMapper;

    @Resource
    private OrderItemMapper orderItemMapper;

    @Resource
    private OrderStatusLogMapper orderStatusLogMapper;

    @Resource
    private ProductSpecMapper productSpecMapper;

    @Resource
    private OrderWebSocketService orderWebSocketService;

    @Resource
    private SysConfigService sysConfigService;

    @Scheduled(fixedDelay = 60000)
    @Transactional(rollbackFor = Exception.class)
    public void checkTimeoutOrders() {
        log.debug("开始检查超时订单...");
        
        try {
            int expireMinutes = getOrderExpireMinutes();
            LocalDateTime expireTime = LocalDateTime.now().minusMinutes(expireMinutes);

            LambdaQueryWrapper<OrderInfo> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(OrderInfo::getOrderStatus, 0)
                   .eq(OrderInfo::getIsDeleted, 0)
                   .lt(OrderInfo::getCreateTime, expireTime);

            List<OrderInfo> timeoutOrders = orderInfoMapper.selectList(wrapper);

            if (timeoutOrders.isEmpty()) {
                log.debug("没有发现超时订单");
                return;
            }

            log.info("发现{}个超时订单需要处理", timeoutOrders.size());

            for (OrderInfo order : timeoutOrders) {
                try {
                    processTimeoutOrder(order);
                    log.info("超时订单处理完成，orderId: {}, orderNo: {}", order.getOrderId(), order.getOrderNo());
                } catch (Exception e) {
                    log.error("处理超时订单失败，orderId: {}", order.getOrderId(), e);
                }
            }

        } catch (Exception e) {
            log.error("检查超时订单异常", e);
        }
    }

    private void processTimeoutOrder(OrderInfo order) {
        order.setOrderStatus(6);
        order.setCancelTime(LocalDateTime.now());
        order.setCancelReason("订单支付超时，系统自动取消");
        orderInfoMapper.updateById(order);

        OrderStatusLog statusLog = new OrderStatusLog();
        statusLog.setOrderId(order.getOrderId());
        statusLog.setOrderNo(order.getOrderNo());
        statusLog.setPreStatus(0);
        statusLog.setCurrentStatus(6);
        statusLog.setOperationType("系统自动取消订单");
        statusLog.setOperationRemark("订单支付超时，系统自动取消");
        statusLog.setOperationUserId(0L);
        statusLog.setOperationUserName("系统");
        orderStatusLogMapper.insert(statusLog);

        rollbackStock(order.getOrderId());

        orderWebSocketService.pushOrderNotification(
                order.getUserId(),
                "订单已取消",
                String.format("订单 %s 因支付超时已自动取消", order.getOrderNo()),
                null
        );
    }

    private void rollbackStock(Long orderId) {
        List<OrderItem> itemList = orderItemMapper.selectList(new LambdaQueryWrapper<OrderItem>()
                .eq(OrderItem::getOrderId, orderId)
                .eq(OrderItem::getIsDeleted, 0));
        for (OrderItem item : itemList) {
            if (item.getSpecId() != null) {
                ProductSpec spec = productSpecMapper.selectById(item.getSpecId());
                if (spec != null) {
                    spec.setStock(spec.getStock() + item.getProductNum());
                    productSpecMapper.updateById(spec);
                }
            }
        }
    }

    private int getOrderExpireMinutes() {
        try {
            String value = sysConfigService.getConfigValue("order_pay_expire_minutes", "30");
            return Integer.parseInt(value);
        } catch (Exception e) {
            log.warn("读取订单支付过期时间配置失败，使用默认值30分钟", e);
            return 30;
        }
    }
}
