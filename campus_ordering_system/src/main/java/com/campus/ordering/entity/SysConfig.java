package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sys_config")
@ApiModel(value = "SysConfig对象", description = "系统参数配置表")
public class SysConfig {

    @ApiModelProperty(value = "配置ID")
    @TableId(value = "config_id", type = IdType.AUTO)
    private Long configId;

    @ApiModelProperty(value = "配置键名")
    @TableField("config_key")
    private String configKey;

    @ApiModelProperty(value = "配置键值")
    @TableField("config_value")
    private String configValue;

    @ApiModelProperty(value = "配置名称")
    @TableField("config_name")
    private String configName;

    @ApiModelProperty(value = "配置描述")
    @TableField("config_desc")
    private String configDesc;

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
