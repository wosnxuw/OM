这本笔记的内容主要来自于BV1Mz4y1S73w

### 1、通用语法

一个Model基本的构型如下：

```modelica
model A
equation

end A;
```

注释：
```
/*88888*/
//555555
```
引号注释：
```
Real foo "this is a real variable";
```
这个可以放在变量声明也可以放在等式那

变量声明：

```
Real foo;
Integer bar;
Boolean v4;
```
变量前缀：
```
input Real foo;
output Integer bar3;
parameter Real b = 1.0; //参数，表示这个量定死了
```
可见性前缀：
默认是public

```
public 
	Real a;
protected 
	Real b;
```
protected是 一种分区标识符。
数组：

```
Real x[3] = {1，2，3};
Real x[3,3] = [1,2,3; 2,3,4; 3,4,5];
//一维之间用;隔开
```

逻辑语句：

这个应该是得在equation里写
```
if <condition> then
...
elseif<condition> then
...
else
...
end if;
```
逻辑运算符：
```
< > <= >= and or not <> （不等于）
```
for循环：
```
for i in 1:size(a, 1) loop
	a[i]=i;
end for;

// 数组的初索引从1开始，和MatLab一样
// i in 1:10，是从1到10，而不是python那样，不包含右区间
// 对于M而言，数组的最后索引就是长度
// python是最后索引是长度减一，而range不包含右
// 所以它们恰好都是size
// 这个i就像python那样，不用在for之前就有定义
```

### 2、函数语法

Function基本的样子是这样。

```modelica
function fun
	input Real in1=10;
	input Real in2;
	output Real out1;
	output Real out2;
protected
//局部变量声明
    Real a = in1-in2;
    
// (out1,out2)=fun(in1,in2);
algorithm
	out1:=a;
	out2:=in1*in2;
end fun;
```

函数的参数在algorithm前面声明，input为“形参”,output为返回值，可以有多个。

" Algorithms can not contain equations ('='), use assignments (':=') instead"

:=应该就是函数内部的赋值符号

在函数体内，是从上到下的执行代码。而在equation中，等式的顺序是没有关系的。

传入的是形参。

input可以设置默认值。如果有默认值，可以调用时不传递那个参数。

如果你只想要返回值的一个，你就不用写括号了 out=fun(in1,in2)


### 3、等式语法

核心：建立平衡模型

然后使得未知变量的数量，与等式的数量一致


model和block应该是最常见的两个结构，名称一般建议是大驼峰。函数名建议是小写。

<表达式1>=<表达式2> 两侧可以换位置

在等式语句块中使用if语句  --> if每个框体中等式的数量应该是相同的。就是说if后一定有else。

```modelica
if a>b then
x=sin(time);
else
x=cos(time);
end if;
```

初始化等式语句块：

主要是设置初始值

der(y)=0;


### Modelica多文件
假设有一个model文件和一个function文件，调用函数

在OMEdit中，同时打开两个文件，不需要import语句，就可以使用函数的内容

但是用omc直接编译model，两个文件放在同一个文件夹下，不行（不写import的话）

如果要写import，应该是写在`model x`与`end x;`之间，不过这也不行（根据OMNoteBook第10章，导入包教程）

正确的做法：
```shell
omc Model.mo Modelica #will first load the Modelica library and then produce flattened Model on standard output

omc Model1.mo Model2.mo #will load both Model1.mo and Model2.mo, and produce flattened Model1 on standard output
```

另外，modelica不限制一个.mo文件只包含一个model或者function

比如上面那俩model，你可以写一个文件里（modelica似乎没有package）

但需要在调用函数前实现函数，函数要写model上面


### MSL Modelica Standard Library 标准库

你可以在OM中搜索使用的model的名字来迅速找到它

Modelica.Blocks:
基本输入输出

Modelica.Blocks.Sources:
输入源

Modelica.StateGraph
状态机

Modelica.Math
数学函数

Modelica.Math.Polynomials
多项式，包含求微积分的函数

Modelica.Constants
常量，直接使用常量即可
circumference = 2 * Modelica.Constants.pi * radius;
