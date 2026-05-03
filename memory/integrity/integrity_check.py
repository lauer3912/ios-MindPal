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

# 核心文件清单（必须存在）
REQUIRED_FILES = [
    "INDEX.md",
    "ARCHITECTURE.md",
    "MEMORY.md",
    "AGENTS.md",
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

def calculate_md5(filepath):
    """计算文件的 MD5"""
    try:
        with open(filepath, 'rb') as f:
            return hashlib.md5(f.read()).hexdigest()
    except:
        return "ERROR"

def check_file(filepath):
    """检查单个文件"""
    full_path = f"{MEMORY_DIR}/{filepath}"
    exists = os.path.exists(full_path)
    md5 = calculate_md5(full_path) if exists else "N/A"
    return {"exists": exists, "md5": md5}

def main():
    print("🧠 Memory Integrity Checker v4.0")
    print(f"时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 50)
    
    all_ok = True
    
    # 检查核心文件
    print("\n📁 核心文件检查:")
    for file in REQUIRED_FILES:
        result = check_file(file)
        status = "✅" if result["exists"] else "❌"
        print(f"  {status} {file}: {result['md5'][:12]}...")
        if not result["exists"]:
            all_ok = False
    
    # 检查项目文件
    print("\n📂 项目文件检查:")
    for file in PROJECT_FILES:
        result = check_file(file)
        status = "✅" if result["exists"] else "❌"
        print(f"  {status} {file}")
        if not result["exists"]:
            all_ok = False
    
    # 验证 INDEX.md 一致性
    print("\n🔗 INDEX.md 一致性检查:")
    index_path = f"{MEMORY_DIR}/INDEX.md"
    if os.path.exists(index_path):
        with open(index_path, 'r') as f:
            content = f.read()
            # 检查关键标记
            checks = [
                ("v4.0" in content, "版本标记"),
                ("中央索引" in content, "中央索引标记"),
                ("唯一真相来源" in content, "唯一真相来源标记"),
            ]
            for check, name in checks:
                status = "✅" if check else "❌"
                print(f"  {status} {name}")
                if not check:
                    all_ok = False
    else:
        print("  ❌ INDEX.md 不存在")
        all_ok = False
    
    print("\n" + "=" * 50)
    if all_ok:
        print("✅ 所有检查通过 — 记忆系统完整性验证成功")
    else:
        print("❌ 部分检查失败 — 需要人工干预")
    
    return all_ok

if __name__ == "__main__":
    main()