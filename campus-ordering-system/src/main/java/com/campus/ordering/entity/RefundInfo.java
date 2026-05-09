package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("refund_info")
@ApiModel(value = "RefundInfo对象", description = "退款记录表")
public class RefundInfo {

    @ApiModelProperty(value = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @ApiModelProperty(value = "商户退款单号（对应refund_no）")
    @TableField("out_refund_no")
    private String outRefundNo;

    @ApiModelProperty(value = "退款申请ID")
    @TableField("refund_id")
    private Long refundId;

    @ApiModelProperty(value = "订单ID")
    @TableField("order_id")
    private Long orderId;

    @ApiModelProperty(value = "商户订单号")
    @TableField("out_trade_no")
    private String outTradeNo;

    @ApiModelProperty(value = "原支付流水号")
    @TableField("transaction_id")
    private String transactionId;

    @ApiModelProperty(value = "第三方退款流水号")
    @TableField("refund_transaction_id")
    private String refundTransactionId;

    @ApiModelProperty(value = "退款金额")
    @TableField("refund_amount")
    private BigDecimal refundAmount;

    @ApiModelProperty(value = "退款渠道：1-微信退款 2-支付宝退款")
    @TableField("refund_type")
    private Integer refundType;

    @ApiModelProperty(value = "退款状态：0-退款中 1-退款成功 2-退款失败")
    @TableField("refund_status")
    private Integer refundStatus;

    @ApiModelProperty(value = "退款完成时间")
    @TableField("refund_time")
    private LocalDateTime refundTime;

    @ApiModelProperty(value = "退款回调原始数据")
    @TableField("callback_content")
    private String callbackContent;

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