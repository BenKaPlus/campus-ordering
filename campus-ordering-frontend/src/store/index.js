import Vue from 'vue'
import Vuex from 'vuex'
import * as auth from '@/utils/auth'
import { getUserInfo } from '@/api/auth'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: auth.getToken(),
    userInfo: null,
    roles: [],
    cartCount: 0
  },
  getters: {
    token: state => state.token,
    userInfo: state => state.userInfo,
    roles: state => state.roles,
    cartCount: state => state.cartCount
  },
  mutations: {
    SET_TOKEN(state, token) {
      state.token = token
      auth.setToken(token)
    },
    SET_USER_INFO(state, userInfo) {
      state.userInfo = userInfo
    },
    SET_ROLES(state, roles) {
      state.roles = roles
    },
    SET_CART_COUNT(state, count) {
      state.cartCount = count
    },
    LOGOUT(state) {
      state.token = null
      state.userInfo = null
      state.roles = []
      state.cartCount = 0
      auth.removeToken()
    }
  },
  actions: {
    async getUserInfo({ commit }) {
      try {
        const res = await getUserInfo()
        if (res.code === 200 && res.data) {
          commit('SET_USER_INFO', res.data)
          if (res.data.roles) {
            commit('SET_ROLES', res.data.roles)
          }
        }
        return res
      } catch (error) {
        console.error('获取用户信息失败:', error)
        throw error
      }
    },
    logout({ commit }) {
      commit('LOGOUT')
    }
  }
})