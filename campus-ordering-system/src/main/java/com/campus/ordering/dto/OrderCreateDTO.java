package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

@Data
@ApiModel(value = "订单创建入参")
public class OrderCreateDTO {

    @NotNull(message = "店铺ID不能为空")
    @ApiModelProperty(value = "店铺ID", required = true)
    private Long shopId;

    @NotNull(message = "收货地址ID不能为空")
    @ApiModelProperty(value = "收货地址ID", required = true)
    private Long addressId;

    @ApiModelProperty(value = "订单备注")
    private String orderRemark;

    @NotNull(message = "商品列表不能为空")
    @ApiModelProperty(value = "商品列表", required = true)
    private List<OrderItemDTO> itemList;

    @ApiModelProperty(value = "购物车ID列表")
    private List<Long> cartIds;

    @Data
    public static class OrderItemDTO {
        @NotNull(message = "商品ID不能为空")
        private Long productId;
        private Long specId;
        @NotNull(message = "商品数量不能为空")
        private Integer productNum;
        private BigDecimal productPrice;
    }
}