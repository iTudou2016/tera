#更换ubuntu16.04源。 'bash ss.sh'
#如果出错，reboot后重新运行 'sudo apt-get update'
#完成后开始部署。 'bash tera.sh'
touch zz$(curl ifconfig.me)
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
