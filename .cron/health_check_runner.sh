#!/bin/bash
# Memory Health Check Runner
# Run: 每2小时执行一次 (cron: 0 */2 * * *)
# 用法: bash health_check_runner.sh

WORKSPACE="/root/.openclaw/workspace"
LOG_FILE="$WORKSPACE/.cron/health_check_log.txt"

echo "======== Health Check $(date '+%Y-%m-%d %H:%M:%S') ========" >> "$LOG_FILE"

# 执行健康检查
python3 "$WORKSPACE/.cron/health_check.py" 2>&1 | tee -a "$LOG_FILE"

# 如果有 P0 警告，发送通知（通过 message tool 会在下次 session 触发）
# 这里只是记录到日志

echo "Done at $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"