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
HOSTIP='www.91mud.com:9999'
#MYIPEX=$(curl www.icanhazip.com)
MYIPEX=$(curl www.91mud.com:9999/tera/ip)
touch zz${MYIPEX}
output 'Time sync from ubuntu'
sudo apt-get update
sudo apt-get install -y gcc g++ make python ntp
echo "server ntp.ubuntu.com" >> /etc/ntp.conf
/etc/init.d/ntp start
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
#wget -c $HOSTIP:9999/wallet.zip
#sudo apt-get install -y unzip
#unzip -q wallet.zip
#mv wallet-master wallet
git clone --depth=1 https://github.com/terafoundation/wallet.git
cd wallet/Source
sudo npm install
sudo node set httpport:33333 password:393131
cd
mv wallet/DATA wallet/x
wget -c $HOSTIP/bc.tar.gz
tar xzf bc.tar.gz
cp wallet/x/const.lst wallet/DATA/
sed -i 's/"USE_MINING": 0,/"USE_MINING": true,/' wallet/DATA/const.lst
sed -i 's/"POW_MAX_PERCENT": 50,/"POW_MAX_PERCENT": 100,/' wallet/DATA/const.lst
sed -i 's/"STAT_MODE": 0,/  "NET_WORK_MODE": {\n    "ip": "'${MYIPEX}'",\n    "port": 30000,\n    "UseDirectIP": true,\n    "NodeWhiteList": "",\n    "DoRestartNode": 1\n  },\n  "STAT_MODE": 0,/' wallet/DATA/const.lst
cd wallet/Source
pm2 start run-node.js -n tera
