import axios from 'axios'
import { Message } from 'element-ui'
import store from '@/store'

const service = axios.create({
  baseURL: '/api',
  timeout: 10000
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    console.log('发送请求:', config.url, config.method, config.data)
    if (store.getters.token) {
      config.headers['Authorization'] = 'Bearer ' + store.getters.token
      console.log('添加了 Authorization 头')
    }
    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data
    // 验证码接口特殊处理
    if (response.config.url.includes('/auth/captcha')) {
      return res
    }
    if (res.code !== 200) {
      // 显示更详细的错误信息
      const errorMsg = res.msg || res.message || '请求失败'
      console.error('API 错误:', {
        url: response.config.url,
        code: res.code,
        msg: errorMsg,
        data: res.data
      })
      Message.error(errorMsg)
      if (res.code === 401) {
        store.dispatch('logout')
        location.reload()
      }
      return Promise.reject(new Error(errorMsg))
    } else {
      return res
    }
  },
  error => {
    // 验证码接口错误不弹出提示
    if (error.config && error.config.url.includes('/auth/captcha')) {
      console.log('验证码加载失败')
      return Promise.reject(error)
    }
    // 显示更详细的错误信息
    console.error('请求失败:', {
      url: error.config?.url,
      message: error.message,
      response: error.response?.data,
      status: error.response?.status
    })
    Message.error(error.message || '网络错误')
    return Promise.reject(error)
  }
)

export default service