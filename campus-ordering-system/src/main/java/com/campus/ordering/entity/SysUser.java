package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sys_user")
@ApiModel(value = "SysUser对象", description = "系统用户表")
public class SysUser {

    @ApiModelProperty(value = "用户唯一ID")
    @TableId(value = "user_id", type = IdType.AUTO)
    private Long userId;

    @ApiModelProperty(value = "登录账号（学生学号/商家账号/管理员账号）")
    @TableField("user_no")
    private String userNo;

    @ApiModelProperty(value = "加密存储密码（BCrypt加密）")
    @TableField("password")
    @JsonIgnore // 密码不序列化返回
    private String password;

    @ApiModelProperty(value = "手机号")
    @TableField("phone")
    private String phone;

    @ApiModelProperty(value = "用户头像URL")
    @TableField("avatar")
    private String avatar;

    @ApiModelProperty(value = "用户姓名")
    @TableField("user_name")
    private String userName;

    @ApiModelProperty(value = "账号状态：0-禁用 1-正常")
    @TableField("status")
    private Integer status;

    @ApiModelProperty(value = "用户类型：1-学生 2-商家 3-管理员")
    @TableField("user_type")
    private Integer userType;

    @ApiModelProperty(value = "最后登录时间")
    @TableField("last_login_time")
    private LocalDateTime lastLoginTime;

    @ApiModelProperty(value = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @ApiModelProperty(value = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @ApiModelProperty(value = "逻辑删除：0-未删除 1-已删除")
    @TableField("is_deleted")
    @TableLogic
    private Integer isDeleted;
}