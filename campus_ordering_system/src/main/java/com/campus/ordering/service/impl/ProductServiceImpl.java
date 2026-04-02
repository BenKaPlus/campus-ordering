package com.campus.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.entity.ProductCategory;
import com.campus.ordering.entity.ShopInfo;
import com.campus.ordering.entity.ProductInfo;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.mapper.ProductCategoryMapper;
import com.campus.ordering.mapper.ShopInfoMapper;
import com.campus.ordering.mapper.ProductInfoMapper;
import com.campus.ordering.service.ProductService;
import com.campus.ordering.vo.AdminProductVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ProductServiceImpl implements ProductService {

    @Resource
    private ShopInfoMapper shopInfoMapper;

    @Resource
    private ProductInfoMapper productInfoMapper;

    @Resource
    private ProductCategoryMapper productCategoryMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addProduct(ProductInfo product, Long merchantUserId) {
        if (product.getShopId() == null) {
            ShopInfo shop = shopInfoMapper.selectOne(new LambdaQueryWrapper<ShopInfo>()
                    .eq(ShopInfo::getMerchantUserId, merchantUserId)
                    .eq(ShopInfo::getIsDeleted, 0));
            if (shop == null) {
                throw new BusinessException(ResultCode.ERROR, "您还没有店铺，请先创建店铺");
            }
            product.setShopId(shop.getShopId());
        }

        product.setProductStatus(1);
        product.setSales(0);
        product.setIsDeleted(0);
        product.setCreateTime(LocalDateTime.now());
        product.setUpdateTime(LocalDateTime.now());
        productInfoMapper.insert(product);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateProductStatus(Long productId, Integer status, Long merchantUserId) {
        ProductInfo product = productInfoMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException(ResultCode.ERROR, "商品不存在");
        }

        ShopInfo shop = shopInfoMapper.selectOne(new LambdaQueryWrapper<ShopInfo>()
                .eq(ShopInfo::getShopId, product.getShopId())
                .eq(ShopInfo::getMerchantUserId, merchantUserId)
                .eq(ShopInfo::getIsDeleted, 0));
        if (shop == null) {
            throw new BusinessException(ResultCode.ERROR, "无权操作该商品");
        }

        product.setProductStatus(status);
        product.setUpdateTime(LocalDateTime.now());
        productInfoMapper.updateById(product);
    }

    @Override
    public List<ProductCategory> getCategoryList(Long shopId) {
        return productCategoryMapper.selectList(new LambdaQueryWrapper<ProductCategory>()
                .eq(ProductCategory::getShopId, shopId)
                .eq(ProductCategory::getIsDeleted, 0)
                .orderByAsc(ProductCategory::getSort));
    }

    @Override
    public IPage<ProductInfo> getProductList(Long shopId, Long categoryId, Integer page, Integer size) {
        Page<ProductInfo> productPage = new Page<>(page, size);
        LambdaQueryWrapper<ProductInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductInfo::getShopId, shopId)
                .eq(ProductInfo::getIsDeleted, 0)
                .eq(categoryId != null, ProductInfo::getCategoryId, categoryId)
                .eq(ProductInfo::getProductStatus, 1)
                .orderByDesc(ProductInfo::getSort)
                .orderByDesc(ProductInfo::getCreateTime);
        return productInfoMapper.selectPage(productPage, wrapper);
    }

    @Override
    public ProductInfo getProductDetail(Long productId) {
        return productInfoMapper.selectById(productId);
    }

    @Override
    public IPage<ProductInfo> searchProduct(String keyword, Long shopId, Integer page, Integer size) {
        Page<ProductInfo> productPage = new Page<>(page, size);
        LambdaQueryWrapper<ProductInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductInfo::getShopId, shopId)
                .eq(ProductInfo::getIsDeleted, 0)
                .eq(ProductInfo::getProductStatus, 1)
                .and(StringUtils.hasText(keyword), w -> 
                    w.like(ProductInfo::getProductName, keyword)
                     .or()
                     .like(ProductInfo::getProductDesc, keyword));
        return productInfoMapper.selectPage(productPage, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateProduct(ProductInfo product, Long merchantUserId) {
        ProductInfo existing = productInfoMapper.selectById(product.getProductId());
        if (existing == null) {
            throw new BusinessException(ResultCode.ERROR, "商品不存在");
        }

        ShopInfo shop = shopInfoMapper.selectOne(new LambdaQueryWrapper<ShopInfo>()
                .eq(ShopInfo::getShopId, existing.getShopId())
                .eq(ShopInfo::getMerchantUserId, merchantUserId)
                .eq(ShopInfo::getIsDeleted, 0));
        if (shop == null) {
            throw new BusinessException(ResultCode.ERROR, "无权操作该商品");
        }

        existing.setProductName(product.getProductName());
        existing.setProductImage(product.getProductImage());
        existing.setProductImages(product.getProductImages());
        existing.setProductDesc(product.getProductDesc());
        existing.setPrice(product.getPrice());
        existing.setOriginalPrice(product.getOriginalPrice());
        existing.setUnit(product.getUnit());
        existing.setCategoryId(product.getCategoryId());
        existing.setSort(product.getSort());
        existing.setUpdateTime(LocalDateTime.now());
        productInfoMapper.updateById(existing);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteProduct(Long productId, Long merchantUserId) {
        ProductInfo product = productInfoMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException(ResultCode.ERROR, "商品不存在");
        }

        ShopInfo shop = shopInfoMapper.selectOne(new LambdaQueryWrapper<ShopInfo>()
                .eq(ShopInfo::getShopId, product.getShopId())
                .eq(ShopInfo::getMerchantUserId, merchantUserId)
                .eq(ShopInfo::getIsDeleted, 0));
        if (shop == null) {
            throw new BusinessException(ResultCode.ERROR, "无权操作该商品");
        }

        productInfoMapper.deleteById(productId);
    }

    @Override
    public IPage<ProductInfo> getMerchantProductList(Long merchantUserId, Integer page, Integer size) {
        ShopInfo shop = shopInfoMapper.selectOne(new LambdaQueryWrapper<ShopInfo>()
                .eq(ShopInfo::getMerchantUserId, merchantUserId)
                .eq(ShopInfo::getIsDeleted, 0));
        if (shop == null) {
            return new Page<>(page, size);
        }

        Page<ProductInfo> productPage = new Page<>(page, size);
        LambdaQueryWrapper<ProductInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductInfo::getShopId, shop.getShopId())
                .eq(ProductInfo::getIsDeleted, 0)
                .orderByDesc(ProductInfo::getSort)
                .orderByDesc(ProductInfo::getCreateTime);
        return productInfoMapper.selectPage(productPage, wrapper);
    }

    @Override
    public IPage getAdminProductList(Integer page, Integer size) {
        Page<ProductInfo> productPage = new Page<>(page, size);
        LambdaQueryWrapper<ProductInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductInfo::getIsDeleted, 0)
               .orderByDesc(ProductInfo::getCreateTime);
        Page<ProductInfo> pageInfo = productInfoMapper.selectPage(productPage, wrapper);
        
        // 关联查询店铺信息
        List<Long> shopIds = pageInfo.getRecords().stream()
                .map(ProductInfo::getShopId)
                .collect(Collectors.toList());
        
        List<ShopInfo> shops = new java.util.ArrayList<>();
        if (!shopIds.isEmpty()) {
            shops = shopInfoMapper.selectBatchIds(shopIds);
        }
        Map<Long, ShopInfo> shopMap = shops.stream()
                .collect(Collectors.toMap(ShopInfo::getShopId, shop -> shop, (v1, v2) -> v1));
        
        // 转换为 VO 对象
        List<AdminProductVO> voList = pageInfo.getRecords().stream().map(product -> {
            AdminProductVO vo = new AdminProductVO();
            vo.setProductId(product.getProductId());
            vo.setProductName(product.getProductName());
            vo.setProductImage(product.getProductImage());
            vo.setShopId(product.getShopId());
            vo.setProductPrice(product.getPrice());
            vo.setStatus(product.getProductStatus());
            vo.setMonthlySales(product.getMonthlySales());
            vo.setCreateTime(product.getCreateTime());
            
            // 设置店铺名称
            ShopInfo shop = shopMap.get(product.getShopId());
            if (shop != null) {
                vo.setShopName(shop.getShopName());
            }
            
            return vo;
        }).collect(Collectors.toList());
        
        // 创建新的分页对象
        Page<AdminProductVO> voPage = new Page<>(page, size, pageInfo.getTotal());
        voPage.setRecords(voList);
        
        return voPage;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void offlineProduct(Long productId, String reason) {
        ProductInfo product = productInfoMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException(ResultCode.ERROR, "商品不存在");
        }
        product.setProductStatus(0);
        product.setUpdateTime(LocalDateTime.now());
        productInfoMapper.updateById(product);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void onlineProduct(Long productId) {
        ProductInfo product = productInfoMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException(ResultCode.ERROR, "商品不存在");
        }
        product.setProductStatus(1);
        product.setUpdateTime(LocalDateTime.now());
        productInfoMapper.updateById(product);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void batchOfflineProduct(List<Long> productIds, String reason) {
        for (Long productId : productIds) {
            ProductInfo product = productInfoMapper.selectById(productId);
            if (product != null) {
                product.setProductStatus(0);
                product.setUpdateTime(LocalDateTime.now());
                productInfoMapper.updateById(product);
            }
        }
    }
}
