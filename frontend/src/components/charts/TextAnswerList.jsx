import './Chart.css'

function TextAnswerList({ data, title }) {
  const textAnswers = data && data.textAnswers ? data.textAnswers : []

  return (
    <div className="chart-wrapper">
      <div className="text-answer-container">
        <h3 className="text-answer-title">{title || '文本题答案'}</h3>
        <div className="text-answer-stats">
          <span className="text-answer-count">共 {textAnswers.length} 条回答</span>
        </div>
        <div className="text-answer-list">
          {textAnswers.length > 0 ? (
            textAnswers.map((answer, index) => (
              <div key={index} className="text-answer-item">
                <span className="text-answer-index">{index + 1}.</span>
                <span className="text-answer-content">{answer}</span>
              </div>
            ))
          ) : (
            <div className="text-answer-empty">暂无回答</div>
          )}
        </div>
      </div>
    </div>
  )
}

export default TextAnswerList

