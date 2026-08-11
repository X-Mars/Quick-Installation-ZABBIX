# Quick-Installation-ZABBIX

English | [简体中文](README.md)

### <https://www.bilibili.com/video/BV1Qu411z7i1/> Click this link, or follow the official account for more tutorials

<img src="https://github.com/X-Mars/Quick-Installation-ZABBIX/blob/master/images/4.jpg?raw=true" width="80%" height="80%">

## Zabbix Installation Scripts

### Script Author: Mars Liu

### Can be used together with my WeChat alert script: <https://github.com/X-Mars/Zabbix-Alert-WeChat>

### Supported Operating Systems

1. **zabbix6.sh** supports **CentOS 7 (compiled installation) / CentOS 8 / CentOS 9 / Rocky Linux 8 / Rocky Linux 9 / Ubuntu 20.04 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 11 / Debian 12**
2. **zabbix7.sh** supports **CentOS 8 (strongly not recommended) / CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 12 / AlmaLinux 8 / AlmaLinux 9 / AlmaLinux 10**
3. **zabbix7 offline package build script** supports **CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04**
4. **zabbix7.4.sh** supports **CentOS 8 (strongly not recommended) / CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 12 / AlmaLinux 8 / AlmaLinux 9 / AlmaLinux 10**
5. Docker deployment has been tested on **Rocky Linux 9 / Ubuntu 24.04**
6. **openeuler.sh** supports **openEuler 22.03 / openEuler 24.03**
7. Join the QQ group to get the **CentOS 7 script for installing Zabbix 7**

### Community Groups

<img src="https://github.com/X-Mars/Quick-Installation-ZABBIX/blob/master/images/1.jpg?raw=true" width="25%" height="25%"><img src="https://github.com/X-Mars/Quick-Installation-ZABBIX/blob/master/images/2.jpg?raw=true" width="45%" height="45%"><img src="https://github.com/X-Mars/Quick-Installation-ZABBIX/blob/master/images/3.png?raw=true" width="30%" height="30%">

### How to Install Zabbix 8.0 Pre-release

1. CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 12 / AlmaLinux 8 / AlmaLinux 9 / AlmaLinux 10

```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX
bash zabbix8-pre.sh
```

### How to Install Zabbix 7.4

1. CentOS 8 (strongly not recommended) / CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 12 / AlmaLinux 8 / AlmaLinux 9 / AlmaLinux 10

```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX
bash zabbix7.4.sh
```

### How to Install Zabbix 7.0

1. CentOS 8 (strongly not recommended) / CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 12 / AlmaLinux 8 / AlmaLinux 9 / AlmaLinux 10

```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX
bash zabbix7.sh
```

### How to Build the Zabbix 7.0 Offline Installation Package

1. CentOS 9 / CentOS 10 / Rocky Linux 8 / Rocky Linux 9 / Rocky Linux 10 / Ubuntu 22.04 / Ubuntu 24.04

```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX/offline_install
bash make_offline_package.sh
```

### How to Install Zabbix 7.0 on openEuler 22 / 24

```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX
bash openeuler.sh
```

### How to Deploy Zabbix 7.0 with Docker

1. Rocky Linux 9 / Ubuntu 24.04

```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX/docker
bash zabbix7_docker.sh
```

### How to Install Zabbix 6.0

1. CentOS 8 / CentOS 9 / Rocky Linux 8 / Rocky Linux 9 / Ubuntu 20.04 / Ubuntu 22.04 / Ubuntu 24.04 / Debian 11 / Debian 12

```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX
bash zabbix6.sh
```

2. CentOS 7 (compiled installation, **extremely and strongly not recommended!!!**)

```shell
git clone https://github.com/X-Mars/Quick-Installation-ZABBIX.git
cd Quick-Installation-ZABBIX/zabbix6
bash centos-7.sh
```

### Notes

1. On Debian, you need to manually run **dpkg-reconfigure locales** to install the Chinese language pack
2. For CentOS 7, please use **zabbix6/centos-7.sh**

## Update Log

### 2026-06-04 Update

1. Added the Zabbix 7.0 offline package build script

### 2026-02-27 Update

1. Added the Zabbix 8.0 pre-release deployment script

### 2025-10-18 Update

1. Added support for the author-developed Zabbix CMDB and report modules
2. <https://gitee.com/xtlyk/zabbix_modules>

### 2025-10-14 Update

1. Added the Zabbix 7.4 deployment script

### 2025-08-30 Update

1. Added support for Rocky Linux 10 / CentOS 10 / AlmaLinux 10
2. The default root password is set to **huoxingxiaoliu**

### 2024-08-27 Update

1. Added support for AlmaLinux 8 / 9

### 2024-08-25 Update

1. Added support for openEuler 22 / 24

### 2024-06-29 Update

1. Added support for Zabbix 7.0 Docker deployment

### 2024-06-05 Update

1. Added the Zabbix 7.0 installation script **zabbix7.sh**. Please note that this script is currently in **beta**
2. Added Ubuntu 24.04 support for Zabbix 6.0

### 2023-10-08 Update

1. Added database installation status detection. If database installation fails, the script will prompt for reinstallation and exit

### 2023-09-30 Update

1. By default, pulls alert scripts for WeCom, Feishu, and DingTalk
2. Alert script path on CentOS: **/usr/local/share/zabbix/alertscripts**
3. Alert script path on other operating systems: **/usr/lib/zabbix/alertscripts**
4. You can manually add each script in Media types

### 2023-09-23 Update

1. Please use script **zabbix6.sh**, which supports **CentOS 8 / CentOS 9 / Rocky Linux 8 / Rocky Linux 9 / Ubuntu 20.04 / Ubuntu 22.04 / Debian 11 / Debian 12**
2. Fixed garbled Chinese text in the web UI (on Debian, manually run **dpkg-reconfigure locales**)
3. Full support for CentOS 8 / 9
4. Full support for Debian 11 / 12

### 2023-09-22 Update

1. Added support for Debian 11; Debian 12 needs further testing

### 2023-09-17 Update

1. Added a CentOS 7 script for deploying Zabbix 6.0

### 2023-09-16 Update

1. Added Ubuntu 20 / 22 scripts for deploying Zabbix 6.0

### 2023-09-13 Update

1. Added Ubuntu 20 beta deployment script for Zabbix 6.0

### 2023-09-12 Update

1. Added support for deploying Zabbix 6.0 on Rocky Linux 8 / 9

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
[graphtrees effect preview](http://t.cn/RqAeAxT)

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

1. Added wget installation in agent-install.sh
2. Upgraded Zabbix to 2.4.7
3. server-install.sh copies zabbix-2.4.7.tar.gz to /var/www/html/zabbix, and agent-install.sh fetches zabbix-2.4.7.tar.gz from the server

# Star History

**Please give this project a star. Your support is my greatest encouragement!**
[![Star History Chart](https://star-history.dera.page/svg?repos=X-Mars/Quick-Installation-ZABBIX&type=Date)](https://star-history.dera.page/#X-Mars/Quick-Installation-ZABBIX&Date)
