package com.campus.ordering.service;

import com.campus.ordering.entity.UserAddress;
import java.util.List;

public interface UserAddressService {
    /**
     * 获取用户收货地址列表
     */
    List<UserAddress> getAddressList(Long userId);

    /**
     * 新增收货地址
     */
    void addAddress(UserAddress address);

    /**
     * 更新收货地址
     */
    void updateAddress(UserAddress address, Long userId);

    /**
     * 删除收货地址
     */
    void deleteAddress(Long addressId, Long userId);

    /**
     * 设置默认收货地址
     */
    void setDefaultAddress(Long addressId, Long userId);
}
