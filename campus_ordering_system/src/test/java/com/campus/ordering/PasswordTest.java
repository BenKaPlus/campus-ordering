package com.campus.ordering;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

public class PasswordTest {
    public static void main(String[] args) {
        PasswordEncoder encoder = new BCryptPasswordEncoder();
        
        String rawPassword = "admin123";
        
        // 生成 5 个新的加密密码
        System.out.println("生成的 BCrypt 加密密码（admin123）：\n");
        for (int i = 0; i < 5; i++) {
            String encoded = encoder.encode(rawPassword);
            System.out.println((i + 1) + ". " + encoded);
            System.out.println("   长度：" + encoded.length());
            System.out.println("   验证：" + encoder.matches(rawPassword, encoded));
            System.out.println();
        }
    }
}
