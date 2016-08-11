+++
date = "2014-12-04T10:54:24+02:00"
draft = false
title = "学习GO routine"
slug = "goroutine"
tags = ["go","goroutine"]
image = "https://morsmachine.dk/in-motion.jpg"
comments = true	# set false to hide Disqus
share = true	# set false to hide share buttons
menu= ""		# set "main" to add this content to the main menu
author = "foreversmart"
featured = false
description = "goroutine 特性介绍"

+++

最近因为项目需要研究go routine，先记录routine 的一些特性待完整后在做整理

- go routine并不是并发而是并行（需要并发需要设置cpu数量）
- go routine并发的条件是被阻塞，如果不被阻塞不会被动切换
- go routine在程序结束后任然会运行，如果是死循环,不知道可不可以用message推出
- 如果go routine 里面发生error defer 怎么执行还是不变么