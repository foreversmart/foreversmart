+++
date = "2015-04-20T10:54:24+02:00"
draft = false
title = "Go Function Introduction 2"
slug = "go_function_2"
tags = ["go", "function"]
comments = true	# set false to hide Disqus
share = true	# set false to hide share buttons
menu= ""		# set "main" to add this content to the main menu
author = "foreversmart"
featured = false
description = "golang 函数使用2"
+++

作者：ForeverSmart   
[原文链接:](http://foreversmart.github.io/go/2015/04/20/go-function-introduction-2/) http://foreversmart.github.io/go/2015/04/20/go-function-introduction-2/

----

### Go语言函数传参和返回值

#### 返回值

Go语言中函数会返回零到多个值（在c,c++，java和c#中只有一个返回值)

函数多参数返回时，可以使用_空标识符忽略特定的返回值。

Go语言函数支持命名返回参数，命名返回参数可以使代码更简明和自说明。

####参数

Go语言函数支持不定长变参
   	
函数变参最后一个参数可以用...type声明函数出可以传入多个该类型的值，函数用一个slice type来接收这些变量。如果多个参数在数组中可以用arr...来传入
   	
Go语言中默认向函数通过值传递来传递参数，会对变量做一个拷贝，在函数中会修改拷贝的变量但是原来的变量不会被修改。
	
当不定长变参是不同类型的两种解决方案：
  
- 定义一个struct类型聚集可能的参数 
 
- 使用interfacejie口来统一类型，在函数内部对变量类型做断言和转换
    
###### 函数参数传递方式：

Go语言中默认向函数通过值传递来传递参数，会对变量做一个拷贝，在函数中会修改拷贝的变量但是原来的变量不会被修改。
	
如果需要改变原来的变量，可以传递变量的地址引用传递，如果传递的变量是指针类型，指针会被拷贝但指针指向的数据不会进行拷贝，可以通过指针来修改原来的数据。传递一个指针是一个会比之传递更加高效，因为只需要拷贝指针的地址而变量需要拷贝所有的内容。
	
在Go语言中有些类型如slices，maps，interfaces，和channels在函数传递的过程中既会表现出引用传递的特性也会表现出值传递的特性，常常会迷惑大家不知道什么时候是引用传递，什么时候是值传递。下面用一个例子让大家清楚在这些类型下怎么区分引用传递和值传递。
	
在Go语言中比如：slices，maps，interfaces，和channels都是引用传递，但这里具有一定的迷惑性是在区分引用传递和值传递的概念，前面我们把传递变量地址的方式称为引用传递，而我们在修改上面slices,maps，interfaces,和channels时有两种常见的使用方式一种是修改地址另一种是修改数据。对于第一种修改地址的情况表现出的就是值传递的特性，因为这个时候地址就是的数据，而第二种修改数据的方式表现出引用传递的特性。
	
类似的我们可以发现如slices,maps，interfaces,和channels这些类型的传递方式取决于函数体中的使用方式。如果改变他们指向的数据就会表现出值传递的特性，因为这里传递的值就是地址，改变的值也是地址。如果通过他们的地址去改变数据就是引用传递。