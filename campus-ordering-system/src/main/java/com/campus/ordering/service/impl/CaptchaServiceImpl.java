package com.campus.ordering.service.impl;

import cn.hutool.core.util.IdUtil;
import cn.hutool.captcha.CaptchaUtil;
import cn.hutool.captcha.LineCaptcha;
import com.campus.ordering.service.CaptchaService;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
public class CaptchaServiceImpl implements CaptchaService {

    @Resource
    private RedisTemplate<String, String> redisTemplate;

    private static final String CAPTCHA_KEY_PREFIX = "captcha:";
    private static final String SMS_CODE_KEY_PREFIX = "sms:";
    private static final long CAPTCHA_EXPIRE_MINUTES = 5;
    private static final long SMS_CODE_EXPIRE_MINUTES = 5;

    @Override
    public Map<String, Object> generateCaptcha() {
        // 定义图形验证码的长、宽、验证码字符数、干扰线个数
        LineCaptcha captcha = CaptchaUtil.createLineCaptcha(130, 48, 4, 10);

        // 生成验证码文本
        String code = captcha.getCode();

        // 生成验证码图片的 Base64
        String imageBase64 = captcha.getImageBase64();

        // 生成唯一的验证码 key
        String captchaKey = IdUtil.fastSimpleUUID();

        // 将验证码存储到 Redis
        redisTemplate.opsForValue().set(
                CAPTCHA_KEY_PREFIX + captchaKey,
                code.toLowerCase(),
                CAPTCHA_EXPIRE_MINUTES,
                TimeUnit.MINUTES
        );

        // 返回结果
        Map<String, Object> result = new HashMap<>();
        result.put("captchaKey", captchaKey);
        result.put("captchaImage", imageBase64);

        return result;
    }

    /**
     * 验证验证码
     * @param captchaKey 验证码 key
     * @param code 用户输入的验证码
     * @return 验证结果
     */
    public boolean validateCaptcha(String captchaKey, String code) {
        if (captchaKey == null || code == null) {
            return false;
        }

        String storedCode = redisTemplate.opsForValue().get(CAPTCHA_KEY_PREFIX + captchaKey);
        if (storedCode == null) {
            return false;
        }

        boolean result = storedCode.equalsIgnoreCase(code);
        if (result) {
            // 验证成功后删除验证码
            redisTemplate.delete(CAPTCHA_KEY_PREFIX + captchaKey);
        }
        return result;
    }

    @Override
    public String sendSmsCode(String phone) {
        // 生成6位数字验证码
        String code = String.format("%06d", (int) (Math.random() * 1000000));

        // 存储到 Redis，key 为手机号
        String key = SMS_CODE_KEY_PREFIX + phone;
        redisTemplate.opsForValue().set(key, code, SMS_CODE_EXPIRE_MINUTES, TimeUnit.MINUTES);

        // TODO: 实际项目中这里应该调用短信网关发送验证码
        // 现在暂时打印到控制台，方便测试
        System.out.println("【忘记密码】向手机 " + phone + " 发送的验证码是：" + code);

        return code;
    }

    @Override
    public boolean validateSmsCode(String phone, String code) {
        if (phone == null || code == null) {
            return false;
        }

        String key = SMS_CODE_KEY_PREFIX + phone;
        String storedCode = redisTemplate.opsForValue().get(key);
        if (storedCode == null) {
            return false;
        }

        boolean result = storedCode.equals(code);
        if (result) {
            // 验证成功后删除验证码
            redisTemplate.delete(key);
        }
        return result;
    }
}
