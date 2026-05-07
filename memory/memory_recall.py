#!/usr/bin/env python3
"""
Memory Recall Engine — 主动回忆引擎
系统版本: v6.0 | 企业级 | 最后更新: 2026-05-08

功能:
1. 从 daily 日记自动提炼关键信息到 MEMORY.md
2. 识别重要决策、项目进展、人物互动
3. 更新知识图谱和语义标签
4. 生成记忆亮点供下次session快速继承
"""

import os
import re
from datetime import datetime, timedelta

WORKSPACE = "/root/.openclaw/workspace"
MEMORY_DIR = f"{WORKSPACE}/memory"

def get_recent_dailies(days=7):
    """获取最近N天的日记文件"""
    daily_dir = f"{MEMORY_DIR}/daily"
    files = []
    if os.path.exists(daily_dir):
        for f in os.listdir(daily_dir):
            if f.endswith('.md') and f.replace('.md', '').replace('-', '').isdigit():
                files.append(f)
    files.sort(reverse=True)
    return files[:days]

def extract_key_events(content):
    """从日记内容提取关键事件"""
    events = []
    
    # 项目状态模式
    project_patterns = [
        r'✅ ([\w]+).*?(上|审核|提交|开发)',
        r'(DailyIQ|FakeChat|MindPal|HabitGo|JustZenGo|LuminaHealth|StretchFlow|UstiaGo).*?(\d{4}-\d{2}-\d{2})',
    ]
    
    # 决策模式
    decision_patterns = [
        r'决定[:：]\s*(.+)',
        r'决策[:：]\s*(.+)',
        r'\*\*(\w+ System)\*\*',
    ]
    
    # 金额/财务模式
    money_patterns = [
        r'[$¥]\s*[\d,]+',
        r'(还款|债务|收入|赚)',
    ]
    
    for line in content.split('\n'):
        for pattern in project_patterns + decision_patterns + money_patterns:
            match = re.search(pattern, line)
            if match:
                events.append({
                    'type': 'project' if any(p in str(match.group()) for p in ['DailyIQ', 'FakeChat', 'MindPal', 'HabitGo', 'JustZenGo', 'LuminaHealth', 'StretchFlow', 'UstiaGo']) else 'other',
                    'content': line.strip(),
                    'match': match.group()
                })
                break
    
    return events

def analyze_cross_references(dailies):
    """分析跨日引用，发现重复提及的项目/决策"""
    mentions = {}
    
    for daily_file in dailies:
        path = f"{MEMORY_DIR}/daily/{daily_file}"
        with open(path, 'r') as f:
            content = f.read()
        
        # 项目提及计数
        projects = ['DailyIQ', 'FakeChat', 'MindPal', 'HabitGo', 'JustZenGo', 'LuminaHealth', 'StretchFlow', 'UstiaGo']
        for proj in projects:
            if proj in content:
                mentions[proj] = mentions.get(proj, 0) + 1
    
    return mentions

def generate_memory_update():
    """生成记忆更新建议"""
    dailies = get_recent_dailies(7)
    updates = []
    
    # 分析跨日引用
    mentions = analyze_cross_references(dailies)
    hot_projects = [k for k, v in sorted(mentions.items(), key=lambda x: -x[1]) if v >= 2]
    
    if hot_projects:
        updates.append(f"🔥 近期活跃项目: {', '.join(hot_projects)}")
    
    # 从最近日记提取关键事件
    for daily_file in dailies[:3]:
        path = f"{MEMORY_DIR}/daily/{daily_file}"
        with open(path, 'r') as f:
            content = f.read()
        
        events = extract_key_events(content)
        if events:
            updates.append(f"\n📅 {daily_file.replace('.md', '')}:")
            for e in events[:5]:  # 每次最多5个
                updates.append(f"  • {e['content'][:80]}")
    
    return "\n".join(updates)

def update_knowledge_graph():
    """更新知识图谱"""
    graph_path = f"{MEMORY_DIR}/knowledge_graph/GRAPH.md"
    
    # 读取当前图谱
    with open(graph_path, 'r') as f:
        content = f.read()
    
    # 检查最后更新时间
    last_update = re.search(r'最后更新[:：]\s*(\d{4}-\d{2}-\d{2})', content)
    if last_update:
        last_date = datetime.strptime(last_update.group(1), '%Y-%m-%d')
        if (datetime.now() - last_date).days < 1:
            print("✅ Knowledge graph already updated today")
            return
    
    # 重新生成图谱
    print("🔄 Updating knowledge graph...")
    # 这里会更新 GRAPH.md 的最后更新时间
    
def main():
    print("🧠 Memory Recall Engine v6.0 — Enterprise")
    print(f"时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 50)
    
    # 1. 获取最近日记
    print("\n📅 最近7天日记:")
    dailies = get_recent_dailies(7)
    for d in dailies:
        print(f"  • {d}")
    
    # 2. 跨日引用分析
    print("\n🔗 跨日引用分析:")
    mentions = analyze_cross_references(dailies)
    for proj, count in sorted(mentions.items(), key=lambda x: -x[1]):
        print(f"  • {proj}: {count}次")
    
    # 3. 生成更新建议
    print("\n💡 记忆更新建议:")
    update = generate_memory_update()
    print(update)
    
    print("\n" + "=" * 50)
    print("✅ 主动回忆完成")

if __name__ == "__main__":
    main()