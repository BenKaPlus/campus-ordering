package com.campus.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.entity.MerchantApply;
import com.campus.ordering.entity.ShopInfo;
import com.campus.ordering.entity.SysRole;
import com.campus.ordering.entity.SysUser;
import com.campus.ordering.entity.SysUserRole;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.mapper.MerchantApplyMapper;
import com.campus.ordering.mapper.ShopInfoMapper;
import com.campus.ordering.mapper.SysRoleMapper;
import com.campus.ordering.mapper.SysUserMapper;
import com.campus.ordering.mapper.SysUserRoleMapper;
import com.campus.ordering.service.MerchantApplyService;
import com.campus.ordering.dto.MerchantSettleDTO;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.time.LocalDateTime;

@Service
public class MerchantApplyServiceImpl implements MerchantApplyService {

    @Resource
    private MerchantApplyMapper merchantApplyMapper;
    @Resource
    private SysUserMapper sysUserMapper;
    @Resource
    private ShopInfoMapper shopInfoMapper;
    @Resource
    private SysRoleMapper sysRoleMapper;
    @Resource
    private SysUserRoleMapper sysUserRoleMapper;

    @Override
    public IPage<MerchantApply> getApplyList(Integer auditStatus, Integer page, Integer size) {
        Page<MerchantApply> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<MerchantApply> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantApply::getIsDeleted, 0);
        if (auditStatus != null) {
            wrapper.eq(MerchantApply::getAuditStatus, auditStatus);
        }
        wrapper.orderByAsc(MerchantApply::getApplyId);
        return merchantApplyMapper.selectPage(pageParam, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void auditApply(Long applyId, Integer auditStatus, String auditRemark, Long auditUserId) {
        MerchantApply apply = merchantApplyMapper.selectById(applyId);
        if (apply == null) {
            throw new BusinessException(ResultCode.ERROR, "申请不存在");
        }
        if (apply.getAuditStatus() != 0) {
            throw new BusinessException(ResultCode.ERROR, "该申请已审核");
        }

        apply.setAuditStatus(auditStatus);
        apply.setAuditRemark(auditRemark);
        apply.setAuditTime(LocalDateTime.now());
        apply.setAuditUserId(auditUserId);
        apply.setUpdateTime(LocalDateTime.now());
        merchantApplyMapper.updateById(apply);

        // 如果审核通过，激活商家账号并创建店铺
        if (auditStatus == 1) {
            SysUser user = sysUserMapper.selectById(apply.getUserId());
            if (user != null) {
                user.setStatus(1); // 激活账号
                user.setUpdateTime(LocalDateTime.now());
                sysUserMapper.updateById(user);

                // 绑定商家角色
                SysRole merchantRole = sysRoleMapper.selectOne(new LambdaQueryWrapper<SysRole>()
                        .eq(SysRole::getRoleCode, "merchant")
                        .eq(SysRole::getIsDeleted, 0));
                if (merchantRole != null) {
                    SysUserRole userRole = new SysUserRole();
                    userRole.setUserId(user.getUserId());
                    userRole.setRoleId(merchantRole.getRoleId());
                    userRole.setCreateTime(LocalDateTime.now());
                    userRole.setUpdateTime(LocalDateTime.now());
                    userRole.setIsDeleted(0);
                    sysUserRoleMapper.insert(userRole);
                }

                // 创建店铺
                ShopInfo shop = new ShopInfo();
                shop.setMerchantUserId(user.getUserId());
                shop.setShopName(apply.getShopName());
                shop.setShopLogo(""); // 默认空字符串
                shop.setShopDesc(apply.getShopDescription());
                shop.setShopCategoryId(1L); // 默认分类 ID
                shop.setBusinessLicense(""); // 默认空字符串
                shop.setFoodLicense(""); // 默认空字符串
                shop.setBusinessHours("09:00-21:00"); // 默认营业时间
                shop.setContactPhone(user.getPhone()); // 使用用户手机号
                shop.setShopAddress("校园内"); // 默认地址
                shop.setDeliveryFee(apply.getDeliveryFee());
                shop.setMinOrderAmount(new java.math.BigDecimal("0.00")); // 默认 0 起送
                shop.setShopStatus(1); // 营业中
                shop.setAuditStatus(1); // 已审核
                shop.setAuditRemark("入驻申请审核通过");
                shop.setMonthlySales(0); // 初始销量为 0
                shop.setShopScore(new java.math.BigDecimal("5.0")); // 初始评分 5.0
                shop.setCreateTime(LocalDateTime.now());
                shop.setUpdateTime(LocalDateTime.now());
                shop.setIsDeleted(0);
                shopInfoMapper.insert(shop);
            }
        }
    }

    @Override
    public MerchantApply getCurrentUserApply() {
        String userNo = getCurrentUserNo();
        SysUser user = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getUserNo, userNo)
                .eq(SysUser::getIsDeleted, 0));
        if (user == null) {
            return null;
        }

        return merchantApplyMapper.selectOne(new LambdaQueryWrapper<MerchantApply>()
                .eq(MerchantApply::getUserId, user.getUserId())
                .eq(MerchantApply::getIsDeleted, 0)
                .orderByDesc(MerchantApply::getCreateTime)
                .last("LIMIT 1"));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateApply(MerchantSettleDTO settleDTO) {
        String userNo = getCurrentUserNo();
        SysUser user = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getUserNo, userNo)
                .eq(SysUser::getIsDeleted, 0));
        if (user == null) {
            throw new BusinessException(ResultCode.USER_NOT_FOUND);
        }

        MerchantApply apply = merchantApplyMapper.selectOne(new LambdaQueryWrapper<MerchantApply>()
                .eq(MerchantApply::getUserId, user.getUserId())
                .eq(MerchantApply::getIsDeleted, 0)
                .orderByDesc(MerchantApply::getCreateTime)
                .last("LIMIT 1"));
        if (apply == null) {
            throw new BusinessException(ResultCode.ERROR, "未找到入驻申请");
        }

        if (apply.getAuditStatus() == 1) {
            throw new BusinessException(ResultCode.ERROR, "申请已通过，无法修改");
        }

        apply.setShopName(settleDTO.getShopName());
        apply.setShopDescription(settleDTO.getShopDescription());
        apply.setShopType(settleDTO.getShopType());
        apply.setDeliveryFee(settleDTO.getDeliveryFee());
        apply.setBusinessLicense(settleDTO.getBusinessLicense());
        apply.setApplicantIdCard(settleDTO.getApplicantIdCard());
        apply.setIdCardFront(settleDTO.getIdCardFront());
        apply.setIdCardBack(settleDTO.getIdCardBack());

        if (apply.getAuditStatus() == 2) {
            apply.setAuditStatus(0); // 重新提交，恢复为待审核
            apply.setAuditRemark(null);
            apply.setAuditUserId(null);
            apply.setAuditTime(null);
        }

        apply.setUpdateTime(LocalDateTime.now());
        merchantApplyMapper.updateById(apply);
    }

    private String getCurrentUserNo() {
        org.springframework.security.core.Authentication authentication =
            SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
            return ((UserDetails) authentication.getPrincipal()).getUsername();
        }
        throw new BusinessException(ResultCode.ERROR, "无法获取当前用户信息");
    }
}
