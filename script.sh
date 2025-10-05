#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/monitoring.log"
SERVICE_NAME="test.service"
ENDPOINT="https://test.com/monitoring/test/api"

STATE_FILE="/var/tmp/monitoring_state"

timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

check_restart() {
    local current_status=$(systemctl is-active "$SERVICE_NAME")


    if [[ -f "$STATE_FILE" ]]; then 
        local previous_status=$(cat "$STATE_FILE")
        if [[ "$previous_status" != "$current_status" ]]; then
            echo "$(timestamp) | Сервис $SERVICE_NAME был перезапущен" >> "$LOG_FILE"
        fi
    fi

    echo "$current_status" > "$STATE_FILE"
}

check_restart

if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "$(timestamp) | $SERVICE_NAME работает" >> "$LOG_FILE"

    if curl -s -f --connect-timeout 10 "$ENDPOINT" > /dev/null; then
        echo "$(timestamp) | $ENDPOINT доступен" >> "$LOG_FILE"
    else
        echo "$(timestamp) | $ENDPOINT недоступен" >> "$LOG_FILE"
    fi
else
    echo "$(timestamp) | $SERVICE_NAME не работает" >> "$LOG_FILE"
fi

