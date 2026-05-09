package com.campus.ordering.service.impl;

import cn.hutool.core.util.IdUtil;
import com.alipay.api.AlipayApiException;
import com.alipay.api.internal.util.AlipaySignature;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.entity.PaymentInfo;
import com.campus.ordering.entity.OrderInfo;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.mapper.PaymentInfoMapper;
import com.campus.ordering.mapper.OrderInfoMapper;
import com.campus.ordering.service.PayService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
public class PayServiceImpl implements com.campus.ordering.service.PayService {

    private static final Logger logger = LoggerFactory.getLogger(PayServiceImpl.class);

    @Resource
    private PaymentInfoMapper paymentInfoMapper;

    @Resource
    private OrderInfoMapper orderInfoMapper;

    private static final String ALIPAY_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQE...";
    private static final String WX_PAY_SECRET = "your_wxpay_secret_key";

    @Override
    public Map<String, Object> createWxPay(String orderNo, Long userId) {
        if (orderNo == null || userId == null) {
            throw new BusinessException(ResultCode.ERROR, "订单号或用户 ID 不能为空");
        }

        OrderInfo order = orderInfoMapper.selectOne(new LambdaQueryWrapper<OrderInfo>()
                .eq(OrderInfo::getOrderNo, orderNo)
                .eq(OrderInfo::getUserId, userId)
                .eq(OrderInfo::getIsDeleted, 0));

        if (order == null) {
            throw new BusinessException(ResultCode.ERROR, "订单不存在");
        }

        if (order.getOrderStatus() != 0) {
            throw new BusinessException(ResultCode.ERROR, "订单状态异常，无法支付");
        }

        Map<String, Object> payParams = new HashMap<>();
        payParams.put("orderNo", orderNo);
        payParams.put("totalAmount", order.getActualAmount());
        payParams.put("subject", "校园点餐系统 - " + order.getShopName());
        payParams.put("body", "订单支付");
        payParams.put("tradeType", "JSAPI");
        payParams.put("openId", "user_openid");

        logger.info("创建微信支付订单：{}", orderNo);

        return payParams;
    }

    @Override
    public String createAliPay(String orderNo, Long userId) {
        if (orderNo == null || userId == null) {
            throw new BusinessException(ResultCode.ERROR, "订单号或用户 ID 不能为空");
        }

        OrderInfo order = orderInfoMapper.selectOne(new LambdaQueryWrapper<OrderInfo>()
                .eq(OrderInfo::getOrderNo, orderNo)
                .eq(OrderInfo::getUserId, userId)
                .eq(OrderInfo::getIsDeleted, 0));

        if (order == null) {
            throw new BusinessException(ResultCode.ERROR, "订单不存在");
        }

        if (order.getOrderStatus() != 0) {
            throw new BusinessException(ResultCode.ERROR, "订单状态异常，无法支付");
        }

        logger.info("创建支付宝支付订单：{}", orderNo);

        return "alipay_form_html_placeholder";
    }

    @Override
    public String wxPayCallback(String notifyData) {
        logger.info("微信支付回调通知：{}", notifyData);

        try {
            Map<String, String> resultMap = parseXml(notifyData);
            String returnCode = resultMap.get("return_code");
            String resultCode = resultMap.get("result_code");
            String outTradeNo = resultMap.get("out_trade_no");
            String transactionId = resultMap.get("transaction_id");

            if ("SUCCESS".equals(returnCode) && "SUCCESS".equals(resultCode)) {
                updatePaymentStatus(outTradeNo, transactionId, 1);
                return "<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>";
            }
        } catch (Exception e) {
            logger.error("微信支付回调处理失败", e);
            return "<xml><return_code><![CDATA[FAIL]]></return_code><return_msg><![CDATA[" + e.getMessage() + "]]></return_msg></xml>";
        }

        return "<xml><return_code><![CDATA[FAIL]]></return_code><return_msg><![CDATA[处理失败]]></return_msg></xml>";
    }

    @Override
    public String aliPayCallback(Map<String, String> params) {
        logger.info("支付宝支付回调通知：{}", params);

        try {
            boolean signVerified = AlipaySignature.rsaCheckV1(params, ALIPAY_PUBLIC_KEY, "UTF-8", "RSA2");

            if (signVerified) {
                String outTradeNo = params.get("out_trade_no");
                String tradeNo = params.get("trade_no");
                String tradeStatus = params.get("trade_status");

                if ("TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus)) {
                    updatePaymentStatus(outTradeNo, tradeNo, 1);
                    return "success";
                }
            } else {
                logger.warn("支付宝签名验证失败");
                return "fail";
            }
        } catch (AlipayApiException e) {
            logger.error("支付宝回调处理失败", e);
            return "fail";
        }

        return "fail";
    }

    @Override
    public PaymentInfo getPaymentByOrderNo(String orderNo) {
        if (orderNo == null) {
            throw new BusinessException(ResultCode.ERROR, "订单号不能为空");
        }

        return paymentInfoMapper.selectOne(new LambdaQueryWrapper<PaymentInfo>()
                .eq(PaymentInfo::getOutTradeNo, orderNo)
                .orderByDesc(PaymentInfo::getCreateTime)
                .last("LIMIT 1"));
    }

    private void updatePaymentStatus(String orderNo, String transactionId, Integer payStatus) {
        PaymentInfo paymentInfo = paymentInfoMapper.selectOne(new LambdaQueryWrapper<PaymentInfo>()
                .eq(PaymentInfo::getOutTradeNo, orderNo)
                .orderByDesc(PaymentInfo::getCreateTime)
                .last("LIMIT 1"));

        if (paymentInfo != null) {
            paymentInfo.setTransactionId(transactionId);
            paymentInfo.setPayStatus(payStatus);
            paymentInfo.setPayTime(LocalDateTime.now());
            paymentInfo.setUpdateTime(LocalDateTime.now());
            paymentInfoMapper.updateById(paymentInfo);

            if (payStatus == 1) {
                OrderInfo order = orderInfoMapper.selectOne(new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getOrderNo, orderNo));
                if (order != null) {
                    order.setOrderStatus(1);
                    order.setPayTime(LocalDateTime.now());
                    orderInfoMapper.updateById(order);
                }
            }
        }
    }

    private Map<String, String> parseXml(String xmlStr) throws Exception {
        Map<String, String> map = new HashMap<>();
        String[] lines = xmlStr.replace("<xml>", "").replace("</xml>", "").split(">");
        for (String line : lines) {
            if (line.contains("<")) {
                String[] parts = line.split("<");
                if (parts.length == 2 && !parts[1].trim().isEmpty()) {
                    map.put(parts[0].trim(), parts[1].trim());
                }
            }
        }
        return map;
    }
}
