package com.campus.ordering.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@ApiModel(value = "AdminOrderVO 对象", description = "管理员端订单信息视图对象")
public class AdminOrderVO {

    @ApiModelProperty(value = "订单 ID")
    private Long orderId;

    @ApiModelProperty(value = "订单编号")
    private String orderNo;

    @ApiModelProperty(value = "下单用户 ID")
    private Long userId;

    @ApiModelProperty(value = "用户编号/学号")
    private String userNo;

    @ApiModelProperty(value = "用户姓名")
    private String userName;

    @ApiModelProperty(value = "用户手机号")
    private String userPhone;

    @ApiModelProperty(value = "店铺 ID")
    private Long shopId;

    @ApiModelProperty(value = "店铺名称")
    private String shopName;

    @ApiModelProperty(value = "收货人姓名")
    private String receiverName;

    @ApiModelProperty(value = "收货人手机号")
    private String receiverPhone;

    @ApiModelProperty(value = "收货地址")
    private String receiverAddress;

    @ApiModelProperty(value = "订单总金额")
    private BigDecimal totalAmount;

    @ApiModelProperty(value = "实付金额")
    private BigDecimal payAmount;

    @ApiModelProperty(value = "订单状态：0-待支付 1-待接单 2-待备餐 3-待出餐 4-配送中 5-已完成 6-已取消 7-退款中 8-已退款")
    private Integer orderStatus;

    @ApiModelProperty(value = "支付状态：0-未支付 1-已支付 2-已退款")
    private Integer payStatus;

    @ApiModelProperty(value = "订单备注")
    private String orderRemark;

    @ApiModelProperty(value = "下单时间")
    private LocalDateTime createTime;
}
