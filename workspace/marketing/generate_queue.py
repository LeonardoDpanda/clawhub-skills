#!/usr/bin/env python3
"""
自动生成次日内容队列
"""

import os
from datetime import datetime, timedelta

# 内容库
CONTENT_LIBRARY = {
    "morning": [
        """🚀 新的一天，新的代码！分享一个今天让我省时间的工具。

你用什么工具提升效率？

#DevTools #Productivity""",
        
        """💡 晨间思考：自动化是程序员的复利

每天省10分钟 = 每年省60小时

你的时间投资在哪里？

#Automation #Developer""",
        
        """☕ Good morning devs!

今天要用哪个CLI工具开始工作？

#MorningRoutine #CLI"""
    ],
    "afternoon": [
        """刚解决了一个烦人的问题。

有时候最简单的工具反而最有效。

你们的go-to工具是什么？

#Developer #Tools""",
        
        """💡 开发者效率技巧：

把重复的工作写成脚本
一次投入，永久受益

我的工具集帮我每天省1小时+

#Productivity #DevTips""",
        
        """🔧 工具推荐：

命令行工具的优势：
✅ 启动快
✅ 内存小
✅ 可脚本化
✅ 可组合

GUI工具做不到的这些 ⚡

#CLI #Unix"""
    ],
    "evening": [
        """📊 今日总结：

自动化流程又帮我省了不少时间。

把时间花在真正重要的事情上。

#Automation #Efficiency""",
        
        """🌙 Evening thoughts:

Best investment for developers:
Build tools that save time.

Time saved compounds.

#Developer #SideProject""",
        
        """📚 今日学到：

简单的自动化 > 复杂的手动操作

CLI工具的魅力就在于此 🛠️

#DevTips #Learning"""
    ]
}

def generate_queue():
    """生成未来7天的内容队列"""
    queue_dir = "/workspace/projects/workspace/marketing/queue"
    os.makedirs(queue_dir, exist_ok=True)
    
    today = datetime.now()
    
    for i in range(7):
        date = today + timedelta(days=i)
        date_str = date.strftime("%Y-%m-%d")
        
        # 生成3个时间点的内容
        for slot, contents in CONTENT_LIBRARY.items():
            filename = f"{queue_dir}/{date_str}_{slot}.txt"
            
            # 如果文件不存在，创建它
            if not os.path.exists(filename):
                # 轮流使用内容库
                content_index = (i + list(CONTENT_LIBRARY.keys()).index(slot)) % len(contents)
                content = contents[content_index]
                
                with open(filename, 'w') as f:
                    f.write(content)
                
                print(f"✅ 创建: {filename}")
            else:
                print(f"⏭️ 已存在: {filename}")
    
    print("\n✅ 内容队列生成完成!")

if __name__ == "__main__":
    generate_queue()
