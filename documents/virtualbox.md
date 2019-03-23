## 使用技巧

### 找回鼠标

右边的Ctrl键

## 网络连接方式

virtualbox自带的虚拟机UI不好用，最好能通过ssh的方式连接上去

ssh连接方式的一个前提是: 主机和虚拟机相互ping通

实现了互ping，就可以使用Xshell(secureCRT, putty)实现文件传输, 或者文本粘贴。 

ssh工具里，还是XShell最好用，直接在官网下载免费版即可，不得用于商业用途

### virtualBox实现主机和虚拟机相互ping通,配置静态IP地址

#### 查看主机的网络连接信息

桥接模式的主机必须联网

假设主机系统为Windows 7

1. 单击右下界网络图标
1. 右键单击选择当前的网络
1. 右键菜单中单击"状态"
1. 弹出的状态窗口中，单击"详细信息"

在这个窗口中，以下信息接下来会用到:
* $(描述) 主机的网卡名
* $(IPv4 地址) 主机的IPADDR
* $(IPv4 子网掩码) 主机的NETMASK
* $(Ipv4 默认网关)  主机的GATEWAY

#### 更改VirtualBox的网络连接模式为"桥接网卡"

桥接模式的优点：能够和主机分配在同一个网段下，拥有独立的IP地址，可以和主机互ping。 

设备 -> 网络 -> 网卡1界面

* 连接方式(A): 桥接网卡
* 界面名称(N): 选择 主机的网卡名, $(描述)
* 混杂模式(P): 选择 全部允许
* OK

#### Linux虚拟机network配置

vim /etc/sysconfig/network-scripts/ifcfg-eth0 

文件名称可能不叫ifcfg-eth0 
总之是：/etc/sysconfig/network-scripts/ifcfg-< interface-name> 的这种形式。 

* BOOTPROTO=static
* IPADDR=$(IPv4 地址) 注意ip的末尾需要变动
* NETMASK=$(Ipv4 子网掩码)
* GATEWAY=$(Ipv4 默认网关)
* 保存退出

重启网卡解决桥接无网络问题

service network start

最后确认虚拟机可以联网

ifconfig

ping baidu.com

互ping测试
虚拟机: ping $(IPv4 地址)
主机: ping 虚拟机的IPADDR

其实只要主机可以ping通虚拟机，就可以用ssh命令连接了


## centos

### 使用VirtualBox增强功能插件，实现虚拟主机与本地主机的文件共享。

这种方法只是临时方法，终极方法还是使用ssh

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
