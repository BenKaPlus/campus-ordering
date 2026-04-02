<template>
  <div class="product-container">
    <el-card>
      <div slot="header">
        <el-button type="primary" @click="showAddDialog">添加商品</el-button>
      </div>
      <el-table :data="productList" style="width: 100%;" v-loading="loading">
        <el-table-column prop="productImage" label="商品图片" width="100">
          <template slot-scope="scope">
            <img :src="scope.row.productImage" class="product-img" alt="商品图片">
          </template>
        </el-table-column>
        <el-table-column prop="productName" label="商品名称" min-width="150"></el-table-column>
        <el-table-column prop="price" label="价格" width="100">
          <template slot-scope="scope">
            ¥{{ scope.row.price }}
          </template>
        </el-table-column>
        <el-table-column prop="monthlySales" label="月销量" width="100"></el-table-column>
        <el-table-column prop="productStatus" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.productStatus === 1 ? 'success' : 'info'">
              {{ scope.row.productStatus === 1 ? '在售' : '下架' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="editProduct(scope.row)">编辑</el-button>
            <el-button type="text" size="small" @click="toggleStatus(scope.row)">
              {{ scope.row.productStatus === 1 ? '下架' : '上架' }}
            </el-button>
            <el-button type="text" size="small" @click="deleteProduct(scope.row)">删除</el-button>
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
        @current-change="getProductList"
      ></el-pagination>
    </el-card>

    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="商品名称" required>
          <el-input v-model="form.productName" placeholder="请输入商品名称"></el-input>
        </el-form-item>
        <el-form-item label="商品价格" required>
          <el-input-number v-model="form.price" :min="0" :precision="2"></el-input-number>
        </el-form-item>
        <el-form-item label="商品分类">
          <el-select v-model="form.categoryId" placeholder="请选择分类">
            <el-option
              v-for="category in categoryList"
              :key="category.categoryId"
              :label="category.categoryName"
              :value="category.categoryId"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="商品图片">
          <el-input v-model="form.productImage" placeholder="请输入图片URL"></el-input>
        </el-form-item>
        <el-form-item label="商品描述">
          <el-input v-model="form.productDesc" type="textarea" :rows="3"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveProduct">确定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { getProductList, addProduct, updateProduct, updateProductStatus, deleteProduct } from '@/api/merchant'
import { getProductCategoryList } from '@/api/common'

export default {
  name: 'MerchantProduct',
  data() {
    return {
      productList: [],
      categoryList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false,
      dialogVisible: false,
      dialogTitle: '添加商品',
      form: {
        productId: null,
        productName: '',
        price: 0,
        productImage: '',
        productDesc: '',
        categoryId: null
      }
    }
  },
  created() {
    this.getProductList()
  },
  methods: {
    async getProductList() {
      this.loading = true
      const res = await getProductList({ page: this.page, size: this.size })
      if (res.code === 200) {
        this.productList = res.data.records
        this.total = res.data.total
        if (this.productList.length > 0 && this.categoryList.length === 0) {
          this.getCategoryList(this.productList[0].shopId)
        }
      }
      this.loading = false
    },
    async getCategoryList(shopId) {
      const res = await getProductCategoryList(shopId)
      if (res.code === 200) {
        this.categoryList = res.data
      }
    },
    showAddDialog() {
      this.form = { productId: null, productName: '', price: 0, productImage: '', productDesc: '', categoryId: null }
      this.dialogTitle = '添加商品'
      this.dialogVisible = true
    },
    editProduct(row) {
      this.form = { ...row }
      this.dialogTitle = '编辑商品'
      this.dialogVisible = true
    },
    async saveProduct() {
      let res
      if (this.form.productId) {
        res = await updateProduct(this.form)
      } else {
        res = await addProduct(this.form)
      }
      if (res.code === 200) {
        this.$message.success('保存成功')
        this.dialogVisible = false
        this.getProductList()
      }
    },
    async toggleStatus(row) {
      const newStatus = row.productStatus === 1 ? 0 : 1
      const res = await updateProductStatus(row.productId, newStatus)
      if (res.code === 200) {
        this.$message.success('操作成功')
        this.getProductList()
      }
    },
    async deleteProduct(row) {
      this.$confirm('确定删除该商品吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        const res = await deleteProduct(row.productId)
        if (res.code === 200) {
          this.$message.success('删除成功')
          this.getProductList()
        }
      })
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
