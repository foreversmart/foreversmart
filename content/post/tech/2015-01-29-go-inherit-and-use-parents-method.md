+++
date = "2015-01-29T10:54:24+02:00"
draft = false
title = "Go inherit"
slug = "go_inherit"
tags = ["go"]
image = "http://obovlo80m.bkt.clouddn.com/struct.jpg"
comments = true	# set false to hide Disqus
share = true	# set false to hide share buttons
menu= ""		# set "main" to add this content to the main menu
author = "foreversmart"
featured = false
description = "Golang 继承"
+++

Golang 从设计上不是一个面向对象的语言，也没有一般意义上的继承。
但我们可以通过一些技巧实现继承的功能。

#### 定义

* 通过 struct 组合的形式实现继承的功能：
    
    通过内嵌匿名基类的方式，子的struct可以获得所有的属性包括public和private的
    
    我们可以在子 struct 中匿名嵌入基类的 struct 实例
    ```go
   type Child {  
       Parent
   }
    ```
    Child 继承所有在 Parent 上的方法。 
    </br>*Child 继承所有在 Parent 和 *Parent 上的方法。 
    
    我们可以在子 struct 中匿名嵌入基类的 struct 指针
    ```go
    type Child {  
        *Parent
    }
    ```
    Child 和 *Child 继承所有在 Parent 和 *Parent 上的方法。 

    通过内嵌的方式我们可以灵活的为 Child 新增属性和方法，也能可以重写 Parent 上的方法.
    这种方式实现的继承比较灵活，再用上 interface 几乎可以实现面向对象中的基础需求。
  
* 定义一个新的类型：
    
    用普通类型声明一个新的类型
    ```go 
    type Child Parent  
    ```
    Child 继承所有在 Parent 上的方法。 
    </br>*Child 继承所有在 Parent 和 *Parent 上的方法。 
    
    用类型的指针声明一个新的类型
    ```go 
    type Child *Parent  
    ```
    Child 和 *Child 继承所有在 Parent 和 *Parent 上的方法。 
    
    这种方式新的 Child 也继承Parent类型所有的属性, 但缺点是这种方式只能对Parent 类型的行为进行扩展，
    无法新增新的属性。
    
* 多重继承

    child 可以通过组合多个 Parent 来继承不同属性和方法
    在使用多重继承的时候 这多个 Parent 不能有相同的属性或方法 否则编译会报 **ambiguous** 错误。
    这个和c++ 中的菱形继承问题是类似的。
     ```go
    type ParentA struct {}
  
    func (p ParentA) func Hello() {
        fmt.Println("hello world a !")
    }
    
    type ParentB struct {}
    
    func (p ParentB) func Hello() {
        fmt.Println("hello world b !")
    }
    
    // wrong
    type Child struct {
        ParentA
        ParentB
    }
    
    func main(){
        var child Child
        child.Hello() // error ambiguous selector child.Hello 
    }
    ```
    
#### 使用

上面两种方式的使用方式基本相同

* 方法调用

    child.Hello() 如果 Child 定义了 Hello() 方法那么调用Child.Hello() 否则调用Parent.Hello()的方法
    如果 Child 定义了Hello() 可以通过 child.Parent.Hello() 调用父类的方法
    ```go
    type Parent struct {}
    
    func (p Parent) func Hello() {
        fmt.Println("hello world!")
    }
    
    type Child struct {
        Parent
    }
    
    func (p Child) func Hello() {
        fmt.Println("hello child")
    }
    
    func main(){
        var child Child
      
        // 默认调用 Child.Hello() 如果Child 没有Hello 则调用 Parent.Hello()
        child.Hello() 
        child.Parent.Hello() // Parend.Hello()
    }
    ```
    
* 
    

当我们使用一个第三方库是使用了其中的一个公开访问的类型；有一种场景是我们想直接利用第三方的类型，增加我们自己的行为。
这样可以省略很多重复的代码，简化代码结构，减少很多中间的重复数据结构。
    
但是对一个非local的type，想进行修改和增加行为在不影响第三方库正常使用的情况下是非常方便的.
但会存在大量的代码隐患，也会出现在调试的过程中type的行为分布在多个不同的package导致代码混乱，
不易管理和排查错误。所以Go语言中是不能对非local的type，新增方法的。

我们可以使用下面两种方式来实现为远程的类增加行为和方法

1. 通过组合的设计模式的概念对外部type用本地的type进行包装  
	```go
		type mytype{  
			out outtype
		}
	```
	
2. 使用类型代用的方式  
	普通的类型  
	```go 
	    type mytype outtype  
	    outtype(my).method()  
	```

	指针类型  
	```go
	    type mytype *outtype  
	    (*outtype)(my).method()   
	    *outtype(my).method()      //这种使用方式是错误的  
    ```
