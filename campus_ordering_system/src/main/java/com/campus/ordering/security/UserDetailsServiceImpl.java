package com.campus.ordering.security;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.campus.ordering.entity.SysRole;
import com.campus.ordering.entity.SysUser;
import com.campus.ordering.entity.SysUserRole;
import com.campus.ordering.mapper.SysRoleMapper;
import com.campus.ordering.mapper.SysUserMapper;
import com.campus.ordering.mapper.SysUserRoleMapper;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    @Resource
    private SysUserMapper sysUserMapper;

    @Resource
    private SysRoleMapper sysRoleMapper;

    @Resource
    private SysUserRoleMapper sysUserRoleMapper;

    @Override
    public UserDetails loadUserByUsername(String userNo) throws UsernameNotFoundException {
        // 根据用户编号查询用户
        SysUser user = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getUserNo, userNo)
                .eq(SysUser::getIsDeleted, 0));

        if (user == null) {
            throw new UsernameNotFoundException("用户不存在：" + userNo);
        }

        // 检查用户状态
        if (user.getStatus() != null && user.getStatus() != 1) {
            throw new UsernameNotFoundException("账号已被禁用：" + userNo);
        }

        // 查询用户角色
        List<SysUserRole> userRoles = sysUserRoleMapper.selectList(new LambdaQueryWrapper<SysUserRole>()
                .eq(SysUserRole::getUserId, user.getUserId())
                .eq(SysUserRole::getIsDeleted, 0));

        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        for (SysUserRole userRole : userRoles) {
            SysRole role = sysRoleMapper.selectById(userRole.getRoleId());
            if (role != null && role.getIsDeleted() == 0) {
                // 添加角色权限（格式：ROLE_XXX）
                authorities.add(new SimpleGrantedAuthority("ROLE_" + role.getRoleCode()));
            }
        }

        // 返回 Spring Security 的 User 对象
        return new User(
                user.getUserNo(),
                user.getPassword(),
                authorities
        );
    }
}
