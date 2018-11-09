output() {
    printf "\E[0;33;40m"
    echo $1
    printf "\E[0m"
    sleep 2s
}

read -e -p "Enter mn folder : " mnfolder
read -e -p "Enter mn port : " mnport
read -e -p "Enter mn rpcport : " mnrpcport
read -e -p "Enter mn genkey : " mngenkey
read -e -p "Enter mn outputs : " mnoutputs
#read -e -p "Enter mn genkey : " mngenkey
mnip=$(curl ifconfig.me)

cd aywa
cp -r .aywa18 $mnfolder
cd $mnfolder
sudo sed -i 's/port=.*/port='$mnport'/' aywa.conf
sudo sed -i 's/rpcport=.*/rpcport='$mnrpcport'/' aywa.conf
sudo sed -i 's/externalip=.*/externalip='$mnip'/' aywa.conf
sudo sed -i 's/masternodeprivkey=.*/masternodeprivkey='$mngenkey'/' aywa.conf
sudo sed -i 's/aywa18.*/'$mnfolder' '$mnip':'$mnport' '$mngenkey' '$mnoutputs' 1/' masternode.conf

sudo apt-get update
sudo apt-get -y install python-virtualenv
git clone https://github.com/GetAywa/Aywa_Masternode/ && cd Aywa_Masternode/sentinel
virtualenv ./venv #(if locale.Error: unsupported locale setting: export LC_ALL=C)
./venv/bin/pip install -r requirements.txt
sudo sed -i 's/aywa_conf=.*/aywa_conf=/root/aywa/'$mnfolder'/aywa.conf' sentinel.conf
./root/aywa/aywad -datadir=/root/aywa/$mnfolder
pwd

echo 'crontab -e'
echo '* * * * * cd /home/YOURUSERNAME/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1'
