package com.campus.ordering.service;

import com.campus.ordering.entity.PaymentInfo;
import java.util.Map;

public interface PayService {
    /**
     * 生成微信支付参数
     */
    Map<String, Object> createWxPay(String orderNo, Long userId);

    /**
     * 生成支付宝支付参数
     */
    String createAliPay(String orderNo, Long userId);

    /**
     * 微信支付回调处理
     */
    String wxPayCallback(String notifyData);

    /**
     * 支付宝支付回调处理
     */
    String aliPayCallback(Map<String, String> params);

    /**
     * 根据订单号查询支付记录
     */
    PaymentInfo getPaymentByOrderNo(String orderNo);
}