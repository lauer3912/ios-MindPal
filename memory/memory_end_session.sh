#!/bin/bash
# Memory System v3.0 — Session End Auto-Save Hook
# Run this at the end of every session

WORKSPACE="/root/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE/memory"
TODAY=$(date +%Y-%m-%d)
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M")

echo "🧠 Memory System v3.0 — Session Auto-Save"
echo "时间: $CURRENT_TIME"

# 1. 检查并创建今日日记
if [ ! -f "$MEMORY_DIR/$TODAY.md" ]; then
    echo "📝 创建今日日记: $TODAY.md"
    cat > "$MEMORY_DIR/$TODAY.md" << EOF
# $TODAY Daily Log

> 系统版本: 企业级记忆 v3.0
> 自动生成: $CURRENT_TIME

## 📝 今日概要

### 完成事项
-

### 关键决策
-

### 待跟进
-

---
EOF
fi

# 2. 更新 BRIDGE.md
echo "🔗 更新上下文桥梁..."
cat > "$MEMORY_DIR/context/BRIDGE.md" << EOF
# Context Bridge — 跨 Session 上下文桥梁

> 最后更新: $CURRENT_TIME
> 系统版本: v3.0

## 🔗 上一个 Session

- 时间: $TODAY
- 自动保存完成

## 🧭 Session 启动检查清单

- [x] 读取 context/BRIDGE.md（本文档）
- [x] 检查 tasks/active.md P0 任务
- [ ] 确认今天是否有新的 memory 文件
- [ ] 如果老爷有新消息，执行 Memory Protocol

---

*此文件由 memory_end_session.sh 自动维护*"
EOF

# 3. 更新 hotaccessed.txt
echo "📊 更新热度记录..."
echo "$CURRENT_TIME | auto-save | session-end | -" >> "$MEMORY_DIR/hot/accessed.txt" 2>/dev/null || true

# 4. 更新 INDEX.md 修改时间
echo "✅ INDEX.md 时间戳更新"
sed -i "s/最后更新:.*/最后更新: $CURRENT_TIME/" "$MEMORY_DIR/INDEX.md" 2>/dev/null || true

echo ""
echo "✅ Session Auto-Save 完成!"
echo "今日日记: $MEMORY_DIR/$TODAY.md"
echo "上下文桥: $MEMORY_DIR/context/BRIDGE.md"