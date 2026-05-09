package com.campus.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.campus.ordering.common.CacheConstants;
import com.campus.ordering.entity.SysConfig;
import com.campus.ordering.mapper.SysConfigMapper;
import com.campus.ordering.service.SysConfigService;
import com.campus.ordering.utils.RedisCacheUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
public class SysConfigServiceImpl extends ServiceImpl<SysConfigMapper, SysConfig> implements SysConfigService {

    @Resource
    private RedisCacheUtil redisCacheUtil;

    @Override
    public String getConfigValue(String key) {
        return getConfigValue(key, null);
    }

    @Override
    public String getConfigValue(String key, String defaultValue) {
        String cacheKey = CacheConstants.SYS_CONFIG_VALUE + key;
        String cachedValue = redisCacheUtil.get(cacheKey, String.class);
        if (cachedValue != null) {
            return cachedValue;
        }
        SysConfig config = baseMapper.selectByKey(key);
        if (config != null) {
            redisCacheUtil.set(cacheKey, config.getConfigValue(), CacheConstants.CACHE_TIME_1_HOUR, TimeUnit.MINUTES);
            return config.getConfigValue();
        }
        return defaultValue;
    }

    @Override
    @Transactional
    public void updateConfigValue(String key, String value) {
        SysConfig config = baseMapper.selectByKey(key);
        if (config != null) {
            config.setConfigValue(value);
            updateById(config);
        } else {
            config = new SysConfig();
            config.setConfigKey(key);
            config.setConfigValue(value);
            config.setConfigName(key);
            save(config);
        }
        deleteCache();
    }

    @Override
    public Map<String, String> getAllConfigMap() {
        Map<String, String> cachedMap = redisCacheUtil.get(CacheConstants.SYS_CONFIG_ALL, 
            new com.fasterxml.jackson.core.type.TypeReference<Map<String, String>>() {});
        if (cachedMap != null) {
            return cachedMap;
        }
        Map<String, String> result = new HashMap<>();
        LambdaQueryWrapper<SysConfig> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysConfig::getIsDeleted, 0);
        List<SysConfig> list = list(wrapper);
        for (SysConfig config : list) {
            result.put(config.getConfigKey(), config.getConfigValue());
        }
        redisCacheUtil.set(CacheConstants.SYS_CONFIG_ALL, result, CacheConstants.CACHE_TIME_1_HOUR, TimeUnit.MINUTES);
        return result;
    }

    @Override
    @Transactional
    public void batchUpdateConfig(Map<String, String> configMap) {
        for (Map.Entry<String, String> entry : configMap.entrySet()) {
            updateConfigValue(entry.getKey(), entry.getValue());
        }
        deleteCache();
    }

    private void deleteCache() {
        redisCacheUtil.delete(CacheConstants.SYS_CONFIG_ALL);
        redisCacheUtil.deleteByPattern(CacheConstants.SYS_CONFIG_VALUE + "*");
    }
}
