# Cron Configuration — 定时任务配置
# 系统版本: v5.0 AI Enterprise Level

---

## ⏰ 定时任务清单

| 任务 | 频率 | 脚本 | 用途 |
|------|------|------|------|
| 健康检查 | 每2小时 | health_check.py | 全面检查+自动修复 |
| 自动提交 | 每分钟 | memory_cron.sh | 防止断电丢失 |
| Git Push | 每小时 | memory_cron.sh 内 | 异地容灾 |

---

## 🕐 cron 设置命令

```bash
# 每2小时执行健康检查
0 */2 * * * /root/.openclaw/workspace/.cron/health_check_runner.sh

# 每分钟执行自动提交
* * * * * /root/.openclaw/workspace/.cron/memory_cron.sh
```

---

## 📋 健康检查任务详情

### 每2小时健康检查 (health_check.py)
检查范围: 过去 24-48 小时

#### 检查项目:
1. **每日日记** — 检查 YYYY-MM-DD.md 是否存在
   - 自动创建空白模板如果缺失
   - 记录缺失日期

2. **项目状态文件** — 检查 projects/*.md
   - 自动创建空白模板如果缺失
   - 记录缺失项目

3. **核心文件** — 检查 INDEX.md, ARCHITECTURE.md, MEMORY.md, AGENTS.md
   - 检查 workspace root 和 memory/ 两个位置
   - 记录缺失

4. **完整性验证** — 运行 integrity_check.py
   - 全部检查
   - 记录结果

5. **自动恢复** — 如果发现问题
   - 创建缺失的每日日记
   - 创建缺失的项目文件
   - 立即 git commit

6. **Git 同步** — 确保所有恢复已保存
   - git add + commit
   - 生成健康报告

---

## 📊 健康报告格式

```
========================================
🧠 Memory Health Check Report
时间: YYYY-MM-DD HH:MM:SS
========================================

📊 检查结果:
  核心文件: ✅ 或 ❌ N个缺失
  每日日记: ✅ 或 ⚠️ N个缺失
  项目文件: ✅ 或 ⚠️ N个缺失

🔧 自动修复:
  每日日记: 已恢复 / 无需恢复
  项目文件: 已恢复 / 无需恢复

📦 Git 状态:
  ✅ 已提交 / ❌ 需人工处理

========================================
```

---

## 🚨 告警条件

健康检查发现以下情况会记录警告:
- 每日日记缺失
- 项目文件缺失
- 核心文件缺失
- 完整性检查失败

---

## 📁 相关日志文件

| 文件 | 路径 | 内容 |
|------|------|------|
| 健康检查日志 | .cron/health_check_log.txt | 每次健康检查的详细日志 |
| 备份日志 | .cron/backup_log.txt | 每次备份的详细日志 |
| 启动检查日志 | .cron/startup_log.txt | 每次启动的检查日志 |
| 崩溃恢复日志 | .cron/crash_recovery_log.txt | 崩溃恢复的详细日志 |

---

*此文件由系统自动维护，每次 cron 配置变更时更新*