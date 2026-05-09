package com.campus.ordering.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;

@Data
@ApiModel(value = "OrderItemVO 对象", description = "订单项视图对象")
public class OrderItemVO {

    @ApiModelProperty(value = "订单项 ID")
    private Long orderItemId;

    @ApiModelProperty(value = "商品 ID")
    private Long productId;

    @ApiModelProperty(value = "商品名称")
    private String productName;

    @ApiModelProperty(value = "商品图片")
    private String productImage;

    @ApiModelProperty(value = "规格名称")
    private String specName;

    @ApiModelProperty(value = "商品单价")
    private BigDecimal price;

    @ApiModelProperty(value = "购买数量")
    private Integer quantity;

    @ApiModelProperty(value = "小计金额")
    private BigDecimal subTotal;
}
