package com.campus.ordering.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.campus.ordering.entity.SysUser;

public interface UserService {
    /**
     * 获取用户列表
     */
    IPage<SysUser> getUserList(String keyword, Integer userType, Integer page, Integer size);

    /**
     * 更新用户状态
     */
    void updateUserStatus(Long userId, Integer status);

    /**
     * 重置用户密码
     */
    void resetPassword(Long userId);

    /**
     * 更新用户信息
     */
    void updateUser(SysUser user);
}
