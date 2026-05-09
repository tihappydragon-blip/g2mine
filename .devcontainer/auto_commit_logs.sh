#!/bin/bash

LOG_DIR="/workspaces/${LOCAL_WORKSPACE_FOLDER}/activation_logs"
cd "/workspaces/${LOCAL_WORKSPACE_FOLDER}"

# Find the most recent log file
LATEST_LOG=$(ls -t ${LOG_DIR}/activation_*.txt 2>/dev/null | head -1)

if [ -n "$LATEST_LOG" ]; then
    git add "$LATEST_LOG"
    git commit -m "Auto-log: Codespace activation at $(date)" 
    git push origin HEAD 2>/dev/null || echo "⚠️ Could not auto-push (might need authentication)"
fi
