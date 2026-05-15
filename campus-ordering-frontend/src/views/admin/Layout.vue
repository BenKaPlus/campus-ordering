<template>
  <el-container class="admin-layout">
    <el-aside width="200px">
      <el-menu
        :default-active="$route.path"
        router
        background-color="#545c64"
        text-color="#fff"
        active-text-color="#ffd04b"
      >
        <el-menu-item index="/admin/order">
          <i class="el-icon-s-order"></i>
          <span>订单管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/payment">
          <i class="el-icon-s-finance"></i>
          <span>支付管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/user">
          <i class="el-icon-user"></i>
          <span>用户管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/shop">
          <i class="el-icon-s-shop"></i>
          <span>店铺管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/product">
          <i class="el-icon-goods"></i>
          <span>商品管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/merchant-apply">
          <i class="el-icon-s-flag"></i>
          <span>商家申请</span>
        </el-menu-item>
        <el-menu-item index="/admin/system">
          <i class="el-icon-s-tools"></i>
          <span>系统管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/profile">
          <i class="el-icon-user"></i>
          <span>个人中心</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header>
        <div class="header-left">
          <span>校园点餐系统 - 管理端</span>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="el-dropdown-link">
              <img v-if="userInfo.avatar" :src="userInfo.avatar" class="user-avatar">
              <i v-else class="el-icon-user-solid user-avatar-default"></i>
              <span class="user-name">{{ userInfo.userName }}</span>
              <i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="profile">个人中心</el-dropdown-item>
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

export default {
  name: 'AdminLayout',
  computed: {
    ...mapGetters(['userInfo'])
  },
  methods: {
    async handleCommand(command) {
      if (command === 'profile') {
        this.$router.push('/admin/profile')
      } else if (command === 'logout') {
        // 调用后端退出登录接口（可选），不处理错误
        logout().catch(() => {
          // 忽略后端接口错误，继续执行退出逻辑
        }).finally(() => {
          // 清除本地状态
          this.$store.dispatch('logout')
          this.$router.push('/login')
        })
      }
    }
  }
}
</script>

<style scoped>
.admin-layout {
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
  display: flex;
  align-items: center;
}
.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  object-fit: cover;
  margin-right: 8px;
}
.user-avatar-default {
  font-size: 32px;
  color: #909399;
  margin-right: 8px;
}
.user-name {
  margin-right: 4px;
}
</style>
