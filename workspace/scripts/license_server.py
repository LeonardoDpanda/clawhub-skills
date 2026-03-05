#!/usr/bin/env python3
"""
授权验证服务 - 简化版
部署到: Vercel / Railway / 云服务器
"""

from flask import Flask, request, jsonify
import hashlib
import time
import json
from functools import wraps

app = Flask(__name__)

# 模拟数据库（生产环境用 Redis/MySQL）
licenses_db = {}
payments_db = {}

# ============ 授权码生成与管理 ============

def generate_license_key(order_id):
    """生成16位授权码"""
    timestamp = str(time.time())
    raw = f"{order_id}{timestamp}SECRET_KEY"
    key = hashlib.sha256(raw.encode()).hexdigest()[:16].upper()
    return key

def create_license(plan="pro", duration_days=30):
    """创建新授权"""
    license_key = generate_license_key(str(time.time()))
    
    license_data = {
        "key": license_key,
        "plan": plan,  # free/pro/enterprise
        "created_at": time.time(),
        "expires_at": time.time() + (duration_days * 86400),
        "activations": [],
        "max_activations": 3 if plan == "pro" else 999,
        "status": "active"
    }
    
    licenses_db[license_key] = license_data
    return license_key

# ============ API 端点 ============

@app.route('/api/verify', methods=['POST'])
def verify_license():
    """验证授权码"""
    data = request.json
    license_key = data.get('license_key', '').upper().strip()
    device_id = data.get('device_id', 'unknown')
    
    if not license_key or license_key not in licenses_db:
        return jsonify({
            "valid": False,
            "error": "授权码无效"
        }), 403
    
    license_data = licenses_db[license_key]
    
    # 检查是否过期
    if time.time() > license_data['expires_at']:
        return jsonify({
            "valid": False,
            "error": "授权已过期",
            "expired_at": license_data['expires_at']
        }), 403
    
    # 检查设备激活数量
    if device_id not in license_data['activations']:
        if len(license_data['activations']) >= license_data['max_activations']:
            return jsonify({
                "valid": False,
                "error": f"授权码已达到最大激活数 ({license_data['max_activations']})"
            }), 403
        license_data['activations'].append(device_id)
    
    return jsonify({
        "valid": True,
        "plan": license_data['plan'],
        "expires_at": license_data['expires_at'],
        "days_left": int((license_data['expires_at'] - time.time()) / 86400)
    })

@app.route('/api/purchase', methods=['POST'])
def create_purchase():
    """创建购买订单"""
    data = request.json
    plan = data.get('plan', 'pro')
    email = data.get('email')
    
    # 生成授权码
    if plan == 'pro':
        license_key = create_license('pro', 30)
        price = 29
    elif plan == 'pro-yearly':
        license_key = create_license('pro', 365)
        price = 199
    else:
        license_key = create_license('enterprise', 365)
        price = 999
    
    order_id = f"ORD{int(time.time())}"
    
    payments_db[order_id] = {
        "order_id": order_id,
        "license_key": license_key,
        "plan": plan,
        "price": price,
        "email": email,
        "status": "pending",
        "created_at": time.time()
    }
    
    return jsonify({
        "order_id": order_id,
        "license_key": license_key,
        "price": price,
        "payment_url": f"https://your-payment-page.com/pay?order={order_id}"
    })

@app.route('/api/webhook/payment', methods=['POST'])
def payment_webhook():
    """支付平台回调（Gumroad/Stripe/微信）"""
    data = request.json
    order_id = data.get('order_id')
    payment_status = data.get('status')
    
    if order_id in payments_db and payment_status == 'completed':
        payments_db[order_id]['status'] = 'completed'
        license_key = payments_db[order_id]['license_key']
        
        # 发送授权码邮件
        send_license_email(
            payments_db[order_id]['email'],
            license_key,
            payments_db[order_id]['plan']
        )
        
        return jsonify({"success": True})
    
    return jsonify({"success": False}), 400

def send_license_email(email, license_key, plan):
    """发送授权码邮件"""
    # 集成 SendGrid / AWS SES / 邮件服务
    print(f"[EMAIL] Sending license {license_key} to {email}")
    # TODO: 实现邮件发送

# ============ 管理接口 ============

@app.route('/api/stats', methods=['GET'])
def get_stats():
    """获取统计"""
    total_licenses = len(licenses_db)
    active_licenses = sum(1 for l in licenses_db.values() if l['status'] == 'active')
    total_revenue = sum(p['price'] for p in payments_db.values() if p['status'] == 'completed')
    
    return jsonify({
        "total_licenses": total_licenses,
        "active_licenses": active_licenses,
        "total_revenue": total_revenue,
        "pending_orders": sum(1 for p in payments_db.values() if p['status'] == 'pending')
    })

if __name__ == '__main__':
    app.run(debug=True, port=5000)
