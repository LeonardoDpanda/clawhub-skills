#!/usr/bin/env node
/**
 * 订单监听与自动处理脚本
 * 
 * 模拟接收闲鱼订单通知并自动触发选题生成
 * 
 * 使用方法：
 * node scripts/order-listener.js
 * 
 * 或定时运行：
 * crontab: */5 * * * * cd /workspace/projects/workspace && node scripts/order-listener.js
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// 配置
const CONFIG = {
    // 订单队列文件
    queueFile: './orders/queue.jsonl',
    // 已处理订单记录
    processedFile: './orders/processed.json',
    // 处理间隔（毫秒）
    interval: 5000,
};

// 确保目录存在
function ensureDir(dir) {
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
    }
}

// 获取已处理订单列表
function getProcessedOrders() {
    ensureDir(path.dirname(CONFIG.processedFile));
    if (!fs.existsSync(CONFIG.processedFile)) {
        return new Set();
    }
    try {
        const data = JSON.parse(fs.readFileSync(CONFIG.processedFile, 'utf8'));
        return new Set(data.processed || []);
    } catch {
        return new Set();
    }
}

// 记录已处理订单
function markOrderProcessed(orderId) {
    const processed = Array.from(getProcessedOrders());
    processed.push(orderId);
    fs.writeFileSync(CONFIG.processedFile, JSON.stringify({ processed }, null, 2), 'utf8');
}

// 获取待处理订单
function getPendingOrders() {
    ensureDir(path.dirname(CONFIG.queueFile));
    if (!fs.existsSync(CONFIG.queueFile)) {
        return [];
    }
    
    const content = fs.readFileSync(CONFIG.queueFile, 'utf8').trim();
    if (!content) return [];
    
    return content.split('\n')
        .map(line => {
            try {
                return JSON.parse(line);
            } catch {
                return null;
            }
        })
        .filter(Boolean);
}

// 清空队列
function clearQueue() {
    if (fs.existsSync(CONFIG.queueFile)) {
        fs.writeFileSync(CONFIG.queueFile, '', 'utf8');
    }
}

// 处理单个订单
function processOrder(order) {
    console.log(`\n🎯 正在处理订单: ${order.orderId}`);
    console.log(`   买家: ${order.buyerId}`);
    console.log(`   时间: ${order.timestamp}`);
    
    try {
        // 调用主智能体脚本
        const result = execSync(
            `node scripts/drama-topic-agent.js --order-id=${order.orderId} --buyer-id=${order.buyerId}`,
            {
                encoding: 'utf8',
                cwd: '/workspace/projects/workspace',
                timeout: 60000
            }
        );
        console.log(result);
        return { success: true };
    } catch (error) {
        console.error(`❌ 处理订单 ${order.orderId} 失败:`, error.message);
        return { success: false, error: error.message };
    }
}

// 模拟添加订单（用于测试）
function addMockOrder() {
    ensureDir(path.dirname(CONFIG.queueFile));
    
    const order = {
        orderId: `ORD_${Date.now()}`,
        buyerId: `BUYER_${Math.random().toString(36).substring(2, 8).toUpperCase()}`,
        timestamp: new Date().toISOString(),
        type: 'drama_topic',
        quantity: 3
    };
    
    fs.appendFileSync(CONFIG.queueFile, JSON.stringify(order) + '\n', 'utf8');
    console.log(`✅ 已添加测试订单: ${order.orderId}`);
    return order;
}

// 主循环
async function main() {
    const args = process.argv.slice(2);
    
    // 添加测试订单模式
    if (args.includes('--mock')) {
        const order = addMockOrder();
        console.log(`\n可以使用以下命令处理此订单：`);
        console.log(`node scripts/order-listener.js --process-once`);
        return;
    }
    
    // 单次处理模式
    if (args.includes('--process-once')) {
        console.log('========================================');
        console.log('   订单监听处理器（单次模式）');
        console.log('========================================\n');
        
        const orders = getPendingOrders();
        const processed = getProcessedOrders();
        
        console.log(`📋 发现 ${orders.length} 个订单`);
        console.log(`✅ 已处理 ${processed.size} 个订单\n`);
        
        let processedCount = 0;
        for (const order of orders) {
            if (processed.has(order.orderId)) {
                console.log(`⏭️  跳过已处理订单: ${order.orderId}`);
                continue;
            }
            
            const result = processOrder(order);
            if (result.success) {
                markOrderProcessed(order.orderId);
                processedCount++;
            }
        }
        
        // 清空已处理的队列
        clearQueue();
        
        console.log(`\n========================================`);
        console.log(`   处理完成！`);
        console.log(`   本次处理: ${processedCount} 个订单`);
        console.log(`========================================`);
        return;
    }
    
    // 持续监听模式
    console.log('========================================');
    console.log('   订单监听处理器（持续模式）');
    console.log('========================================');
    console.log('按 Ctrl+C 停止监听\n');
    
    const processed = getProcessedOrders();
    
    setInterval(() => {
        const orders = getPendingOrders();
        
        for (const order of orders) {
            if (processed.has(order.orderId)) {
                continue;
            }
            
            console.log(`\n[${new Date().toLocaleTimeString()}] 发现新订单!`);
            const result = processOrder(order);
            
            if (result.success) {
                processed.add(order.orderId);
                markOrderProcessed(order.orderId);
                
                // 从队列中移除
                const remaining = orders.filter(o => o.orderId !== order.orderId);
                fs.writeFileSync(
                    CONFIG.queueFile,
                    remaining.map(o => JSON.stringify(o)).join('\n') + (remaining.length > 0 ? '\n' : ''),
                    'utf8'
                );
            }
        }
    }, CONFIG.interval);
}

main().catch(console.error);
