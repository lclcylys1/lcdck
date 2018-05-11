#!/bin/bash
expect << EOF
spawn ssh -X $1
expect "]#" {send "touch /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "echo \[aa\] > /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "echo name=lc >> /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "echo baseurl=ftp://$2/rhel7 >> /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "echo enabled=1 >> /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "echo gpgcheck=0 >> /etc/yum.repos.d/aa.repo\n"}
expect "]#" {send "exit\n"}
EOF

