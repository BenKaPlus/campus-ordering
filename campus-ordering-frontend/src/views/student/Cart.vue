<template>
  <div class="cart-container">
    <el-card>
      <div slot="header">
        <span>购物车</span>
        <el-button type="danger" size="small" style="float: right;" @click="clearCart">清空购物车</el-button>
      </div>
      <el-table :data="cartList" style="width: 100%;" v-loading="loading" @selection-change="handleSelectionChange" ref="cartTable">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="productName" label="商品名称"></el-table-column>
        <el-table-column prop="productImage" label="商品图片" width="100">
          <template slot-scope="scope">
            <img :src="scope.row.productImage" style="width: 60px; height: 60px; border-radius: 4px;">
          </template>
        </el-table-column>
        <el-table-column prop="productPrice" label="单价" width="100">
          <template slot-scope="scope">
            ¥{{ scope.row.productPrice }}
          </template>
        </el-table-column>
        <el-table-column label="数量" width="150">
          <template slot-scope="scope">
            <el-input-number v-model="scope.row.productNum" :min="1" size="small" @change="updateNum(scope.row)"></el-input-number>
          </template>
        </el-table-column>
        <el-table-column label="小计" width="120">
          <template slot-scope="scope">
            ¥{{ (scope.row.productPrice * scope.row.productNum).toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="deleteCartItem(scope.row.cartId)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="cart-footer">
        <span>已选 {{ selectedCartIds.length }} 件商品</span>
        <span class="total-price">合计：¥{{ totalPrice.toFixed(2) }}</span>
        <el-button type="primary" @click="goSettle" :disabled="selectedCartIds.length === 0">去结算</el-button>
      </div>
    </el-card>
  </div>
</template>

<script>
import { getCartList, updateCartNum, deleteCart } from '@/api/student'

export default {
  name: 'StudentCart',
  data() {
    return {
      cartList: [],
      selectedCartIds: [],
      loading: false
    }
  },
  computed: {
    totalPrice() {
      return this.selectedCartIds
        .reduce((sum, cartId) => {
          const item = this.cartList.find(item => item.cartId === cartId)
          return sum + (item ? item.productPrice * item.productNum : 0)
        }, 0)
    }
  },
  created() {
    this.getCartList()
  },
  methods: {
    async getCartList() {
      this.loading = true
      const res = await getCartList()
      if (res.code === 200) {
        this.cartList = res.data
      }
      this.loading = false
    },
    async updateNum(item) {
      await updateCartNum(item.cartId, item.productNum)
    },
    async deleteCartItem(cartId) {
      this.$confirm('确定删除该商品吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        await deleteCart([cartId])
        this.$message.success('删除成功')
        this.getCartList()
      })
    },
    async clearCart() {
      this.$confirm('确定清空购物车吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        await deleteCart(this.cartList.map(item => item.cartId))
        this.$message.success('清空成功')
        this.getCartList()
      })
    },
    goSettle() {
      // 跳转到订单确认页
      this.$router.push({ path: '/order', query: { cartIds: this.selectedCartIds.join(',') } })
    },
    handleSelectionChange(selection) {
      this.selectedCartIds = selection.map(item => item.cartId)
    }
  }
}
</script>

<style scoped>
.cart-container {
  padding: 20px;
}
.cart-footer {
  margin-top: 20px;
  text-align: right;
}
.total-price {
  font-size: 18px;
  color: #f56c6c;
  font-weight: bold;
  margin: 0 20px;
}
</style>