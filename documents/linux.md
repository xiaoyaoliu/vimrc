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

apt-get install mailutils

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

## python相关

## debian上安装python3.7

由于默认python版本是3.5，而某些软件需要3.7，所以只能从源码编译

1. 安装必要的依赖包
apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev curl libbz2-dev 
2. 下载python源码, X替换为最新版本号
curl -O https://www.python.org/ftp/python/3.7.X/Python-3.7.X.tar.xz
tar -xf Python-3.7.X.tar.xz
3. 安装
./configure --enable-optimizations
make
make altinstall
python3.7
4. 将python3设置为python3.7
ln -s /usr/local/bin/python3.7 /usr/bin/python3

### 编译python3.7中间遇到的问题

Q1: No module named 'lsb_release' after install Python 3.7.X from source
A1: https://askubuntu.com/questions/965043/no-module-named-lsb-release-after-install-python-3-6-3-from-source

Q2: Building Python 3.7.1 - SSL module failed
A2: https://stackoverflow.com/questions/53543477/building-python-3-7-1-ssl-module-failed

### 关于问题2的重点摘要:

1. Compiling openssl

curl https://www.openssl.org/source/openssl-1.0.2o.tar.gz | tar xz
cd openssl-1.0.2o
./config -fPIC -shared
make && make install
export PATH="/usr/local/openssl/lib:$PATH"
export LD_LIBRARY_PATH=/path/to/openssl/lib:$LD_LIBRARY_PATH

2. Compiling Python3，重点关注configure的参数!!
sudo ./configure --with-openssl=/usr/local --enable-optimizations

注意: The key here is understanding that the path you define with  --with-openssl=  is where Python looks for /openssl/lib. You need to give Python the parent directory of the openssl directory.

That means that if you set  --with-openssl=/usr/local/openssl  your make install will fail even though the make logs show that openssl is fine!

--enable-optimizations is irrelevant but recommended - longer make for 10% faster Python code is a good tradeoff.



