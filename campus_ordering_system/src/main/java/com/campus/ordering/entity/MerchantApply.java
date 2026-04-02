package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("merchant_apply")
@ApiModel(value = "MerchantApply 对象", description = "商家入驻申请表")
public class MerchantApply {

    @ApiModelProperty(value = "申请 ID")
    @TableId(value = "apply_id", type = IdType.AUTO)
    private Long applyId;

    @ApiModelProperty(value = "申请人用户 ID")
    @TableField("user_id")
    private Long userId;

    @ApiModelProperty(value = "申请人姓名")
    @TableField("applicant_name")
    private String applicantName;

    @ApiModelProperty(value = "申请人手机号")
    @TableField("applicant_phone")
    private String applicantPhone;

    @ApiModelProperty(value = "申请人身份证号")
    @TableField("applicant_id_card")
    private String applicantIdCard;

    @ApiModelProperty(value = "店铺名称")
    @TableField("shop_name")
    private String shopName;

    @ApiModelProperty(value = "店铺描述")
    @TableField("shop_description")
    private String shopDescription;

    @ApiModelProperty(value = "店铺类型：1-快餐 2-小吃 3-饮品 4-水果 5-超市 6-其他")
    @TableField("shop_type")
    private Integer shopType;

    @ApiModelProperty(value = "预计配送费")
    @TableField("delivery_fee")
    private BigDecimal deliveryFee;

    @ApiModelProperty(value = "营业执照 URL")
    @TableField("business_license")
    private String businessLicense;

    @ApiModelProperty(value = "身份证正面 URL")
    @TableField("id_card_front")
    private String idCardFront;

    @ApiModelProperty(value = "身份证反面 URL")
    @TableField("id_card_back")
    private String idCardBack;

    @ApiModelProperty(value = "审核状态：0-待审核 1-已通过 2-已拒绝")
    @TableField("audit_status")
    private Integer auditStatus;

    @ApiModelProperty(value = "审核意见")
    @TableField("audit_remark")
    private String auditRemark;

    @ApiModelProperty(value = "审核人 ID")
    @TableField("audit_user_id")
    private Long auditUserId;

    @ApiModelProperty(value = "审核时间")
    @TableField("audit_time")
    private LocalDateTime auditTime;

    @ApiModelProperty(value = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @ApiModelProperty(value = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @ApiModelProperty(value = "逻辑删除：0-未删除 1-已删除")
    @TableField("is_deleted")
    @TableLogic
    private Integer isDeleted;
}
