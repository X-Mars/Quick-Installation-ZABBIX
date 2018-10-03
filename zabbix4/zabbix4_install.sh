#!/bin/sh
echo "脚本作者:火星小刘 web:www.huoxingxiaoliu.com email:xtlyk@163.com"

zabbixdir=`pwd`
ip=`ip address |grep inet |grep -v inet6 |grep -v 127.0.0.1 |awk '{print $2}' |awk -F "/" '{print $1}'`
release=`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'`

cat $zabbixdir/README.md

echo "当前目录为:$zabbixdir"
echo "本机ip为:$ip"

echo "同步服务器时间"
ntpdate asia.pool.ntp.org

echo "关闭防火墙"
systemctl stop firewalld
systemctl disable firewalld

echo "创建zabbix用户"

groupadd zabbix
useradd -g zabbix zabbix

sleep 5

echo "安装zabbix源"
rpm -i https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm

echo "安装zabbix、mysql、apache、php等相关组件"
yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb mariadb-devel mariadb-server -y

echo "设置数据库root密码,默认为123321"
sleep 3
systemctl start mariadb.service
mysqladmin  -uroot password "123321"

echo "创建zabbix数据库，和用户名密码"
echo "create database zabbix character set utf8 collate utf8_bin;" | mysql -uroot -p123321
echo "grant all privileges on zabbix.* to zabbix@'localhost' identified by 'zabbix';" | mysql -uroot -p123321
echo "flush privileges;" | mysql -uroot -p123321

echo "导入数据库"
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix zabbix

echo "修改zabbix 配置文件"
sed -i '/# DBPassword=/a\DBPassword=zabbix' /etc/zabbix/zabbix_server.conf
sed -i '/# php_value date.timezone Europe\/Riga/a\ php_value date.timezone PRC' /etc/httpd/conf.d/zabbix.conf

cat > /usr/share/zabbix/conf/zabbix.conf.php <<END
<?php
// Zabbix GUI configuration file.
global $DB, $HISTORY;

\$DB['TYPE']                             = 'MYSQL';
\$DB['SERVER']                   = 'localhost';
\$DB['PORT']                             = '0';
\$DB['DATABASE']                 = 'zabbix';
\$DB['USER']                             = 'zabbix';
\$DB['PASSWORD']                 = 'zabbix';
// Schema name. Used for IBM DB2 and PostgreSQL.
\$DB['SCHEMA']                   = 'zabbix';

\$ZBX_SERVER                             = 'localhost';
\$ZBX_SERVER_PORT                = '10051';
\$ZBX_SERVER_NAME                = '';

\$IMAGE_FORMAT_DEFAULT   = IMAGE_FORMAT_PNG;

// Uncomment this block only if you are using Elasticsearch.
// Elasticsearch url (can be string if same url is used for all types).
//$HISTORY['url']   = [
//              'uint' => 'http://localhost:9200',
//              'text' => 'http://localhost:9200'
//];
// Value types stored in Elasticsearch.
//$HISTORY['types'] = ['uint', 'text'];
END


echo "启动服务，设置开机启动"
systemctl restart zabbix-server zabbix-agent httpd
systemctl enable zabbix-server zabbix-agent httpd mariadb

echo "数据库默认root密码 : zabbix123321;"
echo "zabbix 数据库名称、zabbix连接数据库用户名:zabbix、zabbix连接数据库密码:zabbix"
echo "zabbix web 用户名：Admin、密码：zabbix"
echo "打开http://$ip/zabbix，进行下一步安装"
