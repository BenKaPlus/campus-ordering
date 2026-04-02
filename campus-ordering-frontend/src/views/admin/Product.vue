<template>
  <div class="product-container">
    <el-card>
      <div slot="header">
        <el-input
          v-model="searchProductName"
          placeholder="搜索商品名称"
          style="width: 200px;"
          @keyup.enter.native="loadProducts"
        >
        </el-input>
        <el-button type="primary" @click="loadProducts">搜索</el-button>
      </div>
      <el-table :data="productList" style="width: 100%;" v-loading="loading">
        <el-table-column prop="productImage" label="商品图片" width="100">
          <template slot-scope="scope">
            <img :src="scope.row.productImage" class="product-img" alt="商品图片">
          </template>
        </el-table-column>
        <el-table-column prop="productName" label="商品名称" min-width="150"></el-table-column>
        <el-table-column prop="shopName" label="所属店铺" width="150"></el-table-column>
        <el-table-column prop="productPrice" label="价格" width="100">
          <template slot-scope="scope">
            ¥{{ scope.row.productPrice }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">
              {{ scope.row.status === 1 ? '在售' : '下架' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="toggleStatus(scope.row)">
              {{ scope.row.status === 1 ? '下架' : '上架' }}
            </el-button>
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
        @current-change="loadProducts"
      ></el-pagination>
    </el-card>
  </div>
</template>

<script>
import { getAdminProductList, offlineProduct, onlineProduct } from '@/api/admin'

export default {
  name: 'AdminProduct',
  data() {
    return {
      searchProductName: '',
      productList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false
    }
  },
  created() {
    this.loadProducts()
  },
  methods: {
    async loadProducts() {
      this.loading = true
      try {
        const res = await getAdminProductList({
          productName: this.searchProductName,
          page: this.page,
          size: this.size
        })
        this.productList = res.data.records || []
        this.total = res.data.total || 0
      } catch (error) {
        this.$message.error('获取商品列表失败')
      } finally {
        this.loading = false
      }
    },
    async toggleStatus(row) {
      const newStatus = row.status === 1 ? 0 : 1
      try {
        if (newStatus === 0) {
          await offlineProduct(row.productId, '管理员下架')
        } else {
          await onlineProduct(row.productId)
        }
        this.$message.success(newStatus === 1 ? '上架成功' : '下架成功')
        this.loadProducts()
      } catch (error) {
        this.$message.error('操作失败')
      }
    }
  }
}
</script>

<style scoped>
.product-container {
  padding: 20px;
}
.product-img {
  width: 60px;
  height: 60px;
  object-fit: cover;
}
.pagination {
  margin-top: 20px;
  text-align: center;
}
</style>
