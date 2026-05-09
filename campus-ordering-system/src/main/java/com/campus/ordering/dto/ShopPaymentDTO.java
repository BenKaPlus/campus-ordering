package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;

@Data
@ApiModel(value = "店铺支付信息DTO")
public class ShopPaymentDTO {
    @ApiModelProperty(value = "店铺ID")
    private Long shopId;

    @ApiModelProperty(value = "店铺名称")
    private String shopName;

    @ApiModelProperty(value = "订单ID")
    private Long orderId;

    @ApiModelProperty(value = "订单号")
    private String orderNo;

    @ApiModelProperty(value = "应付金额")
    private BigDecimal payAmount;

    @ApiModelProperty(value = "支付方式：1-微信 2-支付宝")
    private Integer payType;

    @ApiModelProperty(value = "微信收款码")
    private String wxQrcode;

    @ApiModelProperty(value = "支付宝收款码")
    private String aliQrcode;
}
