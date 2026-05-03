#!/bin/bash
# Memory Startup Check
# Run: 在每次 session 启动时自动执行（在 AGENTS.md 之前）
# 用法: 在 session 开始时自动调用

WORKSPACE="/root/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE/memory"
STARTUP_LOG="$WORKSPACE/.cron/startup_log.txt"

echo "========================================" > "$STARTUP_LOG"
echo "Memory Startup Check - $(date '+%Y-%m-%d %H:%M:%S')" >> "$STARTUP_LOG"
echo "========================================" >> "$STARTUP_LOG"

# 1. 检查关键文件
echo "[1/4] 检查关键文件..." >> "$STARTUP_LOG"
REQUIRED_FILES="INDEX.md ARCHITECTURE.md MEMORY.md AGENTS.md 2026-05-03.md"
for file in $REQUIRED_FILES; do
    if [ -f "$MEMORY_DIR/$file" ]; then
        echo "  ✅ $file" >> "$STARTUP_LOG"
    elif [ -f "$WORKSPACE/$file" ]; then
        echo "  ✅ $file (workspace root)" >> "$STARTUP_LOG"
    else
        echo "  ❌ $file MISSING" >> "$STARTUP_LOG"
    fi
done

# 2. 运行完整性检查（快速版）
echo "" >> "$STARTUP_LOG"
echo "[2/4] 运行完整性检查..." >> "$STARTUP_LOG"
python3 "$MEMORY_DIR/integrity/integrity_check.py" > /tmp/integrity_result.txt 2>&1
if grep -q "所有检查通过" /tmp/integrity_result.txt; then
    echo "  ✅ 完整性检查通过" >> "$STARTUP_LOG"
else
    echo "  ⚠️ 部分检查失败，查看详情" >> "$STARTUP_LOG"
    grep "❌" /tmp/integrity_result.txt >> "$STARTUP_LOG"
fi

# 3. 检查 Git 是否有未保存的变更
echo "" >> "$STARTUP_LOG"
echo "[3/4] 检查 Git 状态..." >> "$STARTUP_LOG"
cd "$WORKSPACE"
UNCOMMITTED=$(git status --porcelain memory/ | grep -v "^??" | wc -l)
if [ "$UNCOMMITTED" -gt 0 ]; then
    echo "  ⚠️ 有 $UNCOMMITTED 个未提交的 memory 文件" >> "$STARTUP_LOG"
    git status --short memory/ | head -5 >> "$STARTUP_LOG"
else
    echo "  ✅ 所有 memory 文件已提交" >> "$STARTUP_LOG"
fi

# 4. 读取今天的 BRIDGE 信息
echo "" >> "$STARTUP_LOG"
echo "[4/4] 读取 BRIDGE 信息..." >> "$STARTUP_LOG"
TODAY=$(date +%Y-%m-%d)
if [ -f "$MEMORY_DIR/context/BRIDGE.md" ]; then
    LAST_UPDATE=$(grep "最后更新" "$MEMORY_DIR/context/BRIDGE.md" | head -1)
    echo "  最后更新: $LAST_UPDATE" >> "$STARTUP_LOG"
    LAST_SESSION=$(grep "时间:" "$MEMORY_DIR/context/BRIDGE.md" | head -1)
    echo "  上次 Session: $LAST_SESSION" >> "$STARTUP_LOG"
else
    echo "  ⚠️ BRIDGE.md 不存在" >> "$STARTUP_LOG"
fi

echo "" >> "$STARTUP_LOG"
echo "✅ Startup Check 完成 - $(date '+%Y-%m-%d %H:%M:%S')" >> "$STARTUP_LOG"
echo "查看完整日志: cat $STARTUP_LOG" >> "$STARTUP_LOG"

# 显示摘要到控制台
echo "🧠 Memory System v4.0 启动检查:"
grep "✅\|❌\|⚠️" "$STARTUP_LOG" | head -10