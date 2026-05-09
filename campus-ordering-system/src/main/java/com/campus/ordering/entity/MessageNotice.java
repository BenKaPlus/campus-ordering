package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("message_notice")
@ApiModel(value = "MessageNotice对象", description = "消息通知表")
public class MessageNotice {

    @ApiModelProperty(value = "消息ID")
    @TableId(value = "message_id", type = IdType.AUTO)
    private Long messageId;

    @ApiModelProperty(value = "接收用户ID")
    @TableField("receive_user_id")
    private Long receiveUserId;

    @ApiModelProperty(value = "发送用户ID，系统发送为0")
    @TableField("send_user_id")
    private Long sendUserId;

    @ApiModelProperty(value = "消息类型：1-订单通知 2-系统通知 3-公告通知")
    @TableField("message_type")
    private Integer messageType;

    @ApiModelProperty(value = "消息标题")
    @TableField("message_title")
    private String messageTitle;

    @ApiModelProperty(value = "消息内容")
    @TableField("message_content")
    private String messageContent;

    @ApiModelProperty(value = "关联ID（如订单ID、公告ID）")
    @TableField("relation_id")
    private Long relationId;

    @ApiModelProperty(value = "是否已读：0-未读 1-已读")
    @TableField("is_read")
    private Integer isRead;

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