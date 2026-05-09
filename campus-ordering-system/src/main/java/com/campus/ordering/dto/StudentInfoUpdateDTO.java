package com.campus.ordering.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel(description = "学生信息更新DTO")
public class StudentInfoUpdateDTO {

    @ApiModelProperty(value = "手机号")
    private String phone;

    @ApiModelProperty(value = "用户姓名")
    private String userName;

    @ApiModelProperty(value = "学号")
    private String studentNo;

    @ApiModelProperty(value = "所属学院")
    private String college;

    @ApiModelProperty(value = "所属专业")
    private String major;

    @ApiModelProperty(value = "年级")
    private String grade;

    @ApiModelProperty(value = "宿舍地址")
    private String dormitory;
}
