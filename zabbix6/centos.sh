# Path: zabbix6/centos-7.sh
#!/bin/bash
# Author: 火星小刘 / 中国青岛
# Install Zabbix 6.0 on Centos Linux 8 / 9

echo -e "\e[32mAuthor: \e[0m\e[33m火星小刘 / 中国青岛"
echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/"
echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477"
echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX"
echo -e "\e[32m当前脚本介绍: \e[0m\e[33mInstall Zabbix 6.0 on Centos Linux 8 / 9"

# 获取操作系统信息，下载对应版本zabbix源码包
# 检查 /etc/os-release 文件是否存在
echo '检查操作系统版本...'
if [ -e /etc/os-release ]; then
    source /etc/os-release
    centos_version=$(echo "$VERSION_ID" | cut -d'.' -f1)
    if [ "$ID" == "centos" ] && ( [ "$VERSION_ID" == "8" ] || [ "$VERSION_ID" == "9" ]); then
        dnf install epel-release -y
        # 下载zabbix 源码 包
        echo "操作系统版本为 Centos Linux $centos_version"
        curl -O https://mirrors.aliyun.com/zabbix/zabbix/6.0/rhel/${VERSION_ID}/x86_64/zabbix-release-6.0-4.el${VERSION_ID}.noarch.rpm
        rpm -ivh zabbix-release-6.0-4.el${VERSION_ID}.noarch.rpm
        if [ "$VERSION_ID" == "9" ]; then
          sudo sed -i '/^\[epel\]/a excludepkgs=zabbix*' /etc/yum.repos.d/epel.repo
        fi
    else
        echo "不支持的操作系统版本，脚本停止运行。"
        exit 1
    fi
else
    echo "无法找到 /etc/os-release 文件，脚本无法运行。"
    exit 1
fi

# 安装zabbix源
sudo sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/yum.repos.d/zabbix.repo
sudo sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/yum.repos.d/zabbix-agent2-plugins.repo
sudo mv /etc/yum.repos.d/zabbix-agent2-plugins.repo /etc/yum.repos.d/zabbix-agent2-plugins.repo-bak

# 安装mariadb源
echo '安装mariadb源...'
sudo curl -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version=11.0

sudo dnf clean all
sudo dnf makecache

# 安装数据库、zabbix
sudo dnf install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent MariaDB-server MariaDB-client MariaDB-backup MariaDB-devel langpacks-zh_CN -y
sudo systemctl enable mariadb --now

echo '初始化数据库...'
sudo echo "create database zabbix character set utf8mb4 collate utf8mb4_bin;" | mariadb -uroot
sudo echo "create user zabbix@localhost identified by 'huoxingxiaoliu';" | mariadb -uroot
sudo echo "grant all privileges on zabbix.* to zabbix@localhost;" | mariadb -uroot
sudo echo "set global log_bin_trust_function_creators = 1;" | mariadb -uroot

# 导入初始化数据
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mariadb --default-character-set=utf8mb4 -uzabbix -phuoxingxiaoliu zabbix
sudo sed -i 's/# DBPassword=/DBPassword=huoxingxiaoliu/g' /etc/zabbix/zabbix_server.conf
sudo echo "set global log_bin_trust_function_creators = 0;" | mariadb -uroot

# 配置防火墙
echo '配置防火墙...'
sudo firewall-cmd --permanent --add-port={80/tcp,10051/tcp}
sudo firewall-cmd --reload
systemctl restart zabbix-server zabbix-agent httpd php-fpm
systemctl enable zabbix-server zabbix-agent httpd php-fpm

# 配置selinux
echo '配置selinux...'
sudo sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
sudo setenforce 0

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

echo -e "\e[32m\n\nAuthor: \e[0m\e[33m火星小刘 / 中国青岛"
echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/"
echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477"
echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX"
