package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sys_announcement")
@ApiModel(value = "SysAnnouncement对象", description = "系统公告表")
public class SysAnnouncement {

    @ApiModelProperty(value = "公告ID")
    @TableId(value = "announcement_id", type = IdType.AUTO)
    private Long announcementId;

    @ApiModelProperty(value = "公告标题")
    @TableField("announcement_title")
    private String announcementTitle;

    @ApiModelProperty(value = "公告内容")
    @TableField("announcement_content")
    private String announcementContent;

    @ApiModelProperty(value = "发布人ID")
    @TableField("publisher_id")
    private Long publisherId;

    @ApiModelProperty(value = "发布人名称")
    @TableField("publisher_name")
    private String publisherName;

    @ApiModelProperty(value = "是否置顶：0-否 1-是")
    @TableField("is_top")
    private Integer isTop;

    @ApiModelProperty(value = "状态：0-下架 1-发布")
    @TableField("status")
    private Integer status;

    @ApiModelProperty(value = "发布时间")
    @TableField("publish_time")
    private LocalDateTime publishTime;

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