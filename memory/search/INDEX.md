# Search Index — 全局搜索索引

> 系统版本: v3.0 | 每周一自动重建

## 用途
提供快速全文搜索能力，按类型分类索引。

## 索引结构

### 📁 按类型

#### Projects (项目)
- `dailyiq` → memory/projects/dailyiq.md
- `fakechat` → memory/projects/fakechat.md
- `mindpal` → memory/projects/mindpal.md
- `habitgo` → memory/projects/habitgo.md
- `justzengo` → memory/projects/justzengo.md
- `luminahealth` → memory/projects/luminahealth.md
- `stretchflow` → memory/projects/stretchflow.md
- `ustiago` → memory/projects/ustiago.md

#### Decisions (决策)
- `memory-protocol` → memory/decisions/2026-04-17-memory-protocol.md
- `fakechat-rebuild` → memory/decisions/2026-04-26-fakechat-rebuild.md
- `enterprise-memory` → memory/decisions/2026-05-03-enterprise-memory.md

#### People (人物)
- `pagebrin` → memory/people/pagebrin.md
- `佛罗多老爷` → memory/people/pagebrin.md

#### Tasks (任务)
- `active-tasks` → memory/tasks/active.md
- `memory-upgrade` → tasks/P0 记忆系统升级

#### Daily (日记)
- 2026-05-03 → memory/2026-05-03.md
- 2026-04-29 → memory/2026-04-29.md
- 2026-04-28 → memory/2026-04-28.md
- 2026-04-27 → memory/2026-04-27.md
- 2026-04-26 → memory/2026-04-26.md
- 2026-04-22 → memory/2026-04-22.md

---

## 🔍 常用查询路径

### 1. 项目状态查询
```
memory_search(query="DailyIQ status") 
→ memory/projects/dailyiq.md
```

### 2. 任务进度查询
```
memory_search(query="当前任务 P0")
→ memory/tasks/active.md
```

### 3. 决策历史查询
```
memory_search(query="memory protocol decision")
→ memory/decisions/
```

### 4. 对话历史查询
```
memory_search(query="JustZenGo 上传")
→ memory/sessions/SESSIONS.md
```

---

## 📊 关键数据点

| 项目 | Bundle ID | 最后状态 | App Store ID |
|------|-----------|----------|--------------|
| DailyIQ | com.ggsheng.DailyIQ | ✅ 上架 | 未知 |
| FakeChat | com.ggsheng.FakeChat | 🔨 开发中 | 未知 |
| MindPal | com.ggsheng.MindPal | 🔨 开发中 | 未知 |
| HabitGo | com.ggsheng.HabitGo | 🔨 审核中 | 未知 |
| JustZenGo | com.ggsheng.JustZen | ✅ 已提交 | 6762428992 |
| LuminaHealth | com.ggsheng.LuminaHealth | 🔨 待测 | 未知 |
| StretchFlow | com.ggsheng.StretchGoGo | 🔨 待测 | 未知 |
| UstiaGo | com.ggsheng.UstiaGo | 🔨 开发中 | 未知 |

---

## 🏷️ 标签索引

| 标签 | 相关文件 |
|------|----------|
| app-store | projects/dailyiq.md, projects/justzengo.md |
| build-success | projects/dailyiq.md, projects/ustiago.md |
| vnc | tasks/active.md (截图任务) |
| archive | memory/2026-04-10.md, memory/2026-04-17.md |
| privacy-policy | projects/fakechat.md, projects/mindpal.md |
| screenshot | projects/mindpal.md (iPad floating tab 问题) |

---

*此文件由系统每周一自动更新 + 每次重大决策时更新*