#!/bin/bash

# ===== Colors =====
GRAY="\e[1;30m"
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
WHITE="\e[1;37m"
RESET="\e[0m"

# ===== System Stats =====
totalCpu=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15}')

totalMemory=$(free -m | awk '/Mem:/ {print $2}')
usedMemory=$(free -m | awk '/Mem:/ {print $3}')
percentageMemory=$(awk "BEGIN {printf \"%d\", ($usedMemory/$totalMemory)*100}")

read totalDisk usedDisk percentageDisk <<<$(df -h / | awk 'NR==2{print $2, $3, $5}')
percentageDisk="${percentageDisk%\%}"

top5usageCpu=$(top -b -o %CPU -n 1 | awk 'NR>7{print $12}' | head -5)
top5usageMemory=$(top -b -o %MEM -n 1 | awk 'NR>7{print $12}' | head -5)

versionOS=$(lsb_release -d | cut -f2)
uptime=$(uptime -p)
loadAvg=$(uptime | awk -F'load average:' '{print $2}')
onlineUsers=$(who | awk '{print $1}' | sort -u)

# ===== Failed login attempts =====
if [ -f /var/log/auth.log ]; then
    failedLogins=$(grep -i "Failed password" /var/log/auth.log | wc -l)
    lastFailed=$(grep -i "Failed password" /var/log/auth.log | tail -5)
elif [ -f /var/log/secure ]; then
    failedLogins=$(grep -i "Failed password" /var/log/secure | wc -l)
    lastFailed=$(grep -i "Failed password" /var/log/secure | tail -5)
else
    failedLogins="N/A"
    lastFailed="Log file not found"
fi

# ===== Conditional Display =====
if (( totalCpu > 90 )); then 
    cpuColor=$RED
elif (( totalCpu > 70 )); then
    cpuColor=$YELLOW
else
    cpuColor=$GREEN
fi

if (( percentageMemory > 90 )); then 
    memoryColor=$RED
elif (( percentageMemory > 70 )); then
    memoryColor=$YELLOW
else
    memoryColor=$GREEN
fi

if (( percentageDisk > 90 )); then 
    diskColor=$RED
elif (( percentageDisk > 70 )); then
    diskColor=$YELLOW
else
    diskColor=$GREEN
fi

# ===== Output =====
echo -e "${BLUE}======== SERVER STATS ==================${RESET}"
echo -e "${BLUE}System Stats:${RESET}"
echo -e "${GRAY}CPU Usage:${RESET} ${cpuColor}${totalCpu}%${RESET}"
echo -e "${GRAY}Memory Usage:${RESET} ${memoryColor}${usedMemory}/${totalMemory} MB (${percentageMemory}%)${RESET}"
echo -e "${GRAY}Disk Usage:${RESET} ${diskColor}${usedDisk}/${totalDisk} (${percentageDisk}%)${RESET}"
echo ""
echo -e "${BLUE}Top 5 Processes by CPU:${RESET}"
echo -e "${WHITE}${top5usageCpu}${RESET}"
echo -e "${BLUE}Top 5 Processes by Memory:${RESET}"
echo -e "${WHITE}${top5usageMemory}${RESET}"
echo ""
echo -e "${BLUE}System Info:${RESET}"
echo -e "${GRAY}OS Version:${RESET} ${WHITE}${versionOS}${RESET}"
echo -e "${GRAY}Uptime:${RESET} ${WHITE}${uptime}${RESET}"
echo -e "${GRAY}Load Average:${RESET} ${WHITE}${loadAvg}${RESET}"
echo -e "${GRAY}Logged-in Users:${RESET} ${WHITE}${onlineUsers}${RESET}"
echo ""
echo -e "${BLUE}Failed Login Attempts:${RESET}"
echo -e "${GRAY}Total:${RESET} ${WHITE}${failedLogins}${RESET}"
echo -e "${GRAY}Last 5 Entries:${RESET}"
echo -e "${WHITE}${lastFailed}${RESET}"
echo -e "${BLUE}========================================${RESET}"
exit 0