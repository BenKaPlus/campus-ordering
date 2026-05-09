package com.campus.ordering.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${system.file.upload-path}")
    private String uploadPath;

    @Value("${system.file.access-url}")
    private String accessUrl;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置文件访问路径映射
        String pathPattern = accessUrl.substring(accessUrl.lastIndexOf("/")) + "/**";
        String resourceLocation = "file:" + uploadPath + "/";
        registry.addResourceHandler(pathPattern)
                .addResourceLocations(resourceLocation);
    }
}