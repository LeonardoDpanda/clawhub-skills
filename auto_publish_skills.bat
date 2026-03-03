@echo off
chcp 65001 >nul 2>&1
echo ========================ClawHub技能自动化发布========================
echo 1. 定位到技能存储目录...
cd /d D:\ClawHub_Skills

echo 2. 拉取远程最新版本（避免冲突）...
git pull origin main

echo 3. 添加所有新生成的技能文件...
git add .

echo 4. 提交更新（自动带时间戳）...
git commit -m "【自动发布】%date% %time% 新增OpenClaw技能模板"

echo 5. 推送到GitHub远程仓库...
git push origin main

echo 6. 发布到ClawHub平台...
clawhub publish https://github.com/LeonardoDpanda/clawhub-skills.git

echo ========================发布流程执行完毕！========================
echo 请查看上方输出，无红色报错即代表成功。
pause