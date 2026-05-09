package com.campus.ordering.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.campus.ordering.dto.OrderCreateDTO;
import com.campus.ordering.entity.OrderInfo;
import com.campus.ordering.vo.AdminOrderDetailVO;
import com.campus.ordering.vo.AdminOrderVO;

public interface OrderService {
    /**
     * 获取结算信息
     */
    Object getSettleInfo(java.util.List<Long> cartIds, Long userId);

    /**
     * 创建订单
     */
    String createOrder(OrderCreateDTO dto, Long userId);

    /**
     * 取消订单
     */
    void cancelOrder(Long orderId, Long userId);

    /**
     * 学生端获取订单列表
     */
    IPage<OrderInfo> getStudentOrderList(Long userId, Integer status, String keyword, Integer page, Integer size);

    /**
     * 获取订单详情
     */
    OrderInfo getOrderDetail(Long orderId, Long userId);

    /**
     * 商家端获取订单列表
     */
    IPage<OrderInfo> getMerchantOrderList(Long shopId, Integer status, Integer page, Integer size);

    /**
     * 商家接单
     */
    void acceptOrder(Long orderId, Long merchantUserId);

    /**
     * 商家拒单
     */
    void rejectOrder(Long orderId, String rejectReason, Long merchantUserId);

    /**
     * 更新订单状态
     */
    void updateOrderStatus(Long orderId, Integer status, Long operationUserId, String operationUserName);

    /**
     * 管理员端获取订单列表
     */
    IPage<AdminOrderVO> getAdminOrderList(Integer status, String keyword, Integer page, Integer size);

    /**
     * 管理员端获取订单详情
     */
    AdminOrderDetailVO getAdminOrderDetail(Long orderId);

    /**
     * 获取店铺统计数据
     */
    Object getShopStatistics(Long shopId);
}