package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import javax.validation.constraints.NotBlank;

@Data
@ApiModel(value = "登录入参")
public class LoginDTO {

    @NotBlank(message = "账号不能为空")
    @ApiModelProperty(value = "登录账号", required = true)
    private String userNo;

    @NotBlank(message = "密码不能为空")
    @ApiModelProperty(value = "密码", required = true)
    private String password;

    @NotBlank(message = "验证码不能为空")
    @ApiModelProperty(value = "图形验证码", required = true)
    private String captcha;

    @NotBlank(message = "验证码标识不能为空")
    @ApiModelProperty(value = "验证码唯一标识", required = true)
    private String uuid;
}