<template>
  <div class="order-container">
    <el-card>
      <div slot="header">
        <div class="header-content">
          <el-tabs v-model="activeTab" @tab-click="handleTabClick" class="order-tabs">
            <el-tab-pane label="全部" name="all"></el-tab-pane>
            <el-tab-pane label="待支付" name="0"></el-tab-pane>
            <el-tab-pane label="待接单" name="1"></el-tab-pane>
            <el-tab-pane label="待备餐" name="2"></el-tab-pane>
            <el-tab-pane label="待出餐" name="3"></el-tab-pane>
            <el-tab-pane label="配送中" name="4"></el-tab-pane>
            <el-tab-pane label="已完成" name="5"></el-tab-pane>
            <el-tab-pane label="已取消" name="6"></el-tab-pane>
          </el-tabs>
          <div class="search-box">
            <el-input
              v-model="searchKeyword"
              placeholder="请输入订单号/用户编号/用户姓名/店铺名"
              style="width: 400px"
              clearable
              @clear="handleSearch"
              @keyup.enter.native="handleSearch"
            >
              <el-button slot="append" icon="el-icon-search" @click="handleSearch"></el-button>
            </el-input>
          </div>
        </div>
      </div>
      <el-table :data="orderList" style="width: 100%;" v-loading="loading">
        <el-table-column prop="orderNo" label="订单号" width="180"></el-table-column>
        <el-table-column prop="userNo" label="用户编号" width="120"></el-table-column>
        <el-table-column prop="userName" label="用户姓名" width="100"></el-table-column>
        <el-table-column prop="shopName" label="店铺" width="150"></el-table-column>
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
        <el-table-column prop="createTime" label="下单时间" width="160">
          <template slot-scope="scope">
            {{ scope.row.createTime | formatDate }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="viewDetail(scope.row)">详情</el-button>
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
        @current-change="loadOrders"
      ></el-pagination>
    </el-card>

    <!-- 订单详情对话框 -->
    <el-dialog title="订单详情" :visible.sync="detailVisible" width="800px">
      <el-descriptions :column="2" border v-if="orderDetail.orderId">
        <el-descriptions-item label="订单号">{{ orderDetail.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="订单状态">
          <el-tag :type="getStatusType(orderDetail.orderStatus)" size="small">
            {{ getStatusText(orderDetail.orderStatus) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="用户编号">{{ orderDetail.userNo }}</el-descriptions-item>
        <el-descriptions-item label="用户姓名">{{ orderDetail.userName }}</el-descriptions-item>
        <el-descriptions-item label="用户手机">{{ orderDetail.userPhone }}</el-descriptions-item>
        <el-descriptions-item label="店铺">{{ orderDetail.shopName }}</el-descriptions-item>
        <el-descriptions-item label="支付方式">
          {{ orderDetail.payType === 1 ? '微信支付' : (orderDetail.payType === 2 ? '支付宝支付' : '未知') }}
        </el-descriptions-item>
        <el-descriptions-item label="收货人">{{ orderDetail.receiverName }}</el-descriptions-item>
        <el-descriptions-item label="收货电话">{{ orderDetail.receiverPhone }}</el-descriptions-item>
        <el-descriptions-item label="收货地址" :span="2">{{ orderDetail.receiverAddress }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ orderDetail.orderRemark || '无' }}</el-descriptions-item>
      </el-descriptions>

      <el-divider>商品清单</el-divider>
      <el-table :data="orderDetail.items" style="width: 100%;" size="small">
        <el-table-column prop="productName" label="商品名称"></el-table-column>
        <el-table-column prop="specName" label="规格" width="120"></el-table-column>
        <el-table-column prop="price" label="单价" width="80">
          <template slot-scope="scope">¥{{ scope.row.price }}</template>
        </el-table-column>
        <el-table-column prop="quantity" label="数量" width="60"></el-table-column>
        <el-table-column prop="subTotal" label="小计" width="80">
          <template slot-scope="scope">¥{{ scope.row.subTotal }}</template>
        </el-table-column>
      </el-table>

      <el-divider>金额信息</el-divider>
      <el-descriptions :column="2" border v-if="orderDetail.orderId">
        <el-descriptions-item label="商品总额">¥{{ orderDetail.productAmount }}</el-descriptions-item>
        <el-descriptions-item label="配送费">¥{{ orderDetail.deliveryFee }}</el-descriptions-item>
        <el-descriptions-item label="优惠金额">-¥{{ orderDetail.discountAmount }}</el-descriptions-item>
        <el-descriptions-item label="订单总额">¥{{ orderDetail.totalAmount }}</el-descriptions-item>
        <el-descriptions-item label="实付金额" :span="2">
          <span style="color: #f56c6c; font-weight: bold; font-size: 16px;">¥{{ orderDetail.payAmount }}</span>
        </el-descriptions-item>
      </el-descriptions>

      <el-divider>状态变更日志</el-divider>
      <el-timeline v-if="orderDetail.statusLogs && orderDetail.statusLogs.length > 0">
        <el-timeline-item 
          v-for="(log, index) in orderDetail.statusLogs" 
          :key="index" 
          :timestamp="formatDateTime(log.createTime)"
          placement="top">
          <el-card>
            <p>{{ log.description }}</p>
            <p style="color: #909399; font-size: 12px;">
              状态：{{ getStatusText(log.beforeStatus) }} → {{ getStatusText(log.afterStatus) }}
              <span v-if="log.operatorName">（操作人：{{ log.operatorName }}）</span>
            </p>
          </el-card>
        </el-timeline-item>
      </el-timeline>
      <p v-else style="text-align: center; color: #909399;">暂无状态变更记录</p>

      <span slot="footer">
        <el-button @click="detailVisible = false">关闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import request from '@/api'

export default {
  name: 'AdminOrder',
  data() {
    return {
      activeTab: 'all',
      searchKeyword: '',
      orderList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false,
      detailVisible: false,
      orderDetail: {}
    }
  },
  created() {
    this.loadOrders()
  },
  methods: {
    handleTabClick() {
      this.page = 1
      this.loadOrders()
    },
    handleSearch() {
      this.page = 1
      this.loadOrders()
    },
    async loadOrders() {
      this.loading = true
      try {
        const params = {
          page: this.page,
          size: this.size
        }
        // 只有当不是"全部"选项时才传状态参数
        if (this.activeTab !== 'all') {
          params.status = this.activeTab
        }
        // 添加搜索关键词
        if (this.searchKeyword && this.searchKeyword.trim()) {
          params.keyword = this.searchKeyword.trim()
        }
        const res = await request.get('/admin/order/list', { params })
        if (res.code === 200 && res.data) {
          this.orderList = res.data.records || []
          this.total = res.data.total || 0
        }
      } catch (error) {
        console.error('加载订单列表失败', error)
        this.$message.error('加载订单列表失败')
      } finally {
        this.loading = false
      }
    },
    async viewDetail(row) {
      try {
        const res = await request.get(`/admin/order/detail/${row.orderId}`)
        if (res.code === 200 && res.data) {
          this.orderDetail = res.data
          this.detailVisible = true
        }
      } catch (error) {
        console.error('加载订单详情失败', error)
        this.$message.error('加载订单详情失败')
      }
    },
    getStatusType(status) {
      const typeMap = { 
        0: 'info', 
        1: 'warning', 
        2: 'primary', 
        3: 'warning', 
        4: 'warning', 
        5: 'success',
        6: 'info',
        7: 'warning',
        8: 'info'
      }
      return typeMap[status] || 'info'
    },
    getStatusText(status) {
      const textMap = { 
        0: '待支付', 
        1: '待接单', 
        2: '待备餐', 
        3: '待出餐', 
        4: '配送中', 
        5: '已完成',
        6: '已取消',
        7: '退款中',
        8: '已退款'
      }
      return textMap[status] || '未知'
    },
    formatDateTime(time) {
      if (!time) return ''
      const date = new Date(time)
      return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      })
    }
  }
}
</script>

<style scoped>
.order-container {
  padding: 20px;
}
.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.order-tabs {
  flex: 1;
}
.search-box {
  margin-left: 20px;
}
.pagination {
  margin-top: 20px;
  text-align: center;
}
</style>
