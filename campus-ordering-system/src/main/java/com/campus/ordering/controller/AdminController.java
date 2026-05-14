package com.campus.ordering.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.campus.ordering.common.Result;
import com.campus.ordering.entity.MerchantApply;
import com.campus.ordering.entity.OrderInfo;
import com.campus.ordering.entity.ProductInfo;
import com.campus.ordering.entity.ShopInfo;
import com.campus.ordering.entity.SysUser;
import com.campus.ordering.service.MerchantApplyService;
import com.campus.ordering.service.OrderService;
import com.campus.ordering.service.ProductService;
import com.campus.ordering.service.ShopService;
import com.campus.ordering.service.UserService;
import com.campus.ordering.vo.AdminOrderDetailVO;
import com.campus.ordering.vo.AdminOrderVO;
import com.campus.ordering.vo.AdminProductVO;
import com.campus.ordering.vo.AdminShopVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/admin")
@Api(tags = "管理员端接口")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

    @Resource
    private UserService userService;
    @Resource
    private ShopService shopService;
    @Resource
    private ProductService productService;
    @Resource
    private OrderService orderService;
    @Resource
    private MerchantApplyService merchantApplyService;
    @Resource
    private com.campus.ordering.service.PayService payService;

    // ==================== 用户管理接口 ====================
    @GetMapping("/user/list")
    @ApiOperation("获取用户列表")
    public Result<IPage<SysUser>> getUserList(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer userType,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(userService.getUserList(keyword, userType, page, size));
    }

    @PutMapping("/user/status")
    @ApiOperation("更新用户状态")
    public Result<Void> updateUserStatus(
            @RequestParam Long userId,
            @RequestParam Integer status) {
        userService.updateUserStatus(userId, status);
        return Result.success();
    }

    @PutMapping("/user/reset-password")
    @ApiOperation("重置用户密码")
    public Result<Void> resetPassword(@RequestParam Long userId) {
        userService.resetPassword(userId);
        return Result.success();
    }

    @PutMapping("/user/update")
    @ApiOperation("更新用户信息")
    public Result<Void> updateUser(@RequestBody SysUser user) {
        userService.updateUser(user);
        return Result.success();
    }

    // ==================== 店铺管理接口 ====================
    @GetMapping("/shop/list")
    @ApiOperation("获取店铺列表")
    public Result<IPage<AdminShopVO>> getShopList(
            @RequestParam(required = false) String shopName,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(shopService.getAdminShopList(shopName, status, page, size));
    }

    @PutMapping("/shop/audit")
    @ApiOperation("审核店铺")
    public Result<Void> auditShop(
            @RequestParam Long shopId,
            @RequestParam Integer auditStatus,
            @RequestParam(required = false) String auditRemark) {
        shopService.auditShop(shopId, auditStatus, auditRemark);
        return Result.success();
    }

    @PutMapping("/shop/status")
    @ApiOperation("更新店铺状态")
    public Result<Void> updateShopStatus(
            @RequestParam Long shopId,
            @RequestParam Integer status) {
        shopService.updateAdminShopStatus(shopId, status);
        return Result.success();
    }

    @PutMapping("/shop/update")
    @ApiOperation("更新店铺信息")
    public Result<Void> updateShop(@RequestBody ShopInfo shop) {
        shopService.updateShop(shop);
        return Result.success();
    }

    // ==================== 商品管理接口 ====================
    @GetMapping("/product/list")
    @ApiOperation("获取商品列表")
    public Result<IPage<ProductInfo>> getProductList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(productService.getAdminProductList(page, size));
    }

    @PutMapping("/product/offline/{productId}")
    @ApiOperation("下架商品")
    public Result<Void> offlineProduct(
            @PathVariable Long productId,
            @RequestParam(required = false) String reason) {
        productService.offlineProduct(productId, reason);
        return Result.success();
    }

    @PutMapping("/product/online/{productId}")
    @ApiOperation("上架商品")
    public Result<Void> onlineProduct(@PathVariable Long productId) {
        productService.onlineProduct(productId);
        return Result.success();
    }

    @PutMapping("/product/batch-offline")
    @ApiOperation("批量下架商品")
    public Result<Void> batchOfflineProduct(
            @RequestBody List<Long> productIds,
            @RequestParam(required = false) String reason) {
        productService.batchOfflineProduct(productIds, reason);
        return Result.success();
    }

    // ==================== 订单管理接口 ====================
    @GetMapping("/order/list")
    @ApiOperation("获取订单列表")
    public Result<IPage<AdminOrderVO>> getOrderList(
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(orderService.getAdminOrderList(status, keyword, page, size));
    }

    @GetMapping("/order/detail/{orderId}")
    @ApiOperation("获取订单详情")
    public Result<AdminOrderDetailVO> getOrderDetail(@PathVariable Long orderId) {
        return Result.success(orderService.getAdminOrderDetail(orderId));
    }

    // ==================== 商家申请管理接口 ====================
    @GetMapping("/merchant/apply/list")
    @ApiOperation("获取商家申请列表")
    public Result<IPage<MerchantApply>> getMerchantApplyList(
            @RequestParam(required = false) Integer auditStatus,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(merchantApplyService.getApplyList(auditStatus, page, size));
    }

    @PutMapping("/merchant/apply/audit")
    @ApiOperation("审核商家申请")
    public Result<Void> auditMerchantApply(
            @RequestParam Long applyId,
            @RequestParam Integer auditStatus,
            @RequestParam(required = false) String auditRemark) {
        merchantApplyService.auditApply(applyId, auditStatus, auditRemark);
        return Result.success();
    }

    // ==================== 支付记录管理接口 ====================
    @GetMapping("/payment/list")
    @ApiOperation("查询支付记录列表（支持多维度筛选）")
    public Result<IPage<com.campus.ordering.entity.PaymentInfo>> getPaymentList(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long shopId,
            @RequestParam(required = false) Integer payType,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(payService.getAdminPaymentList(userId, shopId, payType, page, size));
    }
}
