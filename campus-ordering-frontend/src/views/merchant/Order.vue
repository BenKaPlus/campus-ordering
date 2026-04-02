<template>
  <div class="merchant-order-container">
    <el-card>
      <div slot="header">
        <el-tabs v-model="activeTab" @tab-click="getOrderList">
          <el-tab-pane label="全部" name=""></el-tab-pane>
          <el-tab-pane label="待接单" name="1"></el-tab-pane>
          <el-tab-pane label="待备餐" name="2"></el-tab-pane>
          <el-tab-pane label="配送中" name="4"></el-tab-pane>
          <el-tab-pane label="已完成" name="5"></el-tab-pane>
        </el-tabs>
      </div>
      <el-table :data="orderList" style="width: 100%;" v-loading="loading">
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
      ></el-pagination>
    </el-card>
  </div>
</template>

<script>
import { getMerchantOrderList, acceptOrder, rejectOrder, updateOrderStatus } from '@/api/merchant'

export default {
  name: 'MerchantOrder',
  data() {
    return {
      activeTab: '',
      orderList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false
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
    async getOrderList() {
      this.loading = true
      const res = await getMerchantOrderList({
        status: this.activeTab,
        page: this.page,
        size: this.size
      })
      if (res.code === 200) {
        this.orderList = res.data.records
        this.total = res.data.total
      }
      this.loading = false
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
</style>