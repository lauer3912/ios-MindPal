# Memory Index — 企业级记忆系统中央索引

> 最后更新: 2026-05-08T05:53:00+08:00
> 系统版本: v6.0 (AI Enterprise Level — 具备回忆能力)

---

## 📊 记忆系统结构

```
workspace/
├── MEMORY.md              ← 核心记忆（长期）- 在 workspace 根目录
├── AGENTS.md              ← 系统规则（含 Memory Protocol）
│
memory/
├── INDEX.md              ← 中央索引（唯一真相来源）
├── ARCHITECTURE.md       ← 系统架构图
│
├── daily/                ← 每日日记（每次session自动追加）
│   └── YYYY-MM-DD.md     ← 历史日记（14个文件）
│
├── projects/             ← 项目状态追踪（11个）
│   ├── dailyiq.md
│   ├── fakechat.md
│   ├── mindpal.md
│   ├── luminahealth.md
│   ├── stretchflow.md
│   ├── habitgo.md        ← v6.0 新增
│   ├── justzengo.md      ← v6.0 新增
│   ├── ustiago.md        ← v6.0 新增
│   ├── aliencontact.md
│   ├── blastpop.md
│   └── paradox.md
│
├── decisions/            ← 重大决策记录
│
├── people/               ← 人物关系
│   └── pagebrin.md
│
├── tasks/                ← 当前任务 & 待办
│   └── active.md
│
├── sessions/             ← 会话轨迹记录
│   └── SESSIONS.md
│
├── hot/                  ← 热文件访问记录
│
├── search/               ← 搜索索引
│
├── context/              ← 跨会话上下文桥
│   └── BRIDGE.md
│
├── knowledge_graph/      ← 知识图谱 + AI推理引擎
│   ├── GRAPH.md
│   └── inference.py
│
├── semantic/             ← 语义标签系统
│   └── TAGS.md
│
├── alerts/               ← 主动提醒系统
│
├── workflows/            ← 自动化工作流
│
├── backup/               ← 多地备份
│
├── dreaming/             ← 梦境记忆系统
│   ├── deep/
│   ├── light/
│   └── rem/
│
├── memory_recall.py      ← v6.0 主动回忆引擎（可执行）
├── memory_health.py      ← v6.0 健康检查系统（可执行）
└── session_replay.py     ← v6.0 历史会话回放（可执行）
```

---

## 🔄 更新规则

1. **每次 session 结束前**：自动追加到 `daily/YYYY-MM-DD.md`
2. **项目状态变更**：立即更新 `projects/<project>.md`
3. **重大决策**：立即写入 `decisions/`
4. **任务完成/新增**：立即更新 `tasks/active.md`
5. **每次 session**：自动更新 `sessions/SESSIONS.md` + `hot/accessed.txt`
6. **每周一**：生成 `weekly/YYYY-WXX.md` 总结

---

## 🆕 v6.0 新增功能（2026-05-08）

| 功能 | 文件 | 用途 |
|------|------|------|
| 主动回忆引擎 | memory_recall.py | 从 daily 自动提炼关键信息 |
| 健康检查系统 | memory_health.py | 检查完整性 + 自动修复 |
| 历史会话回放 | session_replay.py | 查询历史会话、跨日追踪 |
| 跨日引用分析 | (集成在 recall 中) | 发现项目活跃度趋势 |

---

## 🧠 记忆系统使用指南

### 1. 主动回忆（每次 session 开始时）
```bash
python3 memory/memory_recall.py
```
→ 输出：近期活跃项目 + 关键事件 + 更新建议

### 2. 健康检查（怀疑记忆丢失时）
```bash
python3 memory/memory_health.py
```
→ 输出：缺失文件 + 孤岛文件 + 引用完整性

### 3. 历史会话回放（需要回顾时）
```bash
# 生成7天报告
python3 memory/session_replay.py --report 7

# 回放特定日期
python3 memory/session_replay.py --replay 2026-05-03

# 搜索关键词
python3 memory/session_replay.py --search DailyIQ

# 按项目查看历史
python3 memory/session_replay.py --project FakeChat
```

### 4. AI推理查询
```bash
python3 memory/knowledge_graph/inference.py
```
→ 输出：项目状态、影响链分析、异常检测

---

## 📂 当前活跃文件清单

### Daily（每日日记）- 14个文件
| 文件 | 日期 |
|------|------|
| 2026-05-05.md | ✅ |
| 2026-05-03.md | ✅ |
| 2026-05-02.md | ✅ |
| 2026-05-01.md | ✅ |
| 2026-04-30.md | ✅ |
| 2026-04-29.md | ✅ |
| 2026-04-28.md | ✅ |
| 2026-04-27.md | ✅ |
| 2026-04-26.md | ✅ |
| 2026-04-22.md | ✅ |
| 2026-04-19.md | ✅ |
| 2026-04-18.md | ✅ |
| 2026-04-17.md | ✅ |
| 2026-04-10.md | ✅ |

⚠️ 缺失：2026-05-06, 2026-05-07, 2026-05-08

### Projects（项目追踪）- 11个文件
| 项目 | 状态 | 最后更新 |
|------|------|----------|
| DailyIQ | ✅ 上架 | 2026-04-29 |
| FakeChat | 🔨 开发中 | 2026-04-26 |
| MindPal | 🔨 开发中 | 2026-04-27 |
| HabitGo | 🔨 审核中 | 2026-04-22 |
| JustZenGo | ✅ 已提交 | 2026-04-17 |
| LuminaHealth | 🔨 待测 | 2026-04-29 |
| StretchFlow | 🔨 待测 | 2026-04-29 |
| UstiaGo | 🔨 开发中 | 2026-04-22 |
| AlienContact | 🔨 开发中 | - |
| BlastPop | 🔨 开发中 | - |
| Paradox | 🔨 开发中 | - |

### Sessions（会话轨迹）
| 日期 | 会话数 |
|------|--------|
| 2026-05-08 | 1次 |
| 2026-05-03 | 4次 |

---

## 🏢 企业级特性（v6.0）

- ✅ **多维度索引**：时间 + 项目 + 人物 + 决策 + 任务 + 热度
- ✅ **自动追踪**：每次 session 自动更新
- ✅ **中央索引**：INDEX.md 是唯一真相来源
- ✅ **热度系统**：最近访问的文件优先级更高
- ✅ **会话轨迹**：每次 session 完整记录，可追溯
- ✅ **上下文桥**：BRIDGE.md 确保跨 session 连续性
- ✅ **搜索优化**：search/INDEX.md 提供快速关键词定位
- ✅ **容错机制**：文件缺失时自动创建空白模板
- ✅ **主动回忆**：从历史日记提炼关键信息
- ✅ **健康检查**：自动检测 + 修复问题
- ✅ **历史回放**：查询任意时间段的历史会话

---

## ⚡ 下一步升级方向

1. 集成 AI 推理引擎到日常检索
2. 自动生成每周记忆摘要
3. 智能预测项目风险（基于历史模式）
4. 跨语言语义搜索支持

---

*此文件由系统自动维护，每次架构变更时更新*
*v6.0 新增: recall + health + replay 三大引擎*