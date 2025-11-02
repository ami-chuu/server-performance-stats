# Server Performance Stats
The script to analyse basic server performance stats.
[Roadmap.sh project page](https://roadmap.sh/projects/server-stats)
## Installation ##
```
git clone https://github.com/ami-chuu/server-performance-stats
cd server-performance-stats
chmod +x server-stats.sh
```
## Usage ##
```
sudo ./server-stats.sh
```
## Output ##
```
======== SERVER STATS ==================
CPU Usage: 1%
Memory Usage: 580/898 MB (64%)
Disk Usage: 1.5G/7.8G (20%)

Top 5 Processes by CPU:
node
systemd
init-sy+
init
systemd+
Top 5 Processes by Memory:
node
node
node
node
node

System Info:
OS Version: Ubuntu 24.04.3 LTS
Uptime: up 3 hours, 11 minutes
Load Average:  0.00, 0.00, 0.00
Logged-in Users: ami-chuu

Failed Login Attempts:
Total: 2
Last 5 Entries:
Nov  2 16:04:59 sshd[2938]: Failed password for root from 192.168.1.15
Nov  2 16:05:12 sshd[2940]: Failed password for invalid user admin ...
========================================
```
