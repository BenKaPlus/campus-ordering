package com.campus.ordering.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.campus.ordering.common.Result;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.entity.OrderInfo;
import com.campus.ordering.entity.ProductInfo;
import com.campus.ordering.entity.ShopInfo;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.security.JwtTokenUtil;
import com.campus.ordering.service.*;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/merchant")
@Api(tags = "商家端接口")
@PreAuthorize("hasRole('MERCHANT')")
public class MerchantController {

    @Resource
    private JwtTokenUtil jwtTokenUtil;
    @Resource
    private ShopService shopService;
    @Resource
    private ProductService productService;
    @Resource
    private OrderService orderService;

    // ==================== 店铺接口 ====================
    @GetMapping("/shop/detail")
    @ApiOperation("获取店铺详情")
    public Result<ShopInfo> getShopDetail(HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        return Result.success(shopService.getShopByMerchantId(merchantUserId));
    }

    @PutMapping("/shop/status/update")
    @ApiOperation("切换店铺营业状态")
    public Result<Void> updateShopStatus(@RequestParam Integer status, HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        shopService.updateShopStatus(merchantUserId, status);
        return Result.success();
    }

    @PutMapping("/shop/update")
    @ApiOperation("更新店铺信息")
    public Result<Void> updateShopInfo(@RequestBody ShopInfo shop, HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        shopService.updateShopInfo(shop, merchantUserId);
        return Result.success();
    }

    // ==================== 商品接口 ====================
    @GetMapping("/product/list")
    @ApiOperation("获取店铺商品列表")
    public Result<IPage<ProductInfo>> getProductList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        return Result.success(productService.getMerchantProductList(merchantUserId, page, size));
    }

    @PostMapping("/product/add")
    @ApiOperation("新增商品")
    public Result<Void> addProduct(@RequestBody ProductInfo product, HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        productService.addProduct(product, merchantUserId);
        return Result.success();
    }

    @PutMapping("/product/update")
    @ApiOperation("更新商品信息")
    public Result<Void> updateProduct(@RequestBody ProductInfo product, HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        productService.updateProduct(product, merchantUserId);
        return Result.success();
    }

    @PutMapping("/product/status/update")
    @ApiOperation("商品上下架")
    public Result<Void> updateProductStatus(@RequestParam Long productId, @RequestParam Integer status, HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        productService.updateProductStatus(productId, status, merchantUserId);
        return Result.success();
    }

    @DeleteMapping("/product/delete/{productId}")
    @ApiOperation("删除商品")
    public Result<Void> deleteProduct(@PathVariable Long productId, HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        productService.deleteProduct(productId, merchantUserId);
        return Result.success();
    }

    // ==================== 订单接口 ====================
    @GetMapping("/order/list")
    @ApiOperation("获取店铺订单列表")
    public Result<IPage<OrderInfo>> getOrderList(
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        ShopInfo shop = shopService.getShopByMerchantId(merchantUserId);
        return Result.success(orderService.getMerchantOrderList(shop.getShopId(), status, page, size));
    }

    @PutMapping("/order/accept/{orderId}")
    @ApiOperation("商家接单")
    public Result<Void> acceptOrder(@PathVariable Long orderId, HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        orderService.acceptOrder(orderId, merchantUserId);
        return Result.success();
    }

    @PutMapping("/order/reject/{orderId}")
    @ApiOperation("商家拒单")
    public Result<Void> rejectOrder(@PathVariable Long orderId, @RequestParam String rejectReason, HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        orderService.rejectOrder(orderId, rejectReason, merchantUserId);
        return Result.success();
    }

    @PutMapping("/order/status/{orderId}")
    @ApiOperation("更新订单状态")
    public Result<Void> updateOrderStatus(@PathVariable Long orderId, @RequestParam Integer status, HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        ShopInfo shop = shopService.getShopByMerchantId(merchantUserId);
        orderService.updateOrderStatus(orderId, status, merchantUserId, shop.getShopName());
        return Result.success();
    }

    // 私有方法：获取当前商家用户 ID
    private Long getUserId(HttpServletRequest request) {
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
            try {
                return jwtTokenUtil.getClaimFromToken(token, claims -> claims.get("userId", Long.class));
            } catch (Exception e) {
                // 令牌无效或过期
            }
        }
        throw new BusinessException(ResultCode.ERROR, "用户未登录");
    }

    // ==================== 统计接口 ====================
    @GetMapping("/statistics")
    @ApiOperation("获取店铺统计数据")
    public Result<Object> getStatistics(HttpServletRequest request) {
        Long merchantUserId = getUserId(request);
        ShopInfo shop = shopService.getShopByMerchantId(merchantUserId);
        return Result.success(orderService.getShopStatistics(shop.getShopId()));
    }
}