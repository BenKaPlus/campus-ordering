package com.campus.ordering.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.campus.ordering.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SysUserMapper extends BaseMapper<SysUser> {
    
    @Select("SELECT * FROM sys_user WHERE user_no = #{userNo} AND is_deleted = 0")
    SysUser selectByUserNo(String userNo);
}