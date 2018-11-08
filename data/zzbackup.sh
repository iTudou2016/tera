pm2 stop tera
sleep 3s
tar czvf tera/data/bc.tar.gz wallet/DATA
sleep 3s
pm2 start tera
cat tera/data/setup
