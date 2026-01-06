import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { questionnaireAPI } from '../services/api'
import QuestionItem from '../components/questionnaire/QuestionItem'
import Loading from '../components/common/Loading'
import ErrorMessage from '../components/common/ErrorMessage'
import './FillPage.css'

function FillPage() {
  const { id } = useParams()
  const navigate = useNavigate()
  const [questionnaire, setQuestionnaire] = useState(null)
  const [answers, setAnswers] = useState({})
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [submitSuccess, setSubmitSuccess] = useState(false)

  useEffect(() => {
    console.log('[FillPage] 组件挂载/更新, 问卷ID:', id)
    loadQuestionnaire()
  }, [id])

  const loadQuestionnaire = async () => {
    try {
      console.log('[FillPage] 开始加载问卷, ID:', id)
      setLoading(true)
      setError(null)
      
      const data = await questionnaireAPI.getQuestionnaire(id)
      console.log('[FillPage] API返回数据:', data)
      console.log('[FillPage] 数据类型:', typeof data)
      console.log('[FillPage] 数据keys:', data ? Object.keys(data) : 'data is null')
      
      setQuestionnaire(data)
      
      // 初始化答案对象
      const initialAnswers = {}
      console.log('[FillPage] questions存在?', !!data?.questions)
      console.log('[FillPage] questions类型:', Array.isArray(data?.questions) ? 'array' : typeof data?.questions)
      console.log('[FillPage] questions长度:', data?.questions?.length)
      console.log('[FillPage] questions内容:', data?.questions)
      
      if (data?.questions) {
        if (Array.isArray(data.questions)) {
          data.questions.forEach((q, index) => {
            console.log(`[FillPage] 处理题目 ${index}:`, q)
            console.log(`[FillPage] 题目ID: ${q.id}, 类型: ${q.type}, 内容: ${q.content}`)
            if (q.type === 2) {
              // 多选题初始化为数组
              initialAnswers[q.id] = []
            } else {
              // 单选和文本题初始化为空字符串
              initialAnswers[q.id] = ''
            }
          })
        } else {
          console.warn('[FillPage] questions不是数组:', data.questions)
        }
      } else {
        console.warn('[FillPage] questions不存在或为空')
      }
      
      console.log('[FillPage] 初始答案对象:', initialAnswers)
      setAnswers(initialAnswers)
    } catch (err) {
      console.error('[FillPage] 加载问卷失败:', err)
      console.error('[FillPage] 错误详情:', err.message, err.stack)
      setError(err.message || '加载问卷失败')
    } finally {
      setLoading(false)
      console.log('[FillPage] 加载完成, loading状态:', false)
    }
  }

  const handleAnswerChange = (questionId, value) => {
    setAnswers((prev) => ({
      ...prev,
      [questionId]: value,
    }))
  }

  const validateAnswers = () => {
    if (!questionnaire || !questionnaire.questions) return false

    for (const question of questionnaire.questions) {
      const answer = answers[question.id]
      if (question.type === 2) {
        // 多选题
        if (!Array.isArray(answer) || answer.length === 0) {
          return false
        }
      } else {
        // 单选和文本题
        if (!answer || answer.trim() === '') {
          return false
        }
      }
    }
    return true
  }

  const handleSubmit = async () => {
    if (!validateAnswers()) {
      alert('请完成所有题目后再提交')
      return
    }

    try {
      setSubmitting(true)
      setError(null)
      
      // 转换答案格式：将选项ID转换为字符串格式
      const submitData = {}
      Object.keys(answers).forEach((questionId) => {
        const answer = answers[questionId]
        // 找到对应的问题，确定题型
        const question = questionnaire.questions.find(q => String(q.id) === questionId)
        if (question && question.type === 2) {
          // 多选题：转换为逗号分隔的字符串（后端期望格式）
          submitData[questionId] = Array.isArray(answer) ? answer.join(',') : String(answer)
        } else {
          // 单选和文本题：直接使用字符串
          submitData[questionId] = String(answer)
        }
      })

      await questionnaireAPI.submitQuestionnaire(id, submitData)
      setSubmitSuccess(true)
    } catch (err) {
      setError(err.message || '提交失败，请重试')
    } finally {
      setSubmitting(false)
    }
  }

  if (loading) {
    return <Loading message="加载问卷中..." />
  }

  if (error && !questionnaire) {
    return <ErrorMessage message={error} onRetry={loadQuestionnaire} />
  }

  if (submitSuccess) {
    return (
      <div className="fill-page">
        <div className="fill-container">
          <div className="success-message">
            <h2>提交成功！</h2>
            <p>感谢您的参与</p>
            <button
              className="fill-btn fill-btn-primary"
              onClick={() => navigate('/')}
            >
              返回首页
            </button>
          </div>
        </div>
      </div>
    )
  }

  console.log('[FillPage] 渲染阶段 - questionnaire:', questionnaire)
  console.log('[FillPage] 渲染阶段 - questionnaire存在?', !!questionnaire)
  console.log('[FillPage] 渲染阶段 - questions:', questionnaire?.questions)
  console.log('[FillPage] 渲染阶段 - questions是数组?', Array.isArray(questionnaire?.questions))
  console.log('[FillPage] 渲染阶段 - questions长度:', questionnaire?.questions?.length)
  console.log('[FillPage] 渲染阶段 - answers:', answers)
  console.log('[FillPage] 渲染阶段 - loading:', loading)
  console.log('[FillPage] 渲染阶段 - error:', error)

  return (
    <div className="fill-page">
      <div className="fill-container">
        {questionnaire && (
          <>
            <div className="fill-header">
              <h1 className="fill-title">{questionnaire.title}</h1>
              {questionnaire.description && (
                <p className="fill-description">{questionnaire.description}</p>
              )}
            </div>

            <div className="fill-questions">
              {(() => {
                const questions = questionnaire.questions
                console.log('[FillPage] 准备渲染题目, questions:', questions)
                console.log('[FillPage] questions类型:', typeof questions)
                console.log('[FillPage] questions是数组?', Array.isArray(questions))
                
                if (!questions) {
                  console.warn('[FillPage] questions为null/undefined')
                  return <div>暂无题目</div>
                }
                
                if (!Array.isArray(questions)) {
                  console.warn('[FillPage] questions不是数组:', questions)
                  return <div>题目数据格式错误</div>
                }
                
                if (questions.length === 0) {
                  console.warn('[FillPage] questions数组为空')
                  return <div>暂无题目</div>
                }
                
                const sortedQuestions = questions.sort((a, b) => (a.questionOrder || 0) - (b.questionOrder || 0))
                console.log('[FillPage] 排序后的题目:', sortedQuestions)
                
                return sortedQuestions.map((question, index) => {
                  console.log(`[FillPage] 渲染题目 ${index}:`, question)
                  return (
                    <QuestionItem
                      key={question.id}
                      question={question}
                      value={answers[question.id]}
                      onChange={(value) => handleAnswerChange(question.id, value)}
                    />
                  )
                })
              })()}
            </div>

            {error && (
              <div className="fill-error">
                <ErrorMessage message={error} />
              </div>
            )}

            <div className="fill-actions">
              <button
                className="fill-btn fill-btn-secondary"
                onClick={() => navigate('/')}
              >
                取消
              </button>
              <button
                className="fill-btn fill-btn-primary"
                onClick={handleSubmit}
                disabled={submitting}
              >
                {submitting ? '提交中...' : '提交问卷'}
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  )
}

export default FillPage

