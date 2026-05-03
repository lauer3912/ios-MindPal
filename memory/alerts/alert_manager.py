#!/usr/bin/env python3
"""
Alert Manager — 主动提醒管理器
系统版本: v5.0 | AI Enterprise Level

功能:
1. 检查所有提醒条件
2. 生成提醒报告
3. 发送通知到飞书（通过 message tool）
"""

import os
from datetime import datetime

WORKSPACE = "/root/.openclaw/workspace"
MEMORY_DIR = f"{WORKSPACE}/memory"

# 提醒规则
ALERT_RULES = [
    {
        "name": "DailyIQ 上架提醒",
        "condition": lambda: os.path.exists(f"{MEMORY_DIR}/projects/dailyiq.md"),
        "priority": "🔴 P0",
        "message": "DailyIQ 已上架审核通过，待 VNC 截图上传 App Store Connect",
    },
    {
        "name": "记忆补全提醒",
        "condition": lambda: True,  # 始终检查
        "priority": "🔴 P0",
        "message": "请补充 2026-04-29 ~ 2026-05-02 的历史记忆",
    },
    {
        "name": "FakeChat 开发进度",
        "condition": lambda: True,
        "priority": "🟠 P1",
        "message": "FakeChat/MindPal/UstiaGo 待 VNC 截图 → Archive → 上传",
    },
    {
        "name": "LuminaHealth/StretchFlow 测试",
        "condition": lambda: True,
        "priority": "🟠 P1",
        "message": "LuminaHealth/StretchFlow 待 BUILD 测试",
    },
]

def check_alerts():
    """检查所有提醒条件"""
    active_alerts = []
    for rule in ALERT_RULES:
        try:
            if rule["condition"]():
                active_alerts.append({
                    "name": rule["name"],
                    "priority": rule["priority"],
                    "message": rule["message"],
                    "time": datetime.now().strftime("%Y-%m-%d %H:%M")
                })
        except:
            pass
    return active_alerts

def generate_report(alerts):
    """生成提醒报告"""
    if not alerts:
        return "✅ 无活跃提醒"
    
    report = "🧠 Memory System v5.0 — 活跃提醒\n"
    report += "=" * 40 + "\n\n"
    
    for i, alert in enumerate(alerts, 1):
        report += f"{alert['priority']} {alert['name']}\n"
        report += f"   时间: {alert['time']}\n"
        report += f"   消息: {alert['message']}\n\n"
    
    return report

def main():
    print("🔔 Alert Manager v5.0")
    print(f"时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 50)
    
    alerts = check_alerts()
    report = generate_report(alerts)
    
    print(report)
    
    # 如果有 P0 提醒，打印警告
    p0_alerts = [a for a in alerts if "P0" in a["priority"]]
    if p0_alerts:
        print(f"\n⚠️ 有 {len(p0_alerts)} 个 P0 紧急提醒需要处理!")
    
    return alerts

if __name__ == "__main__":
    main()