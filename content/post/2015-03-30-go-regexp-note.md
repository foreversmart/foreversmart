+++
date = "2015-03-14T10:54:24+02:00"
draft = false
title = "Go Regexp Note"
slug = "go_regexp_note"
tags = ["go"]
comments = true	# set false to hide Disqus
share = true	# set false to hide share buttons
menu= ""		# set "main" to add this content to the main menu
author = "foreversmart"
featured = false
description = "golang 正则表达式使用笔记"
+++

作者：ForeverSmart   
[原文链接:](http://foreversmart.github.io/go/2015/03/30/go-regexp-note/) http://foreversmart.github.io/go/2015/03/30/go-regexp-note/

----

#### GO语言正则表达式笔记


###### 1.下GO语言中的正则表达式的实现机制
     正则表达式一共有3种实现机制:
     	DFA 确定性的状态机 最高效，但是构造复杂并且支持的正则词法有限
     	NFA  NFA性能与DFA相近，相对DFA构造简单，除了不支持少数语法外都较好的支持（不支持搜索时反向引用）  
     	回溯  功能最强适配所有的语法，但是会随着规模增大出现指数级复杂度
     	GO语言中使用RE2正则表达式引擎，该引擎中使用DFA和NFA结合，在提高性能同时也能保证对语法的支持
     	
![image](http://pdos.csail.mit.edu/~rsc/regexp-img/grep3p.png)  
回溯模型  复杂度  
![image](http://pdos.csail.mit.edu/~rsc/regexp-img/grep4p.png)  
NFA模型复杂度
     	
  
###### 相关链接：  
[性能和原理](http://swtch.com/~rsc/regexp/regexp1.html)  
[解释器实现](http://swtch.com/~rsc/regexp/regexp2.html)  
[实践中的匹配](http://swtch.com/~rsc/regexp/regexp3.html)  
[Google Code Search工作原理](http://swtch.com/~rsc/regexp/regexp4.html)


######2.正则表达式的使用
     
     1.转义符号介绍
          \c  对特殊字符的原生字符  如\*
          \000  表示八进制码点值  如\101 表示'A'
          \xHH  表示指定的两个数字是十六进制的 如 \x41 表示'A'
          \x{HHHHHH} 表示给定的1-6个数字是十六进制的
          \a  AscII码的响铃字符
          \f  AscII码的换页符
          \n  AscII码的换行符
          \r  AscII码的回车符
          \t  AscII码的制表符
          \v  AscII码的垂直制表符
          \Q. . .\E 里面是原生字面量 
          
     2. 字符类符号
          [] 里面定义的任何字符中的一个
          [^] 任何不在里面的字符
          [:name:] 任何在name字符类中的ASCII字符
                  [[:alnum]]  等价  ［0-9A-Za-z］
                    [[:alpha]]  等价  ［A-Za-z］
                    [[:digit]]   等价  [0-9]
                    [[:word]]  等价 [0-9A-Za-z_]
                    [[:lower]]  等价 [a-z]
          . 任何字符
          \d  任何ASCII码数字  [0-9]
          \D 任何非数字的ASCII码 ［^0-9］
          \s  任何ASCII码的空白字符 [ \t\n\f\r]
          \S  任何ASCII码的非空白字符 [^ \t\n\f\r]
          \w  任何ASCII码的单词字符  [0-9A-Za-z_]
          \W 任何ASCII码的非单词字符 [^0-9A-Za-z_]
          
     3.零宽断言符号 零宽断言就是指匹配的位置应该满足一定的条件
          ^  文本开始处 如果指定多行m标志则表示行首的位置
          $  文本结尾处 如果指定多行m标志则表示行尾的位置
          \A  文本开始处
          \z  文本结尾处
          \b  单词标界 单词标界（即\w在一侧而另一侧为\W\A\z 或者反过来）
          \B  不是一个单词的标界
           
     4.数量匹配符号
          贪婪匹配会在在整个表达式匹配成功的前提下，尽可能多的匹配匹配项，而惰性匹配则是尽可能少的匹配匹配项
          e? or e{0,1} e出现0次或1次  贪婪匹配
          e* or e {0, }  e出现0次或多次  贪婪匹配
          e+ or e {1, }  e出现1次或多次  贪婪匹配
          e{m, }  e至少出现m次  贪婪匹配
          e{, n}   e至多出现n次  贪婪匹配
          e{m,n}  e出现m－n次  贪婪匹配
          e{m} or  e{m}?  e只出现m次
          e??  惰性匹配
          e*?  惰性匹配
          e+?  惰性匹配
          e{m,}?  惰性匹配
          e{,n}?  惰性匹配
          e{m,n}?  惰性匹配
     
     5.标识和分组符号
          (re)  子匹配pattern 会被捕获 $0为整个表达式
          (?P<name>re) 使用name来命名re pattern
          (?:re)  子匹配pattern但不存储
          (?flags) 标记生效
          (?flags:re) 将给定的标记设置给re pattern
          flag:
               m  多行匹配模式
               s   使.可以匹配换行符
               i    匹配大小写不敏感
               U  将贪婪匹配和惰性匹配反转
               flag 前面加 － 表示相反
               
    6.简单正则匹配使用
          函数Match 检查byte切片是否匹配pattern表达式
          函数MatchReader 检查从RuneReader中读到的文本是否匹配pattern表达式
          函数MatchString   检查一个字符串是否匹配pattern表达式
          函数QuoteMeta  用引号安全的返回字符串的正则表达式元字符匹配的字面量
          
     7.使用Regexp接口进行正则处理
          函数Compile  解析一个正则表达式并返回一个正则对象，如果成功的话该正则对象可以多次用来匹配。该正则对象在匹配的过程中尽早的返回一个可能的匹配leftmost。
          函数MustCompile 和函数Compile功能相似，但如果解析正则表达式不成功会panics而不是返回一个错误值， 
          函数CompilePOSIX  解析一个正则表达式并返回一个正则对象，和Compile函数相似但会有更严格的正则表达式语法要求POSIX ERE（egrep）同时在匹配的过程中会在尽可能早地匹配中选择一个尽可能长的匹配leftmost－longest返回。
          函数MustCompilePOSIX 和函数CompilePOSIX功能相似，但如果解析正则表达式不成功会panics而不是返回一个错误值
           
     8.具体正则函数介绍
          Find类函数用于查找匹配并返回相应的结果
          Replace类函数用于将匹配的字符串部分替换成新的部分
          Match类函数用于返回字符串中是否有匹配的结果
          其它函数：
               函数 Expand(dst []byte, template []byte, src []byte, match []int) []byte将src作为模版源，match字匹配的索引, template 定义模版在模板中使用$ + 数字，字母，下划线表示子匹配。将模版追加到dst返回结果
               函数ExpandString 和Expand函数功能相似，但模板和模板源类型为字符串
               函数NumSubexp   返回正则表达式中有多少子表达式
               函数LiteralPrefix  返回匹配的公共前缀，以及是否完整