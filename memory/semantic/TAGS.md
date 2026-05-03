# Semantic Tags — 语义标签系统

> 系统版本: v5.0 | AI Enterprise Level | 最后更新: 2026-05-03

---

## 🎯 功能说明

语义标签为每个实体（项目、决策、任务）添加多维度标签，
实现：
- 快速分类检索
- 意图识别辅助
- 关系发现

---

## 🏷️ 项目语义标签

### 按功能分类
| 项目 | 功能标签 |
|------|----------|
| DailyIQ | # productivity # AI # scheduling # goals # insights |
| FakeChat | # social # simulator # entertainment # chat-simulation |
| MindPal | # productivity # habit # journal # growth # tracking |
| HabitGo | # productivity # habit # calendar # gamification |
| JustZenGo | # productivity # focus # timer # widget # pomodoro |
| LuminaHealth | # health # wellness # tracking # lifestyle |
| StretchFlow | # health # fitness # stretching # wellness |
| UstiaGo | # productivity # screen-time # parental-controls # utility |

### 按状态分类
| 项目 | 状态标签 |
|------|----------|
| DailyIQ | # live # app-store # approved |
| FakeChat | # development # not-uploaded |
| MindPal | # development # not-uploaded |
| HabitGo | # in-review # app-store # pending |
| JustZenGo | # submitted # app-store # pending |
| LuminaHealth | # testing # not-uploaded |
| StretchFlow | # testing # not-uploaded |
| UstiaGo | # development # not-uploaded |

### 按优先级分类
| 项目 | 优先级标签 |
|------|----------|
| DailyIQ | # p1-done |
| FakeChat | # p1-high |
| MindPal | # p1-high |
| HabitGo | # p2-medium |
| JustZenGo | # p2-medium |
| LuminaHealth | # p1-medium |
| StretchFlow | # p1-medium |
| UstiaGo | # p1-high |

---

## 🏷️ 决策语义标签

| 决策 | 标签 |
|------|------|
| Memory Protocol | # system # memory # mandatory # protocol |
| FakeChat Rebuild | # project # fakechat # sop # rebuild |
| Enterprise Memory v3.0 | # system # memory # enterprise # infrastructure |
| Enterprise Memory v4.0 | # system # memory # enterprise # infrastructure # backup |

---

## 🏷️ 人物语义标签

| 人物 | 标签 |
|------|------|
| PageBrin (老爷) | # owner # boss # developer # apple-dev # strict |

---

## 🔍 意图识别模式

### 模式库
| 模式 | 意图 | 动作 |
|------|------|------|
| "继续上次*" | 恢复任务 | 读取 tasks/active.md + projects/*.md |
| "项目状态" | 查询状态 | 读取 INDEX.md + projects/*.md |
| "之前做了什么" | 历史查询 | memory_search + sessions/SESSIONS.md |
| "记忆系统" | 系统查询 | 读取 INDEX.md + ARCHITECTURE.md |
| "下次*" | 预约任务 | 更新 tasks/active.md |

---

## 📊 标签统计

| 标签类型 | 数量 |
|----------|------|
| 功能标签 | 25+ |
| 状态标签 | 10+ |
| 优先级标签 | 8 |
| 决策标签 | 10+ |
| 人物标签 | 5+ |

---

## 🧠 语义搜索示例

### "找所有 productivity 相关的项目"
```bash
grep -r "# productivity" /root/.openclaw/workspace/memory/projects/
→ DailyIQ, MindPal, HabitGo, JustZenGo, UstiaGo
```

### "找所有 #p1-high 优先级的项目"
```bash
grep -r "# p1-high" /root/.openclaw/workspace/memory/projects/
→ FakeChat, MindPal, UstiaGo
```

### "找所有 #app-store 相关项目"
```bash
grep -r "# app-store" /root/.openclaw/workspace/memory/projects/
→ DailyIQ, HabitGo, JustZenGo
```

---

*此文件由系统自动维护，每次实体更新时同步*