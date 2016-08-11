+++
date = "2015-03-14T10:54:24+02:00"
draft = false
title = "Go Strings Note"
slug = "go_strings_note"
tags = ["go"]
comments = true	# set false to hide Disqus
share = true	# set false to hide share buttons
menu= ""		# set "main" to add this content to the main menu
author = "foreversmart"
featured = false
description = "golang strings 包使用笔记"
+++

作者：ForeverSmart   
[原文链接:](http://foreversmart.github.io/go/2015/03/14/go-strings-package-note/) http://foreversmart.github.io/go/2015/03/14/go-strings-package-note/

----

### GO语言中strings包中字符串处理函数介绍：

	   我们在使用字符串进行编程的过程中经常会遇到关于字符串处理的看相关场景，在Go标准库中的Strings包中已经提供了丰富的工具函数来处理这些问题。

**下面按处理函数的功能性，把这些函数分为8种类型向大家进行介绍:**  

1. 处理包含关系的函数

	函数Contains() 返回一个布尔值  表示传入的第一个字符串参数中是否包含第二个字符串参数  如果第二个字符串参数即字符串为空“”返回值恒为true

	函数ContainsAny()返回一个布尔值 表示传入的第一个字符串参数中是否包含第二个字符串参数中任意的Unicode 码点值，如果第二个字符串参数为空“”则返回值恒为false

	函数ContainsRune() 返回一个布尔值 表示传入的第一个字符串参数中是否包含第二个rune参数

	函数Count() 返回一个int类型的数值 表示在传入的第一个字符串参数中包含第二个字符串参数的非重叠子字符串个数，如果第二个字符串为空则会返回第一个字符串参数用rune切片表示的长度加一

	函数EqualFold 返回一个布尔值表示传入的两个字符串参数在Unicode case-folding模式下是否相等，Unicode case-folding是一种从Unicode编码上的忽略大小写，可以应用在多种语言编码上进行大小写忽略比较。相关链接：http://www.w3.org/International/wiki/Case_folding

2. 处理字符串位置关系的函数

	函数Index() 返回一个int类型的数值 表示传入的第二个字符串参数在第一个字符串参数中的第一个子字符串的位置， 如果第二个字符串参数没有在第一个字符串参数中出现则返回－1

	函数IndexAny 返回一个int类型的数值 表示传入的第二个字符串参数中任意的Unicode 码点值在第一个字符串参数中出现的第一个位置，如果第二个字符串参数中所有的Unicode码点值都不在第一个字符串参数中则返回－1

	函数IndexFunc 返回一个int类型的数值 表示在传入的第一个字符串参数中第一个满足第二个参数中函数返回值为true的Unicode 码点值位置，如果第一个字符串参数中没有满足的Unicode码点值则返回－1

	函数IndexByte 返回一个int类型的数值 表示传入的第二个byte参数在第一个字符串参数中第一个相等的位置，如果第二个byte没有在第一个字符串参数中出现过则返回－1

	函数IndexRune 返回一个int类型的数值 表示传入的第二个Rune参数在第一个字符串参数中第一个相等的位置，如果第二个Rune没有在第一个字符串参数中出现过则返回－1

	函数LastIndex 和 函数Index的功能相似不过返回的是最后一个的位置

	函数LastIndexAny 函数IndexAny的功能相似不过返回的是最后一个的位置

	函数LastIndexFunc 函数IndexFunc的功能相似不过返回的是最后一个的位置

3. 处理字符串分割的函数
     
	函数Fields 通过对传入的字符串参数按一个或多个连续的空白字符进行划分返回一个字符串数组， 这里的空白字符是通过unicode.IsSpace 定义的。包括：'\t', '\n', '\v', '\f', '\r', ' ', 0x85, 0xA0

	函数FieldsFunc 通过对传入的字符串参数按每一个Unicode码点是否满足第二个参数中的函数进行划分返回一个字符串数组，其中连续的满足函数的Unicode码点会合并进行划分

	函数Split 将第一个字符串参数按第二个传入的字符串参数进行划分 返回一个字符串数组

	函数SplitN 将第一个字符串参数按第二个传入的字符串参数进行划分为第三个int参数的个数，返回一个字符串数组，当第三个参数大于0时返回长度最多为这个数的分割结果，其中最后一个子字符串是剩下没有被分割的字符串 为0时返回 nil 当n<0时返回完全分割的结果

	函数SplitAfter 和 函数Split功能相似不过在划分字符串的时候会保留分隔符

	函数SplitAfterN 和 函数SplitN功能相似不过在划分字符串的时候会保留分隔符

4. 处理字符串前缀后缀的函数

	函数HasPrefix 返回一个布尔值表示是否第一个字符串参数以第二个字符串参数开始

	函数HasSuffix 返回一个布尔值表示是否第一个字符串参数以第二个字符串参数结尾

	函数TrimPrefix 把第一个字符串参数中的第二个字符串参数前缀去掉返回，如果第二个字符串参数不是第一个字符串参数的前缀则返回第一个字符串参数

	函数TrimSuffix 和 函数TrimPrefix功能相似不过函数TrimSuffix是去掉第一个字符串参数的后缀

5. 处理字符串大小写相关的转换函数

	函数Title 会对传入参数做一个拷贝并且把每个单词前面的Unicode 字母转换为标题格式返回

	函数ToTitle 和函数Title功能相似不过 函数ToTitle是把所有的Unicode 字母转换为标题格式

	函数ToLower 会对传入参数做一个拷贝并且把所有的Unicode 字母转换为小写格式

	函数ToLowerSpecial 会根据传入的unicode.SpecialCase类型指定的优先规则把传入的字符串参数中所有的Unicode字母转换为小写格式

	函数ToUpper 和 函数ToLower 功能相似不过ToUpper函数是将Unicode字母转换为大写格式

	函数ToUpperSpecial 和 函数ToLowerSpecial 功能相似不过ToUpperSpecial函数是将Unicode字母转换为大写格式
    
6. 处理字符串合并和生成的函数

	函数Join 把传入的字符串数组参数用传入的分割字符串合并成新的字符串，分隔字符串放在两个数组元素之间

	函数NewReader 通过传入的字符串参数创建一个新的Reader，Reader中提供了很多高效的读取字符串的方法，这里的Reader是只读的。

	函数Repeat 把传入的字符串参数复制 传入的int参数个数然后合并返回新的字符串

7. 处理字符串过滤的函数

	函数Trim 从传入的第一个字符串参数的两端过滤所有包含在第二个字符串参数中的Unicode 码点值

	函数TrimFunc 从传入的第一个字符串参数的两端过滤所有满足在第二个函数参数中的Unicode 码点值

	函数TrimLeft 和 函数TrimLeftFunc 是从第一个字符串参数的左端开始过滤

	函数TrimRight 和 函数TrimRightFunc 是从第一个字符串参数的右端开始过滤

	函数TrimSpace 从传入的字符串参数的两端过滤所有在Unicode中定义的空白字符的Unicode 码点值
     
 8. 处理字符串替换的函数  
     
	函数Map 把传入的字符串参数中的每一个字符根据传入的mapping函数的返回值进行修改，如果返回值为负则不会替换原来的字符

	函数Replace 把第一个字符串参数中的old代表的字符串用new代表的字符串替换，传入的int参数n表示重复替换的次数，如果n小于0，则不会限制替换的次数

	函数NewReplacer 通过多对新旧字符串创建一个替换器，在进行替换的时候会按顺序进行，不会替换重叠的部分