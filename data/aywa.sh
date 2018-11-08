wget -c 113.96.61.86:9999/aywa.tar.gz
tar xzvf aywa.tar.gz
cd aywa
tar xzvf aywac.tar.gz
tar xzvf block.tar.gz

sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
sudo apt-get install -y libminiupnpc-dev libzmq3-dev libboost-all-dev
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
