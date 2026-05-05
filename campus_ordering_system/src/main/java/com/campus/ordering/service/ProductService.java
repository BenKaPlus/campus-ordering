package com.campus.ordering.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.campus.ordering.entity.ProductCategory;
import com.campus.ordering.entity.ProductInfo;

import java.util.List;

public interface ProductService {
    /**
     * 新增商品
     */
    void addProduct(ProductInfo product, Long merchantUserId);

    /**
     * 商品上下架
     */
    void updateProductStatus(Long productId, Integer status, Long merchantUserId);

    /**
     * 获取店铺商品分类列表
     */
    List<ProductCategory> getCategoryList(Long shopId);

    /**
     * 获取店铺商品列表
     */
    IPage<ProductInfo> getProductList(Long shopId, Long categoryId, Integer page, Integer size);

    /**
     * 获取商品详情
     */
    ProductInfo getProductDetail(Long productId);

    /**
     * 搜索商品
     */
    IPage<ProductInfo> searchProduct(String keyword, Long shopId, Integer page, Integer size);

    /**
     * 更新商品信息
     */
    void updateProduct(ProductInfo product, Long merchantUserId);

    /**
     * 删除商品
     */
    void deleteProduct(Long productId, Long merchantUserId);

    /**
     * 获取商家商品列表
     */
    IPage<ProductInfo> getMerchantProductList(Long merchantUserId, Integer page, Integer size);

    /**
     * 获取商品列表（管理员端）
     */
    IPage<ProductInfo> getAdminProductList(Integer page, Integer size);

    /**
     * 下架商品
     */
    void offlineProduct(Long productId, String reason);

    /**
     * 上架商品
     */
    void onlineProduct(Long productId);

    /**
     * 批量下架商品
     */
    void batchOfflineProduct(List<Long> productIds, String reason);

    /**
     * 更新商品图片
     */
    void updateProductImage(Long productId, String productImage, Long merchantUserId);
}
