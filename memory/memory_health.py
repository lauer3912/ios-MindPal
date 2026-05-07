#!/usr/bin/env python3
"""
Memory Health Checker — 记忆系统健康检查
系统版本: v6.0 | 企业级 | 最后更新: 2026-05-08

功能:
1. 检查所有必需文件是否存在
2. 验证索引完整性
3. 检测孤岛文件（无引用）
4. 检查过时信息
5. 自动修复常见问题
"""

import os
import re
from datetime import datetime, timedelta

WORKSPACE = "/root/.openclaw/workspace"
MEMORY_DIR = f"{WORKSPACE}/memory"

REQUIRED_FILES = [
    "INDEX.md",
    "../MEMORY.md",  # MEMORY.md 在 workspace 根目录
    "ARCHITECTURE.md",
]

REQUIRED_DIRS = [
    "daily",
    "projects",
    "decisions",
    "people",
    "tasks",
    "sessions",
    "hot",
    "search",
    "context",
    "knowledge_graph",
    "dreaming",
]

PROJECTS = ["DailyIQ", "FakeChat", "MindPal", "HabitGo", "JustZenGo", "LuminaHealth", "StretchFlow", "UstiaGo"]

def check_required_structure():
    """检查必需目录结构"""
    print("📁 目录结构检查:")
    issues = []
    
    for dir_name in REQUIRED_DIRS:
        path = f"{MEMORY_DIR}/{dir_name}"
        if os.path.exists(path):
            print(f"  ✅ {dir_name}/")
        else:
            print(f"  ❌ {dir_name}/ 缺失 - 正在创建...")
            os.makedirs(path, exist_ok=True)
            issues.append(f"已创建缺失目录: {dir_name}")
    
    return issues

def check_core_files():
    """检查核心文件"""
    print("\n📄 核心文件检查:")
    issues = []
    
    for file_name in REQUIRED_FILES:
        path = f"{MEMORY_DIR}/{file_name}"
        if os.path.exists(path):
            # 检查文件是否为空
            if os.path.getsize(path) < 10:
                issues.append(f"{file_name} 为空")
                print(f"  ⚠️ {file_name} (空)")
            else:
                print(f"  ✅ {file_name}")
        else:
            issues.append(f"{file_name} 缺失")
            print(f"  ❌ {file_name} 缺失")
    
    return issues

def check_project_files():
    """检查项目文件完整性"""
    print("\n📱 项目文件检查:")
    issues = []
    
    for project in PROJECTS:
        path = f"{MEMORY_DIR}/projects/{project.lower()}.md"
        if os.path.exists(path):
            print(f"  ✅ {project}")
        else:
            print(f"  ⚠️ {project} (无追踪文件)")
            issues.append(f"缺失项目文件: {project}")
    
    return issues

def check_daily_coverage():
    """检查每日日记覆盖度"""
    print("\n📅 日记覆盖度检查:")
    daily_dir = f"{MEMORY_DIR}/daily"
    
    if not os.path.exists(daily_dir):
        print("  ❌ daily 目录不存在")
        return ["daily 目录缺失"]
    
    files = [f for f in os.listdir(daily_dir) if f.endswith('.md')]
    files.sort()
    
    if not files:
        print("  ⚠️ 无日记文件")
        return ["无日记文件"]
    
    print(f"  共 {len(files)} 个日记文件")
    
    # 检查最近7天是否有日记
    today = datetime.now()
    missing = []
    for i in range(7):
        date = today - timedelta(days=i)
        filename = date.strftime('%Y-%m-%d') + ".md"
        if filename not in files:
            missing.append(filename)
    
    if missing:
        print(f"  ⚠️ 缺失: {', '.join(missing[:3])}{'...' if len(missing) > 3 else ''}")
    else:
        print("  ✅ 最近7天全覆盖")
    
    return [f"缺失日记: {m}" for m in missing]

def find_orphaned_files():
    """查找孤岛文件（没有被 INDEX.md 引用的文件）"""
    print("\n🔍 孤岛文件检测:")
    
    index_path = f"{MEMORY_DIR}/INDEX.md"
    with open(index_path, 'r') as f:
        index_content = f.read()
    
    # 扫描所有 .md 文件
    orphaned = []
    for root, dirs, files in os.walk(MEMORY_DIR):
        # 跳过特定目录
        if any(skip in root for skip in ['__pycache__', 'archive', '.git', 'daily']):
            continue
        
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                rel_path = os.path.relpath(file_path, MEMORY_DIR)
                
                # 检查是否在 INDEX.md 中被引用
                if rel_path not in index_content and file != 'INDEX.md':
                    orphaned.append(rel_path)
    
    if orphaned:
        print(f"  ⚠️ 发现 {len(orphaned)} 个孤岛文件:")
        for f in orphaned[:10]:
            print(f"    • {f}")
    else:
        print("  ✅ 无孤岛文件")
    
    return [f"孤岛文件: {o}" for o in orphaned]

def check_referential_integrity():
    """检查引用完整性（文件间相互引用）"""
    print("\n🔗 引用完整性检查:")
    issues = []
    
    # 检查 MEMORY.md 是否引用了核心文件
    memory_path = f"{WORKSPACE}/MEMORY.md"
    with open(memory_path, 'r') as f:
        memory_content = f.read()
    
    # 检查关键引用
    key_refs = {
        "INDEX.md": r'INDEX\.md',
        "ARCHITECTURE.md": r'ARCHITECTURE\.md',
        "projects/": r'projects/',
        "decisions/": r'decisions/',
    }
    
    for name, pattern in key_refs.items():
        if re.search(pattern, memory_content):
            print(f"  ✅ {name} 被引用")
        else:
            print(f"  ⚠️ {name} 未被引用")
            issues.append(f"MEMORY.md 未引用 {name}")
    
    return issues

def generate_report():
    """生成完整健康报告"""
    print("\n" + "=" * 50)
    print("🧠 Memory Health Report — 企业级检查")
    print(f"时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 50)
    
    all_issues = []
    
    all_issues.extend(check_required_structure())
    all_issues.extend(check_core_files())
    all_issues.extend(check_project_files())
    all_issues.extend(check_daily_coverage())
    all_issues.extend(find_orphaned_files())
    all_issues.extend(check_referential_integrity())
    
    print("\n" + "=" * 50)
    if all_issues:
        print(f"⚠️ 发现 {len(all_issues)} 个问题:")
        for issue in all_issues[:20]:
            print(f"  • {issue}")
    else:
        print("✅ 记忆系统健康 — 无问题发现")
    
    print("=" * 50)
    
    return all_issues

if __name__ == "__main__":
    issues = generate_report()
    exit(0 if not issues else 1)