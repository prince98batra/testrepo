# SOP: Managing Cron Jobs on Ubuntu

**Owner:** Prince Batra  
**Team:** Downtime Crew  
**Date Created:** 14-Apr-2025  
**Last Updated:** 14-Apr-2025  

---

## 📦 Stack Details

**Component:** Cron Scheduler  
**OS/Platform:** Ubuntu 22.04 LTS    

---

## 🎯 Purpose

This SOP outlines how to create, edit, and manage cron jobs on Ubuntu systems. It helps in automating tasks like backups, log rotation, and monitoring.

---

## 🛠 Prerequisites

- Ubuntu 22.04 or compatible Linux environment  
- User access with `sudo` privileges  
- Basic shell scripting knowledge  

---

## 1. Introduction
Cron is a time-based job scheduler in Unix-like operating systems. This SOP provides step-by-step instructions for creating, editing, managing, and troubleshooting cron jobs on Ubuntu systems.

## 2. What is cron and crontab?

🎯 Objective / Use Case:  
Cron is a time-based job scheduler in Unix-like operating systems like Ubuntu. It lets users schedule tasks (called cron jobs) to run automatically at specified times or intervals.

📌 Example Use Case:  
Automatically run a backup script every night at midnight to save important files or logs for future use.

### 2.1 Check cron status
```bash
sudo systemctl status cron
```

### 2.2 Start cron (if inactive)
```bash
sudo systemctl start cron
```

### 2.3 Enable cron on system boot 
```bash
sudo systemctl enable cron
```

## 3. Cron Syntax Format

Learn how to write the correct cron job schedule format to run tasks at specific times — like hourly, daily, or on specific weekdays.

```
* * * * * command_to_run
│ │ │ │ │
│ │ │ │ └─ Day of the Week (0 - 7) (Sunday = 0 or 7)
│ │ │ └──── Month (1 - 12)
│ │ └────── Day of Month (1 - 31)
│ └──────── Hour (0 - 23)
└────────── Minute (0 - 59)
```

---

## 4. Creating and Editing Cron Jobs

Open the cron table (crontab) of the current user in edit mode, so you can create, modify, or delete scheduled tasks (cron jobs).

```bash
crontab -e
```

### 4.1 Example

#### Step 1: Create a Script
```bash
nano /home/ubuntu/hello.sh
```
Paste this into the file:
```bash
#!/bin/bash
echo "Hello from cron at $(date)" >> /home/ubuntu/hello_log.txt
```
Then make it executable:
```bash
chmod +x /home/ubuntu/hello.sh
```

#### Step 2: Schedule It in Cron
```bash
crontab -e
```

Add your cron job in the file:
```bash
0 9 * * * /home/ubuntu/hello.sh
```
This will run the hello.sh script every day at 9:00 AM.

#### Step 3: Verify It’s Working
```bash
cat /home/ubuntu/hello_log.txt
```
You should see something like:
```
Hello from cron at Mon Apr 14 13:21:01 UTC 2025
```

## 5. Viewing Cron Jobs

### 5.1 For Current User
List your scheduled jobs:
```bash
crontab -l
```

### 5.2 For Another User (as root)
```bash
crontab -u username -l
```

## 6. Removing Cron Jobs

### 6.1 Remove All Cron Jobs without confirmation
```bash
crontab -r
```

### 6.2 Remove All Cron Jobs with confirmation:
```bash
crontab -i -r
```

## 7. To edit your existing cron jobs

Open the crontab:
```bash
crontab -e
```
Modify the scheduled jobs (e.g., change the time or script) in the crontab file.  
Save and exit after making the changes.

## 8. Check System Cron Logs

```bash
grep CRON /var/log/syslog
```
This command will show logs for cron job executions, both user-specific and system-wide jobs.

### 8.1 View the /etc/crontab File
System-wide cron file: `/etc/crontab`  
This is where system-wide tasks are scheduled to run.

**Use Case:** Scheduling things like backups or cleanup tasks for the whole system.
```bash
# System-wide cron job for running backups daily at 2 AM
0 2 * * * root /usr/local/bin/backup.sh
```

### 8.2 Directory for Custom Cron Job Files
**Location:** `/etc/cron.d/`  

This allows you to store cron jobs in separate files and specify the user for each job.

**Use Case:** Organizing cron jobs for different users or services.

### 8.3 Directory for Daily Cron Jobs
**Location:** `/etc/cron.daily/`  

Scripts here are executed once daily by the system.

**Use Case:** For simple maintenance scripts that should run daily.

### 8.4 Directory for Hourly Cron Jobs
**Location:** `/etc/cron.hourly/`  

Scripts here run every hour.

**Use Case:** For scripts that perform frequent checks or cleanups.

## 9. Example Cron Jobs for Common Use Cases

## 9.1 Running System Updates
Run system updates every day at 5 AM:

`0 5 * * * root apt update && apt upgrade -y`

## 9.2 Running System Updates
Run log rotation every day at midnight:

`0 0 * * * root /usr/sbin/logrotate /etc/logrotate.conf`
---

| Date       | Author        | Change Description         |
|------------|---------------|----------------------------|
| 14-Apr-25  | Prince Batra  | Initial draft              |

**End of SOP**
