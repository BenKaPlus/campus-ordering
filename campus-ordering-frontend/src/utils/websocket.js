import SockJS from 'sockjs-client'
import Stomp from 'stompjs/lib/stomp.js'
import store from '@/store'
import { Message } from 'element-ui'

let stompClient = null

export function connectWebSocket() {
  const socket = new SockJS('http://localhost:8080/api/ws/order')
  stompClient = Stomp.over(socket)
  stompClient.debug = null
  stompClient.connect({}, () => {
    // 订阅订单状态推送
    stompClient.subscribe('/topic/order/' + store.getters.userInfo.userId, (message) => {
      const data = JSON.parse(message.body)
      Message.info(data.content)
      // 刷新订单列表
      if (store.getters.roles.includes('STUDENT') || store.getters.roles.includes('MERCHANT')) {
        window.dispatchEvent(new CustomEvent('refreshOrder'))
      }
    })
  }, (error) => {
    console.error('WebSocket连接失败', error)
  })
}

export function disconnectWebSocket() {
  if (stompClient) {
    stompClient.disconnect()
  }
}