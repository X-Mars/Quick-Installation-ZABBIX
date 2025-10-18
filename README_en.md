# Quick-Installation-ZABBIX

English | [简体中文](README.md)

# https://www.bilibili.com/video/BV1Qu411z7i1/ Click this link to watch Zabbix 6.0 latest video tutorial
## Zabbix Installation Scripts
### Script Author: Mars Liu (火星小刘)
### Works with WeChat alert script: https://github.com/X-Mars/Zabbix-Alert-WeChat

### Supported Operating Systems
1. **zabbix6.sh** supports **CentOS 7 (compiled installation) / CentOS 8 / CentOS 9 / Rocky Linux 8 / Rocky Linux 9 / Ubuntu 20.04 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 11 / Debian 12**
2. **zabbix7.sh** supports **CentOS 8 (strongly not recommended) / CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 12 / AlmaLinux 8 / AlmaLinux 9 / AlmaLinux 10**
3. **zabbix7.4.sh** supports **CentOS 8 (strongly not recommended) / CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 12 / AlmaLinux 8 / AlmaLinux 9 / AlmaLinux 10**
4. Docker deployment has been tested on **Rocky Linux 9 / Ubuntu 24.04**
5. **openeuler.sh** supports **openEuler 22.03 / openEuler 24.03**
6. Join QQ group to get **CentOS 7 installation script for Zabbix 7**

### Community

<img src="https://github.com/X-Mars/Quick-Installation-ZABBIX/blob/master/images/1.jpg?raw=true" width="25%" height="25%"><img src="https://github.com/X-Mars/Quick-Installation-ZABBIX/blob/master/images/2.jpg?raw=true" width="45%" height="45%"><img src="https://github.com/X-Mars/Quick-Installation-ZABBIX/blob/master/images/3.png?raw=true" width="30%" height="30%">

### Zabbix 7.4 Installation
1. CentOS 8 (strongly not recommended) / CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 12 / AlmaLinux 8 / AlmaLinux 9 / AlmaLinux 10
```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX
bash zabbix7.4.sh
```

### Zabbix 7.0 Installation
1. CentOS 8 (strongly not recommended) / CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 12 / AlmaLinux 8 / AlmaLinux 9 / AlmaLinux 10
```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX
bash zabbix7.sh
```

### openEuler 22 / 24 Zabbix 7.0 Installation
```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX
bash openeuler.sh
```

### Zabbix 7.0 Docker Deployment
1. Rocky Linux 9 / Ubuntu 24.04
```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX/docker
bash zabbix7_docker.sh
```

### Zabbix 6.0 Installation
1. CentOS 8 / CentOS 9 / Rocky Linux 8 / Rocky Linux 9 / Ubuntu 20.04 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 11 / Debian 12
```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX
bash zabbix6.sh
```
2. CentOS 7 (compiled installation, **extremely NOT recommended!!!**)
```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX/zabbix6
bash centos-7.sh
```

### Important Notes
1. For Debian, you need to manually run **dpkg-reconfigure locales** to install Chinese language pack
2. For CentOS 7 systems, please use **zabbix6/centos-7.sh**

### Visitor Count
<img align="left" src = "https://profile-counter.glitch.me/Quick-Installation-ZABBIX/count.svg" alt="Loading">
    
## Update Log

### 2025-10-18 Update
1. Added support for author-developed Zabbix CMDB and Report modules
2. https://gitee.com/xtlyk/zabbix_modules

### 2025-10-14 Update
1. Added Zabbix 7.4 deployment script

### 2025-08-30 Update
1. Added Rocky Linux 10 / CentOS 10 / AlmaLinux 10 support
2. Root default password set to **huoxingxiaoliu**

### 2024-08-27 Update
1. Added AlmaLinux 8 / 9 support

### 2024-08-25 Update
1. Added openEuler 22 / 24 support

### 2024-06-29 Update
1. Added Zabbix 7.0 Docker deployment support

### 2024-06-05 Update
1. Added Zabbix 7.0 installation script **zabbix7.sh**, please note this script is currently in **beta version**
2. Zabbix 6.0 added Ubuntu 24.04 support

### 2023-10-08 Update
1. Added database installation status detection, will prompt for reinstallation if database installation fails and exit the script

### 2023-09-30 Update
1. Automatically pull WeChat Enterprise, Feishu, DingTalk alert scripts by default
2. CentOS alert script path **/usr/local/share/zabbix/alertscripts**
3. Other OS alert script path **/usr/lib/zabbix/alertscripts**
4. Can manually add various scripts in alert media types

### 2023-09-23 Update
1. Please use the script **zabbix6.sh** that supports **CentOS 8 / CentOS 9 / Rocky Linux 8 / Rocky Linux 9 / Ubuntu 20.04 / Ubuntu 22.04 / Debian 11 / Debian 12**
2. Fixed Chinese character garbled text in graphical interface (Debian needs to manually run **dpkg-reconfigure locales**)
3. Perfect support for CentOS 8 / 9
4. Perfect support for Debian 11 / 12

### 2023-09-22 Update
1. Added Debian 11 support, Debian 12 needs further testing

### 2023-09-17 Update
1. Added CentOS 7 deployment script for Zabbix 6.0

### 2023-09-16 Update
1. Added Ubuntu 20 / 22 deployment script for Zabbix 6.0

### 2023-09-13 Update
1. Added Ubuntu 20 deployment beta version script for Zabbix 6.0

### 2023-09-12 Update
1. Added Rocky Linux 8 / 9 deployment for Zabbix 6.0

### 2018-07-01 Update
1. Upgraded Zabbix to 3.0.19

### 2018-06-06 Update
1. Upgraded Zabbix to 3.0.18

### 2018-05-14 Update
1. Upgraded Zabbix to 3.0.17

### 2018-02-22 Update
1. Upgraded Zabbix to 3.0.14

### 2016-11-22 Update
1. Added Wu Zhaosong's **graphtrees** plugin
[graphtrees github](https://github.com/OneOaaS/graphtrees)  
[graphtrees implementation effect](http://t.cn/RqAeAxT)  

### 2017-11-10 Update
1. Upgraded Zabbix to 3.0.13

### 2017-09-29 Update
1. Upgraded Zabbix to 3.0.11

### 2017-06-01 Update
1. Removed graphtrees

### 2016-06-10 Update
1. Added CentOS 7 support
2. Added zabbix_java startup

### 2015-11-20 Update
1. agent-install.sh added wget installation
2. Upgraded Zabbix to 2.4.7
3. server-install.sh copies zabbix-2.4.7.tar.gz to /var/www/html/zabbix, agent-install.sh retrieves zabbix-2.4.7.tar.gz installation package from server

## Features

### 🚀 Quick Installation
- One-command installation for multiple Linux distributions
- Automatic configuration of domestic mirror sources for faster downloads
- Automatic firewall and SELinux configuration

### 🔐 Security Features
- Interactive password setup with confirmation
- Default password: **huoxingxiaoliu** (customizable)
- Secure database configuration

### 🌍 Chinese Support
- Automatic Chinese font configuration to prevent garbled text
- Chinese language pack installation (manual for Debian)

### 📧 Alert Integration
- Automatically pulls WeChat Enterprise alert scripts
- DingTalk alert scripts
- Feishu (Lark) alert scripts

### 🐳 Docker Support
- Complete Docker Compose deployment solution
- Pre-configured for quick startup

## Default Credentials

- **Zabbix Web Interface**: Admin / zabbix
- **Database Root User**: huoxingxiaoliu (or custom password)
- **Database Zabbix User**: huoxingxiaoliu (or custom password)

## Technical Stack

- **Database**: MariaDB 11.4
- **Web Server**: Apache (CentOS/Rocky) / Apache (Ubuntu/Debian)
- **PHP**: 8.0+ (automatically configured)
- **Zabbix Versions**: 6.0 LTS, 7.0 LTS, 7.4

## Support

- **Author**: Mars Liu (火星小刘) / Qingdao, China
- **GitHub**: https://github.com/X-Mars/
- **Bilibili**: https://space.bilibili.com/439068477
- **QQ Group**: 523870446

# Star History

**Please give this project a star, your support is the greatest encouragement to me!**
[![Star History Chart](https://api.star-history.com/svg?repos=X-Mars/Quick-Installation-ZABBIX&type=Date)](https://star-history.com/#X-Mars/Quick-Installation-ZABBIX&Date)
