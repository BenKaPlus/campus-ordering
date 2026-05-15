package com.campus.ordering.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@ApiModel(value = "OrderReviewReplyVO对象", description = "评价回复VO")
public class OrderReviewReplyVO {

    @ApiModelProperty(value = "回复ID")
    private Long replyId;

    @ApiModelProperty(value = "评价ID")
    private Long reviewId;

    @ApiModelProperty(value = "回复用户ID")
    private Long replyUserId;

    @ApiModelProperty(value = "回复用户昵称")
    private String replyUserName;

    @ApiModelProperty(value = "回复内容")
    private String replyText;

    @ApiModelProperty(value = "创建时间")
    private LocalDateTime createTime;
}
