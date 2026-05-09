package com.campus.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.entity.UserAddress;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.mapper.UserAddressMapper;
import com.campus.ordering.service.UserAddressService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class UserAddressServiceImpl implements UserAddressService {

    @Resource
    private UserAddressMapper userAddressMapper;

    @Override
    public List<UserAddress> getAddressList(Long userId) {
        LambdaQueryWrapper<UserAddress> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserAddress::getUserId, userId);
        wrapper.eq(UserAddress::getIsDeleted, 0);
        wrapper.orderByDesc(UserAddress::getIsDefault);
        wrapper.orderByDesc(UserAddress::getCreateTime);
        return userAddressMapper.selectList(wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addAddress(UserAddress address) {
        if (address.getUserId() == null) {
            throw new BusinessException(ResultCode.ERROR, "用户 ID 不能为空");
        }

        if (address.getReceiverName() == null || address.getReceiverPhone() == null) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "收货人和手机号不能为空");
        }

        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            LambdaQueryWrapper<UserAddress> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(UserAddress::getUserId, address.getUserId());
            wrapper.eq(UserAddress::getIsDefault, 1);
            wrapper.eq(UserAddress::getIsDeleted, 0);
            UserAddress existDefault = userAddressMapper.selectOne(wrapper);
            if (existDefault != null) {
                existDefault.setIsDefault(0);
                existDefault.setUpdateTime(LocalDateTime.now());
                userAddressMapper.updateById(existDefault);
            }
        }

        address.setIsDeleted(0);
        address.setCreateTime(LocalDateTime.now());
        address.setUpdateTime(LocalDateTime.now());
        userAddressMapper.insert(address);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateAddress(UserAddress address, Long userId) {
        UserAddress existing = userAddressMapper.selectById(address.getAddressId());
        if (existing == null || !existing.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.ERROR, "地址不存在");
        }

        if (address.getReceiverName() != null) {
            existing.setReceiverName(address.getReceiverName());
        }
        if (address.getReceiverPhone() != null) {
            existing.setReceiverPhone(address.getReceiverPhone());
        }
        if (address.getCampusArea() != null) {
            existing.setCampusArea(address.getCampusArea());
        }
        if (address.getAddressDetail() != null) {
            existing.setAddressDetail(address.getAddressDetail());
        }
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            // 取消其他默认地址
            LambdaQueryWrapper<UserAddress> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(UserAddress::getUserId, userId)
                   .eq(UserAddress::getIsDefault, 1)
                   .eq(UserAddress::getIsDeleted, 0)
                   .ne(UserAddress::getAddressId, address.getAddressId());
            UserAddress existDefault = userAddressMapper.selectOne(wrapper);
            if (existDefault != null) {
                existDefault.setIsDefault(0);
                existDefault.setUpdateTime(LocalDateTime.now());
                userAddressMapper.updateById(existDefault);
            }
            existing.setIsDefault(1);
        }
        existing.setUpdateTime(LocalDateTime.now());
        userAddressMapper.updateById(existing);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteAddress(Long addressId, Long userId) {
        UserAddress address = userAddressMapper.selectById(addressId);
        if (address == null || !address.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.ERROR, "地址不存在");
        }
        address.setIsDeleted(1);
        address.setUpdateTime(LocalDateTime.now());
        userAddressMapper.updateById(address);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void setDefaultAddress(Long addressId, Long userId) {
        // 取消该用户所有默认地址
        LambdaQueryWrapper<UserAddress> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserAddress::getUserId, userId)
               .eq(UserAddress::getIsDefault, 1)
               .eq(UserAddress::getIsDeleted, 0);
        List<UserAddress> addresses = userAddressMapper.selectList(wrapper);
        for (UserAddress address : addresses) {
            address.setIsDefault(0);
            address.setUpdateTime(LocalDateTime.now());
            userAddressMapper.updateById(address);
        }

        // 设置新的默认地址
        UserAddress target = userAddressMapper.selectById(addressId);
        if (target == null || !target.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.ERROR, "地址不存在");
        }
        target.setIsDefault(1);
        target.setUpdateTime(LocalDateTime.now());
        userAddressMapper.updateById(target);
    }
}
