import { Routes, Route } from 'react-router-dom'
import FillPage from './pages/FillPage'
import StatisticsPage from './pages/StatisticsPage'
import HomePage from './pages/HomePage'
import './App.css'

function App() {
  return (
    <div className="app">
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/fill/:id" element={<FillPage />} />
        <Route path="/statistics/:id" element={<StatisticsPage />} />
      </Routes>
    </div>
  )
}

export default App

