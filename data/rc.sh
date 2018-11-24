pm2 stop 0
mv tera/data/bc.tar.gz .
rm -r wallet/DATA
tar xzvf bc.tar.gz
cp wallet/x/const.lst wallet/DATA/
sed -i 's/"USE_MINING": 0,/"USE_MINING": true,/' wallet/DATA/const.lst
sed -i 's/"POW_MAX_PERCENT": 50,/"POW_MAX_PERCENT": 100,/' wallet/DATA/const.lst
sleep 3s
sed -i 's/"STAT_MODE": 0,/  "NET_WORK_MODE": {\n    "ip": "'$(curl ifconfig.me)'",\n    "port": 30000,\n    "UseDirectIP": true,\n    "NodeWhiteList": ""
,\n    "DoRestartNode": 1\n  },\n  "STAT_MODE": 0,/' wallet/DATA/const.lst
cd wallet/Source
pm2 start 0
