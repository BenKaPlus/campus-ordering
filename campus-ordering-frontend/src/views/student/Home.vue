<template>
  <div class="home-container">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input v-model="keyword" placeholder="搜索商品" style="width: 300px;" clearable>
        <el-button slot="append" icon="el-icon-search" @click="handleSearch"></el-button>
      </el-input>
    </div>

    <!-- 店铺分类 -->
    <div class="category-bar">
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
    <div class="shop-list">
      <el-card v-for="shop in shopList" :key="shop.shopId" class="shop-card" @click.native="goShopDetail(shop.shopId)">
        <div class="shop-info">
          <img :src="shop.shopLogo" class="shop-logo" alt="店铺logo">
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

    <!-- 分页 -->
    <el-pagination
      class="pagination"
      background
      layout="prev, pager, next"
      :total="total"
      :current-page.sync="page"
      :page-size.sync="size"
      @current-change="getShopList"
    ></el-pagination>
  </div>
</template>

<script>
import { getShopCategoryList, getShopList as fetchShopList } from '@/api/common'

export default {
  name: 'StudentHome',
  data() {
    return {
      keyword: '',
      categoryList: [],
      currentCategoryId: null,
      shopList: [],
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
    handleSearch() {
      this.page = 1
      this.getShopList()
    },
    goShopDetail(shopId) {
      this.$router.push('/shop/' + shopId)
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
.pagination {
  margin-top: 20px;
  text-align: center;
}
</style>