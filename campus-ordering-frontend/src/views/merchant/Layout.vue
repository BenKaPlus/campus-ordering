<template>
  <div class="merchant-layout-wrapper">
    <notice-bar />
    <el-container class="merchant-layout">
      <el-aside v-if="settleStatus === 1" width="200px">
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
        <el-menu-item index="/merchant/review">
          <i class="el-icon-s-comment"></i>
          <span>评价管理</span>
        </el-menu-item>
        <el-menu-item index="/merchant/profile">
          <i class="el-icon-user"></i>
          <span>个人中心</span>
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
        <div v-if="loading" class="loading-container">
          <el-loading-spinner size="large"></el-loading-spinner>
        </div>
        <div v-else-if="settleStatus === 1">
          <router-view></router-view>
        </div>
        <div v-else-if="settleStatus === 0 || settleStatus === 2" class="pending-container">
          <el-card class="pending-card">
            <div v-if="settleStatus === 0" class="status-header">
              <i class="el-icon-time pending-icon"></i>
              <h2>入驻申请待审核</h2>
              <p>预计3-5天内出审核结果，届时您可正常登录系统</p>
            </div>
            <div v-else class="status-header">
              <i class="el-icon-error pending-icon rejected"></i>
              <h2>入驻申请未通过</h2>
              <p>请根据审核意见修改申请信息后重新提交</p>
            </div>

            <div v-if="applyInfo" class="apply-content">
              <el-divider content-position="left">申请信息</el-divider>

              <el-form ref="applyForm" :model="applyForm" :rules="rules" label-width="120px">
                <el-divider content-position="left">申请人信息</el-divider>
                <el-form-item label="申请人姓名">
                  <el-input v-model="applyForm.applicantName" :disabled="!isEditing" />
                </el-form-item>
                <el-form-item label="联系电话">
                  <el-input v-model="applyForm.applicantPhone" :disabled="!isEditing" />
                </el-form-item>
                <el-form-item label="身份证号码" prop="applicantIdCard">
                  <el-input v-model="applyForm.applicantIdCard" :disabled="!isEditing" maxlength="18" />
                </el-form-item>

                <el-divider content-position="left">店铺信息</el-divider>
                <el-form-item label="店铺名称" prop="shopName">
                  <el-input v-model="applyForm.shopName" :disabled="!isEditing" />
                </el-form-item>
                <el-form-item label="店铺描述">
                  <el-input v-model="applyForm.shopDescription" type="textarea" :rows="3" :disabled="!isEditing" />
                </el-form-item>
                <el-form-item label="店铺类型" prop="shopType">
                  <el-select v-model="applyForm.shopType" :disabled="!isEditing" style="width: 100%;">
                    <el-option label="快餐" :value="1" />
                    <el-option label="小吃" :value="2" />
                    <el-option label="饮品" :value="3" />
                    <el-option label="水果" :value="4" />
                    <el-option label="超市" :value="5" />
                    <el-option label="其他" :value="6" />
                  </el-select>
                </el-form-item>
                <el-form-item label="预计配送费">
                  <el-input-number v-model="applyForm.deliveryFee" :min="0" :precision="2" :step="0.5" :disabled="!isEditing" style="width: 100%;" />
                </el-form-item>

                <el-divider content-position="left">资质证明</el-divider>
                <el-form-item label="营业执照">
                  <el-upload
                    v-if="isEditing"
                    class="license-uploader"
                    :show-file-list="false"
                    :before-upload="(file) => beforeUpload(file, 'businessLicense')"
                    :http-request="(option) => uploadFile(option, 'businessLicense')"
                  >
                    <img v-if="applyForm.businessLicense" :src="applyForm.businessLicense" class="license-image">
                    <i v-else class="el-icon-plus license-uploader-icon"></i>
                  </el-upload>
                  <el-image
                    v-else-if="applyForm.businessLicense"
                    :src="applyForm.businessLicense"
                    class="license-image"
                    :preview-src-list="[applyForm.businessLicense]"
                    fit="contain"
                  />
                  <div v-else class="no-image">暂无营业执照</div>
                </el-form-item>
                <el-form-item label="身份证正面">
                  <el-upload
                    v-if="isEditing"
                    class="license-uploader"
                    :show-file-list="false"
                    :before-upload="(file) => beforeUpload(file, 'idCardFront')"
                    :http-request="(option) => uploadFile(option, 'idCardFront')"
                  >
                    <img v-if="applyForm.idCardFront" :src="applyForm.idCardFront" class="license-image">
                    <i v-else class="el-icon-plus license-uploader-icon"></i>
                  </el-upload>
                  <el-image
                    v-else-if="applyForm.idCardFront"
                    :src="applyForm.idCardFront"
                    class="license-image"
                    :preview-src-list="[applyForm.idCardFront]"
                    fit="contain"
                  />
                  <div v-else class="no-image">暂无身份证正面</div>
                </el-form-item>
                <el-form-item label="身份证反面">
                  <el-upload
                    v-if="isEditing"
                    class="license-uploader"
                    :show-file-list="false"
                    :before-upload="(file) => beforeUpload(file, 'idCardBack')"
                    :http-request="(option) => uploadFile(option, 'idCardBack')"
                  >
                    <img v-if="applyForm.idCardBack" :src="applyForm.idCardBack" class="license-image">
                    <i v-else class="el-icon-plus license-uploader-icon"></i>
                  </el-upload>
                  <el-image
                    v-else-if="applyForm.idCardBack"
                    :src="applyForm.idCardBack"
                    class="license-image"
                    :preview-src-list="[applyForm.idCardBack]"
                    fit="contain"
                  />
                  <div v-else class="no-image">暂无身份证反面</div>
                </el-form-item>

                <el-divider content-position="left">审核意见</el-divider>
                <el-form-item v-if="applyInfo.auditRemark" label="审核意见">
                  <el-tag type="warning" class="remark-tag">{{ applyInfo.auditRemark }}</el-tag>
                </el-form-item>
                <el-form-item v-else label="审核意见">
                  <el-tag type="info" class="remark-tag">暂无审核意见</el-tag>
                </el-form-item>
              </el-form>

              <div class="button-group">
                <el-button v-if="!isEditing" type="primary" @click="startEdit">修改申请</el-button>
                <template v-else>
                  <el-button type="primary" @click="submitEdit" :loading="submitting">
                    {{ settleStatus === 2 ? '重新提交' : '保存修改' }}
                  </el-button>
                  <el-button @click="cancelEdit">取消</el-button>
                </template>
                <el-button @click="handleLogout">退出登录</el-button>
              </div>
            </div>
          </el-card>
        </div>
        <div v-else class="settle-container">
          <el-card class="settle-card">
            <h2>商家入驻申请</h2>
            <p class="tips">您还没有申请入驻校园点餐平台，请填写以下信息提交申请</p>
            <el-form ref="settleForm" :model="settleForm" :rules="rules" label-width="120px">
              <el-divider content-position="left">店铺信息</el-divider>
              <el-form-item label="店铺名称" prop="shopName">
                <el-input v-model="settleForm.shopName" placeholder="请输入店铺名称" />
              </el-form-item>
              <el-form-item label="店铺描述" prop="shopDescription">
                <el-input v-model="settleForm.shopDescription" type="textarea" :rows="3" placeholder="请输入店铺描述" />
              </el-form-item>
              <el-form-item label="店铺类型" prop="shopType">
                <el-select v-model="settleForm.shopType" placeholder="请选择店铺类型" style="width: 100%;">
                  <el-option label="快餐" :value="1" />
                  <el-option label="小吃" :value="2" />
                  <el-option label="饮品" :value="3" />
                  <el-option label="水果" :value="4" />
                  <el-option label="超市" :value="5" />
                  <el-option label="其他" :value="6" />
                </el-select>
              </el-form-item>
              <el-form-item label="预计配送费" prop="deliveryFee">
                <el-input-number v-model="settleForm.deliveryFee" :min="0" :precision="2" :step="0.5" style="width: 100%;" />
              </el-form-item>
              <el-divider content-position="left">资质证明</el-divider>
              <el-form-item label="身份证号码" prop="applicantIdCard">
                <el-input v-model="settleForm.applicantIdCard" placeholder="请输入身份证号码" maxlength="18" />
              </el-form-item>
              <el-form-item label="营业执照">
                <el-upload
                  class="license-uploader"
                  :show-file-list="false"
                  :before-upload="(file) => beforeUpload(file, 'businessLicense')"
                  :http-request="(option) => uploadFile(option, 'businessLicense')"
                >
                  <img v-if="settleForm.businessLicense" :src="settleForm.businessLicense" class="license-image">
                  <i v-else class="el-icon-plus license-uploader-icon"></i>
                </el-upload>
              </el-form-item>
              <el-form-item label="身份证正面">
                <el-upload
                  class="license-uploader"
                  :show-file-list="false"
                  :before-upload="(file) => beforeUpload(file, 'idCardFront')"
                  :http-request="(option) => uploadFile(option, 'idCardFront')"
                >
                  <img v-if="settleForm.idCardFront" :src="settleForm.idCardFront" class="license-image">
                  <i v-else class="el-icon-plus license-uploader-icon"></i>
                </el-upload>
              </el-form-item>
              <el-form-item label="身份证反面">
                <el-upload
                  class="license-uploader"
                  :show-file-list="false"
                  :before-upload="(file) => beforeUpload(file, 'idCardBack')"
                  :http-request="(option) => uploadFile(option, 'idCardBack')"
                >
                  <img v-if="settleForm.idCardBack" :src="settleForm.idCardBack" class="license-image">
                  <i v-else class="el-icon-plus license-uploader-icon"></i>
                </el-upload>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="handleSettle" :loading="submitting">提交申请</el-button>
              </el-form-item>
            </el-form>
            <el-alert title="温馨提示" type="info" :closable="false" show-icon>
              <p>1. 提交申请后，管理员将在 3-5 个工作日内审核</p>
              <p>2. 审核通过后，您将获得商家功能权限</p>
              <p>3. 请确保填写的信息真实有效</p>
            </el-alert>
          </el-card>
        </div>
      </el-main>
    </el-container>
  </el-container>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { logout, getMerchantSettleStatus, merchantSettle, getCurrentUserApply, updateApply } from '@/api/auth'
import { uploadImage } from '@/api/common'
import NoticeBar from '@/components/NoticeBar'

export default {
  name: 'MerchantLayout',
  components: {
    NoticeBar
  },
  data() {
    return {
      settleStatus: -1,
      loading: true,
      submitting: false,
      isEditing: false,
      applyInfo: null,
      applyForm: {
        applicantName: '',
        applicantPhone: '',
        applicantIdCard: '',
        shopName: '',
        shopDescription: '',
        shopType: null,
        deliveryFee: 0,
        businessLicense: '',
        idCardFront: '',
        idCardBack: ''
      },
      settleForm: {
        shopName: '',
        shopDescription: '',
        shopType: null,
        deliveryFee: 0,
        applicantIdCard: '',
        businessLicense: '',
        idCardFront: '',
        idCardBack: ''
      },
      rules: {
        shopName: [{ required: true, message: '请输入店铺名称', trigger: 'blur' }],
        shopType: [{ required: true, message: '请选择店铺类型', trigger: 'change' }],
        applicantIdCard: [{ required: true, message: '请输入身份证号码', trigger: 'blur' }, { pattern: /^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}[\dXx]$/, message: '请输入正确的身份证号码', trigger: 'blur' }]
      }
    }
  },
  computed: {
    ...mapGetters(['userInfo'])
  },
  created() {
    this.checkSettleStatus()
  },
  methods: {
    async checkSettleStatus() {
      this.loading = true
      try {
        const res = await getMerchantSettleStatus()
        if (res.code === 200) {
          this.settleStatus = res.data
          if (this.settleStatus === 0 || this.settleStatus === 2) {
            await this.loadApplyInfo()
          }
        }
      } catch (error) {
        this.$message.error('获取入驻状态失败')
      } finally {
        this.loading = false
      }
    },
    async loadApplyInfo() {
      try {
        const res = await getCurrentUserApply()
        if (res.code === 200 && res.data) {
          this.applyInfo = res.data
          this.applyForm = {
            applicantName: res.data.applicantName || '',
            applicantPhone: res.data.applicantPhone || '',
            applicantIdCard: res.data.applicantIdCard || '',
            shopName: res.data.shopName || '',
            shopDescription: res.data.shopDescription || '',
            shopType: res.data.shopType || null,
            deliveryFee: res.data.deliveryFee || 0,
            businessLicense: res.data.businessLicense || '',
            idCardFront: res.data.idCardFront || '',
            idCardBack: res.data.idCardBack || ''
          }
        }
      } catch (error) {
        this.$message.error('获取申请信息失败')
      }
    },
    startEdit() {
      this.isEditing = true
    },
    cancelEdit() {
      this.isEditing = false
      if (this.applyInfo) {
        this.applyForm = {
          applicantName: this.applyInfo.applicantName || '',
          applicantPhone: this.applyInfo.applicantPhone || '',
          applicantIdCard: this.applyInfo.applicantIdCard || '',
          shopName: this.applyInfo.shopName || '',
          shopDescription: this.applyInfo.shopDescription || '',
          shopType: this.applyInfo.shopType || null,
          deliveryFee: this.applyInfo.deliveryFee || 0,
          businessLicense: this.applyInfo.businessLicense || '',
          idCardFront: this.applyInfo.idCardFront || '',
          idCardBack: this.applyInfo.idCardBack || ''
        }
      }
    },
    async submitEdit() {
      this.$refs.applyForm.validate(async valid => {
        if (valid) {
          this.submitting = true
          try {
            await updateApply({
              shopName: this.applyForm.shopName,
              shopDescription: this.applyForm.shopDescription,
              shopType: this.applyForm.shopType,
              deliveryFee: this.applyForm.deliveryFee,
              businessLicense: this.applyForm.businessLicense,
              idCardFront: this.applyForm.idCardFront,
              idCardBack: this.applyForm.idCardBack
            })
            this.$message.success(this.settleStatus === 2 ? '重新提交成功' : '修改保存成功')
            this.isEditing = false
            await this.checkSettleStatus()
          } catch (error) {
            const errorMsg = error.response?.data?.msg || error.response?.data?.message || error.message || '提交失败'
            this.$message.error(errorMsg)
          } finally {
            this.submitting = false
          }
        }
      })
    },
    async handleSettle() {
      this.$refs.settleForm.validate(async valid => {
        if (valid) {
          this.submitting = true
          try {
            await merchantSettle(this.settleForm)
            this.$message.success('申请提交成功，请等待管理员审核')
            await this.checkSettleStatus()
          } catch (error) {
            const errorMsg = error.response?.data?.msg || error.response?.data?.message || error.message || '提交失败'
            this.$message.error(errorMsg)
          } finally {
            this.submitting = false
          }
        }
      })
    },
    handleLogout() {
      logout().catch(() => {}).finally(() => {
        this.$store.dispatch('logout')
        this.$router.push('/login')
      })
    },
    async handleCommand(command) {
      if (command === 'profile') {
        this.$router.push('/merchant/profile')
      } else if (command === 'logout') {
        this.handleLogout()
      }
    },
    beforeUpload(file, field) {
      const isImage = file.type.startsWith('image/')
      const isLt5M = file.size / 1024 / 1024 < 5
      if (!isImage) {
        this.$message.error('只能上传图片文件')
        return false
      }
      if (!isLt5M) {
        this.$message.error('图片大小不能超过 5MB')
        return false
      }
      return true
    },
    async uploadFile(option, field) {
      try {
        const res = await uploadImage(option.file)
        if (res.code === 200) {
          const url = res.data
          if (this.isEditing || !this.settleStatus) {
            this.applyForm[field] = url
          } else {
            this.settleForm[field] = url
          }
          this.$message.success('上传成功')
        } else {
          this.$message.error(res.msg || '上传失败')
        }
      } catch (error) {
        this.$message.error('上传失败')
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
.el-main {
  background-color: #f0f2f5;
  padding: 20px;
}
.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}
.pending-container {
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding-top: 50px;
}
.pending-card {
  width: 800px;
}
.status-header {
  text-align: center;
  padding: 20px 0;
  border-bottom: 1px solid #e6e6e6;
  margin-bottom: 20px;
}
.pending-icon {
  font-size: 64px;
  color: #E6A23C;
  margin-bottom: 16px;
}
.pending-icon.rejected {
  color: #F56C6C;
}
.apply-content {
  padding: 0 20px;
}
.license-uploader {
  width: 200px;
  height: 150px;
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}
.license-uploader:hover {
  border-color: #409EFF;
}
.license-uploader-icon {
  font-size: 28px;
  color: #8c939d;
}
.license-image {
  width: 200px;
  height: 150px;
  object-fit: contain;
}
.no-image {
  width: 200px;
  height: 150px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f5f5;
  color: #909399;
  font-size: 14px;
  border-radius: 6px;
}
.remark-tag {
  font-size: 14px;
  padding: 8px 16px;
}
.button-group {
  margin-top: 20px;
  text-align: center;
}
.button-group .el-button {
  margin: 0 10px;
}
.settle-container {
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding-top: 50px;
}
.settle-card {
  width: 700px;
}
.tips {
  color: #909399;
  margin-bottom: 20px;
}
</style>