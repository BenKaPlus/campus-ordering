import request from './index'

// 创建评价
export function createReview(data) {
  return request({ url: '/student/review/create', method: 'post', data })
}

// 根据订单ID获取评价
export function getReviewByOrderId(orderId) {
  return request({ url: '/student/review/order/' + orderId, method: 'get' })
}

// 获取店铺评价列表（公开）
export function getShopReviews(shopId) {
  return request({ url: '/common/review/shop/' + shopId, method: 'get' })
}

// 获取店铺评价统计（公开）
export function getShopReviewSummary(shopId) {
  return request({ url: '/common/review/shop/' + shopId + '/summary', method: 'get' })
}

// 商家获取店铺评价列表
export function getMerchantShopReviews() {
  return request({ url: '/merchant/review/list', method: 'get' })
}

// 商家获取店铺评价统计
export function getMerchantShopReviewSummary() {
  return request({ url: '/merchant/review/summary', method: 'get' })
}

// 回复评价
export function replyReview(data) {
  return request({ url: '/merchant/review/reply', method: 'post', data })
}
