package com.campus.ordering.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("product_spec")
@ApiModel(value = "ProductSpec对象", description = "商品规格表")
public class ProductSpec {

    @ApiModelProperty(value = "规格ID")
    @TableId(value = "spec_id", type = IdType.AUTO)
    private Long specId;

    @ApiModelProperty(value = "所属商品ID")
    @TableField("product_id")
    private Long productId;

    @ApiModelProperty(value = "规格名称（如：少冰、正常冰、大份、小份）")
    @TableField("spec_name")
    private String specName;

    @ApiModelProperty(value = "规格加价/售价")
    @TableField("spec_price")
    private BigDecimal specPrice;

    @ApiModelProperty(value = "规格库存")
    @TableField("stock")
    private Integer stock;

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