## 创建自己的git服务器
https://www.liaoxuefeng.com/wiki/896043488029600/899998870925664

### 添加git用户

```bash
adduser git
cd /home/git
mkdir .ssh
touch .ssh/authorized_keys
chown -R git:git .ssh
chmod 600 .ssh/authorized_keys 
```
### 用户管理
1. 收集所有需要登录的用户的公钥，加入到/home/git/.ssh/authorized_keys
1. 出于安全考虑，第二步创建的git用户不允许登录shell，这可以通过编辑/etc/passwd文件完成。找到并修改为类似下面的一行：
git:x:1001:1001:,,,:/home/git:/usr/bin/git-shell

### 初始化git仓库

先选定一个目录作为Git仓库，假定是/srv/git_repos/sample.git，在/srv/git_repos目录下输入命令：

$chown -R git:git /srv/git_repos

$git init --bare sample.git

## git extensions软件配置

https://github.com/gitextensions/gitextensions/issues/2931

Command used to run git C:\Program Files\Git\bin\git.exe

Path to linux tools (sh) C:\Program Files\Git\bin\.
