<template>
  <div v-if="notice" class="notice-bar">
    <div class="notice-content">
      <i class="el-icon-bell notice-icon"></i>
      <span class="notice-text">{{ notice }}</span>
    </div>
  </div>
</template>

<script>
import { getNotice } from '@/api/common'

export default {
  name: 'NoticeBar',
  data() {
    return {
      notice: ''
    }
  },
  created() {
    this.loadNotice()
  },
  methods: {
    async loadNotice() {
      try {
        const res = await getNotice()
        if (res.code === 200 && res.data) {
          this.notice = res.data
        }
      } catch (error) {
        console.error('获取公告失败:', error)
      }
    }
  }
}
</script>

<style scoped>
.notice-bar {
  background: linear-gradient(90deg, #409EFF, #67C23A);
  color: #fff;
  padding: 8px 20px;
  overflow: hidden;
  position: relative;
}

.notice-content {
  display: flex;
  align-items: center;
  white-space: nowrap;
  animation: notice-scroll 15s linear infinite;
}

.notice-icon {
  margin-right: 10px;
  font-size: 16px;
  flex-shrink: 0;
}

.notice-text {
  font-size: 14px;
}

@keyframes notice-scroll {
  0% {
    transform: translateX(100%);
  }
  100% {
    transform: translateX(-100%);
  }
}
</style>