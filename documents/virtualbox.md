## centos

### 使用VirtualBox增强功能插件，实现虚拟主机与本地主机的文件共享。

#### 检查CentOS是连接网络

因为需要安装相关的软件，所以需要先检查网络连接情况。

ping www.baidu.com

如果能够ping通，说明网络连接正常
如果ping不通

dhclient eth0:分配ip给eth0

/etc/sysconfig/network-scripts/ifcfg-eth0，将ONBOOT="no"改为ONBOOT="yes"：这样设置能够使每次重启可以自动获取ip

注: 这里不一定叫eth0, 具体的名字: ls /etc/sysconfig/network-scripts


#### 准备安装环境（版本问题，较多基础程序没有安装）

yum update : 更新系统现有的可更新文件

yum install gcc : 安装GNU编译器套件

yum install kernel-devel ： 安装kernel-devel工具

yum install bzip2： 安装解压工具

reboot ：重启系统

#### 安装 VBoxGuestAdditions.iso镜像并挂载

打开CentOS系统，并以root权限进入系统

系统正常启动后，点击设备——>CD/DVD 设备——>选择ios文件，文件位于VirtualBox安装文件夹下

mkdir /cdrom

将CD进行挂载。mount /dev/cdrom /cdrom 

进入cdrom并运行相关程序。cd /cdrom; sh ./VBoxLinuxAdditions.run (等待程序安装完毕，VirtualBox增强功能软件就在系统中安装完毕)


#### 配置共享文件夹

本地主机创建共享文件夹 d:\share

点击运行的虚拟机设备——>共享文件夹设置——>机器文件，添加共享文件夹——>选中创建的文件夹，填写名字，选择永久分配——>点击确定

在虚拟机中创建共享文件夹。mkdir /share

从虚拟机中进行文件夹挂载。 mount -t vboxsf share（这是指主机文件夹名） share（这是指终端挂载点名）
