import { useEffect, useRef } from 'react'
import * as echarts from 'echarts'
import './Chart.css'

function PieChart({ data, title }) {
  const chartRef = useRef(null)
  const chartInstance = useRef(null)

  useEffect(() => {
    if (!chartRef.current) return

    // 初始化图表
    if (!chartInstance.current) {
      chartInstance.current = echarts.init(chartRef.current)
    }

    // 处理数据：将后端返回的统计数据转换为ECharts格式
    // 后端返回格式: { chartData: [{ label, value, percent }] }
    const chartData = []
    if (data && data.chartData && Array.isArray(data.chartData)) {
      data.chartData.forEach((item) => {
        chartData.push({
          value: item.value || 0,
          name: item.label || '未知选项',
        })
      })
    }

    const option = {
      title: {
        text: title || '单选题统计',
        left: 'center',
        textStyle: {
          fontSize: 16,
          fontWeight: 500,
        },
      },
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c} ({d}%)',
      },
      legend: {
        orient: 'vertical',
        left: 'left',
        top: 'middle',
      },
      series: [
        {
          name: '选择人数',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 10,
            borderColor: '#fff',
            borderWidth: 2,
          },
          label: {
            show: true,
            formatter: '{b}: {c} ({d}%)',
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 16,
              fontWeight: 'bold',
            },
          },
          data: chartData,
        },
      ],
    }

    chartInstance.current.setOption(option)

    // 响应式调整
    const handleResize = () => {
      if (chartInstance.current) {
        chartInstance.current.resize()
      }
    }

    window.addEventListener('resize', handleResize)

    return () => {
      window.removeEventListener('resize', handleResize)
      if (chartInstance.current) {
        chartInstance.current.dispose()
        chartInstance.current = null
      }
    }
  }, [data, title])

  return (
    <div className="chart-wrapper">
      <div ref={chartRef} className="chart-container" style={{ width: '100%', height: '400px' }}></div>
    </div>
  )
}

export default PieChart

