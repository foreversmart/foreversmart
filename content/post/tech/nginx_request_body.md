+++
date = "2019-06-30T10:54 +08:00"
draft = false
title = "记一次 Nginx 转发 request body 异常解决"
slug = "nginx_request_body"
tags = ["Nginx","go", "反向代理"]
image = ""
comments = true	# set false to hide Disqus
share = true	# set false to hide share buttons
menu= ""		# set "main" to add this content to the main menu
author = "foreversmart"
featured = false
description = ""
+++

#### 现象
最近线上观测到一个灵异问题：
    部分 API 请求会报 400 错误

起初我们并没有重视这个问题，以为只是简单的用户参数传入错误，导致验证参数的逻辑抛出 400
错误。但是这个问题偶尔会出现频率不算高也不算低，但是一些关键的 API 服务如果挂了会导致
用户端报错这对用户的体验是极差的。具体去观察每一个请求的报错发现 body 在解析成 json 的时候报格式错误
具体原因是因为这个时候从 http request body 中读取到的字节流不是 json 格式的。
下面是一个有问题的 body

``` 
؃E�\u0017c�X=e���1\u000b�BB\u0015\b�_Y$���у�=HN\r$�\u0019��\u0005[�5��=�I�|m�+��̈_\u001b�5CM�\u0016\r\u000ep�n���\\��Ȩ���J�����\u0016\u001e3gȫ7�7\u001aj��l.��s�\u0006=\u0010�[v8C��T4�ax��\u0018�@\u0015��ԕ\t\u001d5� \u0005��̇x\u001cU�DҬ��?��z��f�����S��2\u001a��\u0013������4\f�jܧ�\u0004Aj&��!��\u000bȱ�2Xm�We�?�������\u0006�U1\u0014�O��z{\u000fIXu���.�\u0005�Д�9Ga�m�We�����\u0006��\u001cz/\u000b��V���Ϗ�\u0002��f�����S��2\u001a��\u0013������4\f�jܧ�\u0004Aj&��!��\u000bȱ�2Xm�We�?�������\u0006�U1\u0014�O��z{\u000fIXu���.�\u0005�Д�9Ga�m�We��@��cTkV�\u0005���_\u0000���\u0000\u0002\u0018\u0000\u0001\u0000\u0003��{\"infos\":[{\"region_id\":\"cn-hangzhou\",\"order_type\":\"create\",\"amount\":1,\"cost_charge_mode\":\"PayByInstance\",\"cost_charge_type\":\"PrePaid\",\”cost_pe
```

线上还有大量的这类错误的 body
分析他们的规律发现他们要么是原始 body 丢了一块，或者多了一些字符
这个问题很像是 body 流出了问题

#### 排查

##### 业务架构
排查前先梳理下我们的服务架构和数据流
前端 -> 对外 nginx -> 反向代理 -> 我们服务 ningx -> 后端服务 server

##### 原因假设
我们发现通过前端不停的刷新
页面，大概刷新3-5次一定会有一两个 API 调用抛 400 错误。这个现象太诡异了，我们先做了几个初步的
假设：
    
1.前端参数封装问题

2.后端在处理 unmarshal json 的时候出现问题

3.反向代理转发出了问题

##### 具体验证
开始验证, 我们写了一些 API 的测试脚本
发现并发的测试脚本必现这个问题

``` go
func main() {
   runtime.GOMAXPROCS(64)
   for i := 0; i < 200; i++ {
      go request()
   }
   time.Sleep(time.Second * 30)
}

func request() {
   url := "https://test.com/v1/resource"
   payload := strings.NewReader("{\"data\": \"something\"}")
   req, _ := http.NewRequest("POST", url, payload)
   res, _ := http.DefaultClient.Do(req)
   result, _ := ioutil.ReadAll(res.Body)
   defer res.Body.Close()
   fmt.Println(res.StatusCode)
}
```

如果把脚本中并发的部分去掉，改为一个个去调用 API 就全部正常
那基本可以排除前端和后端 unmarshal 的问题了

接着我们开始对反向代理层进行分析和测试, 反向代理核心代码：

``` go
proxy := httputil.ReverseProxy{
    Director: func(req *http.Request) {
        req.Host = targetURL.Host
        req.URL.Scheme = targetURL.Scheme
        req.URL.Host = targetURL.Host
    },
    Transport: NewClient(Proxy.AccessKeyID, Proxy.AccessKeySecret, logger),
}

proxy.ServeHTTP(c.Rw, c.Req)

type Client struct {
	AccessKey    string
	AccessSecret string
	Logger  Logger
}

func NewClient(ak, sk string, logger  Logger) *Client {
	return &Client{
		AccessKey:        ak,
		AccessSecret:     sk,
		Logger: logger,
	}
}

func (c *Client) RoundTrip(r *http.Request) (resp *http.Response, err error) {
	query := r.URL.Query()
	req, _ := http.NewRequest(r.Method, r.URL.String(), r.Body)
	
	// 鉴权部分

	// copy headers
	req.Header = r.Header

	client := http.Client{
		Transport: &http.Transport{
			Dial: (&net.Dialer{
			}).Dial,
		},
		Timeout: 60 * time.Second,
	}
	resp, err = client.Do(req)

	if err != nil {
		c.Logger.Errorf("request body error %v", err)
	} 
	return
}

```

可以看出来我们的反向代理就是比较简单的 golang 反向代理上加了鉴权功能
把发现代理放到本地做了压测和并发测测试也没有发现 http request body 的包出现异常的情况

下面只能去找运维核对中间过程中中间件的问题
 
运维发现两个 nginx （对外 nginx 和 后端服务的 nginx） 的版本是不一致的，且第一个 nginx （对外） 开启了 http2：
第一个 nginx 版本：1.16.0 （对外的 ningx）， 第二个 nginx 版本：1.10.2 （后端服务的 nginx） 

因为 http2 可能会有类似流复用的问题，但是我们的应用服务器并没有开启 http2

就往下去追查 nginx 的日志

发现 架构里面第一个 nginx 的日志用的 http2， 第二个 nginx 日志 用的 http1 
再看下去发现 第一个 nginx 是开启 http2 协商的，而 chrome 或是 Go 默认的 http client 都是默认支持 http2 协商的，也就是 第一个 nginx 开启了 http2 所以 ：
chrome 和 go client 都会以 http2 的方式和 第一个 nginx进行 通讯，而 第一个 nginx 向后面 反向代理 和 nginx 发送的时候只能以 http1 进行发送
我们强制客户端 go client 使用 http1 的方式请求服务，发现依然会有这个错误。


我们再去对比 nginx 1.10.2 -> nginx 1.16.0 去看所有有可能和 request body 相关的 issue [https://nginx.org/en/CHANGES-1.16](https://nginx.org/en/CHANGES-1.16)

```
Changes with nginx 1.13.6      
 *) Bugfix: when using HTTP/2 client request body might be corrupted.
Changes with nginx 1.13.4      
 *) Bugfix: request body might not be available in subrequests if it was
      saved to a file and proxying was used.
Changes with nginx 1.11.7   
 *) Bugfix: when using HTTP/2 and the "limit_req" or "auth_request"
       directives client request body might be corrupted; the bug had
       appeared in 1.11.0.
Changes with nginx 1.11.0  
  *) Change: HTTP/2 clients can now start sending request body
       immediately; the "http2_body_preread_size" directive controls size of
       the buffer used before nginx will start reading client request body.
       
```

由于验证可能导致的原因非常繁杂，我们决定先升级 nginx 来排除 nginx 的问题

我们最后将两个 nginx 版本 统一版本为1.16.0 结果发现线上问题被彻底修复。


