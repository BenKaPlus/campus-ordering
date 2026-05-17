package com.campus.ordering.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Slf4j
@Service
public class OrderWebSocketService {

    @Resource
    private SimpMessagingTemplate messagingTemplate;

    private static final String ORDER_TOPIC_PREFIX = "/topic/order/";

    public void pushOrderNotification(Long userId, String title, String content, Object data) {
        if (userId == null) {
            log.warn("pushOrderNotification called with null userId, skipping");
            return;
        }

        String destination = ORDER_TOPIC_PREFIX + userId;

        String message = buildMessage(title, content, data);

        try {
            messagingTemplate.convertAndSend(destination, message);
            log.info("WebSocket消息推送成功 - userId: {}, title: {}", userId, title);
        } catch (Exception e) {
            log.error("WebSocket消息推送失败 - userId: {}, error: {}", userId, e.getMessage());
        }
    }

    public void pushNewOrderToMerchant(Long merchantUserId, Long orderId, String orderNo, String shopName, String totalAmount) {
        String title = "新订单";
        String content = String.format("您有新订单：%s，金额：%s元", orderNo, totalAmount);
        Object data = new OrderNotificationData(orderId, orderNo, shopName, totalAmount, "NEW_ORDER");
        pushOrderNotification(merchantUserId, title, content, data);
    }

    public void pushOrderStatusChangeToStudent(Long studentUserId, Long orderId, String orderNo, Integer newStatus, String statusText) {
        String title = "订单状态更新";
        String content = String.format("订单 %s 状态已更新为：%s", orderNo, statusText);
        Object data = new OrderNotificationData(orderId, orderNo, null, null, "STATUS_CHANGE", newStatus, statusText);
        pushOrderNotification(studentUserId, title, content, data);
    }

    public void pushOrderAcceptedToStudent(Long studentUserId, Long orderId, String orderNo) {
        String title = "商家已接单";
        String content = String.format("订单 %s 已由商家接单，备餐中", orderNo);
        Object data = new OrderNotificationData(orderId, orderNo, null, null, "ORDER_ACCEPTED");
        pushOrderNotification(studentUserId, title, content, data);
    }

    public void pushOrderRejectedToStudent(Long studentUserId, Long orderId, String orderNo, String reason) {
        String title = "订单被拒";
        String content = String.format("订单 %s 已被商家拒绝，原因：%s", orderNo, reason);
        Object data = new OrderNotificationData(orderId, orderNo, null, null, "ORDER_REJECTED", null, reason);
        pushOrderNotification(studentUserId, title, content, data);
    }

    public void pushOrderCancelledToStudent(Long studentUserId, Long orderId, String orderNo, String reason) {
        String title = "订单已取消";
        String content = String.format("订单 %s 已取消，原因：%s", orderNo, reason);
        Object data = new OrderNotificationData(orderId, orderNo, null, null, "ORDER_CANCELLED");
        pushOrderNotification(studentUserId, title, content, data);
    }

    public void pushOrderFinishedToStudent(Long studentUserId, Long orderId, String orderNo) {
        String title = "订单已完成";
        String content = String.format("订单 %s 已完成，感谢您的使用！", orderNo);
        Object data = new OrderNotificationData(orderId, orderNo, null, null, "ORDER_FINISHED");
        pushOrderNotification(studentUserId, title, content, data);
    }

    public void pushRefundToStudent(Long studentUserId, Long orderId, String orderNo, String refundAmount) {
        String title = "退款到账";
        String content = String.format("订单 %s 退款已到账：%s元", orderNo, refundAmount);
        Object data = new OrderNotificationData(orderId, orderNo, null, refundAmount, "REFUND");
        pushOrderNotification(studentUserId, title, content, data);
    }

    private String buildMessage(String title, String content, Object data) {
        java.util.HashMap<String, Object> message = new java.util.HashMap<>();
        message.put("title", title);
        message.put("content", content);
        message.put("data", data);
        message.put("timestamp", System.currentTimeMillis());
        return com.alibaba.fastjson.JSON.toJSONString(message);
    }

    public static class OrderNotificationData {
        private Long orderId;
        private String orderNo;
        private String shopName;
        private String amount;
        private String type;
        private Integer status;
        private String statusText;
        private String extra;

        public OrderNotificationData() {}

        public OrderNotificationData(Long orderId, String orderNo, String shopName, String amount, String type) {
            this.orderId = orderId;
            this.orderNo = orderNo;
            this.shopName = shopName;
            this.amount = amount;
            this.type = type;
        }

        public OrderNotificationData(Long orderId, String orderNo, String shopName, String amount, String type, Integer status, String statusText) {
            this.orderId = orderId;
            this.orderNo = orderNo;
            this.shopName = shopName;
            this.amount = amount;
            this.type = type;
            this.status = status;
            this.statusText = statusText;
        }

        public Long getOrderId() { return orderId; }
        public void setOrderId(Long orderId) { this.orderId = orderId; }
        public String getOrderNo() { return orderNo; }
        public void setOrderNo(String orderNo) { this.orderNo = orderNo; }
        public String getShopName() { return shopName; }
        public void setShopName(String shopName) { this.shopName = shopName; }
        public String getAmount() { return amount; }
        public void setAmount(String amount) { this.amount = amount; }
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        public Integer getStatus() { return status; }
        public void setStatus(Integer status) { this.status = status; }
        public String getStatusText() { return statusText; }
        public void setStatusText(String statusText) { this.statusText = statusText; }
        public String getExtra() { return extra; }
        public void setExtra(String extra) { this.extra = extra; }
    }
}