package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sys_operation_log")
@ApiModel(value = "SysOperationLog对象", description = "操作日志表")
public class SysOperationLog {

    @ApiModelProperty(value = "日志ID")
    @TableId(value = "log_id", type = IdType.AUTO)
    private Long logId;

    @ApiModelProperty(value = "操作用户ID")
    @TableField("user_id")
    private Long userId;

    @ApiModelProperty(value = "操作用户账号")
    @TableField("user_no")
    private String userNo;

    @ApiModelProperty(value = "操作模块（如：商品管理、订单管理）")
    @TableField("operation_module")
    private String operationModule;

    @ApiModelProperty(value = "操作类型（如：新增、编辑、删除、查询）")
    @TableField("operation_type")
    private String operationType;

    @ApiModelProperty(value = "操作描述")
    @TableField("operation_desc")
    private String operationDesc;

    @ApiModelProperty(value = "请求方式（GET/POST/PUT/DELETE）")
    @TableField("request_method")
    private String requestMethod;

    @ApiModelProperty(value = "请求URL")
    @TableField("request_url")
    private String requestUrl;

    @ApiModelProperty(value = "请求参数")
    @TableField("request_params")
    private String requestParams;

    @ApiModelProperty(value = "响应结果")
    @TableField("response_result")
    private String responseResult;

    @ApiModelProperty(value = "操作IP地址")
    @TableField("ip_address")
    private String ipAddress;

    @ApiModelProperty(value = "操作状态：0-失败 1-成功")
    @TableField("operation_status")
    private Integer operationStatus;

    @ApiModelProperty(value = "错误信息")
    @TableField("error_msg")
    private String errorMsg;

    @ApiModelProperty(value = "操作时间")
    @TableField(value = "operation_time", fill = FieldFill.INSERT)
    private LocalDateTime operationTime;

    @ApiModelProperty(value = "耗时（毫秒）")
    @TableField("cost_time")
    private Long costTime;
}