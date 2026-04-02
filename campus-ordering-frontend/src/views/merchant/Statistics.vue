<template>
  <div class="statistics-container">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-title">今日订单</div>
          <div class="stat-value">{{ stats.todayOrders }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-title">今日营业额</div>
          <div class="stat-value">¥{{ stats.todayRevenue }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-title">本月订单</div>
          <div class="stat-value">{{ stats.monthOrders }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-title">本月营业额</div>
          <div class="stat-value">¥{{ stats.monthRevenue }}</div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getStatistics } from '@/api/merchant'

export default {
  name: 'MerchantStatistics',
  data() {
    return {
      stats: {
        todayOrders: 0,
        todayRevenue: 0,
        monthOrders: 0,
        monthRevenue: 0
      }
    }
  },
  created() {
    this.loadStats()
  },
  methods: {
    async loadStats() {
      const res = await getStatistics()
      if (res.code === 200) {
        this.stats = res.data
      }
    }
  }
}
</script>

<style scoped>
.statistics-container {
  padding: 20px;
}
.stat-card {
  text-align: center;
}
.stat-title {
  font-size: 14px;
  color: #909399;
  margin-bottom: 10px;
}
.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #409EFF;
}
</style>
