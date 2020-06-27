
## 当其他机器可以正常上google，唯独某个机器不行的问题
注意检查本地的/etc/host文件是否被人篡改

## 项目地址
https://github.com/trailofbits/algo
服务器使用谷歌云，重点看下这个：https://trailofbits.github.io/algo/cloud-gce.html

## 安装algo

1. 确认Python3是否是3.6 或者 3.7, 不是的话装一个

git clone https://github.com/trailofbits/algo.git

apt install -y python3-virtualenv

cd /path/to/algo

python3 -m virtualenv --python="$(command -v python3)" .env &&
  source .env/bin/activate &&
  python3 -m pip install -U pip virtualenv &&
  python3 -m pip install -r requirements.txt



## 安装gcloud

wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-293.0.0-linux-x86_64.tar.gz

tar -zxvf google-cloud-sdk-293.0.0-linux-x86_64.tar.gz
 
./google-cloud-sdk/install.sh

ln -s /home/zx/google-cloud-sdk/bin/gcloud /usr/local/bin/

2. 初始化gcloud

gcloud init

注意: 此步骤一定要走验证码验证的流程！
cloud project选择: zhangxv9211

3. 生成gce.json文件，为algo的配置做准备

## Create the project to group the resources
```bash
### You might need to change it to have a global unique project id
PROJECT_ID=zhangxv9211
### BiLLING_ID就是谷歌云的结算账号, 应该可以忽略
BILLING_ID="$(gcloud beta billing accounts list --format="value(ACCOUNT_ID)")"

### Create an account that have access to the VPN
gcloud iam service-accounts create algo-vpn --display-name "Algo VPN"
gcloud iam service-accounts keys create configs/gce.json \
  --iam-account algo-vpn@${PROJECT_ID}.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:algo-vpn@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/compute.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:algo-vpn@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/iam.serviceAccountUser

### Enable the services
gcloud services enable compute.googleapis.com

## 这步先不执行，等配置完了algo服务器一起弄
./algo -e "provider=gce" -e "gce_credentials_file=$(pwd)/configs/gce.json"

```
### 修改algo的默认配置
vim config.cfg

要修改的内容如下:
```bash
# 只用wireguard即可，关闭ipsec
ipsec_enabled: false

# gce: external_static_ip 可能要改为true, 也可以后续再绑定静态ip
#动态IP和静态IP的区别在于：动态IP需要在连接网络时自动获取IP地址以供用户正常上网，而静态IP是ISP在装机时分配给用户的IP地址，可以直接连接上网，不需要获取IP地址。

#静态IP又称为固定IP，是运营商的专线业务提供的一种IP形式，安装专线后运营商会提供固定IP及对应的子网掩码、网关，然后我们将固定IP的信息配置在本地连接里，这样我们电脑开机时就会少了获取IP的过程。其实固定IP大多数是用来做网站、运行各种服务的服务器
# 因为只要一个ip在用，无论是静态ip和动态ip收费是一样的，
# 所以，能用静态尽量用静态，只要保证静态ip不闲置即可！！！
# https://cloud.google.com/compute/all-pricing#ipaddress
external_static_ip: true 
```

### 启动algo

./algo -e "provider=gce" -e "gce_credentials_file=$(pwd)/configs/gce.json"

启动后的选项: gce-algo y n y y 1

安装完成后记一下登录gce-algo的方法:

ssh -F configs/xx.xx.xx.xx/ssh_config gce-algo

### wireguard客户端的配置
```bash
tar -czf algo_configs.tar.gz configs

cp ./algo_configs.tar.gz /home/zx/

# 修改wireguard文件的权限，以便于后续可以用scp下载
chmod o+r /home/zx/algo_configs.tar.gz
```
### iphone客户端配置

然后在自己的个人电脑上执行:

```bash
scp xx.xx.xx.xx:/home/zx/algo_configs.tar.gz ~/Downloads

mkdir ~/Downloads/algo 

cd ~/Downloads/algo

tar -xzvf ~/Downloads/algo_configs.tar.gz

# 在个人电脑上远程登录服务器
ssh -F configs/xx.xx.xx.xx/ssh_config gce-algo
```

需要切换下海外的apple id，在app store下载wireguard应用, 用wireguard扫描下~/Downloads/configs/xx.xx.xx.xx/wireguard/phone.png即可

### macair客户端配置
有两种方法: 第一种和iphone类似，切换apple id, 直接下载；第二种方法是用brew，比较慢
```bash
# 安装客户端: 
brew install gpg qrencode grepcidr wireguard-tools

# 下载wireguard配置文件: 
scp xx.xx.xx.xx:/home/zx/wireguard/laptop.conf ~/Desktop

# 后台启动wireguard: 
wireguard-go ~/Desktop/laptop.conf
```
