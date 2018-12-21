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

sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python-virtualenv libminiupnpc-dev libzmq3-dev libboost-all-dev dnsutils
output 'DNS hosts update'
fixDNS github.com
fixDNS github.global.ssl.fastly.net
fixDNS assets-cdn.github.com
fixDNS github-cloud.s3.amazonaws.com
sudo /etc/init.d/networking force-reload

wget -c www.91mud.com:9999/aywasetup.tar.gz
tar xzvf aywasetup.tar.gz
cd aywa
wget -c www.91mud.com:9999/aywablock.tar.gz
tar xzvf aywablock.tar.gz
tar xzvf dbd.tar.gz
cd db-4.8.30.NC/build_unix/
../dist/configure --enable-cxx
make -j4
make install
cd
#Tell your system where to find db4.8 
export BDB_INCLUDE_PATH="/usr/local/BerkeleyDB.4.8/include"
export BDB_LIB_PATH="/usr/local/BerkeleyDB.4.8/lib"
ln -s /usr/local/BerkeleyDB.4.8/lib/libdb-4.8.so /usr/lib/libdb-4.8.so
ln -s /usr/local/BerkeleyDB.4.8/lib/libdb_cxx-4.8.so /usr/lib/libdb_cxx-4.8.so
output 'AYWA installation completed'
