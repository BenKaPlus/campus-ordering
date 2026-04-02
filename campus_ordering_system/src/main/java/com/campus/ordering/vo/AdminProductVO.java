package com.campus.ordering.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@ApiModel(value = "AdminProductVO 对象", description = "管理员端商品信息视图对象")
public class AdminProductVO {

    @ApiModelProperty(value = "商品 ID")
    private Long productId;

    @ApiModelProperty(value = "商品名称")
    private String productName;

    @ApiModelProperty(value = "商品主图 URL")
    private String productImage;

    @ApiModelProperty(value = "所属店铺 ID")
    private Long shopId;

    @ApiModelProperty(value = "所属店铺名称")
    private String shopName;

    @ApiModelProperty(value = "商品售价")
    private BigDecimal productPrice;

    @ApiModelProperty(value = "商品状态：0-下架 1-上架")
    private Integer status;

    @ApiModelProperty(value = "月销量")
    private Integer monthlySales;

    @ApiModelProperty(value = "创建时间")
    private LocalDateTime createTime;
}
