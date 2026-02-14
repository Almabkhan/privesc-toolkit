#!/bin/bash
# Cron Job Checker

echo "==================================="
echo "CRON JOB CHECKER"
echo "==================================="

# Check system-wide crontab
echo -e "\n[+] System Crontab:"
cat /etc/crontab 2>/dev/null

# Check cron directories
echo -e "\n[+] Cron Directories:"
for dir in /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.monthly /etc/cron.weekly; do
    if [ -d "$dir" ]; then
        echo "  • $dir:"
        ls -la "$dir" 2>/dev/null | grep -v "^total" | while read line; do
            echo "    $line"
        done
    fi
done

# Check user crontabs
echo -e "\n[+] User Crontabs:"
for user in $(ls /var/spool/cron/crontabs/ 2>/dev/null); do
    echo "  • $user:"
    cat "/var/spool/cron/crontabs/$user" 2>/dev/null | while read line; do
        echo "    $line"
    done
done

echo -e "\n[+] Check complete!"