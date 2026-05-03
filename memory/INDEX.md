# Memory Index — 企业级记忆系统中央索引

> 最后更新: 2026-05-03T09:04:00+08:00
> 系统版本: v4.0 (企业级最高水平)

---

## 📊 记忆系统结构

```
memory/
├── INDEX.md              ← 中央索引（本文档）
├── ARCHITECTURE.md       ← 系统架构图（v3.0新增）
├── MEMORY.md             ← 核心记忆（长期）
├── AGENTS.md             ← 系统规则（含 Memory Protocol）
│
├── daily/                ← 每日日记（每次session自动追加）
│   └── YYYY-MM-DD.md
│
├── projects/             ← 项目状态追踪（8个）
│   └── *.md
│
├── decisions/            ← 重大决策记录（3个）
│   └── YYYY-MM-DD-*.md
│
├── people/              ← 人物关系
│   └── pagebrin.md
│
├── tasks/                ← 当前任务 & 待办
│   └── active.md
│
├── sessions/            ← 会话轨迹记录（v3.0新增）
│   └── SESSIONS.md
│
├── hot/                 ← 热文件访问记录（v3.0新增）
│   ├── HOT.md           ← 热度主文件
│   └── accessed.txt     ← 访问日志
│
├── search/              ← 搜索索引（v3.0新增）
│   └── INDEX.md
│
├── context/             ← 跨会话上下文桥（v3.0新增）
│   └── BRIDGE.md
│
├── weekly/              ← 每周总结
├── archive/             ← 已归档
└── dreaming/             ← 梦境记忆系统
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

## 📂 当前活跃文件清单

### Daily（每日日记）
| 文件 | 最后更新 | 状态 |
|------|----------|------|
| 2026-05-03.md | 2026-05-03 08:54 | ✅ 今天 |
| 2026-04-29.md | 2026-04-29 00:03 | ⬅️ 需补 |
| 2026-04-28.md | 2026-04-28 08:08 | ⬅️ 需补 |
| 2026-04-27.md | 2026-04-27 23:09 | ✅ |
| 2026-04-26.md | 2026-04-26 22:39 | ✅ |
| 2026-04-22.md | 2026-04-22 20:05 | ✅ |
| 2026-04-19.md | 2026-04-19 22:18 | ✅ |
| 2026-04-18.md | 2026-04-18 23:16 | ✅ |
| 2026-04-17.md | 2026-04-17 23:19 | ✅ |
| 2026-04-10.md | 2026-04-10 07:24 | ✅ |

### Projects（项目追踪）
| 项目 | 文件 | 最后更新 | 状态 |
|------|------|----------|------|
| DailyIQ | projects/dailyiq.md | 2026-04-29 | ✅ 上架 |
| FakeChat | projects/fakechat.md | 2026-04-26 | 🔨 开发中 |
| MindPal | projects/mindpal.md | 2026-04-27 | 🔨 开发中 |
| HabitGo | projects/habitgo.md | 2026-04-22 | 🔨 审核中 |
| JustZenGo | projects/justzengo.md | 2026-04-17 | ✅ 提交审核 |
| LuminaHealth | projects/luminahealth.md | 2026-04-29 | 🔨 待测 |
| StretchFlow | projects/stretchflow.md | 2026-04-29 | 🔨 待测 |
| UstiaGo | projects/ustiago.md | 2026-04-22 | 🔨 开发中 |

### Decisions（重大决策）
| 日期 | 标题 | 文件 |
|------|------|------|
| 2026-04-17 | Memory Protocol 强制执行规则 | decisions/2026-04-17-memory-protocol.md |
| 2026-04-26 | FakeChat SOP 重建决定 | decisions/2026-04-26-fakechat-rebuild.md |
| 2026-05-03 | 企业级记忆系统 v3.0 升级 | decisions/2026-05-03-enterprise-memory.md |

### People（人物关系）
| 人物 | ID | 关系 | 文件 |
|------|-----|------|------|
| 佛罗多老爷 | ou_80ed67669d033510ee7cb5666c87c697 | 主人/老板 | people/pagebrin.md |

### Tasks（任务）
| 任务 | 优先级 | 状态 | 文件 |
|------|--------|------|------|
| 记忆系统 v3.0 升级 | P0 | 🔄 进行中 | tasks/active.md |

---

## 🆕 v4.0 新增功能

| 功能 | 文件 | 用途 |
|------|------|------|
| 会话轨迹 | sessions/SESSIONS.md | 每次 session 的完整记录 |
| 热度追踪 | hot/HOT.md + accessed.txt | 最近7天活跃文件 |
| 搜索索引 | search/INDEX.md | 全局搜索关键词映射 |
| 上下文桥 | context/BRIDGE.md | 跨 session 未完成任务 |
| 系统架构图 | ARCHITECTURE.md | 完整架构文档 |
| 审计追踪 | audit/AUDIT.md | 完整性审计 |
| 完整性检查 | integrity/integrity_check.py | 自动验证 |
| 灾难恢复 | recovery/RECOVERY.md | 紧急恢复 |
| 监控面板 | dashboard/DASHBOARD.md | 实时状态 |
| 保留策略 | retention/POLICY.md | 数据保留规则 |
| 压缩归档 | compression/COMPRESS.md | 旧文件压缩 |
| 双向链接 | links/LINKS.md | 文件间关联 |

---

## ⚠️ 待补历史（2026-04-29 → 2026-05-02）

以下日期的记忆文件缺失，需要老爷补充：
- [ ] 2026-04-29（已知：DailyIQ BUILD SUCCEEDED）
- [ ] 2026-04-30
- [ ] 2026-05-01
- [ ] 2026-05-02

---

## 🏢 企业级特性（v3.0）

- **多维度索引**：时间 + 项目 + 人物 + 决策 + 任务 + 热度
- **自动追踪**：每次 session 自动更新，无需手动
- **中央索引**：INDEX.md 是唯一真相来源
- **热度系统**：最近访问的文件优先级更高
- **会话轨迹**：每次 session 完整记录，可追溯
- **上下文桥**：BRIDGE.md 确保跨 session 连续性
- **搜索优化**：search/INDEX.md 提供快速关键词定位
- **容错机制**：文件缺失时自动创建空白模板

---

*此文件由系统自动维护，请勿手动编辑*