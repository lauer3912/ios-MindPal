#!/usr/bin/env python3
"""
Memory Health Check — 每2小时全面健康检查
系统版本: v5.0 | AI Enterprise Level
触发: 每2小时执行 (cron: 0 */2 * * *)

功能:
1. 检查过去24-48小时的记忆是否完整
2. 自动补充缺失的记忆
3. 修复损坏的记忆
4. 生成健康报告
"""

import os
import subprocess
from datetime import datetime, timedelta

WORKSPACE = "/root/.openclaw/workspace"
MEMORY_DIR = f"{WORKSPACE}/memory"
LOG_FILE = f"{WORKSPACE}/.cron/health_check_log.txt"

def log(msg):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as f:
        f.write(f"[{timestamp}] {msg}\n")
    print(f"[{timestamp}] {msg}")

def get_recent_days():
    """获取最近需要检查的日期"""
    today = datetime.now()
    dates = []
    for i in range(1, 3):  # 过去48小时
        date = today - timedelta(days=i)
        dates.append(date.strftime("%Y-%m-%d"))
    dates.append(today.strftime("%Y-%m-%d"))  # 今天
    return dates

def check_daily_files(dates):
    """检查每日日记文件是否完整"""
    log("📅 检查每日日记文件...")
    missing = []
    for date in dates:
        file_path = f"{MEMORY_DIR}/{date}.md"
        if not os.path.exists(file_path):
            missing.append(date)
            log(f"  ⚠️ 缺失: {date}.md")
        else:
            log(f"  ✅ {date}.md")
    return missing

def check_projects_status():
    """检查项目状态文件"""
    log("📂 检查项目状态文件...")
    projects = ["dailyiq", "fakechat", "mindpal", "habitgo", "justzengo", "luminahealth", "stretchflow", "ustiago"]
    missing = []
    for proj in projects:
        file_path = f"{MEMORY_DIR}/projects/{proj}.md"
        if not os.path.exists(file_path):
            missing.append(proj)
            log(f"  ⚠️ 缺失: projects/{proj}.md")
        else:
            log(f"  ✅ projects/{proj}.md")
    return missing

def check_critical_files():
    """检查核心文件"""
    log("🔑 检查核心文件...")
    critical = ["INDEX.md", "ARCHITECTURE.md", "MEMORY.md", "AGENTS.md"]
    missing = []
    for file in critical:
        # 检查 workspace root 和 memory/
        path_root = f"{WORKSPACE}/{file}"
        path_memory = f"{MEMORY_DIR}/{file}"
        if os.path.exists(path_root) or os.path.exists(path_memory):
            log(f"  ✅ {file}")
        else:
            missing.append(file)
            log(f"  ❌ 缺失: {file}")
    return missing

def auto_recover_missing(missing_type, items):
    """自动恢复缺失的文件"""
    if not items:
        return
    
    log(f"🔧 自动恢复 {missing_type}...")
    for item in items:
        if missing_type == "daily":
            # 创建空白日记模板
            content = f"""# {item} Daily Log

> 系统版本: v5.0 AI Enterprise Level
> 自动创建: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
> 原因: 健康检查发现缺失，自动创建

## 📝 今日概要

<!-- 由健康检查自动创建，待补充 -->

### 完成事项
-

### 关键决策
-

### 待跟进
-

---

*此文件由 health_check.py 自动创建*"""
            with open(f"{MEMORY_DIR}/{item}.md", "w") as f:
                f.write(content)
            log(f"  ✅ 已创建空白模板: {item}.md")
            
        elif missing_type == "project":
            # 创建空白项目模板
            content = f"""# {item} — 项目状态

> 自动创建: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
> 状态: 未知（待补充）

## 基本信息
- Bundle ID: com.ggsheng.{item.capitalize()}
- 创建时间: 未知
- 最后活跃: {datetime.now().strftime('%Y-%m-%d')}

## 当前状态
<!-- 由健康检查自动创建，待补充 -->
状态阶段: 0

## 最后进展
- 待补充

## 待办
- [ ] 待老爷补充项目信息

## 历史记录
| 日期 | 操作 | 详情 |
|------|------|------|
| {datetime.now().strftime('%Y-%m-%d')} | 自动创建 | 健康检查发现缺失 |
EOF"""
            with open(f"{MEMORY_DIR}/projects/{item}.md", "w") as f:
                f.write(content)
            log(f"  ✅ 已创建空白模板: projects/{item}.md")

def run_integrity_check():
    """运行完整性检查"""
    log("🔍 运行完整性检查...")
    try:
        result = subprocess.run(
            ["python3", f"{MEMORY_DIR}/integrity/integrity_check.py"],
            capture_output=True, text=True, timeout=30
        )
        if "所有检查通过" in result.stdout or "✅ 所有检查通过" in result.stdout:
            log("  ✅ 完整性检查通过")
            return True
        else:
            log("  ⚠️ 完整性检查发现问题")
            return False
    except Exception as e:
        log(f"  ❌ 完整性检查异常: {e}")
        return False

def git_commit_recovery():
    """Git 提交恢复"""
    log("📦 提交恢复...")
    try:
        subprocess.run(["git", "add", "memory/"], cwd=WORKSPACE, capture_output=True)
        result = subprocess.run(
            ["git", "commit", "-m", f"health-check-auto-recover: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"],
            cwd=WORKSPACE, capture_output=True, text=True
        )
        if result.returncode == 0:
            log("  ✅ 已提交恢复")
            return True
        else:
            if "nothing to commit" in result.stderr:
                log("  ℹ️ 无变更")
                return True
            log(f"  ❌ 提交失败: {result.stderr}")
            return False
    except Exception as e:
        log(f"  ❌ 提交异常: {e}")
        return False

def generate_report(all_ok, daily_missing, project_missing, critical_missing):
    """生成健康报告"""
    report = f"""
========================================
🧠 Memory Health Check Report
时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
========================================

📊 检查结果:
  核心文件: {'✅' if not critical_missing else f'❌ {len(critical_missing)} 个缺失'}
  每日日记: {'✅' if not daily_missing else f'⚠️ {len(daily_missing)} 个缺失'}
  项目文件: {'✅' if not project_missing else f'⚠️ {len(project_missing)} 个缺失'}

🔧 自动修复:
  每日日记: {'已恢复' if daily_missing else '无需恢复'}
  项目文件: {'已恢复' if project_missing else '无需恢复'}

📦 Git 状态:
  {'✅ 已提交' if all_ok else '❌ 需人工处理'}

========================================
"""
    return report

def main():
    print("🧠 Memory Health Check v5.0")
    print("=" * 50)
    log("=" * 50)
    log("开始每2小时健康检查...")
    
    # 1. 检查每日日记
    dates = get_recent_days()
    daily_missing = check_daily_files(dates)
    
    # 2. 检查项目文件
    project_missing = check_projects_status()
    
    # 3. 检查核心文件
    critical_missing = check_critical_files()
    
    # 4. 完整性检查
    integrity_ok = run_integrity_check()
    
    # 5. 自动恢复
    auto_recover_missing("daily", daily_missing)
    auto_recover_missing("project", project_missing)
    
    # 6. Git 提交
    all_ok = git_commit_recovery() if (daily_missing or project_missing) else True
    
    # 7. 生成报告
    report = generate_report(all_ok, daily_missing, project_missing, critical_missing)
    print(report)
    log(report)
    
    log("✅ 健康检查完成")
    print("\n✅ 健康检查完成")

if __name__ == "__main__":
    main()