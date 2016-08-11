---
layout: post
title: "Go inherit and use parent's method"
description: ""
category: 
tags: []
---

问题：

- 当我们使用一个第三方库是使用了其中的一个公开访问的类型；有一种场景是我们想直接利用第三方的类型，增加我们自己的行为。这样可以省略很多重复的代码，简化代码结构，减少很多中间的重复数据结构。
    
- 但是对一个非local的type，想进行修改和增加行为在不影响第三方库正常使用的情况下是非常方便的，但会存在大量的代码隐患，也会出现在调试的过程中type的行为分布在多个不同的package导致代码混乱，不易管理和排查错误。所以Go语言中是不能对非local的type，新增方法的。

- 我们可以使用下面两种方式来实现为远程的类增加行为和方法

	1. 通过组合的设计模式的概念对外部type用本地的type进行包装  
		
		`type mytype{`  
			`out outtype`  
		`}`
		
	
	2. 使用类型代用的方式  
		普通的类型  
	`type mytype outtype`  
	 `outtype(my).method()`  

		指针类型  
	`type mytype *outtype`  
	`(*outtype)(my).method()`   
	`*outtype(my).method()//这种使用方式是错误的`  
