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
              <span>配送费：¥{{ shop.deliveryFee || 0 }}</span>
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
        <el-tabs v-model="activeTab" @tab-click="getOrderList">
          <el-tab-pane label="全部" name="all"></el-tab-pane>
          <el-tab-pane label="待支付" name="0"></el-tab-pane>
          <el-tab-pane label="待接单" name="1"></el-tab-pane>
          <el-tab-pane label="配送中" name="4"></el-tab-pane>
          <el-tab-pane label="已完成" name="5"></el-tab-pane>
        </el-tabs>
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
        <el-table-column label="操作" width="200">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="viewOrderDetail(scope.row.orderId)">查看详情</el-button>
            <el-button v-if="scope.row.orderStatus === 0" type="text" size="small" @click="cancelOrder(scope.row.orderId)">取消订单</el-button>
            <el-button v-if="scope.row.orderStatus === 0" type="primary" size="small" @click="goPay(scope.row.orderNo)">去支付</el-button>
            <el-button v-if="scope.row.orderStatus === 4" type="text" size="small" @click="confirmReceive(scope.row.orderId)">确认收货</el-button>
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
        <el-button v-if="orderDetail.orderStatus === 0" type="primary" size="small" @click="goPay(orderDetail.orderNo)">去支付</el-button>
        <el-button v-if="orderDetail.orderStatus === 4" type="primary" size="small" @click="confirmReceive(orderDetail.orderId)">确认收货</el-button>
      </div>
    </el-drawer>

    <el-dialog :visible.sync="qrcodeDialogVisible" title="扫码支付" width="300px" center>
      <div class="qrcode-content">
        <p class="qrcode-shop">{{ currentShopPayment.shopName }}</p>
        <p class="qrcode-amount">应付：¥{{ currentShopPayment.payAmount }}</p>
        <img :src="currentShopPayment.qrcodeUrl" class="qrcode-image">
        <p class="qrcode-tip">请使用{{ currentShopPayment.payType === 'wx' ? '微信' : '支付宝' }}扫码支付</p>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getOrderList, cancelOrder, getOrderDetail, getWxPayParams, updateOrderStatus, getSettleInfo, createBatchOrder, getCartList } from '@/api/student'

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
      currentShopPayment: {
        shopName: '',
        payAmount: 0,
        qrcodeUrl: '',
        payType: ''
      },
      paymentList: [],
      currentPaymentIndex: 0
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
      const res = await getSettleInfo(validCartIds)
      if (res.code === 200 && res.data) {
        this.settleInfo = {
          cartList: res.data.cartList || [],
          addressList: res.data.addressList || [],
          defaultAddressId: res.data.defaultAddressId || null
        }
        if (this.settleInfo.defaultAddressId) {
          this.selectedAddressId = this.settleInfo.defaultAddressId
        }
        if (this.settleInfo.cartList.length === 0 && validCartIds.length > 0) {
          const cartRes = await getCartList()
          if (cartRes.code === 200 && Array.isArray(cartRes.data)) {
            this.settleInfo.cartList = cartRes.data.filter(item => validCartIds.includes(item.cartId))
          }
        }
        this.groupCartByShop()
      }
      this.loading = false
    },
    groupCartByShop() {
      const shopMap = new Map()
      for (const item of this.settleInfo.cartList) {
        if (!shopMap.has(item.shopId)) {
          shopMap.set(item.shopId, {
            shopId: item.shopId,
            shopName: item.shopName || '店铺商品',
            deliveryFee: item.deliveryFee || 0,
            items: [],
            selectedPayType: 'wx',
            wxQrcode: item.wxQrcode || '',
            aliQrcode: item.aliQrcode || ''
          })
        }
        shopMap.get(item.shopId).items.push(item)
      }
      for (const shop of shopMap.values()) {
        const productTotal = shop.items.reduce((sum, item) => sum + item.productPrice * item.productNum, 0)
        shop.shopTotal = productTotal + (shop.deliveryFee || 0)
        if (!shop.wxQrcode && !shop.aliQrcode) {
          shop.selectedPayType = ''
        } else if (!shop.wxQrcode) {
          shop.selectedPayType = 'ali'
        } else if (!shop.aliQrcode) {
          shop.selectedPayType = 'wx'
        }
      }
      this.groupedCartList = Array.from(shopMap.values())
    },
    getStatusType(status) {
      const typeMap = { 0: 'info', 1: 'warning', 2: 'primary', 4: 'warning', 5: 'success', 6: 'info' }
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
        await cancelOrder(orderId)
        this.$message.success('订单已取消')
        this.getOrderList()
      })
    },
    async goPay(orderNo) {
      const res = await getWxPayParams(orderNo)
      if (res.code === 200) {
        this.$message.info('支付功能开发中')
      }
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
      const res = await createBatchOrder({
        addressId: this.selectedAddressId,
        shopOrders: shopOrders
      })
      if (res.code === 200 && res.data) {
        this.paymentList = res.data
        this.currentPaymentIndex = 0
        this.showNextPayment()
      }
    },
    showNextPayment() {
      if (this.currentPaymentIndex < this.paymentList.length) {
        const payment = this.paymentList[this.currentPaymentIndex]
        this.currentShopPayment = {
          shopName: payment.shopName,
          payAmount: payment.payAmount,
          qrcodeUrl: payment.payType === 'wx' ? payment.wxQrcode : payment.aliQrcode,
          payType: payment.payType
        }
        this.qrcodeDialogVisible = true
      } else {
        this.$message.success('所有订单已创建，请完成支付')
        this.$router.push('/order')
      }
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
  width: 200px;
  height: 200px;
  margin-bottom: 15px;
}
.qrcode-tip {
  color: #909399;
  font-size: 14px;
}
</style>
