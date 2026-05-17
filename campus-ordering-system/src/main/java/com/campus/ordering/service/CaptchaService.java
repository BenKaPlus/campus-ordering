package com.campus.ordering.service;

import java.util.Map;

public interface CaptchaService {
    /**
     * 生成图形验证码
     * @return 包含验证码图片 Base64 和验证码 key 的 Map
     */
    Map<String, Object> generateCaptcha();

    /**
     * 验证图形验证码
     * @param captchaKey 验证码 key
     * @param code 用户输入的验证码
     * @return 验证结果
     */
    boolean validateCaptcha(String captchaKey, String code);

    /**
     * 发送手机验证码（用于忘记密码）
     * @param phone 手机号
     * @return 验证码key，用于后续验证
     */
    String sendSmsCode(String phone);

    /**
     * 验证手机验证码
     * @param phone 手机号
     * @param code 用户输入的验证码
     * @return 验证结果
     */
    boolean validateSmsCode(String phone, String code);
}
