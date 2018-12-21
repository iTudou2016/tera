pm2 stop 0
rm bc.tar.gz
wget www.91mud.com:9999/bc.tar.gz
cp wallet/DATA/const.lst wallet/
rm -r wallet/DATA
tar xzvf bc.tar.gz
cp wallet/const.lst wallet/DATA/
pm2 start 0
