import request from './index'

export function login(data) {
  return request({
    url: '/auth/login',
    method: 'post',
    data
  })
}

export function logout() {
  return request({
    url: '/auth/logout',
    method: 'post'
  })
}

export function getUserInfo() {
  return request({
    url: '/auth/user/info',
    method: 'get'
  })
}

export function getCaptcha() {
  return request({
    url: '/auth/captcha',
    method: 'get'
  })
}

export function updateUserInfo(data) {
  return request({
    url: '/auth/user/info',
    method: 'put',
    data
  })
}

export function updatePassword(data) {
  return request({
    url: '/auth/user/password',
    method: 'put',
    data
  })
}

export function getMerchantSettleStatus() {
  return request({
    url: '/auth/merchant/settle-status',
    method: 'get'
  })
}

export function merchantSettle(data) {
  return request({
    url: '/auth/merchant/settle',
    method: 'post',
    data
  })
}

export function getCurrentUserApply() {
  return request({
    url: '/auth/merchant/apply',
    method: 'get'
  })
}

export function updateApply(data) {
  return request({
    url: '/auth/merchant/apply',
    method: 'put',
    data
  })
}

export function sendResetCode(params) {
  return request({
    url: '/auth/forgot-password/send-code',
    method: 'post',
    params
  })
}

export function resetPassword(params) {
  return request({
    url: '/auth/forgot-password/reset',
    method: 'post',
    params
  })
}