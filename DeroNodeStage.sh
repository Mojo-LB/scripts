## Check if First run, otherwise exit

{
if [  -f /atlantis/stats.sh ]; then
    echo "Not First run, exitting"
    exit 0
fi
}

### Staging
sudo apt install screen  -y
wget https://git.dero.io/DeroProject/dero-stats-client/raw/master/node-side-linux.tar.gz
wget https://git.dero.io/DeroProject/atlantis-testnet/raw/master/dero_linux_amd64.tar.gz
tar -xvzf dero_linux_amd64.tar.gz
tar -xvzf node-side-linux.tar.gz
sudo mkdir /atlantis
sudo chmod 777 /atlantis 
cp node-side-linux /atlantis/ 
cp dero_linux_amd64/* /atlantis 

## Stage Testnet/Mainnet folder - Uncomment and adjust links accordingly
#wget http://seeds.dero.io/testnet/blockchain/derod_database.db.zip
#sudo apt install unzip -y
#unzip derod_database.db.zip
#mkdir /atlantis/testnet
#cp derod_database.db /atlantis/testnet

### Stats Site Script
touch /atlantis/stats.sh
echo "HOST=\$(uname -n)" >> /atlantis/stats.sh
echo "cd /atlantis" >> /atlantis/stats.sh
echo "echo  {\\\"myDaemon\\\":\\\"http://127.0.0.1:30306\\\",\\\"myName\\\":\\\"\$HOST \\\"} > config.json" > /atlantis/stats.sh
echo "/./atlantis/node-side-linux" >> /atlantis/stats.sh

### Setup Crontab for auto start
#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "@reboot cd /atlantis/ && screen -S daemon -d -m  /./atlantis/derod-linux-amd64 --testnet" >> mycron
echo "@reboot cd /atlantis/ && screen -S stats -d -m sh stats.sh" >> mycron
#install new cron file
crontab mycron
rm mycron

### Reboot for changes to tae effect
sudo shutdown -r now
