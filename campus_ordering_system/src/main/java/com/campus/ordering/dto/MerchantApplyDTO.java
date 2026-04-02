package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.math.BigDecimal;

@Data
@ApiModel(value = "MerchantApplyDTO", description = "商家入驻申请请求")
public class MerchantApplyDTO {

    @NotBlank(message = "账号不能为空")
    @ApiModelProperty(value = "登录账号", required = true)
    private String userNo;

    @NotBlank(message = "密码不能为空")
    @ApiModelProperty(value = "密码", required = true)
    private String password;

    @NotBlank(message = "手机号不能为空")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    @ApiModelProperty(value = "手机号", required = true)
    private String phone;

    @NotBlank(message = "真实姓名不能为空")
    @ApiModelProperty(value = "真实姓名", required = true)
    private String userName;

    @NotBlank(message = "店铺名称不能为空")
    @ApiModelProperty(value = "店铺名称", required = true)
    private String shopName;

    @ApiModelProperty(value = "店铺描述")
    private String shopDescription;

    @NotBlank(message = "店铺类型不能为空")
    @ApiModelProperty(value = "店铺类型：1-快餐 2-小吃 3-饮品 4-水果 5-超市 6-其他", required = true)
    private Integer shopType;

    @ApiModelProperty(value = "预计配送费")
    private BigDecimal deliveryFee;

    @ApiModelProperty(value = "营业执照 URL")
    private String businessLicense;

    @ApiModelProperty(value = "身份证正面 URL")
    private String idCardFront;

    @ApiModelProperty(value = "身份证反面 URL")
    private String idCardBack;

    @ApiModelProperty(value = "验证码 UUID")
    private String uuid;

    @NotBlank(message = "验证码不能为空")
    @ApiModelProperty(value = "验证码", required = true)
    private String captcha;
}
