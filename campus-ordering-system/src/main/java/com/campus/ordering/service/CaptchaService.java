package com.campus.ordering.service;

import java.util.Map;

public interface CaptchaService {
    /**
     * 生成图形验证码
     * @return 包含验证码图片 Base64 和验证码 key 的 Map
     */
    Map<String, Object> generateCaptcha();
}
