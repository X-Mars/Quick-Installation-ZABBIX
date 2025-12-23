#!/bin/bash
# Author: 火星小刘 / 中国青岛
# Install Zabbix 7.4 on CentOS, Rocky Linux, Debian, or Ubuntu

# 设置默认密码变量
DEFAULT_PASSWORD="huoxingxiaoliu"

# 提示用户设置密码
echo -e "\e[32m是否要设置自定义的数据库密码？默认密码为：$DEFAULT_PASSWORD\e[0m"
echo -e "\e[32m请选择 (y/n): \e[0m"
read -r set_custom_password

if [ "$set_custom_password" = "y" ] || [ "$set_custom_password" = "Y" ]; then
    while true; do
        echo -e "\e[32m请输入新的密码: \e[0m"
        read -rs custom_password
        echo  # 输入完成后换行
        
        # 二次确认密码
        echo -e "\e[32m请再次输入密码: \e[0m"
        read -rs confirm_password
        echo  # 输入完成后换行
        
        if [ -z "$custom_password" ]; then
            echo -e "\e[31m密码不能为空，请重新输入\e[0m"
        elif [ "$custom_password" != "$confirm_password" ]; then
            echo -e "\e[31m两次输入的密码不一致，请重新输入\e[0m"
        else
            DEFAULT_PASSWORD=$custom_password
            echo -e "\e[32m密码已设置为: $DEFAULT_PASSWORD\e[0m"
            break
        fi
    done
else
    echo -e "\e[32m将使用默认密码: $DEFAULT_PASSWORD\e[0m"
fi

echo -e "\e[32mAuthor: \e[0m\e[33m火星小刘 / 中国青岛\e[0m"
echo -e "\e[32m加入QQ群一起开车一起学习: \e[0m\e[33m523870446\e[0m"
echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/\e[0m"
echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477\e[0m"
echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX\e[0m"
echo -e "\e[32m当前脚本介绍: \e[0m\e[33mZabbix 7.4 安装脚本\e[0m"
echo -e "\e[32m支持的操作系统: \e[0m\e[33mcentos 8 / centos 9 / centos 10 / rocky linux 8 / rocky linux 9 / rocky linux 10 / ubuntu 22.04 / ubuntu 24.04 / debian 12 / almaLinux 8 / almaLinux 9 / almaLinux 10\e[0m"

# 检查当前用户是否是root用户
if [ "$(id -u)" -eq 0 ]; then
  echo "当前用户是root用户..."
else
  echo "请使用root用户运行本脚本..."
  exit 1
fi

install_zabbix_release_on_centos_or_rocky() {
  echo '为CentOS或Rocky Linux安装zabbix 7.4源...'
  if( [ "$VERSION_ID" == "8" ] || [ "$VERSION_ID" == "9" ] || [ "$VERSION_ID" == "10" ]); then
    curl -O https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/7.4/release/${ID}/${VERSION_ID}/noarch/zabbix-release-latest-7.4.el${VERSION_ID}.noarch.rpm
    rpm -ivh zabbix-release-latest-7.4.el${VERSION_ID}.noarch.rpm
    if [ "$VERSION_ID" == "8" ]; then
      dnf module switch-to php:8.0 -y
    fi
  fi
  dnf module reset mariadb -y
  sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/yum.repos.d/zabbix.repo
  sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/yum.repos.d/zabbix-agent2-plugins.repo
  mv /etc/yum.repos.d/zabbix-agent2-plugins.repo /etc/yum.repos.d/zabbix-agent2-plugins.repo-bak
}

install_zabbix_release_on_alma() {
  echo '为AlmaLinux安装zabbix 7.4源...'
  if( [ "$VERSION_ID" == "8" ] || [ "$VERSION_ID" == "9" ] || [ "$VERSION_ID" == "10" ]); then
    curl -O https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/7.4/release/alma/${VERSION_ID}/noarch/zabbix-release-latest-7.4.el${VERSION_ID}.noarch.rpm
    rpm -ivh zabbix-release-latest-7.4.el${VERSION_ID}.noarch.rpm
  fi
  dnf module reset mariadb -y
  sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/yum.repos.d/zabbix.repo
  sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/yum.repos.d/zabbix-agent2-plugins.repo
  mv /etc/yum.repos.d/zabbix-agent2-plugins.repo /etc/yum.repos.d/zabbix-agent2-plugins.repo-bak
}

config_epel(){
  dnf install epel-release -y
  sed -i 's|^#baseurl=https://download.example/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel*
  sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*
  sed -i '/^\[epel\]/a excludepkgs=zabbix*' /etc/yum.repos.d/epel.repo
}

config_rocky(){
  echo '为Rocky Linux配置阿里云源...'
  if ( [ "$VERSION_ID" == "9" ] || [ "$VERSION_ID" == "10" ]); then
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
      -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.aliyun.com/rockylinux|g' \
      -i.bak \
      /etc/yum.repos.d/rocky*.repo
    
  elif [ "$VERSION_ID" == "8" ]; then
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
      -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.aliyun.com/rockylinux|g' \
      -i.bak \
      /etc/yum.repos.d/Rocky-*.repo
  fi
}

config_alma(){
  echo '为AlmaLinux配置阿里云源...'
  if ( [ "$VERSION_ID" == "8" ] || [ "$VERSION_ID" == "9" ] || [ "$VERSION_ID" == "10" ]); then
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
      -e 's|^# baseurl=https://repo.almalinux.org|baseurl=https://mirrors.aliyun.com|g' \
      -i.bak \
      /etc/yum.repos.d/almalinux*.repo
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
  echo '为Ubuntu或Debian安装zabbix 7.4源...'
  apt install curl -y
  curl -O https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/7.4/release/${ID}/pool/main/z/zabbix-release/zabbix-release_latest-7.4+${ID}${VERSION_ID}_all.deb
  dpkg -i "zabbix-release_latest-7.4+${ID}${VERSION_ID}_all.deb"

  sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/apt/sources.list.d/zabbix.list
  sed -i 's/repo\.zabbix\.com/mirrors\.aliyun\.com\/zabbix/' /etc/apt/sources.list.d/zabbix-agent2-plugins.list
  mv /etc/apt/sources.list.d/zabbix-agent2-plugins.list /etc/apt/sources.list.d/zabbix-agent2-plugins.list-bak
}

install_mariadb_release() {
  echo '安装mariadb源...'
  # 判断当前文件夹，是否存在mariadb_repo_setup，如果存在直接运行
  if [ -f "./mariadb_repo_setup" ]; then
    echo "mariadb_repo_setup 已存在，直接运行..."
    bash ./mariadb_repo_setup --mariadb-server-version=11.4
    return
  else
    echo "mariadb_repo_setup 不存在，下载安装..."
    curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version=11.4
  fi
}

config_mariadb_release_on_centos_or_rocky() {
  echo '为CentOS或Rocky Linux配置mariadb 阿里云源...'
  sudo sed -i.bak 's|^baseurl.*$|baseurl = https://mirrors.aliyun.com/mariadb/yum/11.4/rhel/$releasever/$basearch|' /etc/yum.repos.d/mariadb.repo
}

init_database() {
  echo '初始化数据库...'
  echo "设置数据库root和zabbix用户密码..."
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DEFAULT_PASSWORD';" | mariadb -uroot
  
  # 使用新设置的密码执行后续操作
  echo "create database zabbix character set utf8mb4 collate utf8mb4_bin;" | mariadb -uroot -p$DEFAULT_PASSWORD
  echo "create user zabbix@localhost identified by '$DEFAULT_PASSWORD';" | mariadb -uroot -p$DEFAULT_PASSWORD
  echo "grant all privileges on zabbix.* to zabbix@localhost;" | mariadb -uroot -p$DEFAULT_PASSWORD
  echo "set global log_bin_trust_function_creators = 1;" | mariadb -uroot -p$DEFAULT_PASSWORD

  # 注意：Zabbix 7.4 SQL脚本路径可能有所变化
  # 导入初始化数据
  if [ -f /usr/share/zabbix-sql-scripts/mysql/server.sql.gz ]; then
    zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mariadb --default-character-set=utf8mb4 -uzabbix -p$DEFAULT_PASSWORD zabbix
  elif [ -f /usr/share/zabbix/sql-scripts/mysql/server.sql.gz ]; then
    zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mariadb --default-character-set=utf8mb4 -uzabbix -p$DEFAULT_PASSWORD zabbix
  else
    echo -e "\e[31m未找到Zabbix SQL初始化脚本，请检查安装路径！\e[0m"
    exit 1
  fi
  
  sed -i "s/# DBPassword=/DBPassword=$DEFAULT_PASSWORD/g" /etc/zabbix/zabbix_server.conf
  echo "set global log_bin_trust_function_creators = 0;" | mariadb -uroot -p$DEFAULT_PASSWORD
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
  echo -e "\e[32m加入QQ群一起开车一起学习: \e[0m\e[33m523870446\e[0m"
  echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/\e[0m"
  echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477\e[0m"
  echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX\e[0m"
  echo -e "\e[32m当前脚本介绍: \e[0m\e[33mZabbix 7.4 安装脚本\e[0m"
  echo -e "\e[32m支持的操作系统: \e[0m\e[33mcentos 8 / centos 9 / centos 10 / rocky linux 8 / rocky linux 9 / rocky linux 10 / ubuntu 22.04 / ubuntu 24.04 / debian 12 / almaLinux 8 / almaLinux 9 / almaLinux 10\e[0m"

  echo -e "\n\e[31m数据库root用户和zabbix用户默认密码均为: $DEFAULT_PASSWORD\e[0m"

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
  echo -e "\n\e[31m拉取Zabbix cmdb 和报表模块，具体查看：https://gitee.com/xtlyk/zabbix_modules\e[0m"
  echo -e "\e[31m此操作不影响zabbix使用\e[0m"
  echo -e "\e[31m你可以在“管理”-“常规”-“模块”中点击“扫描目录”后，在列表中查找并启用两个模块\e[0m"
  git clone https://gitee.com/xtlyk/zabbix_modules.git /usr/share/zabbix/ui/modules
  ls -la /usr/share/zabbix/ui/modules

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
      if ( [ "$VERSION_ID" == "8" ] || [ "$VERSION_ID" == "9" ] || [ "$VERSION_ID" == "10" ]); then
          if [ "$ID" == "rocky" ]; then
              config_rocky
          fi
          config_epel
          install_zabbix_release_on_centos_or_rocky
          install_mariadb_release
          config_mariadb_release_on_centos_or_rocky
          dnf install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent MariaDB-server MariaDB-client MariaDB-backup MariaDB-devel langpacks-zh_CN git -y
          systemctl enable mariadb --now
          if systemctl is-active mariadb; then
            echo "MariaDB 安装成功。"
          else
            echo -e "\e[91mMariaDB 安装失败,怀疑是网络问题（你懂得）。请使用以下命令安装 MariaDB 后重试: \e[0m"
            echo -e "\e[91m安装 MariaDB 源: curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | bash -s -- --mariadb-server-version=11.4\e[0m"
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
    almalinux)
      # AlmaLinux 的安装步骤
      VERSION_ID=$(echo "$VERSION_ID" | cut -d'.' -f1)
      if ( [ "$VERSION_ID" == "8" ] || [ "$VERSION_ID" == "9" ] || [ "$VERSION_ID" == "10" ]); then
          config_alma
          config_epel
          install_zabbix_release_on_alma
          install_mariadb_release
          dnf install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent MariaDB-server MariaDB-client MariaDB-backup MariaDB-devel langpacks-zh_CN git -y
          systemctl enable mariadb --now
          if systemctl is-active mariadb; then
            echo "MariaDB 安装成功。"
          else
            echo -e "\e[91mMariaDB 安装失败,怀疑是网络问题（你懂得）。请使用以下命令安装 MariaDB 后重试: \e[0m"
            echo -e "\e[91m安装 MariaDB 源: curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | bash -s -- --mariadb-server-version=11.4\e[0m"
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
            echo -e "\e[91m安装 MariaDB 源: curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | bash -s -- --mariadb-server-version=11.4\e[0m"
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
