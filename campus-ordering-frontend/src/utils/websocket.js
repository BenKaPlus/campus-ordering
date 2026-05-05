import store from '@/store'
import { Message } from 'element-ui'

let stompClient = null
let SockJS = null
let retryCount = 0
const maxRetries = 3

// 仅在浏览器环境中动态导入 SockJS
export function initWebSocket() {
  if (typeof window !== 'undefined') {
    // 动态导入 SockJS
    import('sockjs-client').then(SockJSModule => {
      SockJS = SockJSModule.default || SockJSModule
    }).catch(err => {
      console.error('SockJS 导入失败', err)
    })
  }
}

// 指数退避重试函数
const retryConnect = () => {
  if (retryCount < maxRetries) {
    const delay = Math.pow(2, retryCount) * 1000
    console.log(`WebSocket连接失败，${delay}ms后重试...`)
    setTimeout(() => {
      connectWebSocket()
      retryCount++
    }, delay)
  } else {
    console.warn('WebSocket连接失败，已达到最大重试次数')
    // 降级方案：不使用 WebSocket
    console.warn('WebSocket 不可用，将使用轮询方式获取订单更新')
  }
}

export function connectWebSocket() {
  try {
    // 确保在浏览器环境中运行
    if (typeof window === 'undefined') {
      console.warn('WebSocket连接仅在浏览器环境中可用')
      return
    }
    
    // 确保 SockJS 已加载
    if (!SockJS) {
      console.error('SockJS 未初始化')
      retryConnect()
      return
    }
    
    // 尝试使用浏览器兼容的 stompjs 版本
    // 首先尝试导入 stompjs 的浏览器版本
    import('stompjs/lib/stomp.js').then(StompModule => {
      // 正确处理stompjs模块的导入
      const Stomp = StompModule.Stomp || StompModule.default || StompModule
      
      // 确保Stomp对象存在且有over方法
      if (!Stomp || typeof Stomp.over !== 'function') {
        console.error('Stomp库加载失败或版本不兼容')
        retryConnect()
        return
      }
      
      const socket = new SockJS('http://localhost:8080/api/ws/order')
      stompClient = Stomp.over(socket)
      stompClient.debug = null
      stompClient.connect({}, () => {
        // 连接成功，重置重试计数
        retryCount = 0
        console.log('WebSocket连接成功')
        // 订阅订单状态推送
        if (store.getters.userInfo && store.getters.userInfo.userId) {
          stompClient.subscribe('/topic/order/' + store.getters.userInfo.userId, (message) => {
            try {
              const data = JSON.parse(message.body)
              Message.info(data.content)
              // 刷新订单列表
              if (store.getters.roles && (store.getters.roles.includes('STUDENT') || store.getters.roles.includes('MERCHANT'))) {
                if (typeof window !== 'undefined') {
                  window.dispatchEvent(new CustomEvent('refreshOrder'))
                }
              }
            } catch (parseError) {
              console.error('消息解析失败', parseError)
            }
          })
        }
      }, (error) => {
        console.error('WebSocket连接失败', error)
        // 连接失败，进行重试
        retryConnect()
      })
    }).catch((importError) => {
      console.error('Stomp库导入失败', importError)
      // 导入失败，进行重试
      retryConnect()
    })
  } catch (error) {
    console.error('WebSocket初始化失败', error)
    // 初始化失败，进行重试
    retryConnect()
  }
}

export function disconnectWebSocket() {
  try {
    if (stompClient && typeof stompClient.disconnect === 'function') {
      stompClient.disconnect()
      stompClient = null
      // 重置重试计数
      retryCount = 0
    }
  } catch (error) {
    console.error('WebSocket断开连接失败', error)
  }
}