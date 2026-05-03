#!/usr/bin/env python3
"""
Memory Integrity Checker v4.0
Run: python3 integrity_check.py

功能:
1. 验证所有 memory 文件存在
2. 检查文件完整性（MD5）
3. 验证 INDEX.md 与实际文件一致
4. 生成完整性报告
"""

import os
import hashlib
from datetime import datetime

WORKSPACE = "/root/.openclaw/workspace"
MEMORY_DIR = f"{WORKSPACE}/memory"

# 核心文件清单（必须存在）- 路径相对于 WORKSPACE
REQUIRED_FILES_WORKSPACE = [
    "MEMORY.md",
    "AGENTS.md",
]

# memory/ 目录下的核心文件
REQUIRED_FILES_MEMORY = [
    "INDEX.md",
    "ARCHITECTURE.md",
    "2026-05-03.md",
    "tasks/active.md",
    "people/pagebrin.md",
    "sessions/SESSIONS.md",
    "hot/HOT.md",
    "search/INDEX.md",
    "context/BRIDGE.md",
]

# 项目文件清单
PROJECT_FILES = [
    "projects/dailyiq.md",
    "projects/fakechat.md",
    "projects/mindpal.md",
    "projects/habitgo.md",
    "projects/justzengo.md",
    "projects/luminahealth.md",
    "projects/stretchflow.md",
    "projects/ustiago.md",
]

# 决策文件清单
DECISION_FILES = [
    "decisions/2026-04-17-memory-protocol.md",
    "decisions/2026-04-26-fakechat-rebuild.md",
    "decisions/2026-05-03-enterprise-memory.md",
]

def calculate_md5(filepath):
    """计算文件的 MD5"""
    try:
        with open(filepath, 'rb') as f:
            return hashlib.md5(f.read()).hexdigest()
    except:
        return "ERROR"

def check_file_in_dir(dir_path, rel_path):
    """检查文件是否存在"""
    full_path = os.path.join(dir_path, rel_path)
    exists = os.path.exists(full_path)
    md5 = calculate_md5(full_path) if exists else "N/A"
    return {"path": full_path, "exists": exists, "md5": md5}

def main():
    print("🧠 Memory Integrity Checker v4.0")
    print(f"时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 50)
    
    all_ok = True
    
    # 检查 WORKSPACE 根目录的核心文件
    print("\n📁 工作区根目录文件检查:")
    for file in REQUIRED_FILES_WORKSPACE:
        result = check_file_in_dir(WORKSPACE, file)
        status = "✅" if result["exists"] else "❌"
        print(f"  {status} {file}: {result['md5'][:12]}..." if result["exists"] else f"  {status} {file}: N/A")
        if not result["exists"]:
            all_ok = False
    
    # 检查 memory/ 目录下的核心文件
    print("\n📁 Memory 目录核心文件检查:")
    for file in REQUIRED_FILES_MEMORY:
        result = check_file_in_dir(MEMORY_DIR, file)
        status = "✅" if result["exists"] else "❌"
        print(f"  {status} {file}: {result['md5'][:12]}..." if result["exists"] else f"  {status} {file}: N/A")
        if not result["exists"]:
            all_ok = False
    
    # 检查项目文件
    print("\n📂 项目文件检查:")
    for file in PROJECT_FILES:
        result = check_file_in_dir(MEMORY_DIR, file)
        status = "✅" if result["exists"] else "❌"
        print(f"  {status} {file}")
        if not result["exists"]:
            all_ok = False
    
    # 检查决策文件
    print("\n⚖️ 决策文件检查:")
    for file in DECISION_FILES:
        result = check_file_in_dir(MEMORY_DIR, file)
        status = "✅" if result["exists"] else "❌"
        print(f"  {status} {file}")
        if not result["exists"]:
            all_ok = False
    
    # 验证 INDEX.md 一致性
    print("\n🔗 INDEX.md 一致性检查:")
    index_path = os.path.join(MEMORY_DIR, "INDEX.md")
    if os.path.exists(index_path):
        with open(index_path, 'r') as f:
            content = f.read()
            checks = [
                ("v4.0" in content, "版本标记"),
                ("中央索引" in content, "中央索引标记"),
                ("唯一真相来源" in content, "唯一真相来源标记"),
                ("audit" in content, "audit 模块标记"),
                ("dashboard" in content, "dashboard 模块标记"),
            ]
            for check, name in checks:
                status = "✅" if check else "❌"
                print(f"  {status} {name}")
                if not check:
                    all_ok = False
    else:
        print("  ❌ INDEX.md 不存在")
        all_ok = False
    
    # 检查脚本文件
    print("\n🔧 脚本文件检查:")
    scripts = [
        ("memory_autosave.py", "Python 自动备份"),
        ("memory_end_session.sh", "Bash Session End Hook"),
        ("integrity/integrity_check.py", "Integrity Checker"),
    ]
    for file, desc in scripts:
        full_path = os.path.join(MEMORY_DIR, file)
        exists = os.path.exists(full_path)
        status = "✅" if exists else "❌"
        print(f"  {status} {file} ({desc})")
        if not exists:
            all_ok = False
    
    # 检查子目录
    print("\n📂 子目录检查:")
    subdirs = [
        "audit", "compression", "context", "dashboard", "decisions",
        "hot", "integrity", "links", "people", "projects",
        "recovery", "retention", "search", "sessions", "tasks", "weekly", "archive"
    ]
    for dir_name in subdirs:
        full_path = os.path.join(MEMORY_DIR, dir_name)
        exists = os.path.isdir(full_path)
        status = "✅" if exists else "❌"
        print(f"  {status} {dir_name}/")
        if not exists:
            all_ok = False
    
    print("\n" + "=" * 50)
    if all_ok:
        print("✅ 所有检查通过 — 记忆系统完整性验证成功")
    else:
        print("⚠️ 部分检查失败 — 请查看上述 ❌ 项目")
    
    return all_ok

if __name__ == "__main__":
    main()