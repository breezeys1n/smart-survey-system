#!/bin/bash

# 数据切换脚本 (Linux/Mac版本)
# 用于快速切换不同的测试数据集

DATASET=$1
PASSWORD="Mysql@693"
DATABASE="smart_survey"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}=========================================="
echo "测试数据切换工具"
echo -e "==========================================${NC}"
echo ""

if [ -z "$DATASET" ] || [ "$DATASET" = "list" ]; then
    echo -e "${YELLOW}可用的测试数据集:${NC}"
    echo -e "${GREEN}  1 - 程序员现状调查（基础测试）${NC}"
    echo "     包含: 3道题（单选、多选、文本），3条提交记录"
    echo ""
    echo -e "${GREEN}  2 - 用户满意度调查（多题目测试）${NC}"
    echo "     包含: 5道题（单选、多选、文本），5条提交记录"
    echo ""
    echo -e "${GREEN}  3 - 简单单题问卷（最小测试）${NC}"
    echo "     包含: 1道单选题，2条提交记录"
    echo ""
    echo -e "${GREEN}  4 - 纯文本问卷（文本题测试）${NC}"
    echo "     包含: 3道文本题，3条提交记录"
    echo ""
    echo -e "${GREEN}  5 - 综合功能测试问卷（完整测试）${NC}"
    echo "     包含: 7道题（单选、多选、文本），8条提交记录"
    echo ""
    echo -e "${YELLOW}使用方法:${NC}"
    echo -e "${CYAN}  ./switch-data.sh 1${NC}"
    exit 0
fi

if ! [[ "$DATASET" =~ ^[1-5]$ ]]; then
    echo -e "${RED}[错误] 无效的数据集编号，请输入 1-5${NC}"
    exit 1
fi

SQL_FILE="$(dirname "$SCRIPT_DIR")/mock/init-data-set$DATASET.sql"

if [ ! -f "$SQL_FILE" ]; then
    echo -e "${RED}[错误] 找不到数据文件: $SQL_FILE${NC}"
    exit 1
fi

echo -e "${YELLOW}切换到数据集 $DATASET...${NC}"
echo "数据文件: $SQL_FILE"
echo ""

# 执行SQL
echo -e "${YELLOW}正在执行SQL脚本...${NC}"
mysql -u root "-p$PASSWORD" "$DATABASE" < "$SQL_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[成功] 数据切换完成${NC}"
else
    echo -e "${RED}[错误] 数据切换失败${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}验证数据...${NC}"

# 检查数据
QUESTIONNAIRE_COUNT=$(mysql -u root "-p$PASSWORD" -e "USE $DATABASE; SELECT COUNT(*) FROM questionnaire;" 2>/dev/null | tail -n 1)
QUESTION_COUNT=$(mysql -u root "-p$PASSWORD" -e "USE $DATABASE; SELECT COUNT(*) FROM question;" 2>/dev/null | tail -n 1)
OPTION_COUNT=$(mysql -u root "-p$PASSWORD" -e "USE $DATABASE; SELECT COUNT(*) FROM option_item;" 2>/dev/null | tail -n 1)
RESPONSE_COUNT=$(mysql -u root "-p$PASSWORD" -e "USE $DATABASE; SELECT COUNT(*) FROM user_response;" 2>/dev/null | tail -n 1)

echo ""
echo -e "${CYAN}数据统计:${NC}"
echo -e "${GREEN}  问卷数量: $QUESTIONNAIRE_COUNT${NC}"
echo -e "${GREEN}  题目数量: $QUESTION_COUNT${NC}"
echo -e "${GREEN}  选项数量: $OPTION_COUNT${NC}"
echo -e "${GREEN}  提交记录: $RESPONSE_COUNT${NC}"

echo ""
echo -e "${CYAN}=========================================="
echo -e "${GREEN}切换完成！${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo -e "${YELLOW}提示: 刷新前端页面查看新数据${NC}"

