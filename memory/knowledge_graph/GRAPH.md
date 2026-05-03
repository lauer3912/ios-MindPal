# Knowledge Graph — 知识图谱

> 系统版本: v5.0 | AI Enterprise Level | 最后更新: 2026-05-03

---

## 🎯 概念

知识图谱将记忆系统中的实体（项目、决策、人物）连接成网状结构，
实现：
- **关系可视化**: 一眼看清项目间的关联
- **影响链追踪**: 一个决策如何影响多个项目
- **智能推理**: 自动发现隐藏的联系

---

## 📊 实体类型

### Entity Types
| 类型 | 说明 | 示例 |
|------|------|------|
| Project | iOS App 项目 | DailyIQ, FakeChat, MindPal |
| Decision | 重大决策 | Memory Protocol, FakeChat Rebuild |
| Person | 人物 | PageBrin (老爷) |
| Task | 任务 | P0 记忆系统升级 |
| Document | 文档 | AGENTS.md, MEMORY.md |

---

## 🔗 关系定义

| 关系类型 | 符号 | 说明 |
|----------|------|------|
| depends_on | → | 依赖关系 |
| part_of | ∈ | 属于 |
| relates_to | ⇄ | 相关 |
| impacts | ⇒ | 影响 |
| created_by | ✗ | 创建者 |
| approved_by | ✓ | 审批者 |

---

## 🕸️ 项目关系图

```
DailyIQ ──part_of──→ App Store 上架
   │                      ▲
   └─depends_on──→ Memory Protocol
                           │
FakeChat ──part_of──→ SOP 重建
   │                      ▲
   └─depends_on──→ Memory Protocol

MindPal ──part_of──→ App Store 提交
   │                      ▲
   └─depends_on──→ Memory Protocol
                           │
JustZenGo ──part_of──→ App Store 已提交
   │                      ▲
   └─depends_on──→ Memory Protocol
```

---

## 🌐 核心实体详情

### DailyIQ
- **类型**: Project
- **Bundle ID**: com.ggsheng.DailyIQ
- **状态**: ✅ 上架审核通过
- **关系**:
  - depends_on: Memory Protocol
  - relates_to: FakeChat (同为SOP项目)
  - approved_by: PageBrin
- **创建时间**: 2026-04

### FakeChat
- **类型**: Project
- **Bundle ID**: com.ggsheng.FakeChat
- **状态**: 🔨 开发中
- **关系**:
  - depends_on: Memory Protocol
  - part_of: SOP 重建
  - relates_to: MindPal (同为SOP项目)
- **创建时间**: 2026-04

### PageBrin (老爷)
- **类型**: Person
- **ID**: ou_80ed67669d033510ee7cb5666c87c697
- **关系**:
  - owns: 所有项目
  - approves: 所有图标/设计
  - creates: 所有重大决策
- **时区**: Asia/Shanghai (GMT+8)

---

## 🔗 决策影响链

```
Memory Protocol (2026-04-17)
    │
    ├──⇒ FakeChat SOP 重建
    ├──⇒ FakeChat AppIcon 修复
    ├──⇒ 所有项目 Memory Search Rule
    ├──⇒ AGENTS.md 更新
    └──⇒ v2.0/v3.0/v4.0 记忆系统升级

FakeChat Rebuild (2026-04-26)
    │
    ├──⇒ FakeChat 项目重建
    ├──⇒ 图标设计审核要求
    └──⇒ UI 设计审核要求

Enterprise Memory v3.0 (2026-05-03)
    │
    ├──⇒ INDEX.md 中央索引
    ├──⇒ sessions/ 会话轨迹
    ├──⇒ hot/ 热度追踪
    └──⇒ search/ 搜索索引
```

---

## 🧠 语义标注

### 项目标签
| 项目 | 标签 |
|------|------|
| DailyIQ | #上架 #审核通过 #70功能 #番茄钟 |
| FakeChat | #开发中 #SOP #重建 #62功能 #聊天模拟 |
| MindPal | #开发中 #SOP #62功能 #习惯追踪 |
| HabitGo | #审核中 #习惯追踪 #日历视图 |
| JustZenGo | #已提交 #番茄钟 #Widget |
| LuminaHealth | #待测 #健康 |
| StretchFlow | #待测 #拉伸 |
| UstiaGo | #开发中 #屏幕时间 |

### 决策标签
| 决策 | 标签 |
|------|------|
| Memory Protocol | #记忆 #系统规则 #MANDATORY |
| FakeChat Rebuild | #SOP #重建 #优先级高 |
| Enterprise Memory v3.0 | #记忆系统 #企业级 #v3.0 |

---

## 🔍 智能查询示例

### "哪些项目依赖于 Memory Protocol?"
```python
# 从知识图谱查询
dependencies["Memory Protocol"] 
→ ["DailyIQ", "FakeChat", "MindPal", "JustZenGo"]
```

### "谁批准了 FakeChat 图标?"
```python
# 查询决策链
approved_by["FakeChat"] 
→ ["PageBrin (佛罗多老爷)"]
```

### "哪些决策影响了 DailyIQ?"
```python
# 查询影响链
impacts["DailyIQ"]
→ ["Memory Protocol", "Enterprise Memory v3.0"]
```

---

## 📈 图谱统计

| 指标 | 数值 |
|------|------|
| 项目节点 | 8 |
| 决策节点 | 3 |
| 人物节点 | 1 |
| 关系边 | 25+ |
| 标签数 | 20+ |

---

*此文件由系统自动维护，每次实体变更时更新*