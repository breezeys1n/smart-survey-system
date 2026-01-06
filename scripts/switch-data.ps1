# 数据切换脚本 (PowerShell版本)
# 用于快速切换不同的测试数据集

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("1", "2", "3", "4", "5", "list")]
    [string]$Dataset
)

$password = "Mysql@693"
$database = "smart_survey"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "测试数据切换工具" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if ($Dataset -eq "list") {
    Write-Host "可用的测试数据集:" -ForegroundColor Yellow
    Write-Host "  1 - 程序员现状调查（基础测试）" -ForegroundColor Green
    Write-Host "     包含: 3道题（单选、多选、文本），3条提交记录" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  2 - 用户满意度调查（多题目测试）" -ForegroundColor Green
    Write-Host "     包含: 5道题（单选、多选、文本），5条提交记录" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  3 - 简单单题问卷（最小测试）" -ForegroundColor Green
    Write-Host "     包含: 1道单选题，2条提交记录" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  4 - 纯文本问卷（文本题测试）" -ForegroundColor Green
    Write-Host "     包含: 3道文本题，3条提交记录" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  5 - 综合功能测试问卷（完整测试）" -ForegroundColor Green
    Write-Host "     包含: 7道题（单选、多选、文本），8条提交记录" -ForegroundColor Gray
    Write-Host ""
    Write-Host "使用方法:" -ForegroundColor Yellow
    Write-Host "  .\switch-data.ps1 -Dataset 1" -ForegroundColor Cyan
    exit 0
}

$sqlFile = Join-Path (Split-Path $scriptDir -Parent) "mock\init-data-set$Dataset.sql"

if (-not (Test-Path $sqlFile)) {
    Write-Host "[错误] 找不到数据文件: $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host "切换到数据集 $Dataset..." -ForegroundColor Yellow
Write-Host "数据文件: $sqlFile" -ForegroundColor Gray
Write-Host ""

# 读取SQL文件
$sqlContent = Get-Content $sqlFile -Raw -Encoding UTF8

# 执行SQL
Write-Host "正在执行SQL脚本..." -ForegroundColor Yellow
$result = mysql -u root "-p$password" $database -e $sqlContent 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "[成功] 数据切换完成" -ForegroundColor Green
} else {
    Write-Host "[错误] 数据切换失败" -ForegroundColor Red
    Write-Host $result
    exit 1
}

Write-Host ""
Write-Host "验证数据..." -ForegroundColor Yellow

# 检查问卷数据
$questionnaireCount = mysql -u root "-p$password" -e "USE $database; SELECT COUNT(*) FROM questionnaire;" 2>&1 | Select-String -Pattern "\d+" | ForEach-Object { $_.Matches.Value }
$questionCount = mysql -u root "-p$password" -e "USE $database; SELECT COUNT(*) FROM question;" 2>&1 | Select-String -Pattern "\d+" | ForEach-Object { $_.Matches.Value }
$optionCount = mysql -u root "-p$password" -e "USE $database; SELECT COUNT(*) FROM option_item;" 2>&1 | Select-String -Pattern "\d+" | ForEach-Object { $_.Matches.Value }
$responseCount = mysql -u root "-p$password" -e "USE $database; SELECT COUNT(*) FROM user_response;" 2>&1 | Select-String -Pattern "\d+" | ForEach-Object { $_.Matches.Value }

Write-Host ""
Write-Host "数据统计:" -ForegroundColor Cyan
Write-Host "  问卷数量: $questionnaireCount" -ForegroundColor Green
Write-Host "  题目数量: $questionCount" -ForegroundColor Green
Write-Host "  选项数量: $optionCount" -ForegroundColor Green
Write-Host "  提交记录: $responseCount" -ForegroundColor Green

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "切换完成！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "提示: 刷新前端页面查看新数据" -ForegroundColor Yellow

