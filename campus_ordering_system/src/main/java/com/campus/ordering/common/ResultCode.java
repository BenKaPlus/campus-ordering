package com.campus.ordering.common;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ResultCode {
    SUCCESS(200, "操作成功"),
    ERROR(500, "操作失败"),
    UNAUTHORIZED(401, "未登录或令牌已过期"),
    FORBIDDEN(403, "权限不足"),
    NOT_FOUND(404, "资源不存在"),
    PARAM_ERROR(400, "参数错误"),
    USER_NOT_FOUND(1001, "用户不存在"),
    PASSWORD_ERROR(1002, "密码错误"),
    USER_DISABLED(1003, "账号已被禁用"),
    ORDER_NOT_FOUND(4001, "订单不存在"),
    ORDER_STATUS_ERROR(4002, "订单状态错误"),
    PAY_ERROR(5001, "支付失败"),
    REFUND_ERROR(5002, "退款失败");

    private final Integer code;
    private final String msg;
}