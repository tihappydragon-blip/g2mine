#!/bin/bash

# Create logs directory if it doesn't exist
LOG_DIR="/workspaces/${LOCAL_WORKSPACE_FOLDER}/activation_logs"
mkdir -p "$LOG_DIR"

# Create timestamp for the log file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/activation_${TIMESTAMP}.txt"

# Start logging
{
    echo "========================================="
    echo "Codespace Activation Log"
    echo "Timestamp: $(date)"
    echo "Codespace Name: ${CODESPACE_NAME}"
    echo "User: $(whoami)"
    echo "Host: $(hostname)"
    echo "========================================="
    echo ""
    
    echo "--- Current Working Directory ---"
    pwd
    echo ""
    
    echo "--- Git Status ---"
    git status 2>/dev/null || echo "Not a git repository or git not available"
    echo ""
    
    echo "--- Running Processes ---"
    ps aux | head -20
    echo ""
    
    echo "--- Port Status ---"
    ss -tuln 2>/dev/null || netstat -tuln 2>/dev/null || echo "Port listing not available"
    echo ""
    
    echo "--- XRay Status Check ---"
    if pgrep -x "xray" > /dev/null; then
        echo "XRay is running"
    else
        echo "XRay is not running"
    fi
    echo ""
    
    echo "--- Environment Variables (filtered) ---"
    env | grep -E "CODESPACE|GITHUB|PORT" | sort
    echo ""
    
    echo "--- Disk Usage ---"
    df -h
    echo ""
    
    echo "--- Memory Usage ---"
    free -h
    echo ""
    
    echo "========================================="
    echo "Log captured at $(date)"
    echo "========================================="
    
} 2>&1 | tee "$LOG_FILE"

# Add the log file to git (stage it, but don't auto-commit)
cd "/workspaces/${LOCAL_WORKSPACE_FOLDER}"
git add "activation_logs/activation_${TIMESTAMP}.txt" 2>/dev/null

# Optional: Create a symbolic link to the latest log
ln -sf "$LOG_FILE" "${LOG_DIR}/latest_activation.txt"

echo "✅ Activation log saved to: $LOG_FILE"
