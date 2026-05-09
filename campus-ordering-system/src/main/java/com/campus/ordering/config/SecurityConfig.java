package com.campus.ordering.config;

import com.campus.ordering.security.JwtAuthenticationEntryPoint;
import com.campus.ordering.security.JwtAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import javax.annotation.Resource;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true) // 开启方法级权限注解
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Resource
    private JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

    @Resource
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                // 关闭CSRF
                .csrf().disable()
                // 关闭Session
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                // 配置异常处理器
                .exceptionHandling().authenticationEntryPoint(jwtAuthenticationEntryPoint)
                .and()
                // 配置请求权限
                .authorizeRequests()
                // 公开接口（无需认证）
                .antMatchers(
                        "/auth/**", // 认证接口
                        "/common/**", // 公共接口
                        "/student/shop/**", // 学生端店铺查询
                        "/student/product/**", // 学生端商品查询
                        "/swagger-ui/**", // Swagger文档
                        "/swagger-resources/**",
                        "/v3/api-docs/**",
                        "/doc.html", // Knife4j文档
                        "/druid/**", // Druid监控
                        "/ws/**" // WebSocket
                ).permitAll()
                // 学生端接口（仅学生可访问）
                .antMatchers("/student/cart/**", "/student/order/**", "/student/info/**", "/student/address/**", "/student/message/**", "/student/feedback/**").hasRole("STUDENT")
                // 商家端接口（仅商家可访问）
                .antMatchers("/merchant/**").hasRole("MERCHANT")
                // 管理员端接口（仅管理员可访问）
                .antMatchers("/admin/**").hasRole("ADMIN")
                // 其他接口需认证
                .anyRequest().authenticated();

        // 添加JWT过滤器
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
    }
}