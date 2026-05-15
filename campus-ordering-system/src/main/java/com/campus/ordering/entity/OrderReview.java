package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("order_review")
@ApiModel(value = "OrderReview对象", description = "订单评价表")
public class OrderReview {

    @ApiModelProperty(value = "评价ID")
    @TableId(value = "review_id", type = IdType.AUTO)
    private Long reviewId;

    @ApiModelProperty(value = "订单ID")
    @TableField("order_id")
    private Long orderId;

    @ApiModelProperty(value = "用户ID")
    @TableField("user_id")
    private Long userId;

    @ApiModelProperty(value = "店铺ID")
    @TableField("shop_id")
    private Long shopId;

    @ApiModelProperty(value = "服务态度评分（1-5星）")
    @TableField("service_rating")
    private Integer serviceRating;

    @ApiModelProperty(value = "配送速度评分（1-5星）")
    @TableField("delivery_rating")
    private Integer deliveryRating;

    @ApiModelProperty(value = "商品满意度评分（1-5星）")
    @TableField("product_rating")
    private Integer productRating;

    @ApiModelProperty(value = "综合评分")
    @TableField("overall_rating")
    private BigDecimal overallRating;

    @ApiModelProperty(value = "文字评价")
    @TableField("review_text")
    private String reviewText;

    @ApiModelProperty(value = "是否匿名：0-否 1-是")
    @TableField("is_anonymous")
    private Integer isAnonymous;

    @ApiModelProperty(value = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @ApiModelProperty(value = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @ApiModelProperty(value = "逻辑删除")
    @TableField("is_deleted")
    @TableLogic
    private Integer isDeleted;
}
