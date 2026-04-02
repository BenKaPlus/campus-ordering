package com.campus.ordering.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel(value = "角色信息 VO")
public class RoleInfoVO {

    @ApiModelProperty(value = "角色 ID")
    private Long roleId;

    @ApiModelProperty(value = "角色编码")
    private String roleCode;

    @ApiModelProperty(value = "角色名称")
    private String roleName;

    @ApiModelProperty(value = "角色描述")
    private String roleDesc;
}
