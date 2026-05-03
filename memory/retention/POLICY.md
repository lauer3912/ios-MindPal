# Data Retention Policy — 数据保留策略

> 系统版本: v4.0 | 最后更新: 2026-05-03

## 📋 保留规则

| 文件类型 | 保留期 | 说明 |
|----------|--------|------|
| 每日日记 (daily/) | 永久 | 不可删除，累积长期记忆 |
| 项目文件 (projects/) | 永久 | 项目存活期间保留 |
| 决策记录 (decisions/) | 永久 | 重要决策永久保存 |
| 人物档案 (people/) | 永久 | 除非关系终止 |
| 任务追踪 (tasks/active.md) | 滚动 | 完成后移至 archive/ |
| 会话轨迹 (sessions/) | 90天 | 保留3个月后压缩 |
| 热文件记录 (hot/) | 30天 | 保留1个月热度数据 |
| 搜索索引 (search/) | 每周 | 每周一重建 |
| 周总结 (weekly/) | 1年 | 一年后移至 archive/ |
| 旧日记 (YYYY-MM-DD.md) | 永久 | 历史记录 |

---

## 🗑️ 删除规则

### 可安全删除
- `hot/accessed.txt` 超过30天
- `sessions/SESSIONS.md` 超过90天
- `search/INDEX.md` 超过7天

### 永不删除
- INDEX.md
- MEMORY.md
- AGENTS.md
- people/pagebrin.md
- decisions/*.md（决策历史）
- projects/*.md（项目历史）

---

## 📦 归档规则

### 自动归档触发条件
- daily/ 日记超过1年 → move to archive/
- weekly/ 总结超过1年 → move to archive/
- sessions/ 超过90天 → compress to sessions/*.gz

### 归档文件命名
`archive/YYYY-MM-DD_description.md`

---

## 🔄 更新周期

| 类型 | 频率 | 执行时间 |
|------|------|----------|
| 热文件清理 | 每天 | 00:00 |
| 搜索索引重建 | 每周一 | 03:00 |
| Session 压缩 | 每月 | 1号 00:00 |
| 旧日记归档 | 每年 | 1月1日 |
| 系统检查 | 每周 | 周一 09:00 |

---

*此文件由系统自动维护*