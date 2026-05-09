package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("shop_info")
@ApiModel(value = "ShopInfo对象", description = "商家店铺信息表")
public class ShopInfo {

    @ApiModelProperty(value = "店铺ID")
    @TableId(value = "shop_id", type = IdType.AUTO)
    private Long shopId;

    @ApiModelProperty(value = "关联商家用户ID")
    @TableField("merchant_user_id")
    private Long merchantUserId;

    @ApiModelProperty(value = "店铺名称")
    @TableField("shop_name")
    private String shopName;

    @ApiModelProperty(value = "店铺LOGO URL")
    @TableField("shop_logo")
    private String shopLogo;

    @ApiModelProperty(value = "店铺封面图URL")
    @TableField("shop_cover")
    private String shopCover;

    @ApiModelProperty(value = "店铺分类ID")
    @TableField("shop_category_id")
    private Long shopCategoryId;

    @ApiModelProperty(value = "营业执照URL")
    @TableField("business_license")
    private String businessLicense;

    @ApiModelProperty(value = "食品经营许可证URL")
    @TableField("food_license")
    private String foodLicense;

    @ApiModelProperty(value = "店铺简介")
    @TableField("shop_desc")
    private String shopDesc;

    @ApiModelProperty(value = "营业时间（如：10:00-22:00）")
    @TableField("business_hours")
    private String businessHours;

    @ApiModelProperty(value = "店铺联系电话")
    @TableField("contact_phone")
    private String contactPhone;

    @ApiModelProperty(value = "店铺地址（校园内位置）")
    @TableField("shop_address")
    private String shopAddress;

    @ApiModelProperty(value = "配送费")
    @TableField("delivery_fee")
    private BigDecimal deliveryFee;

    @ApiModelProperty(value = "起送金额")
    @TableField("min_order_amount")
    private BigDecimal minOrderAmount;

    @ApiModelProperty(value = "店铺状态：0-待审核 1-营业中 2-已打烊 3-审核驳回 4-已禁用")
    @TableField("shop_status")
    private Integer shopStatus;

    @ApiModelProperty(value = "审核状态：0-待审核 1-审核通过 2-审核驳回")
    @TableField("audit_status")
    private Integer auditStatus;

    @ApiModelProperty(value = "审核备注")
    @TableField("audit_remark")
    private String auditRemark;

    @ApiModelProperty(value = "月销量")
    @TableField("monthly_sales")
    private Integer monthlySales;

    @ApiModelProperty(value = "店铺评分（满分5.0）")
    @TableField("shop_score")
    private BigDecimal shopScore;

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

    public void setShopDescription(String shopDescription) {

    }

    public void setShopType(Integer shopType) {
    }
}