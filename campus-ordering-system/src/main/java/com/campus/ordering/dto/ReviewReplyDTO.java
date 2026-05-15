package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel(value = "ReviewReplyDTO对象", description = "评价回复DTO")
public class ReviewReplyDTO {

    @ApiModelProperty(value = "评价ID", required = true)
    private Long reviewId;

    @ApiModelProperty(value = "回复内容", required = true)
    private String replyText;
}
