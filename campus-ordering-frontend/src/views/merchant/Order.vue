<template>
  <div class="merchant-order-container">
    <el-card>
      <div slot="header">
        <el-tabs v-model="activeTab" @tab-click="handleTabClick">
          <el-tab-pane label="全部" name="all"></el-tab-pane>
          <el-tab-pane label="待接单" name="1"></el-tab-pane>
          <el-tab-pane label="待备餐" name="2"></el-tab-pane>
          <el-tab-pane label="配送中" name="4"></el-tab-pane>
          <el-tab-pane label="已完成" name="5"></el-tab-pane>
          <el-tab-pane label="收款记录" name="payment"></el-tab-pane>
        </el-tabs>
      </div>

      <!-- 订单列表 -->
      <el-table :data="orderList" style="width: 100%;" v-loading="loading" v-if="activeTab !== 'payment'">
        <el-table-column prop="orderNo" label="订单号" width="180"></el-table-column>
        <el-table-column label="商品信息" min-width="200">
          <template slot-scope="scope">
            <div v-for="item in scope.row.itemList" :key="item.itemId" class="order-item">
              <img :src="item.productImage" class="order-item-img" alt="商品图片">
              <span>{{ item.productName }} x{{ item.productNum }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="receiverName" label="收货人" width="100"></el-table-column>
        <el-table-column prop="receiverPhone" label="联系电话" width="120"></el-table-column>
        <el-table-column prop="payAmount" label="实付金额" width="100">
          <template slot-scope="scope">
            ¥{{ scope.row.payAmount }}
          </template>
        </el-table-column>
        <el-table-column prop="orderStatus" label="订单状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.orderStatus)">{{ getStatusText(scope.row.orderStatus) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="viewOrderDetail(scope.row.orderId)">查看详情</el-button>
            <el-button v-if="scope.row.orderStatus === 1" type="primary" size="small" @click="acceptOrder(scope.row.orderId)">接单</el-button>
            <el-button v-if="scope.row.orderStatus === 1" type="danger" size="small" @click="rejectOrder(scope.row.orderId)">拒单</el-button>
            <el-button v-if="scope.row.orderStatus === 2" type="text" size="small" @click="updateStatus(scope.row.orderId, 3)">备餐完成</el-button>
            <el-button v-if="scope.row.orderStatus === 3" type="text" size="small" @click="updateStatus(scope.row.orderId, 4)">开始配送</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        class="pagination"
        background
        layout="prev, pager, next"
        :total="total"
        :current-page.sync="page"
        :page-size.sync="size"
        @current-change="getOrderList"
        v-if="activeTab !== 'payment'"
      ></el-pagination>

      <!-- 收款记录 -->
      <div v-if="activeTab === 'payment'" class="payment-stats">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">微信收款</div>
                <div class="stat-value">¥{{ paymentStats.wxAmount }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">支付宝收款</div>
                <div class="stat-value">¥{{ paymentStats.aliAmount }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">收款笔数</div>
                <div class="stat-value">{{ paymentStats.totalCount }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">收款总额</div>
                <div class="stat-value">¥{{ paymentStats.totalAmount }}</div>
              </div>
            </el-card>
          </el-col>
        </el-row>
        <div class="payment-filter">
          <el-select v-model="paymentFilter.payType" placeholder="支付方式" clearable @change="getPaymentList">
            <el-option label="全部" :value="null"></el-option>
            <el-option label="微信支付" :value="1"></el-option>
            <el-option label="支付宝" :value="2"></el-option>
          </el-select>
        </div>
      </div>
      <el-table :data="paymentList" style="width: 100%;" v-loading="paymentLoading" v-if="activeTab === 'payment'">
        <el-table-column prop="outTradeNo" label="订单号" width="180"></el-table-column>
        <el-table-column prop="payType" label="支付方式" width="100">
          <template slot-scope="scope">{{ scope.row.payType === 1 ? '微信支付' : '支付宝' }}</template>
        </el-table-column>
        <el-table-column prop="payAmount" label="支付金额" width="100">
          <template slot-scope="scope">¥{{ scope.row.payAmount }}</template>
        </el-table-column>
        <el-table-column prop="payStatus" label="支付状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.payStatus === 1 ? 'success' : 'danger'">{{ scope.row.payStatus === 1 ? '成功' : '失败' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="payTime" label="支付时间" width="160">
          <template slot-scope="scope">{{ scope.row.payTime ? scope.row.payTime.replace('T', ' ') : '-' }}</template>
        </el-table-column>
        <el-table-column prop="transactionId" label="交易流水号" min-width="180"></el-table-column>
      </el-table>
      <el-pagination
        class="pagination"
        background
        layout="prev, pager, next"
        :total="paymentTotal"
        :current-page.sync="paymentPage"
        :page-size.sync="paymentSize"
        @current-change="getPaymentList"
        v-if="activeTab === 'payment'"
      ></el-pagination>
    </el-card>
  </div>
</template>

<script>
import { getMerchantOrderList, acceptOrder, rejectOrder, updateOrderStatus, getMerchantPaymentList } from '@/api/merchant'

export default {
  name: 'MerchantOrder',
  data() {
    return {
      activeTab: 'all',
      orderList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false,
      paymentList: [],
      paymentTotal: 0,
      paymentPage: 1,
      paymentSize: 10,
      paymentLoading: false,
      paymentFilter: {
        payType: null
      },
      paymentStats: {
        wxAmount: 0,
        aliAmount: 0,
        totalCount: 0,
        totalAmount: 0
      }
    }
  },
  created() {
    this.getOrderList()
    window.addEventListener('refreshOrder', this.getOrderList)
  },
  beforeDestroy() {
    window.removeEventListener('refreshOrder', this.getOrderList)
  },
  methods: {
    handleTabClick(tab) {
      if (tab.name === 'payment') {
        this.paymentPage = 1
        this.getPaymentList()
      } else {
        this.page = 1
        this.getOrderList()
      }
    },
    async getOrderList() {
      this.loading = true
      const params = {
        page: this.page,
        size: this.size
      }
      if (this.activeTab !== 'all') {
        params.status = this.activeTab
      }
      const res = await getMerchantOrderList(params)
      if (res.code === 200) {
        this.orderList = res.data.records
        this.total = res.data.total
      }
      this.loading = false
    },
    async getPaymentList() {
      this.paymentLoading = true
      const params = {
        page: this.paymentPage,
        size: this.paymentSize
      }
      if (this.paymentFilter.payType !== null) {
        params.payType = this.paymentFilter.payType
      }
      const res = await getMerchantPaymentList(params)
      if (res.code === 200) {
        this.paymentList = res.data.records
        this.paymentTotal = res.data.total
        this.calculatePaymentStats()
      }
      this.paymentLoading = false
    },
    calculatePaymentStats() {
      let wxAmount = 0
      let aliAmount = 0
      for (const item of this.paymentList) {
        if (item.payType === 1) {
          wxAmount += Number(item.payAmount)
        } else if (item.payType === 2) {
          aliAmount += Number(item.payAmount)
        }
      }
      this.paymentStats.wxAmount = wxAmount.toFixed(2)
      this.paymentStats.aliAmount = aliAmount.toFixed(2)
      this.paymentStats.totalCount = this.paymentTotal
      this.paymentStats.totalAmount = (wxAmount + aliAmount).toFixed(2)
    },
    getStatusType(status) {
      const typeMap = { 1: 'warning', 2: 'primary', 3: 'warning', 4: 'warning', 5: 'success' }
      return typeMap[status] || 'info'
    },
    getStatusText(status) {
      const textMap = { 1: '待接单', 2: '待备餐', 3: '待出餐', 4: '配送中', 5: '已完成' }
      return textMap[status] || '未知'
    },
    // eslint-disable-next-line no-unused-vars
    viewOrderDetail(orderId) {
      this.$message.info('订单详情功能开发中')
    },
    async acceptOrder(orderId) {
      await acceptOrder(orderId)
      this.$message.success('接单成功')
      this.getOrderList()
    },
    async rejectOrder(orderId) {
      const { value: rejectReason } = await this.$prompt('请输入拒单原因', '拒单', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /\S+/,
        inputErrorMessage: '拒单原因不能为空'
      })
      if (rejectReason) {
        await rejectOrder(orderId, rejectReason)
        this.$message.success('拒单成功')
        this.getOrderList()
      }
    },
    async updateStatus(orderId, status) {
      await updateOrderStatus(orderId, status)
      this.$message.success('状态更新成功')
      this.getOrderList()
    }
  }
}
</script>

<style scoped>
.merchant-order-container {
  padding: 20px;
}
.order-item {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}
.order-item-img {
  width: 50px;
  height: 50px;
  border-radius: 4px;
  margin-right: 10px;
}
.pagination {
  margin-top: 20px;
  text-align: center;
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
.payment-filter {
  margin: 15px 0;
}
</style>