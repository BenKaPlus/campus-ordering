<template>
  <div class="profile-container">
    <el-card>
      <div slot="header">个人中心</div>

      <el-form ref="infoForm" :model="userInfo" label-width="100px" class="info-form">
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
                  :headers="uploadHeaders"
                >
                  <img v-if="userInfo.avatar" :src="userInfo.avatar" class="avatar">
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
              <el-input v-model="userInfo.userNo" disabled></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="姓名">
              <el-input v-model="userInfo.userName" placeholder="请输入姓名"></el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="手机号">
              <el-input v-model="userInfo.phone" placeholder="请输入手机号"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="角色">
              <el-tag type="danger">管理员</el-tag>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item>
          <el-button type="primary" @click="handleUpdateInfo" :loading="infoLoading">保存修改</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { getUserInfo, updateUserInfo } from '@/api/auth'

export default {
  name: 'AdminProfile',
  data() {
    return {
      userInfo: {
        userNo: '',
        userName: '',
        phone: '',
        avatar: ''
      },
      infoLoading: false,
      uploadHeaders: {}
    }
  },
  computed: {
    ...mapGetters(['token'])
  },
  mounted() {
    this.uploadHeaders = {
      'Authorization': 'Bearer ' + this.token
    }
    this.loadUserInfo()
  },
  methods: {
    async handleAvatarSuccess(res) {
      if (res.code === 200) {
        this.userInfo.avatar = res.data
        // 立即保存头像到数据库并更新 store
        try {
          const updateRes = await updateUserInfo({ avatar: this.userInfo.avatar })
          if (updateRes.code === 200) {
            await this.$store.dispatch('getUserInfo')
            this.$message.success('头像上传成功')
          } else {
            this.$message.error(updateRes.msg || '头像保存失败')
          }
        } catch (error) {
          this.$message.error('头像保存失败')
        }
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
    async loadUserInfo() {
      try {
        const res = await getUserInfo()
        if (res.code === 200 && res.data) {
          this.userInfo = {
            userNo: res.data.userNo || '',
            userName: res.data.userName || '',
            phone: res.data.phone || '',
            avatar: res.data.avatar || ''
          }
        }
      } catch (error) {
        console.error('获取用户信息失败:', error)
      }
    },
    async handleUpdateInfo() {
      this.infoLoading = true
      try {
        const res = await updateUserInfo(this.userInfo)
        if (res.code === 200) {
          this.$message.success('个人信息更新成功')
          await this.$store.dispatch('getUserInfo')
          this.loadUserInfo()
        } else {
          this.$message.error(res.msg || '更新失败')
        }
      } catch (error) {
        this.$message.error('更新失败')
      } finally {
        this.infoLoading = false
      }
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
  display: block;
  border-radius: 50%;
  object-fit: cover;
}
.upload-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
}
</style>
