package com.campus.ordering.dto;

import lombok.Data;
import java.util.List;

@Data
public class OrderDeleteDTO {
    private List<Long> orderIds;
}