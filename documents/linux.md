## crontab 不工作的问题

记得查log
https://askubuntu.com/questions/56683/where-is-the-cron-crontab-log

重启指令:
1. service cron restart 或 service crond restart
1. /etc/init.d/cron restart 或 /etc/init.d/crond restart

root用户的crontab文件地址: /var/spool/cron/crontabs/root

经验1: 查看log发现cron restart的时候报语法错误，检查发现，root文件的格式为dos所致

## packages

### 搜索安装包
直接yum install ifconfig会显示install failed.

所以要用search搜一下这个指令

yum search ifconfig

## mail 发不出去的问题

[Configure Postfix to Send Mail Using Gmail and Google Apps on Debian or Ubuntu](https://www.linode.com/docs/email/postfix/configure-postfix-to-send-mail-using-gmail-and-google-apps-on-debian-or-ubuntu/)

### 重启(systemctl restart postfix)失败的解决方法

注意监听log

* tail -f /var/log/syslog
* tail -f /var/log/mail.log

log中发现:

postfix/master[13486]: fatal: bind 0.0.0.0 port 25: Address already in use

查看25端口占用情况:

lsof -i -P -n | grep 25

### 防火墙的设置

iptables详解与概念: https://www.zsythink.net/archives/1199

iptables开启特定端口: https://github.com/judasn/Linux-Tutorial

例如:
* iptables -A OUTPUT -p tcp --sport 587 -j ACCEPT
* iptables -A OUTPUT -p tcp --sport 25 -j ACCEPT
