package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("order_status_log")
@ApiModel(value = "OrderStatusLog对象", description = "订单状态流转日志表")
public class OrderStatusLog {

    @ApiModelProperty(value = "日志ID")
    @TableId(value = "log_id", type = IdType.AUTO)
    private Long logId;

    @ApiModelProperty(value = "订单ID")
    @TableField("order_id")
    private Long orderId;

    @ApiModelProperty(value = "订单编号")
    @TableField("order_no")
    private String orderNo;

    @ApiModelProperty(value = "变更前状态")
    @TableField("pre_status")
    private Integer preStatus;

    @ApiModelProperty(value = "变更后状态")
    @TableField("current_status")
    private Integer currentStatus;

    @ApiModelProperty(value = "操作类型（如：用户下单、商家接单、用户取消）")
    @TableField("operation_type")
    private String operationType;

    @ApiModelProperty(value = "操作人ID")
    @TableField("operation_user_id")
    private Long operationUserId;

    @ApiModelProperty(value = "操作人名称")
    @TableField("operation_user_name")
    private String operationUserName;

    @ApiModelProperty(value = "操作备注")
    @TableField("operation_remark")
    private String operationRemark;

    @ApiModelProperty(value = "操作时间")
    @TableField(value = "operation_time", fill = FieldFill.INSERT)
    private LocalDateTime operationTime;
}