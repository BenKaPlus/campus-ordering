package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("user_address")
@ApiModel(value = "UserAddress对象", description = "用户收货地址表")
public class UserAddress {

    @ApiModelProperty(value = "地址ID")
    @TableId(value = "address_id", type = IdType.AUTO)
    private Long addressId;

    @ApiModelProperty(value = "关联用户ID")
    @TableField("user_id")
    private Long userId;

    @ApiModelProperty(value = "收货人姓名")
    @TableField("receiver_name")
    private String receiverName;

    @ApiModelProperty(value = "收货人手机号")
    @TableField("receiver_phone")
    private String receiverPhone;

    @ApiModelProperty(value = "校区/园区")
    @TableField("campus_area")
    private String campusArea;

    @ApiModelProperty(value = "详细地址（如：XX宿舍楼XX室）")
    @TableField("address_detail")
    private String addressDetail;

    @ApiModelProperty(value = "是否默认地址：0-否 1-是")
    @TableField("is_default")
    private Integer isDefault;

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