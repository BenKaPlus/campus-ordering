package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("payment_info")
@ApiModel(value = "PaymentInfo对象", description = "支付记录表")
public class PaymentInfo {

    @ApiModelProperty(value = "支付记录ID")
    @TableId(value = "payment_id", type = IdType.AUTO)
    private Long paymentId;

    @ApiModelProperty(value = "商户订单号（对应order_no）")
    @TableField("out_trade_no")
    private String outTradeNo;

    @ApiModelProperty(value = "第三方支付流水号")
    @TableField("transaction_id")
    private String transactionId;

    @ApiModelProperty(value = "订单ID")
    @TableField("order_id")
    private Long orderId;

    @ApiModelProperty(value = "支付用户ID")
    @TableField("user_id")
    private Long userId;

    @ApiModelProperty(value = "支付方式：1-微信支付 2-支付宝支付")
    @TableField("pay_type")
    private Integer payType;

    @ApiModelProperty(value = "支付金额")
    @TableField("pay_amount")
    private BigDecimal payAmount;

    @ApiModelProperty(value = "支付状态：0-待支付 1-支付成功 2-支付失败 3-已关闭 4-已退款")
    @TableField("pay_status")
    private Integer payStatus;

    @ApiModelProperty(value = "支付完成时间")
    @TableField("pay_time")
    private LocalDateTime payTime;

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