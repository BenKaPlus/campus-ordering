package com.campus.ordering.service;

import com.campus.ordering.entity.ShoppingCart;
import java.util.List;

public interface CartService {
    /**
     * 商品加入购物车
     */
    void addCart(ShoppingCart cart);

    /**
     * 获取用户购物车列表
     */
    List<ShoppingCart> getCartList(Long userId);

    /**
     * 修改购物车商品数量
     */
    void updateCartNum(Long cartId, Integer num, Long userId);

    /**
     * 删除购物车商品
     */
    void deleteCart(List<Long> cartIds, Long userId);
}