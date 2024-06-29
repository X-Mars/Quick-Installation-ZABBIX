#!/bin/bash
#author: 火星小刘
#url: https://github.com/X-Mars/Quick-Installation-ZABBIX
#description: docker 版本 Zabbix 7 安装脚本

# 安装docker
install_docker_ce_on_rocky_or_centos() {
  echo '为Rocky Linux / CentOS安装docker...'
  # 安装依赖
  dnf install -y yum-utils device-mapper-persistent-data lvm2
  # 添加docker源
  dnf config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  sudo sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
  # 安装docker
  dnf install -y docker-ce docker-ce-cli docker-compose-plugin
  # 启动docker
  systemctl start docker
  # 设置开机启动
  systemctl enable docker
  # 查看docker版本
  echo '查看docker版本...'
  # 
  docker --version
  docker compose version
}

install_docker_ce_on_ubuntu() {
  echo '为Ubuntu安装docker...'
  # 安装依赖
  apt update
  apt install -y apt-transport-https ca-certificates curl software-properties-common
  # 添加docker源
  curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository -y "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
  # 安装docker
  apt update
  apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  # 启动docker
  systemctl start docker
  # 设置开机启动
  systemctl enable docker
  # 查看docker版本
  echo '查看docker版本...'
  docker --version
  docker compose version
}

docker_pull_zabbix7() {
  # 拉取zabbix7镜像
  docker pull registry.dockermirror.com/zabbix/zabbix-server-mysql:ubuntu-7.0-latest
  docker pull registry.dockermirror.com/zabbix/zabbix-web-apache-mysql:ubuntu-7.0-latest
  docker pull registry.dockermirror.com/zabbix/zabbix-agent:ubuntu-7.0-latest
  docker pull registry.dockermirror.com/library/mysql:8.0.37-oraclelinux9
}

docker_run_zabbix7() {
  docker compose up -d
  docker ps
}

notification() {

  echo -e "\e[32mAuthor: \e[0m\e[33m火星小刘 / 中国青岛\e[0m"
  echo -e "\e[32m作者github: \e[0m\e[33mhttps://github.com/X-Mars/\e[0m"
  echo -e "\e[32m跟作者学运维开发: \e[0m\e[33mhttps://space.bilibili.com/439068477\e[0m"
  echo -e "\e[32m本项目地址: \e[0m\e[33mhttps://github.com/X-Mars/Quick-Installation-ZABBIX\e[0m"
  echo -e "\e[32m当前脚本介绍: \e[0m\e[33mZabbix 7 docker 安装脚本\e[0m"
  echo -e "\e[32m支持的操作系统: \e[0m\e[33mrocky linux 9 / ubuntu 24.04 \e[0m"

  echo -e "\n\e[31m数据库root用户默认密码为huoxingxiaoliu,zabbix用户默认密码 huoxingxiaoliu\e[0m"

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
    echo -e "\e[32m访问继续下一步操作:  http://$i/\e[0m"
  done

  echo -e "\e[32m默认用户名密码:  Admin / zabbix\e[0m"
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
          install_docker_ce_on_rocky_or_centos
      else
          echo "不支持的操作系统版本,脚本停止运行。"
          exit 1
      fi
      ;;
    debian|ubuntu)
      # Debian 或 Ubuntu 的安装步骤
      VERSION_ID_BIG=$(echo "$VERSION_ID" | cut -d'.' -f1)
      if ( [ "$VERSION_ID" == "12" ] || [ "$VERSION_ID_BIG" == "22" ] || [ "$VERSION_ID_BIG" == "24" ] ); then
      
          install_docker_ce_on_ubuntu
      else
          echo "不支持的操作系统版本,脚本停止运行。"
          exit 1
      fi
      ;;
  esac
fi

docker_pull_zabbix7
docker_run_zabbix7
notification
