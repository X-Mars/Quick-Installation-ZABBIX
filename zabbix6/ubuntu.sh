# Path: zabbix6/ubuntu.sh
#!/bin/bash
# Author: 火星小刘 / 中国青岛
# Install Zabbix 6.0 on Ubuntu 20.04 / 22.04"

echo -e "\e[32mAuthor: \e[0m\e[33m火星小刘 / 中国青岛"
echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/"
echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477"
echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX"
echo -e "\e[32m当前脚本介绍: \e[0m\e[33mInstall Zabbix 6.0 on Ubuntu 20.04 / 22.04"

# 获取操作系统信息，安装对应版本zabbix源，并替换为阿里云zabbix源
# 检查 /etc/os-release 文件是否存在
echo '检查操作系统版本...'
if [ -f /etc/os-release ]; then
    # 导入 /etc/os-release 文件
    . /etc/os-release
    # 检查 ID 是否为 "ubuntu" 并且 VERSION_ID 是否定义
    if [ "$ID" == "ubuntu" ] && [ -n "$VERSION_ID" ]; then
        # 构建下载URL并下载 zabbix-release 包
        zabbix_release_url="https://mirrors.aliyun.com/zabbix/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu${VERSION_ID}_all.deb"
        curl -O "$zabbix_release_url"
        sudo dpkg -i "zabbix-release_6.0-4+ubuntu${VERSION_ID}_all.deb"
        echo "已下载适用于 Ubuntu $VERSION_ID 的 zabbix-release 包。"
    else
        echo "不支持的操作系统版本，脚本停止运行。"
        exit 1
    fi
else
    echo "无法找到 /etc/os-release 文件，脚本无法运行。"
    exit 1
fi

sudo sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/apt/sources.list.d/zabbix.list
sudo sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/apt/sources.list.d/zabbix-agent2-plugins.list
sudo mv /etc/apt/sources.list.d/zabbix-agent2-plugins.list /etc/apt/sources.list.d/zabbix-agent2-plugins.list-bak

# 安装mariadb源
echo '安装mariadb源...'
sudo curl -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup --mariadb-server-version=11.0

# 安装zabbix、中文语言包、数据库
echo 'zabbix、中文语言包、数据库...'
sudo apt update
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mariadb-server mariadb-client language-pack-zh-hans -y

sudo systemctl enable mariadb

# 初始化数据库

echo '初始化数据库...'
sudo echo "create database zabbix character set utf8mb4 collate utf8mb4_bin;" | mariadb -uroot
sudo echo "create user zabbix@localhost identified by 'huoxingxiaoliu';" | mariadb -uroot
sudo echo "grant all privileges on zabbix.* to zabbix@localhost;" | mariadb -uroot
sudo echo "set global log_bin_trust_function_creators = 1;" | mariadb -uroot

# 导入初始化数据
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mariadb --default-character-set=utf8mb4 -uzabbix -phuoxingxiaoliu zabbix
sudo sed -i 's/# DBPassword=/DBPassword=huoxingxiaoliu/g' /etc/zabbix/zabbix_server.conf

sudo echo "set global log_bin_trust_function_creators = 0;" | mariadb -uroot

# 检查防火墙是否运行，配置防火墙
echo '检查防火墙'
# 检查是否存在ufw命令
if command -v ufw &>/dev/null; then
    echo "ufw已安装在系统中."

    # 检查ufw是否已启用
    if sudo ufw status | grep -q "Status: active"; then
        echo "ufw已启用，配置防火墙..."
        sudo ufw allow 80/tcp
        sudo ufw allow 10051/tcp
        sudo ufw reload
    else
        echo "ufw未启用."
    fi
else
    echo "ufw未安装在系统中."
fi

sudo systemctl restart zabbix-server apache2 zabbix-agent
sudo systemctl enable zabbix-server apache2 zabbix-agent

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
    echo -e "访问继续下一步操作 \e[31mhttp://$i/zabbix/ (注意最后的/为必须)\e[0m"
done

echo -e "默认用户名密码： \e[31mAdmin / zabbix\e[0m"

echo -e "\e[32m\n\nAuthor: \e[0m\e[33m火星小刘 / 中国青岛"
echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/"
echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477"
echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX"
