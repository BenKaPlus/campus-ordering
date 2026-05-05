<template>
  <div class="product-container">
    <el-card>
      <div slot="header">
        <el-button type="primary" @click="showAddDialog">添加商品</el-button>
      </div>
      <el-table :data="productList" style="width: 100%;" v-loading="loading">
        <el-table-column prop="productImage" label="商品图片" width="120">
          <template slot-scope="scope">
            <div class="image-cell">
              <img :src="scope.row.productImage" class="product-img" alt="商品图片" v-if="scope.row.productImage">
              <span v-else class="no-image">暂无图片</span>
              <el-upload
                class="upload-btn"
                action="/api/common/upload/image"
                :headers="{ 'Authorization': getAuthHeader() }"
                :show-file-list="false"
                :on-success="(response) => handleProductImageUpload(response, scope.row)"
                :on-error="handleUploadError"
                accept="image/*"
              >
                <el-button type="text" size="small">{{ scope.row.productImage ? '更换图片' : '上传图片' }}</el-button>
              </el-upload>
            </div>
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

    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="600px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="商品名称" required>
          <el-input v-model="form.productName" placeholder="请输入商品名称"></el-input>
        </el-form-item>
        <el-form-item label="商品价格" required>
          <el-input-number v-model="form.price" :min="0" :precision="2"></el-input-number>
        </el-form-item>
        <el-form-item label="商品原价">
          <el-input-number v-model="form.originalPrice" :min="0" :precision="2"></el-input-number>
        </el-form-item>
        <el-form-item label="商品单位">
          <el-input v-model="form.unit" placeholder="请输入商品单位（份、杯、个等）"></el-input>
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
        <el-form-item label="商品主图">
          <el-upload
            class="avatar-uploader"
            action="/api/common/upload/image"
            :headers="{ 'Authorization': getAuthHeader() }"
            :show-file-list="false"
            :on-success="(response) => handleImageUpload(response, 'productImage')"
            :on-error="handleUploadError"
            accept="image/*"
          >
            <img v-if="form.productImage" :src="form.productImage" class="avatar">
            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>
        <el-form-item label="商品描述">
          <el-input v-model="form.productDesc" type="textarea" :rows="3"></el-input>
        </el-form-item>
        <el-form-item label="排序号">
          <el-input-number v-model="form.sort" :min="0"></el-input-number>
        </el-form-item>
        <el-form-item label="商品状态">
          <el-radio-group v-model="form.productStatus">
            <el-radio :label="1">上架</el-radio>
            <el-radio :label="0">下架</el-radio>
          </el-radio-group>
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
import { getProductList, addProduct, updateProduct, updateProductStatus, deleteProduct, updateProductImage } from '@/api/merchant'
import { getProductCategoryList } from '@/api/common'
import request from '@/api/index'

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
        originalPrice: 0,
        unit: '',
        productImage: '',
        productDesc: '',
        categoryId: null,
        sort: 0,
        productStatus: 1
      }
    }
  },
  created() {
    this.getProductList()
  },
  methods: {
    async getProductList() {
      this.loading = true
      try {
        const res = await getProductList({ page: this.page, size: this.size })
        console.log('获取商品列表响应:', res)
        if (res && res.code === 200 && res.data) {
          this.productList = res.data.records || []
          this.total = res.data.total || 0
          // 尝试获取店铺ID并加载分类
          if (this.categoryList.length === 0) {
            this.getShopInfo()
          }
        } else {
          console.error('获取商品列表失败:', res)
          this.productList = []
          this.total = 0
        }
      } catch (error) {
        console.error('获取商品列表异常:', error)
        this.productList = []
        this.total = 0
      } finally {
        this.loading = false
      }
    },
    async getShopInfo() {
      try {
        const res = await request({
          url: '/merchant/shop/detail',
          method: 'get'
        })
        if (res && res.code === 200 && res.data && res.data.shopId) {
          this.getCategoryList(res.data.shopId)
        }
      } catch (error) {
        console.error('获取店铺信息失败:', error)
      }
    },
    async getCategoryList(shopId) {
      try {
        const res = await getProductCategoryList(shopId)
        if (res && res.code === 200 && res.data) {
          this.categoryList = res.data
        }
      } catch (error) {
        console.error('获取分类列表失败:', error)
      }
    },
    handleImageUpload(response, fieldName) {
      if (response && response.code === 200 && response.data) {
        this.form[fieldName] = response.data
        this.$message.success('上传成功')
      } else {
        this.$message.error('上传失败：' + (response && response.msg ? response.msg : '未知错误'))
      }
    },
    async handleProductImageUpload(response, row) {
      if (response && response.code === 200 && response.data) {
        try {
          const res = await updateProductImage(row.productId, response.data)
          if (res && res.code === 200) {
            this.$message.success('图片更新成功')
            this.getProductList()
          } else {
            this.$message.error('更新失败：' + (res && res.msg ? res.msg : '未知错误'))
          }
        } catch (error) {
          console.error('更新商品图片失败:', error)
          this.$message.error('更新失败，请重试')
        }
      } else {
        this.$message.error('上传失败：' + (response && response.msg ? response.msg : '未知错误'))
      }
    },
    handleUploadError(error) {
      console.error('上传错误:', error)
      this.$message.error('上传失败，请重试')
    },
    showAddDialog() {
      this.form = { 
        productId: null, 
        productName: '', 
        price: 0, 
        originalPrice: 0, 
        unit: '', 
        productImage: '', 
        productDesc: '', 
        categoryId: null,
        sort: 0,
        productStatus: 1
      }
      this.dialogTitle = '添加商品'
      this.dialogVisible = true
    },
    editProduct(row) {
      this.form = { ...row }
      this.dialogTitle = '编辑商品'
      this.dialogVisible = true
    },
    async saveProduct() {
      try {
        let res
        if (this.form.productId) {
          res = await updateProduct(this.form)
        } else {
          res = await addProduct(this.form)
        }
        if (res && res.code === 200) {
          this.$message.success('保存成功')
          this.dialogVisible = false
          this.getProductList()
        } else {
          this.$message.error('保存失败：' + (res && res.msg ? res.msg : '未知错误'))
        }
      } catch (error) {
        console.error('保存商品失败:', error)
        this.$message.error('保存失败，请重试')
      }
    },
    async toggleStatus(row) {
      try {
        if (!row || !row.productId) {
          this.$message.error('商品信息有误')
          return
        }
        const newStatus = row.productStatus === 1 ? 0 : 1
        const res = await updateProductStatus(row.productId, newStatus)
        if (res && res.code === 200) {
          this.$message.success('操作成功')
          this.getProductList()
        } else {
          this.$message.error('操作失败：' + (res && res.msg ? res.msg : '未知错误'))
        }
      } catch (error) {
        console.error('操作商品状态失败:', error)
        this.$message.error('操作失败，请重试')
      }
    },
    async deleteProduct(row) {
      if (!row || !row.productId) {
        this.$message.error('商品信息有误')
        return
      }
      this.$confirm('确定删除该商品吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deleteProduct(row.productId)
          if (res && res.code === 200) {
            this.$message.success('删除成功')
            this.getProductList()
          } else {
            this.$message.error('删除失败：' + (res && res.msg ? res.msg : '未知错误'))
          }
        } catch (error) {
          console.error('删除商品失败:', error)
          this.$message.error('删除失败，请重试')
        }
      })
    },
    getAuthHeader() {
      try {
        if (typeof window !== 'undefined' && window.localStorage) {
          const token = localStorage.getItem('token')
          return token ? 'Bearer ' + token : ''
        }
        return ''
      } catch (error) {
        console.error('获取认证头失败:', error)
        return ''
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
  display: block;
}
.pagination {
  margin-top: 20px;
  text-align: center;
}
.avatar-uploader {
  width: 120px;
  height: 120px;
  position: relative;
}
.avatar-uploader-icon {
  width: 120px;
  height: 120px;
  line-height: 120px;
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  text-align: center;
  cursor: pointer;
}
.avatar {
  width: 120px;
  height: 120px;
  border-radius: 6px;
  object-fit: cover;
}
.image-cell {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
}
.no-image {
  font-size: 12px;
  color: #999;
  padding: 15px 0;
}
.upload-btn {
  margin-top: 2px;
}
</style>
