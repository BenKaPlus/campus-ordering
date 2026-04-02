package com.campus.ordering.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.campus.ordering.entity.OrderInfo;
import com.campus.ordering.vo.AdminOrderVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface OrderInfoMapper extends BaseMapper<OrderInfo> {

    /**
     * 管理员查询订单列表（关联用户和店铺信息）
     * 支持按状态筛选和关键词搜索（订单号、用户名、店铺名）
     */
    IPage<AdminOrderVO> selectAdminOrderPage(Page<AdminOrderVO> page, 
                                               @Param("status") Integer status, 
                                               @Param("keyword") String keyword);
}
