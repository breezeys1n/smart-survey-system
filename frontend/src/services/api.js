import axios from 'axios'

const API_BASE_URL = '/api/v1'

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

// 请求拦截器
api.interceptors.request.use(
  (config) => {
    console.log('[API] 请求发送:', config.method?.toUpperCase(), config.url)
    console.log('[API] 请求参数:', config.params)
    console.log('[API] 请求数据:', config.data)
    return config
  },
  (error) => {
    console.error('[API] 请求拦截器错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
api.interceptors.response.use(
  (response) => {
    console.log('[API] 响应接收:', response.config?.url)
    console.log('[API] 响应状态:', response.status)
    console.log('[API] 响应数据:', response.data)
    console.log('[API] 响应数据类型:', typeof response.data)
    console.log('[API] 响应数据keys:', response.data ? Object.keys(response.data) : 'data is null')
    return response.data
  },
  (error) => {
    console.error('[API] 响应错误:', error)
    console.error('[API] 错误URL:', error.config?.url)
    console.error('[API] 错误状态码:', error.response?.status)
    console.error('[API] 错误响应数据:', error.response?.data)
    console.error('[API] 错误消息:', error.message)
    const message = error.response?.data?.message || error.message || '请求失败'
    return Promise.reject(new Error(message))
  }
)

// 问卷相关API
export const questionnaireAPI = {
  // 获取问卷详情（用于填写页面）
  getQuestionnaire: (id) => {
    console.log('[questionnaireAPI] 获取问卷, ID:', id)
    const url = `/questionnaires/${id}/render`
    console.log('[questionnaireAPI] 请求URL:', url)
    return api.get(url).then(data => {
      console.log('[questionnaireAPI] 获取问卷成功, 返回数据:', data)
      return data
    }).catch(err => {
      console.error('[questionnaireAPI] 获取问卷失败:', err)
      throw err
    })
  },

  // 提交问卷答案
  submitQuestionnaire: (id, answers) => {
    return api.post(`/questionnaires/${id}/submit`, answers)
  },
}

// 统计分析API
export const statisticsAPI = {
  // 获取单个问题统计
  getQuestionStats: (questionId) => {
    return api.get(`/statistics/question/${questionId}`)
  },

  // 获取问卷完整分析
  getFullAnalysis: (questionnaireId) => {
    return api.get(`/statistics/questionnaire/${questionnaireId}/full-analysis`)
  },
}

export default api

