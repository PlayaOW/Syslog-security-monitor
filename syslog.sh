#Author: Rayhanul Karim
#Develpment date: 08/15/2025
#Program Name: syslog.sh
#Description: This script is used to monitor system logs and send alerts for critical issues.

#!/bin/bash

LOGIN_LOGS=$(grep "authorization failure" /var/log/auth.log)
COUNT=$(echo "$LOGIN_LOGS" | wc -l)
readonly EMAIL="RAYHANULKARIM313@GMAIL.COM"     #Email address of primary SysAdmin
if ! [[ -z "$LOGIN_LOGS" && "$COUNT" -le 10 ]]; then
    echo "Unauthorized login attempts detected."
    echo "$LOGIN_LOGS" | mail -s "Unauthorized Login Attempts and possible brute force attack detected" "$EMAIL"
    echo "Alert sent to $EMAIL"
    echo "Total unauthorized login attempts: $COUNT"
else
    echo "No unauthorized login attempts found."
fi