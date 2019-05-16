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

