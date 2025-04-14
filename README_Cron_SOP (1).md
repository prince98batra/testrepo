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

```
sudo systemctl status cron
```

### 2.2 Start cron (if inactive)
If cron is already active, this command will simply ensure it's running without restarting it unnecessarily.

```
sudo systemctl start cron
```

### 2.3 Enable cron on system boot 

```
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

```
crontab -e
```

### 4.1 Example

#### Step 1: Create a Script

```
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
```
crontab -e
```

Add your cron job in the file:
```
0 9 * * * /home/ubuntu/hello.sh
```

This will run the hello.sh script every day at 9:00 AM.

#### Step 3: Verify It’s Working
```
cat /home/ubuntu/hello_log.txt
```

You should see something like:

```
Hello from cron at Mon Apr 14 13:21:01 UTC 2025
```

## 5. Viewing Cron Jobs

### 5.1 For Current User
List your scheduled jobs:

```
crontab -l
```

### 5.2 For Another User (as root)

```
crontab -u username -l
```

## 6. Removing Cron Jobs

### 6.1 Remove All Cron Jobs without confirmation

```
crontab -r
```

### 6.2 Remove All Cron Jobs with confirmation:

```
crontab -i -r
```

## 7. To edit your existing cron jobs

Open the crontab:

```
crontab -e
```

Modify the scheduled jobs (e.g., change the time or script) in the crontab file.  
Save and exit after making the changes.

## 8. Check System Cron Logs

```
grep CRON /var/log/syslog
```

This command will show logs for cron job executions, both user-specific and system-wide jobs.

### 8.1 System-wide Cron File 
**Location:** `/etc/crontab`  

Can Be Used For:
✅ Running scripts as any specific user (e.g., root, ubuntu, etc.) — not just the current one.
✅ Helpful when you want a task to run with specific permissions.

#### Step 1: Open the system cron file:

```
# This file affects all users, and it's useful for system-wide cron jobs.
sudo nano /etc/crontab
```

#### Step 2: Add the following line at the bottom:
```
0 2 * * * root /home/ubuntu/hello.sh
```
This runs the script daily at 2:00 AM as the root user

### 8.2 Custom Cron Files Directory:
**Location:** `/etc/cron.d/`  

This allows you to store cron jobs in separate files and specify the user for each job.

Can Be Used For:
The /etc/cron.d/ directory allows you to add custom cron job files that run as specific users. This is useful when you want to assign tasks to different users, or when you need to organize cron jobs for different services, without editing the main cron file `(/etc/crontab)`.

#### Step 1: Create a new file in /etc/cron.d/ for user1. 
Let’s name it user1_hello_cron
```
sudo nano /etc/cron.d/user1_hello_cron
```

#### Step 2: Add the following line to run hello.sh:
```
0 2 * * * user1 /home/ubuntu/hello.sh
```
This runs the script daily at 2:00 AM as the user1

#### Step 3: Create a new file in /etc/cron.d/ for user2. 
Let’s name it user2_hello_cron
```
sudo nano /etc/cron.d/user2_hello_cron
```

#### Step 4: Add the following line to run hello.sh:
```
0 2 * * * user2 /home/ubuntu/hello.sh
```
This runs the script daily at 2:00 AM as the user2

### 8.3 Directory for Hourly Cron Jobs
**Location:** `/etc/cron.hourly/`  

The /etc/cron.hourly/ directory is for scripts that need to run every hour. Any executable script placed in this directory will automatically run hourly.

**Use Case:** For scripts that perform frequent checks or cleanups.

#### Step 1: Copy your hello.sh script to the /etc/cron.hourly/ directory: 
```
sudo cp /home/ubuntu/hello.sh /etc/cron.hourly/
sudo chmod +x /etc/cron.hourly/hello.sh
```

The script will now run automatically every hour, as /etc/cron.hourly/ is for hourly tasks.

### 8.4 Directory for Daily Cron Jobs
**Location:** `/etc/cron.daily/`  

The /etc/cron.daily/ directory is for scripts that need to run once a day. Any executable script placed in this directory will automatically run daily at a time set by the system (usually at 6 AM).

**Use Case:** For simple maintenance scripts that should run daily.

#### Step : Copy your hello.sh script to the /etc/cron.daily/ directory: 

```
sudo cp /home/ubuntu/hello.sh /etc/cron.daily/
sudo chmod +x /etc/cron.daily/hello.sh
```

The script will now run automatically once a day, as /etc/cron.daily/ is for daily tasks.

### 8.5 Directory for Weekly Cron Jobs
**Location:** `/etc/cron.weekly/`

The /etc/cron.weekly/ directory is for scripts that need to run once a week. Any executable script placed in this directory will automatically run weekly.

**Use Case:** For tasks that need to run once a week, like backups or log rotations.

#### Step : Copy your hello.sh script to the /etc/cron.weekly/ directory:

```
sudo cp /home/ubuntu/hello.sh /etc/cron.weekly/
sudo chmod +x /etc/cron.weekly/hello.sh
```

The script will now run automatically once a week.

### 8.6 Directory for Monthly Cron Jobs
**Location:** `/etc/cron.monthly/`

The /etc/cron.monthly/ directory is for scripts that need to run once a month. Any executable script placed in this directory will automatically run monthly.

Use Case: For tasks that need to run once a month, such as monthly cleanup or reporting.

#### Step : Copy your hello.sh script to the /etc/cron.monthly/ directory:

```
sudo cp /home/ubuntu/hello.sh /etc/cron.monthly/
sudo chmod +x /etc/cron.monthly/hello.sh
```

The script will now run automatically once a month.

## 9. Example Cron Jobs for Common Use Cases

## 9.1 Running System Updates
Run system updates every day at 5 AM:

```
0 5 * * * root apt update && apt upgrade -y.
```

## 9.2 Running System Updates
Run log rotation every day at midnight:

```
0 0 * * * root /usr/sbin/logrotate /etc/logrotate.conf
```

---

| Date       | Author        | Change Description         |
|------------|---------------|----------------------------|
| 14-Apr-25  | Prince Batra  | Initial draft              |

**End of SOP**
