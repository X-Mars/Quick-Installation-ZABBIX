# Path: zabbix6/debian.sh
#!/bin/bash
# Author: 火星小刘 / 中国青岛
# Install Zabbix 6.0 on Debian 11 / 12"

echo -e "\e[32mAuthor: \e[0m\e[33m火星小刘 / 中国青岛"
echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/"
echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477"
echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX"
echo -e "\e[32m当前脚本介绍: \e[0m\e[33mInstall Zabbix 6.0 on Debian 11 / 12"

# 检查当前用户是否是root用户
if [ "$(id -u)" -eq 0 ]; then
    echo "当前用户是root用户。"
else
    echo "请使用root用户运行本脚本。"
    exit 1
fi

# 获取操作系统信息，安装对应版本zabbix源，并替换为阿里云zabbix源
# 检查 /etc/os-release 文件是否存在
echo '检查操作系统版本...'
if [ -f /etc/os-release ]; then
    # 导入 /etc/os-release 文件
    . /etc/os-release
    # 检查 ID 是否为 "debian" 并且 VERSION_ID 是否定义
    if [ "$ID" == "debian" ] && ( [ "$VERSION_ID" == "11" ] || [ "$VERSION_ID" == "12" ]); then
        apt install curl -y
        # 构建下载URL并下载 zabbix-release 包
        echo "已下载适用于 ${ID} $VERSION_ID 的 zabbix-release 包。"
        if [ "$VERSION_ID" == "11" ]; then
          wget https://mirrors.aliyun.com/zabbix/zabbix/6.0/${ID}/pool/main/z/zabbix-release/zabbix-release_6.0-4+${ID}${VERSION_ID}_all.deb
          dpkg -i "zabbix-release_6.0-4+${ID}${VERSION_ID}_all.deb"
        else
          wget https://mirrors.aliyun.com/zabbix/zabbix/6.0/${ID}/pool/main/z/zabbix-release/zabbix-release_6.0-5+${ID}${VERSION_ID}_all.deb
          dpkg -i "zabbix-release_6.0-5+${ID}${VERSION_ID}_all.deb"
        fi
    else
        echo "不支持的操作系统版本，脚本停止运行。"
        exit 1
    fi
else
    echo "无法找到 /etc/os-release 文件，脚本无法运行。"
    exit 1
fi

sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/apt/sources.list.d/zabbix.list
sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/apt/sources.list.d/zabbix-agent2-plugins.list
mv /etc/apt/sources.list.d/zabbix-agent2-plugins.list /etc/apt/sources.list.d/zabbix-agent2-plugins.list-bak

# 安装mariadb源
echo '安装mariadb源...'
wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
bash mariadb_repo_setup --mariadb-server-version=11.0

# 安装zabbix、中文语言包、数据库
echo 'zabbix、中文语言包、数据库...'
apt update
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mariadb-server mariadb-client -y

systemctl enable mariadb

# 初始化数据库

echo '初始化数据库...'
echo "create database zabbix character set utf8mb4 collate utf8mb4_bin;" | mariadb -uroot
echo "create user zabbix@localhost identified by 'huoxingxiaoliu';" | mariadb -uroot
echo "grant all privileges on zabbix.* to zabbix@localhost;" | mariadb -uroot
echo "set global log_bin_trust_function_creators = 1;" | mariadb -uroot

# 导入初始化数据
echo "导入初始化数据"
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mariadb --default-character-set=utf8mb4 -uzabbix -phuoxingxiaoliu zabbix
sed -i 's/# DBPassword=/DBPassword=huoxingxiaoliu/g' /etc/zabbix/zabbix_server.conf

echo "set global log_bin_trust_function_creators = 0;" | mariadb -uroot

# 检查防火墙是否运行，配置防火墙
echo '检查防火墙'
# 检查是否存在ufw命令
if command -v ufw &>/dev/null; then
    echo "ufw已安装在系统中."

    # 检查ufw是否已启用
    if ufw status | grep -q "Status: active"; then
        echo "ufw已启用，配置防火墙..."
        ufw allow 80/tcp
        ufw allow 10051/tcp
        ufw reload
    else
        echo "ufw未启用."
    fi
else
    echo "ufw未安装在系统中."
fi

systemctl restart zabbix-server apache2 zabbix-agent
systemctl enable zabbix-server apache2 zabbix-agent

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

echo -e "\e[31m请手动执行 dpkg-reconfigure locales 安装中文语言包！！！\e[0m"
echo -e "\e[31m执行后勾选 zh_CN.GB2312、zh_CN.GB18030、zh_CN.GBK、zh_CN.UTF-8！！！\e[0m"
