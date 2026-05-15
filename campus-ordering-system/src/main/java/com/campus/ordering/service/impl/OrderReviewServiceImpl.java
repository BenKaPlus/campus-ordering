package com.campus.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.dto.OrderReviewDTO;
import com.campus.ordering.dto.ReviewReplyDTO;
import com.campus.ordering.entity.OrderInfo;
import com.campus.ordering.entity.OrderReview;
import com.campus.ordering.entity.OrderReviewReply;
import com.campus.ordering.entity.SysUser;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.mapper.OrderInfoMapper;
import com.campus.ordering.mapper.OrderReviewMapper;
import com.campus.ordering.mapper.OrderReviewReplyMapper;
import com.campus.ordering.mapper.SysUserMapper;
import com.campus.ordering.service.OrderReviewService;
import com.campus.ordering.vo.OrderReviewReplyVO;
import com.campus.ordering.vo.OrderReviewVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class OrderReviewServiceImpl extends ServiceImpl<OrderReviewMapper, OrderReview> implements OrderReviewService {

    @Autowired
    private OrderInfoMapper orderInfoMapper;

    @Autowired
    private OrderReviewReplyMapper orderReviewReplyMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createReview(Long userId, OrderReviewDTO reviewDTO) {
        OrderInfo orderInfo = orderInfoMapper.selectById(reviewDTO.getOrderId());
        if (orderInfo == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_FOUND);
        }
        if (!orderInfo.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.FORBIDDEN, "无权评价此订单");
        }
        if (orderInfo.getOrderStatus() != 5) {
            throw new BusinessException(ResultCode.ORDER_STATUS_ERROR, "只有已完成的订单才能评价");
        }

        LambdaQueryWrapper<OrderReview> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(OrderReview::getOrderId, reviewDTO.getOrderId());
        OrderReview existReview = this.getOne(queryWrapper);
        if (existReview != null) {
            throw new BusinessException(ResultCode.ERROR, "该订单已评价过");
        }

        OrderReview review = new OrderReview();
        BeanUtils.copyProperties(reviewDTO, review);
        review.setUserId(userId);
        review.setShopId(orderInfo.getShopId());
        BigDecimal avgRating = BigDecimal.valueOf(reviewDTO.getServiceRating() + reviewDTO.getDeliveryRating() + reviewDTO.getProductRating())
                .divide(BigDecimal.valueOf(3), 1, RoundingMode.HALF_UP);
        review.setOverallRating(avgRating);

        this.save(review);

        orderInfo.setIsReviewed(1);
        orderInfoMapper.updateById(orderInfo);
    }

    @Override
    public OrderReviewVO getReviewByOrderId(Long orderId) {
        LambdaQueryWrapper<OrderReview> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(OrderReview::getOrderId, orderId);
        OrderReview review = this.getOne(queryWrapper);
        if (review == null) {
            return null;
        }
        return convertToVO(review);
    }

    @Override
    public List<OrderReviewVO> getShopReviews(Long shopId) {
        LambdaQueryWrapper<OrderReview> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(OrderReview::getShopId, shopId)
                .orderByDesc(OrderReview::getCreateTime);
        List<OrderReview> reviewList = this.list(queryWrapper);
        if (reviewList.isEmpty()) {
            return new ArrayList<>();
        }
        return reviewList.stream().map(this::convertToVO).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void replyReview(Long userId, ReviewReplyDTO replyDTO) {
        OrderReview review = this.getById(replyDTO.getReviewId());
        if (review == null) {
            throw new BusinessException(ResultCode.ERROR, "评价不存在");
        }

        OrderReviewReply reply = new OrderReviewReply();
        reply.setReviewId(replyDTO.getReviewId());
        reply.setReplyUserId(userId);
        reply.setReplyText(replyDTO.getReplyText());
        orderReviewReplyMapper.insert(reply);
    }

    private OrderReviewVO convertToVO(OrderReview review) {
        OrderReviewVO vo = new OrderReviewVO();
        BeanUtils.copyProperties(review, vo);

        if (review.getIsAnonymous() != 1) {
            SysUser user = sysUserMapper.selectById(review.getUserId());
            if (user != null) {
                vo.setUserName(user.getUserName());
                vo.setUserAvatar(user.getAvatar());
            }
        } else {
            vo.setUserName("匿名用户");
        }

        LambdaQueryWrapper<OrderReviewReply> replyQueryWrapper = new LambdaQueryWrapper<>();
        replyQueryWrapper.eq(OrderReviewReply::getReviewId, review.getReviewId())
                .orderByAsc(OrderReviewReply::getCreateTime);
        List<OrderReviewReply> replyList = orderReviewReplyMapper.selectList(replyQueryWrapper);

        if (!replyList.isEmpty()) {
            List<OrderReviewReplyVO> replyVOList = new ArrayList<>();
            List<Long> replyUserIds = replyList.stream().map(OrderReviewReply::getReplyUserId).collect(Collectors.toList());
            List<SysUser> replyUsers = sysUserMapper.selectBatchIds(replyUserIds);
            Map<Long, String> userNameMap = replyUsers.stream()
                    .collect(Collectors.toMap(SysUser::getUserId, SysUser::getUserName));

            for (OrderReviewReply reply : replyList) {
                OrderReviewReplyVO replyVO = new OrderReviewReplyVO();
                BeanUtils.copyProperties(reply, replyVO);
                replyVO.setReplyUserName(userNameMap.get(reply.getReplyUserId()));
                replyVOList.add(replyVO);
            }
            vo.setReplyList(replyVOList);
        }

        return vo;
    }

    @Override
    public Map<String, Object> getShopReviewSummary(Long shopId) {
        System.out.println("开始查询店铺 " + shopId + " 的评价统计");
        LambdaQueryWrapper<OrderReview> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(OrderReview::getShopId, shopId);
        List<OrderReview> reviewList = this.list(queryWrapper);
        System.out.println("查询到 " + reviewList.size() + " 条评价");

        Map<String, Object> summary = new HashMap<>();
        if (reviewList.isEmpty()) {
            summary.put("totalCount", 0);
            summary.put("overallRating", BigDecimal.ZERO);
            summary.put("avgServiceRating", BigDecimal.ZERO);
            summary.put("avgDeliveryRating", BigDecimal.ZERO);
            summary.put("avgProductRating", BigDecimal.ZERO);
        } else {
            summary.put("totalCount", reviewList.size());

            BigDecimal totalOverall = reviewList.stream()
                    .map(OrderReview::getOverallRating)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            summary.put("overallRating", totalOverall.divide(
                    BigDecimal.valueOf(reviewList.size()), 1, RoundingMode.HALF_UP));

            BigDecimal totalService = reviewList.stream()
                    .map(r -> BigDecimal.valueOf(r.getServiceRating()))
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            summary.put("avgServiceRating", totalService.divide(
                    BigDecimal.valueOf(reviewList.size()), 1, RoundingMode.HALF_UP));

            BigDecimal totalDelivery = reviewList.stream()
                    .map(r -> BigDecimal.valueOf(r.getDeliveryRating()))
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            summary.put("avgDeliveryRating", totalDelivery.divide(
                    BigDecimal.valueOf(reviewList.size()), 1, RoundingMode.HALF_UP));

            BigDecimal totalProduct = reviewList.stream()
                    .map(r -> BigDecimal.valueOf(r.getProductRating()))
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            summary.put("avgProductRating", totalProduct.divide(
                    BigDecimal.valueOf(reviewList.size()), 1, RoundingMode.HALF_UP));
        }
        System.out.println("返回的统计数据: " + summary);

        return summary;
    }
}
