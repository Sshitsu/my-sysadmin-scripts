#!/bin/bash
#
# Вариант задания (Б — Мониторинг ресурсов)
# script.sh — мониторинг ресурсов системы
# Раз в N секунд снимает free -h, df -h, uptime и дописывает блок
# с временной меткой в monitor.log

INTERVAL=5
LOG_FILE="/var/www/monitor.log"

for cmd in free df uptime date; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: utility '$cmd' is not find" >&2
        exit 1
    fi
done

LOG_DIR="$(dirname "$LOG_FILE")"
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: catalog '$LOG_DIR' is not exist" >&2
    exit 1
fi


trap 'echo; echo "Monitoring has stopped."; exit 0' INT

echo "Monitoring has started. Interval: ${INTERVAL}s. LOG: ${LOG_FILE}"
echo "Press Ctrl+C to exit."

while true; do
    {
        echo "--- $(date '+%Y-%m-%d %H:%M:%S') ---"
        free -h
        df -h
        uptime
        echo
    } >> "$LOG_FILE"
    sleep "$INTERVAL"
done


