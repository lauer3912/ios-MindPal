# Memory System Architecture — 企业级记忆系统 v6.0

> 版本: v6.0 | 更新: 2026-05-08 | 状态: ✅ 运营中 | 具备回忆能力

---

## 📐 系统架构图

```
┌─────────────────────────────────────────────────────────────────────┐
│                         WORKSPACE ROOT                              │
│  MEMORY.md ←─────── 核心记忆（长期/跨session）                        │
│  AGENTS.md ←─────── 系统规则（Memory Protocol MANDATORY）            │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│                      STARTUP SEQUENCE                              │
├─────────────────────────────────────────────────────────────────────┤
│  1. AGENTS.md（系统规则）                                            │
│  2. MEMORY.md（核心记忆）                                             │
│  3. INDEX.md（中央索引）← ┐                                          │
│  4. BRIDGE.md（上下文桥）←┼─ 启动时强制检查                           │
│  5. SESSIONS.md（会话轨迹）                                           │
│  6. Today's daily log   ←┘                                          │
│  7. memory_recall.py → 生成回顾报告                                  │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                    Memory System v6.0                              │
├─────────────────┬─────────────────┬─────────────────┬──────────────┤
│   LONG-TERM     │    DAILY        │     HOT         │  RECALL     │
│   (MEMORY.md)   │  (YYYY-MM-DD)   │   (访问热度)      │ (主动回忆)   │
│                 │                 │                 │              │
│ - 核心记忆       │ - 当天日志      │ - 最近7天活跃文件  │ - 跨日分析   │
│ - 人物档案       │ - Session记录   │ - 快速跳转表     │ - 趋势发现   │
│ - 长期项目状态   │ - 任务追踪      │ - 搜索索引       │ - 关键事件   │
└─────────────────┴─────────────────┴─────────────────┴──────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                    v6.0 ENGINE MODULES                             │
├─────────────────┬─────────────────┬─────────────────┬──────────────┤
│  recall         │  health         │  replay         │  inference  │
│  主动回忆引擎    │  健康检查系统    │  历史会话回放     │  AI推理引擎 │
│                 │                 │                 │              │
│ - 跨日引用分析   │ - 完整性检查     │ - 会话检索       │ - 关系推理   │
│ - 关键事件提取   │ - 自动修复       │ - 日期回放       │ - 影响链分析 │
│ - 记忆更新建议   │ - 孤岛检测       │ - 关键词搜索     │ - 异常检测   │
│ - 活跃度排名     │ - 引用完整性     │ - 项目历史       │ - 智能建议   │
└─────────────────┴─────────────────┴─────────────────┴──────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                    Category Structure                               │
├──────────────┬──────────────┬───────────────┬────────────────────┤
│   projects/  │  decisions/  │    people/    │    tasks/          │
│   (11项目)    │  (决策记录)   │   (人物)      │   (任务)           │
│              │              │               │                    │
│ dailyiq.md   │ (按日期)      │ pagebrin.md   │ active.md          │
│ fakechat.md  │              │               │                    │
│ mindpal.md   │              │               │                    │
│ ...         │               │               │                    │
└──────────────┴──────────────┴───────────────┴────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                    Data Flow v6.0                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Query ──→ memory_search ──→ INDEX.md ──→ 相关文件                 │
│              ↓                                                   │
│         [recall.py] ──→ 生成主动回忆报告                           │
│              ↓                                                   │
│         [health.py] ──→ 检查完整性                                 │
│              ↓                                                   │
│         [replay.py] ──→ 历史会话回放                               │
│                                                                  │
│  User Message → 分析 → Action → Write to Memory → Commit         │
│                                 ↓                                 │
│                    sessions/SESSIONS.md (追加)                    │
│                    hot/accessed.txt (热度+1)                      │
│                    daily/YYYY-MM-DD.md (日志)                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🧠 v6.0 新增功能

### 1. 主动回忆引擎 (memory_recall.py)
- 从 daily/ 自动提炼关键信息到 MEMORY.md
- 识别重要决策、项目进展、人物互动
- 更新知识图谱和语义标签
- 生成记忆亮点供下次session快速继承

### 2. 健康检查系统 (memory_health.py)
- 检查所有必需文件是否存在
- 验证索引完整性
- 检测孤岛文件（无引用）
- 自动修复常见问题

### 3. 历史会话回放 (session_replay.py)
- 从 sessions/SESSIONS.md 提取历史会话
- 支持按日期、项目、关键词搜索
- 生成"记忆回顾报告"供快速继承上下文

---

## 📁 目录结构

```
memory/
├── INDEX.md              中央索引（唯一真相来源）
├── ARCHITECTURE.md       系统架构图（本文件）
├── MEMORY.md             ← 核心记忆（在 workspace 根目录）
├── AGENTS.md             ← 系统规则（在 workspace 根目录）
│
├── daily/                每日日记（YYYY-MM-DD.md）
│   └── YYYY-MM-DD.md
│
├── projects/             项目追踪（11个）
│   └── *.md
│
├── decisions/           重大决策
│   └── YYYY-MM-DD-*.md
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
│   ├── HOT.md
│   └── accessed.txt
│
├── search/              搜索索引
│   └── INDEX.md
│
├── context/             跨会话上下文
│   └── BRIDGE.md
│
├── knowledge_graph/     知识图谱 + AI推理
│   ├── GRAPH.md
│   └── inference.py
│
├── semantic/            语义标签
│   └── TAGS.md
│
├── alerts/              主动提醒系统
├── workflows/           自动化工作流
├── backup/              多地备份
│
├── dreaming/            梦境记忆系统
│   ├── deep/
│   ├── light/
│   └── rem/
│
├── memory_recall.py     v6.0 主动回忆引擎 ⚡
├── memory_health.py     v6.0 健康检查系统 ⚡
└── session_replay.py    v6.0 历史会话回放 ⚡
```

---

## 🔄 数据流 v6.0

### 启动流程
```
1. 读取 AGENTS.md + MEMORY.md + INDEX.md
2. 运行 memory_recall.py → 生成回顾报告
3. 检查今日 daily 是否存在
4. 恢复未完成的 P0 任务
```

### 写入流程
```
User Message → 分析 → Action → Write to Memory → Commit
                                       ↓
                        sessions/SESSIONS.md (追加)
                        hot/accessed.txt (热度+1)
                        daily/YYYY-MM-DD.md (日志)
                        INDEX.md (如有重大变更)
```

### 回忆流程（新增）
```
Query → memory_recall.py → 跨日分析 → 关键事件
     → memory_health.py → 完整性检查
     → session_replay.py → 历史回放
     → inference.py → AI推理
```

---

## ⚡ Memory Protocol v6.0（强制执行）

### 启动行为
1. 读取 AGENTS.md（包含本规则）
2. 读取 MEMORY.md（核心记忆）
3. 检查 INDEX.md（中央索引）
4. 运行 memory_recall.py 生成回顾报告 ⚡
5. 检查 BRIDGE.md（上下文桥）
6. 检查今日 daily 日志是否存在
7. 如有未完成的 P0 任务，从 tasks/active.md 恢复

### 结束行为
1. 追加到 daily/YYYY-MM-DD.md
2. 更新 sessions/SESSIONS.md
3. 更新 hot/accessed.txt
4. 更新 context/BRIDGE.md
5. 更新 tasks/active.md（如有变更）
6. 更新 INDEX.md（如有重大变更）

### 搜索规则
- 所有"之前做了什么"、"上次"类问题 → memory_search
- 搜索范围：MEMORY.md + memory/*.md + memory/*/
- 结果必须包含引用来源（文件名 + 行号）

### 回忆规则（v6.0 新增）
- 每次 session 开始自动运行 memory_recall.py
- 关键事件自动提炼到 MEMORY.md
- 历史会话可随时通过 session_replay.py 回放

---

## 🛡️ 容错机制

| 情况 | 处理方式 |
|------|----------|
| 今日日记不存在 | 自动创建空白模板 |
| Index 过期 | 下次 session 开始时自动更新 |
| 热文件缺失 | 跳过，更新 accessed.txt |
| 跨 session 丢失 | 从 BRIDGE.md + SESSIONS.md 恢复 |
| 健康检查失败 | 自动修复（创建缺失文件） |
| 会话历史损坏 | 从 daily/ 日志重建 |

---

## 🚀 性能目标

- 启动时间: < 3秒（读取关键文件）
- 搜索时间: < 1秒（memory_search）
- 写入时间: < 0.5秒（增量追加）
- 回忆报告生成: < 2秒（memory_recall.py）
- 健康检查完成: < 3秒（memory_health.py）

---

*本文档由系统自动维护，每次架构变更时更新*
*v6.0 新增: recall + health + replay 三大引擎，支持主动回忆能力*