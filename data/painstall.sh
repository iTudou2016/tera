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
#HOSTIP='203.104.37.177'
HOSTIP='43.240.128.75'

output 'Time sync from ubuntu'
sudo apt-get update
sudo apt-get install -y gcc g++ make
sudo apt-get install -y ntp
echo "server ntp.ubuntu.com" >> /etc/ntp.conf
/etc/init.d/ntp start
touch $(curl ifconfig.me)

#output 'DNS hosts update'
#sudo apt-get install -y dnsutils
#fixDNS github.com
#fixDNS github.global.ssl.fastly.net
#fixDNS assets-cdn.github.com
#fixDNS github-cloud.s3.amazonaws.com
#sudo /etc/init.d/networking force-reload
output 'Nodejs/npm/pm2 setup'
#curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
#sudo apt-get install -y nodejs

wget -c $HOSTIP:9999/node8.12.tar.gz
tar xzvf node-v8.12.tar.gz -C /usr/local/
sudo ln -s /usr/local/nodejs/bin/node /usr/local/bin/node
sudo ln -s /usr/local/nodejs/bin/npm /usr/local/bin/npm
sudo npm install pm2 -g
sudo ln -s /usr/local/nodejs/bin/pm2 /usr/local/bin/pm2

output 'Tera/Data installation'
wget -c $HOSTIP:9999/wallet.zip
sudo apt-get install -y unzip
unzip wallet.zip
mv wallet-master wallet
cd wallet/Source
sudo npm install
sudo node set httpport: password:
cd
mv wallet/DATA wallet/x
wget -c $HOSTIP:9999/bc.tar.gz
tar xzvf bc.tar.gz
cp wallet/x/const.lst wallet/DATA/
cd wallet/Source
pm2 start run-node.js -n tera
