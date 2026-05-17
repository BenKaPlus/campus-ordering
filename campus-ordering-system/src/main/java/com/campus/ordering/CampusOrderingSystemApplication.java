package com.campus.ordering;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@MapperScan("com.campus.ordering.mapper")
@EnableScheduling
public class CampusOrderingSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(CampusOrderingSystemApplication.class, args);
        System.out.println("========================================");
        System.out.println("  校园点餐系统启动成功！");
        System.out.println("  接口地址：http://localhost:8080/api");
        System.out.println("  接口文档：http://localhost:8080/api/swagger-ui/index.html");
        System.out.println("  Druid监控：http://localhost:8080/api/druid");
        System.out.println("========================================");
    }
}