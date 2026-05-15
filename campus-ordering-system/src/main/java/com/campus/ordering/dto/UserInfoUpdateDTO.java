package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel(description = "用户信息更新DTO")
public class UserInfoUpdateDTO {

    @ApiModelProperty(value = "手机号")
    private String phone;

    @ApiModelProperty(value = "用户姓名")
    private String userName;

    @ApiModelProperty(value = "头像URL")
    private String avatar;
}
