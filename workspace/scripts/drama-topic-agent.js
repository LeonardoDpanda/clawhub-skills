#!/usr/bin/env node
/**
 * 短剧选题交付智能体 - DramaTopicAgent
 * 
 * 功能：
 * 1. 生成3个女性向爆款短剧选题
 * 2. 保存为Markdown文件
 * 3. 上传到云盘并生成分享链接（可选）
 * 4. 发送消息通知买家（需配置渠道）
 * 5. 记录交付日志
 * 
 * 使用方法：
 * node scripts/drama-topic-agent.js --order-id=ORDER_001 --buyer-id=BUYER_001
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// ============ 配置 ============
const CONFIG = {
    // 输出目录
    outputDir: process.env.DRAMA_OUTPUT_DIR || './deliverables',
    logDir: process.env.DRAMA_LOG_DIR || './logs',
    
    // 云盘配置（可选）
    cloudDrive: {
        enabled: process.env.CLOUD_DRIVE_ENABLED === 'true',
        type: process.env.CLOUD_DRIVE_TYPE || 'aliyun', // aliyun, baidu, quark
        uploadScript: process.env.CLOUD_UPLOAD_SCRIPT || '',
        targetFolder: process.env.CLOUD_TARGET_FOLDER || '/短剧选题交付',
    },
    
    // 消息通知配置（可选）
    messaging: {
        enabled: process.env.MESSAGING_ENABLED === 'true',
        channel: process.env.MESSAGING_CHANNEL || 'xianyu', // xianyu, telegram, email
    },
    
    // 选题配置
    topicCount: 3,
    genre: '女性向',
};

// ============ 短剧选题数据库 ============
const TOPIC_TEMPLATES = {
    // 现代都市类
    modern: [
        {
            theme: '职场逆袭',
            titles: ['《职场女王驾到》', '《实习生翻身记》', '《总监，请指教》'],
            settings: [
                '大型互联网公司',
                '时尚杂志社',
                '顶级律师事务所',
                '家族企业',
                '创业工作室'
            ],
            archetypes: [
                { role: '女主', traits: ['能力强但被低估', '隐忍后爆发', '专业能力顶尖'] },
                { role: '男主/反派', traits: ['霸道总裁', '职场霸凌者', '竞争对手'] },
                { role: '配角', traits: ['势利眼同事', '真心朋友', '神秘贵人'] }
            ],
            conflicts: [
                '被同事陷害背黑锅',
                '项目被抢功',
                '被潜规则威胁',
                '职场PUA',
                '能力被性别歧视'
            ],
            payoffs: [
                '用实力打脸所有人',
                '当众揭穿阴谋',
                '逆袭成为行业顶尖',
                '让欺负她的人跪求合作',
                '收获事业爱情双丰收'
            ]
        },
        {
            theme: '婚姻复仇',
            titles: ['《离婚后我暴富了》', '《前夫跪求复婚》', '《新婚夜，我发现丈夫的秘密》'],
            settings: [
                '豪门世家',
                '普通都市家庭',
                '商业联姻',
                '闪婚现场'
            ],
            archetypes: [
                { role: '女主', traits: ['隐忍贤妻', '被背叛后觉醒', '隐藏身份的大佬'] },
                { role: '前夫', traits: ['渣男出轨', '势利眼', '后期追悔莫及'] },
                { role: '女配', traits: ['绿茶小三', '心机闺蜜', '真千金'] }
            ],
            conflicts: [
                '发现丈夫出轨闺蜜',
                '被婆婆刁难被当保姆',
                '为家庭付出一切却被抛弃',
                '丈夫转移财产',
                '被设计净身出户'
            ],
            payoffs: [
                '曝光渣男真面目让他身败名裂',
                '展现真实身份让对方高攀不起',
                '找到真爱让前夫嫉妒发狂',
                '事业成功让前夫跪求复合',
                '让小三和渣男互相撕扯'
            ]
        },
        {
            theme: '甜宠恋爱',
            titles: ['《闪婚后，总裁宠翻天》', '《契约娇妻太撩人》', '《暗恋对象成了我上司》'],
            settings: [
                '豪门宴会',
                '普通公司',
                '意外邂逅场景',
                '契约婚姻',
                '青梅竹马重逢'
            ],
            archetypes: [
                { role: '女主', traits: ['单纯善良', '有隐藏马甲', '独立自强'] },
                { role: '男主', traits: ['高冷霸总', '只对女主温柔', '护妻狂魔'] },
                { role: '助攻', traits: ['神助攻闺蜜', '可爱萌宝', '毒舌助理'] }
            ],
            conflicts: [
                '身份地位悬殊',
                '误会重重',
                '前任纠缠',
                '家族反对',
                '契约到期危机'
            ],
            payoffs: [
                '男主霸道护妻',
                '甜蜜日常撒糖',
                '身份揭晓震惊众人',
                '双向奔赴的爱情',
                '完美结局大圆满'
            ]
        },
        {
            theme: '重生复仇',
            titles: ['《重生后，我成了首富》', '《重生千金要复仇》', '《回到十年前，我杀疯了》'],
            settings: [
                '高中/大学校园',
                '创业初期',
                '家族企业',
                '娱乐圈'
            ],
            archetypes: [
                { role: '女主', traits: ['带着前世记忆', '智商在线', '果断狠辣'] },
                { role: '仇人', traits: ['前世害死女主', '虚伪阴险', '最终被反杀'] },
                { role: '守护者', traits: ['前世错过的真爱', '默默守护', '最强助攻'] }
            ],
            conflicts: [
                '前世被最信任的人背叛',
                '家族被陷害破产',
                '被诬陷身败名裂',
                '错过真爱遗憾终身',
                '努力一切被窃取'
            ],
            payoffs: [
                '提前布局改变人生',
                '让仇人自食其果',
                '弥补前世遗憾',
                '收获前世错过的幸福',
                '站在人生巅峰俯视仇人'
            ]
        }
    ],
    
    // 古代/古装类
    ancient: [
        {
            theme: '宫斗权谋',
            titles: ['《宠妃，她杀疯了》', '《本宫不死，尔等终究是妃》', '《废后归来》'],
            settings: [
                '深宫后院',
                '选秀现场',
                '冷宫',
                '御花园',
                '朝堂'
            ],
            archetypes: [
                { role: '女主', traits: ['聪慧过人', '心狠手辣', '隐忍不发'] },
                { role: '皇帝', traits: ['疑心重', '被女主吸引', '权力至上'] },
                { role: '反派', traits: ['恶毒皇后', '心机妃嫔', '权势外戚'] }
            ],
            conflicts: [
                '被陷害入冷宫',
                '家族被牵连',
                '孩子被害',
                '被下毒毁容',
                '姐妹背叛'
            ],
            payoffs: [
                '步步为营登上后位',
                '让仇人自相残杀',
                '获得皇帝独宠',
                '为家族复仇雪恨',
                '掌握后宫生杀大权'
            ]
        },
        {
            theme: '穿越逆袭',
            titles: ['《穿越后，我成了诰命夫人》', '《农门娇妻有点甜》', '《王妃她每天都在打脸》'],
            settings: [
                '古代农村',
                '王府侯府',
                '京城',
                '边关',
                '书院'
            ],
            archetypes: [
                { role: '女主', traits: ['现代思维', '多才多艺', '不走寻常路'] },
                { role: '男主', traits: ['高冷王爷', '痴情专一', '权势滔天'] },
                { role: '反派', traits: ['势利亲戚', '恶毒嫡母', '情敌贵女'] }
            ],
            conflicts: [
                '被当成废柴嘲笑',
                '被逼婚给纨绔',
                '被人设计失节',
                '家族被欺辱',
                '现代观念不被接受'
            ],
            payoffs: [
                '用现代知识逆袭',
                '打脸所有看不起她的人',
                '嫁给最好的男人',
                '事业爱情双丰收',
                '改变时代成为传奇'
            ]
        }
    ],
    
    // 奇幻/异能类
    fantasy: [
        {
            theme: '修仙逆袭',
            titles: ['《废柴师妹她杀疯了》', '《被挖灵根后，我飞升了》', '《全员重生后，只有我没变》'],
            settings: [
                '修仙门派',
                '秘境',
                '仙魔战场',
                '凡间历练',
                '天庭'
            ],
            archetypes: [
                { role: '女主', traits: ['废柴开局', '隐藏血脉', '悟性逆天'] },
                { role: '师尊/男主', traits: ['高冷仙尊', '护短狂魔', '实力天花板'] },
                { role: '反派', traits: ['恶毒师姐', '伪善长老', '魔族'] }
            ],
            conflicts: [
                '被同门欺凌',
                '被陷害失去灵根',
                '被污蔑勾结魔族',
                '被当成炉鼎',
                '至亲被害'
            ],
            payoffs: [
                '觉醒逆天血脉',
                '实力碾压所有人',
                '让仇人跪地求饶',
                '成为最强者',
                '收获仙尊独宠'
            ]
        }
    ]
};

// ============ 工具函数 ============

/**
 * 随机选择数组元素
 */
function randomPick(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

/**
 * 随机选择多个不重复元素
 */
function randomPicks(arr, count) {
    const shuffled = [...arr].sort(() => 0.5 - Math.random());
    return shuffled.slice(0, count);
}

/**
 * 确保目录存在
 */
function ensureDir(dir) {
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
    }
}

/**
 * 格式化日期
 */
function formatDate(date = new Date()) {
    return date.toISOString().replace('T', ' ').substring(0, 19);
}

/**
 * 生成唯一ID
 */
function generateId(prefix = '') {
    const timestamp = Date.now().toString(36);
    const random = Math.random().toString(36).substring(2, 6);
    return `${prefix}${timestamp}${random}`.toUpperCase();
}

// ============ 核心业务逻辑 ============

/**
 * 生成单个短剧选题
 */
function generateTopic(category, index) {
    const templates = TOPIC_TEMPLATES[category];
    const template = randomPick(templates);
    
    const title = randomPick(template.titles);
    const setting = randomPick(template.settings);
    const mainConflict = randomPick(template.conflicts);
    const payoff = randomPick(template.payoffs);
    const archetypes = template.archetypes;
    
    // 生成大纲
    const episodes = [
        '第一集：开场引爆 - 女主遭遇重大打击/危机，引出核心冲突',
        '第二集：反击开始 - 女主开始展现能力/隐藏身份/布局',
        '第三集：打脸时刻 - 第一次小高潮，让一个小反派吃瘪',
        '第四集：感情线发展 - 与男主/关键人物产生交集',
        '第五集：危机升级 - 大反派出手，女主陷入更大危机',
        '第六集：惊天反转 - 女主真实实力/身份揭晓，震惊众人',
        '第七集：全面碾压 - 女主开始收割，让仇人付出代价',
        '第八集：终极对决 - 与大反派正面对决',
        '第九集：圆满结局 - 大仇得报，收获幸福/事业巅峰',
        '第十集：彩蛋/第二季预告 - 埋下新伏笔'
    ];
    
    return {
        index: index + 1,
        theme: template.theme,
        title: title,
        setting: setting,
        characters: archetypes.map(a => ({
            role: a.role,
            traits: randomPicks(a.traits, 2).join('、')
        })),
        conflict: mainConflict,
        payoff: payoff,
        outline: episodes,
        tags: [template.theme, category === 'modern' ? '现代' : category === 'ancient' ? '古装' : '奇幻', '女频', '爆款']
    };
}

/**
 * 生成3个短剧选题
 */
function generateTopics() {
    const categories = ['modern', 'ancient', 'fantasy'];
    const topics = [];
    
    for (let i = 0; i < CONFIG.topicCount; i++) {
        const category = categories[i % categories.length];
        topics.push(generateTopic(category, i));
    }
    
    return topics;
}

/**
 * 将选题转换为Markdown格式
 */
function topicsToMarkdown(topics, orderInfo) {
    const now = formatDate();
    
    let md = `# 短剧选题交付文档

---

**订单信息**
- 交付时间：${now}
- 订单编号：${orderInfo.orderId}
- 客户编号：${orderInfo.buyerId}
- 选题数量：${topics.length}个
- 选题类型：女性向爆款短剧

---

`;

    topics.forEach((topic, idx) => {
        md += `## 选题${topic.index}：${topic.title}

### 基本信息
| 项目 | 内容 |
|------|------|
| 题材类型 | ${topic.theme} |
| 时代背景 | ${topic.tags[1]} |
| 核心场景 | ${topic.setting} |

### 人设设定
`;
        topic.characters.forEach(char => {
            md += `- **${char.role}**：${char.traits}\n`;
        });

        md += `
### 核心冲突
> ${topic.conflict}

### 核心爽点
> ${topic.payoff}

### 分集大纲
`;
        topic.outline.forEach(ep => {
            md += `${ep}\n\n`;
        });

        md += `### 标签
`;
        topic.tags.forEach(tag => {
            md += `#${tag} `;
        });
        
        md += `\n\n---\n\n`;
    });

    md += `## 使用说明

### 版权说明
本文档中的短剧选题仅供参考和灵感启发，版权归创作者所有。请勿直接抄袭已播出的短剧剧情。

### 改编建议
1. **人设深化**：根据目标受众调整主角性格特点
2. **地域特色**：可加入方言、地方文化元素增加亲近感
3. **热点结合**：结合当下社会热点话题增加讨论度
4. **节奏把控**：每集结尾留悬念，提高完播率

### 制作建议
- **单集时长**：1-3分钟为佳
- **总集数**：80-100集（可调整）
- **投流平台**：抖音、快手、视频号
- **变现方式**：付费解锁、广告植入、品牌合作

---

*本内容由智能体自动生成 | 如有定制需求请联系客服*
`;

    return md;
}

/**
 * 保存文件
 */
function saveDeliverable(content, orderId) {
    ensureDir(CONFIG.outputDir);
    
    const timestamp = new Date().toISOString().split('T')[0];
    const filename = `短剧选题_${orderId}_${timestamp}.md`;
    const filepath = path.join(CONFIG.outputDir, filename);
    
    fs.writeFileSync(filepath, content, 'utf8');
    
    return { filename, filepath };
}

/**
 * 上传到云盘（模拟/实际）
 */
async function uploadToCloud(filepath, filename) {
    if (!CONFIG.cloudDrive.enabled) {
        return {
            success: false,
            message: '云盘上传未启用',
            link: null
        };
    }

    // 如果有自定义上传脚本，执行它
    if (CONFIG.cloudDrive.uploadScript) {
        try {
            const result = execSync(
                `${CONFIG.cloudDrive.uploadScript} "${filepath}" "${filename}"`,
                { encoding: 'utf8' }
            );
            return {
                success: true,
                message: '上传成功',
                link: result.trim()
            };
        } catch (error) {
            return {
                success: false,
                message: `上传失败: ${error.message}`,
                link: null
            };
        }
    }

    // 返回模拟结果
    return {
        success: true,
        message: '云盘上传功能已配置',
        link: `[云盘分享链接 - 请手动上传到${CONFIG.cloudDrive.type}云盘]`
    };
}

/**
 * 发送消息通知
 */
async function sendNotification(orderInfo, fileInfo, cloudLink) {
    if (!CONFIG.messaging.enabled) {
        return {
            success: false,
            message: '消息通知未启用'
        };
    }

    const message = `您好！您的短剧选题已生成完成 📋

订单编号：${orderInfo.orderId}
交付文件：${fileInfo.filename}
${cloudLink ? `下载链接：${cloudLink}` : '文件已保存至服务器'}

使用说明：
1. 本文档包含3个精心设计的女性向短剧选题
2. 每个选题包含完整的人设、冲突、爽点、分集大纲
3. 选题可自由改编，建议结合当前热点

如有问题请随时联系，祝创作顺利！✨`;

    // 根据渠道类型发送
    switch (CONFIG.messaging.channel) {
        case 'telegram':
            // 通过 Telegram 发送
            return await sendTelegram(orderInfo.buyerId, message);
        case 'email':
            // 通过邮件发送
            return await sendEmail(orderInfo.buyerId, message);
        case 'xianyu':
        default:
            // 闲鱼渠道需要特殊处理
            return {
                success: false,
                message: '闲鱼消息发送需通过 OpenClaw 渠道配置，当前未配置'
            };
    }
}

/**
 * 记录交付日志
 */
function logDelivery(orderInfo, fileInfo, cloudResult, messageResult) {
    ensureDir(CONFIG.logDir);
    
    const logEntry = {
        timestamp: new Date().toISOString(),
        orderId: orderInfo.orderId,
        buyerId: orderInfo.buyerId,
        filename: fileInfo.filename,
        filepath: fileInfo.filepath,
        cloudUpload: cloudResult,
        messageSent: messageResult,
        status: cloudResult.success && messageResult.success ? 'completed' : 'partial'
    };
    
    const logFile = path.join(CONFIG.logDir, 'delivery-log.jsonl');
    fs.appendFileSync(logFile, JSON.stringify(logEntry) + '\n', 'utf8');
    
    return logEntry;
}

// ============ 主流程 ============

async function main() {
    // 解析命令行参数
    const args = process.argv.slice(2);
    const orderId = args.find(a => a.startsWith('--order-id='))?.split('=')[1] || generateId('ORD_');
    const buyerId = args.find(a => a.startsWith('--buyer-id='))?.split('=')[1] || 'ANONYMOUS';
    
    const orderInfo = { orderId, buyerId };
    
    console.log('========================================');
    console.log('   短剧选题交付智能体 v1.0');
    console.log('========================================');
    console.log(`订单编号：${orderId}`);
    console.log(`买家编号：${buyerId}`);
    console.log('----------------------------------------\n');
    
    // 1. 生成选题
    console.log('📋 正在生成短剧选题...');
    const topics = generateTopics();
    console.log(`✅ 已生成 ${topics.length} 个选题\n`);
    
    // 2. 转换为Markdown并保存
    console.log('📝 正在整理文档...');
    const markdown = topicsToMarkdown(topics, orderInfo);
    const fileInfo = saveDeliverable(markdown, orderId);
    console.log(`✅ 文档已保存: ${fileInfo.filepath}\n`);
    
    // 3. 上传到云盘
    console.log('☁️  正在上传云盘...');
    const cloudResult = await uploadToCloud(fileInfo.filepath, fileInfo.filename);
    console.log(`${cloudResult.success ? '✅' : '⚠️'} ${cloudResult.message}`);
    if (cloudResult.link) {
        console.log(`   分享链接: ${cloudResult.link}\n`);
    }
    
    // 4. 发送消息通知
    console.log('📤 正在发送通知...');
    const messageResult = await sendNotification(orderInfo, fileInfo, cloudResult.link);
    console.log(`${messageResult.success ? '✅' : '⚠️'} ${messageResult.message}\n`);
    
    // 5. 记录日志
    console.log('🗂️  正在记录日志...');
    const logEntry = logDelivery(orderInfo, fileInfo, cloudResult, messageResult);
    console.log('✅ 日志已记录\n');
    
    // 输出摘要
    console.log('========================================');
    console.log('   交付完成！');
    console.log('========================================');
    console.log(`文件路径：${fileInfo.filepath}`);
    if (cloudResult.link) {
        console.log(`分享链接：${cloudResult.link}`);
    }
    console.log(`日志状态：${logEntry.status}`);
    console.log('========================================');
}

// 运行
main().catch(err => {
    console.error('❌ 执行失败:', err.message);
    process.exit(1);
});
