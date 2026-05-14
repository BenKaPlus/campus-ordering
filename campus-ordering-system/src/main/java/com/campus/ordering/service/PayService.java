package com.campus.ordering.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
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

    /**
     * 学生端-查询自己的支付记录列表
     */
    IPage<PaymentInfo> getStudentPaymentList(Long userId, Integer payType, Integer page, Integer size);

    /**
     * 商家端-查询自己店铺的支付记录列表
     */
    IPage<PaymentInfo> getMerchantPaymentList(Long shopId, Integer payType, Integer page, Integer size);

    /**
     * 管理端-查询所有支付记录列表（支持多维度筛选）
     */
    IPage<PaymentInfo> getAdminPaymentList(Long userId, Long shopId, Integer payType, Integer page, Integer size);
}