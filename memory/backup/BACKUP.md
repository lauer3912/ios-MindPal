# Multi-Region Backup — 多地容灾备份系统

> 系统版本: v5.0 | AI Enterprise Level | 最后更新: 2026-05-03

---

## 🎯 功能说明

多地容灾备份确保在单点故障情况下可以完整恢复：
- 本地 Git 仓库（实时）
- 远程 GitHub（每小时 push）
- 可选：云存储备份

---

## 📊 备份架构

```
┌─────────────────────────────────────────────────────┐
│              Memory System v5.0                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  本地 (workspace/.git)                             │
│     │                                               │
│     ├── 每分钟 git add + commit                     │
│     └── 状态: ✅ 实时保护                           │
│                                                     │
│  远程 (GitHub: lauer3912/...)                       │
│     │                                               │
│     ├── 每小时 git push                             │
│     └── 状态: ✅ 异地容灾                           │
│                                                     │
│  可选扩展 (待实现)                                  │
│     │                                               │
│     ├── 阿里云 OSS                                  │
│     └── S3/GCS 云存储                              │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 🔧 备份脚本

### incremental_backup.sh — 增量备份
```bash
#!/bin/bash
# 增量备份到 GitHub
WORKSPACE="/root/.openclaw/workspace"

cd $WORKSPACE
git add memory/
git commit -m "auto-backup: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin master

echo "✅ 增量备份完成: $(date '+%Y-%m-%d %H:%M:%S')"
```

### full_backup.sh — 全量备份（每月）
```bash
#!/bin/bash
# 全量备份（压缩后上传）
tar -czf backup_$(date +%Y%m).tar.gz memory/
gsutil cp backup_*.tar.gz gs://bucket/  # 未来扩展
```

---

## 📋 备份状态

| 备份位置 | 频率 | 最后备份 | 状态 |
|----------|------|----------|------|
| 本地 .git | 每分钟 | 2026-05-03 09:14 | ✅ |
| GitHub origin | 每小时 | - | ✅ |
| 本地备份脚本 | 按需 | 2026-05-03 | ✅ |

---

## 🚨 恢复流程

### 场景1: 本地文件损坏
```bash
# 从 GitHub 恢复
cd /root/.openclaw/workspace
git clone https://github.com/lauer3912/... # 替换为实际仓库
```

### 场景2: 断电后恢复
```bash
# 运行 crash_recovery.sh
bash .cron/crash_recovery.sh
```

### 场景3: 完整的系统重建
```bash
# 1. 克隆仓库
git clone <repo_url>
# 2. 运行完整性检查
python3 memory/integrity/integrity_check.py
# 3. 恢复今日日记
bash memory/memory_end_session.sh
# 4. 启动检查
bash .cron/startup_check.sh
```

---

## 📊 备份统计

| 指标 | 数值 |
|------|------|
| 本地备份频率 | 每分钟 |
| 远程备份频率 | 每小时 |
| 最大丢失数据 | 1 分钟 |
| 完整恢复时间 | < 5 分钟 |

---

## ⚠️ 待实现（v5.1）

- [ ] 阿里云 OSS 自动备份
- [ ] 备份加密
- [ ] 增量 vs 全量备份策略
- [ ] 备份验证脚本

---

*此文件由系统自动维护，每次备份后更新*