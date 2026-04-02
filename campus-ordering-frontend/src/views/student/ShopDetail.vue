<template>
  <div class="shop-detail-container">
    <div class="shop-header">
      <img :src="shopInfo.shopLogo" class="shop-logo" alt="店铺logo">
      <div class="shop-info">
        <h2>{{ shopInfo.shopName }}</h2>
        <p class="shop-desc">{{ shopInfo.shopDesc }}</p>
        <div class="shop-meta">
          <span>营业时间：{{ shopInfo.businessHours }}</span>
          <span>起送：¥{{ shopInfo.minOrderAmount }}</span>
          <span>配送费：¥{{ shopInfo.deliveryFee }}</span>
        </div>
      </div>
    </div>

    <div class="shop-content">
      <div class="category-sidebar">
        <div
          v-for="category in productCategoryList"
          :key="category.categoryId"
          :class="['category-item', { active: currentCategoryId === category.categoryId }]"
          @click="currentCategoryId = category.categoryId; getProductList()"
        >
          {{ category.categoryName }}
        </div>
      </div>

      <div class="product-list">
        <el-card v-for="product in productList" :key="product.productId" class="product-card">
          <div class="product-info">
            <img :src="product.productImage" class="product-img" alt="商品图片">
            <div class="product-detail">
              <h4>{{ product.productName }}</h4>
              <p class="product-desc">{{ product.productDesc }}</p>
              <div class="product-bottom">
                <div class="product-meta">
                  <span class="product-price">¥{{ product.price }}</span>
                  <span class="product-sales">月售{{ product.monthlySales }}</span>
                </div>
                <el-button type="primary" size="small" @click="addToCart(product)">加入购物车</el-button>
              </div>
            </div>
          </div>
        </el-card>
        <el-empty v-if="productList.length === 0" description="暂无商品"></el-empty>
      </div>
    </div>
  </div>
</template>

<script>
import { getShopDetail, getProductCategoryList, getProductList } from '@/api/common'
import { addCart } from '@/api/student'

export default {
  name: 'ShopDetail',
  data() {
    return {
      shopId: null,
      shopInfo: {},
      productCategoryList: [],
      currentCategoryId: null,
      productList: []
    }
  },
  created() {
    this.shopId = this.$route.params.shopId
    this.getShopInfo()
    this.getProductCategories()
  },
  methods: {
    async getShopInfo() {
      const res = await getShopDetail(this.shopId)
      if (res.code === 200) {
        this.shopInfo = res.data
      }
    },
    async getProductCategories() {
      const res = await getProductCategoryList(this.shopId)
      if (res.code === 200) {
        this.productCategoryList = res.data
        if (this.productCategoryList.length > 0) {
          this.currentCategoryId = this.productCategoryList[0].categoryId
          this.getProductList()
        }
      }
    },
    async getProductList() {
      const res = await getProductList(this.shopId, {
        categoryId: this.currentCategoryId,
        page: 1,
        size: 50
      })
      if (res.code === 200) {
        this.productList = res.data.records || []
      }
    },
    async addToCart(product) {
      const res = await addCart({
        shopId: this.shopId,
        productId: product.productId,
        productNum: 1
      })
      if (res.code === 200) {
        this.$message.success('已加入购物车')
        this.$store.commit('SET_CART_COUNT', this.$store.getters.cartCount + 1)
      }
    }
  }
}
</script>

<style scoped>
.shop-detail-container {
  padding: 20px;
}
.shop-header {
  display: flex;
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}
.shop-logo {
  width: 120px;
  height: 120px;
  border-radius: 8px;
  margin-right: 20px;
  object-fit: cover;
}
.shop-info h2 {
  margin: 0 0 10px 0;
}
.shop-desc {
  color: #666;
  margin: 0 0 15px 0;
}
.shop-meta span {
  margin-right: 20px;
  color: #999;
  font-size: 14px;
}
.shop-content {
  display: flex;
  gap: 20px;
}
.category-sidebar {
  width: 150px;
  background: #fff;
  border-radius: 8px;
  padding: 10px 0;
  height: fit-content;
}
.category-item {
  padding: 12px 20px;
  cursor: pointer;
  transition: all 0.3s;
}
.category-item:hover {
  background: #f5f7fa;
}
.category-item.active {
  background: #ecf5ff;
  color: #409eff;
  border-right: 3px solid #409eff;
}
.product-list {
  flex: 1;
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  align-content: flex-start;
}
.product-card {
  width: 280px;
}
.product-info {
  display: flex;
}
.product-img {
  width: 100px;
  height: 100px;
  border-radius: 8px;
  margin-right: 15px;
  object-fit: cover;
}
.product-detail {
  flex: 1;
}
.product-detail h4 {
  margin: 0 0 8px 0;
  font-size: 16px;
}
.product-desc {
  color: #999;
  font-size: 12px;
  margin: 0 0 10px 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.product-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.product-price {
  color: #f56c6c;
  font-size: 18px;
  font-weight: bold;
}
.product-sales {
  color: #999;
  font-size: 12px;
  margin-left: 10px;
}
</style>
