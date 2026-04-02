package com.campus.ordering.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.campus.ordering.entity.SysConfig;

import java.util.Map;

public interface SysConfigService extends IService<SysConfig> {

    String getConfigValue(String key);

    String getConfigValue(String key, String defaultValue);

    void updateConfigValue(String key, String value);

    Map<String, String> getAllConfigMap();

    void batchUpdateConfig(Map<String, String> configMap);
}
