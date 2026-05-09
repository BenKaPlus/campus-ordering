package com.campus.ordering.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.dto.LoginDTO;
import com.campus.ordering.dto.MerchantApplyDTO;
import com.campus.ordering.dto.StudentRegisterDTO;
import com.campus.ordering.entity.MerchantApply;
import com.campus.ordering.entity.SysRole;
import com.campus.ordering.entity.SysUser;
import com.campus.ordering.entity.SysUserRole;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.mapper.MerchantApplyMapper;
import com.campus.ordering.mapper.SysRoleMapper;
import com.campus.ordering.mapper.SysUserMapper;
import com.campus.ordering.mapper.SysUserRoleMapper;
import com.campus.ordering.security.JwtTokenUtil;
import com.campus.ordering.service.AuthService;
import com.campus.ordering.vo.LoginVO;
import com.campus.ordering.vo.RoleInfoVO;
import com.campus.ordering.vo.UserInfoVO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

@Service
public class AuthServiceImpl implements AuthService {

    @Resource
    private SysUserMapper sysUserMapper;
    @Resource
    private SysUserRoleMapper sysUserRoleMapper;
    @Resource
    private SysRoleMapper sysRoleMapper;
    @Resource
    private PasswordEncoder passwordEncoder;
    @Resource
    private UserDetailsService userDetailsService;
    @Resource
    private JwtTokenUtil jwtTokenUtil;
    @Resource
    private RedisTemplate<String, Object> redisTemplate;

    @Resource
    private MerchantApplyMapper merchantApplyMapper;

    @Value("${jwt.expiration}")
    private Long expiration;
    @Value("${jwt.refresh-expiration}")
    private Long refreshExpiration;

    @Override
    public LoginVO login(LoginDTO loginDTO) {
        // 1. 校验验证码
        String cacheCaptcha = (String) redisTemplate.opsForValue().get("captcha:" + loginDTO.getUuid());
        if (StrUtil.isBlank(cacheCaptcha) || !cacheCaptcha.equalsIgnoreCase(loginDTO.getCaptcha())) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "验证码错误或已过期");
        }

        // 2. 查询用户
        SysUser user = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getUserNo, loginDTO.getUserNo())
                .eq(SysUser::getIsDeleted, 0));
        if (user == null) {
            throw new BusinessException(ResultCode.USER_NOT_FOUND);
        }

        // 3. 校验密码
        if (!passwordEncoder.matches(loginDTO.getPassword(), user.getPassword())) {
            throw new BusinessException(ResultCode.PASSWORD_ERROR);
        }

        // 4. 校验账号状态
        if (user.getStatus() == 0) {
            throw new BusinessException(ResultCode.USER_DISABLED);
        }

        // 5. 查询用户角色
        SysUserRole userRole = sysUserRoleMapper.selectOne(new LambdaQueryWrapper<SysUserRole>()
                .eq(SysUserRole::getUserId, user.getUserId())
                .eq(SysUserRole::getIsDeleted, 0));
        SysRole role = sysRoleMapper.selectById(userRole.getRoleId());

        // 6. 生成JWT令牌
        UserDetails userDetails = userDetailsService.loadUserByUsername(user.getUserNo());
        String token = jwtTokenUtil.generateToken(userDetails, user.getUserId(), role.getRoleCode());
        String refreshToken = jwtTokenUtil.generateRefreshToken(userDetails);

        // 7. 令牌存入Redis
        redisTemplate.opsForValue().set("token:" + user.getUserId(), token, expiration, TimeUnit.SECONDS);
        redisTemplate.opsForValue().set("refreshToken:" + user.getUserId(), refreshToken, refreshExpiration, TimeUnit.SECONDS);

        // 8. 封装返回结果
        LoginVO loginVO = new LoginVO();
        loginVO.setToken(token);
        loginVO.setRefreshToken(refreshToken);
        loginVO.setExpiresIn(expiration);

        UserInfoVO userInfo = new UserInfoVO();
        userInfo.setUserId(user.getUserId());
        userInfo.setUserNo(user.getUserNo());
        userInfo.setUserName(user.getUserName());
        userInfo.setPhone(user.getPhone());
        userInfo.setAvatar(user.getAvatar());
        userInfo.setStatus(user.getStatus());
        loginVO.setUserInfo(userInfo);

        RoleInfoVO roleInfo = new RoleInfoVO();
        roleInfo.setRoleId(role.getRoleId());
        roleInfo.setRoleCode(role.getRoleCode());
        roleInfo.setRoleName(role.getRoleName());
        loginVO.setRoleInfo(roleInfo);

        // 9. 删除验证码
        redisTemplate.delete("captcha:" + loginDTO.getUuid());

        return loginVO;
    }

    @Override
    public void logout(Long userId) {
        redisTemplate.delete("token:" + userId);
        redisTemplate.delete("refreshToken:" + userId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void studentRegister(StudentRegisterDTO registerDTO) {
        // 1. 校验验证码
        String cacheCaptcha = (String) redisTemplate.opsForValue().get("captcha:" + registerDTO.getUuid());
        if (StrUtil.isBlank(cacheCaptcha) || !cacheCaptcha.equalsIgnoreCase(registerDTO.getCaptcha())) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "验证码错误或已过期");
        }

        // 2. 检查学号是否已存在
        SysUser existUser = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getUserNo, registerDTO.getUserNo())
                .eq(SysUser::getIsDeleted, 0));
        if (existUser != null) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "该学号已被注册");
        }

        // 3. 检查手机号是否已存在
        SysUser existPhone = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getPhone, registerDTO.getPhone())
                .eq(SysUser::getIsDeleted, 0));
        if (existPhone != null) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "该手机号已被注册");
        }

        // 4. 查询学生角色
        SysRole studentRole = sysRoleMapper.selectOne(new LambdaQueryWrapper<SysRole>()
                .eq(SysRole::getRoleCode, "student")
                .eq(SysRole::getIsDeleted, 0));
        if (studentRole == null) {
            throw new BusinessException(ResultCode.ERROR, "学生角色不存在");
        }

        // 5. 创建用户
        SysUser user = new SysUser();
        user.setUserNo(registerDTO.getUserNo());
        user.setPassword(passwordEncoder.encode(registerDTO.getPassword()));
        user.setPhone(registerDTO.getPhone());
        user.setUserName(registerDTO.getUserName());
        user.setUserType(1); // 1-学生
        user.setStatus(1); // 1-正常
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        user.setIsDeleted(0);
        sysUserMapper.insert(user);

        // 6. 绑定角色
        SysUserRole userRole = new SysUserRole();
        userRole.setUserId(user.getUserId());
        userRole.setRoleId(studentRole.getRoleId());
        userRole.setCreateTime(LocalDateTime.now());
        userRole.setUpdateTime(LocalDateTime.now());
        userRole.setIsDeleted(0);
        sysUserRoleMapper.insert(userRole);

        // 7. 删除验证码
        redisTemplate.delete("captcha:" + registerDTO.getUuid());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void merchantApply(MerchantApplyDTO applyDTO) {
        // 1. 校验验证码
        String cacheCaptcha = (String) redisTemplate.opsForValue().get("captcha:" + applyDTO.getUuid());
        if (StrUtil.isBlank(cacheCaptcha) || !cacheCaptcha.equalsIgnoreCase(applyDTO.getCaptcha())) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "验证码错误或已过期");
        }

        // 2. 检查账号是否已存在
        SysUser existUser = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getUserNo, applyDTO.getUserNo())
                .eq(SysUser::getIsDeleted, 0));
        if (existUser != null) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "该账号已被注册");
        }

        // 3. 检查手机号是否已存在
        SysUser existPhone = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getPhone, applyDTO.getPhone())
                .eq(SysUser::getIsDeleted, 0));
        if (existPhone != null) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "该手机号已被注册");
        }

        // 4. 创建用户（状态为待审核）
        SysUser user = new SysUser();
        user.setUserNo(applyDTO.getUserNo());
        user.setPassword(passwordEncoder.encode(applyDTO.getPassword()));
        user.setPhone(applyDTO.getPhone());
        user.setUserName(applyDTO.getUserName());
        user.setUserType(2); // 2-商家
        user.setStatus(0); // 0-禁用，待审核
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        user.setIsDeleted(0);
        sysUserMapper.insert(user);

        // 5. 创建入驻申请
        MerchantApply apply = new MerchantApply();
        apply.setUserId(user.getUserId());
        apply.setApplicantName(applyDTO.getUserName());
        apply.setApplicantPhone(applyDTO.getPhone());
        apply.setShopName(applyDTO.getShopName());
        apply.setShopDescription(applyDTO.getShopDescription());
        apply.setShopType(applyDTO.getShopType());
        apply.setDeliveryFee(applyDTO.getDeliveryFee());
        apply.setBusinessLicense(applyDTO.getBusinessLicense());
        apply.setIdCardFront(applyDTO.getIdCardFront());
        apply.setIdCardBack(applyDTO.getIdCardBack());
        apply.setAuditStatus(0); // 0-待审核
        apply.setCreateTime(LocalDateTime.now());
        apply.setUpdateTime(LocalDateTime.now());
        apply.setIsDeleted(0);
        merchantApplyMapper.insert(apply);

        // 6. 删除验证码
        redisTemplate.delete("captcha:" + applyDTO.getUuid());
    }
}