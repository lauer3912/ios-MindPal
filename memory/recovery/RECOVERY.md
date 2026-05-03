# Memory Recovery Plan — 灾难恢复计划

> 系统版本: v4.0 | 用途: 数据恢复

## 场景1: 文件丢失

### INDEX.md 丢失
**恢复步骤:**
1. 从 Git history 恢复: `git checkout HEAD~1 -- memory/INDEX.md`
2. 或从 ARCHITECTURE.md 重建系统结构
3. 运行 `integrity_check.py` 验证

### 项目文件丢失
**恢复步骤:**
1. 检查 `audit/AUDIT.md` 获取最后已知状态
2. 从 Git history 恢复: `git checkout HEAD -- memory/projects/<file>.md`
3. 更新 INDEX.md

---

## 场景2: Session 丢失

### BRIDGE.md 损坏
**恢复步骤:**
1. 读取 `sessions/SESSIONS.md` 获取最后一个 session 信息
2. 从 `tasks/active.md` 恢复未完成的任务
3. 重新生成 BRIDGE.md

### 日记丢失
**恢复步骤:**
1. 从 Git history 恢复: `git checkout HEAD~1 -- memory/YYYY-MM-DD.md`
2. 或从 sessions/SESSIONS.md 重建当日记录

---

## 场景3: 系统崩溃

### 整个 memory 目录损坏
**恢复步骤:**
1. `git clone` 重新获取最新提交
2. 运行 `memory_autosave.py daily` 重新初始化今日日记
3. 检查 `audit/AUDIT.md` 完整性

---

## 📞 紧急联系人

| 场景 | 联系人 | 备注 |
|------|--------|------|
| 系统崩溃 | Git history | 最近的 commit 是 `fad10e4` |
| 文件损坏 |老爷 | 飞书 ou_80ed67669d033510ee7cb5666c87c697 |

---

## 🔧 恢复工具

| 工具 | 路径 | 用途 |
|------|------|------|
| Integrity Checker | integrity/integrity_check.py | 验证文件完整性 |
| Auto-save | memory_autosave.py | 重新初始化日常文件 |
| Session Recovery | sessions/SESSIONS.md | 从会话记录恢复 |

---

*此文件由系统自动维护，v4.0*