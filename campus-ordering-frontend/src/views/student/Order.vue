<template>
  <div class="order-container">
    <div v-if="isSettleMode">
      <el-card>
        <div slot="header">订单确认</div>
        <div class="address-section">
          <h4>选择收货地址</h4>
          <el-radio-group v-model="selectedAddressId">
            <el-radio v-for="address in settleInfo.addressList" :key="address.addressId" :label="address.addressId" border>
              {{ address.receiverName }} {{ address.receiverPhone }}<br>
              {{ address.campusArea }} {{ address.addressDetail }}
            </el-radio>
          </el-radio-group>
        </div>

        <div v-for="shop in groupedCartList" :key="shop.shopId" class="shop-section">
          <div class="shop-header">
            <span class="shop-name">{{ shop.shopName }}</span>
          </div>
          <el-table :data="shop.items" style="width: 100%;">
            <el-table-column prop="productName" label="商品名称"></el-table-column>
            <el-table-column prop="productImage" label="商品图片" width="100">
              <template slot-scope="scope">
                <img :src="scope.row.productImage" style="width: 60px; height: 60px; border-radius: 4px;">
              </template>
            </el-table-column>
            <el-table-column prop="productPrice" label="单价" width="100">
              <template slot-scope="scope">¥{{ scope.row.productPrice }}</template>
            </el-table-column>
            <el-table-column prop="productNum" label="数量" width="100"></el-table-column>
            <el-table-column label="小计" width="120">
              <template slot-scope="scope">¥{{ (scope.row.productPrice * scope.row.productNum).toFixed(2) }}</template>
            </el-table-column>
          </el-table>
          <div class="shop-footer">
            <div class="pay-type-section">
              <span class="pay-label">支付方式：</span>
              <el-radio-group v-model="shop.selectedPayType">
                <el-radio label="wx" :disabled="!shop.wxQrcode">微信支付</el-radio>
                <el-radio label="ali" :disabled="!shop.aliQrcode">支付宝</el-radio>
              </el-radio-group>
            </div>
            <div class="shop-total">
              <span>配送费：¥{{ (shop.deliveryFee || 0).toFixed(2) }}</span>
              <span class="shop-amount">店铺合计：¥{{ shop.shopTotal.toFixed(2) }}</span>
            </div>
          </div>
        </div>

        <div class="settle-footer">
          <span class="total-price">总计：¥{{ settleTotalPrice.toFixed(2) }}</span>
          <el-button type="primary" @click="submitBatchOrder">提交订单</el-button>
        </div>
      </el-card>
    </div>

    <el-card v-else>
      <div slot="header" class="header-wrapper">
        <div class="header-left">
          <el-tabs v-model="activeTab" @tab-click="handleTabClick">
            <el-tab-pane label="全部" name="all"></el-tab-pane>
            <el-tab-pane label="待支付" name="0"></el-tab-pane>
            <el-tab-pane label="待接单" name="1"></el-tab-pane>
            <el-tab-pane label="待备餐" name="2"></el-tab-pane>
            <el-tab-pane label="待出餐" name="3"></el-tab-pane>
            <el-tab-pane label="配送中" name="4"></el-tab-pane>
            <el-tab-pane label="已完成" name="5"></el-tab-pane>
            <el-tab-pane label="已取消" name="6"></el-tab-pane>
            <el-tab-pane label="支付记录" name="payment"></el-tab-pane>
          </el-tabs>
        </div>
        <div class="header-right">
          <el-button
            type="danger"
            size="small"
            :disabled="selectedOrderIds.length === 0"
            @click="handleBatchDelete"
          >批量删除</el-button>
          <el-input
            v-model="keyword"
            placeholder="搜索订单号"
            style="width: 200px;"
            clearable
            @clear="handleSearch"
            @keyup.enter.native="handleSearch"
          >
            <el-button slot="append" icon="el-icon-search" @click="handleSearch"></el-button>
          </el-input>
        </div>
      </div>
      <el-table :data="orderList" style="width: 100%;" v-loading="loading" @selection-change="handleSelectionChange" v-if="activeTab !== 'payment'">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="orderNo" label="订单号" width="180"></el-table-column>
        <el-table-column label="商品信息" min-width="200">
          <template slot-scope="scope">
            <div v-for="item in scope.row.itemList" :key="item.itemId" class="order-item">
              <img :src="item.productImage" class="order-item-img" alt="商品图片">
              <span>{{ item.productName }} x{{ item.productNum }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="payAmount" label="实付金额" width="100">
          <template slot-scope="scope">¥{{ scope.row.payAmount }}</template>
        </el-table-column>
        <el-table-column prop="orderStatus" label="订单状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.orderStatus)">{{ getStatusText(scope.row.orderStatus) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="下单时间" width="160">
          <template slot-scope="scope">{{ scope.row.createTime | formatDate }}</template>
        </el-table-column>
        <el-table-column label="操作" width="220">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="viewOrderDetail(scope.row.orderId)">查看详情</el-button>
            <el-button v-if="scope.row.orderStatus === 0" type="text" size="small" @click="cancelOrder(scope.row.orderId)">取消订单</el-button>
            <el-button v-if="scope.row.orderStatus === 0" type="primary" size="small" @click="goPay(scope.row.orderId)">去支付</el-button>
            <el-button v-if="scope.row.orderStatus === 4" type="text" size="small" @click="confirmReceive(scope.row.orderId)">确认收货</el-button>
            <el-button
              v-if="scope.row.orderStatus === 0 || scope.row.orderStatus === 1 || scope.row.orderStatus === 5 || scope.row.orderStatus === 6"
              type="text"
              size="small"
              @click="handleDelete(scope.row.orderId)"
            >删除</el-button>
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
        @current-change="handlePageChange"
      ></el-pagination>

      <!-- 支付记录表格 -->
      <div v-if="activeTab === 'payment'" class="payment-stats">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">微信支付</div>
                <div class="stat-value">¥{{ paymentStats.wxAmount }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">支付宝支付</div>
                <div class="stat-value">¥{{ paymentStats.aliAmount }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">支付笔数</div>
                <div class="stat-value">{{ paymentStats.totalCount }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">总金额</div>
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

    <el-drawer title="订单详情" :visible.sync="orderDetailVisible" size="40%">
      <div v-if="orderDetail.orderId" class="order-detail-content">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="订单号">{{ orderDetail.orderNo }}</el-descriptions-item>
          <el-descriptions-item label="订单状态">
            <el-tag :type="getStatusType(orderDetail.orderStatus)">{{ getStatusText(orderDetail.orderStatus) }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="收货人">{{ orderDetail.receiverName }} {{ orderDetail.receiverPhone }}</el-descriptions-item>
          <el-descriptions-item label="收货地址">{{ orderDetail.receiverAddress }}</el-descriptions-item>
          <el-descriptions-item label="商品金额">¥{{ orderDetail.productAmount }}</el-descriptions-item>
          <el-descriptions-item label="配送费">¥{{ orderDetail.deliveryFee }}</el-descriptions-item>
          <el-descriptions-item label="实付金额">¥{{ orderDetail.payAmount }}</el-descriptions-item>
          <el-descriptions-item label="下单时间">{{ orderDetail.createTime | formatDate }}</el-descriptions-item>
        </el-descriptions>
        <div class="order-detail-items">
          <h4>商品信息</h4>
          <div v-for="item in orderDetail.itemList" :key="item.itemId" class="order-detail-item">
            <img :src="item.productImage" class="order-detail-item-img" alt="商品图片">
            <div class="order-detail-item-info">
              <span>{{ item.productName }}</span>
              <span>¥{{ item.productPrice }} x{{ item.productNum }}</span>
            </div>
          </div>
        </div>
      </div>
      <div v-if="orderDetail.orderId" class="drawer-footer">
        <el-button v-if="orderDetail.orderStatus === 0" type="text" size="small" @click="cancelOrder(orderDetail.orderId)">取消订单</el-button>
        <el-button v-if="orderDetail.orderStatus === 0" type="primary" size="small" @click="goPay(orderDetail.orderId)">去支付</el-button>
        <el-button v-if="orderDetail.orderStatus === 4" type="primary" size="small" @click="confirmReceive(orderDetail.orderId)">确认收货</el-button>
      </div>
    </el-drawer>

    <el-dialog :visible.sync="qrcodeDialogVisible" title="扫码支付" width="500px" center>
      <div class="qrcode-content">
        <p class="qrcode-shop">{{ currentShopPayment.shopName }}</p>
        <p class="qrcode-amount">应付：¥{{ currentShopPayment.payAmount }}</p>
        <img :src="currentShopPayment.qrcodeUrl" class="qrcode-image">
        <p class="qrcode-tip">请使用{{ currentShopPayment.payType === 'wx' ? '微信' : '支付宝' }}扫码支付</p>
        <div class="qrcode-actions">
          <el-button type="success" @click="confirmPaid">已完成支付</el-button>
        </div>
      </div>
    </el-dialog>

    <el-dialog :visible.sync="payTypeDialogVisible" title="选择支付方式" width="400px" center>
      <div class="pay-type-content">
        <el-radio-group v-model="selectedPayType">
          <el-radio label="wx" :disabled="!currentOrder?.wxQrcode">微信支付</el-radio>
          <el-radio label="ali" :disabled="!currentOrder?.aliQrcode">支付宝</el-radio>
        </el-radio-group>
        <div class="pay-dialog-actions">
          <el-button @click="payTypeDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="showQrcode">确认支付</el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getOrderList, cancelOrder as cancelOrderApi, getOrderDetail, updateOrderStatus, getSettleInfo, createBatchOrder, getOrderPayInfo, deleteOrders, getPaymentList } from '@/api/student'

export default {
  name: 'StudentOrder',
  data() {
    return {
      activeTab: 'all',
      keyword: '',
      orderList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false,
      orderDetailVisible: false,
      orderDetail: {},
      isSettleMode: false,
      settleInfo: {
        cartList: [],
        addressList: [],
        defaultAddressId: null
      },
      selectedAddressId: null,
      groupedCartList: [],
      qrcodeDialogVisible: false,
      payTypeDialogVisible: false,
      currentShopPayment: {
        shopName: '',
        payAmount: 0,
        qrcodeUrl: '',
        payType: ''
      },
      currentOrder: null,
      selectedPayType: 'wx',
      selectedOrderIds: [],
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
      },
      selectedCartIds: []
    }
  },
  computed: {
    settleTotalPrice() {
      if (!this.isSettleMode) return 0
      return this.groupedCartList.reduce((sum, shop) => sum + shop.shopTotal, 0)
    }
  },
  created() {
    if (this.$route.query.cartIds) {
      this.isSettleMode = true
      this.getSettleInfo(this.$route.query.cartIds.split(',').map(Number))
    } else {
      this.getOrderList()
    }
    window.addEventListener('refreshOrder', this.getOrderList)
  },
  beforeDestroy() {
    window.removeEventListener('refreshOrder', this.getOrderList)
  },
  methods: {
    handleSelectionChange(selection) {
      this.selectedOrderIds = selection.map(item => item.orderId)
    },
    async handleDelete(orderId) {
      console.log('handleDelete 被调用，orderId:', orderId)
      this.$confirm('确定要删除该订单吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          console.log('开始调用 deleteOrders API，参数:', [orderId])
          const res = await deleteOrders([orderId])
          console.log('deleteOrders API 响应:', res)
          this.$message.success('删除成功')
          this.getOrderList()
        } catch (error) {
          console.error('删除失败:', error)
        }
      }).catch(() => {})
    },
    async handleBatchDelete() {
      console.log('handleBatchDelete 被调用，selectedOrderIds:', this.selectedOrderIds)
      this.$confirm(`确定要删除选中的 ${this.selectedOrderIds.length} 个订单吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          console.log('开始调用 deleteOrders API，参数:', this.selectedOrderIds)
          const res = await deleteOrders(this.selectedOrderIds)
          console.log('deleteOrders API 响应:', res)
          this.$message.success('批量删除成功')
          this.selectedOrderIds = []
          this.activeTab = 'all'
          this.page = 1
          this.getOrderList()
        } catch (error) {
          console.error('删除失败:', error)
        }
      }).catch(() => {})
    },
    async getOrderList() {
      this.loading = true
      const params = { page: this.page, size: this.size }
      if (this.activeTab !== 'all') {
        params.status = this.activeTab
      }
      if (this.keyword) {
        params.keyword = this.keyword
      }
      const res = await getOrderList(params)
      if (res.code === 200) {
        this.orderList = res.data.records
        this.total = res.data.total
      }
      this.loading = false
    },
    handleSearch() {
      this.page = 1
      this.getOrderList()
    },
    async getSettleInfo(cartIds) {
      this.loading = true
      const validCartIds = cartIds.filter(id => Number.isInteger(id) && id > 0)
      console.log('getSettleInfo 调用，validCartIds:', validCartIds)
      this.selectedCartIds = validCartIds
      const res = await getSettleInfo(validCartIds)
      console.log('getSettleInfo 响应:', res)
      if (res.code === 200 && res.data) {
        this.settleInfo = {
          cartList: res.data.cartList || [],
          addressList: res.data.addressList || [],
          defaultAddressId: res.data.defaultAddressId || null
        }
        if (this.settleInfo.defaultAddressId) {
          this.selectedAddressId = this.settleInfo.defaultAddressId
        }
        console.log('settleInfo.cartList:', this.settleInfo.cartList)
        this.groupCartByShop()
      }
      this.loading = false
    },
    groupCartByShop() {
      console.log('groupCartByShop 被调用，cartList:', this.settleInfo.cartList)
      const shopMap = new Map()
      for (const item of this.settleInfo.cartList) {
        console.log('处理购物车项:', item)
        if (!shopMap.has(item.shopId)) {
          const shopData = {
            shopId: item.shopId,
            shopName: item.shopName || '店铺商品',
            deliveryFee: Number(item.deliveryFee) || 0,
            items: [],
            selectedPayType: 'wx',
            wxQrcode: item.wxQrcode || '',
            aliQrcode: item.aliQrcode || ''
          }
          console.log('创建店铺数据:', shopData)
          shopMap.set(item.shopId, shopData)
        }
        shopMap.get(item.shopId).items.push(item)
      }
      for (const shop of shopMap.values()) {
        const productTotal = shop.items.reduce((sum, item) => sum + (Number(item.productPrice) * Number(item.productNum)), 0)
        console.log('店铺:', shop.shopName, '商品总额:', productTotal, '配送费:', shop.deliveryFee)
        shop.shopTotal = productTotal + shop.deliveryFee
        console.log('店铺总金额:', shop.shopTotal)
        if (!shop.wxQrcode && !shop.aliQrcode) {
          shop.selectedPayType = ''
        } else if (!shop.wxQrcode) {
          shop.selectedPayType = 'ali'
        } else if (!shop.aliQrcode) {
          shop.selectedPayType = 'wx'
        }
      }
      this.groupedCartList = Array.from(shopMap.values())
      console.log('groupedCartList:', this.groupedCartList)
    },
    getStatusType(status) {
      const typeMap = { 0: 'info', 1: 'warning', 2: 'primary', 3: 'warning', 4: 'warning', 5: 'success', 6: 'info' }
      return typeMap[status] || 'info'
    },
    getStatusText(status) {
      const textMap = { 0: '待支付', 1: '待接单', 2: '待备餐', 3: '待出餐', 4: '配送中', 5: '已完成', 6: '已取消' }
      return textMap[status] || '未知'
    },
    async viewOrderDetail(orderId) {
      const res = await getOrderDetail(orderId)
      if (res.code === 200) {
        this.orderDetail = res.data
        this.orderDetailVisible = true
      }
    },
    async cancelOrder(orderId) {
      this.$confirm('确定取消该订单吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        await cancelOrderApi(orderId)
        this.$message.success('订单已取消')
        this.getOrderList()
      })
    },
    async goPay(orderId) {
      const res = await getOrderPayInfo(orderId)
      if (res.code === 200 && res.data) {
        const payment = res.data
        if (!payment.wxQrcode && !payment.aliQrcode) {
          this.$message.error('该店铺未设置收款码')
          return
        }
        this.currentOrder = payment
        this.selectedPayType = payment.wxQrcode ? 'wx' : 'ali'
        this.payTypeDialogVisible = true
      }
    },
    showQrcode() {
      if (!this.currentOrder) return
      this.payTypeDialogVisible = false
      this.currentShopPayment = {
        orderId: this.currentOrder.orderId,
        orderNo: this.currentOrder.orderNo,
        shopName: this.currentOrder.shopName,
        payAmount: this.currentOrder.payAmount,
        qrcodeUrl: this.selectedPayType === 'wx' ? this.currentOrder.wxQrcode : this.currentOrder.aliQrcode,
        payType: this.selectedPayType
      }
      this.qrcodeDialogVisible = true
    },
    async confirmReceive(orderId) {
      this.$confirm('确定已收到商品吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        await updateOrderStatus(orderId, 5)
        this.$message.success('确认收货成功')
        this.getOrderList()
      })
    },
    async submitBatchOrder() {
      console.log('submitBatchOrder 被调用')
      if (!this.selectedAddressId) {
        this.$message.error('请选择收货地址')
        return
      }
      for (const shop of this.groupedCartList) {
        if (!shop.selectedPayType) {
          this.$message.error(`请为 ${shop.shopName} 选择支付方式`)
          return
        }
        if ((shop.selectedPayType === 'wx' && !shop.wxQrcode) ||
            (shop.selectedPayType === 'ali' && !shop.aliQrcode)) {
          this.$message.error(`${shop.shopName} 未设置${shop.selectedPayType === 'wx' ? '微信' : '支付宝'}收款码`)
          return
        }
      }
      const shopOrders = this.groupedCartList.map(shop => ({
        shopId: shop.shopId,
        shopName: shop.shopName,
        payType: shop.selectedPayType,
        itemList: shop.items.map(item => ({
          productId: item.productId,
          specId: item.specId,
          productNum: item.productNum
        }))
      }))
      console.log('准备发送的 shopOrders:', shopOrders, 'cartIds:', this.selectedCartIds)
      const res = await createBatchOrder({
        addressId: this.selectedAddressId,
        shopOrders: shopOrders,
        cartIds: this.selectedCartIds
      })
      console.log('createBatchOrder 响应:', res)
      if (res.code === 200 && res.data) {
        this.paymentList = res.data
        this.currentPaymentIndex = 0
        console.log('设置 paymentList:', this.paymentList)
        this.showNextPayment()
      }
    },
    showNextPayment() {
      console.log('showNextPayment 被调用，currentPaymentIndex:', this.currentPaymentIndex, 'paymentList:', this.paymentList)
      if (this.currentPaymentIndex < this.paymentList.length) {
        const payment = this.paymentList[this.currentPaymentIndex]
        console.log('当前支付信息:', payment)
        const payType = payment.payType === 1 ? 'wx' : 'ali'
        this.currentShopPayment = {
          orderId: payment.orderId,
          orderNo: payment.orderNo,
          shopName: payment.shopName,
          payAmount: payment.payAmount,
          qrcodeUrl: payType === 'wx' ? payment.wxQrcode : payment.aliQrcode,
          payType: payType
        }
        console.log('设置 currentShopPayment:', this.currentShopPayment)
        this.qrcodeDialogVisible = true
      } else {
        this.$message.success('所有订单已创建，请完成支付')
        this.$router.push('/order')
      }
    },
    async confirmPaid() {
      console.log('confirmPaid 被调用，currentShopPayment:', this.currentShopPayment)
      const orderId = this.currentShopPayment.orderId
      await updateOrderStatus(orderId, 1)
      this.qrcodeDialogVisible = false
      this.$message.success('支付成功')

      if (this.paymentList && this.paymentList.length > 0) {
        this.currentPaymentIndex++
        console.log('currentPaymentIndex 增加后:', this.currentPaymentIndex)
        if (this.currentPaymentIndex < this.paymentList.length) {
          console.log('还有下一个店铺需要支付，调用 showNextPayment')
          this.showNextPayment()
        } else {
          console.log('所有店铺支付完成，跳转到订单页面')
          this.$router.push('/order')
        }
      } else {
        console.log('paymentList 为空，直接跳转到订单页面')
        this.$router.push('/order')
      }
    },
    handleTabClick(tab) {
      if (tab.name === 'payment') {
        this.getPaymentList()
      } else {
        this.page = 1
        this.getOrderList()
      }
    },
    handlePageChange() {
      if (this.activeTab === 'payment') {
        this.getPaymentList()
      } else {
        this.getOrderList()
      }
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
      const res = await getPaymentList(params)
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
    }
  }
}
</script>

<style scoped>
.order-container {
  padding: 20px;
}
.address-section, .product-section {
  margin-bottom: 30px;
}
.address-section h4, .product-section h4 {
  margin-bottom: 15px;
  color: #303133;
}
.el-radio.is-bordered {
  margin-bottom: 10px;
  margin-right: 10px;
  height: auto;
  padding: 15px 20px;
}
.shop-section {
  margin-bottom: 30px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  padding: 15px;
}
.shop-header {
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebeef5;
}
.shop-name {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}
.shop-footer {
  margin-top: 15px;
  padding-top: 15px;
  border-top: 1px solid #ebeef5;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.pay-type-section {
  display: flex;
  align-items: center;
}
.pay-label {
  font-weight: bold;
  margin-right: 10px;
}
.shop-total {
  text-align: right;
}
.shop-total span {
  margin-left: 15px;
  color: #606266;
}
.shop-amount {
  color: #f56c6c;
  font-weight: bold;
  font-size: 16px;
}
.settle-footer {
  margin-top: 30px;
  text-align: right;
  border-top: 1px solid #ebeef5;
  padding-top: 20px;
}
.total-price {
  font-size: 20px;
  color: #f56c6c;
  font-weight: bold;
  margin-right: 20px;
}
.header-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.header-left {
  flex: 1;
}
.header-right {
  display: flex;
  align-items: center;
  gap: 10px;
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
.order-detail-items {
  margin-top: 20px;
}
.order-detail-item {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}
.order-detail-item-img {
  width: 80px;
  height: 80px;
  border-radius: 4px;
  margin-right: 15px;
}
.order-detail-item-info {
  flex: 1;
  display: flex;
  justify-content: space-between;
}
.qrcode-content {
  text-align: center;
}
.qrcode-shop {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 10px;
}
.qrcode-amount {
  font-size: 20px;
  color: #f56c6c;
  font-weight: bold;
  margin-bottom: 15px;
}
.qrcode-image {
  width: 400px;
  height: 500px;
  margin-bottom: 15px;
}
.qrcode-tip {
  color: #909399;
  font-size: 14px;
}
.qrcode-actions {
  margin-top: 15px;
  text-align: center;
}
.pay-type-content {
  text-align: center;
  padding: 20px 0;
}
.pay-type-content .el-radio-group {
  margin-bottom: 20px;
}
.pay-type-content .el-radio {
  margin: 0 20px;
  font-size: 16px;
}
.pay-dialog-actions {
  text-align: right;
}
</style>
