<template>
  <div class="profile-container">
    <el-card>
      <div slot="header">个人中心</div>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="账号">{{ userInfo.userNo }}</el-descriptions-item>
        <el-descriptions-item label="姓名">{{ userInfo.userName }}</el-descriptions-item>
        <el-descriptions-item label="手机号">{{ userInfo.phone }}</el-descriptions-item>
        <el-descriptions-item label="角色">
          <el-tag v-if="roleCode === 'STUDENT'">学生</el-tag>
          <el-tag v-else-if="roleCode === 'MERCHANT'" type="success">商家</el-tag>
          <el-tag v-else-if="roleCode === 'ADMIN'" type="warning">管理员</el-tag>
          <span v-else>-</span>
        </el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'StudentProfile',
  computed: {
    ...mapGetters(['userInfo', 'roles']),
    roleCode() {
      return this.roles && this.roles.length > 0 ? this.roles[0] : ''
    }
  }
}
</script>

<style scoped>
.profile-container {
  padding: 20px;
}
</style>
