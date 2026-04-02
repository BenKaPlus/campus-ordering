package com.campus.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.entity.SysUser;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.mapper.SysUserMapper;
import com.campus.ordering.service.UserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

@Service
public class UserServiceImpl implements UserService {

    @Resource
    private SysUserMapper sysUserMapper;

    @Resource
    private PasswordEncoder passwordEncoder;

    @Override
    public IPage<SysUser> getUserList(String keyword, Integer userType, Integer page, Integer size) {
        Page<SysUser> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(SysUser::getUserNo, keyword)
                    .or()
                    .like(SysUser::getUserName, keyword));
        }
        if (userType != null) {
            wrapper.eq(SysUser::getUserType, userType);
        }
        wrapper.eq(SysUser::getIsDeleted, 0)
               .orderByDesc(SysUser::getCreateTime);
        return sysUserMapper.selectPage(pageParam, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateUserStatus(Long userId, Integer status) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(ResultCode.ERROR, "用户不存在");
        }
        user.setStatus(status);
        sysUserMapper.updateById(user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void resetPassword(Long userId) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(ResultCode.ERROR, "用户不存在");
        }
        // 重置为默认密码 123456
        user.setPassword(passwordEncoder.encode("123456"));
        sysUserMapper.updateById(user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateUser(SysUser user) {
        SysUser existUser = sysUserMapper.selectById(user.getUserId());
        if (existUser == null) {
            throw new BusinessException(ResultCode.ERROR, "用户不存在");
        }
        existUser.setUserName(user.getUserName());
        existUser.setPhone(user.getPhone());
        sysUserMapper.updateById(existUser);
    }
}
