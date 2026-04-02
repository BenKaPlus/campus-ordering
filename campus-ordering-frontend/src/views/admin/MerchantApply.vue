<template>
  <div class="merchant-apply-container">
    <el-card>
      <div class="filter-row">
        <el-tabs v-model="activeTab" @tab-click="handleTabClick" class="status-tabs">
          <el-tab-pane label="全部" name="all"></el-tab-pane>
          <el-tab-pane label="待审核" name="0"></el-tab-pane>
          <el-tab-pane label="已通过" name="1"></el-tab-pane>
          <el-tab-pane label="已拒绝" name="2"></el-tab-pane>
        </el-tabs>
      </div>

      <el-table :data="tableData" v-loading="loading" style="width: 100%;">
        <el-table-column prop="applyId" label="申请ID" width="80"></el-table-column>
        <el-table-column prop="applicantName" label="申请人" width="100"></el-table-column>
        <el-table-column prop="applicantPhone" label="手机号" width="120"></el-table-column>
        <el-table-column prop="shopName" label="店铺名称" min-width="150"></el-table-column>
        <el-table-column label="店铺类型" width="100">
          <template slot-scope="scope">
            {{ shopTypeFilter(scope.row.shopType) }}
          </template>
        </el-table-column>
        <el-table-column prop="deliveryFee" label="配送费" width="80">
          <template slot-scope="scope">¥{{ scope.row.deliveryFee }}</template>
        </el-table-column>
        <el-table-column label="审核状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.auditStatus)">
              {{ getStatusText(scope.row.auditStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="申请时间" width="160">
          <template slot-scope="scope">
            {{ formatDateTime(scope.row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template slot-scope="scope">
            <el-button
              v-if="scope.row.auditStatus === 0"
              type="text"
              size="small"
              @click="handleAudit(scope.row, 1)"
              style="color: #67c23a;"
            >通过</el-button>
            <el-button
              v-if="scope.row.auditStatus === 0"
              type="text"
              size="small"
              @click="handleAudit(scope.row, 2)"
              style="color: #f56c6c;"
            >拒绝</el-button>
            <el-button
              type="text"
              size="small"
              @click="handleDetail(scope.row)"
            >详情</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        class="pagination"
        background
        layout="total, prev, pager, next"
        :total="total"
        :current-page.sync="pageNum"
        :page-size.sync="pageSize"
        @current-change="getList"
      ></el-pagination>
    </el-card>

    <!-- 审核对话框 -->
    <el-dialog :title="auditDialog.title" :visible.sync="auditDialog.visible" width="500px">
      <el-form :model="auditForm" label-width="80px">
        <el-form-item label="审核意见">
          <el-input v-model="auditForm.auditRemark" type="textarea" :rows="4" placeholder="请输入审核意见（可选）"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="auditDialog.visible = false">取消</el-button>
        <el-button type="primary" @click="confirmAudit">确定</el-button>
      </span>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog title="申请详情" :visible.sync="detailDialog.visible" width="600px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="申请人">{{ currentApply.applicantName }}</el-descriptions-item>
        <el-descriptions-item label="手机号">{{ currentApply.applicantPhone }}</el-descriptions-item>
        <el-descriptions-item label="店铺名称">{{ currentApply.shopName }}</el-descriptions-item>
        <el-descriptions-item label="店铺类型">{{ shopTypeFilter(currentApply.shopType) }}</el-descriptions-item>
        <el-descriptions-item label="配送费">¥{{ currentApply.deliveryFee }}</el-descriptions-item>
        <el-descriptions-item label="审核状态">
          <el-tag :type="getStatusType(currentApply.auditStatus)">
            {{ getStatusText(currentApply.auditStatus) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="店铺描述" :span="2">{{ currentApply.shopDescription || '无' }}</el-descriptions-item>
        <el-descriptions-item label="营业执照">
          <el-image 
            v-if="currentApply.businessLicense" 
            :src="currentApply.businessLicense" 
            :preview-src-list="[currentApply.businessLicense]" 
            style="width: 80px; height: 80px;"
            fit="cover"
          />
          <span v-else style="color: #909399;">未上传</span>
        </el-descriptions-item>
        <el-descriptions-item label="身份证正面">
          <el-image 
            v-if="currentApply.idCardFront" 
            :src="currentApply.idCardFront" 
            :preview-src-list="[currentApply.idCardFront]" 
            style="width: 80px; height: 80px;"
            fit="cover"
          />
          <span v-else style="color: #909399;">未上传</span>
        </el-descriptions-item>
        <el-descriptions-item label="身份证反面">
          <el-image 
            v-if="currentApply.idCardBack" 
            :src="currentApply.idCardBack" 
            :preview-src-list="[currentApply.idCardBack]" 
            style="width: 80px; height: 80px;"
            fit="cover"
          />
          <span v-else style="color: #909399;">未上传</span>
        </el-descriptions-item>
        <el-descriptions-item label="申请时间">{{ formatDateTime(currentApply.createTime) }}</el-descriptions-item>
        <el-descriptions-item label="审核时间">{{ formatDateTime(currentApply.auditTime) || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核意见" :span="2">{{ currentApply.auditRemark || '无' }}</el-descriptions-item>
      </el-descriptions>
      <span slot="footer">
        <el-button @click="detailDialog.visible = false">关闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import request from '@/api'

export default {
  name: 'MerchantApply',
  data() {
    return {
      loading: false,
      activeTab: 'all',
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 10,
      auditDialog: {
        visible: false,
        title: '',
        applyId: null,
        auditStatus: null
      },
      auditForm: {
        auditRemark: ''
      },
      detailDialog: {
        visible: false
      },
      currentApply: {}
    }
  },
  created() {
    this.getList()
  },
  methods: {
    shopTypeFilter(type) {
      const types = { 1: '快餐', 2: '小吃', 3: '饮品', 4: '水果', 5: '超市', 6: '其他' }
      return types[type] || '未知'
    },
    getStatusType(status) {
      const types = { 0: 'warning', 1: 'success', 2: 'danger' }
      return types[status] || 'info'
    },
    getStatusText(status) {
      const texts = { 0: '待审核', 1: '已通过', 2: '已拒绝' }
      return texts[status] || '未知'
    },
    formatDateTime(dateTime) {
      if (!dateTime) return ''
      return dateTime.replace('T', ' ').substring(0, 19)
    },
    handleTabClick() {
      this.pageNum = 1
      this.getList()
    },
    async getList() {
      this.loading = true
      try {
        const params = {
          page: this.pageNum,
          size: this.pageSize
        }
        if (this.activeTab !== 'all') {
          params.auditStatus = parseInt(this.activeTab)
        }
        const res = await request.get('/admin/merchant/apply/list', { params })
        this.tableData = res.data.records || []
        this.total = res.data.total || 0
      } catch (error) {
        this.$message.error('获取列表失败')
      } finally {
        this.loading = false
      }
    },
    handleAudit(row, status) {
      this.auditDialog.applyId = row.applyId
      this.auditDialog.auditStatus = status
      this.auditDialog.title = status === 1 ? '通过审核' : '拒绝申请'
      this.auditForm.auditRemark = ''
      this.auditDialog.visible = true
    },
    async confirmAudit() {
      try {
        await request.put('/admin/merchant/apply/audit', null, {
          params: {
            applyId: this.auditDialog.applyId,
            auditStatus: this.auditDialog.auditStatus,
            auditRemark: this.auditForm.auditRemark || ''
          }
        })
        this.$message.success('审核成功')
        this.auditDialog.visible = false
        this.getList()
      } catch (error) {
        this.$message.error('审核失败')
      }
    },
    handleDetail(row) {
      this.currentApply = { ...row }
      this.detailDialog.visible = true
    }
  }
}
</script>

<style scoped>
.merchant-apply-container {
  padding: 20px;
}
.filter-row {
  margin-bottom: 15px;
}
.status-tabs {
  margin-bottom: 0;
}
.pagination {
  margin-top: 20px;
  text-align: center;
}
</style>
