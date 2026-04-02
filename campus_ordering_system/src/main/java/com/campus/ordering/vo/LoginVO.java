package com.campus.ordering.vo;


import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel(value = "登录响应VO")
public class LoginVO {

    @ApiModelProperty(value = "访问令牌")
    private String token;

    @ApiModelProperty(value = "刷新令牌")
    private String refreshToken;

    @ApiModelProperty(value = "令牌有效期(秒)")
    private Long expiresIn;

    @ApiModelProperty(value = "用户信息")
    private UserInfoVO userInfo;

    @ApiModelProperty(value = "角色信息")
    private RoleInfoVO roleInfo;
}