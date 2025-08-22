# Syslog-security-monitor
# SYSLOG.SH - System Log Monitoring Script

**Author**: Rayhanul Karim  
**Development Date**: 08/15/2025  
**Email**: RAYHANULKARIM313@GMAIL.COM  

## 📜 Description

`syslog.sh` is a Bash script designed to monitor critical system logs and send email alerts to the system administrator. It proactively checks for:

- Unauthorized login attempts
- SSH brute-force login attacks
- Resource contention (CPU, memory, swap usage)

In the event of a security threat or system resource issue, the script can notify the sysadmin via email—and in extreme cases, it will shut down the system to prevent further damage.

---

## 🚀 Features

- **Authorization Failure Detection**  
  Detects unauthorized login attempts. If more than 10 attempts are detected, the script sends an alert and shuts down the system.

- **Resource Contention Reporting**  
  Lists the top CPU and memory-consuming processes and reports current swap usage via email.

- **SSH Brute Force Attack Monitoring**  
  Monitors failed SSH login attempts, identifies attacking IPs, and sends an alert.

- **Help Manual**  
  Displays a built-in manual with usage instructions and requirements.

---

## 🛠️ Usage

Run the script with one of the following arguments:

```bash
./syslog.sh "Authorization Failure Test"
./syslog.sh "Resource Contention"
./syslog.sh "SSH Connection Efforts"
./syslog.sh Manual


