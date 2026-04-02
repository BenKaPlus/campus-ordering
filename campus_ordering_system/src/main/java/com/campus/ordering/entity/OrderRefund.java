package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("order_refund")
@ApiModel(value = "OrderRefund对象", description = "订单退款申请表")
public class OrderRefund {

    @ApiModelProperty(value = "退款申请ID")
    @TableId(value = "refund_id", type = IdType.AUTO)
    private Long refundId;

    @ApiModelProperty(value = "退款编号（唯一，幂等用）")
    @TableField("refund_no")
    private String refundNo;

    @ApiModelProperty(value = "所属订单ID")
    @TableField("order_id")
    private Long orderId;

    @ApiModelProperty(value = "订单编号")
    @TableField("order_no")
    private String orderNo;

    @ApiModelProperty(value = "申请人用户ID")
    @TableField("user_id")
    private Long userId;

    @ApiModelProperty(value = "所属店铺ID")
    @TableField("shop_id")
    private Long shopId;

    @ApiModelProperty(value = "申请退款金额")
    @TableField("refund_amount")
    private BigDecimal refundAmount;

    @ApiModelProperty(value = "退款原因")
    @TableField("refund_reason")
    private String refundReason;

    @ApiModelProperty(value = "退款说明")
    @TableField("refund_desc")
    private String refundDesc;

    @ApiModelProperty(value = "退款凭证图片URL数组（JSON格式）")
    @TableField("refund_images")
    private String refundImages;

    @ApiModelProperty(value = "退款状态：0-待审核 1-商家同意 2-商家拒绝 3-退款中 4-退款成功 5-退款失败")
    @TableField("refund_status")
    private Integer refundStatus;

    @ApiModelProperty(value = "商家审核时间")
    @TableField("audit_time")
    private LocalDateTime auditTime;

    @ApiModelProperty(value = "审核备注")
    @TableField("audit_remark")
    private String auditRemark;

    @ApiModelProperty(value = "退款完成时间")
    @TableField("refund_time")
    private LocalDateTime refundTime;

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