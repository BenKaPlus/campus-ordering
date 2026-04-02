package com.campus.ordering.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@ApiModel(value = "AdminShopVO 对象", description = "管理员端店铺信息视图对象")
public class AdminShopVO {

    @ApiModelProperty(value = "店铺 ID")
    private Long shopId;

    @ApiModelProperty(value = "店铺名称")
    private String shopName;

    @ApiModelProperty(value = "店主姓名")
    private String ownerName;

    @ApiModelProperty(value = "店主手机号")
    private String phone;

    @ApiModelProperty(value = "店铺联系电话")
    private String contactPhone;

    @ApiModelProperty(value = "店铺状态：0-待审核 1-营业中 2-已打烊 3-审核驳回 4-已禁用")
    private Integer status;

    @ApiModelProperty(value = "审核状态：0-待审核 1-审核通过 2-审核驳回")
    private Integer auditStatus;

    @ApiModelProperty(value = "配送费")
    private BigDecimal deliveryFee;

    @ApiModelProperty(value = "起送金额")
    private BigDecimal minOrderAmount;

    @ApiModelProperty(value = "店铺评分")
    private BigDecimal shopScore;

    @ApiModelProperty(value = "月销量")
    private Integer monthlySales;

    @ApiModelProperty(value = "店铺简介")
    private String shopDesc;

    @ApiModelProperty(value = "创建时间")
    private LocalDateTime createTime;
}
