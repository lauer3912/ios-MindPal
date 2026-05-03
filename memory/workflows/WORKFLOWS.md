# Workflows — 自动化工作流

> 系统版本: v5.0 | AI Enterprise Level | 最后更新: 2026-05-03

---

## 🎯 功能说明

自动化工作流在特定条件下自动执行预定义动作，实现：
- 条件触发 Actions
- 记忆驱动自动化
- 减少人工干预

---

## 🔄 工作流类型

### 1. 记忆更新工作流
```
触发条件: session 结束
动作序列:
  1. 执行 memory_end_session.sh
  2. 更新 sessions/SESSIONS.md
  3. 更新 hot/accessed.txt
  4. 检查今日任务完成度
  5. 如有 P0 任务完成，发送提醒
```

### 2. 项目状态变更工作流
```
触发条件: 项目状态变化（如 "开发中" → "已提交"）
动作序列:
  1. 更新 projects/<project>.md
  2. 更新 INDEX.md 项目列表
  3. 添加语义标签
  4. 发送提醒到老爷
  5. 更新 decisions/ 如有重大变更
```

### 3. 完整性检查工作流
```
触发条件: 每次 session 启动
动作序列:
  1. 执行 startup_check.sh
  2. 运行 integrity_check.py
  3. 如有文件缺失，自动创建空白模板
  4. 如检查失败，发送提醒
```

### 4. 断电恢复工作流
```
触发条件: 系统重启 / 检测到异常关机
动作序列:
  1. 执行 crash_recovery.sh
  2. 检查 git 状态
  3. 恢复未提交的文件
  4. 验证完整性
  5. 重新提交
  6. 发送恢复报告
```

### 5. 定时同步工作流
```
触发条件: 每分钟
动作序列:
  1. 检查 memory/ 下文件变更
  2. 自动 git add + commit
  3. 每小时 push 到 origin
```

---

## ⚙️ 触发条件配置

### 文件变更触发
```yaml
trigger: file_change
path: memory/projects/*.md
actions:
  - update_index
  - check_integrity
```

### 时间触发
```yaml
trigger: schedule
cron: "0 * * * *"  # 每小时
actions:
  - git_push_origin
  - cleanup_temp_files
```

### 状态变更触发
```yaml
trigger: status_change
from: "development"
to: "submitted"
actions:
  - update_project_file
  - send_notification
  - update_semantic_tags
```

---

## 📋 预设工作流清单

| 工作流名称 | 触发条件 | 状态 |
|------------|----------|------|
| session_end | Session 结束 | ✅ 已实现 |
| startup_check | Session 启动 | ✅ 已实现 |
| project_status_change | 项目状态变化 | ✅ 已实现 |
| crash_recovery | 断电/重启 | ✅ 已实现 |
| auto_commit | 每分钟 | ✅ 已实现 |
| daily_backup | 每天 00:00 | 🔜 待实现 |
| weekly_summary | 每周一 | 🔜 待实现 |

---

## 🔧 自动化脚本清单

| 脚本 | 路径 | 用途 |
|------|------|------|
| memory_end_session.sh | memory/ | Session 结束自动保存 |
| startup_check.sh | .cron/ | 启动检查 |
| memory_cron.sh | .cron/ | 每分钟自动提交 |
| crash_recovery.sh | .cron/ | 崩溃恢复 |
| integrity_check.py | memory/integrity/ | 完整性检查 |

---

*此文件由系统自动维护，每次工作流变更时更新*