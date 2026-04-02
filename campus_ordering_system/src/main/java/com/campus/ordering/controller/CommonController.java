package com.campus.ordering.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.campus.ordering.common.Result;
import com.campus.ordering.entity.ProductCategory;
import com.campus.ordering.entity.ProductInfo;
import com.campus.ordering.service.PayService;
import com.campus.ordering.service.ShopService;
import com.campus.ordering.service.FileService;
import com.campus.ordering.service.ProductService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/common")
@Api(tags = "公共接口")
public class CommonController {

    @Resource
    private ShopService shopService;
    @Resource
    private PayService payService;
    @Resource
    private FileService fileService;
    @Resource
    private ProductService productService;

    @GetMapping("/shop/category/list")
    @ApiOperation("获取店铺分类列表")
    public Result<Object> getShopCategoryList() {
        return Result.success(shopService.getCategoryList());
    }

    @GetMapping("/shop/list")
    @ApiOperation("获取店铺列表")
    public Result<Object> getShopList(
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(shopService.getShopList(categoryId, keyword, page, size));
    }

    @GetMapping("/shop/detail/{shopId}")
    @ApiOperation("获取店铺详情")
    public Result<Object> getShopDetail(@PathVariable Long shopId) {
        return Result.success(shopService.getShopDetail(shopId));
    }

    @GetMapping("/product/category/{shopId}")
    @ApiOperation("获取店铺商品分类列表")
    public Result<List<ProductCategory>> getProductCategoryList(@PathVariable Long shopId) {
        return Result.success(productService.getCategoryList(shopId));
    }

    @GetMapping("/product/list/{shopId}")
    @ApiOperation("获取店铺商品列表")
    public Result<IPage<ProductInfo>> getProductList(
            @PathVariable Long shopId,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(productService.getProductList(shopId, categoryId, page, size));
    }

    @GetMapping("/product/detail/{productId}")
    @ApiOperation("获取商品详情")
    public Result<ProductInfo> getProductDetail(@PathVariable Long productId) {
        return Result.success(productService.getProductDetail(productId));
    }

    @GetMapping("/product/search")
    @ApiOperation("搜索商品")
    public Result<IPage<ProductInfo>> searchProduct(
            @RequestParam String keyword,
            @RequestParam(required = false) Long shopId,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(productService.searchProduct(keyword, shopId, page, size));
    }

    @PostMapping("/upload/image")
    @ApiOperation("图片上传")
    public Result<String> uploadImage(@RequestParam("file") MultipartFile file) {
        return Result.success(fileService.uploadImage(file));
    }

    @PostMapping("/pay/callback/wx")
    @ApiOperation("微信支付回调")
    public String wxPayCallback(@RequestBody String notifyData) {
        return payService.wxPayCallback(notifyData);
    }

    @PostMapping("/pay/callback/ali")
    @ApiOperation("支付宝支付回调")
    public String aliPayCallback(HttpServletRequest request) {
        Map<String, String[]> parameterMap = request.getParameterMap();
        // 转换参数
        Map<String, String> params = new java.util.HashMap<>();
        for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
            params.put(entry.getKey(), entry.getValue()[0]);
        }
        return payService.aliPayCallback(params);
    }
}