
## linux上安装mariadb

http://blog.takwolf.com/2016/10/17/setup-mariadb-on-ubuntu/index.html

### 注意事项

执行以下命令，必须用linux的root权限:
* mysql -u root -p
* mysql_secure_installation

不用root权限执行如上命令后果是： 怎么输入密码都会告诉你不对

### 修改mysql的root密码(忘记原密码的时候)

https://robbinespu.github.io/eng/2018/03/29/Reset_mariadb_root_password.html

https://www.digitalocean.com/community/tutorials/how-to-reset-your-mysql-or-mariadb-root-password

### 修改mysql的root密码
``` 
sudo -i
mysql -u root -p
UPDATE mysql.user SET authentication_string = PASSWORD('new_password') WHERE User = 'root' AND Host = 'localhost';
FLUSH PRIVILEGES;
exit
```
