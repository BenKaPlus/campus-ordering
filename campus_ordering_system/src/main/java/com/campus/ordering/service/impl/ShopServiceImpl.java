package com.campus.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.entity.ShopCategory;
import com.campus.ordering.entity.ShopInfo;
import com.campus.ordering.entity.SysUser;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.mapper.ShopCategoryMapper;
import com.campus.ordering.mapper.ShopInfoMapper;
import com.campus.ordering.mapper.SysUserMapper;
import com.campus.ordering.service.ShopService;
import com.campus.ordering.vo.AdminShopVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ShopServiceImpl implements ShopService {

    @Resource
    private ShopCategoryMapper shopCategoryMapper;

    @Resource
    private ShopInfoMapper shopInfoMapper;

    @Resource
    private SysUserMapper sysUserMapper;

    @Override
    public List<ShopCategory> getCategoryList() {
        LambdaQueryWrapper<ShopCategory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ShopCategory::getIsDeleted, 0);
        wrapper.orderByAsc(ShopCategory::getSort);
        return shopCategoryMapper.selectList(wrapper);
    }

    @Override
    public Page<ShopInfo> getShopList(Long categoryId, String keyword, Integer page, Integer size) {
        Page<ShopInfo> pageInfo = new Page<>(page, size);
        
        LambdaQueryWrapper<ShopInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ShopInfo::getIsDeleted, 0);
        wrapper.eq(ShopInfo::getShopStatus, 1);
        
        if (categoryId != null) {
            wrapper.eq(ShopInfo::getShopCategoryId, categoryId);
        }
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.and(w -> w.like(ShopInfo::getShopName, keyword)
                           .or()
                           .like(ShopInfo::getShopDesc, keyword));
        }
        
        return shopInfoMapper.selectPage(pageInfo, wrapper);
    }

    @Override
    public ShopInfo getShopByMerchantId(Long merchantUserId) {
        LambdaQueryWrapper<ShopInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ShopInfo::getMerchantUserId, merchantUserId);
        wrapper.eq(ShopInfo::getIsDeleted, 0);
        return shopInfoMapper.selectOne(wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateShopStatus(Long merchantUserId, Integer status) {
        ShopInfo shop = getShopByMerchantId(merchantUserId);
        if (shop == null) {
            throw new BusinessException(ResultCode.ERROR, "店铺不存在");
        }
        shop.setShopStatus(status);
        shop.setUpdateTime(LocalDateTime.now());
        shopInfoMapper.updateById(shop);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateShopInfo(ShopInfo shop, Long merchantUserId) {
        ShopInfo existing = getShopByMerchantId(merchantUserId);
        if (existing == null) {
            throw new BusinessException(ResultCode.ERROR, "店铺不存在");
        }

        existing.setShopName(shop.getShopName());
        existing.setShopLogo(shop.getShopLogo());
        existing.setShopCover(shop.getShopCover());
        existing.setShopDesc(shop.getShopDesc());
        existing.setBusinessHours(shop.getBusinessHours());
        existing.setContactPhone(shop.getContactPhone());
        existing.setShopAddress(shop.getShopAddress());
        existing.setDeliveryFee(shop.getDeliveryFee());
        existing.setMinOrderAmount(shop.getMinOrderAmount());
        existing.setUpdateTime(LocalDateTime.now());
        shopInfoMapper.updateById(existing);
    }

    @Override
    public ShopInfo getShopDetail(Long shopId) {
        return shopInfoMapper.selectById(shopId);
    }

    @Override
    public Page<AdminShopVO> getAdminShopList(String shopName, Integer status, Integer page, Integer size) {
        Page<ShopInfo> pageInfo = new Page<>(page, size);
        LambdaQueryWrapper<ShopInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ShopInfo::getIsDeleted, 0)
               .orderByAsc(ShopInfo::getShopId);
        
        if (shopName != null && !shopName.trim().isEmpty()) {
            wrapper.like(ShopInfo::getShopName, shopName);
        }
        
        if (status != null) {
            wrapper.eq(ShopInfo::getShopStatus, status);
        }
        
        Page<ShopInfo> shopPage = shopInfoMapper.selectPage(pageInfo, wrapper);
        
        // 关联查询用户信息（店主信息）
        List<Long> merchantUserIds = shopPage.getRecords().stream()
                .map(ShopInfo::getMerchantUserId)
                .collect(Collectors.toList());
        
        List<SysUser> users = new java.util.ArrayList<>();
        if (!merchantUserIds.isEmpty()) {
            users = sysUserMapper.selectBatchIds(merchantUserIds);
        }
        Map<Long, SysUser> userMap = users.stream()
                .collect(Collectors.toMap(SysUser::getUserId, user -> user, (v1, v2) -> v1));
        
        // 转换为 VO 对象
        List<AdminShopVO> voList = shopPage.getRecords().stream().map(shop -> {
            AdminShopVO vo = new AdminShopVO();
            vo.setShopId(shop.getShopId());
            vo.setShopName(shop.getShopName());
            vo.setStatus(shop.getShopStatus());
            vo.setAuditStatus(shop.getAuditStatus());
            vo.setDeliveryFee(shop.getDeliveryFee());
            vo.setMinOrderAmount(shop.getMinOrderAmount());
            vo.setShopScore(shop.getShopScore());
            vo.setMonthlySales(shop.getMonthlySales());
            vo.setShopDesc(shop.getShopDesc());
            vo.setContactPhone(shop.getContactPhone());
            vo.setCreateTime(shop.getCreateTime());
            
            // 设置店主信息
            SysUser user = userMap.get(shop.getMerchantUserId());
            if (user != null) {
                vo.setOwnerName(user.getUserName() != null ? user.getUserName() : user.getUserNo());
                vo.setPhone(user.getPhone());
            }
            
            return vo;
        }).collect(Collectors.toList());
        
        // 创建新的分页对象
        Page<AdminShopVO> voPage = new Page<>(page, size, shopPage.getTotal());
        voPage.setRecords(voList);
        
        return voPage;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void auditShop(Long shopId, Integer auditStatus, String auditRemark) {
        ShopInfo shop = shopInfoMapper.selectById(shopId);
        if (shop == null) {
            throw new BusinessException(ResultCode.ERROR, "店铺不存在");
        }
        shop.setAuditStatus(auditStatus);
        shop.setAuditRemark(auditRemark);
        if (auditStatus == 1) {
            shop.setShopStatus(1);
        } else if (auditStatus == 2) {
            shop.setShopStatus(3);
        }
        shop.setUpdateTime(LocalDateTime.now());
        shopInfoMapper.updateById(shop);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateAdminShopStatus(Long shopId, Integer status) {
        ShopInfo shop = shopInfoMapper.selectById(shopId);
        if (shop == null) {
            throw new BusinessException(ResultCode.ERROR, "店铺不存在");
        }
        shop.setShopStatus(status);
        shop.setUpdateTime(LocalDateTime.now());
        shopInfoMapper.updateById(shop);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateShop(ShopInfo shop) {
        if (shop == null || shop.getShopId() == null) {
            throw new BusinessException(ResultCode.ERROR, "店铺 ID 不能为空");
        }
        ShopInfo existShop = shopInfoMapper.selectById(shop.getShopId());
        if (existShop == null) {
            throw new BusinessException(ResultCode.ERROR, "店铺不存在");
        }
        
        existShop.setShopName(shop.getShopName());
        existShop.setContactPhone(shop.getContactPhone());
        existShop.setShopDesc(shop.getShopDesc());
        existShop.setDeliveryFee(shop.getDeliveryFee());
        existShop.setMinOrderAmount(shop.getMinOrderAmount());
        existShop.setUpdateTime(LocalDateTime.now());
        
        shopInfoMapper.updateById(existShop);
    }
}
