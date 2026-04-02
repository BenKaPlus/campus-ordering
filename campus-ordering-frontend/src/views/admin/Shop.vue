<template>
  <div class="shop-container">
    <el-card>
      <div class="filter-row">
        <div class="filter-left">
          <el-radio-group v-model="searchStatus" @change="handleStatusChange">
            <el-radio-button label="">全部</el-radio-button>
            <el-radio-button label="1">营业中</el-radio-button>
            <el-radio-button label="2">已打烊</el-radio-button>
          </el-radio-group>
        </div>
        <div class="filter-right">
          <el-input
            v-model="searchShopName"
            placeholder="搜索店铺名称"
            style="width: 200px;"
            @keyup.enter.native="loadShops"
          ></el-input>
          <el-button type="primary" @click="loadShops">搜索</el-button>
        </div>
      </div>

      <el-table :data="shopList" style="width: 100%;" v-loading="loading">
        <el-table-column prop="shopId" label="店铺ID" width="80"></el-table-column>
        <el-table-column prop="shopName" label="店铺名称" min-width="150"></el-table-column>
        <el-table-column prop="ownerName" label="店主" width="100"></el-table-column>
        <el-table-column prop="phone" label="店主手机" width="120"></el-table-column>
        <el-table-column prop="contactPhone" label="店铺电话" width="120"></el-table-column>
        <el-table-column prop="shopDesc" label="店铺简介" min-width="150" show-overflow-tooltip></el-table-column>
        <el-table-column prop="deliveryFee" label="配送费" width="80">
          <template slot-scope="scope">¥{{ scope.row.deliveryFee }}</template>
        </el-table-column>
        <el-table-column prop="minOrderAmount" label="起送价" width="80">
          <template slot-scope="scope">¥{{ scope.row.minOrderAmount }}</template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'warning'">
              {{ scope.row.status === 1 ? '营业中' : '已打烊' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="editShop(scope.row)">编辑</el-button>
            <el-button type="text" size="small" @click="toggleStatus(scope.row)">
              {{ scope.row.status === 1 ? '打烊' : '营业' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        class="pagination"
        background
        layout="total, prev, pager, next"
        :total="total"
        :current-page.sync="page"
        :page-size.sync="size"
        @current-change="loadShops"
      ></el-pagination>
    </el-card>

    <el-dialog title="编辑店铺" :visible.sync="dialogVisible" width="500px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="店铺名称">
          <el-input v-model="form.shopName"></el-input>
        </el-form-item>
        <el-form-item label="店主手机">
          <el-input v-model="form.ownerPhone" disabled></el-input>
        </el-form-item>
        <el-form-item label="店铺联系电话">
          <el-input v-model="form.contactPhone" placeholder="店铺对外联系电话"></el-input>
        </el-form-item>
        <el-form-item label="店铺简介">
          <el-input v-model="form.shopDesc" type="textarea" :rows="3"></el-input>
        </el-form-item>
        <el-form-item label="配送费">
          <el-input-number v-model="form.deliveryFee" :precision="2" :min="0" :step="0.5"></el-input-number>
        </el-form-item>
        <el-form-item label="起送金额">
          <el-input-number v-model="form.minOrderAmount" :precision="2" :min="0" :step="5"></el-input-number>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveShop">确定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import request from '@/api'

export default {
  name: 'AdminShop',
  data() {
    return {
      searchShopName: '',
      searchStatus: '',
      shopList: [],
      page: 1,
      size: 10,
      total: 0,
      loading: false,
      dialogVisible: false,
      form: {}
    }
  },
  created() {
    this.loadShops()
  },
  methods: {
    handleStatusChange() {
      this.page = 1
      this.loadShops()
    },
    async loadShops() {
      this.loading = true
      try {
        const params = {
          page: this.page,
          size: this.size,
          shopName: this.searchShopName
        }
        if (this.searchStatus !== '') {
          params.status = parseInt(this.searchStatus)
        }
        const res = await request.get('/admin/shop/list', { params })
        if (res.code === 200 && res.data) {
          this.shopList = res.data.records || []
          this.total = res.data.total || 0
        }
      } catch (error) {
        this.$message.error('加载店铺列表失败')
      } finally {
        this.loading = false
      }
    },
    editShop(row) {
      this.form = {
        shopId: row.shopId,
        shopName: row.shopName,
        ownerPhone: row.phone,
        contactPhone: row.contactPhone,
        shopDesc: row.shopDesc,
        deliveryFee: row.deliveryFee,
        minOrderAmount: row.minOrderAmount
      }
      this.dialogVisible = true
    },
    async saveShop() {
      try {
        await request.put('/admin/shop/update', this.form)
        this.$message.success('保存成功')
        this.dialogVisible = false
        this.loadShops()
      } catch (error) {
        this.$message.error('保存失败')
      }
    },
    async toggleStatus(row) {
      try {
        const newStatus = row.status === 1 ? 2 : 1
        await request.put('/admin/shop/status', null, {
          params: {
            shopId: row.shopId,
            status: newStatus
          }
        })
        row.status = newStatus
        this.$message.success('操作成功')
      } catch (error) {
        this.$message.error('操作失败')
      }
    }
  }
}
</script>

<style scoped>
.shop-container {
  padding: 20px;
}
.filter-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.filter-right {
  display: flex;
  gap: 10px;
}
.pagination {
  margin-top: 20px;
  text-align: center;
}
</style>
