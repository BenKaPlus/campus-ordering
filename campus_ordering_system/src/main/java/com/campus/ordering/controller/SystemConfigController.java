package com.campus.ordering.controller;

import com.campus.ordering.common.Result;
import com.campus.ordering.dto.SystemConfigDTO;
import com.campus.ordering.service.SysConfigService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/admin/system")
@Api(tags = "系统配置接口")
@PreAuthorize("hasRole('ADMIN')")
public class SystemConfigController {

    @Resource
    private SysConfigService sysConfigService;

    @GetMapping("/config")
    @ApiOperation("获取系统配置")
    public Result<SystemConfigDTO> getSystemConfig() {
        SystemConfigDTO dto = new SystemConfigDTO();
        dto.setSystemName(sysConfigService.getConfigValue("system.name", "校园点餐系统"));
        dto.setNotice(sysConfigService.getConfigValue("system.notice", ""));
        dto.setMaxDeliveryFee(sysConfigService.getConfigValue("max.delivery.fee", "10"));
        dto.setOrderTimeout(sysConfigService.getConfigValue("order.expire.minutes", "30"));
        return Result.success(dto);
    }

    @PostMapping("/config")
    @ApiOperation("保存系统配置")
    public Result<Void> saveSystemConfig(@RequestBody SystemConfigDTO dto) {
        Map<String, String> configMap = new HashMap<>();
        configMap.put("system.name", dto.getSystemName());
        configMap.put("system.notice", dto.getNotice());
        configMap.put("max.delivery.fee", dto.getMaxDeliveryFee());
        configMap.put("order.expire.minutes", dto.getOrderTimeout());
        sysConfigService.batchUpdateConfig(configMap);
        return Result.success();
    }
}
