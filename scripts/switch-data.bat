@echo off
REM 数据切换脚本 (Windows CMD版本)

set PASSWORD=Mysql@693
set DATABASE=smart_survey

if "%1"=="" goto :list
if "%1"=="list" goto :list

set DATASET=%1
set SQL_FILE=%~dp0..\mock\init-data-set%DATASET%.sql

if not exist "%SQL_FILE%" (
    echo [错误] 找不到数据文件: %SQL_FILE%
    exit /b 1
)

echo ==========================================
echo 测试数据切换工具
echo ==========================================
echo.
echo 切换到数据集 %DATASET%...
echo 数据文件: %SQL_FILE%
echo.

echo 正在执行SQL脚本...
mysql -u root "-p%PASSWORD%" %DATABASE% < "%SQL_FILE%"

if errorlevel 1 (
    echo [错误] 数据切换失败
    exit /b 1
)

echo [成功] 数据切换完成
echo.
echo 验证数据...

mysql -u root "-p%PASSWORD%" -e "USE %DATABASE%; SELECT COUNT(*) as '问卷数量' FROM questionnaire;" 2>nul
mysql -u root "-p%PASSWORD%" -e "USE %DATABASE%; SELECT COUNT(*) as '题目数量' FROM question;" 2>nul
mysql -u root "-p%PASSWORD%" -e "USE %DATABASE%; SELECT COUNT(*) as '选项数量' FROM option_item;" 2>nul
mysql -u root "-p%PASSWORD%" -e "USE %DATABASE%; SELECT COUNT(*) as '提交记录' FROM user_response;" 2>nul

echo.
echo ==========================================
echo 切换完成！
echo ==========================================
echo.
echo 提示: 刷新前端页面查看新数据
exit /b 0

:list
echo 可用的测试数据集:
echo   1 - 程序员现状调查（基础测试）
echo      包含: 3道题（单选、多选、文本），3条提交记录
echo.
echo   2 - 用户满意度调查（多题目测试）
echo      包含: 5道题（单选、多选、文本），5条提交记录
echo.
echo   3 - 简单单题问卷（最小测试）
echo      包含: 1道单选题，2条提交记录
echo.
echo   4 - 纯文本问卷（文本题测试）
echo      包含: 3道文本题，3条提交记录
echo.
echo   5 - 综合功能测试问卷（完整测试）
echo      包含: 7道题（单选、多选、文本），8条提交记录
echo.
echo 使用方法:
echo   switch-data.bat 1
exit /b 0

