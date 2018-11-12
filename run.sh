mv ../bc.tar.gz data/
mv ../wallet.zip data/
mv ../node-v8.12.tar.gz data/
pm2 start index.js -n home
