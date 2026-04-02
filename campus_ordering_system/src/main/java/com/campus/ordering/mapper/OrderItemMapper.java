package com.campus.ordering.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.campus.ordering.entity.OrderItem;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface OrderItemMapper extends BaseMapper<OrderItem> {
    void batchInsert(List<OrderItem> itemList);
}