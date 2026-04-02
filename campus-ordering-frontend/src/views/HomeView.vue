<template>
  <div class="home">
    <h1>🎉 校园点餐系统 - 首页</h1>
    <p>Vue 2 + Element UI 环境搭建成功！</p>
    
    <!-- 测试 Element UI 是否生效 -->
    <el-button type="primary" icon="el-icon-shopping-cart-2">开始点餐</el-button>
    <el-button type="success">查看订单</el-button>
  </div>
</template>

<script>
export default {
  name: 'HomeView',
}
</script>

<style scoped>
.home {
  text-align: center;
  margin-top: 50px;
}
h1 {
  color: #409EFF;
}
</style>