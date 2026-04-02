<template>
  <div id="app">
    <!-- 这里非常重要：router-view 是路由组件的出口 -->
    <!-- 你之前创建的 HomeView 内容就会显示在这里 -->
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
/* 全局样式重置，去掉默认的一些边距 */
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  /* 不要加 margin-top，让内容顶格显示，或者根据需要调整 */
}

/* 如果你还想保留一点默认的全局样式可以留着，否则可以清空 */
body {
  margin: 0;
}
</style>