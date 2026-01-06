# 智能问卷与调查系统

> 一个功能完整的问卷创建、发布、收集和分析平台

## 项目简介

智能问卷与调查系统是一个支持问卷设计、发布、填写和数据可视化的全栈应用。系统支持多种题型（单选、多选、文本）、逻辑跳转和数据分析功能。

### 核心特性

- 📝 **问卷设计器** - 拖拽排序题目，支持多种题型
- 🔗 **逻辑跳转** - 根据答案动态跳转题目
- 📊 **数据可视化** - 自动生成统计图表（饼图、柱状图）
- 📱 **响应式设计** - 适配不同设备屏幕
- 🎯 **数据分析** - 实时统计和可视化展示

## 技术栈

### 后端
- Spring Boot 4.0.0
- Java 17
- MySQL 8.0+
- Spring Data JPA
- Maven

### 前端
- React 18+
- React Router
- ECharts / AntV G2
- Axios
- CSS Modules

## 快速开始

### 环境要求

- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Node.js 16+ (前端开发)

### 后端启动

1. **克隆项目**
```bash
git clone https://github.com/breezeys1n/smart-survey-system.git
cd smart-survey-system
```

2. **配置数据库**
```sql
CREATE DATABASE smart_survey CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. **修改配置**
编辑 `src/main/resources/application.properties`，配置数据库连接信息。

4. **初始化数据（可选）**
```bash
# 使用原始脚本
mysql -u root -p smart_survey < smart_survey_init.sql

# 或使用快速切换工具（推荐）- 数据文件在mock目录
# Windows PowerShell:
cd scripts
.\switch-data.ps1 -Dataset 1

# Linux/Mac:
cd scripts
./switch-data.sh 1

# Windows CMD:
cd scripts
switch-data.bat 1
```

5. **启动服务**
```bash
mvn spring-boot:run
```

后端服务运行在: `http://localhost:8080`

### 前端启动

**重要**: 必须在 `frontend` 目录下执行npm命令！

```bash
# 1. 进入frontend目录
cd frontend

# 2. 安装依赖（首次运行）
npm install

# 3. 启动开发服务器
npm run dev
```

前端服务运行在: `http://localhost:3000`

**注意**: 
- 如果出现 "找不到 package.json" 错误，说明在错误的目录执行命令
- 确保在 `frontend` 目录下执行 `npm` 命令

详细前端开发指南请参考 [前端开发指南](./docs/前端开发指南.md)  
快速启动指南请参考 [快速开始-前端启动](./docs/快速开始-前端启动.md)

## 项目结构

```
smart-survey-system/
├── docs/                    # 项目文档
│   ├── 开发文档.md
│   └── 角色D-开发计划.md
├── src/                     # 后端源码
│   ├── main/
│   │   ├── java/           # Java 源码
│   │   └── resources/      # 配置文件
│   └── test/               # 测试代码
├── frontend/               # 前端源码
├── smart_survey_init.sql   # 数据库初始化脚本
├── pom.xml                 # Maven 配置
└── README.md              # 项目说明
```

## API 文档

### 问卷相关

- `GET /api/v1/questionnaires/{id}/render` - 获取问卷详情
- `POST /api/v1/questionnaires/{id}/submit` - 提交问卷答案

### 统计分析

- `GET /api/v1/statistics/question/{questionId}` - 获取单个问题统计
- `GET /api/v1/statistics/questionnaire/{id}/full-analysis` - 获取问卷完整分析

详细 API 文档请参考 [开发文档](./docs/开发文档.md)

## 测试数据

项目提供了5组不同的测试数据集，位于 `mock/` 目录，用于测试不同场景：

| 数据集 | 文件 | 说明 | 题目数 | 提交数 |
|--------|------|------|--------|--------|
| 数据集1 | `mock/init-data-set1.sql` | 程序员现状调查（基础测试） | 3 | 3 |
| 数据集2 | `mock/init-data-set2.sql` | 用户满意度调查（多题目测试） | 5 | 5 |
| 数据集3 | `mock/init-data-set3.sql` | 简单单题问卷（最小测试） | 1 | 2 |
| 数据集4 | `mock/init-data-set4.sql` | 纯文本问卷（文本题测试） | 3 | 3 |
| 数据集5 | `mock/init-data-set5.sql` | 综合功能测试问卷（完整测试） | 7 | 8 |

### 快速切换测试数据

**Windows PowerShell**:
```powershell
cd scripts
.\switch-data.ps1 -Dataset 1  # 切换到数据集1
.\switch-data.ps1 -Dataset list  # 查看所有数据集
```

**Linux/Mac**:
```bash
cd scripts
./switch-data.sh 1  # 切换到数据集1
./switch-data.sh list  # 查看所有数据集
```

**Windows CMD**:
```cmd
cd scripts
switch-data.bat 1  # 切换到数据集1
switch-data.bat list  # 查看所有数据集
```

## 测试

### 快速测试

1. **启动服务**（参考快速开始部分）

2. **切换测试数据**（参考上面的"测试数据"部分）

3. **执行测试**
   - 手动测试: 参考 [测试复现指南](./docs/测试复现指南.md)
   - API自动化测试: 
     - Linux/Mac: `./scripts/test-api.sh`
     - Windows: `scripts\test-api.bat`

4. **查看测试结果**
   - 测试用例: [测试用例文档](./docs/测试用例文档.md)
   - 测试报告: [完整测试报告](./docs/完整测试报告.md)

### 测试文档
- [角色D-完整测试报告](./docs/角色D-完整测试报告.md) - 完整的测试执行报告（42个测试用例）
- [角色D-接口文档](./docs/角色D-接口文档.md) - 角色D涉及的API接口详细文档

## 开发计划

### 当前阶段（角色D）- ✅ 已完成

- [x] 项目文档整理
- [x] 问卷填写页面开发
- [x] 数据提交功能实现
- [x] 图表库集成
- [x] 数据可视化实现
- [x] 系统测试文档
- [x] 项目演示准备

**角色D工作文档**:
- [角色D-接口文档](./docs/角色D-接口文档.md) - API接口详细文档
- [角色D-完整测试报告](./docs/角色D-完整测试报告.md) - 完整测试报告

## 团队成员

- **角色A**: 问卷设计器前端开发
- **角色B**: 后端API开发
- **角色C**: 数据库设计与后端业务逻辑
- **角色D**: 问卷填写页面、数据可视化、系统测试

## 文档

### 项目文档
- [开发文档](./docs/开发文档.md) - 项目整体开发文档
- [项目总结报告](./docs/项目总结报告.md) - 角色D项目总结
- [文档索引](./docs/文档索引.md) - 所有文档索引

### 开发计划
- [角色D开发计划](./docs/角色D-开发计划.md) - 前端开发详细计划
- [角色D开发进度](./docs/角色D-开发进度.md) - 开发进度跟踪

### 开发指南
- [前端开发指南](./docs/前端开发指南.md) - 前端开发详细指南

### 测试文档
- [测试文档总览](./docs/测试文档总览.md) - 测试文档索引和说明
- [测试用例文档](./docs/测试用例文档.md) - 完整测试用例（42个）
- [测试执行指南](./docs/测试执行指南.md) - 测试执行详细指南
- [测试复现指南](./docs/测试复现指南.md) - 详细的测试复现步骤
- [完整测试报告](./docs/完整测试报告.md) - 完整的测试执行报告
- [测试执行报告](./docs/测试执行报告.md) - 测试执行报告模板

### 测试数据
- [测试数据使用指南](./docs/测试数据使用指南.md) - 测试数据切换和使用说明

### 演示文档
- [项目演示文稿大纲](./docs/项目演示文稿大纲.md) - 项目演示准备

### 角色D文档
- [角色D-接口文档](./docs/角色D-接口文档.md) - 角色D涉及的API接口详细文档
- [角色D-完整测试报告](./docs/角色D-完整测试报告.md) - 完整的测试执行报告

## 许可证

本项目为课程项目，仅供学习使用。

## 贡献

欢迎提交 Issue 和 Pull Request！

---

**项目地址**: https://github.com/breezeys1n/smart-survey-system

