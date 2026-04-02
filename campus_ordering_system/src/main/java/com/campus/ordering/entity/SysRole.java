package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sys_role")
@ApiModel(value = "SysRole对象", description = "系统角色表")
public class SysRole {

    @ApiModelProperty(value = "角色唯一ID")
    @TableId(value = "role_id", type = IdType.AUTO)
    private Long roleId;

    @ApiModelProperty(value = "角色编码：STUDENT-学生 MERCHANT-商家 ADMIN-管理员")
    @TableField("role_code")
    private String roleCode;

    @ApiModelProperty(value = "角色名称")
    @TableField("role_name")
    private String roleName;

    @ApiModelProperty(value = "角色描述")
    @TableField("role_desc")
    private String roleDesc;

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