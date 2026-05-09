package com.campus.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.entity.ProductInfo;
import com.campus.ordering.entity.ShoppingCart;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.mapper.ProductInfoMapper;
import com.campus.ordering.mapper.ShoppingCartMapper;
import com.campus.ordering.service.CartService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CartServiceImpl implements CartService {

    @Resource
    private ShoppingCartMapper shoppingCartMapper;

    @Resource
    private ProductInfoMapper productInfoMapper;

    @Override
    public void addCart(ShoppingCart cart) {
        if (cart.getUserId() == null) {
            throw new BusinessException(ResultCode.ERROR, "用户未登录");
        }

        if (cart.getProductId() == null) {
            throw new BusinessException(ResultCode.ERROR, "商品不能为空");
        }

        if (cart.getProductNum() == null || cart.getProductNum() <= 0) {
            throw new BusinessException(ResultCode.ERROR, "商品数量必须大于 0");
        }

        LambdaQueryWrapper<ShoppingCart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ShoppingCart::getUserId, cart.getUserId());
        wrapper.eq(ShoppingCart::getProductId, cart.getProductId());
        wrapper.eq(ShoppingCart::getSpecId, cart.getSpecId() != null ? cart.getSpecId() : 0);
        wrapper.eq(ShoppingCart::getIsDeleted, 0);

        ShoppingCart existCart = shoppingCartMapper.selectOne(wrapper);

        if (existCart != null) {
            existCart.setProductNum(existCart.getProductNum() + cart.getProductNum());
            existCart.setUpdateTime(LocalDateTime.now());
            shoppingCartMapper.updateById(existCart);
        } else {
            cart.setIsChecked(1);
            cart.setIsDeleted(0);
            cart.setCreateTime(LocalDateTime.now());
            cart.setUpdateTime(LocalDateTime.now());
            shoppingCartMapper.insert(cart);
        }
    }

    @Override
    public List<ShoppingCart> getCartList(Long userId) {
        if (userId == null) {
            throw new BusinessException(ResultCode.ERROR, "用户未登录");
        }

        LambdaQueryWrapper<ShoppingCart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ShoppingCart::getUserId, userId);
        wrapper.eq(ShoppingCart::getIsDeleted, 0);
        wrapper.orderByDesc(ShoppingCart::getCreateTime);

        List<ShoppingCart> cartList = shoppingCartMapper.selectList(wrapper);
        
        // 填充商品详情
        for (ShoppingCart cart : cartList) {
            ProductInfo product = productInfoMapper.selectById(cart.getProductId());
            if (product != null) {
                cart.setProductName(product.getProductName());
                cart.setProductPrice(product.getPrice());
                cart.setProductImage(product.getProductImage());
            }
        }
        
        return cartList;
    }

    @Override
    public void updateCartNum(Long cartId, Integer num, Long userId) {
        if (cartId == null || num == null || num <= 0) {
            throw new BusinessException(ResultCode.ERROR, "参数错误");
        }

        ShoppingCart cart = shoppingCartMapper.selectById(cartId);
        if (cart == null) {
            throw new BusinessException(ResultCode.ERROR, "购物车记录不存在");
        }

        // 验证是否属于当前用户
        if (!cart.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.ERROR, "无权操作该购物车");
        }

        cart.setProductNum(num);
        cart.setUpdateTime(LocalDateTime.now());
        shoppingCartMapper.updateById(cart);
    }

    @Override
    public void deleteCart(List<Long> cartIds, Long userId) {
        if (cartIds == null || cartIds.isEmpty()) {
            throw new BusinessException(ResultCode.ERROR, "请选择要删除的商品");
        }

        for (Long cartId : cartIds) {
            ShoppingCart cart = shoppingCartMapper.selectById(cartId);
            if (cart != null && cart.getUserId().equals(userId)) {
                cart.setIsDeleted(1);
                cart.setUpdateTime(LocalDateTime.now());
                shoppingCartMapper.updateById(cart);
            }
        }
    }
}
