#### 概念：
Template：带孔的字符串。孔中放表达式。

Template Language：将结构化的数据转化为文本的语言（一般化）

Text Template Language：同上。明确了目标就是文本。

Template Function：此函数的形参是一些属性或参数，返回值是一个文本结构。

Template Hole：孔是由<%xxx%>包裹的东西。

template constructors：模板构造函数。也就是用<<xxx>>将一些文本包含进来。<<xxx<%jjj%>kkk>>。

这里面的孔，是实际数据将被插入的地方。

##### 两种孔
<<>>
''
在OM里，基本都是第一种<<>>的


这个和什么有些类似呢？就是python中f-字符串
```python
def template_function(p: int) -> str:
    p=p+1
    return f"get : {p}"
```

<<>>中，不允许什么都不写，即空串

#### 如何运行.tpl文件？

Susan Template文件是无法直接运行的，必须转化为MetaModelica

编写一个正确的.tpl文件

编译用：

`omc xxx.tpl

输出为：

`xxx.mo`

#### 编写要点

##### 基本结构
生成的mo是一个package，所以tpl文件里最外侧要求是一个package

你在这个package里可以写很多template xxx()函数，每一个template xxx()函数

都会转化为mo文件中的一个function（有时不只是一个）

我的建议是，tpl虽然不要求最外层包名和文件名相同，但是找包的时候会将包名认为是文件名。所以还是像java一样，类名和文件名写一样的

在hello.tpl，查看基本结构

##### “孔”处可以放什么（或者说，可以怎样转化）
变量：

<%%>里放置MetaModelica中的变量，可以直接将变量的值转化为字符串，如<%x%>

只有Integer,Real,Boolean,String这四个类的变量，才能自动转化为字符串

当一个变量时Option类，它输出其SOME的值

函数：

调用函数，因为我们的模板函数的返回值总是Text

数组或列表：

每个元素转换出字符串并首尾拼接

```suasn
template globalDataVarNamesArray(String name, list<SimVar> items) ::= 
if items then 
<< 
char* <%name%>[<%listLength(items)%>] = {<% (items |> SIMVAR(__) => 
 '"<%crefSubscript(origName)%>"' ) ;separator=", "%>}; 
>> 
else 
<< 
char* <%name%>[1] = {""}; 
>>; 
end globalDataVarNamesArray; 
```
这行代码声明了一个包含 n 个 `char*`的数组

C中正确写法应该是`char* a[3] = {"xxx","yyy","zzz"};`

然而，写成`char* a[3]={"xxx"};`也不会错，只不过另外两个指针NULL

根据语义来推断，因为这里都设置separetor了，那么肯定是要用到逗号的

分析：外侧的<%%>，产生了"xxx","yyy","zzz"，它的本质是<%数组 ;separator=","%>

而这个数组是一个被括号包裹的推导式，推导式先从列表里取出匹配`SIMVAR(__)`的变量，再利用自动展开得到子变量origName。最后的运算表达式被一个单引号括起，表示新的列表中的元素是一个Text。

##### if-else
和Modelica不同，else语句结束后，没有end if

if else那行也没有分号；

在if的`<Cond>`条件中，使用比较运算符，如==、>= 、< 不被允许

通过调用MetaModelica函数，可以实现比较运算

值得注意的是if语句有返回值，比如：

```susan
  if intEq(rel.index,-1) then
    let &preExp += '<%res%> = <%rel_f%>(<%e1%>,<%e2%>);<%\n%>'
    res
  else
  ...
```

在这个例子中，可以看到使用了intEq进行==的判断，res是if前面的一个变量，在这里做返回值

既然有返回值，那么一个变量=if xxx 是可以的



##### 生成文件

生成的mo文件的function中

会额外的附加

input Tpl.Text in_txt;

output Tpl.Text out_txt;

这进一步说明了模板函数的作用

##### 调用函数
在一个tpl文件的包里写两个函数，相互调用

成功的调用位置有：

<%%>孔处

let的等于号后面

不允许的调用位置：

if 的条件处！

文档说，即使过编译。if处，也不能处理一个template函数的返回值

template函数必然返回Text类型，这是没办法修改的

而if的条件处（根据文档）是没有Text的

##### 定义变量

不管是什么变量，最好不要以`_`开头，不然的话，在模式匹配里，`_`会被认为是通配符（它没有再继续看，就直接认定通配符了），导致无法编译

定义变量时，要根据右侧的结果决定变量的类型

如果右侧是一个模板函数，或者是字面量，那么let后的变量是一个Text类型

如果右侧是一个MetaModelica函数，那么let的变量可以就具类型

举例：
let x = 1

<<<%x+1%>>> 将会输出11，而不是2，+号用来拼接字符串，而不能自动重载，根据x是实数还是整数来运算

let items={"xxx","yyy","zzz"}

`char* a[3] = {<% (items |> x => '"<%x%>"' ) ;separator=", "%>}; `

将会输出`char* a[3] = {"xxxyyyzzz"};`而不是`char* a[3] = {"xxx","yyy","zzz"};`

因为let后面的东西是一个Text，而{}的数组被自动先拼接为了Text，因此items实际上只包含一个元素，你取出来，也只有一个

只有`<<<%{"a","b","c"} |> x => 'U<%x%>!'%>>>`才能够输出Ua!Ub!Uc!

```susan
template crefSubIsScalarHuman(DAE.ComponentRef cref) ::= 
 let resBool = crefSubIsScalar(cref) 
 if resBool then
 "this cref has scalar subscript" 
 else 
 "this cref does not have scalar subscript" 
end crefSubIsScalarHuman; 
```
这里，resBool是一个bool类型的。同时能够用作if的条件，否则，如果所有的变量都是Text类型，那么if后面就不能放置任何let的变量。

文档说Susan是strongly typed，这和声明时是否指定类型无关

比如python时动态类型+强类型，强类型只是要求类型转化严格执行

语言是否解释执行和动态类型也没关系

let local_var=10 

之后此变量可用于<%%>之中

您必须在前面定义好所有的let变量，不允许执行过程中定义（这个不是那么绝对）//待补充

let变量的值可以继承if-else、match case等语句的结果

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

感觉let就是一个定死的Text，let&可变。

##### 管道
这个内容也是函数式编程的思想

类比：管道是python的列表推导式，目的是产生新列表，而不是取出做普通的迭代

这个列表，如果你不接住(用一个变量接受返回值)

新列表的每个元素会首尾相接，产生新的一个字符串

接住了，就是一个新列表

列表 |> 代表元素 => 模板表达式( template-expression)

可以参考list_use.tpl内容

使用()将整个表达式括起来，可以提高可读性，但是不强制

我检查了一下CodegenC.tpl的内容，大部分没有使用括号

一般就是let xxx = 管道 ; separator="," 

括起来就是<%(管道) ;separetor=","%>

##### 使用管道来模式匹配
在Susan中，一个列表中元素的类型可以不一致

参见list_use.tpl

这样，使用模式匹配，可以单独提取符合类型的元素

element-list |> elem-pattrn => template-expression

比如：

```Susan
template intConstantsList(list<Exp> expLst) ::= 
 (expLst |> ICONST(__) => value ;separator=", ")
end intConstantsList;
```
相当于把expLst里，是INCONST这种类型的拿出来了，至于value是从哪来的，好像是说，如果__自动展开作用域的话，就可以随意的使用那里面的变量


```Susan
<%variables |> var as VARIABLE(__) => '<%varType(var)%> <%cref(var.name)%>;' ;separator="\n"%> 
```
使用一个别名，使得类型匹配的时候，后续也可以使用别名

##### hasindex fromindex
elements |> elem-pattrn [hasindex myindex [fromindex startindex ] ] => templateexpression 
计数开始是0

hasindex 后面是一个临时的变量比如myindex1

这样，后续您能够使用这个元素的位置

fromindex后面是一个整数，表示起始位置

比如：

multi-val-expr |> el hasindex myindex1 fromindex 1 => templ(el, myindex1)>

//?待补充：似乎没有一个方法能够单独取出数组中的一个元素？

##### 使用大括号{}来构造列表
这样支持您现场构造列表，比如

{"a","b","c"} |> x => 'U<%x%>!'

这个表达式将会产生列表：

{"Ua!", "Ub!", "Uc!"} 

最终会转化成字符串形式：（如果没有一个变量来接受这个列表）

"Ua!Ub!Uc!"

分析：这里，模板表达式是一个被''双单引号包裹的式子，一般情况下都是这样，然后，每一个x都会单独进入表达式，进行n次，构造出新列表

##### 不限制推导式的源
一般来讲，推导式的源都需要是一个列表（比如python，[x+1 for x in 1]不合理）

在Susan中，不会进行类型检查，这意味着推导式的源可以是一个非“集合”对象

例子：
```Susan
list<SimEqSystem> allEquations
<%
match allEquations
case {} then ""
//case {eqs} then (eqs |> eq => equation_(eq); separator="\n")
case {eqs} then equation_(eqs)
else (allEquations |> eqs => (eqs |> eq => equation_(eq); separator="\n"); separator="\n")
%>
//equation_(SimEqSystem x)
```

在这里，被注释的语句和其下面的语句是等价的。由于allEquations是一个列表，{eqs}表示一个只有一个元素的列表，所以那个推导式试图从eqs这个变量里推东西，什么都没推到，还是自己。

else这里，当allEquations是一个数组，eqs是每一个变量，然后括号里的推导式还是冗余的。

##### 推导式的规范性要求
```susan
  let fncalls = (allEquationsPlusWhen |> eq hasindex i0 =>
                    let &eqfuncs += equation_impl(-1, -1, eq, contextSimulationDiscrete, modelNamePrefix, false)
                    equation_call(eq, modelNamePrefix)
                    ;separator="\n")
```

这里请注意换行符，因为susan语句结束时，不需要`；`来结束

这里，eqfuncs是一个buffer，这里为这个buffer添加内容，但是这些内容并不会对fncalls产生影响，只有后面的equation_call会像fncalls中添加内容，并且是添加多个内容

也就是说`let &eqfuncs += equation_impl(-1, -1, eq, contextSimulationDiscrete, modelNamePrefix, false)`这句话在这个推导式的第三项，没有为推导式添加内容，仅仅是进行一个计算

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

调modelica有interface

调tpl没有
