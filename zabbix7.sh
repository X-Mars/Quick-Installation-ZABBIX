#!/bin/bash
# Author: 火星小刘 / 中国青岛
# Install Zabbix 7 on CentOS, Rocky Linux, Debian, or Ubuntu

echo -e "\e[32mAuthor: \e[0m\e[33m火星小刘 / 中国青岛\e[0m"
echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/\e[0m"
echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477\e[0m"
echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX\e[0m"
echo -e "\e[32m当前脚本介绍: \e[0m\e[33mZabbix 7 安装脚本\e[0m"
echo -e "\e[32m支持的操作系统: \e[0m\e[33mcentos 8 / centos 9 / rocky linux 8 / rocky linux 9 / ubuntu 22.04 / ubuntu 24.04 / debian 12\e[0m"

# 检查当前用户是否是root用户
if [ "$(id -u)" -eq 0 ]; then
  echo "当前用户是root用户..."
else
  echo "请使用root用户运行本脚本..."
  exit 1
fi

install_zabbix_release_on_centos_or_rocky() {
  echo '为CentOS或Rocky Linux安装zabbix源...'
  if [ "$VERSION_ID" == "9" ]; then
    curl -O https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/7.0/${ID}/${VERSION_ID}/x86_64/zabbix-release-7.0-2.el${VERSION_ID}.noarch.rpm
    rpm -ivh zabbix-release-7.0-2.el${VERSION_ID}.noarch.rpm
  elif [ "$VERSION_ID" == "8" ]; then
    curl -O https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/7.0/${ID}/${VERSION_ID}/x86_64/zabbix-release-7.0-1.el${VERSION_ID}.noarch.rpm
    rpm -ivh zabbix-release-7.0-1.el${VERSION_ID}.noarch.rpm
    dnf module switch-to php:8.0 -y
  fi
  dnf module reset mariadb -y
  sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/yum.repos.d/zabbix.repo
  sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/yum.repos.d/zabbix-agent2-plugins.repo
  mv /etc/yum.repos.d/zabbix-agent2-plugins.repo /etc/yum.repos.d/zabbix-agent2-plugins.repo-bak
  sed -i '/^\[epel\]/a excludepkgs=zabbix*' /etc/yum.repos.d/epel.repo
}

config_epel(){
  dnf install epel-release -y
  sed -i 's|^#baseurl=https://download.example/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel*
  sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*
}

config_rocky(){
  echo '为Rocky Linux配置阿里云源...'
  if [ "$VERSION_ID" == "9" ]; then
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
      -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=http://mirrors.aliyun.com/rockylinux|g' \
      -i.bak \
      /etc/yum.repos.d/rocky*.repo
    
  elif [ "$VERSION_ID" == "8" ]; then
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
      -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.aliyun.com/rockylinux|g' \
      -i.bak \
      /etc/yum.repos.d/Rocky-*.repo
  fi
}

config_firewalld_on_centos_or_rocky() {
  echo '为CentOS或Rocky Linux配置防火墙...'
  # 如果防火墙正在运行,配置防火墙
  if systemctl status firewalld | grep -q "active (running)"; then
    echo '配置防火墙...'
    firewall-cmd --permanent --add-port={80/tcp,10051/tcp,443/tcp}
    firewall-cmd --reload
  fi
  # 关闭selinux
  sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
  setenforce 0
}

config_ufw_on_ubuntu_or_debian() {
  echo '为Ubuntu或Debian配置防火墙...'
  if command -v ufw &>/dev/null; then
    echo "ufw已安装在系统中."

    # 检查ufw是否已启用
    if ufw status | grep -q "Status: active"; then
      echo "ufw已启用,配置防火墙..."
      ufw allow 80/tcp
      ufw allow 443/tcp
      ufw allow 10051/tcp
      ufw reload
    else
        echo "ufw未启用."
    fi
  else
    echo "ufw未安装在系统中."
  fi
}

install_zabbix_release_on_ubuntu_or_debain() {
  echo '为Ubuntu或Debian安装zabbix源...'
  apt install curl -y
  curl -O https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/7.0/${ID}/pool/main/z/zabbix-release/zabbix-release_7.0-1+${ID}${VERSION_ID}_all.deb
  dpkg -i "zabbix-release_7.0-1+${ID}${VERSION_ID}_all.deb"

  sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/apt/sources.list.d/zabbix.list
  sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/apt/sources.list.d/zabbix-agent2-plugins.list
  mv /etc/apt/sources.list.d/zabbix-agent2-plugins.list /etc/apt/sources.list.d/zabbix-agent2-plugins.list-bak
}

install_mariadb_release() {
  echo '安装mariadb源...'
  curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash -s -- --mariadb-server-version=11.0
}

init_database() {
  echo '初始化数据库...'
  echo "create database zabbix character set utf8mb4 collate utf8mb4_bin;" | mariadb -uroot
  echo "create user zabbix@localhost identified by 'huoxingxiaoliu';" | mariadb -uroot
  echo "grant all privileges on zabbix.* to zabbix@localhost;" | mariadb -uroot
  echo "set global log_bin_trust_function_creators = 1;" | mariadb -uroot

  # 导入初始化数据
  zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mariadb --default-character-set=utf8mb4 -uzabbix -phuoxingxiaoliu zabbix
  sed -i 's/# DBPassword=/DBPassword=huoxingxiaoliu/g' /etc/zabbix/zabbix_server.conf
  echo "set global log_bin_trust_function_creators = 0;" | mariadb -uroot
}

centos_or_rocky_finsh() {
  echo '安装完成,启动服务...'
  # 启动服务
  systemctl restart zabbix-server zabbix-agent httpd php-fpm
  systemctl enable zabbix-server zabbix-agent httpd php-fpm
  notification
}

ubuntu_or_debian_finsh() {
  echo '安装完成,启动服务...'
  # 启动服务
  systemctl restart zabbix-server apache2 zabbix-agent
  systemctl enable zabbix-server apache2 zabbix-agent
  notification
}

change_font_to_chinese() {
  echo "解决zabbix图表中文乱码问题"
  if [ -e "simkai.ttf" ]; then
    cp simkai.ttf /usr/share/zabbix/assets/fonts
    rm -f /usr/share/zabbix/assets/fonts/graphfont.ttf
    ln -s /usr/share/zabbix/assets/fonts/simkai.ttf /usr/share/zabbix/assets/fonts/graphfont.ttf
  else
    echo -e "\e[31m中文字体simkai.ttf不存在,请确保通过git clone 下载本项目！！！\e[0m"
  fi

}

notification() {

  echo -e "\e[32mAuthor: \e[0m\e[33m火星小刘 / 中国青岛\e[0m"
  echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/\e[0m"
  echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477\e[0m"
  echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX\e[0m"
  echo -e "\e[32m当前脚本介绍: \e[0m\e[33mZabbix 7 安装脚本\e[0m"
  echo -e "\e[32m支持的操作系统: \e[0m\e[33mcentos 8 / centos 9 / rocky linux 8 / rocky linux 9 / ubuntu 22.04 / ubuntu 24.04 / debian 12\e[0m"

  echo -e "\n\e[31m数据库root用户默认密码为空,zabbix用户默认密码 huoxingxiaoliu\e[0m"

  # 获取ip
  if command -v ip &> /dev/null; then
    # 使用ip命令获取IP地址并存储到ip变量
    ip=$(ip addr | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
  else
    # 使用ifconfig命令获取IP地址并存储到ip变量
    ip=$(ifconfig | grep -oP 'inet\s+\K[\d.]+')
  fi

  # 使用for循环打印IP地址,并在每次打印后输出 "ok"
  for i in $ip; do
    echo -e "\e[32m访问继续下一步操作:  http://$i/zabbix\e[0m"
  done

  echo -e "\e[32m默认用户名密码:  Admin / zabbix\e[0m"

  if [ "$ID" == "debian" ]; then
    echo -e "\n\e[31m请手动执行 dpkg-reconfigure locales 安装中文语言包！！！\e[0m"
    echo -e "\e[31m执行后勾选 zh_CN.UTF-8！！！\e[0m"
    echo -e "\e[31m安装结束后,重启服务: systemctl restart zabbix-server zabbix-agent apache2\e[0m"
  fi
}


add_wechat_dingtalk_feishu_scripts() {
  echo -e "\n\e[31m拉取企业微信、钉钉、飞书告警脚本,具体查看: https://github.com/X-Mars/Zabbix-Alert-WeChat\e[0m"
  echo -e "\e[31m此操作不影响zabbix使用\e[0m"
  echo -e "\e[31m运行命令: ls -la /usr/lib/zabbix/alertscripts 查看脚本\e[0m"
  git clone https://github.com/X-Mars/Zabbix-Alert-WeChat.git /usr/lib/zabbix/alertscripts
  ls -la /usr/lib/zabbix/alertscripts
}

# 获取操作系统信息
if [ -f /etc/os-release ]; then
  . /etc/os-release
  echo "操作系统版本为: $ID linux $VERSION_ID"
  case "$ID" in
    centos|rocky)
      # CentOS 或 Rocky Linux 的安装步骤
      VERSION_ID=$(echo "$VERSION_ID" | cut -d'.' -f1)
      if ( [ "$VERSION_ID" == "8" ] || [ "$VERSION_ID" == "9" ]); then
          if [ "$ID" == "rocky" ]; then
              config_rocky
          fi
          config_epel
          install_zabbix_release_on_centos_or_rocky
          install_mariadb_release
          dnf install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent MariaDB-server MariaDB-client MariaDB-backup MariaDB-devel langpacks-zh_CN git -y
          systemctl enable mariadb --now
          if systemctl is-active mariadb; then
            echo "MariaDB 安装成功。"
          else
            echo -e "\e[91mMariaDB 安装失败,怀疑是网络问题（你懂得）。请使用以下命令安装 MariaDB 后重试: \e[0m"
            echo -e "\e[91m安装 MariaDB 源: curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash -s -- --mariadb-server-version=11.0\e[0m"
            echo -e "\e[91m安装 MariaDB: dnf install MariaDB-server MariaDB-client MariaDB-backup MariaDB-devel -y\e[0m"
            echo -e "\e[91m启动 MariaDB: systemctl enable mariadb --now\e[0m"
            exit 1
          fi
          change_font_to_chinese
          init_database
          config_firewalld_on_centos_or_rocky
          centos_or_rocky_finsh
          add_wechat_dingtalk_feishu_scripts
      else
          echo "不支持的操作系统版本,脚本停止运行。"
          exit 1
      fi
      ;;
    debian|ubuntu)
      # Debian 或 Ubuntu 的安装步骤
      VERSION_ID_BIG=$(echo "$VERSION_ID" | cut -d'.' -f1)
      if ( [ "$VERSION_ID" == "12" ] || [ "$VERSION_ID_BIG" == "22" ] || [ "$VERSION_ID_BIG" == "24" ] ); then
      
          install_zabbix_release_on_ubuntu_or_debain
          if [ "$ID" == "ubuntu" ]; then
            apt install language-pack-zh-hans -y
          fi
          
          install_mariadb_release
          apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mariadb-server mariadb-client git -y
          systemctl enable mariadb --now
          if systemctl is-active mariadb; then
            echo "MariaDB 安装成功。"
          else
            echo -e "\e[91mMariaDB 安装失败,怀疑是网络问题（你懂得）。请使用以下命令安装 MariaDB 后重试: \e[0m"
            echo -e "\e[91m安装 MariaDB 源: curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash -s -- --mariadb-server-version=11.0\e[0m"
            echo -e "\e[91m安装 MariaDB: apt install mariadb-server mariadb-client -y\e[0m"
            echo -e "\e[91m启动 MariaDB: systemctl enable mariadb --now\e[0m"
            exit 1
          fi
          change_font_to_chinese
          init_database
          config_ufw_on_ubuntu_or_debian
          ubuntu_or_debian_finsh
          add_wechat_dingtalk_feishu_scripts
      else
          echo "不支持的操作系统版本,脚本停止运行。"
          exit 1
      fi
      ;;
  esac
fi
