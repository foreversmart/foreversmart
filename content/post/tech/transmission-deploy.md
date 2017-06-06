+++
author = "foreversmart"
comments = true
date = "2017-05-27T11:45:54+08:00"
description = ""
draft = false
featured = false
image = ""
menu = ""
share = true
slug = "deploy-transmission"
tags = ["centos", "linux", "soft"]
title = "centos7 下部署 transmission"

+++

##### Transmission 是一款跨平台的BitTorrent客户端，界面非常简洁。正是因为这个原因我们可以将它部署到linux 系统上。

#### 在你的系统中开启[EPEL repository](http://idroot.net/tutorials/install-enable-epel-repo-centos-5-centos-6-centos-7/)

``` bash
yum install epel-release
yum -y update
```
#### 安装Transmission

``` bash
yum install transmission-cli transmission-common transmission-daemon
```
安装成功后可以通过运行下面的命令来确认是否安装成功

```bash
systemctl start transmission-daemon.service
systemctl stop transmission-daemon.service
```
#### 配置Transmission

* 打开transmission的配置文件
``` bash
vim /var/lib/transmission/.config/transmission-daemon/settings.json
```

* 配置访问认证
``` bash
"rpc-authentication-required": true,
"rpc-enabled": true,            
"rpc-password": "mypassword",   // 认证的密码
"rpc-username": "mysuperlogin", // 认证的用户名
"rpc-whitelist-enabled": false, // 是否开启访问白名单
"rpc-whitelist": "0.0.0.0",
"rpc-bind-address": "0.0.0.0",
"rpc-port": 8081,
"rpc-url": "/transmission/",
```

* 设置下载目录
``` bash
"download-dir": "/data1/Downloads",
"download-queue-enabled": true,
"download-queue-size": 5,
```
* 修改完配置启动transmission
``` bash
systemctl start transmission-daemon.service
```

* 启动成功后我们就可以通过配置好的域名或ip 访问我们的管理界面

#### 注意

* 新开的rpc-port需要在防火墙中打开 
``` bash
firewall-cmd --permanent --add-port=8081/tcp
systemctl restart firewalld
```

* 认证密码: </br>
transmission 启动的时候会检测他的密码是不是一个hash， 如果不是hash处于安全考虑
transmission 会把它设成hash。同时transmission 在关闭的时候会把它加载的密码重新写到配置文件；
所以再transmission 运行的时候，修改密码是不会生效的。所以直接restart 会导致修改密码失败，
正确的做法如下
``` bash
systemctl stop transmission-daemon.service
change rpc-password
systemctl start transmission-daemon.service
```

