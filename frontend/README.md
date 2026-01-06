# 智能问卷系统 - 前端

## 技术栈

- React 18+
- Vite
- React Router
- Axios
- ECharts

## 快速开始

### 安装依赖

```bash
npm install
```

### 启动开发服务器

```bash
npm run dev
```

前端服务运行在: `http://localhost:3000`

### 构建生产版本

```bash
npm run build
```

## 项目结构

```
frontend/
├── src/
│   ├── components/        # 组件
│   │   ├── common/        # 通用组件
│   │   ├── questionnaire/ # 问卷相关组件
│   │   └── charts/        # 图表组件
│   ├── pages/             # 页面
│   │   ├── HomePage.jsx   # 首页
│   │   ├── FillPage.jsx   # 问卷填写页面
│   │   └── StatisticsPage.jsx # 统计分析页面
│   ├── services/          # API 服务
│   │   └── api.js         # API 封装
│   ├── App.jsx            # 根组件
│   └── main.jsx           # 入口文件
├── package.json
└── vite.config.js
```

## API 配置

前端通过 Vite 代理访问后端 API，代理配置在 `vite.config.js` 中。

后端服务默认运行在: `http://localhost:8080`

## 功能说明

### 1. 首页 (HomePage)
- 输入问卷ID
- 跳转到填写页面或统计页面

### 2. 问卷填写页面 (FillPage)
- 动态渲染问卷题目
- 支持单选、多选、文本三种题型
- 表单校验
- 提交答案

### 3. 统计分析页面 (StatisticsPage)
- 显示问卷统计摘要
- 单选题：饼图展示
- 多选题：柱状图展示
- 文本题：文本列表展示

## 开发说明

本项目是角色D的前端开发部分，专注于：
- 问卷填写功能
- 数据可视化
- 系统测试

不涉及：
- 问卷设计器（角色A）
- 后端API开发（角色B）
- 数据库设计（角色C）

