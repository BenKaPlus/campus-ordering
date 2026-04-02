package com.campus.ordering.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.campus.ordering.entity.MerchantApply;

public interface MerchantApplyService {
    /**
     * 获取商家申请列表
     */
    IPage<MerchantApply> getApplyList(Integer auditStatus, Integer page, Integer size);

    /**
     * 审核商家申请
     */
    void auditApply(Long applyId, Integer auditStatus, String auditRemark);
}
