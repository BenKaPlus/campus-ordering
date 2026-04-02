<template>
  <div class="system-container">
    <el-card>
      <div slot="header">系统设置</div>
      <el-form :model="systemForm" label-width="120px" v-loading="loading">
        <el-form-item label="系统名称">
          <el-input v-model="systemForm.systemName" placeholder="请输入系统名称"></el-input>
        </el-form-item>
        <el-form-item label="公告内容">
          <el-input
            v-model="systemForm.notice"
            type="textarea"
            :rows="6"
            placeholder="请输入系统公告"
          ></el-input>
        </el-form-item>
        <el-form-item label="配送费上限">
          <el-input-number v-model="systemForm.maxDeliveryFee" :min="0" :precision="2"></el-input-number>
        </el-form-item>
        <el-form-item label="订单超时时间 (分钟)">
          <el-input-number v-model="systemForm.orderTimeout" :min="1"></el-input-number>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="saveSystem" :loading="saving">保存设置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card style="margin-top: 20px;">
      <div slot="header">系统信息</div>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="系统版本">v1.0.0</el-descriptions-item>
        <el-descriptions-item label="后端框架">Spring Boot</el-descriptions-item>
        <el-descriptions-item label="前端框架">Vue.js + Element UI</el-descriptions-item>
        <el-descriptions-item label="数据库">MySQL</el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<script>
import { getSystemConfig, saveSystemConfig } from '@/api/admin'

export default {
  name: 'AdminSystem',
  data() {
    return {
      loading: false,
      saving: false,
      systemForm: {
        systemName: '校园点餐系统',
        notice: '',
        maxDeliveryFee: 10,
        orderTimeout: 30
      }
    }
  },
  created() {
    this.loadSystemConfig()
  },
  methods: {
    async loadSystemConfig() {
      this.loading = true
      try {
        const res = await getSystemConfig()
        if (res.code === 200 && res.data) {
          this.systemForm = {
            systemName: res.data.systemName || '校园点餐系统',
            notice: res.data.notice || '',
            maxDeliveryFee: parseFloat(res.data.maxDeliveryFee) || 10,
            orderTimeout: parseInt(res.data.orderTimeout) || 30
          }
        }
      } catch (error) {
        this.$message.error('加载系统配置失败')
      } finally {
        this.loading = false
      }
    },
    async saveSystem() {
      this.saving = true
      try {
        const data = {
          systemName: this.systemForm.systemName,
          notice: this.systemForm.notice,
          maxDeliveryFee: String(this.systemForm.maxDeliveryFee),
          orderTimeout: String(this.systemForm.orderTimeout)
        }
        const res = await saveSystemConfig(data)
        if (res.code === 200) {
          this.$message.success('保存成功')
        } else {
          this.$message.error(res.message || '保存失败')
        }
      } catch (error) {
        this.$message.error('保存失败')
      } finally {
        this.saving = false
      }
    }
  }
}
</script>

<style scoped>
.system-container {
  padding: 20px;
}
</style>
