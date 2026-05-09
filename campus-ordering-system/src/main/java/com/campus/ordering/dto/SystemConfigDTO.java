package com.campus.ordering.dto;

import lombok.Data;

@Data
public class SystemConfigDTO {
    private String systemName;
    private String notice;
    private String maxDeliveryFee;
    private String orderTimeout;
}
