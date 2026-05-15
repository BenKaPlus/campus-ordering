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
        <div class="shop-rating" v-if="reviewSummary">
          <span class="rating-label">综合评分：</span>
          <span class="rating-value">{{ reviewSummary.overallRating }}分</span>
          <el-rate v-model="reviewSummary.overallRating" disabled :max="5" show-score />
        </div>
      </div>
    </div>

    <div class="shop-tabs">
      <el-tabs v-model="activeTab">
        <el-tab-pane label="商品" name="product">
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
        </el-tab-pane>

        <el-tab-pane label="评价" name="review">
          <div class="review-section">
            <div class="review-summary" v-if="reviewSummary">
              <el-row :gutter="20">
                <el-col :span="6">
                  <div class="summary-item">
                    <div class="summary-label">综合评分</div>
                    <div class="summary-value">{{ reviewSummary.overallRating }}分</div>
                  </div>
                </el-col>
                <el-col :span="6">
                  <div class="summary-item">
                    <div class="summary-label">服务态度</div>
                    <div class="summary-value">{{ reviewSummary.avgServiceRating }}分</div>
                  </div>
                </el-col>
                <el-col :span="6">
                  <div class="summary-item">
                    <div class="summary-label">配送速度</div>
                    <div class="summary-value">{{ reviewSummary.avgDeliveryRating }}分</div>
                  </div>
                </el-col>
                <el-col :span="6">
                  <div class="summary-item">
                    <div class="summary-label">评价总数</div>
                    <div class="summary-value">{{ reviewSummary.totalCount }}条</div>
                  </div>
                </el-col>
              </el-row>
            </div>

            <div class="review-list" v-loading="reviewLoading">
              <div v-for="review in reviewList" :key="review.reviewId" class="review-item">
                <div class="review-user">
                  <el-avatar :size="40" :src="review.userAvatar" v-if="!review.isAnonymous" />
                  <el-avatar :size="40" v-else />
                  <span class="user-name">{{ review.isAnonymous ? '匿名用户' : review.userName }}</span>
                  <span class="review-time">{{ review.createTime }}</span>
                </div>
                <div class="review-ratings">
                  <el-rate v-model="review.serviceRating" disabled size="small" />
                  <span class="rating-text">服务态度</span>
                  <el-rate v-model="review.deliveryRating" disabled size="small" style="margin-left: 20px;" />
                  <span class="rating-text">配送速度</span>
                  <el-rate v-model="review.productRating" disabled size="small" style="margin-left: 20px;" />
                  <span class="rating-text">商品满意</span>
                </div>
                <div class="review-text" v-if="review.reviewText">{{ review.reviewText }}</div>
                <div class="review-replies" v-if="review.replyList && review.replyList.length > 0">
                  <div v-for="reply in review.replyList" :key="reply.replyId" class="reply-item">
                    <div class="reply-header">
                      <span class="reply-label">商家回复</span>
                      <span class="reply-time">{{ reply.createTime }}</span>
                    </div>
                    <div class="reply-text">{{ reply.replyText }}</div>
                  </div>
                </div>
              </div>
              <el-empty v-if="reviewList.length === 0" description="暂无评价"></el-empty>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script>
import { getShopDetail, getProductCategoryList, getProductList } from '@/api/common'
import { addCart } from '@/api/student'
import { getShopReviews, getShopReviewSummary } from '@/api/review'

export default {
  name: 'ShopDetail',
  data() {
    return {
      shopId: null,
      shopInfo: {},
      productCategoryList: [],
      currentCategoryId: null,
      productList: [],
      activeTab: 'product',
      reviewList: [],
      reviewSummary: null,
      reviewLoading: false
    }
  },
  created() {
    this.shopId = this.$route.params.shopId
    this.getShopInfo()
    this.getProductCategories()
    this.getReviewSummary()
    this.getReviewList()
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
    },
    async getReviewSummary() {
      try {
        const res = await getShopReviewSummary(this.shopId)
        if (res.code === 200) {
          this.reviewSummary = res.data
        }
      } catch (error) {
        console.error('获取评价统计失败:', error)
      }
    },
    async getReviewList() {
      this.reviewLoading = true
      try {
        const res = await getShopReviews(this.shopId)
        if (res.code === 200) {
          this.reviewList = res.data || []
        }
      } catch (error) {
        console.error('获取评价列表失败:', error)
      } finally {
        this.reviewLoading = false
      }
    }
  },
  watch: {
    activeTab(newVal) {
      if (newVal === 'review') {
        this.getReviewSummary()
        this.getReviewList()
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

.shop-rating {
  margin-top: 10px;
  display: flex;
  align-items: center;
}
.shop-rating .rating-label {
  color: #606266;
  margin-right: 10px;
}
.shop-rating .rating-value {
  font-size: 18px;
  font-weight: bold;
  color: #f56c6c;
  margin-right: 10px;
}

.shop-tabs {
  background: #fff;
  border-radius: 8px;
  padding: 10px;
}

.review-section {
  padding: 20px 0;
}
.review-summary {
  margin-bottom: 30px;
  padding: 20px;
  background: #f5f7fa;
  border-radius: 8px;
}
.summary-item {
  text-align: center;
}
.summary-label {
  color: #909399;
  font-size: 14px;
  margin-bottom: 10px;
}
.summary-value {
  font-size: 24px;
  font-weight: bold;
  color: #f56c6c;
}
.review-list {
  padding: 0 10px;
}
.review-item {
  padding: 20px 0;
  border-bottom: 1px solid #ebeef5;
}
.review-item:last-child {
  border-bottom: none;
}
.review-user {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}
.review-user .user-name {
  margin-left: 15px;
  font-weight: bold;
}
.review-user .review-time {
  margin-left: 15px;
  color: #909399;
  font-size: 12px;
}
.review-ratings {
  margin-bottom: 15px;
  display: flex;
  align-items: center;
}
.review-ratings .rating-text {
  font-size: 12px;
  color: #606266;
  margin-left: 5px;
}
.review-text {
  color: #303133;
  line-height: 1.6;
}
.review-replies {
  margin-top: 15px;
}
.reply-item {
  background: #ecf5ff;
  padding: 15px;
  border-radius: 4px;
}
.reply-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}
.reply-label {
  font-weight: bold;
  color: #409eff;
}
.reply-time {
  font-size: 12px;
  color: #909399;
}
.reply-text {
  color: #303133;
  line-height: 1.6;
}
</style>
