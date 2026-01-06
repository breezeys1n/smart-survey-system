import { useEffect, useRef } from 'react'
import * as echarts from 'echarts'
import './Chart.css'

function BarChart({ data, title }) {
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
    const xAxisData = []
    const seriesData = []

    if (data && data.chartData && Array.isArray(data.chartData)) {
      data.chartData.forEach((item) => {
        xAxisData.push(item.label || '未知选项')
        seriesData.push(item.value || 0)
      })
    }

    const option = {
      title: {
        text: title || '多选题统计',
        left: 'center',
        textStyle: {
          fontSize: 16,
          fontWeight: 500,
        },
      },
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'shadow',
        },
        formatter: '{b}: {c} 人',
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true,
      },
      xAxis: {
        type: 'category',
        data: xAxisData,
        axisLabel: {
          rotate: xAxisData.length > 5 ? 45 : 0,
          interval: 0,
        },
      },
      yAxis: {
        type: 'value',
        name: '选择人数',
      },
      series: [
        {
          name: '选择人数',
          type: 'bar',
          data: seriesData,
          itemStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#83bff6' },
              { offset: 0.5, color: '#188df0' },
              { offset: 1, color: '#188df0' },
            ]),
          },
          emphasis: {
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: '#2378f7' },
                { offset: 0.7, color: '#2378f7' },
                { offset: 1, color: '#83bff6' },
              ]),
            },
          },
          label: {
            show: true,
            position: 'top',
            formatter: '{c}',
          },
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

export default BarChart

