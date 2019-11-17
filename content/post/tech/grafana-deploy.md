+++
author = "foreversmart"
comments = true
date = "2017-09-20T19:07:36+08:00"
description = ""
draft = false
featured = false
image = ""
menu = ""
share = true
slug = "post-title"
tags = ["tag1", "tag2"]
title = "grafana deploy and usage"

+++

#### Grafana

Grafana 是一款漂亮的开源分析和监控的平台，它可以让你把数据漂亮的展示出来无论你的数据数据存放在何处和依赖于什么数据库。
它支持![32种数据源](https://grafana.com/plugins?type=datasource), ![27类面板](https://grafana.com/plugins?type=panel)

#### Install on docker

由于特定的场景我们需要将 Grafana 作为服务安装在 docker 上。
我们可以打开 grafana 官方提供的![安装文档](http://docs.grafana.org/installation/docker)
这里面简单的描述了，如何使用官方提供的默认 docker image 去运行 grafana 服务；作为基本的使用这种方式其实已经能满足我们使用的需求了。

由于我们在使用的过程中涉及到的 config 项比较多， 我们可以自定义 docker image 把 grafana 的配置文件 grafana.ini 动态的打包到镜像中。

```
FROM grafana/grafana

ADD grafana.ini /etc/grafana/

CMD grafana \
      --homepath=/usr/share/grafana                 \
      --config=/etc/grafana/grafana.ini             \
```

这样我们运行 ``` docker build -t evm-grafana . ``` 就可以 build 一个带我们自定义配置文件的 grafana 镜像了

#### Config

部署好 grafana 以后我们可以修改 grafana.ini 来配置 grafana

grafana 的配置用的是 .ini 的配置文件格式。默认的配置文件在 ``` $WORKING_DIR/conf/defaults.ini ```; 
用户也可以通过 ``` --config ``` 来自定义配置文件路径。在 grafana 里面配置项分成了很多个 ``` section ``` 部分
* 认证配置
    
* auth config
* auth github
* smtp server

#### Usage
