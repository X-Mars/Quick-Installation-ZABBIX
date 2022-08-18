# Quick-Installation-ZABBIX

## zabbix安装脚本
### 脚本作者:火星小刘 
### web: www.huoxingxiaoliu.com 
### email: xtlyk@163.com
### 可配合本人微信报警脚本哦：https://github.com/X-Mars/Zabbix-Alert-WeChat
### 已上传zabbix 4.0 yum 安装脚本，欢迎搭建反馈

### 交流群

<img src="https://github.com/X-Mars/Quick-Installation-ZABBIX/blob/master/images/1.jpg?raw=true" width="25%" height="25%">

 * 要求纯净centos6/7系统（强烈建议用7，用6的话安装非常缓慢）
 * 关闭防火墙
 * 关闭selinux
 * php>=5.6
 * zabbix web ：Admin/zabbix

 * zabbix 4.0 不支持 **graphtrees** ！！！
 
#### 运行**server-install.sh**安装zabbix服务器端
由于zabbix3需要php5.6以上，因此脚本会删除原有php环境从新安装  
  
**mysql默认root密码123321**  
**zabbix数据库名称zabbix**  
**zabbix数据库用户名zabbix**  
**zabbix数据库密码zabbix**  

#### 在被监控终端运行**agent-install.sh**安装

## 更新日志

### 2018-07-01更新
1. 升级zabbix到3.0.19

### 2018-06-06更新
1. 升级zabbix到3.0.18

### 2018-05-14更新
1. 升级zabbix到3.0.17

### 2018-02-22更新
1. 升级zabbix到3.0.14

### 2016-11-22更新  
1. 添加吴兆松的**graphtrees**插件  
[graphtrees github](https://github.com/OneOaaS/graphtrees)  
[graphtrees 实现效果](http://t.cn/RqAeAxT)  

### 2017-11-10更新
1. 升级zabbix到3.0.13

### 2017-09-29更新
1. 升级zabbix到3.0.11

### 2017-06-01更新
1. 删除graphtrees


### 2016-06-10更新  
1. 增加centos7支持  
2. 添加zabbix_java启动  

### 2015-11-20更新  
1. agent-install.sh增加wget安装  
2. 升级zabbix到2.4.7  
3. server-install.sh复制zabbix-2.4.7.tar.gz到/var/www/html/zabbix，agent-install.sh从服务端调取zabbix-2.4.7.tar.gz安装包
