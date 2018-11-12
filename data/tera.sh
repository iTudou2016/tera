output() {
    printf "\E[0;33;40m"
    echo $1
    printf "\E[0m"
    sleep 2s
}
fixDNS() {
output 'updateDNS: '$1''
sed -i '/'$1'/d' /etc/hosts
nslookup $1|grep 'Address: .*'|sed -e 's/^Address: //' -n -e '1s/.*/& '$1'/p' >> /etc/hosts
}

echo 注意3个文件的格式！！！
echo node-v8.12.tar.gz
echo wallet.zip
echo bc.tar.gz。在有tera的根目录执行压缩命令，备份wallet/DATA文件夹：'tar czvf bc.tar.gz wallet/DATA'

#更新放3个下载文件的服务器地址。
HOSTIP='10.1.171.8:9999'
#更新http登录的port和password。这里会用到sudo node set httpport:'$HTTPPORT' password:'$PASSWD'
HTTPPORT=33333
PASSWD=666666

output 'Time sync from ubuntu'
sudo apt-get update
sudo apt-get install -y gcc g++ make
sudo apt-get install -y ntp
echo "server ntp.ubuntu.com" >> /etc/ntp.conf
/etc/init.d/ntp start
touch zz$(curl ifconfig.me)
output 'DNS hosts update'
sudo apt-get install -y dnsutils
fixDNS github.com
fixDNS github.global.ssl.fastly.net
fixDNS assets-cdn.github.com
fixDNS github-cloud.s3.amazonaws.com
sudo /etc/init.d/networking force-reload

output 'Nodejs/npm/pm2 setup'
wget -c $HOSTIP/node-v8.12.tar.gz
tar xzf node-v8.12.tar.gz -C /usr/local
sudo ln -s /usr/local/nodejs/bin/node /usr/local/bin/node
sudo ln -s /usr/local/nodejs/bin/npm /usr/local/bin/npm
sudo npm install pm2 -g
sudo ln -s /usr/local/nodejs/bin/pm2 /usr/local/bin/pm2

output 'Tera/Data installation'
wget -c $HOSTIP/wallet.zip
sudo apt-get install -y unzip
unzip -q wallet.zip
mv wallet-master wallet
cd wallet/Source
sudo npm install
sudo node set httpport:'$HTTPPORT' password:'$PASSWD'
cd
mv wallet/DATA wallet/x
wget -c $HOSTIP/bc.tar.gz
tar xzf bc.tar.gz
cp wallet/x/const.lst wallet/DATA/
sed -i 's/"USE_MINING": 0,/"USE_MINING": true,/' wallet/DATA/const.lst
sed -i 's/"POW_MAX_PERCENT": 50,/"POW_MAX_PERCENT": 100,/' wallet/DATA/const.lst
sed -i 's/"STAT_MODE": 0,/  "NET_WORK_MODE": {\n    "ip": "'$(curl ifconfig.me)'",\n    "port": 30000,\n    "UseDirectIP": true,\n    "NodeWhiteList": "",\n    "DoRestartNode": 1\n  },\n  "STAT_MODE": 0,/' wallet/DATA/const.lst
cd wallet/Source
pm2 start run-node.js -n tera
pm2 log tera
