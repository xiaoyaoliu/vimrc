## crontab 不工作的问题

记得查log
https://askubuntu.com/questions/56683/where-is-the-cron-crontab-log

重启指令:
1. service cron restart 或 service crond restart
1. /etc/init.d/cron restart 或 /etc/init.d/crond restart

root用户的crontab文件地址: /var/spool/cron/crontabs/root

经验1: 查看log发现cron restart的时候报语法错误，检查发现，root文件的格式为dos所致

### crontab比设定的次数多执行的问题

https://askubuntu.com/questions/635704/strange-root-cronjob-ive-never-set-it

The script starts with the default definitions in /etc/crontab

## syslog不work的问题

### 确认直接原因是rsyslog重启失败
https://serverfault.com/questions/960287/syslog-not-logging

关键步骤:
* /etc/init.d/rsyslog restart
* systemctl status rsyslog

### 多方查询和尝试，最终决定对rsyslog进行升级来解决问题

https://software.opensuse.org//download.html?project=home%3Argerhards&package=rsyslog

关键步骤
```
echo 'deb http://download.opensuse.org/repositories/home:/rgerhards/Debian_9.0/ /' > /etc/apt/sources.list.d/home:rgerhards.list
apt-get update && apt-get install rsyslog
wget -nv https://download.opensuse.org/repositories/home:rgerhards/Debian_9.0/Release.key -O Release.key
apt-key add - < Release.key
apt-get update
```

### rsyslog升级到最新后，找不到/etc/init.d/rsyslog

执行: systemctl enable rsyslog.service

得到: Failed to enable unit: Unit file /etc/systemd/system/rsyslog.service is masked

解决办法: https://askubuntu.com/questions/804946/systemctl-how-to-unmask

关键步骤:

The commands you are using are both correct. See also the manual.

It seems the unmask command fails when there is no existing unit file in the system other than the symlink to /dev/null. 

If you mask a service, then that creates a new symlink to /dev/null in /etc/systemd/system where systemd looks for unit files to load at boot. 

In this case, there is no real unit file.

Others seem to have similar issues

```py
# rsyslog.service was also masked on my system. You can fix it like this:

# First check that the unit file is a symlink to /dev/null

file /lib/systemd/system/rsyslog.service
# it should return:
# /lib/systemd/system/rsyslog.service: symbolic link to /dev/null

# in which case, delete it
sudo rm /lib/systemd/system/rsyslog.service

# Since you changed a unit file, you need to run this:
sudo systemctl daemon-reload

# now check the status:
systemctl status rsyslog

# if it doesn't say loaded and running (if the circle is still red), reinstall the package:
sudo apt-get install --reinstall rsyslog

# and reload the daemon again
sudo systemctl daemon-reload

# and check status once more
systemctl status rsyslog

# Now it's green and running :) 
# The service has no systemd unit file, but systemd happily uses the script for it in /etc/init.d instead.
/etc/init.d/rsyslog restart
systemctl status rsyslog
```

## packages

### 软件源
https://software.opensuse.org/distributions

### 搜索安装包

#### centos/red hat
直接yum install ifconfig会显示install failed.

所以要用search搜一下这个指令

yum search ifconfig

#### Debian/Ubuntu

apt-cache search rsyslog

查看软件可用版本:

apt-cache policy rsyslog

## mail 发不出去的问题

[Configure Postfix to Send Mail Using Gmail and Google Apps on Debian or Ubuntu](https://www.linode.com/docs/email/postfix/configure-postfix-to-send-mail-using-gmail-and-google-apps-on-debian-or-ubuntu/)

### 重启(systemctl restart postfix)失败的解决方法

注意监听log

* tail -f /var/log/syslog
* tail -f /var/log/mail.log
* zcat /var/log/syslog.2.gz | grep xxxx

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

## docker相关

### 彻底卸载docker

https://askubuntu.com/questions/935569/how-to-completely-uninstall-docker/950844

To completely uninstall Docker:

Step 1

```
dpkg -l | grep -i docker
```
To identify what installed package you have:

Step 2
```
sudo apt-get purge -y docker-engine docker docker.io docker-ce  
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce  
```
The above commands will not remove images, containers, volumes, or user created configuration files on your host. If you wish to delete all images, containers, and volumes run the following commands:

```sh
sudo rm -rf /var/lib/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
```

You have removed Docker from the system completely.
