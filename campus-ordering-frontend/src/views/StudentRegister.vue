<template>
  <div class="register-container">
    <el-card class="register-card">
      <h2 class="register-title">学生注册</h2>
      <el-form ref="registerForm" :model="registerForm" :rules="rules" label-width="100px">
        <el-form-item label="学号" prop="userNo">
          <el-input v-model="registerForm.userNo" placeholder="请输入学号" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="registerForm.password" type="password" placeholder="请输入密码" />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input v-model="registerForm.confirmPassword" type="password" placeholder="请再次输入密码" />
        </el-form-item>
        <el-form-item label="真实姓名" prop="userName">
          <el-input v-model="registerForm.userName" placeholder="请输入真实姓名" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="registerForm.phone" placeholder="请输入手机号" maxlength="11" />
        </el-form-item>
        <el-form-item label="验证码" prop="captcha">
          <div class="captcha-input">
            <el-input v-model="registerForm.captcha" placeholder="请输入验证码" style="width: 200px;" />
            <img :src="captchaUrl" alt="验证码" @click="refreshCaptcha" class="captcha-img" />
          </div>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleRegister" :loading="loading" style="width: 100%;">注册</el-button>
        </el-form-item>
        <el-form-item>
          <div class="login-link">
            已有账号？<router-link to="/login">立即登录</router-link>
          </div>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import request from '@/api'
import { getCaptcha } from '@/api/auth'

export default {
  name: 'StudentRegister',
  data() {
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.registerForm.password) {
        callback(new Error('两次输入的密码不一致'))
      } else {
        callback()
      }
    }
    return {
      captchaUrl: '',
      uuid: '',
      loading: false,
      registerForm: {
        userNo: '',
        password: '',
        confirmPassword: '',
        userName: '',
        phone: '',
        captcha: '',
        uuid: ''
      },
      rules: {
        userNo: [
          { required: true, message: '请输入学号', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能小于 6 位', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, validator: validateConfirmPassword, trigger: 'blur' }
        ],
        userName: [
          { required: true, message: '请输入真实姓名', trigger: 'blur' }
        ],
        phone: [
          { required: true, message: '请输入手机号', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }
        ],
        captcha: [
          { required: true, message: '请输入验证码', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.refreshCaptcha()
  },
  methods: {
    async refreshCaptcha() {
      try {
        const res = await getCaptcha()
        this.captchaUrl = 'data:image/png;base64,' + res.data.captchaImage
        this.uuid = res.data.captchaKey
        this.registerForm.uuid = res.data.captchaKey
      } catch (error) {
        this.$message.error('获取验证码失败')
      }
    },
    handleRegister() {
      this.$refs.registerForm.validate(async(valid) => {
        if (valid) {
          this.loading = true
          try {
            await request({
              url: '/auth/register/student',
              method: 'post',
              data: {
                username: this.registerForm.username,
                password: this.registerForm.password,
                phone: this.registerForm.phone,
                realName: this.registerForm.realName,
                captcha: this.registerForm.captcha,
                uuid: this.registerForm.uuid
              }
            })
            this.$message.success('注册成功，请登录')
            this.$router.push('/login')
          } catch (error) {
            const errorMsg = error.response?.data?.msg || error.response?.data?.message || error.message || '注册失败'
            this.$message.error(errorMsg)
            this.refreshCaptcha()
            this.registerForm.captcha = ''
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
.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.register-card {
  width: 450px;
  padding: 20px;
}

.register-title {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
}

.captcha-input {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.captcha-img {
  width: 120px;
  height: 40px;
  margin-left: 10px;
  cursor: pointer;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
}

.login-link {
  text-align: center;
  width: 100%;
}

.login-link a {
  color: #409EFF;
  text-decoration: none;
}
</style>
