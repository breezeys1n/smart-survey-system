import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { statisticsAPI } from '../services/api'
import PieChart from '../components/charts/PieChart'
import BarChart from '../components/charts/BarChart'
import TextAnswerList from '../components/charts/TextAnswerList'
import Loading from '../components/common/Loading'
import ErrorMessage from '../components/common/ErrorMessage'
import './StatisticsPage.css'

function StatisticsPage() {
  const { id } = useParams()
  const navigate = useNavigate()
  const [analysisData, setAnalysisData] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    loadStatistics()
  }, [id])

  const loadStatistics = async () => {
    try {
      setLoading(true)
      setError(null)
      const data = await statisticsAPI.getFullAnalysis(id)
      setAnalysisData(data)
    } catch (err) {
      setError(err.message || '加载统计数据失败')
    } finally {
      setLoading(false)
    }
  }

  const renderQuestionChart = (questionAnalysis) => {
    // 后端返回格式: { questionId, questionContent, questionType, totalResponses, chartData/textAnswers }
    const questionType = questionAnalysis.questionType

    if (questionType === 1) {
      // 单选题 - 饼图
      return <PieChart data={questionAnalysis} title={questionAnalysis.questionContent} />
    } else if (questionType === 2) {
      // 多选题 - 柱状图
      return <BarChart data={questionAnalysis} title={questionAnalysis.questionContent} />
    } else if (questionType === 3) {
      // 文本题 - 文本列表
      return <TextAnswerList data={questionAnalysis} title={questionAnalysis.questionContent} />
    }
    return null
  }

  if (loading) {
    return <Loading message="加载统计数据中..." />
  }

  if (error) {
    return (
      <div className="statistics-page">
        <div className="statistics-container">
          <ErrorMessage message={error} onRetry={loadStatistics} />
        </div>
      </div>
    )
  }

  if (!analysisData) {
    return (
      <div className="statistics-page">
        <div className="statistics-container">
          <ErrorMessage message="暂无统计数据" />
        </div>
      </div>
    )
  }

  const { summary, questionsAnalysis } = analysisData

  return (
    <div className="statistics-page">
      <div className="statistics-container">
        <div className="statistics-header">
          <h1 className="statistics-title">问卷统计分析</h1>
          <button
            className="statistics-back-btn"
            onClick={() => navigate('/')}
          >
            返回首页
          </button>
        </div>

        {summary && (
          <div className="statistics-summary">
            <div className="summary-item">
              <span className="summary-label">总提交数：</span>
              <span className="summary-value">{summary.totalSubmissions || 0}</span>
            </div>
            <div className="summary-item">
              <span className="summary-label">题目数量：</span>
              <span className="summary-value">{questionsAnalysis?.length || 0}</span>
            </div>
          </div>
        )}

        <div className="statistics-charts">
          {questionsAnalysis && questionsAnalysis.length > 0 ? (
            questionsAnalysis.map((questionAnalysis, index) => (
              <div key={questionAnalysis.questionId || index} className="chart-container">
                {renderQuestionChart(questionAnalysis)}
              </div>
            ))
          ) : (
            <div className="no-data">
              <p>暂无统计数据</p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export default StatisticsPage

