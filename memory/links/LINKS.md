# Bidirectional Links — 双向链接系统

> 系统版本: v4.0 | 用途: 文件间关联追踪

## 概念
双向链接让你在 A 文件中引用 B 文件时，系统自动在 B 文件中创建"反向链接"记录。
实现类似 Roam Research / Obsidian 的链接功能。

---

## 📎 链接类型

| 类型 | 语法 | 示例 |
|------|------|------|
| 项目链接 | `[[project:filename]]` | `[[project:dailyiq]]` |
| 决策链接 | `[[decision:date-title]]` | `[[decision:2026-05-03-enterprise]]` |
| 人物链接 | `[[person:name]]` | `[[person:pagebrin]]` |
| 任务链接 | `[[task:name]]` | `[[task:active]]` |

---

## 🔗 当前链接关系

### 项目 → 其他
| 项目 | 链接到 | 说明 |
|------|--------|------|
| dailyiq.md | decisions/2026-04-17-memory-protocol.md | SOP决策相关 |
| dailyiq.md | tasks/active.md | 当前P0任务 |
| fakechat.md | decisions/2026-04-26-fakechat-rebuild.md | SOP重建决策 |
| mindpal.md | decisions/2026-04-17-memory-protocol.md | Memory Protocol |

### 决策 → 其他
| 决策 | 反向链接（哪些文件引用） |
|------|-------------------------|
| 2026-05-03-enterprise-memory.md | tasks/active.md, INDEX.md, 2026-05-03.md |
| 2026-04-17-memory-protocol.md | projects/dailyiq.md, projects/fakechat.md, projects/mindpal.md |

### 人物 → 其他
| 人物 | 被哪些文件引用 |
|------|----------------|
| pagebrin.md | projects/*.md (全部8个), decisions/*.md (全部3个), tasks/active.md |

---

## 🔍 搜索反向链接

当你想知道"哪些文件引用了这个决策"时，搜索 `links/` 目录即可。

### 示例查询
```bash
# 查找所有引用 dailyiq 的文件
grep -r "dailyiq" /root/.openclaw/workspace/memory/links/

# 查找所有引用 pagebrin 的文件
grep -r "pagebrin" /root/.openclaw/workspace/memory/links/
```

---

## 📝 手动维护规则

1. 创建新链接时，同步更新两端的链接记录
2. 删除链接时，从两端同时删除
3. 每周一检查链接完整性

---

*此文件由系统手动维护，双向链接需手动创建*