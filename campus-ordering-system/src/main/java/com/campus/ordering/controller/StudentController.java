package com.campus.ordering.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.campus.ordering.common.Result;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.dto.OrderCreateDTO;
import com.campus.ordering.dto.StudentInfoUpdateDTO;
import com.campus.ordering.entity.OrderInfo;
import com.campus.ordering.entity.ShoppingCart;
import com.campus.ordering.entity.StudentInfo;
import com.campus.ordering.entity.UserAddress;
import com.campus.ordering.service.StudentInfoService;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.security.JwtTokenUtil;
import com.campus.ordering.service.*;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/student")
@Api(tags = "学生端接口")
@PreAuthorize("hasRole('STUDENT')")
public class StudentController {

    @Resource
    private JwtTokenUtil jwtTokenUtil;
    @Resource
    private CartService cartService;
    @Resource
    private OrderService orderService;
    @Resource
    private PayService payService;
    @Resource
    private UserAddressService addressService;
    @Resource
    private StudentInfoService studentInfoService;

    // ==================== 购物车接口 ====================
    @PostMapping("/cart/add")
    @ApiOperation("商品加入购物车")
    public Result<Void> addCart(@RequestBody ShoppingCart cart, HttpServletRequest request) {
        Long userId = getUserId(request);
        cart.setUserId(userId);
        cartService.addCart(cart);
        return Result.success();
    }

    @GetMapping("/cart/list")
    @ApiOperation("获取购物车列表")
    public Result<List<ShoppingCart>> getCartList(HttpServletRequest request) {
        Long userId = getUserId(request);
        return Result.success(cartService.getCartList(userId));
    }

    @PutMapping("/cart/update/num")
    @ApiOperation("修改购物车商品数量")
    public Result<Void> updateCartNum(@RequestParam Long cartId, @RequestParam Integer num, HttpServletRequest request) {
        Long userId = getUserId(request);
        cartService.updateCartNum(cartId, num, userId);
        return Result.success();
    }

    @PostMapping("/cart/delete")
    @ApiOperation("删除购物车商品")
    public Result<Void> deleteCart(@RequestBody List<Long> cartIds, HttpServletRequest request) {
        Long userId = getUserId(request);
        cartService.deleteCart(cartIds, userId);
        return Result.success();
    }

    // ==================== 订单接口 ====================
    @PostMapping("/order/settle")
    @ApiOperation("获取结算信息")
    public Result<Object> getSettleInfo(@RequestBody List<Long> cartIds, HttpServletRequest request) {
        Long userId = getUserId(request);
        return Result.success(orderService.getSettleInfo(cartIds, userId));
    }

    @PostMapping("/order/create")
    @ApiOperation("创建订单")
    public Result<String> createOrder(@Valid @RequestBody OrderCreateDTO dto, HttpServletRequest request) {
        Long userId = getUserId(request);
        return Result.success(orderService.createOrder(dto, userId));
    }

    @PutMapping("/order/cancel/{orderId}")
    @ApiOperation("取消订单")
    public Result<Void> cancelOrder(@PathVariable Long orderId, HttpServletRequest request) {
        Long userId = getUserId(request);
        orderService.cancelOrder(orderId, userId);
        return Result.success();
    }

    @GetMapping("/order/list")
    @ApiOperation("获取订单列表")
    public Result<IPage<OrderInfo>> getOrderList(
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            HttpServletRequest request) {
        Long userId = getUserId(request);
        return Result.success(orderService.getStudentOrderList(userId, status, keyword, page, size));
    }

    @GetMapping("/order/detail/{orderId}")
    @ApiOperation("获取订单详情")
    public Result<OrderInfo> getOrderDetail(@PathVariable Long orderId, HttpServletRequest request) {
        Long userId = getUserId(request);
        return Result.success(orderService.getOrderDetail(orderId, userId));
    }

    @GetMapping("/order/pay/{orderNo}")
    @ApiOperation("获取微信支付参数")
    public Result<Object> getWxPayParams(@PathVariable String orderNo, HttpServletRequest request) {
        Long userId = getUserId(request);
        return Result.success(payService.createWxPay(orderNo, userId));
    }

    // ==================== 收货地址接口 ====================
    @GetMapping("/address/list")
    @ApiOperation("获取收货地址列表")
    public Result<List<UserAddress>> getAddressList(HttpServletRequest request) {
        Long userId = getUserId(request);
        return Result.success(addressService.getAddressList(userId));
    }

    @PostMapping("/address/add")
    @ApiOperation("新增收货地址")
    public Result<Void> addAddress(@RequestBody UserAddress address, HttpServletRequest request) {
        Long userId = getUserId(request);
        address.setUserId(userId);
        addressService.addAddress(address);
        return Result.success();
    }

    @PutMapping("/address/update")
    @ApiOperation("更新收货地址")
    public Result<Void> updateAddress(@RequestBody UserAddress address, HttpServletRequest request) {
        Long userId = getUserId(request);
        addressService.updateAddress(address, userId);
        return Result.success();
    }

    @DeleteMapping("/address/delete/{addressId}")
    @ApiOperation("删除收货地址")
    public Result<Void> deleteAddress(@PathVariable Long addressId, HttpServletRequest request) {
        Long userId = getUserId(request);
        addressService.deleteAddress(addressId, userId);
        return Result.success();
    }

    @PutMapping("/address/default/{addressId}")
    @ApiOperation("设置默认收货地址")
    public Result<Void> setDefaultAddress(@PathVariable Long addressId, HttpServletRequest request) {
        Long userId = getUserId(request);
        addressService.setDefaultAddress(addressId, userId);
        return Result.success();
    }

    // ==================== 个人中心接口 ====================
    @GetMapping("/info")
    @ApiOperation("获取个人信息")
    public Result<StudentInfo> getStudentInfo(HttpServletRequest request) {
        Long userId = getUserId(request);
        return Result.success(studentInfoService.getStudentInfo(userId));
    }

    @PutMapping("/info/update")
    @ApiOperation("更新个人信息")
    public Result<Void> updateStudentInfo(@RequestBody StudentInfoUpdateDTO dto, HttpServletRequest request) {
        Long userId = getUserId(request);
        studentInfoService.updateStudentInfo(userId, dto);
        return Result.success();
    }

    // 私有方法：获取当前用户 ID
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
}