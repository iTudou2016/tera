crontab -l > tempcron
echo '*/5 * * * * curl -d "cpuload= $(uptime|cut -d ":" -f5)" www.91mud.com:9999/tera' >> tempcron
crontab tempcron
rm tempcron
