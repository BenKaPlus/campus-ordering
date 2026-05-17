package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

@Data
@ApiModel(value = "MerchantSettleDTO", description = "商家入驻申请请求（已登录用户）")
public class MerchantSettleDTO {

    @NotBlank(message = "店铺名称不能为空")
    @ApiModelProperty(value = "店铺名称", required = true)
    private String shopName;

    @ApiModelProperty(value = "店铺描述")
    private String shopDescription;

    @NotNull(message = "店铺类型不能为空")
    @ApiModelProperty(value = "店铺类型：1-快餐 2-小吃 3-饮品 4-水果 5-超市 6-其他", required = true)
    private Integer shopType;

    @ApiModelProperty(value = "预计配送费")
    private BigDecimal deliveryFee;

    @ApiModelProperty(value = "营业执照 URL")
    private String businessLicense;

    @NotBlank(message = "身份证号码不能为空")
    @ApiModelProperty(value = "身份证号码", required = true)
    private String applicantIdCard;

    @ApiModelProperty(value = "身份证正面 URL")
    private String idCardFront;

    @ApiModelProperty(value = "身份证反面 URL")
    private String idCardBack;
}