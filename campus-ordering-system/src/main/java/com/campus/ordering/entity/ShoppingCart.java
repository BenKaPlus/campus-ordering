package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("shopping_cart")
@ApiModel(value = "ShoppingCart对象", description = "购物车表")
public class ShoppingCart {

    @ApiModelProperty(value = "购物车ID")
    @TableId(value = "cart_id", type = IdType.AUTO)
    private Long cartId;

    @ApiModelProperty(value = "所属用户ID")
    @TableField("user_id")
    private Long userId;

    @ApiModelProperty(value = "所属店铺ID")
    @TableField("shop_id")
    private Long shopId;

    @ApiModelProperty(value = "商品ID")
    @TableField("product_id")
    private Long productId;

    @ApiModelProperty(value = "商品规格ID")
    @TableField("spec_id")
    private Long specId;

    @ApiModelProperty(value = "商品数量")
    @TableField("product_num")
    private Integer productNum;

    @ApiModelProperty(value = "是否选中：0-未选中 1-选中")
    @TableField("is_checked")
    private Integer isChecked;

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

    @ApiModelProperty(value = "商品名称（非数据库字段）")
    @TableField(exist = false)
    private String productName;

    @ApiModelProperty(value = "商品价格（非数据库字段）")
    @TableField(exist = false)
    private BigDecimal productPrice;

    @ApiModelProperty(value = "商品图片（非数据库字段）")
    @TableField(exist = false)
    private String productImage;

    @ApiModelProperty(value = "店铺名称（非数据库字段）")
    @TableField(exist = false)
    private String shopName;

    @ApiModelProperty(value = "配送费（非数据库字段）")
    @TableField(exist = false)
    private BigDecimal deliveryFee;

    @ApiModelProperty(value = "微信收款码（非数据库字段）")
    @TableField(exist = false)
    private String wxQrcode;

    @ApiModelProperty(value = "支付宝收款码（非数据库字段）")
    @TableField(exist = false)
    private String aliQrcode;
}