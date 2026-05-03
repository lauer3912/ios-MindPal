# Memory System Architecture — 企业级记忆系统 v3.0

> 版本: v3.0 | 更新: 2026-05-03 | 状态: ✅ 运营中

---

## 📐 系统架构图

```
┌─────────────────────────────────────────────────────────────┐
│                    Startup Sequence                        │
├─────────────────────────────────────────────────────────────┤
│  1. AGENTS.md (系统规则)                                    │
│  2. MEMORY.md (核心记忆)                                     │
│  3. INDEX.md (中央索引) ← ┐                                  │
│  4. BRIDGE.md (上下文桥) ←┼─ 启动时强制检查                   │
│  5. SESSIONS.md (会话轨迹)                                   │
│  6. Today's daily log   ←┘                                  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    Memory System v3.0                       │
├─────────────────┬─────────────────┬─────────────────────────┤
│   LONG-TERM     │    DAILY        │     HOT FILES           │
│   (MEMORY.md)   │  (YYYY-MM-DD)   │   (访问热度)             │
│                 │                 │                         │
│ - 核心记忆       │ - 当天日志      │ - 最近7天活跃文件         │
│ - 人物档案       │ - Session记录   │ - 快速跳转表             │
│ - 长期项目状态   │ - 任务追踪      │ - 搜索索引               │
└─────────────────┴─────────────────┴─────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    Category Structure                       │
├──────────────┬──────────────┬───────────────┬───────────────┤
│   projects/  │  decisions/  │    people/    │    tasks/     │
│   (8项目)    │  (决策记录)  │   (人物)      │   (任务)      │
│              │              │               │               │
│ dailyiq.md   │ 2026-04-17   │ pagebrin.md   │ active.md     │
│ fakechat.md  │ memory-pro.. │               │               │
│ mindpal.md   │ 2026-04-26   │               │               │
│ habitgo.md   │ fakechat-..  │               │               │
│ justzengo.md │ 2026-05-03   │               │               │
│ luminahealth │ enterprise.. │               │               │
│ stretchflow  │               │               │               │
│ ustiago.md   │               │               │               │
└──────────────┴──────────────┴───────────────┴───────────────┘
```

---

## 🔄 数据流

### 写入流程
```
User Message → Memory_search → 分析 → Action → Write to Memory → Commit
                                 ↓
                         sessions/SESSIONS.md (追加)
                         hot/accessed.txt (热度+1)
```

### 读取流程
```
Query → memory_search → INDEX.md → 相关文件 → memory_get → Response
                    ↓
              如果是 today → daily/YYYY-MM-DD.md
```

---

## 📁 目录结构

```
memory/
├── INDEX.md              中央索引（唯一真相来源）
├── MEMORY.md             核心记忆（长期）
├── AGENTS.md             系统规则（含 Memory Protocol）
│
├── daily/                每日日记（YYYY-MM-DD.md）
│   └── YYYY-MM-DD.md
│
├── projects/             项目追踪（8个）
│   ├── dailyiq.md
│   ├── fakechat.md
│   ├── mindpal.md
│   ├── habitgo.md
│   ├── justzengo.md
│   ├── luminahealth.md
│   ├── stretchflow.md
│   └── ustiago.md
│
├── decisions/           重大决策（按日期）
│   ├── 2026-04-17-memory-protocol.md
│   ├── 2026-04-26-fakechat-rebuild.md
│   └── 2026-05-03-enterprise-memory.md
│
├── people/              人物关系
│   └── pagebrin.md
│
├── tasks/               任务追踪
│   └── active.md
│
├── sessions/            会话轨迹记录
│   └── SESSIONS.md
│
├── hot/                 热文件访问记录
│   ├── HOT.md           热度主文件
│   └── accessed.txt     访问日志
│
├── search/              搜索索引
│   └── INDEX.md
│
├── context/             跨会话上下文
│   └── BRIDGE.md
│
├── weekly/              每周总结
│   └── .gitkeep
│
├── archive/             归档（旧文件）
│
├── dreaming/            梦境记忆系统（自动）
│
└── memory_autosave.py   自动备份脚本（可选）
    memory_end_session.sh  Session结束自动保存
```

---

## 🎯 Memory Protocol v3.0（强制执行）

### 启动行为
1. 读取 AGENTS.md（包含本规则）
2. 检查 MEMORY.md（核心记忆）
3. 检查 INDEX.md（中央索引）
4. 检查 BRIDGE.md（上下文桥）
5. 检查今日 daily 日志是否存在
6. 如有未完成的 P0 任务，从 tasks/active.md 恢复

### 结束行为
1. 追加到 daily/YYYY-MM-DD.md
2. 更新 sessions/SESSIONS.md
3. 更新 hot/HOT.md
4. 更新 context/BRIDGE.md
5. 更新 tasks/active.md（如有变更）
6. 更新 INDEX.md（如有重大变更）

### 搜索规则
- 所有"之前做了什么"、"上次"类问题 → memory_search
- 搜索范围：MEMORY.md + memory/*.md + memory/*/
- 结果必须包含引用来源（文件名 + 行号）

---

## ⚡ 关键原则

1. **写事实不写感受** — `App Store ID: 6762428992` 而非 `I think it's approved`
2. **不确定就写** — "If you're unsure whether to write something, write it anyway"
3. **立即记录** — 重要信息不要等到 session 结束
4. **中央索引** — INDEX.md 是唯一真相来源，任何冲突以它为准
5. **热度追踪** — 频繁访问的文件优先级更高

---

## 🛡️ 容错机制

| 情况 | 处理方式 |
|------|----------|
| 今日日记不存在 | 自动创建空白模板 |
| Index 过期 | 下次 session 开始时自动更新 |
| 热文件缺失 | 跳过，更新 accessed.txt |
| 跨 session 丢失 | 从 BRIDGE.md + SESSIONS.md 恢复 |

---

## 🚀 性能目标

- 启动时间: < 3秒（读取关键文件）
- 搜索时间: < 1秒（memory_search）
- 写入时间: < 0.5秒（增量追加）

---

*本文档由系统自动维护，每次架构变更时更新*