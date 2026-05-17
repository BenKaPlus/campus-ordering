<template>
  <div class="home-container">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-select v-model="searchType" style="width: 100px; margin-right: 10px;" size="small">
        <el-option label="店铺" value="shop"></el-option>
        <el-option label="商品" value="product"></el-option>
      </el-select>
      <el-input v-model="keyword" placeholder="搜索店铺或商品" style="width: 300px;" clearable @keyup.enter="handleSearch">
        <el-button slot="append" icon="el-icon-search" @click="handleSearch"></el-button>
      </el-input>
    </div>

    <!-- 店铺分类 -->
    <div class="category-bar" v-if="searchType === 'shop'">
      <el-tag
        v-for="category in categoryList"
        :key="category.categoryId"
        :type="currentCategoryId === category.categoryId ? 'primary' : ''"
        @click="currentCategoryId = category.categoryId; getShopList()"
        class="category-tag"
      >
        {{ category.categoryName }}
      </el-tag>
    </div>

    <!-- 店铺列表 -->
    <div class="shop-list" v-if="searchType === 'shop'">
      <el-card v-for="shop in shopList" :key="shop.shopId" class="shop-card" @click.native="goShopDetail(shop.shopId)">
        <div class="shop-info">
          <img :src="shop.shopLogo" class="shop-logo" alt="店铺logo" @error="shop.shopLogo = '/placeholder.png'">
          <div class="shop-detail">
            <h3>{{ shop.shopName }}</h3>
            <p class="shop-desc">{{ shop.shopDesc }}</p>
            <div class="shop-meta">
              <span class="shop-score">评分：{{ shop.shopScore }}</span>
              <span class="shop-sales">月售：{{ shop.monthlySales }}</span>
              <span class="shop-delivery">配送费：¥{{ shop.deliveryFee }}</span>
            </div>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 商品列表 -->
    <div class="product-list" v-if="searchType === 'product'">
      <el-card v-for="product in productList" :key="product.productId" class="product-card" @click.native="goShopDetail(product.shopId)">
        <div class="product-info">
          <div class="product-main">
            <img :src="product.productImage" class="product-image" alt="商品图片" @error="product.productImage = '/placeholder.png'">
            <div class="product-detail">
              <h3>{{ product.productName }}</h3>
              <p class="product-desc">{{ product.productDesc }}</p>
              <div class="product-meta">
                <span class="product-price">¥{{ product.price }}</span>
                <span class="product-sales">月售：{{ product.monthlySales }}</span>
              </div>
            </div>
          </div>
          <div class="product-shop">
            <span class="shop-label">所属店铺</span>
            <span class="shop-name">{{ product.shopName }}</span>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 空状态 -->
    <div class="empty-state" v-if="(searchType === 'shop' && shopList.length === 0 && page === 1) || (searchType === 'product' && productList.length === 0 && page === 1)">
      <el-empty description="暂无搜索结果"></el-empty>
    </div>

    <!-- 分页：只有数据超过一页时才显示 -->
    <el-pagination
      v-if="total > size"
      class="pagination"
      background
      layout="prev, pager, next"
      :total="total"
      :current-page.sync="page"
      :page-size.sync="size"
      @current-change="handlePageChange"
    ></el-pagination>
  </div>
</template>

<script>
import { getShopCategoryList, getShopList as fetchShopList, searchProduct } from '@/api/common'

export default {
  name: 'StudentHome',
  data() {
    return {
      keyword: '',
      searchType: 'shop',
      categoryList: [],
      currentCategoryId: null,
      shopList: [],
      productList: [],
      page: 1,
      size: 10,
      total: 0
    }
  },
  created() {
    this.getCategoryList()
    this.getShopList()
  },
  methods: {
    async getCategoryList() {
      const res = await getShopCategoryList()
      if (res.code === 200) {
        this.categoryList = res.data
      }
    },
    async getShopList() {
      const res = await fetchShopList({
        categoryId: this.currentCategoryId,
        keyword: this.keyword,
        page: this.page,
        size: this.size
      })
      if (res.code === 200) {
        this.shopList = res.data.records
        this.total = res.data.total
      }
    },
    async getProductList() {
      console.log('搜索关键词:', this.keyword)
      const res = await searchProduct(this.keyword, null, { page: this.page, size: this.size })
      console.log('商品搜索结果:', res)
      if (res.code === 200) {
        this.productList = res.data.records
        this.total = res.data.total
      }
    },
    handleSearch() {
      this.page = 1
      if (this.searchType === 'shop') {
        this.getShopList()
      } else {
        this.getProductList()
      }
    },
    goShopDetail(shopId) {
      this.$router.push('/shop/' + shopId)
    },
    handlePageChange() {
      if (this.searchType === 'shop') {
        this.getShopList()
      } else {
        this.getProductList()
      }
    }
  },
  watch: {
    searchType() {
      this.page = 1
      if (this.searchType === 'shop') {
        this.getShopList()
      } else {
        this.getProductList()
      }
    }
  }
}
</script>

<style scoped>
.home-container {
  padding: 20px;
}
.search-bar {
  margin-bottom: 20px;
  text-align: center;
}
.category-bar {
  margin-bottom: 20px;
}
.category-tag {
  margin-right: 10px;
  cursor: pointer;
}
.shop-list {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}
.shop-card {
  width: 300px;
  cursor: pointer;
}
.shop-info {
  display: flex;
}
.shop-logo {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  margin-right: 15px;
}
.shop-detail h3 {
  margin: 0 0 10px 0;
}
.shop-desc {
  color: #666;
  font-size: 12px;
  margin: 0 0 10px 0;
}
.shop-meta span {
  margin-right: 15px;
  font-size: 12px;
  color: #999;
}

/* 商品列表样式 - 一行一行展示 */
.product-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}
.product-card {
  width: 100%;
  cursor: pointer;
}
.product-info {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.product-main {
  display: flex;
  align-items: center;
  flex: 1;
}
.product-image {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  margin-right: 15px;
}
.product-detail h3 {
  margin: 0 0 10px 0;
}
.product-desc {
  color: #666;
  font-size: 12px;
  margin: 0 0 10px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 300px;
}
.product-meta span {
  margin-right: 15px;
  font-size: 12px;
}
.product-price {
  color: #f56c6c;
  font-weight: bold;
}
.product-sales {
  color: #999;
}

/* 商品店铺信息样式 */
.product-shop {
  text-align: right;
  padding-left: 20px;
  border-left: 1px solid #eee;
}
.shop-label {
  display: block;
  font-size: 12px;
  color: #999;
  margin-bottom: 5px;
}
.shop-name {
  font-size: 14px;
  font-weight: bold;
  color: #409eff;
}

.empty-state {
  text-align: center;
  margin: 50px 0;
}
.pagination {
  margin-top: 20px;
  text-align: center;
}
</style>