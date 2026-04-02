package com.campus.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.campus.ordering.entity.SysConfig;
import com.campus.ordering.mapper.SysConfigMapper;
import com.campus.ordering.service.SysConfigService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SysConfigServiceImpl extends ServiceImpl<SysConfigMapper, SysConfig> implements SysConfigService {

    @Override
    public String getConfigValue(String key) {
        return getConfigValue(key, null);
    }

    @Override
    public String getConfigValue(String key, String defaultValue) {
        SysConfig config = baseMapper.selectByKey(key);
        return config != null ? config.getConfigValue() : defaultValue;
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
    }

    @Override
    public Map<String, String> getAllConfigMap() {
        Map<String, String> result = new HashMap<>();
        LambdaQueryWrapper<SysConfig> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysConfig::getIsDeleted, 0);
        List<SysConfig> list = list(wrapper);
        for (SysConfig config : list) {
            result.put(config.getConfigKey(), config.getConfigValue());
        }
        return result;
    }

    @Override
    @Transactional
    public void batchUpdateConfig(Map<String, String> configMap) {
        for (Map.Entry<String, String> entry : configMap.entrySet()) {
            updateConfigValue(entry.getKey(), entry.getValue());
        }
    }
}
