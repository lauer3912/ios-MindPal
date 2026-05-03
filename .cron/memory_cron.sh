#!/bin/bash
# Memory Auto-Commit Cron Job
# Run: 设置 cron: * * * * * /root/.openclaw/workspace/.cron/memory_cron.sh
# 频率: 每分钟执行一次（最小化断电损失）

WORKSPACE="/root/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE/memory"
LOG_FILE="$WORKSPACE/.cron/cron_log.txt"

echo "======== $(date '+%Y-%m-%d %H:%M:%S') =======" >> "$LOG_FILE"

# 1. 自动添加 memory/ 下所有变更
cd "$WORKSPACE"
git add memory/ 2>/dev/null

# 2. 检查是否有变更待提交
if git diff --cached --quiet; then
    echo "No changes to commit" >> "$LOG_FILE"
else
    # 3. 提交变更（带时间戳）
    git commit -m "auto-save: $(date '+%Y-%m-%d %H:%M:%S')" --allow-empty 2>/dev/null
    echo "Committed at $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
fi

# 4. 每小时 push 一次到 origin（避免积累）
MINUTE=$(date +%M)
if [ "$MINUTE" = "00" ]; then
    git push origin master 2>/dev/null
    echo "Pushed to origin at $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
fi

echo "Done at $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"