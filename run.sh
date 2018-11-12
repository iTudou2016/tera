mv ../bc.tar.gz data/
mv ../wallet.zip data/
mv ../node-v8.12.tar.gz data/
sudo npm install
pm2 start index.js -n home
