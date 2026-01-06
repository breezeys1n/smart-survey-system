# 一键启动脚本 - 智能问卷系统

# 1. 切换到项目目录
cd "D:\work\软件工程\问卷"

# 2. 启动后端
Write-Host "启动后端服务..." -ForegroundColor Green
Start-Process cmd -ArgumentList "/c .\mvnw.cmd spring-boot:run" -WindowStyle Minimized

# 3. 等待后端启动
Start-Sleep -Seconds 5

# 4. 启动前端
Write-Host "启动前端服务..." -ForegroundColor Cyan
cd frontend
Start-Process cmd -ArgumentList "/c npm run dev" -WindowStyle Minimized

# 5. 返回项目目录
cd ..

# 6. 显示信息
Write-Host "`n服务已启动：" -ForegroundColor White
Write-Host "前端: http://localhost:3000" -ForegroundColor Cyan
Write-Host "后端: http://localhost:8080" -ForegroundColor Cyan
Write-Host "`n按 Ctrl+C 停止查看，服务会继续在后台运行" -ForegroundColor Yellow
Write-Host "要停止服务，打开任务管理器结束相关进程" -ForegroundColor Gray

# 7. 保持窗口打开
Read-Host "按回车键关闭此窗口"