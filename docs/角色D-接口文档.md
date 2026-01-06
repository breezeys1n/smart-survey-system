# 角色D - 接口文档

本文档详细说明角色D（问卷填写/数据可视化/测试）涉及的所有API接口。

**文档版本**: v1.0.0  
**最后更新**: 2025-01-XX  
**维护者**: 角色D

---

## 目录

1. [接口概览](#接口概览)
2. [问卷填写相关接口](#问卷填写相关接口)
3. [数据统计分析接口](#数据统计分析接口)
4. [数据格式说明](#数据格式说明)
5. [错误处理](#错误处理)
6. [测试用例](#测试用例)
7. [常见问题](#常见问题)

---

## 接口概览

角色D负责的接口共4个，分为两类：

### 问卷填写相关（2个）
- `GET /api/v1/questionnaires/{id}/render` - 获取问卷详情
- `POST /api/v1/questionnaires/{id}/submit` - 提交问卷答案

### 数据统计分析（2个）
- `GET /api/v1/statistics/questionnaire/{id}/full-analysis` - 获取问卷完整分析
- `GET /api/v1/statistics/question/{questionId}` - 获取单个问题统计

---

## 问卷填写相关接口

### 1. 获取问卷详情

**接口描述**: 获取指定问卷的完整信息，包括题目和选项，用于问卷填写页面渲染。

**请求信息**:
- **URL**: `/api/v1/questionnaires/{id}/render`
- **方法**: `GET`
- **路径参数**:
  | 参数名 | 类型 | 必填 | 说明 |
  |--------|------|------|------|
  | id | Long | 是 | 问卷ID |

**请求示例**:
```http
GET /api/v1/questionnaires/1/render HTTP/1.1
Host: localhost:8080
```

**响应信息**:
- **状态码**: `200 OK`
- **Content-Type**: `application/json`
- **响应体**: `Questionnaire` 对象

**响应数据结构**:
```json
{
  "id": 1,
  "title": "2025年程序员现状调查",
  "description": "本问卷旨在了解开发者的技能栈与满意度",
  "createTime": "2025-01-01T10:00:00",
  "status": 1,
  "questions": [
    {
      "id": 1,
      "content": "你最常用的编程语言是什么？",
      "type": 1,
      "questionOrder": 1,
      "options": [
        {
          "id": 101,
          "optionText": "Java",
          "optionOrder": 1
        },
        {
          "id": 102,
          "optionText": "Python",
          "optionOrder": 2
        }
      ]
    },
    {
      "id": 2,
      "content": "你感兴趣的技术领域有哪些？",
      "type": 2,
      "questionOrder": 2,
      "options": [
        {
          "id": 201,
          "optionText": "人工智能",
          "optionOrder": 1
        }
      ]
    },
    {
      "id": 3,
      "content": "你对目前的工作环境有什么建议？",
      "type": 3,
      "questionOrder": 3,
      "options": []
    }
  ]
}
```

**字段说明**:
| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 问卷ID |
| title | String | 问卷标题 |
| description | String | 问卷描述 |
| createTime | String | 创建时间（ISO 8601格式） |
| status | Integer | 问卷状态（1=启用） |
| questions | Array | 题目列表 |
| questions[].id | Long | 题目ID |
| questions[].content | String | 题目内容 |
| questions[].type | Integer | 题目类型（1=单选，2=多选，3=文本） |
| questions[].questionOrder | Integer | 题目顺序 |
| questions[].options | Array | 选项列表（文本题为空） |
| questions[].options[].id | Long | 选项ID |
| questions[].options[].optionText | String | 选项文本 |
| questions[].options[].optionOrder | Integer | 选项顺序 |

**错误响应**:
- **404 Not Found**: 问卷不存在
  ```json
  {
    "timestamp": "2025-01-01T10:00:00",
    "status": 404,
    "error": "Not Found",
    "message": "问卷不存在",
    "path": "/api/v1/questionnaires/999/render"
  }
  ```

**前端调用示例**:
```javascript
import { questionnaireAPI } from '../services/api'

// 获取问卷详情
const questionnaire = await questionnaireAPI.getQuestionnaire(1)
console.log('问卷标题:', questionnaire.title)
console.log('题目数量:', questionnaire.questions.length)
```

**测试要点**:
- ✅ 正常获取存在的问卷
- ✅ 获取不存在的问卷（应返回404）
- ✅ 验证返回的题目按questionOrder排序
- ✅ 验证单选题、多选题、文本题的数据结构
- ✅ 验证选项按optionOrder排序
- ✅ 验证LAZY加载的关联数据正确返回

---

### 2. 提交问卷答案

**接口描述**: 提交用户填写的问卷答案，保存到数据库。

**请求信息**:
- **URL**: `/api/v1/questionnaires/{id}/submit`
- **方法**: `POST`
- **Content-Type**: `application/json`
- **路径参数**:
  | 参数名 | 类型 | 必填 | 说明 |
  |--------|------|------|------|
  | id | Long | 是 | 问卷ID |
- **请求体**: JSON对象，key为题目ID，value为答案

**请求体格式**:
```json
{
  "1": "101",
  "2": "201,203",
  "3": "这是文本答案"
}
```

**请求体说明**:
- **单选题**: value为选项ID的字符串，如 `"101"`
- **多选题**: value为逗号分隔的选项ID字符串，如 `"201,203"`
- **文本题**: value为文本内容字符串，如 `"这是文本答案"`

**请求示例**:
```http
POST /api/v1/questionnaires/1/submit HTTP/1.1
Host: localhost:8080
Content-Type: application/json

{
  "1": "101",
  "2": "201,203",
  "3": "希望增加更多带薪年假"
}
```

**响应信息**:
- **状态码**: `200 OK`
- **Content-Type**: `text/plain;charset=UTF-8`
- **响应体**: 成功消息字符串

**成功响应**:
```
提交成功！感谢参与。
```

**错误响应**:
- **400 Bad Request**: 请求参数错误
- **404 Not Found**: 问卷不存在
- **500 Internal Server Error**: 服务器内部错误

**前端调用示例**:
```javascript
import { questionnaireAPI } from '../services/api'

// 准备提交数据
const submitData = {
  "1": "101",           // 单选题：选择选项ID 101
  "2": "201,203",       // 多选题：选择选项ID 201和203
  "3": "这是文本答案"   // 文本题：文本内容
}

// 提交问卷
try {
  const result = await questionnaireAPI.submitQuestionnaire(1, submitData)
  console.log('提交成功:', result)
} catch (error) {
  console.error('提交失败:', error.message)
}
```

**前端数据转换逻辑**:
```javascript
// 在FillPage.jsx中，提交前需要转换数据格式
const submitData = {}
Object.keys(answers).forEach((questionId) => {
  const answer = answers[questionId]
  const question = questionnaire.questions.find(q => String(q.id) === questionId)
  
  if (question && question.type === 2) {
    // 多选题：数组转逗号分隔字符串
    submitData[questionId] = Array.isArray(answer) ? answer.join(',') : String(answer)
  } else {
    // 单选和文本题：直接转字符串
    submitData[questionId] = String(answer)
  }
})
```

**测试要点**:
- ✅ 正常提交完整的答案
- ✅ 提交不存在的问卷ID（应返回404）
- ✅ 提交缺失题目的答案（后端应处理）
- ✅ 验证单选题答案格式
- ✅ 验证多选题答案格式（逗号分隔）
- ✅ 验证文本题答案格式
- ✅ 验证IP地址正确记录
- ✅ 验证提交时间正确记录

---

## 数据统计分析接口

### 3. 获取问卷完整分析

**接口描述**: 获取指定问卷的完整统计分析数据，包括所有题目的统计信息，用于统计页面展示。

**请求信息**:
- **URL**: `/api/v1/statistics/questionnaire/{id}/full-analysis`
- **方法**: `GET`
- **路径参数**:
  | 参数名 | 类型 | 必填 | 说明 |
  |--------|------|------|------|
  | id | Long | 是 | 问卷ID |

**请求示例**:
```http
GET /api/v1/statistics/questionnaire/1/full-analysis HTTP/1.1
Host: localhost:8080
```

**响应信息**:
- **状态码**: `200 OK`
- **Content-Type**: `application/json`
- **响应体**: 包含summary和questionsAnalysis的对象

**响应数据结构**:
```json
{
  "summary": {
    "totalSubmissions": 3,
    "lastSubmitTime": "2025-01-01T12:00:00"
  },
  "questionsAnalysis": [
    {
      "questionId": 1,
      "questionContent": "你最常用的编程语言是什么？",
      "questionType": 1,
      "totalResponses": 3,
      "chartData": [
        {
          "label": "Java",
          "value": 2,
          "percent": "66.67%"
        },
        {
          "label": "Python",
          "value": 1,
          "percent": "33.33%"
        }
      ]
    },
    {
      "questionId": 2,
      "questionContent": "你感兴趣的技术领域有哪些？",
      "questionType": 2,
      "totalResponses": 3,
      "chartData": [
        {
          "label": "人工智能",
          "value": 1,
          "percent": "33.33%"
        },
        {
          "label": "大数据分析",
          "value": 1,
          "percent": "33.33%"
        },
        {
          "label": "云原生/容器化",
          "value": 2,
          "percent": "66.67%"
        }
      ]
    },
    {
      "questionId": 3,
      "questionContent": "你对目前的工作环境有什么建议？",
      "questionType": 3,
      "totalResponses": 3,
      "textAnswers": [
        "希望增加更多带薪年假",
        "公司零食种类可以再多一点",
        "工作环境不错"
      ]
    }
  ]
}
```

**字段说明**:
| 字段 | 类型 | 说明 |
|------|------|------|
| summary | Object | 问卷摘要统计 |
| summary.totalSubmissions | Integer | 总提交数 |
| summary.lastSubmitTime | String | 最后提交时间（ISO 8601格式） |
| questionsAnalysis | Array | 题目分析列表（按questionOrder排序） |
| questionsAnalysis[].questionId | Long | 题目ID |
| questionsAnalysis[].questionContent | String | 题目内容 |
| questionsAnalysis[].questionType | Integer | 题目类型（1=单选，2=多选，3=文本） |
| questionsAnalysis[].totalResponses | Integer | 回答总数 |
| questionsAnalysis[].chartData | Array | 图表数据（选择题） |
| questionsAnalysis[].chartData[].label | String | 选项文本 |
| questionsAnalysis[].chartData[].value | Integer | 选择次数 |
| questionsAnalysis[].chartData[].percent | String | 百分比（格式：XX.XX%） |
| questionsAnalysis[].textAnswers | Array | 文本答案列表（文本题） |

**前端调用示例**:
```javascript
import { statisticsAPI } from '../services/api'

// 获取完整分析
const analysisData = await statisticsAPI.getFullAnalysis(1)
console.log('总提交数:', analysisData.summary.totalSubmissions)
console.log('题目分析:', analysisData.questionsAnalysis)

// 渲染图表
analysisData.questionsAnalysis.forEach(questionAnalysis => {
  if (questionAnalysis.questionType === 1) {
    // 单选题：饼图
    renderPieChart(questionAnalysis.chartData)
  } else if (questionAnalysis.questionType === 2) {
    // 多选题：柱状图
    renderBarChart(questionAnalysis.chartData)
  } else if (questionAnalysis.questionType === 3) {
    // 文本题：文本列表
    renderTextList(questionAnalysis.textAnswers)
  }
})
```

**测试要点**:
- ✅ 正常获取有数据的问卷分析
- ✅ 获取无提交记录的问卷（应返回空数据）
- ✅ 获取不存在的问卷ID（应返回404或空数据）
- ✅ 验证summary数据正确
- ✅ 验证questionsAnalysis按questionOrder排序
- ✅ 验证单选题的chartData格式
- ✅ 验证多选题的chartData格式
- ✅ 验证文本题的textAnswers格式
- ✅ 验证百分比计算正确
- ✅ 验证多选题的统计逻辑（每个选项独立计数）

---

### 4. 获取单个问题统计

**接口描述**: 获取指定单个问题的统计分析数据。

**请求信息**:
- **URL**: `/api/v1/statistics/question/{questionId}`
- **方法**: `GET`
- **路径参数**:
  | 参数名 | 类型 | 必填 | 说明 |
  |--------|------|------|------|
  | questionId | Long | 是 | 题目ID |

**请求示例**:
```http
GET /api/v1/statistics/question/1 HTTP/1.1
Host: localhost:8080
```

**响应信息**:
- **状态码**: `200 OK`
- **Content-Type**: `application/json`
- **响应体**: 问题统计对象

**响应数据结构**:

**单选题/多选题**:
```json
{
  "questionId": 1,
  "questionContent": "你最常用的编程语言是什么？",
  "questionType": 1,
  "totalResponses": 3,
  "chartData": [
    {
      "label": "Java",
      "value": 2,
      "percent": "66.67%"
    },
    {
      "label": "Python",
      "value": 1,
      "percent": "33.33%"
    }
  ]
}
```

**文本题**:
```json
{
  "questionId": 3,
  "questionContent": "你对目前的工作环境有什么建议？",
  "questionType": 3,
  "totalResponses": 3,
  "textAnswers": [
    "希望增加更多带薪年假",
    "公司零食种类可以再多一点",
    "工作环境不错"
  ]
}
```

**字段说明**: 同"获取问卷完整分析"接口中的questionsAnalysis项。

**前端调用示例**:
```javascript
import { statisticsAPI } from '../services/api'

// 获取单个问题统计
const questionStats = await statisticsAPI.getQuestionStats(1)
console.log('问题内容:', questionStats.questionContent)
console.log('回答总数:', questionStats.totalResponses)

if (questionStats.questionType === 3) {
  console.log('文本答案:', questionStats.textAnswers)
} else {
  console.log('图表数据:', questionStats.chartData)
}
```

**测试要点**:
- ✅ 正常获取存在的问题统计
- ✅ 获取不存在的问题ID（应返回null或404）
- ✅ 验证单选题返回chartData
- ✅ 验证多选题返回chartData
- ✅ 验证文本题返回textAnswers
- ✅ 验证数据格式正确

---

## 数据格式说明

### 题目类型（questionType）

| 值 | 类型 | 说明 | 前端展示 |
|----|------|------|----------|
| 1 | 单选题 | 只能选择一个选项 | 单选按钮（radio） |
| 2 | 多选题 | 可以选择多个选项 | 复选框（checkbox） |
| 3 | 文本题 | 自由文本输入 | 文本输入框（textarea） |

### 答案格式

**提交时的格式**:
- **单选题**: `"101"` （选项ID的字符串）
- **多选题**: `"201,203"` （逗号分隔的选项ID字符串）
- **文本题**: `"这是文本内容"` （文本字符串）

**前端存储格式**:
- **单选题**: `"101"` （字符串）
- **多选题**: `["201", "203"]` （数组，提交时需转换为逗号分隔字符串）
- **文本题**: `"这是文本内容"` （字符串）

---

## 错误处理

### HTTP状态码

| 状态码 | 说明 | 处理方式 |
|--------|------|----------|
| 200 | 请求成功 | 正常处理响应数据 |
| 400 | 请求参数错误 | 检查请求参数格式 |
| 404 | 资源不存在 | 提示用户问卷/问题不存在 |
| 500 | 服务器内部错误 | 提示用户稍后重试 |

### 前端错误处理示例

```javascript
try {
  const data = await questionnaireAPI.getQuestionnaire(id)
  // 处理成功响应
} catch (error) {
  if (error.response?.status === 404) {
    // 问卷不存在
    setError('问卷不存在，请检查问卷ID')
  } else if (error.response?.status === 500) {
    // 服务器错误
    setError('服务器错误，请稍后重试')
  } else {
    // 其他错误
    setError(error.message || '请求失败')
  }
}
```

---

## 测试用例

### 功能测试用例

#### TC-API-001: 获取问卷详情（正常）
- **前置条件**: 数据库中存在ID为1的问卷
- **测试步骤**:
  1. 发送GET请求到 `/api/v1/questionnaires/1/render`
  2. 验证返回状态码为200
  3. 验证返回数据包含id、title、questions等字段
  4. 验证questions数组不为空
  5. 验证每个question包含options（选择题）或options为空（文本题）
- **预期结果**: 返回完整的问卷数据
- **实际结果**: ✅ 通过

#### TC-API-002: 获取问卷详情（不存在）
- **前置条件**: 数据库中不存在ID为999的问卷
- **测试步骤**:
  1. 发送GET请求到 `/api/v1/questionnaires/999/render`
  2. 验证返回状态码为404或500
- **预期结果**: 返回404错误
- **实际结果**: ✅ 通过

#### TC-API-003: 提交问卷答案（正常）
- **前置条件**: 数据库中存在ID为1的问卷
- **测试步骤**:
  1. 准备提交数据：`{"1": "101", "2": "201,203", "3": "测试文本"}`
  2. 发送POST请求到 `/api/v1/questionnaires/1/submit`
  3. 验证返回状态码为200
  4. 验证返回消息为"提交成功！感谢参与。"
  5. 查询数据库验证答案已保存
- **预期结果**: 答案成功保存到数据库
- **实际结果**: ✅ 通过

#### TC-API-004: 提交问卷答案（多选题格式）
- **前置条件**: 数据库中存在ID为1的问卷，包含多选题
- **测试步骤**:
  1. 准备提交数据：`{"2": "201,203,204"}` （多选题选择3个选项）
  2. 发送POST请求
  3. 验证提交成功
  4. 查询数据库验证多选题答案格式正确
- **预期结果**: 多选题答案以逗号分隔字符串保存
- **实际结果**: ✅ 通过

#### TC-API-005: 获取问卷完整分析（正常）
- **前置条件**: 数据库中存在ID为1的问卷，且有提交记录
- **测试步骤**:
  1. 发送GET请求到 `/api/v1/statistics/questionnaire/1/full-analysis`
  2. 验证返回状态码为200
  3. 验证返回数据包含summary和questionsAnalysis
  4. 验证summary.totalSubmissions正确
  5. 验证questionsAnalysis数组长度等于题目数
  6. 验证每个题目分析数据格式正确
- **预期结果**: 返回完整的统计分析数据
- **实际结果**: ✅ 通过

#### TC-API-006: 获取问卷完整分析（无数据）
- **前置条件**: 数据库中存在ID为1的问卷，但无提交记录
- **测试步骤**:
  1. 发送GET请求
  2. 验证返回状态码为200
  3. 验证summary.totalSubmissions为0
  4. 验证questionsAnalysis数组不为空但chartData/textAnswers为空
- **预期结果**: 返回空统计数据
- **实际结果**: ✅ 通过

#### TC-API-007: 获取单个问题统计（单选题）
- **前置条件**: 数据库中存在ID为1的单选题，且有提交记录
- **测试步骤**:
  1. 发送GET请求到 `/api/v1/statistics/question/1`
  2. 验证返回状态码为200
  3. 验证返回数据包含questionId、questionContent、questionType
  4. 验证questionType为1
  5. 验证包含chartData数组
  6. 验证chartData中每个项包含label、value、percent
- **预期结果**: 返回单选题统计数据
- **实际结果**: ✅ 通过

#### TC-API-008: 获取单个问题统计（文本题）
- **前置条件**: 数据库中存在ID为3的文本题，且有提交记录
- **测试步骤**:
  1. 发送GET请求到 `/api/v1/statistics/question/3`
  2. 验证返回状态码为200
  3. 验证questionType为3
  4. 验证包含textAnswers数组
  5. 验证textAnswers包含所有文本答案
- **预期结果**: 返回文本题统计数据
- **实际结果**: ✅ 通过

### 边界测试用例

#### TC-API-009: 提交空答案
- **测试步骤**: 提交空的答案对象 `{}`
- **预期结果**: 后端应处理或返回错误提示
- **实际结果**: ⚠️ 需要验证

#### TC-API-010: 提交超大文本答案
- **测试步骤**: 提交超过1000字符的文本答案
- **预期结果**: 应能正常处理或返回长度限制错误
- **实际结果**: ⚠️ 需要验证

#### TC-API-011: 多选题选择所有选项
- **测试步骤**: 提交包含所有选项的多选题答案
- **预期结果**: 应能正常处理
- **实际结果**: ✅ 通过

### 性能测试用例

#### TC-API-012: 大量题目问卷加载
- **测试步骤**: 获取包含50+题目的问卷
- **预期结果**: 响应时间应在2秒内
- **实际结果**: ⚠️ 需要验证

#### TC-API-013: 大量提交记录统计
- **测试步骤**: 获取包含1000+提交记录的问卷统计
- **预期结果**: 响应时间应在3秒内
- **实际结果**: ⚠️ 需要验证

---

## 常见问题

### Q1: 获取问卷详情时，questions为空数组？

**A**: 可能原因：
1. 问卷确实没有题目
2. LAZY加载问题（已修复，添加了@Transactional和手动触发加载）
3. 数据库数据问题

**解决方案**:
- 检查数据库question表是否有对应数据
- 查看后端日志确认LAZY加载是否触发
- 使用浏览器开发者工具查看网络请求和响应

### Q2: 提交多选题时，后端接收不到数据？

**A**: 前端需要将多选题答案数组转换为逗号分隔字符串：
```javascript
// 错误：直接发送数组
submitData[questionId] = answer  // ["201", "203"]

// 正确：转换为字符串
submitData[questionId] = answer.join(',')  // "201,203"
```

### Q3: 统计接口返回的百分比计算不正确？

**A**: 多选题的百分比计算逻辑：
- 每个选项的选择次数 / 总回答数
- 注意：多选题的总回答数可能小于实际提交数（如果某题未答）

### Q4: 文本题统计返回的textAnswers顺序？

**A**: 按照提交时间顺序返回，最早提交的在前面。

### Q5: 如何测试接口？

**A**: 可以使用以下工具：
1. **浏览器开发者工具**: Network标签查看请求和响应
2. **Postman**: 手动测试API
3. **curl命令**: 命令行测试
4. **前端页面**: 直接在前端页面操作，查看控制台日志

**curl测试示例**:
```bash
# 获取问卷详情
curl http://localhost:8080/api/v1/questionnaires/1/render

# 提交问卷答案
curl -X POST http://localhost:8080/api/v1/questionnaires/1/submit \
  -H "Content-Type: application/json" \
  -d '{"1":"101","2":"201,203","3":"测试文本"}'

# 获取完整分析
curl http://localhost:8080/api/v1/statistics/questionnaire/1/full-analysis
```

---

## 附录

### A. 前端API封装代码位置

- **API服务**: `frontend/src/services/api.js`
- **问卷填写页面**: `frontend/src/pages/FillPage.jsx`
- **统计分析页面**: `frontend/src/pages/StatisticsPage.jsx`

### B. 后端Controller代码位置

- **问卷Controller**: `src/main/java/com/example/smartsurveysystem/controller/QuestionnaireController.java`
- **统计Controller**: `src/main/java/com/example/smartsurveysystem/controller/StatisticsController.java`

### C. 数据模型

- **Questionnaire实体**: `src/main/java/com/example/smartsurveysystem/entity/Questionnaire.java`
- **Question实体**: `src/main/java/com/example/smartsurveysystem/entity/Question.java`
- **Option实体**: `src/main/java/com/example/smartsurveysystem/entity/Option.java`

---

**文档结束**

如有问题或需要补充，请联系角色D。

