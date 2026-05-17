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
        <el-form-item label="验证码" prop="code">
          <el-input v-model="form.code" placeholder="请输入验证码" style="width: 150px;"></el-input>
          <el-button @click="sendCode" :disabled="countdown > 0" style="margin-left: 10px;">
            {{ countdown > 0 ? countdown + 's' : '发送验证码' }}
          </el-button>
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
import { sendResetCode, resetPassword } from '@/api/auth'

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
        code: '',
        newPassword: '',
        confirmPassword: ''
      },
      rules: {
        userNo: [{ required: true, message: '请输入账号', trigger: 'blur' }],
        phone: [
          { required: true, message: '请输入手机号', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
        ],
        code: [{ required: true, message: '请输入验证码', trigger: 'blur' }],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请再次输入新密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ]
      },
      loading: false,
      countdown: 0
    }
  },
  methods: {
    async sendCode() {
      if (!this.form.userNo) {
        this.$message.error('请先输入账号')
        return
      }
      if (!this.form.phone) {
        this.$message.error('请先输入手机号')
        return
      }
      try {
        await sendResetCode({ userNo: this.form.userNo, phone: this.form.phone })
        this.$message.success('验证码已发送，请查收')
        this.countdown = 60
        const timer = setInterval(() => {
          this.countdown--
          if (this.countdown <= 0) {
            clearInterval(timer)
          }
        }, 1000)
      } catch (e) {
        const errorMsg = e.response?.data?.msg || e.message || '发送验证码失败'
        this.$message.error(errorMsg)
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
              code: this.form.code,
              newPassword: this.form.newPassword
            })
            this.$message.success('密码重置成功，请使用新密码登录')
            this.$router.push('/login')
          } catch (e) {
            const errorMsg = e.response?.data?.msg || e.message || '重置密码失败'
            this.$message.error(errorMsg)
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
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%2300966d" fill-opacity="0.7" d="M0,224L48,213.3C96,203,192,181,288,181.3C384,181,480,203,576,224C672,245,768,267,864,250.7C960,235,1056,181,1152,165.3C1248,149,1344,171,1392,181.3L1440,192L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat;
  background-size: cover;
  display: flex;
  justify-content: center;
  align-items: center;
}

.login-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
}

.login-card {
  position: relative;
  width: 450px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 10px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
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
  width: 100px;
  height: 40px;
  cursor: pointer;
  margin-left: 10px;
  vertical-align: middle;
}

.register-links {
  text-align: center;
  font-size: 14px;
  color: #666;
}

.register-link {
  color: #00967d;
  text-decoration: none;
}

.register-link:hover {
  text-decoration: underline;
}

.back-login {
  text-align: center;
}

.back-link {
  color: #00967d;
  text-decoration: none;
}

.back-link:hover {
  text-decoration: underline;
}
</style>