#!/bin/bash
set -eu

cnf=/etc/zabbix/zabbix_agent2.conf

wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
sudo apt update
sudo apt -y install zabbix-agent2
sudo cp $cnf ${cnf}.bkp
echo "PidFile=/var/run/zabbix/zabbix_agent2.pid
LogFile=/var/log/zabbix/zabbix_agent2.log
LogFileSize=0
Server=127.0.0.1
ServerActive=zabbix-active.example.com
Hostname=somehostname
Include=/etc/zabbix/zabbix_agent2.d/*.conf
PluginSocket=/run/zabbix/agent.plugin.sock
ControlSocket=/run/zabbix/agent.sock
Include=./zabbix_agent2.d/plugins.d/*.conf
" | sudo tee $cnf

sudo systemctl restart zabbix-agent2
sleep 10
tail -n 10 /var/log/zabbix/zabbix_agent2.log
