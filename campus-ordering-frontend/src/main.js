import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import * as auth from '@/utils/auth'
import dayjs from 'dayjs'

Vue.config.productionTip = false
Vue.use(ElementUI)

// 全局日期过滤器
Vue.filter('formatDate', (value, format = 'YYYY-MM-DD HH:mm:ss') => {
  return value ? dayjs(value).format(format) : ''
})

// 全局权限指令
Vue.directive('permission', {
  inserted(el, binding) {
    const roles = store.getters.roles
    const permission = binding.value
    if (permission && !roles.includes(permission)) {
      el.parentNode && el.parentNode.removeChild(el)
    }
  }
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = auth.getToken()
  
  // 公开页面（无需登录）
  const publicPages = ['/login', '/register/student', '/register/merchant']
  const isPublicPage = publicPages.includes(to.path)
  
  // 访问公开页面
  if (isPublicPage) {
    if (to.path === '/login' && token && store.getters.userInfo) {
      // 已登录访问登录页，根据角色跳转
      const roles = store.getters.roles
      if (roles.includes('ADMIN')) {
        next('/admin')
      } else if (roles.includes('MERCHANT')) {
        next('/merchant')
      } else {
        next('/home')
      }
    } else {
      next()
    }
    return
  }
  
  // 访问其他页面需要 token
  if (!token) {
    next('/login')
    return
  }
  
  // 获取用户信息
  if (!store.getters.userInfo) {
    store.dispatch('getUserInfo')
      .then(() => {
        next({ ...to, replace: true })
      })
      .catch(() => {
        auth.removeToken()
        next('/login')
      })
    return
  }
  
  // 权限检查
  const roles = store.getters.roles
  const requiredRole = to.meta.role
  
  if (requiredRole && roles.length > 0 && !roles.includes(requiredRole)) {
    // 角色不匹配，根据用户角色跳转到对应首页
    ElementUI.Message.error('无权访问该页面')
    if (roles.includes('ADMIN')) {
      next('/admin')
    } else if (roles.includes('MERCHANT')) {
      next('/merchant')
    } else {
      next('/home')
    }
  } else {
    next()
  }
})

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')