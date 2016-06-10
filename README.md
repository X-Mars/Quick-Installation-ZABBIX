# Quick-Installation-ZABBIX

zabbix安装脚本v_3.1
脚本作者:火星小刘 web:www.huoxingxiaoliu.com email:xtlyk@126.com

要求纯净centos6/7系统\n
关闭防火墙\n
关闭selinux\n

=========运行"server-install.sh"安装zabbix服务器端\n
由于zabbix3需要php5.6以上，因此脚本会删除原有php环境从新安装\n
mysql默认root密码123321\n
zabbix数据库名称zabbix\n
zabbix数据库用户名zabbix\n
zabbix数据库密码zabbix\n

=========在被监控终端运行"agent-install.sh"安装\n

=========更新日志\n
2016-06-10更新\n
1、增加centos7支持\n
2、添加zabbix_java启动\n

2016-06-09更新\n
1、升级zabbix到3.0.3\n
2、添加吴兆松的graphtrees插件\n
graphtrees\n
https://github.com/OneOaaS/graphtrees\n
实现效果\n
http://t.cn/RqAeAxT\n

2015-11-20更新\n
1、agent-install.sh增加wget安装\n
2、升级zabbix到2.4.7\n
3、server-install.sh复制zabbix-2.4.7.tar.gz到/var/www/html/zabbix，agent-install.sh从服务端调取zabbix-2.4.7.tar.gz安装包\n
