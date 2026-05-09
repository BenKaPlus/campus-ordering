package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.util.List;

@Data
@ApiModel(description = "购物车结算DTO")
public class CartSettleDTO {
    @ApiModelProperty(value = "购物车ID列表")
    private List<Long> cartIds;
}
