package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("order_item")
@ApiModel(value = "OrderItem对象", description = "订单详情表")
public class OrderItem {

    @ApiModelProperty(value = "详情ID")
    @TableId(value = "item_id", type = IdType.AUTO)
    private Long itemId;

    @ApiModelProperty(value = "所属订单ID")
    @TableField("order_id")
    private Long orderId;

    @ApiModelProperty(value = "订单编号")
    @TableField("order_no")
    private String orderNo;

    @ApiModelProperty(value = "商品ID")
    @TableField("product_id")
    private Long productId;

    @ApiModelProperty(value = "商品名称")
    @TableField("product_name")
    private String productName;

    @ApiModelProperty(value = "商品图片")
    @TableField("product_image")
    private String productImage;

    @ApiModelProperty(value = "规格ID")
    @TableField("spec_id")
    private Long specId;

    @ApiModelProperty(value = "规格名称")
    @TableField("spec_name")
    private String specName;

    @ApiModelProperty(value = "商品单价")
    @TableField("product_price")
    private BigDecimal productPrice;

    @ApiModelProperty(value = "商品数量")
    @TableField("product_num")
    private Integer productNum;

    @ApiModelProperty(value = "商品小计金额")
    @TableField("total_price")
    private BigDecimal totalPrice;

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
}