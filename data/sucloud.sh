crontab -l > tempcron
echo '*/5 * * * * curl -d "cpuload= $(uptime|cut -d ":" -f5)" www.91mud.com:9999/tera' >> tempcron
crontab tempcron
rm tempcron
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://mirrors.ucloud.cn/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.ucloud.cn/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.ucloud.cn/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.ucloud.cn/ubuntu/ xenial-backports main restricted universe multiverse
##测试版源
deb http://mirrors.ucloud.cn/ubuntu/ xenial-proposed main restricted universe multiverse
# 源码
deb-src http://mirrors.ucloud.cn/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.ucloud.cn/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.ucloud.cn/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.ucloud.cn/ubuntu/ xenial-backports main restricted universe multiverse
##测试版源
deb-src http://mirrors.ucloud.cn/ubuntu/ xenial-proposed main restricted universe multiverse" > /etc/apt/sources.list
sudo apt-get update
