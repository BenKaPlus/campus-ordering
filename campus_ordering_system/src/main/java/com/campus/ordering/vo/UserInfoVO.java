package com.campus.ordering.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

@Data
@ApiModel(value = "用户信息 VO")
public class UserInfoVO {

    @ApiModelProperty(value = "用户 ID")
    private Long userId;

    @ApiModelProperty(value = "用户编号/学号")
    private String userNo;

    @ApiModelProperty(value = "用户姓名")
    private String userName;

    @ApiModelProperty(value = "手机号")
    private String phone;

    @ApiModelProperty(value = "用户头像 URL")
    private String avatar;

    @ApiModelProperty(value = "账号状态：0-禁用 1-正常")
    private Integer status;

    @ApiModelProperty(value = "角色列表")
    private List<String> roles;
}
