#### 概念：
Template：带孔的字符串。孔中放表达式。
Template Language：将结构化的数据转化为文本的语言（一般化）
Text Template Language：同上。明确了目标就是文本。
Template Function：此函数的形参是一些属性或参数，返回值是一个文本结构。

Template Hole：孔是由<%xxx%>包裹的东西。
template constructors：模板构造函数。也就是用<<xxx>>将一些文本包含进来。<<xxx<%jjj%>kkk>>。这里面的孔，是实际数据将被插入的地方。

这个和什么有些类似呢？就是python中f-字符串
```python
def template_function(p: int) -> str:
    p=p+1
    return f"get : {p}"
```

#### 如何运行.tpl文件？

Susan Template文件是无法直接运行的，必须转化为MetaModelica

编写一个正确的.tpl文件
编译用：
`omc xxx.tpl`
输出为：
`xxx.mo`

#### 编写要点

##### 基本结构
生成的mo是一个package，所以tpl文件里最外侧要求是一个package
你在这个package里可以写很多template xxx，每一个template xxx
都会转化为mo文件中的一个function（有时不只是一个）

我的建议是，tpl虽然不要求最外层包名和文件名相同，但是找包的时候会将包名认为是文件名。所以还是像java一样，类名和文件名写一样的

在hello.tpl，查看基本结构

##### “孔”处可以放什么
<%%>里应该是可以求值的，比如<%(x+1)%>，是ok的
也可以调用函数

##### if-else
和Modelica不同，else语句结束后，没有end if
if else那行也没有分号；

在if的`<Cond>`条件中，使用比较运算符，如==、>= 、< 不被允许

通过后面的调用MetaModelica函数，可以实现比较运算

##### 生成文件
生成的mo文件的function中
会额外的附加
input Tpl.Text in_txt;
output Tpl.Text out_txt;

##### 调用函数
在一个tpl文件的包里写两个函数，相互调用

成功的调用位置有：
<%%>孔处
let的等于号后面

不允许的调用位置：
if 的条件处！！！
我看文档说，即使过编译。if处，也不能处理一个template函数的返回值
template函数必然返回Text类型，这是没办法修改的
而if的条件处（根据文档）是没有Text的

##### 定义变量
在template ::= 的体内定义
定义时不用显示声明类型
let local_var=10 
之后此变量可用于<%%>之中

您必须在前面定义好所有的let变量，不允许执行过程中定义
let变量的值可以继承if-else的结果

##### buffer
buffer（全小写）是一个关键字
但是在vscode里buffer不会高亮

##### 引用 & 关键字
这个东西用在template function的形参中的话
参数类型一定是Text
Text也是类似于String，Real类型的东西，但在vscode没高亮
例子：
```Susan
template sg(Text &arg1) ::=
body
end sg;
```
由于它是一个Text，你要用+=来追加字符
比如：
let &what = buffer ""
let &what += "this"
let &what += <<fuck>>

我看一般情况下，都是定义缓冲区buffer，然后追加
包括用函数追加。&可以直接取址。

##### match的使用
这个内容实际上是MetaModelica的内容
请注意match并不是switch
这是函数式编程中常用的一种叫做“模式匹配”的方法

##### 管道
这个内容也是函数式编程的思想
类比：管道是python的列表推导式，目的是产生新列表，而不是取出做普通的迭代
这个列表，如果你不接住
新列表的每个元素会首尾相接，产生新的一个字符串
接住了，就是一个新列表

列表 |> 代表元素 => 操作表达式

可以参考list_use.tpl内容

##### 调用MetaModelica函数
每个tpl文件，可以导入多个metamodelica interface package
接口包是最外层包名，内部必须包含很多原始包，包内放置函数
接口包是.mo文件
此包有以下特点：
函数只能是签名，而没有体

访问的时候，不需要限定包名，但是建议写
（所以在hello.tpl中调用，那个fu才可有可无）

寻找：在当前路径下寻找文件名.mo

那怎么用大于呢？
要写一个MetaModelica，写一个interface包，包含一个子包，子包包含函数
模板包里引入这个函数，然后调用这个函数即可
而在文档里，写的是在interface包里声明函数，而不是实现函数
（目前不知道在哪里实现）

##### tpl调另一个tpl
和调modelica的区别在于，import是否有interface语句
