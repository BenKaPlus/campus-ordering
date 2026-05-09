<template>
  <div class="profile-container">
    <el-card>
      <div slot="header">个人中心</div>

      <el-tabs v-model="activeTab">
        <el-tab-pane label="基本信息" name="info">
          <el-form ref="infoForm" :model="studentInfo" label-width="100px" class="info-form">
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

export default {
  name: 'StudentProfile',
  data() {
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
        dormitory: ''
      },
      infoLoading: false,
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
      }
    }
  },
  computed: {
    ...mapGetters(['userInfo', 'roles']),
    roleCode() {
      return this.roles && this.roles.length > 0 ? this.roles[0] : ''
    }
  },
  mounted() {
    this.loadStudentInfo()
    this.loadAddressList()
  },
  methods: {
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
            dormitory: res.data.dormitory || ''
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
</style>
