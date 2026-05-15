<template>
  <div class="merchant-review">
    <el-card>
      <div slot="header" class="header-wrapper">
        <span>评价管理</span>
      </div>
      
      <!-- 评价统计 -->
      <div class="review-stats" v-if="reviewSummary">
        <el-row :gutter="20">
          <el-col :span="6">
            <div class="stat-card">
              <div class="stat-label">综合评分</div>
              <div class="stat-value">{{ reviewSummary.overallRating }}分</div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="stat-card">
              <div class="stat-label">服务态度</div>
              <div class="stat-value">{{ reviewSummary.avgServiceRating }}分</div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="stat-card">
              <div class="stat-label">配送速度</div>
              <div class="stat-value">{{ reviewSummary.avgDeliveryRating }}分</div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="stat-card">
              <div class="stat-label">评价总数</div>
              <div class="stat-value">{{ reviewSummary.totalCount }}条</div>
            </div>
          </el-col>
        </el-row>
      </div>

      <!-- 评价列表 -->
      <el-table :data="reviewList" style="width: 100%; margin-top: 20px;" v-loading="loading">
        <el-table-column label="用户" width="150">
          <template slot-scope="scope">
            <div class="user-info">
              <el-avatar :size="40" :src="scope.row.userAvatar" v-if="!scope.row.isAnonymous" />
              <el-avatar :size="40" v-else />
              <span class="user-name">{{ scope.row.isAnonymous ? '匿名用户' : scope.row.userName }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="评分" width="250">
          <template slot-scope="scope">
            <div class="rating-info">
              <div class="rating-item">
                <span class="rating-label">服务：</span>
                <el-rate v-model="scope.row.serviceRating" disabled size="small" />
              </div>
              <div class="rating-item">
                <span class="rating-label">配送：</span>
                <el-rate v-model="scope.row.deliveryRating" disabled size="small" />
              </div>
              <div class="rating-item">
                <span class="rating-label">商品：</span>
                <el-rate v-model="scope.row.productRating" disabled size="small" />
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="评价内容" min-width="200">
          <template slot-scope="scope">{{ scope.row.reviewText || '暂无内容' }}</template>
        </el-table-column>
        <el-table-column label="评价时间" width="160">
          <template slot-scope="scope">{{ scope.row.createTime }}</template>
        </el-table-column>
        <el-table-column label="回复状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.replyList && scope.row.replyList.length > 0 ? 'success' : 'info'">
              {{ scope.row.replyList && scope.row.replyList.length > 0 ? '已回复' : '待回复' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="viewReviewDetail(scope.row)">查看详情</el-button>
            <el-button 
              v-if="!scope.row.replyList || scope.row.replyList.length === 0" 
              type="text" 
              size="small" 
              @click="openReplyDialog(scope.row)"
            >回复</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        class="pagination"
        background
        layout="prev, pager, next"
        :total="total"
        :current-page.sync="page"
        :page-size.sync="size"
        @current-change="getReviewList"
      />
    </el-card>

    <!-- 回复对话框 -->
    <el-dialog :visible.sync="replyDialogVisible" title="回复评价" width="500px">
      <el-form :model="replyForm" :rules="replyRules" ref="replyForm" label-width="80px">
        <el-form-item label="回复内容" prop="replyText">
          <el-input type="textarea" v-model="replyForm.replyText" :rows="5" placeholder="请输入回复内容" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="replyDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitReply" :loading="replySubmitting">提交回复</el-button>
      </div>
    </el-dialog>

    <!-- 查看详情对话框 -->
    <el-dialog :visible.sync="detailDialogVisible" title="评价详情" width="600px">
      <div v-if="currentReview" class="review-detail">
        <div class="review-user-info">
          <el-avatar :size="50" :src="currentReview.userAvatar" v-if="!currentReview.isAnonymous" />
          <el-avatar :size="50" v-else />
          <span class="user-name">{{ currentReview.isAnonymous ? '匿名用户' : currentReview.userName }}</span>
        </div>
        <div class="review-ratings">
          <div class="rating-item">
            <span class="rating-label">服务态度：</span>
            <el-rate v-model="currentReview.serviceRating" disabled />
          </div>
          <div class="rating-item">
            <span class="rating-label">配送速度：</span>
            <el-rate v-model="currentReview.deliveryRating" disabled />
          </div>
          <div class="rating-item">
            <span class="rating-label">商品满意：</span>
            <el-rate v-model="currentReview.productRating" disabled />
          </div>
          <div class="rating-item">
            <span class="rating-label">综合评分：</span>
            <span class="rating-value">{{ currentReview.overallRating }}分</span>
          </div>
        </div>
        <div class="review-text" v-if="currentReview.reviewText">
          {{ currentReview.reviewText }}
        </div>
        <div class="review-replies" v-if="currentReview.replyList && currentReview.replyList.length > 0">
          <h4>我的回复</h4>
          <div v-for="reply in currentReview.replyList" :key="reply.replyId" class="reply-item">
            <div class="reply-header">
              <span class="reply-user">{{ reply.replyUserName }}</span>
              <span class="reply-time">{{ reply.createTime }}</span>
            </div>
            <div class="reply-text">{{ reply.replyText }}</div>
          </div>
        </div>
        <div v-if="!currentReview.replyList || currentReview.replyList.length === 0" class="no-reply">
          <el-button type="primary" @click="openReplyDialog(currentReview)">立即回复</el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getMerchantShopReviews, getMerchantShopReviewSummary, replyReview } from '@/api/review'
import { getShopDetail } from '@/api/merchant'

export default {
  name: 'MerchantReview',
  data() {
    return {
      reviewList: [],
      reviewSummary: null,
      page: 1,
      size: 10,
      total: 0,
      loading: false,
      shopId: null,
      replyDialogVisible: false,
      detailDialogVisible: false,
      replySubmitting: false,
      currentReview: null,
      replyForm: {
        reviewId: null,
        replyText: ''
      },
      replyRules: {
        replyText: [
          { required: true, message: '请输入回复内容', trigger: 'blur' },
          { min: 1, max: 500, message: '回复内容长度在1到500个字符', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.initShopId()
  },
  methods: {
    async initShopId() {
      try {
        const res = await getShopDetail();
        if (res.code === 200 && res.data) {
          this.shopId = res.data.shopId;
          this.getReviewSummary();
          this.getReviewList();
        }
      } catch (error) {
        console.error('获取店铺信息失败:', error);
      }
    },
    async getReviewSummary() {
      try {
        const res = await getMerchantShopReviewSummary();
        if (res.code === 200) {
          this.reviewSummary = res.data;
        }
      } catch (error) {
        console.error('获取评价统计失败:', error);
      }
    },
    async getReviewList() {
      this.loading = true;
      try {
        const res = await getMerchantShopReviews();
        if (res.code === 200) {
          this.reviewList = res.data || [];
          this.total = res.data ? res.data.length : 0;
        }
      } catch (error) {
        console.error('获取评价列表失败:', error);
      } finally {
        this.loading = false;
      }
    },
    openReplyDialog(review) {
      this.currentReview = review
      this.replyForm = {
        reviewId: review.reviewId,
        replyText: ''
      }
      this.detailDialogVisible = false
      this.replyDialogVisible = true
    },
    async submitReply() {
      this.$refs.replyForm.validate(async (valid) => {
        if (valid) {
          this.replySubmitting = true
          try {
            await replyReview(this.replyForm)
            this.$message.success('回复成功')
            this.replyDialogVisible = false
            this.getReviewList()
            this.getReviewSummary()
          } catch (error) {
            console.error('回复失败:', error)
          } finally {
            this.replySubmitting = false
          }
        }
      })
    },
    viewReviewDetail(review) {
      this.currentReview = review
      this.detailDialogVisible = true
    }
  }
}
</script>

<style scoped>
.merchant-review {
  padding: 0;
}
.header-wrapper {
  font-size: 18px;
  font-weight: bold;
}
.review-stats {
  margin-bottom: 20px;
}
.stat-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
  border-radius: 8px;
  color: #fff;
  text-align: center;
}
.stat-card .stat-label {
  font-size: 14px;
  opacity: 0.9;
  margin-bottom: 10px;
}
.stat-card .stat-value {
  font-size: 28px;
  font-weight: bold;
}
.user-info {
  display: flex;
  align-items: center;
}
.user-info .user-name {
  margin-left: 10px;
}
.rating-info .rating-item {
  display: flex;
  align-items: center;
  margin-bottom: 5px;
}
.rating-info .rating-label {
  width: 40px;
  font-size: 12px;
  color: #606266;
}
.pagination {
  margin-top: 20px;
  text-align: center;
}
.review-user-info {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}
.review-user-info .user-name {
  margin-left: 15px;
  font-weight: bold;
}
.review-ratings {
  margin-bottom: 20px;
}
.review-ratings .rating-item {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}
.review-ratings .rating-label {
  width: 100px;
  color: #606266;
}
.review-ratings .rating-value {
  font-size: 18px;
  font-weight: bold;
  color: #f56c6c;
}
.review-text {
  background: #f5f7fa;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 20px;
}
.review-replies h4 {
  margin-bottom: 15px;
  color: #303133;
}
.reply-item {
  background: #ecf5ff;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 10px;
}
.reply-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}
.reply-user {
  font-weight: bold;
  color: #409eff;
}
.reply-time {
  font-size: 12px;
  color: #909399;
}
.no-reply {
  text-align: center;
  padding: 20px;
}
</style>
