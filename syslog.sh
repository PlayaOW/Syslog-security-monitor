#Author: Rayhanul Karim
#Develpment date: 08/15/2025
#Program Name: syslog.sh
#Description: This script is used to monitor system logs and send alerts for critical issues.

#!/bin/bash
readonly EMAIL="RAYHANULKARIM313@GMAIL.COM"     #Email address of primary SysAdmin

auth_failure_test(){
    LOGIN_LOGS=$(grep "authorization failure" /var/log/auth.log)
    COUNT=$(echo "$LOGIN_LOGS" | wc -l)
    if ! [[ -z "$LOGIN_LOGS" && "$COUNT" -le 10 ]]; then
        echo "Unauthorized login attempts detected."
        echo "$LOGIN_LOGS" | mail -s "Unauthorized Login Attempts and possible brute force attack detected" "$EMAIL"
        echo "Alert sent to $EMAIL"
        echo "Total unauthorized login attempts: $COUNT"
        echo "Shutting down the system to prevent further unauthorized access."
        shutdown -h now
    else
        echo "No unauthorized login attempts found."
    fi
}

# Determining Resource contention and sending out report to SysAdmin
Resource_Contention(){
    TOP_PROCESSES_CPU=$(ps -eo user,pid,uid,comm,pcpu,pmem --sort=-pcpu | head -n 11) # Selects all processes and formats the output, sorts by CPU usage.
    TOP_PROCESSES_MEM=$(ps -eo user,pid,uid,comm,pcpu,pmem --sort=-pmem | head -n 11) # Selects all processes and formats the output, sorts by Memory Usage.

    SWAP_USAGE=$(top -b -n 1 | grep "MiB Swap" | awk '{print $4}')

    if ! [[ -z "$TOP_PROCESSES_CPU" && -z "$TOP_PROCESSES_MEM" && -z "$SWAP_USAGE" ]]; then
        echo "Resource contention detected in the system $(whoami) at $(date)"
        echo "Top 10 processes by CPU usage: " $TOP_PROCESSES_CPU
        echo "Top 10 processes by Memory usage: " $TOP_PROCESSES_MEM
        echo "Current Swap usage: $SWAP_USAGE MiB"
        echo "Sending report to $EMAIL"
        echo -e "Resource contention detected in the system $(whoami) at $(date)\
        \nTop 10 processes by CPU usage:\n$TOP_PROCESSES_CPU\nTop 10 processes by Memory usage:\n$TOP_PROCESSES_MEM\n\
        Current Swap usage: $SWAP_USAGE MiB" | mail -s "Resource contention detected in the system $(whoami)" "$EMAIL"
        echo "Report sent to $EMAIL"
    else
        echo "No resource contention detected."
    fi
}

ssh_connection_efforts(){
    SSH_LOGS=$(grep "Failed password for" /var/log/auth.log)
    FAILED_IPS=$(echo "$SSH_LOGS" | awk '{print $11}' | sort | uniq -c | sort -nr)
    COUNT=$(echo "$SSH_LOGS" | wc -l)
    if ! [[ -z "$SSH_LOGS" && "$COUNT" -le 10 ]]; then
        echo "Multiple failed SSH login attempts detected."
        echo "Failed login attempts details:"
        echo "$SSH_LOGS"
        echo "Failed login attempts by IP address:"
        echo "$FAILED_IPS"
        echo "Sending alert to $EMAIL"
        echo -e "Multiple failed SSH login attempts detected in the system $(whoami) at $(date)\
        \nFailed login attempts details:\n$SSH_LOGS\nFailed login attempts by IP address:\n$FAILED_IPS" | mail -s "Multiple Failed SSH Login Attempts Detected" "$EMAIL"
        echo "Alert sent to $EMAIL"
        echo "Total failed SSH login attempts: $COUNT"
    else
        echo "No multiple failed SSH login attempts found."
    fi
}

print_manual(){
    cat <<EOF
------------------------------------------------------------
                SYSLOG.SH - SYSTEM LOG MONITOR
------------------------------------------------------------
Author: Rayhanul Karim
Development Date: 08/15/2025
Email: RAYHANULKARIM313@GMAIL.COM

Description:
    This script monitors system logs and sends email alerts to the
    system administrator for the following critical events:
    - Authorization failures
    - Resource contention (CPU, memory, swap)
    - SSH brute-force login attempts

USAGE:
    ./syslog.sh "Authorization Failure Test"
        - Detects unauthorized login attempts from auth.log.
        - Sends an alert email if more than 10 failures are found.
        - Shuts down the system if attack suspected.

    ./syslog.sh "Resource Contention"
        - Checks for top CPU and memory-consuming processes.
        - Reports current swap usage.
        - Sends a detailed resource usage report via email.

    ./syslog.sh "SSH Connection Efforts"
        - Monitors failed SSH login attempts.
        - Displays attacking IPs and sends an alert email.

    ./syslog.sh man
        - Displays this help manual.

REQUIREMENTS:
    Must be run with root privileges to access /var/log/auth.log
    Dependencies: grep, awk, ps, top, mail, shutdown

NOTE:
    Configure your mail system (e.g., sendmail or postfix)
    for the script to successfully send emails.

------------------------------------------------------------
EOF
}


case $1 in
    "Authorization Failure Test")
        auth_failure_test
        ;;
    "Resource Contention")
        Resource_Contention
        ;;
    "SSH Connection Efforts")
        ssh_connection_efforts
        ;;
    "Manual")
        print_manual
        ;;
    *)
        echo "Usage: $0 {Authorization Failure Test|Resource Contention|SSH Connection Efforts|Manual}"
        exit 1
        ;;
esac


