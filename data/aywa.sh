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

read -e -p "Enter mn folder : " mnfolder
read -e -p "Enter mn port : " mnport
read -e -p "Enter mn rpcport : " mnrpcport
read -e -p "Enter mn genkey : " mngenkey
read -e -p "Enter mn outputs : " mnoutputs
#read -e -p "Enter mn genkey : " mngenkey
mnip=$(curl ifconfig.me)

output 'DNS hosts update'
sudo apt-get install -y dnsutils
fixDNS github.com
fixDNS github.global.ssl.fastly.net
fixDNS assets-cdn.github.com
fixDNS github-cloud.s3.amazonaws.com
sudo /etc/init.d/networking force-reload

sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
sudo apt-get install -y libminiupnpc-dev libzmq3-dev libboost-all-dev
wget -c 113.96.61.86:9999/aywa.tar.gz
tar xzvf aywa.tar.gz
cd aywa
tar xzvf aywac.tar.gz
tar xzvf block.tar.gz
cp -r .aywa18 $mnfolder
tar xzvf dbd.tar.gz
cd db-4.8.30.NC/build_unix/
../dist/configure --enable-cxx
make
make install
#Tell your system where to find db4.8 
export BDB_INCLUDE_PATH="/usr/local/BerkeleyDB.4.8/include"
export BDB_LIB_PATH="/usr/local/BerkeleyDB.4.8/lib"
ln -s /usr/local/BerkeleyDB.4.8/lib/libdb-4.8.so /usr/lib/libdb-4.8.so
ln -s /usr/local/BerkeleyDB.4.8/lib/libdb_cxx-4.8.so /usr/lib/libdb_cxx-4.8.so
#./aywa-cli -datadir=.aywa17
cd ../../$mnfolder

sudo apt-get update
sudo apt-get -y install python-virtualenv
git clone https://github.com/GetAywa/Aywa_Masternode/ && cd Aywa_Masternode/sentinel
virtualenv ./venv #(if locale.Error: unsupported locale setting: export LC_ALL=C)
./venv/bin/pip install -r requirements.txt
pwd

# crontab -e
# * * * * * cd /home/YOURUSERNAME/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1


