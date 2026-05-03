#!/bin/bash
# Memory Crash Recovery Script
# Run when: 电脑断电后重启 / 系统崩溃后恢复
# 用法: bash crash_recovery.sh

WORKSPACE="/root/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE/memory"
LOG_FILE="$WORKSPACE/.cron/crash_recovery_log.txt"

echo "========================================" | tee -a "$LOG_FILE"
echo "Memory Crash Recovery - $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"

# 1. 检查 Git 状态
echo "[1/5] 检查 Git 仓库状态..." | tee -a "$LOG_FILE"
cd "$WORKSPACE"
git status --short | head -20 | tee -a "$LOG_FILE"

# 2. 恢复未提交的 memory 文件
echo "" | tee -a "$LOG_FILE"
echo "[2/5] 恢复未提交的 memory 文件..." | tee -a "$LOG_FILE"
for file in $(git diff --name-only | grep "^memory/"); do
    echo "  恢复: $file" | tee -a "$LOG_FILE"
    git checkout -- "$file"
done

# 3. 运行完整性检查
echo "" | tee -a "$LOG_FILE"
echo "[3/5] 运行完整性检查..." | tee -a "$LOG_FILE"
python3 "$MEMORY_DIR/integrity/integrity_check.py" | tee -a "$LOG_FILE"

# 4. 检查今日日记是否存在
echo "" | tee -a "$LOG_FILE"
echo "[4/5] 检查今日日记..." | tee -a "$LOG_FILE"
TODAY=$(date +%Y-%m-%d)
if [ ! -f "$MEMORY_DIR/$TODAY.md" ]; then
    echo "  ⚠️ 今日日记不存在，创建空白模板" | tee -a "$LOG_FILE"
    cat > "$MEMORY_DIR/$TODAY.md" << EOF
# $TODAY Daily Log

> 崩溃恢复后创建 | 时间: $(date '+%Y-%m-%d %H:%M:%S')

## ⚠️ 崩溃恢复记录

系统检测到崩溃，已自动恢复。
如有未保存的数据，请查看 git log。

EOF
else
    echo "  ✅ 今日日记存在" | tee -a "$LOG_FILE"
fi

# 5. 同步到 Git（确保恢复后立即保存）
echo "" | tee -a "$LOG_FILE"
echo "[5/5] 同步到 Git..." | tee -a "$LOG_FILE"
git add memory/ 2>/dev/null
git commit -m "crash-recovery: $(date '+%Y-%m-%d %H:%M:%S')" --allow-empty 2>/dev/null
echo "  ✅ 恢复完成" | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "崩溃恢复完成 - $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
echo "查看日志: cat $LOG_FILE" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"