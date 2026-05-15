import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/register/student',
    name: 'StudentRegister',
    component: () => import('@/views/StudentRegister.vue'),
    meta: { title: '学生注册' }
  },
  {
    path: '/register/merchant',
    name: 'MerchantApply',
    component: () => import('@/views/MerchantApply.vue'),
    meta: { title: '商家入驻' }
  },
  // 学生端路由
  {
    path: '/',
    component: () => import('@/views/student/Layout.vue'),
    redirect: '/home',
    meta: { role: 'STUDENT' },
    children: [
      {
        path: 'home',
        name: 'StudentHome',
        component: () => import('@/views/student/Home.vue'),
        meta: { title: '首页', role: 'STUDENT' }
      },
      {
        path: 'shop/:shopId',
        name: 'ShopDetail',
        component: () => import('@/views/student/ShopDetail.vue'),
        meta: { title: '店铺详情', role: 'STUDENT' }
      },
      {
        path: 'cart',
        name: 'StudentCart',
        component: () => import('@/views/student/Cart.vue'),
        meta: { title: '购物车', role: 'STUDENT' }
      },
      {
        path: 'order',
        name: 'StudentOrder',
        component: () => import('@/views/student/Order.vue'),
        meta: { title: '我的订单', role: 'STUDENT' }
      },
      {
        path: 'profile',
        name: 'StudentProfile',
        component: () => import('@/views/student/Profile.vue'),
        meta: { title: '个人中心', role: 'STUDENT' }
      }
    ]
  },
  // 商家端路由
  {
    path: '/merchant',
    component: () => import('@/views/merchant/Layout.vue'),
    redirect: '/merchant/order',
    meta: { role: 'MERCHANT' },
    children: [
      {
        path: 'shop',
        name: 'MerchantShop',
        component: () => import('@/views/merchant/Shop.vue'),
        meta: { title: '店铺管理', role: 'MERCHANT' }
      },
      {
        path: 'product',
        name: 'MerchantProduct',
        component: () => import('@/views/merchant/Product.vue'),
        meta: { title: '商品管理', role: 'MERCHANT' }
      },
      {
        path: 'order',
        name: 'MerchantOrder',
        component: () => import('@/views/merchant/Order.vue'),
        meta: { title: '订单管理', role: 'MERCHANT' }
      },
      {
        path: 'statistics',
        name: 'MerchantStatistics',
        component: () => import('@/views/merchant/Statistics.vue'),
        meta: { title: '数据统计', role: 'MERCHANT' }
      },
      {
        path: 'review',
        name: 'MerchantReview',
        component: () => import('@/views/merchant/Review.vue'),
        meta: { title: '评价管理', role: 'MERCHANT' }
      },
      {
        path: 'profile',
        name: 'MerchantProfile',
        component: () => import('@/views/merchant/Profile.vue'),
        meta: { title: '个人中心', role: 'MERCHANT' }
      }
    ]
  },
  // 管理员端路由
  {
    path: '/admin',
    component: () => import('@/views/admin/Layout.vue'),
    redirect: '/admin/order',
    meta: { role: 'ADMIN' },
    children: [
      {
        path: 'user',
        name: 'AdminUser',
        component: () => import('@/views/admin/User.vue'),
        meta: { title: '用户管理', role: 'ADMIN' }
      },
      {
        path: 'shop',
        name: 'AdminShop',
        component: () => import('@/views/admin/Shop.vue'),
        meta: { title: '店铺管理', role: 'ADMIN' }
      },
      {
        path: 'product',
        name: 'AdminProduct',
        component: () => import('@/views/admin/Product.vue'),
        meta: { title: '商品管理', role: 'ADMIN' }
      },
      {
        path: 'order',
        name: 'AdminOrder',
        component: () => import('@/views/admin/Order.vue'),
        meta: { title: '订单管理', role: 'ADMIN' }
      },
      {
        path: 'payment',
        name: 'AdminPayment',
        component: () => import('@/views/admin/Payment.vue'),
        meta: { title: '支付管理', role: 'ADMIN' }
      },
      {
        path: 'merchant-apply',
        name: 'MerchantApply',
        component: () => import('@/views/admin/MerchantApply.vue'),
        meta: { title: '商家申请', role: 'ADMIN' }
      },
      {
        path: 'system',
        name: 'AdminSystem',
        component: () => import('@/views/admin/System.vue'),
        meta: { title: '系统管理', role: 'ADMIN' }
      },
      {
        path: 'profile',
        name: 'AdminProfile',
        component: () => import('@/views/admin/Profile.vue'),
        meta: { title: '个人中心', role: 'ADMIN' }
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

const originalPush = VueRouter.prototype.push
VueRouter.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => {
    if (err.name !== 'NavigationDuplicated') {
      throw err
    }
  })
}

const originalReplace = VueRouter.prototype.replace
VueRouter.prototype.replace = function replace(location) {
  return originalReplace.call(this, location).catch(err => {
    if (err.name !== 'NavigationDuplicated') {
      throw err
    }
  })
}

export default router