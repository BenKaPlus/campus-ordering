package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import javax.validation.constraints.NotNull;
import java.util.List;

@Data
@ApiModel(value = "批量创建订单入参")
public class BatchOrderCreateDTO {
    @NotNull(message = "收货地址ID不能为空")
    @ApiModelProperty(value = "收货地址ID", required = true)
    private Long addressId;

    @NotNull(message = "店铺订单列表不能为空")
    @ApiModelProperty(value = "店铺订单列表", required = true)
    private List<ShopOrderDTO> shopOrders;

    @Data
    public static class ShopOrderDTO {
        @NotNull(message = "店铺ID不能为空")
        @ApiModelProperty(value = "店铺ID", required = true)
        private Long shopId;

        @ApiModelProperty(value = "店铺名称")
        private String shopName;

        @ApiModelProperty(value = "订单备注")
        private String orderRemark;

        @ApiModelProperty(value = "支付方式：wx-微信 ali-支付宝", required = true)
        private String payType;

        @ApiModelProperty(value = "商品列表", required = true)
        private List<OrderItemDTO> itemList;
    }

    @Data
    public static class OrderItemDTO {
        @NotNull(message = "商品ID不能为空")
        private Long productId;
        private Long specId;
        @NotNull(message = "商品数量不能为空")
        private Integer productNum;
    }
}
