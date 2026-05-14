<template>
  <div class="admin-payment-container">
    <el-card>
      <div slot="header">
        <span>支付记录管理</span>
      </div>

      <!-- 统计卡片 -->
      <div class="payment-stats">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">微信支付</div>
                <div class="stat-value">¥{{ stats.wxAmount }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">支付宝支付</div>
                <div class="stat-value">¥{{ stats.aliAmount }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">支付笔数</div>
                <div class="stat-value">{{ stats.totalCount }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">支付总额</div>
                <div class="stat-value">¥{{ stats.totalAmount }}</div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <!-- 筛选条件 -->
      <div class="filter-section">
        <el-form :inline="true" :model="filterForm">
          <el-form-item label="用户ID">
            <el-input v-model="filterForm.userId" placeholder="用户ID" clearable @keyup.enter.native="handleFilter"></el-input>
          </el-form-item>
          <el-form-item label="店铺ID">
            <el-input v-model="filterForm.shopId" placeholder="店铺ID" clearable @keyup.enter.native="handleFilter"></el-input>
          </el-form-item>
          <el-form-item label="支付方式">
            <el-select v-model="filterForm.payType" placeholder="支付方式" clearable>
              <el-option label="微信支付" :value="1"></el-option>
              <el-option label="支付宝" :value="2"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleFilter">查询</el-button>
            <el-button @click="handleReset">重置</el-button>
          </el-form-item>
        </el-form>
      </div>

      <!-- 支付记录表格 -->
      <el-table :data="paymentList" style="width: 100%;" v-loading="loading">
        <el-table-column prop="paymentId" label="支付ID" width="80"></el-table-column>
        <el-table-column prop="outTradeNo" label="订单号" width="180"></el-table-column>
        <el-table-column prop="userId" label="用户ID" width="80"></el-table-column>
        <el-table-column prop="orderId" label="订单ID" width="80"></el-table-column>
        <el-table-column prop="payType" label="支付方式" width="100">
          <template slot-scope="scope">{{ scope.row.payType === 1 ? '微信支付' : '支付宝' }}</template>
        </el-table-column>
        <el-table-column prop="payAmount" label="支付金额" width="100">
          <template slot-scope="scope">¥{{ scope.row.payAmount }}</template>
        </el-table-column>
        <el-table-column prop="payStatus" label="支付状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getPayStatusType(scope.row.payStatus)">{{ getPayStatusText(scope.row.payStatus) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="transactionId" label="交易流水号" min-width="180"></el-table-column>
        <el-table-column prop="payTime" label="支付时间" width="160">
          <template slot-scope="scope">{{ scope.row.payTime ? scope.row.payTime.replace('T', ' ') : '-' }}</template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="160">
          <template slot-scope="scope">{{ scope.row.createTime ? scope.row.createTime.replace('T', ' ') : '-' }}</template>
        </el-table-column>
      </el-table>

      <el-pagination
        class="pagination"
        background
        layout="total, prev, pager, next"
        :total="total"
        :current-page.sync="page"
        :page-size.sync="size"
        @current-change="getPaymentList"
      ></el-pagination>
    </el-card>
  </div>
</template>

<script>
import { getAdminPaymentList } from '@/api/admin'

export default {
  name: 'AdminPayment',
  data() {
    return {
      paymentList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false,
      filterForm: {
        userId: null,
        shopId: null,
        payType: null
      },
      stats: {
        wxAmount: 0,
        aliAmount: 0,
        totalCount: 0,
        totalAmount: 0
      }
    }
  },
  created() {
    this.getPaymentList()
  },
  methods: {
    async getPaymentList() {
      this.loading = true
      const params = {
        page: this.page,
        size: this.size
      }
      if (this.filterForm.userId) {
        params.userId = this.filterForm.userId
      }
      if (this.filterForm.shopId) {
        params.shopId = this.filterForm.shopId
      }
      if (this.filterForm.payType !== null && this.filterForm.payType !== '') {
        params.payType = this.filterForm.payType
      }
      const res = await getAdminPaymentList(params)
      if (res.code === 200) {
        this.paymentList = res.data.records
        this.total = res.data.total
        this.calculateStats()
      }
      this.loading = false
    },
    calculateStats() {
      let wxAmount = 0
      let aliAmount = 0
      for (const item of this.paymentList) {
        if (item.payType === 1) {
          wxAmount += Number(item.payAmount)
        } else if (item.payType === 2) {
          aliAmount += Number(item.payAmount)
        }
      }
      this.stats.wxAmount = wxAmount.toFixed(2)
      this.stats.aliAmount = aliAmount.toFixed(2)
      this.stats.totalCount = this.total
      this.stats.totalAmount = (wxAmount + aliAmount).toFixed(2)
    },
    handleFilter() {
      this.page = 1
      this.getPaymentList()
    },
    handleReset() {
      this.filterForm = {
        userId: null,
        shopId: null,
        payType: null
      }
      this.page = 1
      this.getPaymentList()
    },
    getPayStatusType(status) {
      const typeMap = { 0: 'info', 1: 'success', 2: 'danger', 3: 'warning', 4: 'danger' }
      return typeMap[status] || 'info'
    },
    getPayStatusText(status) {
      const textMap = { 0: '待支付', 1: '支付成功', 2: '支付失败', 3: '已关闭', 4: '已退款' }
      return textMap[status] || '未知'
    }
  }
}
</script>

<style scoped>
.admin-payment-container {
  padding: 20px;
}
.payment-stats {
  margin-bottom: 20px;
}
.payment-stats .el-card {
  text-align: center;
}
.stat-item {
  padding: 10px 0;
}
.stat-label {
  font-size: 14px;
  color: #909399;
  margin-bottom: 5px;
}
.stat-value {
  font-size: 20px;
  font-weight: bold;
  color: #303133;
}
.filter-section {
  margin-bottom: 20px;
}
.pagination {
  margin-top: 20px;
  text-align: center;
}
</style>