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
wget http://electromine.net/derod_database.db.tar.gz
tar -xvzf derod_database.db.tar.gz
mkdir /atlantis/testnet
cp derod_database.db /atlantis/testnet

### Stats Site Config
# Will use machine hostname, if you want change it after script is done
echo  "{\"myDaemon\":\"http://127.0.0.1:30306\",\"myName\":\"$(uname -n)\"}" > /atlantis/config.json

### Setup Crontab for auto start
crontab -l > mycron # will give a warning if cron not used before, ignore
echo "@reboot cd /atlantis/ && screen -S daemon -d -m  /./atlantis/derod-linux-amd64 --testnet" >> mycron
echo "@reboot cd /atlantis/ && screen -S stats -d -m /./atlantis/node-side-linux" >> mycron
crontab mycron
rm mycron

### Reboot for changes to take effect
sudo shutdown -r now
