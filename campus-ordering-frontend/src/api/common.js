import request from './index'

// 店铺
export function getShopCategoryList() {
  return request({ url: '/common/shop/category/list', method: 'get' })
}
export function getShopList(params) {
  return request({ url: '/common/shop/list', method: 'get', params })
}
export function getShopDetail(shopId) {
  return request({ url: '/common/shop/detail/' + shopId, method: 'get' })
}

// 商品
export function getProductCategoryList(shopId) {
  return request({ url: '/common/product/category/' + shopId, method: 'get' })
}
export function getProductList(shopId, params) {
  return request({ url: '/common/product/list/' + shopId, method: 'get', params })
}
export function getProductDetail(productId) {
  return request({ url: '/common/product/detail/' + productId, method: 'get' })
}
export function searchProduct(keyword, shopId, params) {
  const query = { keyword, ...params }
  if (shopId !== null && shopId !== undefined) {
    query.shopId = shopId
  }
  return request({ url: '/common/product/search', method: 'get', params: query })
}

// 文件上传
export function uploadImage(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/common/upload/image',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

export function getNotice() {
  return request({ url: '/common/notice', method: 'get' })
}