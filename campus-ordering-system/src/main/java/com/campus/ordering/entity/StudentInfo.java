package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("student_info")
@ApiModel(value = "StudentInfo对象", description = "学生详细信息表")
public class StudentInfo {

    @ApiModelProperty(value = "主键ID")
    @TableId(value = "student_id", type = IdType.AUTO)
    private Long studentId;

    @ApiModelProperty(value = "关联系统用户ID")
    @TableField("user_id")
    private Long userId;

    @ApiModelProperty(value = "学号")
    @TableField("student_no")
    private String studentNo;

    @ApiModelProperty(value = "所属学院")
    @TableField("college")
    private String college;

    @ApiModelProperty(value = "所属专业")
    @TableField("major")
    private String major;

    @ApiModelProperty(value = "年级")
    @TableField("grade")
    private String grade;

    @ApiModelProperty(value = "宿舍地址")
    @TableField("dormitory")
    private String dormitory;

    @ApiModelProperty(value = "用户姓名")
    @TableField(exist = false)
    private String userName;

    @ApiModelProperty(value = "手机号")
    @TableField(exist = false)
    private String phone;

    @ApiModelProperty(value = "学号")
    @TableField(exist = false)
    private String userNo;

    @ApiModelProperty(value = "头像URL")
    @TableField(exist = false)
    private String avatar;

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