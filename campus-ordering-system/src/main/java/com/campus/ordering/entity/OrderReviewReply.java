package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("order_review_reply")
@ApiModel(value = "OrderReviewReply对象", description = "评价回复表")
public class OrderReviewReply {

    @ApiModelProperty(value = "回复ID")
    @TableId(value = "reply_id", type = IdType.AUTO)
    private Long replyId;

    @ApiModelProperty(value = "评价ID")
    @TableField("review_id")
    private Long reviewId;

    @ApiModelProperty(value = "回复用户ID")
    @TableField("reply_user_id")
    private Long replyUserId;

    @ApiModelProperty(value = "回复内容")
    @TableField("reply_text")
    private String replyText;

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
