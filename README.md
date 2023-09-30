# Quick-Installation-ZABBIX
# https://www.bilibili.com/video/BV1Qu411z7i1/ 可以点击此链接，查看zabbix 6.0 最新版本视频教程
## zabbix安装脚本
### 脚本作者:火星小刘 
### 可配合本人微信报警脚本哦：https://github.com/X-Mars/Zabbix-Alert-WeChat

### 支持操作系统
1. 已支持 **centos 7(编译安装) / centos 8 / centos 9 / rocky linux 8 / rocky linux 9 / ubuntu 20.04 / ubuntu 22.04 / debian 11 / debian 12**
2. 待支持 **openeuler 20 / openeuler 22**

### 食用方法
1. centos 8 / centos 9 / rocky linux 8 / rocky linux 9 / ubuntu 20.04 / ubuntu 22.04 / debian 11 / debian 12
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX
bash zabbix6.sh
```
2. centos 7(编译安装)
```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX/zabbix6
bash centos-7.sh
```

### 交流群

<img src="https://github.com/X-Mars/Quick-Installation-ZABBIX/blob/master/images/1.jpg?raw=true" width="25%" height="25%"><img src="https://github.com/X-Mars/Quick-Installation-ZABBIX/blob/master/images/2.jpg?raw=true" width="45%" height="45%">

### 注意事项
1. debian需要手动执行 **dpkg-reconfigure locales** 安装中文语言包
2. centos7系统，请使用 **zabbix6/centos-7.sh**

## 更新日志

### 2023-09-30更新
1. 默认拉取企业微信、飞书、钉钉告警脚本
2. centos告警脚本路径 **/usr/local/share/zabbix/alertscripts**
3. 其他操作系统告警脚本路径 **/usr/lib/zabbix/alertscripts**
4. 可在报警媒介类型中手动添加各个脚本

### 2023-09-23更新
1. 请使用同时支持**centos 8 / centos 9 / rocky linux 8 / rocky linux 9 / ubuntu 20.04 / ubuntu 22.04 / debian 11 / debian 12** 的脚本 **zabbix6.sh**
2. 解决图形界面中文乱码的问题（debian需要手动执行 **dpkg-reconfigure locales**）
3. 完美支持 centos 8 / 9
4. 完美支持 debian 11 / 12

### 2023-09-22更新
1. 增加 debian 11支持，debian 12 需要进一步测试

### 2023-09-17更新
1. 增加 centos 7 部署zabbix 6.0 脚本

### 2023-09-16更新
1. 增加 ubuntu 20 / 22 部署zabbix 6.0 脚本

### 2023-09-13更新
1. 增加 ubuntu 20 部署zabbix 6.0 beta 版本脚本

### 2023-09-12更新
1. 增加 rocky linux 8 / 9 部署zabbix 6.0

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
