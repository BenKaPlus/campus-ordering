<template>
  <div class="shop-container">
    <el-card v-loading="loading">
      <div slot="header">店铺管理</div>
      <el-form :model="shopForm" label-width="100px">
        <el-tabs value="basic">
          <el-tab-pane label="基本信息" name="basic">
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
          </el-tab-pane>
          <el-tab-pane label="收款设置" name="payment">
            <el-form-item label="微信收款码">
              <el-upload
                class="qrcode-uploader"
                :show-file-list="false"
                :before-upload="(file) => beforeUpload(file, 'wx')"
                :http-request="(option) => uploadQrcode(option, 'wx')"
              >
                <img v-if="shopForm.wxQrcode" :src="shopForm.wxQrcode" class="qrcode-image">
                <i v-else class="el-icon-plus qrcode-icon"></i>
              </el-upload>
              <div class="upload-tip">点击上传微信收款二维码</div>
            </el-form-item>
            <el-form-item label="支付宝收款码">
              <el-upload
                class="qrcode-uploader"
                :show-file-list="false"
                :before-upload="(file) => beforeUpload(file, 'ali')"
                :http-request="(option) => uploadQrcode(option, 'ali')"
              >
                <img v-if="shopForm.aliQrcode" :src="shopForm.aliQrcode" class="qrcode-image">
                <i v-else class="el-icon-plus qrcode-icon"></i>
              </el-upload>
              <div class="upload-tip">点击上传支付宝收款二维码</div>
            </el-form-item>
          </el-tab-pane>
        </el-tabs>
        <el-form-item>
          <el-button type="primary" @click="saveShop">保存</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { getShopDetail, updateShopInfo, updateShopStatus } from '@/api/merchant'
import { uploadImage } from '@/api/common'

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
        shopStatus: 1,
        wxQrcode: '',
        aliQrcode: ''
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
    },
    beforeUpload(file) {
      const isImage = file.type.startsWith('image/')
      const isLt5M = file.size / 1024 / 1024 < 5
      if (!isImage) {
        this.$message.error('只能上传图片文件')
        return false
      }
      if (!isLt5M) {
        this.$message.error('图片大小不能超过 5MB')
        return false
      }
      return true
    },
    async uploadQrcode(option, type) {
      try {
        const res = await uploadImage(option.file)
        if (res.code === 200) {
          const url = res.data
          if (type === 'wx') {
            this.shopForm.wxQrcode = url
          } else {
            this.shopForm.aliQrcode = url
          }
          this.$message.success('上传成功')
        } else {
          this.$message.error(res.msg || '上传失败')
        }
      } catch (error) {
        this.$message.error('上传失败')
      }
    }
  }
}
</script>

<style scoped>
.shop-container {
  padding: 20px;
}
.qrcode-uploader {
  width: 150px;
  height: 150px;
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}
.qrcode-uploader:hover {
  border-color: #409EFF;
}
.qrcode-icon {
  font-size: 28px;
  color: #8c939d;
}
.qrcode-image {
  width: 150px;
  height: 150px;
  object-fit: contain;
}
.upload-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}
</style>
