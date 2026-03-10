# OpenClaw Browser Relay - Chrome Extension

浏览器扩展，用于连接 Chrome 标签页到 OpenClaw 进行远程控制。

## 安装步骤

### 1. 打开 Chrome 扩展管理页面
```
chrome://extensions/
```

### 2. 启用开发者模式
- 右上角开关打开 "Developer mode"

### 3. 加载扩展
- 点击 "Load unpacked"
- 选择本文件夹 (`browser-relay-extension`)
- 扩展会出现在列表中

### 4. 固定到工具栏
- 点击 Chrome 工具栏的拼图图标
- 找到 "OpenClaw Browser Relay"
- 点击图钉图标固定

## 使用方法

1. **确保 OpenClaw 网关正在运行**
   ```bash
   openclaw gateway status
   ```

2. **在目标网页点击扩展图标**
   - 图标显示 "OFF" → 点击连接
   - 图标显示 "ON" → 已连接

3. **OpenClaw 现在可以控制此标签页**
   - 截图
   - 点击元素
   - 填写表单
   - 导航页面

## 故障排除

| 问题 | 解决方案 |
|------|----------|
| 显示 "OpenClaw Not Running" | 确保 `openclaw gateway` 已启动 |
| 连接失败 | 检查防火墙是否允许 localhost:5003 |
| 扩展不显示 | 确认已启用开发者模式 |

## 文件说明

- `manifest.json` - 扩展配置
- `background.js` - 后台脚本
- `popup.html/js` - 弹出窗口
- `icon*.png` - 图标文件
