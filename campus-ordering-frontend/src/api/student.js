import request from './index'

// 购物车
export function addCart(data) {
  return request({ url: '/student/cart/add', method: 'post', data })
}
export function getCartList() {
  return request({ url: '/student/cart/list', method: 'get' })
}
export function updateCartNum(cartId, num) {
  return request({ url: '/student/cart/update/num', method: 'put', params: { cartId, num } })
}
export function deleteCart(cartIds) {
  return request({ url: '/student/cart/delete', method: 'post', data: cartIds })
}

// 订单
export function createOrder(data) {
  return request({ url: '/student/order/create', method: 'post', data })
}
export function getSettleInfo(cartIds) {
  return request({ url: '/student/order/settle', method: 'post', data: { cartIds } })
}
export function cancelOrder(orderId) {
  return request({ url: '/student/order/cancel/' + orderId, method: 'put' })
}
export function getOrderList(params) {
  return request({ url: '/student/order/list', method: 'get', params })
}
export function getOrderDetail(orderId) {
  return request({ url: '/student/order/detail/' + orderId, method: 'get' })
}
export function getWxPayParams(orderNo) {
  return request({ url: '/student/order/pay/' + orderNo, method: 'get' })
}
export function updateOrderStatus(orderId, status) {
  return request({ url: '/student/order/status/' + orderId, method: 'put', params: { status } })
}

// 收货地址
export function getAddressList() {
  return request({ url: '/student/address/list', method: 'get' })
}
export function addAddress(data) {
  return request({ url: '/student/address/add', method: 'post', data })
}
export function updateAddress(data) {
  return request({ url: '/student/address/update', method: 'put', data })
}
export function deleteAddress(addressId) {
  return request({ url: '/student/address/delete/' + addressId, method: 'delete' })
}
export function setDefaultAddress(addressId) {
  return request({ url: '/student/address/default/' + addressId, method: 'put' })
}

// 个人信息
export function getStudentInfo() {
  return request({ url: '/student/info', method: 'get' })
}
export function updateStudentInfo(data) {
  return request({ url: '/student/info/update', method: 'put', data })
}