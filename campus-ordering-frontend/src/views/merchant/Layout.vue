<template>
  <el-container class="merchant-layout">
    <el-aside width="200px">
      <el-menu
        :default-active="$route.path"
        router
        background-color="#545c64"
        text-color="#fff"
        active-text-color="#ffd04b"
      >
        <el-menu-item index="/merchant/order">
          <i class="el-icon-s-order"></i>
          <span>订单管理</span>
        </el-menu-item>
        <el-menu-item index="/merchant/product">
          <i class="el-icon-goods"></i>
          <span>商品管理</span>
        </el-menu-item>
        <el-menu-item index="/merchant/shop">
          <i class="el-icon-s-shop"></i>
          <span>店铺管理</span>
        </el-menu-item>
        <el-menu-item index="/merchant/statistics">
          <i class="el-icon-s-data"></i>
          <span>数据统计</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header>
        <div class="header-left">
          <span>校园点餐系统 - 商家端</span>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="el-dropdown-link">
              {{ userInfo.userName }}<i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </el-header>
      <el-main>
        <router-view></router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
import { mapGetters } from 'vuex'
import { logout } from '@/api/auth'
import { connectWebSocket, disconnectWebSocket } from '@/utils/websocket'

export default {
  name: 'MerchantLayout',
  computed: {
    ...mapGetters(['userInfo'])
  },
  created() {
    connectWebSocket()
  },
  beforeDestroy() {
    disconnectWebSocket()
  },
  methods: {
    async handleCommand(command) {
      if (command === 'logout') {
        // 调用后端退出登录接口（可选），不处理错误
        logout().catch(() => {
          // 忽略后端接口错误，继续执行退出逻辑
        }).finally(() => {
          // 清除本地状态
          // 断开 WebSocket 连接
          disconnectWebSocket()
          this.$store.dispatch('logout')
          this.$router.push('/login')
        })
      }
    }
  }
}
</script>

<style scoped>
.merchant-layout {
  height: 100vh;
}
.el-aside {
  background-color: #545c64;
}
.el-header {
  background-color: #fff;
  border-bottom: 1px solid #e6e6e6;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.header-left {
  font-size: 18px;
  font-weight: bold;
}
.el-dropdown-link {
  cursor: pointer;
}
.el-main {
  background-color: #f0f2f5;
  padding: 20px;
}
</style>