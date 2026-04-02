package com.campus.ordering.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.ordering.entity.ShopCategory;
import com.campus.ordering.entity.ShopInfo;
import com.campus.ordering.vo.AdminShopVO;

import java.util.List;

public interface ShopService {
    /**
     * 获取店铺分类列表
     */
    List<ShopCategory> getCategoryList();

    /**
     * 获取店铺列表
     */
    Page<ShopInfo> getShopList(Long categoryId, String keyword, Integer page, Integer size);

    ShopInfo getShopByMerchantId(Long merchantUserId);

    void updateShopStatus(Long merchantUserId, Integer status);

    /**
     * 更新店铺信息
     */
    void updateShopInfo(ShopInfo shop, Long merchantUserId);

    /**
     * 获取店铺详情
     */
    ShopInfo getShopDetail(Long shopId);

    /**
     * 获取店铺列表（管理员端）
     */
    IPage<AdminShopVO> getAdminShopList(String shopName, Integer status, Integer page, Integer size);

    /**
     * 审核店铺
     */
    void auditShop(Long shopId, Integer auditStatus, String auditRemark);

    /**
     * 更新店铺状态（管理员端）
     */
    void updateAdminShopStatus(Long shopId, Integer status);

    /**
     * 更新店铺信息（管理员端）
     */
    void updateShop(ShopInfo shop);
}
