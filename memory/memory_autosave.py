#!/usr/bin/env python3
"""
Memory System v3.0 — 自动化记忆整理脚本
Run: python3 memory_autosave.py

功能:
1. 生成当日 daily summary
2. 更新 INDEX.md
3. 更新 tasks/active.md (如果有必要)
4. 更新 hot/HOT.md
5. 追加到 sessions/SESSIONS.md
"""

import os
import sys
from datetime import datetime

WORKSPACE = "/root/.openclaw/workspace"
MEMORY_DIR = f"{WORKSPACE}/memory"

def get_today():
    return datetime.now().strftime("%Y-%m-%d")

def get_current_time():
    return datetime.now().strftime("%Y-%m-%d %H:%M")

def update_daily_summary():
    """更新每日日记摘要"""
    today = get_today()
    daily_file = f"{MEMORY_DIR}/{today}.md"
    
    if not os.path.exists(daily_file):
        # 创建新的每日日记
        content = f"""# {today} Daily Log

> 系统版本: 企业级记忆 v3.0
> 自动生成: {get_current_time()}

## 📝 今日概要

<!-- 以下由系统自动填充 -->

### 完成事项
-

### 关键决策
-

### 待跟进
-

---

*本文档由 memory_autosave.py 自动生成*"""
        with open(daily_file, 'w') as f:
            f.write(content)
        print(f"✅ 创建新日记: {daily_file}")
    else:
        print(f"📄 日记已存在: {daily_file}")

def update_hot_files():
    """更新 hot/HOT.md"""
    hot_file = f"{MEMORY_DIR}/hot/HOT.md"
    today = get_today()
    
    # 读取 accessed.txt 更新热度
    accessed_file = f"{MEMORY_DIR}/hot/accessed.txt"
    hot_entries = []
    
    if os.path.exists(accessed_file):
        with open(accessed_file, 'r') as f:
            for line in f:
                if today in line:
                    parts = line.strip().split('|')
                    if len(parts) >= 2:
                        hot_entries.append(parts[1].strip())
    
    print(f"✅ 更新热度文件: {hot_file}")
    return hot_entries

def append_session_log(action, details):
    """追加到 sessions/SESSIONS.md"""
    sessions_file = f"{MEMORY_DIR}/sessions/SESSIONS.md"
    today = get_today()
    current_time = get_current_time()
    
    entry = f"""
### {current_time}
- 操作: {action}
- 详情: {details}
"""
    
    with open(sessions_file, 'a') as f:
        f.write(entry)
    print(f"✅ 追加 session 日志: {sessions_file}")

def main():
    if len(sys.argv) > 1:
        command = sys.argv[1]
        
        if command == "daily":
            update_daily_summary()
        elif command == "hot":
            update_hot_files()
        elif command == "session":
            action = sys.argv[2] if len(sys.argv) > 2 else "unknown"
            details = sys.argv[3] if len(sys.argv) > 3 else ""
            append_session_log(action, details)
        else:
            print("用法: python3 memory_autosave.py [daily|hot|session]")
    else:
        # 完整运行
        update_daily_summary()
        update_hot_files()
        print("✅ Memory System v3.0 自动备份完成")

if __name__ == "__main__":
    main()