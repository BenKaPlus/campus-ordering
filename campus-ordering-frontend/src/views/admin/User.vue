<template>
  <div class="user-container">
    <el-card>
      <div class="filter-row">
        <el-tabs v-model="activeTab" @tab-click="handleTabClick" class="user-tabs">
          <el-tab-pane label="全部" name="all"></el-tab-pane>
          <el-tab-pane label="学生" name="1"></el-tab-pane>
          <el-tab-pane label="商家" name="2"></el-tab-pane>
          <el-tab-pane label="管理员" name="3"></el-tab-pane>
        </el-tabs>
        <div class="search-box">
          <el-input
            v-model="keyword"
            placeholder="请输入用户编号/用户姓名"
            style="width: 300px;"
            @keyup.enter.native="loadUsers"
            clearable
            @clear="loadUsers"
          >
          </el-input>
          <el-button type="primary" @click="loadUsers" style="margin-left: 10px;">搜索</el-button>
        </div>
      </div>
      <el-table :data="userList" style="width: 100%;" v-loading="loading">
        <el-table-column prop="userNo" label="用户编号" width="120"></el-table-column>
        <el-table-column prop="userName" label="用户姓名" width="100"></el-table-column>
        <el-table-column prop="phone" label="手机号" width="120"></el-table-column>
        <el-table-column prop="userType" label="角色" width="100">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.userType === 1">学生</el-tag>
            <el-tag v-else-if="scope.row.userType === 2" type="success">商家</el-tag>
            <el-tag v-else-if="scope.row.userType === 3" type="warning">管理员</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">
              {{ scope.row.status === 1 ? '正常' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="注册时间" width="160">
          <template slot-scope="scope">
            {{ formatDateTime(scope.row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="editUser(scope.row)">编辑</el-button>
            <el-button type="text" size="small" @click="toggleStatus(scope.row)">
              {{ scope.row.status === 1 ? '禁用' : '启用' }}
            </el-button>
            <el-button type="text" size="small" @click="resetPassword(scope.row)">重置密码</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        class="pagination"
        background
        layout="total, prev, pager, next"
        :total="total"
        :current-page.sync="page"
        :page-size.sync="size"
        @current-change="loadUsers"
      ></el-pagination>
    </el-card>

    <!-- 编辑用户对话框 -->
    <el-dialog title="编辑用户" :visible.sync="dialogVisible" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="用户编号">
          <el-input v-model="form.userNo" disabled></el-input>
        </el-form-item>
        <el-form-item label="用户姓名">
          <el-input v-model="form.userName"></el-input>
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="form.phone"></el-input>
        </el-form-item>
        <el-form-item label="角色">
          <el-select v-model="form.userType" disabled>
            <el-option label="学生" :value="1"></el-option>
            <el-option label="商家" :value="2"></el-option>
            <el-option label="管理员" :value="3"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveUser" :loading="saving">确定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import request from '@/api'

export default {
  name: 'AdminUser',
  data() {
    return {
      keyword: '',
      activeTab: 'all',
      userList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false,
      saving: false,
      dialogVisible: false,
      form: {}
    }
  },
  created() {
    this.loadUsers()
  },
  methods: {
    handleTabClick() {
      this.page = 1
      this.loadUsers()
    },
    async loadUsers() {
      this.loading = true
      try {
        const params = {
          page: this.page,
          size: this.size
        }
        if (this.keyword) {
          params.keyword = this.keyword
        }
        if (this.activeTab !== 'all') {
          params.userType = parseInt(this.activeTab)
        }
        const res = await request.get('/admin/user/list', { params })
        if (res.code === 200) {
          this.userList = res.data.records
          this.total = res.data.total
        }
      } catch (error) {
        this.$message.error('加载用户列表失败')
      } finally {
        this.loading = false
      }
    },
    editUser(row) {
      this.form = { ...row }
      this.dialogVisible = true
    },
    async saveUser() {
      this.saving = true
      try {
        const res = await request.put('/admin/user/update', this.form)
        if (res.code === 200) {
          this.$message.success('保存成功')
          this.dialogVisible = false
          this.loadUsers()
        } else {
          this.$message.error(res.msg || '保存失败')
        }
      } catch (error) {
        this.$message.error('保存失败')
      } finally {
        this.saving = false
      }
    },
    async toggleStatus(row) {
      const newStatus = row.status === 1 ? 0 : 1
      const action = newStatus === 0 ? '禁用' : '启用'
      try {
        const res = await request.put('/admin/user/status', null, {
          params: { userId: row.userId, status: newStatus }
        })
        if (res.code === 200) {
          this.$message.success(action + '成功')
          row.status = newStatus
        } else {
          this.$message.error(res.msg || action + '失败')
        }
      } catch (error) {
        this.$message.error(action + '失败')
      }
    },
    async resetPassword(row) {
      try {
        await this.$confirm('确定要重置该用户的密码吗？密码将重置为 123456', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
        const res = await request.put('/admin/user/reset-password', null, {
          params: { userId: row.userId }
        })
        if (res.code === 200) {
          this.$message.success('密码已重置为 123456')
        } else {
          this.$message.error(res.msg || '重置密码失败')
        }
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error('重置密码失败')
        }
      }
    },
    formatDateTime(dateTime) {
      if (!dateTime) return ''
      return dateTime.replace('T', ' ').substring(0, 19)
    }
  }
}
</script>

<style scoped>
.user-container {
  padding: 20px;
}
.filter-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}
.user-tabs {
  margin-bottom: 0;
}
.search-box {
  display: flex;
  align-items: center;
}
.pagination {
  margin-top: 20px;
  text-align: center;
}
</style>
