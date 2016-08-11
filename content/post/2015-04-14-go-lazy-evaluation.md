+++
date = "2015-04-14T10:54:24+02:00"
draft = false
title = "Go Lazy Evaluation"
slug = "go_lazy_evaluation"
tags = ["go"]
comments = true	# set false to hide Disqus
share = true	# set false to hide share buttons
menu= ""		# set "main" to add this content to the main menu
author = "foreversmart"
featured = false
description = "golang 惰性求值"
+++

作者：ForeverSmart   
[原文链接:](http://foreversmart.github.io/go/2015/04/14/go-lazy-evaluation) http://foreversmart.github.io/go/2015/04/14/go-lazy-evaluation/

----

### Lazy Evaluation

惰性求值(Lazy Evaluation)：是一种计算策略，延迟计算一个表达式或函数当需要时才进行计算

我们可以通过惰性求值来避免不必要的计算，也可以通过惰性求值来构造一个无限数据结构,还可以通过惰性求值定义一个像原语的控制流。

在介绍惰性求值前,先来举一个生成器(Generator)的例子
这个生成器是一个函数每次调用会返回特定序列中的下一个值
这其实就是一个惰性求值的应用，因为每次返回的是需要的下一个值而不是整个序列

eg. generator

	package main

	import (
		"fmt"
	)

	var se chan int

	func counter() chan int {
		temp := make(chan int)
		count := 0
		go func() {
			for {
				temp <- count
				count++
			}
		}()
		return temp
	}

	func generator() int {
		return <-se
	}

	func main() {
		se = counter()
		fmt.Println(generator()) //=> 0
		fmt.Println(generator()) //=> 1
		fmt.Println(generator()) //=> 2
	}


构造无限数据结构：
因为惰性求值的特性，只计算当前的需要的值。也就是我们完全可以定义一个无限的数列或其他结构供我们使用，而不需要在使用前把所有的数据结构中的值都计算。就像上面generator的例子，我们可以利用generator得到自然数n。


//使用惰性求值求解Fibonacci问题

	package main

	import (
		"fmt"
	)

	var se chan int

	func main() {
		for i := 1; i <= 10; i++ {
			fmt.Println(Fibonacci(i))
		}
	}

	func Fibonacci(n int) int {
		se = lazy()
		for i := 0; i < n-1; i++ {
			fibonacci()
		}
		return fibonacci()
	}

	func fibonacci() int {
		return <-se
	}

	func lazy() chan int {
		tempChan := make(chan int)
		lastone, lasttwo := 1, 0
		go func() {
			tempChan <- 1
			for {
				tempChan <- lastone + lasttwo
				lastone, lasttwo = lastone+lasttwo, lastone
			}
		}()
		return tempChan
	}

通过上面惰性求值优化Fibonacci的例子，其实本质和使用循环优化尾递归是相同的。
将线性的递归深度过大的问题，规避掉防止栈溢出。

这里惰性求值中也对数据做记忆，减少重复计算，单纯的记忆函数只能避免重复计算带来的时间开销，而惰性求值避免递归深度过大造成的空间开销。



