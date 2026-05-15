package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel(value = "OrderReviewDTO对象", description = "订单评价DTO")
public class OrderReviewDTO {

    @ApiModelProperty(value = "订单ID", required = true)
    private Long orderId;

    @ApiModelProperty(value = "服务态度评分（1-5星）", required = true)
    private Integer serviceRating;

    @ApiModelProperty(value = "配送速度评分（1-5星）", required = true)
    private Integer deliveryRating;

    @ApiModelProperty(value = "商品满意度评分（1-5星）", required = true)
    private Integer productRating;

    @ApiModelProperty(value = "文字评价")
    private String reviewText;

    @ApiModelProperty(value = "是否匿名：0-否 1-是", required = true)
    private Integer isAnonymous;
}
