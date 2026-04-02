import request from './index'

// 店铺
export function getShopDetail() {
  return request({ url: '/merchant/shop/detail', method: 'get' })
}
export function updateShopStatus(status) {
  return request({ url: '/merchant/shop/status/update', method: 'put', params: { status } })
}
export function updateShopInfo(data) {
  return request({ url: '/merchant/shop/update', method: 'put', data })
}

// 商品
export function getProductList(params) {
  return request({ url: '/merchant/product/list', method: 'get', params })
}
export function addProduct(data) {
  return request({ url: '/merchant/product/add', method: 'post', data })
}
export function updateProduct(data) {
  return request({ url: '/merchant/product/update', method: 'put', data })
}
export function updateProductStatus(productId, status) {
  return request({ url: '/merchant/product/status/update', method: 'put', params: { productId, status } })
}
export function deleteProduct(productId) {
  return request({ url: '/merchant/product/delete/' + productId, method: 'delete' })
}

// 订单
export function getMerchantOrderList(params) {
  return request({ url: '/merchant/order/list', method: 'get', params })
}
export function acceptOrder(orderId) {
  return request({ url: '/merchant/order/accept/' + orderId, method: 'put' })
}
export function rejectOrder(orderId, rejectReason) {
  return request({ url: '/merchant/order/reject/' + orderId, method: 'put', params: { rejectReason } })
}
export function updateOrderStatus(orderId, status) {
  return request({ url: '/merchant/order/status/' + orderId, method: 'put', params: { status } })
}

// 统计
export function getStatistics() {
  return request({ url: '/merchant/statistics', method: 'get' })
}