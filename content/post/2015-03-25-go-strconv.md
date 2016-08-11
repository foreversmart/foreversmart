+++
date = "2015-03-14T10:54:24+02:00"
draft = false
title = "Go Strconv使用"
slug = "go_strconv"
tags = ["go"]
comments = true	# set false to hide Disqus
share = true	# set false to hide share buttons
menu= ""		# set "main" to add this content to the main menu
author = "foreversmart"
featured = false
description = "golang strconv 包使用笔记"
+++

作者：ForeverSmart   
[原文链接:](http://foreversmart.github.io/go/2015/03/25/go-strconv/) http://foreversmart.github.io/go/2015/03/25/go-strconv/

----

### GO语言中字符串和其他类型间的转换


##### 1. Go语言中字符串概念  
	
	1.1 使用双引号或反引号定义   
		在双引号中定义的是可以转义的字符串序列，但在双引号中不能定义多行字符串，会在编译时报错，在反引号中可以定义多行的原生字符串序列但不支持转义。一般会在定义多行消息，Html文本，正则表达式等字符串字面量中使用反引号

	1.2 Go语言中字符串是不可变的      
		但我们可以使用可以使用＋级联操作符来连接多个字符串，也可以使用＋＝追加操作符来连接字符串

	1.3  Go语言中字符串是用UTF－8编码的变宽字符序列 
		在java和python中使用码点序列来表示字符串，每一个字符占用16位或32位，但对于英文文本在go语言中只需要8位就可以表示一个字符，所以会比其它语言更节省内存空间

##### 2. 内存模型 

	为了更好的理解GO语言中的字符串，与Unicode 码点值和字节之间的关系 我们下面来对一段中英文混合的字符串进行剖析
	
![image](http://mytutu.qiniudn.com/gostrmem.png)

	大家可以看到"hello世界" 字符串中英文的部分每个字符对应一个unicode码点值，一个unicode码点值对应一个字节，而在后面的中文字符串部分每个中文字符同样对应一个unicode码点值但不同的是，该码点值对应多个字节。

##### 3. GO语言中字符串索引的概念

	和其他语言不同的，其他语言中字符串中的单个字符可以被直接索引
	go语言只有当字符串只包含ASCII字符时才可能被直接索引（ASCII是用单一UTF－8字节表示的）

	GO语言中对字符串的两种索引方式:
	1. 对字符串进行按字节索引
		转换为［］byte 或着 直接使用 string[]数组进行索引
		len(string) 输出字符串的字节切片长度
  		
	2. 对字符串进行按字符索引
		转换为[]rune 的Unicode 码点切片
		或者 使用for...range 对字符串进行一个字符一个字符的迭代

##### 4. strconv转换工具函数

	1. 布尔值和字符串之间的相互转换
	
		函数AppendBool 将一个布尔值追加到一个byte数组中返回
		
		函数FormatBool 将一个不二之转换为字符串返回
		
		函数PareseBool 将字符串参数转换为布尔值返回，如果转换出错error为错误的原因输入字符串”1””t””T””true””TRUE”返回true和nil输入字符串为”0”,”f”,”F”,”false”,”FALSE”会返回false和nil，如果是其他字符串则会返回false和error
		
	2.浮点数和字符串之间的相互转换
	
		函数AppendFolat 将一个64位的浮点数转换为字节追加到byte数组中返回
			参数fmt 表示浮点数转换的格式 b 代表2进制指数  e代表用科学计数法e表示的指数 E代表用科学计数法E表示的指数 f没有指数 g 如果浮点数是大指数则用科学计数法e表示其他情况则用f没有指数 G 如果浮点数是大指数则用科学计数法e表示其他情况则用f没有指数
			参数prec  当fmt参数为 e E f表示 小数点后数字的尾数    当fmt参数为g G时表示所有数字的长度 如果为－1表示最小的能保留精度的个数, 这样使用parseFloat会得到相同的浮点数
			参数bitSize 32表示是返回值转换为float 32    64表示返回值转换为float64

		函数FormatFloat 将一个浮点数按指定的规则精度转换为字符串
		
		函数ParseFloat 将一个字符串按指定的大小转换为浮点数

	3.整形和字符串之间的相互转换
	
		函数AppendInt 将一个 int64转换为字节追加到byte数组中返回
			参数base 表示转换的进制返回从2 － 36 其中大于10的部分用小写字符a-z表示
			
		函数AppendUInt 和 函数AppendInt功能相似不过是对uint64进行转换
		
		函数formatInt和函数FormatUint将int64或uint64按指定的进制转换为字符串
		
		函数ParseInt和函数PareseUint  将int64或uint64按指定的进制和返回大小转换为int返回
			参数bitSize可以为 0， 8， 16， 32 ， 64  分别代表返回值会转换为 int int8 int16 int 32 int64
			如果 base＝0   表示从字符串前缀判断进制 0x或X表示16进制  0表示8进制 其他都为十进制
		函数Atoi一种简单的写法将字符串按10进制转换为int
		
		函数Itoa一种简单的写法将int转换为10进制字符串

	4.字符引号处理
	
		函数AppendQuote 将字符串参数s用双引号形式表示转换为字节追加到第一个byte数组中返回
		
		函数AppendQuoteToASCII和 AppendQuote功能相似但是会对其中非ASCII字符进行转义
		
		函数AppendQuoteRune将字符用单引号形式表示转换为字节追加到第一个byte数组中返回
		
		函数AppendQuoteRuneToASCII和函数AppendQuoteRune功能相似但会对非ASCII字符进行转义
		
		函数Quote 将字符串用双引号表示形式返回 函数QuoteToASCII 会对非ASCII字符进行转义
		
		函数QuoteRune讲字符用单引号形式表示返回字符串 函数QuoteRuneToASCII会对非ASCII进行转义
		
		函数Unquote 将字符串参数中用单引号，双引号，反引号扩起来中的字符或字符串转换为字符串返回。当为双引号时去掉双引号但会对字符串中的字符进行转义，如果是单引号则不会对字符串中的字符进行转义如果字符串中没引号或是不正确的引号则会报错invalid syntax