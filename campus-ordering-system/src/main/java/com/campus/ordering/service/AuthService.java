package com.campus.ordering.service;

import com.campus.ordering.dto.LoginDTO;
import com.campus.ordering.dto.MerchantApplyDTO;
import com.campus.ordering.dto.StudentRegisterDTO;
import com.campus.ordering.vo.LoginVO;

public interface AuthService {
    /**
     * 账号密码登录
     */
    LoginVO login(LoginDTO loginDTO);

    /**
     * 退出登录
     */
    void logout(Long userId);

    /**
     * 学生注册
     */
    void studentRegister(StudentRegisterDTO registerDTO);

    /**
     * 商家入驻申请
     */
    void merchantApply(MerchantApplyDTO applyDTO);
}