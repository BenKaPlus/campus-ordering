<template>
  <div class="login-container">
    <div class="login-overlay"></div>
    <el-card class="login-card">
      <div slot="header" class="login-header">
        <h2>校园点餐系统</h2>
      </div>
      <el-form :model="loginForm" :rules="rules" ref="loginForm" label-width="80px">
        <el-form-item label="账号" prop="userNo">
          <el-input v-model="loginForm.userNo" placeholder="请输入账号"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" show-password></el-input>
        </el-form-item>
        <el-form-item label="验证码" prop="captcha">
          <el-input v-model="loginForm.captcha" placeholder="请输入验证码" style="width: 200px;"></el-input>
          <img :src="captchaImg" @click="refreshCaptcha" class="captcha-img" alt="验证码">
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleLogin" :loading="loading" style="width: 100%;">登录</el-button>
        </el-form-item>
        <el-form-item>
          <div class="register-links">
            <span>还没有账号？</span>
            <router-link to="/register/student" class="register-link">学生注册</router-link>
            <span style="margin: 0 10px; color: #ddd;">|</span>
            <router-link to="/register/merchant" class="register-link">商家入驻</router-link>
          </div>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { login, getCaptcha } from '@/api/auth'
import store from '@/store'

export default {
  name: 'LoginPage',
  data() {
    return {
      loginForm: {
        userNo: '',
        password: '',
        captcha: '',
        uuid: ''
      },
      rules: {
        userNo: [{ required: true, message: '请输入账号', trigger: 'blur' }],
        password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
        captcha: [{ required: true, message: '请输入验证码', trigger: 'blur' }]
      },
      captchaImg: '',
      loading: false
    }
  },
  created() {
    this.refreshCaptcha()
  },
  methods: {
    async refreshCaptcha() {
      const res = await getCaptcha()
      if (res.code === 200) {
        this.captchaImg = 'data:image/png;base64,' + res.data.captchaImage
        this.loginForm.uuid = res.data.captchaKey
      }
    },
    async handleLogin() {
      this.$refs.loginForm.validate(async valid => {
        if (valid) {
          this.loading = true
          try {
            const res = await login(this.loginForm)
            if (res.code === 200) {
              store.commit('SET_TOKEN', res.data.token)
              // 使用登录接口返回的用户信息
              if (res.data.userInfo && res.data.roleInfo) {
                store.commit('SET_USER_INFO', res.data.userInfo)
                store.commit('SET_ROLES', [res.data.roleInfo.roleCode])
              }
              this.$message.success('登录成功')
              // 根据角色跳转
              const roles = store.getters.roles
              if (roles.includes('ADMIN')) {
                this.$router.push('/admin')
              } else if (roles.includes('MERCHANT')) {
                this.$router.push('/merchant')
              } else {
                this.$router.push('/')
              }
            }
          } catch (e) {
            const errorMsg = e.response?.data?.msg || e.message || '登录失败，请检查账号密码和验证码'
            this.$message.error(errorMsg)
            this.refreshCaptcha()
          } finally {
            this.loading = false
          }
        }
      })
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-image: url('~@/assets/背景图.jpg');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  position: relative;
}
.login-overlay {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 300px;
  height: 100px;
  background-color: #f5f7fa;
  z-index: 1;
}
.login-card {
  width: 400px;
  background-color: rgba(255, 255, 255, 0.95);
  position: relative;
  z-index: 2;
}
.login-header {
  text-align: center;
}
.captcha-img {
  margin-left: 10px;
  height: 40px;
  cursor: pointer;
  vertical-align: middle;
}
.register-links {
  text-align: center;
  width: 100%;
  font-size: 14px;
}
.register-link {
  color: #409EFF;
  text-decoration: none;
  margin: 0 5px;
}
.register-link:hover {
  text-decoration: underline;
}
</style>