# Path: openeuler.sh
#!/bin/bash
# Author: 火星小刘 / 中国青岛
# Install Zabbix 7.0 on Openeuler Linux 22.03 / 24.03

zabbix_version=7.0.18
zabbixdir=`pwd`

echo -e "\e[32mAuthor: \e[0m\e[33m火星小刘 / 中国青岛\e[0m"
echo -e "\e[32m加入QQ群一起开车一起学习: \e[0m\e[33m523870446\e[0m"
echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/\e[0m"
echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477\e[0m"
echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX\e[0m"
echo -e "\e[32m当前脚本介绍: \e[0m\e[33mInstall Zabbix 7.0 on Openeuler Linux 22.03 / 24.03 \e[0m"

# 获取操作系统信息，下载对应版本zabbix源码包
# 检查 /etc/os-release 文件是否存在
echo '检查操作系统版本...'
if [ -e /etc/os-release ]; then
    source /etc/os-release
    openeuler_version=$(echo "$VERSION_ID" | cut -d'.' -f1)
    if ( [ "$ID" == "openEuler" ] && ( [ "$openeuler_version" == "22" ] || [ "$openeuler_version" == "24" ] ) ); then
        # 下载zabbix 源码 包
        echo "操作系统版本为 Openeuler Linux $openeuler_version"
        curl -O https://cdn.zabbix.com/zabbix/sources/stable/7.0/zabbix-${zabbix_version}.tar.gz
    else
        echo "不支持的操作系统版本，脚本停止运行。"
        exit 1
    fi
else
    echo "无法找到 /etc/os-release 文件，脚本无法运行。"
    exit 1
fi

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)

echo '更换阿里云源'
sed -e 's|^metalink=|#metalink=|g' -e 's|^baseurl=http://repo.openeuler.org/|baseurl=https://mirrors.aliyun.com/openeuler/|g' -e 's|^gpgkey=http://repo.openeuler.org/|gpgkey=https://mirrors.aliyun.com/openeuler/|g' -i.bak /etc/yum.repos.d/openEuler.repo
sleep 3

echo '添加zabbix用户'
groupadd --system zabbix
useradd --system -g zabbix -d /usr/lib/zabbix -s /sbin/nologin -c "Zabbix Monitoring System" zabbix
mkdir /var/log/zabbix
chown zabbix:zabbix -R /var/log/zabbix

sudo dnf install git make pcre-devel pcre libevent libevent-devel openssl openssl-devel pv gcc libxml2 libxml2-devel curl curl-devel java-devel httpd wget php php-common php-cli php-fpm php-common php-mysqlnd php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-xmlwriter php-xmlreader php-ldap gcc mysql-server mysql-devel httpd tar libxml2-devel libxml2 libxml2-devel -y

# 安装数据库
sudo systemctl enable mysqld --now

# 安装snmp
echo '安装snmp...'
if [ "$openeuler_version" == "22" ]; then
    if [ ! -f net-snmp-5.9.4.tar.gz ]; then
        curl -L -o net-snmp-5.9.4.tar.gz https://sourceforge.net/projects/net-snmp/files/net-snmp/5.9.4/net-snmp-5.9.4.tar.gz/download
    fi

        tar zxvf net-snmp-5.9.4.tar.gz 
        cd net-snmp-5.9.4
        ./configure --with-default-snmp-version="2"  --with-systemd --with-sys-contact="who@where" --with-sys-location="location" --with-logfile="/var/log/snmpd.log" --with-persistent-directory="/var/net-snmp"

        make -j$CPU_NUM

        make install

        echo "/usr/local/lib" >> /etc/ld.so.conf
        cat /etc/ld.so.conf
        sudo ldconfig
        ldconfig -p | grep /usr/local/lib

        cd ..
else
    sudo dnf install net-snmp net-snmp-utils net-snmp-libs net-snmp-devel -y
fi

echo '初始化数据库...'
sudo echo "create database zabbix character set utf8mb4 collate utf8mb4_bin;" | mysql -uroot
sudo echo "create user zabbix@localhost identified by 'huoxingxiaoliu';" | mysql -uroot
sudo echo "grant all privileges on zabbix.* to zabbix@localhost;" | mysql -uroot
sudo echo "set global log_bin_trust_function_creators = 1;" | mysql -uroot

# 安装zabbix
echo "安装zabbix-${zabbix_version}"
tar zxvf $zabbixdir/zabbix-${zabbix_version}.tar.gz
cd $zabbixdir/zabbix-${zabbix_version}
echo `pwd`
./configure --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2 --enable-java

make -j$CPU_NUM

make install

echo "拷贝php文件"
mkdir -p /var/log/zabbix
mkdir -p /var/www/html/zabbix
cp -r $zabbixdir/zabbix-${zabbix_version}/ui/* /var/www/html/zabbix
cp /var/www/html/zabbix/conf/zabbix.conf.php.example /var/www/html/zabbix/conf/zabbix.conf.php
sed -i "s/\$DB\['PASSWORD'\]\s*=\s*'';/\$DB\['PASSWORD'\] = 'huoxingxiaoliu';/" /var/www/html/zabbix/conf/zabbix.conf.php

echo "导入zabbix数据库"

cd $zabbixdir/zabbix-${zabbix_version}
mysql -uzabbix -phuoxingxiaoliu -hlocalhost zabbix < database/mysql/schema.sql
mysql -uzabbix -phuoxingxiaoliu -hlocalhost zabbix < database/mysql/images.sql
mysql -uzabbix -phuoxingxiaoliu -hlocalhost zabbix < database/mysql/data.sql

sed -i '/# DBPassword=/a\DBPassword=huoxingxiaoliu' /usr/local/etc/zabbix_server.conf

echo "设置php.ini相关参数"
sleep 3
cp /etc/php.ini /etc/php.ini.zabbixbak
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php.ini
sed -i '/max_input_time =/s/60/300/' /etc/php.ini
sed -i '/mbstring.func_overload = 0/a\mbstring.func_overload = 1' /etc/php.ini
sed -i '/post_max_size =/s/8M/32M/' /etc/php.ini
sed -i '/;always_populate_raw_post_data = -1/a\always_populate_raw_post_data = -1' /etc/php.ini
sed -i '/;date.timezone =/a\date.timezone = PRC' /etc/php.ini

echo "配置zabbix 日志"
sed -i 's#^LogFile=.*#LogFile=/var/log/zabbix/zabbix_server.log#' /usr/local/etc/zabbix_server.conf
sed -i 's#^LogFile=.*#LogFile=/var/log/zabbix/zabbix_agentd.log#' /usr/local/etc/zabbix_agentd.conf

echo "设置开机启动"
cat > /usr/lib/systemd/system/zabbix-server.service <<EOF
[Unit]
Description=Zabbix Server
After=syslog.target
After=network.target
After=mysql.service
After=mysqld.service
After=mariadb.service
After=postgresql.service
After=pgbouncer.service
After=postgresql-9.4.service
After=postgresql-9.5.service
After=postgresql-9.6.service
After=postgresql-10.service
After=postgresql-11.service
After=postgresql-12.service
After=postgresql-13.service
After=postgresql-14.service
After=postgresql-15.service
After=postgresql-16.service

[Service]
Environment="CONFFILE=/usr/local/etc/zabbix_server.conf"
EnvironmentFile=-/etc/sysconfig/zabbix-server
Type=forking
Restart=on-failure
PIDFile=/tmp/zabbix_server.pid
KillMode=control-group
ExecStart=/usr/local/sbin/zabbix_server -c \$CONFFILE
ExecStop=/bin/kill -SIGTERM \$MAINPID
RestartSec=10s
TimeoutSec=0

[Install]
WantedBy=multi-user.target
EOF

cat > /usr/lib/systemd/system/zabbix-agent.service <<EOF
[Unit]
Description=Zabbix Agent
After=syslog.target
After=network.target

[Service]
Environment="CONFFILE=/usr/local/etc/zabbix_agentd.conf"
EnvironmentFile=-/etc/sysconfig/zabbix-agent
Type=forking
Restart=on-failure
PIDFile=/tmp/zabbix_agentd.pid
KillMode=control-group
ExecStart=/usr/local/sbin/zabbix_agentd -c \$CONFFILE
ExecStop=/bin/kill -SIGTERM \$MAINPID
RestartSec=10s
User=zabbix
Group=zabbix

[Install]
WantedBy=multi-user.target
EOF

sudo echo "set global log_bin_trust_function_creators = 0;" | mysql -uroot

# 修改php时区
sudo sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/g' /etc/php.ini

# 配置防火墙
echo '配置防火墙...'
sudo firewall-cmd --permanent --add-port={80/tcp,10051/tcp}
sudo firewall-cmd --reload

# 配置selinux
echo '配置selinux...'
sudo setsebool -P httpd_can_connect_zabbix on
sudo sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
sudo setenforce 0

sudo chown -R apache:apache /var/www/html/zabbix

echo "解决图表中文乱码问题..."

cd $zabbixdir
cp simkai.ttf /var/www/html/zabbix/assets/fonts
sed -i "s/DejaVuSans/simkai/g" /var/www/html/zabbix/include/defines.inc.php

echo "启动zabbix"
systemctl enable zabbix-server zabbix-agent --now
/usr/local/sbin/zabbix_java/startup.sh
systemctl enable httpd mysqld --now

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

echo -e "牢记以下启动命令，重启服务器时可能会用到： \e[31m \n /usr/local/sbin/zabbix_java/startup.sh\e[0m"

echo -e "\e[32m\n\nAuthor: \e[0m\e[33m火星小刘 / 中国青岛\e[0m"
echo -e "\e[32m加入QQ群一起开车一起学习: \e[0m\e[33m523870446\e[0m"
echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/\e[0m"
echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477\e[0m"
echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX\e[0m"

echo -e "\n\e[31m拉取企业微信、钉钉、飞书告警脚本，具体查看：https://github.com/X-Mars/Zabbix-Alert-WeChat\e[0m"
echo -e "\e[31m此操作不影响zabbix使用\e[0m"
echo -e "\e[31m运行命令：ls -la /usr/local/share/zabbix/alertscripts 查看脚本\e[0m"
git clone https://github.com/X-Mars/Zabbix-Alert-WeChat.git /usr/local/share/zabbix/alertscripts
