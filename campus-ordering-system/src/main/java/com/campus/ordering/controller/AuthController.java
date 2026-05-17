package com.campus.ordering.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.campus.ordering.common.Result;
import com.campus.ordering.dto.LoginDTO;
import com.campus.ordering.dto.MerchantApplyDTO;
import com.campus.ordering.dto.MerchantSettleDTO;
import com.campus.ordering.dto.PasswordUpdateDTO;
import com.campus.ordering.dto.StudentRegisterDTO;
import com.campus.ordering.dto.UserInfoUpdateDTO;
import com.campus.ordering.entity.MerchantApply;
import com.campus.ordering.entity.SysUser;
import com.campus.ordering.entity.SysUserRole;
import com.campus.ordering.entity.SysRole;
import com.campus.ordering.mapper.SysRoleMapper;
import com.campus.ordering.mapper.SysUserMapper;
import com.campus.ordering.mapper.SysUserRoleMapper;
import com.campus.ordering.security.JwtTokenUtil;
import com.campus.ordering.service.AuthService;
import com.campus.ordering.service.CaptchaService;
import com.campus.ordering.vo.LoginVO;
import com.campus.ordering.vo.UserInfoVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/auth")
@Api(tags = "认证接口")
public class AuthController {

    @Resource
    private AuthService authService;
    @Resource
    private JwtTokenUtil jwtTokenUtil;
    @Resource
    private CaptchaService captchaService;
    @Resource
    private SysUserMapper sysUserMapper;
    @Resource
    private SysUserRoleMapper sysUserRoleMapper;
    @Resource
    private SysRoleMapper sysRoleMapper;
    @Resource
    private com.campus.ordering.service.MerchantApplyService merchantApplyService;

    @PostMapping("/login")
    @ApiOperation("账号密码登录")
    public Result<LoginVO> login(@Valid @RequestBody LoginDTO loginDTO) {
        return Result.success(authService.login(loginDTO));
    }

    @PostMapping("/logout")
    @ApiOperation("退出登录")
    public Result<Void> logout(HttpServletRequest request) {
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
            try {
                Long userId = jwtTokenUtil.getClaimFromToken(token, claims -> claims.get("userId", Long.class));
                if (userId != null) {
                    authService.logout(userId);
                }
            } catch (Exception e) {
                // 令牌无效或过期，忽略错误
            }
        }
        return Result.success();
    }

    @GetMapping("/user/info")
    @ApiOperation("获取当前用户信息")
    @PreAuthorize("isAuthenticated()")
    public Result<UserInfoVO> getUserInfo(Principal principal) {
        String userNo = principal.getName();
        SysUser user = sysUserMapper.selectByUserNo(userNo);
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        UserInfoVO vo = new UserInfoVO();
        vo.setUserId(user.getUserId());
        vo.setUserNo(user.getUserNo());
        vo.setUserName(user.getUserName());
        vo.setPhone(user.getPhone());
        vo.setAvatar(user.getAvatar());
        vo.setStatus(user.getStatus());
        
        List<SysUserRole> userRoles = sysUserRoleMapper.selectList(new LambdaQueryWrapper<SysUserRole>()
                .eq(SysUserRole::getUserId, user.getUserId())
                .eq(SysUserRole::getIsDeleted, 0));
        
        List<String> roles = new ArrayList<>();
        for (SysUserRole userRole : userRoles) {
            SysRole role = sysRoleMapper.selectById(userRole.getRoleId());
            if (role != null && role.getIsDeleted() == 0) {
                roles.add(role.getRoleCode());
            }
        }
        vo.setRoles(roles);
        
        return Result.success(vo);
    }

    @GetMapping("/captcha")
    @ApiOperation("获取图形验证码")
    public Result<Map<String, Object>> getCaptcha() {
        return Result.success(captchaService.generateCaptcha());
    }

    @PostMapping("/register/student")
    @ApiOperation("学生注册")
    public Result<Void> studentRegister(@Valid @RequestBody StudentRegisterDTO registerDTO) {
        authService.studentRegister(registerDTO);
        return Result.success();
    }

    @PostMapping("/register/merchant")
    @ApiOperation("商家入驻申请")
    public Result<Void> merchantApply(@Valid @RequestBody MerchantApplyDTO applyDTO) {
        authService.merchantApply(applyDTO);
        return Result.success();
    }

    @PostMapping("/merchant/settle")
    @ApiOperation("商家入驻申请（已登录用户）")
    @PreAuthorize("isAuthenticated()")
    public Result<Void> merchantSettle(@Valid @RequestBody MerchantSettleDTO settleDTO) {
        authService.merchantSettle(settleDTO);
        return Result.success();
    }

    @GetMapping("/merchant/settle-status")
    @ApiOperation("获取商家入驻状态")
    @PreAuthorize("isAuthenticated()")
    public Result<Integer> getMerchantSettleStatus() {
        return Result.success(authService.getMerchantSettleStatus());
    }

    @GetMapping("/merchant/apply")
    @ApiOperation("获取当前用户的入驻申请")
    @PreAuthorize("isAuthenticated()")
    public Result<MerchantApply> getCurrentUserApply() {
        return Result.success(merchantApplyService.getCurrentUserApply());
    }

    @PutMapping("/merchant/apply")
    @ApiOperation("更新入驻申请信息")
    @PreAuthorize("isAuthenticated()")
    public Result<Void> updateApply(@Valid @RequestBody MerchantSettleDTO settleDTO) {
        merchantApplyService.updateApply(settleDTO);
        return Result.success();
    }

    @PutMapping("/user/info")
    @ApiOperation("更新当前用户信息")
    @PreAuthorize("isAuthenticated()")
    public Result<Void> updateUserInfo(@RequestBody UserInfoUpdateDTO dto, Principal principal) {
        try {
            String userNo = principal.getName();
            SysUser user = sysUserMapper.selectByUserNo(userNo);
            if (user == null) {
                return Result.error("用户不存在");
            }
            
            if (dto.getPhone() != null) {
                user.setPhone(dto.getPhone());
            }
            if (dto.getUserName() != null) {
                user.setUserName(dto.getUserName());
            }
            if (dto.getAvatar() != null) {
                user.setAvatar(dto.getAvatar());
            }
            
            sysUserMapper.updateById(user);
            return Result.success();
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新失败: " + e.getMessage());
        }
    }

    @PutMapping("/user/password")
    @ApiOperation("修改密码")
    @PreAuthorize("isAuthenticated()")
    public Result<Void> updatePassword(@RequestBody PasswordUpdateDTO dto, Principal principal) {
        try {
            String userNo = principal.getName();
            SysUser user = sysUserMapper.selectByUserNo(userNo);
            if (user == null) {
                return Result.error("用户不存在");
            }
            
            // 验证旧密码
            org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder = 
                new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();
            if (!encoder.matches(dto.getOldPassword(), user.getPassword())) {
                return Result.error("旧密码错误");
            }
            
            // 更新新密码
            user.setPassword(encoder.encode(dto.getNewPassword()));
            sysUserMapper.updateById(user);
            
            return Result.success();
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("修改密码失败: " + e.getMessage());
        }
    }

    @GetMapping("/test/password")
    @ApiOperation("测试密码生成（临时接口）")
    public Result<String> testPassword(String password) {
        org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder = 
            new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();
        String encoded = encoder.encode(password);
        System.out.println("原始密码：" + password);
        System.out.println("加密后：" + encoded);
        System.out.println("验证结果：" + encoder.matches(password, encoded));
        return Result.success(encoded);
    }

    @PostMapping("/forgot-password/reset")
    @ApiOperation("忘记密码-重置密码（使用图形验证码）")
    public Result<Void> resetPassword(@RequestParam String userNo,
                                       @RequestParam String phone,
                                       @RequestParam String captchaKey,
                                       @RequestParam String captcha,
                                       @RequestParam String newPassword) {
        // 验证图形验证码
        if (!captchaService.validateCaptcha(captchaKey, captcha)) {
            return Result.error("验证码错误或已过期");
        }

        // 验证账号和手机号是否匹配
        SysUser user = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getUserNo, userNo)
                .eq(SysUser::getIsDeleted, 0));
        if (user == null) {
            return Result.error("用户不存在");
        }
        if (!phone.equals(user.getPhone())) {
            return Result.error("手机号与账号不匹配");
        }

        // 重置密码
        org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder =
            new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();
        user.setPassword(encoder.encode(newPassword));
        user.setUpdateTime(java.time.LocalDateTime.now());
        sysUserMapper.updateById(user);

        return Result.success();
    }
}
