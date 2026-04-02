import request from './index'

// 用户
export function getUserList(params) {
  return request({ url: '/admin/user/list', method: 'get', params })
}
export function addUser(data, roleId) {
  return request({ url: '/admin/user/add', method: 'post', data, params: { roleId } })
}
export function updateUser(data, roleId) {
  return request({ url: '/admin/user/update', method: 'put', data, params: { roleId } })
}
export function updateUserStatus(userId, status) {
  return request({ url: '/admin/user/status', method: 'put', params: { userId, status } })
}
export function resetPassword(userId) {
  return request({ url: '/admin/user/reset-password', method: 'put', params: { userId } })
}
export function deleteUser(userId) {
  return request({ url: '/admin/user/delete/' + userId, method: 'delete' })
}

// 店铺
export function getAdminShopList(params) {
  return request({ url: '/admin/shop/list', method: 'get', params })
}
export function auditShop(shopId, auditStatus, auditRemark) {
  return request({ url: '/admin/shop/audit', method: 'put', params: { shopId, auditStatus, auditRemark } })
}
export function updateAdminShopStatus(shopId, status) {
  return request({ url: '/admin/shop/status', method: 'put', params: { shopId, status } })
}

// 商品
export function getAdminProductList(params) {
  return request({ url: '/admin/product/list', method: 'get', params })
}
export function offlineProduct(productId, reason) {
  return request({ url: '/admin/product/offline/' + productId, method: 'put', params: { reason } })
}
export function onlineProduct(productId) {
  return request({ url: '/admin/product/online/' + productId, method: 'put' })
}
export function batchOfflineProduct(productIds, reason) {
  return request({ url: '/admin/product/batch-offline', method: 'put', data: productIds, params: { reason } })
}

// 订单
export function getAdminOrderList(params) {
  return request({ url: '/admin/order/list', method: 'get', params })
}

// 统计
export function getOrderStatistics() {
  return request({ url: '/admin/statistics/order', method: 'get' })
}
export function getShopSalesRank() {
  return request({ url: '/admin/statistics/shop-rank', method: 'get' })
}
export function getOrderTrend(params) {
  return request({ url: '/admin/statistics/order-trend', method: 'get', params })
}

// 系统
export function getOperationLogList(params) {
  return request({ url: '/admin/log/operation/list', method: 'get', params })
}
export function getAnnouncementList(params) {
  return request({ url: '/admin/announcement/list', method: 'get', params })
}
export function addAnnouncement(data) {
  return request({ url: '/admin/announcement/add', method: 'post', data })
}
export function updateAnnouncement(data) {
  return request({ url: '/admin/announcement/update', method: 'put', data })
}
export function updateAnnouncementStatus(announcementId, status) {
  return request({ url: '/admin/announcement/status', method: 'put', params: { announcementId, status } })
}
export function deleteAnnouncement(announcementId) {
  return request({ url: '/admin/announcement/delete/' + announcementId, method: 'delete' })
}

// 系统配置
export function getSystemConfig() {
  return request({ url: '/admin/system/config', method: 'get' })
}
export function saveSystemConfig(data) {
  return request({ url: '/admin/system/config', method: 'post', data })
}