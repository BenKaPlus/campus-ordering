<template>
  <div class="shop-container">
    <el-card v-loading="loading">
      <div slot="header">店铺管理</div>
      <el-form :model="shopForm" label-width="100px">
        <el-form-item label="店铺名称">
          <el-input v-model="shopForm.shopName" placeholder="请输入店铺名称"></el-input>
        </el-form-item>
        <el-form-item label="店铺描述">
          <el-input
            v-model="shopForm.shopDesc"
            type="textarea"
            :rows="2"
            placeholder="请输入店铺描述"
          ></el-input>
        </el-form-item>
        <el-form-item label="营业时间">
          <el-input v-model="shopForm.businessHours" placeholder="如: 09:00-21:00"></el-input>
        </el-form-item>
        <el-form-item label="配送费">
          <el-input-number v-model="shopForm.deliveryFee" :min="0" :precision="2" :step="0.5"></el-input-number>
        </el-form-item>
        <el-form-item label="起送价">
          <el-input-number v-model="shopForm.minOrderAmount" :min="0" :precision="2" :step="1"></el-input-number>
        </el-form-item>
        <el-form-item label="联系电话">
          <el-input v-model="shopForm.contactPhone" placeholder="请输入联系电话"></el-input>
        </el-form-item>
        <el-form-item label="店铺地址">
          <el-input v-model="shopForm.shopAddress" placeholder="请输入店铺地址"></el-input>
        </el-form-item>
        <el-form-item label="营业状态">
          <el-switch
            v-model="shopForm.shopStatus"
            :active-value="1"
            :inactive-value="0"
            active-text="营业中"
            inactive-text="已打烊"
          ></el-switch>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="saveShop">保存</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { getShopDetail, updateShopInfo, updateShopStatus } from '@/api/merchant'

export default {
  name: 'MerchantShop',
  data() {
    return {
      loading: false,
      shopForm: {
        shopId: null,
        shopName: '',
        shopDesc: '',
        businessHours: '',
        deliveryFee: 0,
        minOrderAmount: 0,
        contactPhone: '',
        shopAddress: '',
        shopStatus: 1
      }
    }
  },
  created() {
    this.getShopDetail()
  },
  methods: {
    async getShopDetail() {
      this.loading = true
      const res = await getShopDetail()
      if (res.code === 200 && res.data) {
        this.shopForm = res.data
      }
      this.loading = false
    },
    async saveShop() {
      const res = await updateShopInfo(this.shopForm)
      if (res.code === 200) {
        if (this.shopForm.shopStatus !== undefined) {
          await updateShopStatus(this.shopForm.shopStatus)
        }
        this.$message.success('保存成功')
        this.getShopDetail()
      }
    }
  }
}
</script>

<style scoped>
.shop-container {
  padding: 20px;
}
</style>
