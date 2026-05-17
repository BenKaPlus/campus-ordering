<template>
  <div class="login-container">
    <div class="login-overlay"></div>
    <el-card class="login-card">
      <div slot="header" class="login-header">
        <h2>忘记密码</h2>
        <p class="subtitle">通过手机号验证找回密码</p>
      </div>
      <el-form :model="form" :rules="rules" ref="form" label-width="100px">
        <el-form-item label="账号" prop="userNo">
          <el-input v-model="form.userNo" placeholder="请输入账号"></el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入注册时的手机号"></el-input>
        </el-form-item>
        <el-form-item label="验证码" prop="captcha">
          <el-input v-model="form.captcha" placeholder="请输入验证码" style="width: 150px;"></el-input>
          <img :src="captchaImg" @click="refreshCaptcha" class="captcha-img" alt="验证码">
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input v-model="form.newPassword" type="password" placeholder="请输入新密码" show-password></el-input>
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input v-model="form.confirmPassword" type="password" placeholder="请再次输入新密码" show-password></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleReset" :loading="loading" style="width: 100%;">重置密码</el-button>
        </el-form-item>
        <el-form-item>
          <div class="back-login">
            <router-link to="/login" class="back-link">返回登录</router-link>
          </div>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { resetPassword, getCaptcha } from '@/api/auth'

export default {
  name: 'ForgotPassword',
  data() {
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.form.newPassword) {
        callback(new Error('两次输入的密码不一致'))
      } else {
        callback()
      }
    }
    return {
      form: {
        userNo: '',
        phone: '',
        captcha: '',
        captchaKey: '',
        newPassword: '',
        confirmPassword: ''
      },
      rules: {
        userNo: [{ required: true, message: '请输入账号', trigger: 'blur' }],
        phone: [
          { required: true, message: '请输入手机号', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
        ],
        captcha: [{ required: true, message: '请输入验证码', trigger: 'blur' }],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请再次输入新密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ]
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
        this.form.captchaKey = res.data.captchaKey
      }
    },
    async handleReset() {
      this.$refs.form.validate(async valid => {
        if (valid) {
          this.loading = true
          try {
            await resetPassword({
              userNo: this.form.userNo,
              phone: this.form.phone,
              captchaKey: this.form.captchaKey,
              captcha: this.form.captcha,
              newPassword: this.form.newPassword
            })
            this.$message.success('密码重置成功，请使用新密码登录')
            this.$router.push('/login')
          } catch (e) {
            const errorMsg = e.response?.data?.msg || e.message || '重置密码失败'
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
  width: 450px;
  background-color: rgba(255, 255, 255, 0.95);
  position: relative;
  z-index: 2;
}
.login-header {
  text-align: center;
}
.login-header h2 {
  margin: 0;
  color: #00967d;
}
.subtitle {
  margin: 10px 0 0;
  color: #999;
  font-size: 14px;
}
.captcha-img {
  width: 120px;
  height: 40px;
  cursor: pointer;
  margin-left: 10px;
  vertical-align: middle;
}
.back-login {
  text-align: center;
}
.back-link {
  color: #409EFF;
  text-decoration: none;
}
.back-link:hover {
  text-decoration: underline;
}
</style>