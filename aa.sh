#!/bin/bash
read -p "请输入IP地址:" ip
read -p "请输入yum源地址:" aa
expect << EOF
spawn  ssh-copy-id $ip 
expect "password:"  {send "123456\n"}
expect "#" {send "exit\n"}
EOF
expect << EOF
spawn ssh -X $ip
expect "]#" {send "echo \[aa\] > /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "echo name=lc >> /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "echo baseurl=ftp://$aa/rhel7 >> /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "echo enabled=1 >> /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "echo gpgcheck=0 >> /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "exit\n"}
EOF
scp '/root/桌面/lnmp_soft.tar.gz' $ip:~
expect << EOF
spawn ssh -X $ip
expect "]#"  {send "tar -xf lnmp_soft.tar.gz\n"}
expect "]#"  {send "cd lnmp_soft/\n"}
expect "]#"  {send "tar -xf nginx-1.12.2.tar.gz\n"}
expect "]#"  {send "cd nginx-1.12.2/\n"}
expect "]#"  {send "useradd nginx\n"}
expect "]#"  {send "./configure --user=nginx --group=nginx --with-http_ssl_module --with-stream --with-http_stub_status_module >/dev/null\n"}
expect "]#"  {send "make && make install >/dev/null\n"}
expect "]#"  {send "systemctl stop httpd >/dev/null\n"}
expect "]#"  {send "systemctl disable httpd >/dev/null\n"}
expect "]#"  {send "ln -s /usr/local/nginx/sbin/nginx /sbin/\n"}
expect "]#"  {send "nginx >/dev/null\n"}
expect "]#"  {send "yum -y install mariadb-server mariadb-devel >/dev/null\n"}
expect "]#"  {send "cd\n"}
expect "]#"  {send "cd /root/lnmp_soft/\n"}
expect "]#"  {send "yum -y install php-fpm-5.4.16-42.el7.x86_64.rpm >/dev/null\n"}
expect "]#"  {send "systemctl restart mariadb.service >/dev/null\n"}
expect "]#"  {send "systemctl restart php-fpm.service >/dev/null\n"}
expect "]#"  {send "systemctl enable php-fpm.service >/dev/null\n"}
expect "]#"  {send "systemctl enable mariadb.service >/dev/null\n"}
expect "]#"  {send "netstat -aupnt |grep 80\n"}
expect "]#"  {send "netstat -aupnt |grep 9000\n"}
expect "]#"  {send "netstat -aupnt |grep 3306\n"}
expect "]#"  {send "exit\n"}
EOF
