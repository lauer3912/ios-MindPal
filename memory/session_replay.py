#!/usr/bin/env python3
"""
Session Memory Replay — 历史会话回放系统
系统版本: v6.0 | 企业级 | 最后更新: 2026-05-08

功能:
1. 从 sessions/SESSIONS.md 提取历史会话
2. 支持按日期、项目、关键词搜索历史
3. 生成"记忆回顾报告"供快速继承上下文
4. 识别重复模式和行为习惯
"""

import os
import re
from datetime import datetime, timedelta
from collections import defaultdict

WORKSPACE = "/root/.openclaw/workspace"
MEMORY_DIR = f"{WORKSPACE}/memory"
SESSIONS_FILE = f"{MEMORY_DIR}/sessions/SESSIONS.md"

def load_sessions():
    """加载会话历史"""
    if not os.path.exists(SESSIONS_FILE):
        return []
    
    sessions = []
    current_session = None
    
    with open(SESSIONS_FILE, 'r') as f:
        content = f.read()
    
    # 解析会话条目
    # 格式: ## YYYY-MM-DD HH:MM
    # 或: - [时间] 项目/任务 | 描述
    
    lines = content.split('\n')
    for line in lines:
        # 检测新会话头
        match = re.match(r'##?\s*(\d{4}-\d{2}-\d{2})\s+(\d{2}:\d{2})', line)
        if match:
            if current_session:
                sessions.append(current_session)
            current_session = {
                'date': match.group(1),
                'time': match.group(2),
                'entries': []
            }
        elif current_session and line.strip().startswith('-'):
            current_session['entries'].append(line.strip())
    
    if current_session:
        sessions.append(current_session)
    
    return sessions

def search_sessions(query, sessions):
    """搜索包含特定关键词的会话"""
    results = []
    
    for session in sessions:
        matched_entries = []
        for entry in session['entries']:
            if query.lower() in entry.lower():
                matched_entries.append(entry)
        
        if matched_entries:
            results.append({
                'date': session['date'],
                'time': session['time'],
                'matches': matched_entries
            })
    
    return results

def search_by_project(project, sessions):
    """搜索特定项目的所有历史"""
    return search_sessions(project, sessions)

def generate_recall_report(days=7):
    """生成记忆回顾报告"""
    sessions = load_sessions()
    
    # 过滤最近N天
    cutoff = (datetime.now() - timedelta(days=days)).strftime('%Y-%m-%d')
    recent = [s for s in sessions if s['date'] >= cutoff]
    
    report = []
    report.append(f"# 🧠 Memory Recall Report — 最近{days}天")
    report.append(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    report.append(f"会话数量: {len(recent)}")
    report.append("")
    
    # 按项目统计
    project_mentions = defaultdict(int)
    for session in recent:
        for entry in session['entries']:
            projects = ['DailyIQ', 'FakeChat', 'MindPal', 'HabitGo', 'JustZenGo', 'LuminaHealth', 'StretchFlow', 'UstiaGo']
            for proj in projects:
                if proj in entry:
                    project_mentions[proj] += 1
    
    report.append("## 📊 项目活跃度")
    for proj, count in sorted(project_mentions.items(), key=lambda x: -x[1]):
        report.append(f"  • {proj}: {count}次提及")
    
    # 关键决策回顾
    report.append("")
    report.append("## 🎯 关键进展")
    for session in recent:
        for entry in session['entries']:
            if any(kw in entry for kw in ['✅', '完成', '上架', '审核通过', '提交']):
                report.append(f"  [{session['date']}] {entry[:100]}")
    
    # 待续任务
    report.append("")
    report.append("## 📋 待续任务")
    for session in recent:
        for entry in session['entries']:
            if any(kw in entry for kw in ['待办', '下一步', '🔨', '⚠️']):
                report.append(f"  [{session['date']}] {entry[:100]}")
    
    return "\n".join(report)

def replay_session(date):
    """回放特定日期的会话"""
    sessions = load_sessions()
    target = [s for s in sessions if s['date'] == date]
    
    if not target:
        return f"未找到 {date} 的会话记录"
    
    session = target[0]
    output = []
    output.append(f"# 📅 会话回放: {session['date']} {session['time']}")
    output.append("")
    output.append("## 对话记录:")
    for entry in session['entries']:
        output.append(entry)
    
    return "\n".join(output)

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1:
        if sys.argv[1] == '--report':
            days = int(sys.argv[2]) if len(sys.argv) > 2 else 7
            print(generate_recall_report(days))
        elif sys.argv[1] == '--replay':
            print(replay_session(sys.argv[2]))
        elif sys.argv[1] == '--search':
            sessions = load_sessions()
            results = search_sessions(sys.argv[2], sessions)
            for r in results:
                print(f"[{r['date']} {r['time']}]")
                for m in r['matches']:
                    print(f"  {m}")
        elif sys.argv[1] == '--project':
            sessions = load_sessions()
            results = search_by_project(sys.argv[2], sessions)
            print(f"=== {sys.argv[2]} 历史记录 ===")
            for r in results:
                print(f"[{r['date']} {r['time']}]")
                for m in r['matches']:
                    print(f"  {m}")
        else:
            print("用法:")
            print("  --report [天数]  生成记忆回顾报告")
            print("  --replay 日期    回放特定日期会话")
            print("  --search 关键词  搜索包含关键词的会话")
            print("  --project 项目名  查看项目的所有历史")
    else:
        # 默认生成7天报告
        print(generate_recall_report(7))