<template>
  <div class="apply-container">
    <el-card class="apply-card">
      <h2 class="apply-title">商家入驻申请</h2>
      <el-form ref="applyForm" :model="applyForm" :rules="rules" label-width="120px">
        <el-divider content-position="left">账号信息</el-divider>
        <el-form-item label="登录账号" prop="userNo">
          <el-input v-model="applyForm.userNo" placeholder="请输入登录账号" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="applyForm.password" type="password" placeholder="请输入密码" />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input v-model="applyForm.confirmPassword" type="password" placeholder="请再次输入密码" />
        </el-form-item>
        <el-form-item label="真实姓名" prop="userName">
          <el-input v-model="applyForm.userName" placeholder="请输入真实姓名" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="applyForm.phone" placeholder="请输入手机号" maxlength="11" />
        </el-form-item>

        <el-divider content-position="left">店铺信息</el-divider>
        <el-form-item label="店铺名称" prop="shopName">
          <el-input v-model="applyForm.shopName" placeholder="请输入店铺名称" />
        </el-form-item>
        <el-form-item label="店铺描述" prop="shopDescription">
          <el-input v-model="applyForm.shopDescription" type="textarea" :rows="3" placeholder="请输入店铺描述" />
        </el-form-item>
        <el-form-item label="店铺类型" prop="shopType">
          <el-select v-model="applyForm.shopType" placeholder="请选择店铺类型" style="width: 100%;">
            <el-option label="快餐" :value="1" />
            <el-option label="小吃" :value="2" />
            <el-option label="饮品" :value="3" />
            <el-option label="水果" :value="4" />
            <el-option label="超市" :value="5" />
            <el-option label="其他" :value="6" />
          </el-select>
        </el-form-item>
        <el-form-item label="预计配送费" prop="deliveryFee">
          <el-input-number v-model="applyForm.deliveryFee" :min="0" :precision="2" :step="0.5" style="width: 100%;" />
        </el-form-item>

        <el-divider content-position="left">资质证明</el-divider>
        <el-form-item label="营业执照" prop="businessLicense">
          <el-input v-model="applyForm.businessLicense" placeholder="请输入营业执照图片 URL" />
        </el-form-item>
        <el-form-item label="身份证正面" prop="idCardFront">
          <el-input v-model="applyForm.idCardFront" placeholder="请输入身份证正面图片 URL" />
        </el-form-item>
        <el-form-item label="身份证反面" prop="idCardBack">
          <el-input v-model="applyForm.idCardBack" placeholder="请输入身份证反面图片 URL" />
        </el-form-item>

        <el-form-item label="验证码" prop="captcha">
          <div class="captcha-input">
            <el-input v-model="applyForm.captcha" placeholder="请输入验证码" style="width: 200px;" />
            <img :src="captchaUrl" alt="验证码" @click="refreshCaptcha" class="captcha-img" />
          </div>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="handleApply" :loading="loading" style="width: 100%;">提交申请</el-button>
        </el-form-item>
        <el-form-item>
          <div class="login-link">
            已有账号？<router-link to="/login">立即登录</router-link>
          </div>
        </el-form-item>
        <el-alert
          title="温馨提示"
          type="info"
          :closable="false"
          show-icon
        >
          <p>1. 提交申请后，管理员将在 1-3 个工作日内审核</p>
          <p>2. 审核通过后，您的账号将自动激活并创建店铺</p>
          <p>3. 请确保填写的信息真实有效</p>
        </el-alert>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import request from '@/api'
import { getCaptcha } from '@/api/auth'

export default {
  name: 'MerchantApply',
  data() {
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.applyForm.password) {
        callback(new Error('两次输入的密码不一致'))
      } else {
        callback()
      }
    }
    return {
      captchaUrl: '',
      uuid: '',
      loading: false,
      applyForm: {
        userNo: '',
        password: '',
        confirmPassword: '',
        userName: '',
        phone: '',
        shopName: '',
        shopDescription: '',
        shopType: 1,
        deliveryFee: 0,
        businessLicense: '',
        idCardFront: '',
        idCardBack: '',
        captcha: '',
        uuid: ''
      },
      rules: {
        userNo: [
          { required: true, message: '请输入登录账号', trigger: 'blur' }
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
        shopName: [
          { required: true, message: '请输入店铺名称', trigger: 'blur' }
        ],
        shopType: [
          { required: true, message: '请选择店铺类型', trigger: 'change' }
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
        this.applyForm.uuid = res.data.captchaKey
      } catch (error) {
        this.$message.error('获取验证码失败')
      }
    },
    handleApply() {
      this.$refs.applyForm.validate(async(valid) => {
        if (valid) {
          this.loading = true
          try {
            await request({
              url: '/auth/register/merchant',
              method: 'post',
              data: {
                username: this.applyForm.username,
                password: this.applyForm.password,
                phone: this.applyForm.phone,
                realName: this.applyForm.realName,
                shopName: this.applyForm.shopName,
                shopDescription: this.applyForm.shopDescription,
                shopType: this.applyForm.shopType,
                deliveryFee: this.applyForm.deliveryFee,
                businessLicense: this.applyForm.businessLicense,
                idCardFront: this.applyForm.idCardFront,
                idCardBack: this.applyForm.idCardBack,
                captcha: this.applyForm.captcha,
                uuid: this.applyForm.uuid
              }
            })
            this.$message.success('申请提交成功，请等待管理员审核')
            this.$router.push('/login')
          } catch (error) {
            const errorMsg = error.response?.data?.msg || error.response?.data?.message || error.message || '申请失败'
            this.$message.error(errorMsg)
            this.refreshCaptcha()
            this.applyForm.captcha = ''
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
.apply-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px 0;
}

.apply-card {
  width: 550px;
  padding: 20px;
}

.apply-title {
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

::v-deep .el-alert {
  margin-top: 20px;
}

::v-deep .el-alert p {
  margin: 5px 0;
  font-size: 13px;
  line-height: 1.5;
}
</style>
