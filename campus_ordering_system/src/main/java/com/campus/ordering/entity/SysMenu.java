package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sys_menu")
@ApiModel(value = "SysMenu对象", description = "系统菜单权限表")
public class SysMenu {

    @ApiModelProperty(value = "菜单/权限ID")
    @TableId(value = "menu_id", type = IdType.AUTO)
    private Long menuId;

    @ApiModelProperty(value = "父菜单ID，顶级菜单为0")
    @TableField("parent_id")
    private Long parentId;

    @ApiModelProperty(value = "菜单/权限名称")
    @TableField("menu_name")
    private String menuName;

    @ApiModelProperty(value = "权限标识（如：merchant:product:add）")
    @TableField("permission")
    private String permission;

    @ApiModelProperty(value = "类型：0-目录 1-菜单 2-按钮")
    @TableField("menu_type")
    private Integer menuType;

    @ApiModelProperty(value = "路由路径")
    @TableField("path")
    private String path;

    @ApiModelProperty(value = "菜单图标")
    @TableField("icon")
    private String icon;

    @ApiModelProperty(value = "排序号")
    @TableField("sort")
    private Integer sort;

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