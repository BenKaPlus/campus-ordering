package com.campus.ordering.vo;

import com.campus.ordering.entity.ProductInfo;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.util.List;

@Data
@ApiModel(value = "ProductPageVO 对象", description = "商品分页查询响应视图对象")
public class ProductPageVO {

    @ApiModelProperty(value = "商品列表")
    private List<ProductInfo> records;

    @ApiModelProperty(value = "总记录数")
    private long total;

    @ApiModelProperty(value = "每页大小")
    private long size;

    @ApiModelProperty(value = "当前页码")
    private long current;
}