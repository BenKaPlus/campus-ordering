package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName("order_info")
@ApiModel(value = "OrderInfo对象", description = "订单主表")
public class OrderInfo {

    @ApiModelProperty(value = "订单ID")
    @TableId(value = "order_id", type = IdType.AUTO)
    private Long orderId;

    @ApiModelProperty(value = "订单编号（唯一，幂等用）")
    @TableField("order_no")
    private String orderNo;

    @ApiModelProperty(value = "下单用户ID")
    @TableField("user_id")
    private Long userId;

    @ApiModelProperty(value = "所属店铺ID")
    @TableField("shop_id")
    private Long shopId;

    @ApiModelProperty(value = "收货人姓名")
    @TableField("receiver_name")
    private String receiverName;

    @ApiModelProperty(value = "收货人手机号")
    @TableField("receiver_phone")
    private String receiverPhone;

    @ApiModelProperty(value = "收货地址")
    @TableField("receiver_address")
    private String receiverAddress;

    @ApiModelProperty(value = "订单总金额")
    @TableField("total_amount")
    private BigDecimal totalAmount;

    @ApiModelProperty(value = "商品总金额")
    @TableField("product_amount")
    private BigDecimal productAmount;

    @ApiModelProperty(value = "配送费")
    @TableField("delivery_fee")
    private BigDecimal deliveryFee;

    @ApiModelProperty(value = "优惠金额")
    @TableField("discount_amount")
    private BigDecimal discountAmount;

    @ApiModelProperty(value = "实付金额")
    @TableField("pay_amount")
    private BigDecimal payAmount;

    @ApiModelProperty(value = "支付方式：1-微信支付 2-支付宝支付")
    @TableField("pay_type")
    private Integer payType;

    @ApiModelProperty(value = "订单状态：0-待支付 1-待接单 2-待备餐 3-待出餐 4-配送中 5-已完成 6-已取消 7-退款中 8-已退款")
    @TableField("order_status")
    private Integer orderStatus;

    @ApiModelProperty(value = "支付状态：0-未支付 1-已支付 2-已退款")
    @TableField("pay_status")
    private Integer payStatus;

    @ApiModelProperty(value = "订单备注")
    @TableField("order_remark")
    private String orderRemark;

    @ApiModelProperty(value = "支付时间")
    @TableField("pay_time")
    private LocalDateTime payTime;

    @ApiModelProperty(value = "商家接单时间")
    @TableField("accept_time")
    private LocalDateTime acceptTime;

    @ApiModelProperty(value = "出餐/配送时间")
    @TableField("delivery_time")
    private LocalDateTime deliveryTime;

    @ApiModelProperty(value = "订单完成时间")
    @TableField("finish_time")
    private LocalDateTime finishTime;

    @ApiModelProperty(value = "订单取消时间")
    @TableField("cancel_time")
    private LocalDateTime cancelTime;

    @ApiModelProperty(value = "取消原因")
    @TableField("cancel_reason")
    private String cancelReason;

    @ApiModelProperty(value = "订单支付过期时间")
    @TableField("expire_time")
    private LocalDateTime expireTime;

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

    @ApiModelProperty(value = "订单项列表（非数据库字段）")
    @TableField(exist = false)
    private List<OrderItem> itemList;

    public Object getActualAmount() {
        return this.totalAmount.subtract(this.discountAmount);
    }

    public String getShopName() {
        return "shop_" + this.shopId;
    }
}