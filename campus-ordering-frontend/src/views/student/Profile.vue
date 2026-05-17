<template>
  <div class="profile-container">
    <el-card>
      <div slot="header">个人中心</div>

      <el-tabs v-model="activeTab">
        <el-tab-pane label="基本信息" name="info">
          <el-form ref="infoForm" :model="studentInfo" label-width="100px" class="info-form">
            <el-row>
              <el-col :span="24">
                <el-form-item label="头像">
                  <div class="avatar-uploader">
                    <el-upload
                      class="avatar-uploader"
                      action="/api/common/upload/image"
                      :show-file-list="false"
                      :on-success="handleAvatarSuccess"
                      :before-upload="beforeAvatarUpload"
                      :headers="uploadHeaders">
                      <img v-if="studentInfo.avatar" :src="studentInfo.avatar" class="avatar">
                      <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    </el-upload>
                    <div class="upload-tip">点击上传头像，支持jpg、png格式</div>
                  </div>
                </el-form-item>
              </el-col>
            </el-row>

            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="账号">
                  <el-input v-model="studentInfo.userNo" disabled></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="姓名">
                  <el-input v-model="studentInfo.userName" placeholder="请输入姓名"></el-input>
                </el-form-item>
              </el-col>
            </el-row>

            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="手机号">
                  <el-input v-model="studentInfo.phone" placeholder="请输入手机号"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="学号">
                  <el-input v-model="studentInfo.studentNo" placeholder="请输入学号"></el-input>
                </el-form-item>
              </el-col>
            </el-row>

            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="学院">
                  <el-input v-model="studentInfo.college" placeholder="请输入学院"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="专业">
                  <el-input v-model="studentInfo.major" placeholder="请输入专业"></el-input>
                </el-form-item>
              </el-col>
            </el-row>

            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="年级">
                  <el-input v-model="studentInfo.grade" placeholder="请输入年级"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="宿舍地址">
                  <el-input v-model="studentInfo.dormitory" placeholder="请输入宿舍地址"></el-input>
                </el-form-item>
              </el-col>
            </el-row>

            <el-row>
              <el-col :span="24">
                <el-form-item label="角色">
                  <el-tag v-if="roleCode === 'STUDENT'" type="success">学生</el-tag>
                  <el-tag v-else-if="roleCode === 'MERCHANT'" type="warning">商家</el-tag>
                  <el-tag v-else-if="roleCode === 'ADMIN'" type="danger">管理员</el-tag>
                  <span v-else>-</span>
                </el-form-item>
              </el-col>
            </el-row>

            <el-form-item>
              <el-button type="primary" @click="handleUpdateInfo" :loading="infoLoading">保存修改</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <el-tab-pane label="收货地址" name="address">
          <div class="address-header">
            <el-button type="primary" size="small" @click="showAddressDialog('add')">新增地址</el-button>
          </div>

          <el-table :data="addressList" border style="width: 100%; margin-top: 15px;">
            <el-table-column prop="receiverName" label="联系人" width="100"></el-table-column>
            <el-table-column prop="receiverPhone" label="手机号" width="130"></el-table-column>
            <el-table-column prop="campusArea" label="校区" width="80"></el-table-column>
            <el-table-column prop="addressDetail" label="详细地址"></el-table-column>
            <el-table-column label="默认" width="80">
              <template slot-scope="scope">
                <el-tag v-if="scope.row.isDefault === 1" type="success">默认</el-tag>
                <span v-else>-</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="180">
              <template slot-scope="scope">
                <el-button type="text" size="small" @click="showAddressDialog('edit', scope.row)">编辑</el-button>
                <el-button type="text" size="small" @click="handleSetDefault(scope.row.addressId)" v-if="scope.row.isDefault !== 1">设为默认</el-button>
                <el-button type="text" size="small" style="color: #F56C6C;" @click="handleDeleteAddress(scope.row.addressId)" v-if="scope.row.isDefault !== 1">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="修改密码" name="password">
          <el-form ref="passwordForm" :model="passwordForm" :rules="passwordRules" label-width="100px" class="password-form">
            <el-form-item label="旧密码" prop="oldPassword">
              <el-input v-model="passwordForm.oldPassword" type="password" placeholder="请输入旧密码" show-password></el-input>
            </el-form-item>
            <el-form-item label="新密码" prop="newPassword">
              <el-input v-model="passwordForm.newPassword" type="password" placeholder="请输入新密码" show-password></el-input>
            </el-form-item>
            <el-form-item label="确认密码" prop="confirmPassword">
              <el-input v-model="passwordForm.confirmPassword" type="password" placeholder="请再次输入新密码" show-password></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleUpdatePassword" :loading="passwordLoading">修改密码</el-button>
              <el-button @click="resetPasswordForm">重置</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <el-tab-pane label="入驻申请" name="merchant">
          <div v-if="merchantLoading" class="loading-container">
            <el-loading-spinner size="large"></el-loading-spinner>
          </div>
          <div v-else-if="settleStatus === -1" class="no-apply">
            <el-empty description="您还没有提交入驻申请">
              <el-button type="primary" @click="goToMerchantRegister">前往商家入驻</el-button>
            </el-empty>
          </div>
          <div v-else-if="settleStatus === 0" class="apply-detail">
            <el-alert title="入驻申请待审核" type="info" :closable="false" show-icon>
              <p>预计3-5天内出审核结果，届时您可正常登录系统</p>
            </el-alert>
            <el-divider content-position="left">申请信息</el-divider>
            <el-form label-width="120px" class="apply-form">
              <el-form-item label="申请人姓名">
                <span>{{ applyForm.applicantName || '-' }}</span>
              </el-form-item>
              <el-form-item label="联系电话">
                <span>{{ applyForm.applicantPhone || '-' }}</span>
              </el-form-item>
              <el-form-item label="身份证号码">
                <span>{{ applyForm.applicantIdCard || '-' }}</span>
              </el-form-item>
              <el-form-item label="店铺名称">
                <span>{{ applyForm.shopName || '-' }}</span>
              </el-form-item>
              <el-form-item label="店铺描述">
                <span>{{ applyForm.shopDescription || '-' }}</span>
              </el-form-item>
              <el-form-item label="店铺类型">
                <span>{{ getShopTypeName(applyForm.shopType) }}</span>
              </el-form-item>
              <el-form-item label="预计配送费">
                <span>¥{{ applyForm.deliveryFee || 0 }}</span>
              </el-form-item>
              <el-form-item label="营业执照">
                <el-image
                  v-if="applyForm.businessLicense"
                  :src="applyForm.businessLicense"
                  class="license-image"
                  :preview-src-list="[applyForm.businessLicense]"
                  fit="contain"
                />
                <span v-else>-</span>
              </el-form-item>
              <el-form-item label="身份证正面">
                <el-image
                  v-if="applyForm.idCardFront"
                  :src="applyForm.idCardFront"
                  class="license-image"
                  :preview-src-list="[applyForm.idCardFront]"
                  fit="contain"
                />
                <span v-else>-</span>
              </el-form-item>
              <el-form-item label="身份证反面">
                <el-image
                  v-if="applyForm.idCardBack"
                  :src="applyForm.idCardBack"
                  class="license-image"
                  :preview-src-list="[applyForm.idCardBack]"
                  fit="contain"
                />
                <span v-else>-</span>
              </el-form-item>
              <el-form-item label="审核意见">
                <el-tag type="info">暂无审核意见</el-tag>
              </el-form-item>
            </el-form>
          </div>
          <div v-else-if="settleStatus === 2" class="apply-detail">
            <el-alert title="入驻申请未通过" type="warning" :closable="false" show-icon>
              <p>请根据审核意见修改申请信息后重新提交</p>
            </el-alert>
            <el-divider content-position="left">申请信息</el-divider>
            <el-form label-width="120px" class="apply-form">
              <el-form-item label="申请人姓名">
                <el-input v-if="isEditing" v-model="applyForm.applicantName" />
                <span v-else>{{ applyForm.applicantName || '-' }}</span>
              </el-form-item>
              <el-form-item label="联系电话">
                <el-input v-if="isEditing" v-model="applyForm.applicantPhone" />
                <span v-else>{{ applyForm.applicantPhone || '-' }}</span>
              </el-form-item>
              <el-form-item label="身份证号码">
                <el-input v-if="isEditing" v-model="applyForm.applicantIdCard" />
                <span v-else>{{ applyForm.applicantIdCard || '-' }}</span>
              </el-form-item>
              <el-form-item label="店铺名称">
                <el-input v-if="isEditing" v-model="applyForm.shopName" />
                <span v-else>{{ applyForm.shopName || '-' }}</span>
              </el-form-item>
              <el-form-item label="店铺描述">
                <el-input v-if="isEditing" v-model="applyForm.shopDescription" type="textarea" :rows="2" />
                <span v-else>{{ applyForm.shopDescription || '-' }}</span>
              </el-form-item>
              <el-form-item label="店铺类型">
                <el-select v-if="isEditing" v-model="applyForm.shopType" style="width: 100%;">
                  <el-option label="快餐" :value="1" />
                  <el-option label="小吃" :value="2" />
                  <el-option label="饮品" :value="3" />
                  <el-option label="水果" :value="4" />
                  <el-option label="超市" :value="5" />
                  <el-option label="其他" :value="6" />
                </el-select>
                <span v-else>{{ getShopTypeName(applyForm.shopType) }}</span>
              </el-form-item>
              <el-form-item label="预计配送费">
                <el-input-number v-if="isEditing" v-model="applyForm.deliveryFee" :min="0" :precision="2" :step="0.5" style="width: 100%;" />
                <span v-else>¥{{ applyForm.deliveryFee || 0 }}</span>
              </el-form-item>
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
                <span v-else>-</span>
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
                <span v-else>-</span>
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
                <span v-else>-</span>
              </el-form-item>
              <el-form-item label="审核意见">
                <el-tag type="warning">{{ applyInfo.auditRemark || '暂无审核意见' }}</el-tag>
              </el-form-item>
            </el-form>
            <div class="button-group">
              <el-button v-if="!isEditing" type="primary" @click="startEdit">修改申请</el-button>
              <template v-else>
                <el-button type="primary" @click="submitEdit" :loading="submitting">重新提交</el-button>
                <el-button @click="cancelEdit">取消</el-button>
              </template>
            </div>
          </div>
          <div v-else-if="settleStatus === 1" class="apply-detail">
            <el-alert title="恭喜！您的入驻申请已通过审核" type="success" :closable="false" show-icon>
              <p>您已成为商家，可以正常使用商家端功能</p>
              <el-button type="primary" size="small" @click="goToMerchant">前往商家端</el-button>
            </el-alert>
            <el-divider content-position="left">申请信息</el-divider>
            <el-form label-width="120px" class="apply-form">
              <el-form-item label="店铺名称">
                <span>{{ applyForm.shopName || '-' }}</span>
              </el-form-item>
              <el-form-item label="店铺类型">
                <span>{{ getShopTypeName(applyForm.shopType) }}</span>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <el-dialog :title="addressDialogTitle" :visible.sync="addressDialogVisible" width="500px">
      <el-form ref="addressForm" :model="addressForm" :rules="addressRules" label-width="80px">
        <el-form-item label="联系人" prop="receiverName">
          <el-input v-model="addressForm.receiverName" placeholder="请输入联系人姓名"></el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="receiverPhone">
          <el-input v-model="addressForm.receiverPhone" placeholder="请输入手机号"></el-input>
        </el-form-item>
        <el-form-item label="校区" prop="campusArea">
          <el-select v-model="addressForm.campusArea" placeholder="请选择校区" style="width: 100%;">
            <el-option label="东区" value="东区"></el-option>
            <el-option label="西区" value="西区"></el-option>
            <el-option label="南区" value="南区"></el-option>
            <el-option label="北区" value="北区"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="详细地址" prop="addressDetail">
          <el-input v-model="addressForm.addressDetail" placeholder="请输入详细收货地址，如：XX宿舍楼XX室" type="textarea" :rows="2"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="addressDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveAddress">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { getStudentInfo, updateStudentInfo, getAddressList, addAddress, updateAddress, deleteAddress, setDefaultAddress } from '@/api/student'
import { updatePassword, getCurrentUserApply, updateApply } from '@/api/auth'
import { uploadImage } from '@/api/common'

export default {
  name: 'StudentProfile',
  data() {
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.passwordForm.newPassword) {
        callback(new Error('两次输入的密码不一致'))
      } else {
        callback()
      }
    }
    return {
      activeTab: 'info',
      studentInfo: {
        userNo: '',
        userName: '',
        phone: '',
        studentNo: '',
        college: '',
        major: '',
        grade: '',
        dormitory: '',
        avatar: ''
      },
      infoLoading: false,
      passwordForm: {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      },
      passwordLoading: false,
      passwordRules: {
        oldPassword: [{ required: true, message: '请输入旧密码', trigger: 'blur' }],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '密码长度至少6位', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请再次输入新密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ]
      },
      addressList: [],
      addressDialogVisible: false,
      addressDialogTitle: '新增地址',
      addressForm: {
        addressId: null,
        receiverName: '',
        receiverPhone: '',
        campusArea: '',
        addressDetail: ''
      },
      addressRules: {
        receiverName: [{ required: true, message: '请输入联系人', trigger: 'blur' }],
        receiverPhone: [{ required: true, message: '请输入手机号', trigger: 'blur' }],
        campusArea: [{ required: true, message: '请选择校区', trigger: 'change' }],
        addressDetail: [{ required: true, message: '请输入详细地址', trigger: 'blur' }]
      },
      uploadHeaders: {},
      merchantLoading: false,
      settleStatus: -1,
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
      isEditing: false,
      submitting: false,
      shopTypes: {
        1: '快餐',
        2: '小吃',
        3: '饮品',
        4: '水果',
        5: '超市',
        6: '其他'
      }
    }
  },
  computed: {
    ...mapGetters(['userInfo', 'roles', 'token']),
    roleCode() {
      return this.roles && this.roles.length > 0 ? this.roles[0] : ''
    }
  },
  watch: {
    activeTab(newVal) {
      if (newVal === 'merchant') {
        this.loadMerchantApply()
      }
    }
  },
  mounted() {
    this.uploadHeaders = {
      'Authorization': 'Bearer ' + this.token
    }
    this.loadStudentInfo()
    this.loadAddressList()
  },
  methods: {
    handleAvatarSuccess(res) {
      if (res.code === 200) {
        this.studentInfo.avatar = res.data
        this.$message.success('头像上传成功')
      } else {
        this.$message.error(res.msg || '头像上传失败')
      }
    },
    beforeAvatarUpload(file) {
      const isJPG = file.type === 'image/jpeg' || file.type === 'image/jpg'
      const isPNG = file.type === 'image/png'
      const isLt2M = file.size / 1024 / 1024 < 2

      if (!isJPG && !isPNG) {
        this.$message.error('上传头像只能是 JPG/PNG 格式!')
        return false
      }
      if (!isLt2M) {
        this.$message.error('上传头像大小不能超过 2MB!')
        return false
      }
      return true
    },
    async loadStudentInfo() {
      try {
        const res = await getStudentInfo()
        if (res.code === 200 && res.data) {
          this.studentInfo = {
            userNo: res.data.userNo || this.userInfo.userNo || '',
            userName: res.data.userName || this.userInfo.userName || '',
            phone: res.data.phone || this.userInfo.phone || '',
            studentNo: res.data.studentNo || '',
            college: res.data.college || '',
            major: res.data.major || '',
            grade: res.data.grade || '',
            dormitory: res.data.dormitory || '',
            avatar: res.data.avatar || this.userInfo.avatar || ''
          }
        }
      } catch (error) {
        console.error('获取学生信息失败:', error)
      }
    },
    async handleUpdateInfo() {
      this.infoLoading = true
      try {
        const res = await updateStudentInfo(this.studentInfo)
        if (res.code === 200) {
          this.$message.success('个人信息更新成功')
          await this.$store.dispatch('getUserInfo')
          this.loadStudentInfo()
        } else {
          this.$message.error(res.msg || '更新失败')
        }
      } catch (error) {
        this.$message.error('更新失败')
      } finally {
        this.infoLoading = false
      }
    },
    async loadAddressList() {
      try {
        const res = await getAddressList()
        if (res.code === 200) {
          this.addressList = res.data || []
        }
      } catch (error) {
        console.error('获取收货地址失败:', error)
      }
    },
    showAddressDialog(type, row) {
      if (type === 'add') {
        this.addressDialogTitle = '新增地址'
        this.addressForm = {
          addressId: null,
          receiverName: '',
          receiverPhone: '',
          campusArea: '',
          addressDetail: ''
        }
      } else {
        this.addressDialogTitle = '编辑地址'
        this.addressForm = {
          addressId: row.addressId,
          receiverName: row.receiverName,
          receiverPhone: row.receiverPhone,
          campusArea: row.campusArea,
          addressDetail: row.addressDetail
        }
      }
      this.addressDialogVisible = true
    },
    async handleSaveAddress() {
      try {
        await this.$refs.addressForm.validate()
        let res
        if (this.addressForm.addressId) {
          res = await updateAddress(this.addressForm)
        } else {
          res = await addAddress(this.addressForm)
        }
        if (res.code === 200) {
          this.$message.success('保存成功')
          this.addressDialogVisible = false
          this.loadAddressList()
        } else {
          this.$message.error(res.msg || '保存失败')
        }
      } catch (error) {
        console.error('保存地址失败:', error)
        this.$message.error(error.message || '保存失败')
      }
    },
    async handleSetDefault(addressId) {
      try {
        const res = await setDefaultAddress(addressId)
        if (res.code === 200) {
          this.$message.success('设置成功')
          this.loadAddressList()
        } else {
          this.$message.error(res.msg || '设置失败')
        }
      } catch (error) {
        this.$message.error('设置失败')
      }
    },
    handleDeleteAddress(addressId) {
      this.$confirm('确定要删除该收货地址吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deleteAddress(addressId)
          if (res.code === 200) {
            this.$message.success('删除成功')
            this.loadAddressList()
          } else {
            this.$message.error(res.msg || '删除失败')
          }
        } catch (error) {
          this.$message.error('删除失败')
        }
      }).catch(() => {})
    },
    async handleUpdatePassword() {
      try {
        await this.$refs.passwordForm.validate()
        this.passwordLoading = true
        const res = await updatePassword({
          oldPassword: this.passwordForm.oldPassword,
          newPassword: this.passwordForm.newPassword
        })
        if (res.code === 200) {
          this.$message.success('密码修改成功，请重新登录')
          this.resetPasswordForm()
          this.$store.dispatch('logout')
          this.$router.push('/login')
        } else {
          this.$message.error(res.msg || '密码修改失败')
        }
      } catch (error) {
        if (error !== false) {
          this.$message.error(error.msg || '密码修改失败')
        }
      } finally {
        this.passwordLoading = false
      }
    },
    resetPasswordForm() {
      this.passwordForm = {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      }
      this.$refs.passwordForm && this.$refs.passwordForm.resetFields()
    },
    async loadMerchantApply() {
      this.merchantLoading = true
      try {
        const res = await getCurrentUserApply()
        if (res.code === 200 && res.data) {
          this.applyInfo = res.data
          this.settleStatus = res.data.auditStatus
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
        } else {
          this.settleStatus = -1
        }
      } catch (error) {
        this.settleStatus = -1
      } finally {
        this.merchantLoading = false
      }
    },
    getShopTypeName(type) {
      return this.shopTypes[type] || '-'
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
        this.$message.success('重新提交成功')
        this.isEditing = false
        await this.loadMerchantApply()
      } catch (error) {
        const errorMsg = error.response?.data?.msg || error.response?.data?.message || error.message || '提交失败'
        this.$message.error(errorMsg)
      } finally {
        this.submitting = false
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
          this.applyForm[field] = res.data
          this.$message.success('上传成功')
        } else {
          this.$message.error(res.msg || '上传失败')
        }
      } catch (error) {
        this.$message.error('上传失败')
      }
    },
    goToMerchant() {
      this.$router.push('/merchant')
    },
    goToMerchantRegister() {
      this.$router.push('/merchant')
    }
  }
}
</script>

<style scoped>
.profile-container {
  padding: 20px;
}
.info-form {
  max-width: 800px;
  margin-top: 20px;
}
.address-header {
  margin-bottom: 10px;
}
.avatar-uploader {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100px;
  height: 100px;
  line-height: 100px;
  text-align: center;
}
.avatar {
  width: 100px;
  height: 100px;
  object-fit: contain;
}
.upload-tip {
  margin-top: 5px;
  font-size: 12px;
  color: #909399;
}
.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 50px;
}
.no-apply {
  padding: 50px;
  text-align: center;
}
.apply-detail {
  padding: 20px 0;
}
.apply-form {
  max-width: 600px;
  margin-top: 20px;
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
.button-group {
  margin-top: 20px;
  text-align: center;
}
.button-group .el-button {
  margin: 0 10px;
}
</style>