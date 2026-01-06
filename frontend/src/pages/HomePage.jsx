import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import './HomePage.css'

function HomePage() {
  const navigate = useNavigate()
  const [questionnaireId, setQuestionnaireId] = useState('1')

  const handleFill = () => {
    if (questionnaireId) {
      navigate(`/fill/${questionnaireId}`)
    }
  }

  const handleStatistics = () => {
    if (questionnaireId) {
      navigate(`/statistics/${questionnaireId}`)
    }
  }

  return (
    <div className="home-page">
      <div className="home-container">
        <h1 className="home-title">智能问卷与调查系统</h1>
        <p className="home-subtitle">请输入问卷ID进行填写或查看统计</p>
        
        <div className="home-input-group">
          <input
            type="text"
            className="home-input"
            placeholder="请输入问卷ID（例如：1）"
            value={questionnaireId}
            onChange={(e) => setQuestionnaireId(e.target.value)}
          />
        </div>

        <div className="home-actions">
          <button className="home-btn home-btn-primary" onClick={handleFill}>
            填写问卷
          </button>
          <button className="home-btn home-btn-secondary" onClick={handleStatistics}>
            查看统计
          </button>
        </div>
      </div>
    </div>
  )
}

export default HomePage

