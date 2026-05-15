package com.campus.ordering.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.campus.ordering.dto.OrderReviewDTO;
import com.campus.ordering.dto.ReviewReplyDTO;
import com.campus.ordering.entity.OrderReview;
import com.campus.ordering.vo.OrderReviewVO;

import java.util.List;
import java.util.Map;

public interface OrderReviewService extends IService<OrderReview> {

    void createReview(Long userId, OrderReviewDTO reviewDTO);

    OrderReviewVO getReviewByOrderId(Long orderId);

    List<OrderReviewVO> getShopReviews(Long shopId);

    void replyReview(Long userId, ReviewReplyDTO replyDTO);

    Map<String, Object> getShopReviewSummary(Long shopId);
}
