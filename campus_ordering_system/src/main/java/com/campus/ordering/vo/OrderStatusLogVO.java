package com.campus.ordering.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@ApiModel(value = "OrderStatusLogVO 对象", description = "订单状态日志视图对象")
public class OrderStatusLogVO {

    @ApiModelProperty(value = "日志 ID")
    private Long id;

    @ApiModelProperty(value = "订单 ID")
    private Long orderId;

    @ApiModelProperty(value = "订单编号")
    private String orderNo;

    @ApiModelProperty(value = "变更前的状态")
    private Integer beforeStatus;

    @ApiModelProperty(value = "变更后的状态")
    private Integer afterStatus;

    @ApiModelProperty(value = "变更描述")
    private String description;

    @ApiModelProperty(value = "操作人 ID")
    private Long operatorId;

    @ApiModelProperty(value = "操作人姓名")
    private String operatorName;

    @ApiModelProperty(value = "操作时间")
    private LocalDateTime createTime;
}
