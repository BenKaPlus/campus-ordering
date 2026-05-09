package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("product_info")
@ApiModel(value = "ProductInfo对象", description = "商品信息表")
public class ProductInfo {

    @ApiModelProperty(value = "商品ID")
    @TableId(value = "product_id", type = IdType.AUTO)
    private Long productId;

    @ApiModelProperty(value = "所属店铺ID")
    @TableField("shop_id")
    private Long shopId;

    @ApiModelProperty(value = "所属店铺名称")
    @TableField(exist = false)
    private String shopName;

    @ApiModelProperty(value = "所属商品分类ID")
    @TableField("category_id")
    private Long categoryId;

    @ApiModelProperty(value = "商品名称")
    @TableField("product_name")
    private String productName;

    @ApiModelProperty(value = "商品主图URL")
    @TableField("product_image")
    private String productImage;

    @ApiModelProperty(value = "商品轮播图URL数组（JSON格式）")
    @TableField("product_images")
    private String productImages;

    @ApiModelProperty(value = "商品描述")
    @TableField("product_desc")
    private String productDesc;

    @ApiModelProperty(value = "商品售价")
    @TableField("price")
    private BigDecimal price;

    @ApiModelProperty(value = "商品原价")
    @TableField("original_price")
    private BigDecimal originalPrice;

    @ApiModelProperty(value = "商品单位（份、杯、个等）")
    @TableField("unit")
    private String unit;

    @ApiModelProperty(value = "月销量")
    @TableField("monthly_sales")
    private Integer monthlySales;

    @ApiModelProperty(value = "商品状态：0-下架 1-上架")
    @TableField("product_status")
    private Integer productStatus;

    @ApiModelProperty(value = "是否热销：0-否 1-是")
    @TableField("is_hot")
    private Integer isHot;

    @ApiModelProperty(value = "是否推荐：0-否 1-是")
    @TableField("is_recommend")
    private Integer isRecommend;

    @ApiModelProperty(value = "排序号")
    @TableField("sort")
    private Integer sort;

    @ApiModelProperty(value = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @ApiModelProperty(value = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @ApiModelProperty(value = "逻辑删除")
    @TableField("is_deleted")
    @TableLogic
    private Integer isDeleted;

    public void setSales(int i) {
        this.monthlySales = i;
    }
}