import './QuestionItem.css'

function QuestionItem({ question, value, onChange }) {
  console.log('[QuestionItem] 渲染题目组件:', question)
  console.log('[QuestionItem] 题目ID:', question?.id)
  console.log('[QuestionItem] 题目类型:', question?.type)
  console.log('[QuestionItem] 题目内容:', question?.content)
  console.log('[QuestionItem] 选项数据:', question?.options)
  console.log('[QuestionItem] 选项是数组?', Array.isArray(question?.options))
  console.log('[QuestionItem] 选项数量:', question?.options?.length)
  console.log('[QuestionItem] 当前答案值:', value)

  const handleSingleChoice = (optionId) => {
    console.log('[QuestionItem] 单选题选择:', optionId)
    onChange(String(optionId))
  }

  const handleMultipleChoice = (optionId, checked) => {
    const currentValue = Array.isArray(value) ? value : []
    if (checked) {
      onChange([...currentValue, String(optionId)])
    } else {
      onChange(currentValue.filter((id) => id !== String(optionId)))
    }
  }

  const handleTextChange = (e) => {
    onChange(e.target.value)
  }

  // 排序选项
  const sortedOptions = question.options
    ? [...question.options].sort((a, b) => (a.optionOrder || 0) - (b.optionOrder || 0))
    : []

  console.log('[QuestionItem] 排序后的选项:', sortedOptions)
  console.log('[QuestionItem] 选项数量:', sortedOptions.length)

  if (!question) {
    console.error('[QuestionItem] question为null/undefined')
    return <div>题目数据错误</div>
  }

  if (!question.content) {
    console.warn('[QuestionItem] 题目内容为空')
  }

  return (
    <div className="question-item">
      <div className="question-header">
        <h3 className="question-title">
          {question.questionOrder && `${question.questionOrder}. `}
          {question.content}
        </h3>
        {question.type === 1 && <span className="question-type">（单选题）</span>}
        {question.type === 2 && <span className="question-type">（多选题）</span>}
        {question.type === 3 && <span className="question-type">（文本题）</span>}
      </div>

      <div className="question-body">
        {question.type === 1 && (
          <div className="question-options">
            {sortedOptions.length === 0 ? (
              <div>暂无选项</div>
            ) : (
              sortedOptions.map((option, index) => {
                console.log(`[QuestionItem] 渲染选项 ${index}:`, option)
                return (
                  <label key={option.id} className="option-label">
                    <input
                      type="radio"
                      name={`question-${question.id}`}
                      value={option.id}
                      checked={value === String(option.id)}
                      onChange={() => handleSingleChoice(option.id)}
                    />
                    <span className="option-text">{option.optionText}</span>
                  </label>
                )
              })
            )}
          </div>
        )}

        {question.type === 2 && (
          <div className="question-options">
            {sortedOptions.length === 0 ? (
              <div>暂无选项</div>
            ) : (
              sortedOptions.map((option, index) => {
                console.log(`[QuestionItem] 渲染多选题选项 ${index}:`, option)
                const checked = Array.isArray(value) && value.includes(String(option.id))
                return (
                  <label key={option.id} className="option-label">
                    <input
                      type="checkbox"
                      checked={checked}
                      onChange={(e) => handleMultipleChoice(option.id, e.target.checked)}
                    />
                    <span className="option-text">{option.optionText}</span>
                  </label>
                )
              })
            )}
          </div>
        )}

        {question.type === 3 && (
          <textarea
            className="question-textarea"
            value={value || ''}
            onChange={handleTextChange}
            placeholder="请输入您的答案..."
            rows={4}
          />
        )}
      </div>
    </div>
  )
}

export default QuestionItem

