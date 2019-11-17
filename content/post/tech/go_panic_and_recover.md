+++
date = "2018-09-20T19:07:36+08:00"
draft = false
title = "GO panic and recover"
slug = "go_panic_recover"
tags = ["golang","panic", "recover"]
image = ""
comments = true	# set false to hide Disqus
share = true	# set false to hide share buttons
menu= ""		# set "main" to add this content to the main menu
author = "foreversmart"
featured = false
description = ""
+++

因为最近发现 GO协程下的任务会 panic 导致程序 crash 所以对 go 函数进行了封装
``` go
type HandleFunc func()
func Go(handleFunc HandleFunc) {
   go func() {
      defer func() {
         if r != nil {
           // 原生logger
           var logger *log.Logger
           logger = log.New(os.Stderr, "\n\n\x1b[31m", log.LstdFlags)
           // qvm logger
           msg := fmt.Sprintf("[Recovery] panic recovered:\n%s\n%s%s", r, stack, reset)
           logger.Println(msg)
        }
      }()
      handleFunc()
   }()
}
```
有了我们自定义的 GO 函数以后就对线上的代码进行修改
``` go
for _, b:= persons{
    go func(a *Person) {
        fmt.Println(a)
    }(b)
}
```
修改为
```
for _, b:= persons{
    Go(func(){
        func(a *Person) {
        fmt.Println(a)
    }(b))
}
```
但是发现 线上出现了诡异的问题，线上一直打印的是最后一个用户
仔细一看原来是GO lang 闭包 保留的是 b 的引用，所以协程 func（）里面的 Person 对象都是数组最后一个的引用

第二个关于闭包问题：
``` go
func CatchRecover(r interface{}) {
   if r != nil {
      // 原生logger
      var logger *log.Logger
      logger = log.New(os.Stderr, "\n\n\x1b[31m", log.LstdFlags)
      // qvm logger
      fields := make(map[string]interface{})
      fields["CLASS"] = enums.PANICLoggerClass.String()
      qvmLogger := utils.NewEmptyLoggerWithFields(fields).AddDefaultHook()
      stack := qvm_stack.Stack(4)
      msg := fmt.Sprintf("[QVM Recovery] panic recovered:\n%s\n%s%s", r, stack, reset)
      logger.Println(msg)
      qvmLogger.Error(msg)
   }
}
```
我们对于 panic 写了一个统一的处理 recover 结果的封装函数，用于打印出 panic 时程序的调用栈方便 debug
对于这个 CatchRecover 我们的用法有下面两种：
1：
``` go
defer func() {
   CatchRecover(recover())
}()
```
2：
```
defer CatchRecover(recover())
```
结果发现第一种方式能正常的 recover panic， 第二种程序还是会 panic
阅读 recover 官方说明：

上面提到 recover 如果不在defer function 里面就不会 阻止程序 panic 
所以针对上段代码解读：
第一种方式是一个函数闭包的方式将执行体压入 defer 栈中
第二种方式是将函数 CatchRecover 压入 defer 栈中，这个过程中函数的参数 recover 会在这个时候执行，而不是在 defer function 中执行的，所以这个时候的 recover 不会阻止 panic 并且也 recover 不到任何值

