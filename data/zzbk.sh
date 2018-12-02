#备份最新blockchain
pm2 stop 0
sleep 3s
tar czvf tera/data/bc.tar.gz wallet/DATA
sleep 3s
pm2 start 0
cat tera/data/setup
