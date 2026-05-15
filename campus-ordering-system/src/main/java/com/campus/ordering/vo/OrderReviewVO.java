package com.campus.ordering.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@ApiModel(value = "OrderReviewVO对象", description = "订单评价VO")
public class OrderReviewVO {

    @ApiModelProperty(value = "评价ID")
    private Long reviewId;

    @ApiModelProperty(value = "订单ID")
    private Long orderId;

    @ApiModelProperty(value = "用户ID")
    private Long userId;

    @ApiModelProperty(value = "用户昵称")
    private String userName;

    @ApiModelProperty(value = "用户头像")
    private String userAvatar;

    @ApiModelProperty(value = "店铺ID")
    private Long shopId;

    @ApiModelProperty(value = "服务态度评分（1-5星）")
    private Integer serviceRating;

    @ApiModelProperty(value = "配送速度评分（1-5星）")
    private Integer deliveryRating;

    @ApiModelProperty(value = "商品满意度评分（1-5星）")
    private Integer productRating;

    @ApiModelProperty(value = "综合评分")
    private BigDecimal overallRating;

    @ApiModelProperty(value = "文字评价")
    private String reviewText;

    @ApiModelProperty(value = "是否匿名：0-否 1-是")
    private Integer isAnonymous;

    @ApiModelProperty(value = "创建时间")
    private LocalDateTime createTime;

    @ApiModelProperty(value = "回复列表")
    private List<OrderReviewReplyVO> replyList;
}
