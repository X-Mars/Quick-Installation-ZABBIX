# Path: zabbix6/ubuntu-20.04.sh
#!/bin/bash
# Author: 火星小刘 / 中国青岛
# Install Zabbix 6.0 on Ubuntu 20.04

echo -e "\e[32mAuthor: \e[0m\e[33m火星小刘 / 中国青岛"
echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/"
echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX"
echo -e "\e[32m当前脚本介绍: \e[0m\e[33mInstall Zabbix 6.0 on Rocky Linux 8"

# 安装zabbix源，并替换为阿里云zabbix源
sudo apt update
sudo apt install wget gnupg2 -y
sudo wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu20.04_all.deb
sudo dpkg -i zabbix-release_6.0-4+ubuntu20.04_all.deb
sudo sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/apt/sources.list.d/zabbix.list
sudo sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/apt/sources.list.d/zabbix-agent2-plugins.list
sudo mv /etc/apt/sources.list.d/zabbix-agent2-plugins.list /etc/apt/sources.list.d/zabbix-agent2-plugins.list-bak

sudo apt update
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mariadb-server -y

sudo systemctl enable mariadb --now

# 安装数据库
sudo echo "create database zabbix character set utf8mb4 collate utf8mb4_bin;" | mysql -uroot
sudo echo "create user zabbix@localhost identified by 'huoxingxiaoliu';" | mysql -uroot
sudo echo "grant all privileges on zabbix.* to zabbix@localhost;" | mysql -uroot
sudo echo "set global log_bin_trust_function_creators = 1;" | mysql -uroot

# 导入初始化数据
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p huoxingxiaoliu zabbix
sudo sed -i 's/# DBPassword=/DBPassword=huoxingxiaoliu/g' /etc/zabbix/zabbix_server.conf

# 配置防火墙
sudo ufw allow 80/tcp
sudo ufw allow 10051/tcp
sudo ufw reload

sudo systemctl enable zabbix-server apache2 zabbix-agent --now

echo -e "数据库 \e[31mroot用户默认密码为空，zabbix用户默认密码 huoxingxiaoliu\e[0m"

# 获取ip
if command -v ip &> /dev/null; then
    # 使用ip命令获取IP地址并存储到ip变量
    ip=$(ip addr | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
else
    # 使用ifconfig命令获取IP地址并存储到ip变量
    ip=$(ifconfig | grep -oP 'inet\s+\K[\d.]+')
fi

# 使用for循环打印IP地址，并在每次打印后输出 "ok"
for i in $ip; do
    echo -e "访问继续下一步操作 \e[31mhttp://$i/zabbix\e[0m"
done

echo -e "默认用户名密码： \e[31mAdmin / zabbix\e[0m"