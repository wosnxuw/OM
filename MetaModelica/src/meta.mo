// Literals 译为：字面量


// 浮点数可以用科学计数法
// 1.2E-20
// 1.5e-9
// 13.


// 字符串有时支持相加
// "a"+"b"


// 通过fill函数来创建数组，只能创建全相同元素的数组
// fill(3.14, 5) 5个元素，都是3.14
// 数组可以{1,2,3}这样声明，也可以list(1,2,3)
// cons是一个拼接运算函数cons(list_1, list_2) 等价于 list_1::list_2
// 内置了很多listXXXX函数，获取大小，特定值等


//list和Array是两码事
//list是常用的，Array是C的数组，但是构造相当笨拙（文档直译）
//vec := listArray({2,4,6,8})
//vec[1]
//声明一个数组类型 type MyVector = Boolean[:]


//record类型的，它的名字自动被解析为一个构造函数（在union中）
//声明用构造函数 Complex(1.3, 4.56)


//Meta那个手册已经是2011年的了
//现在实数之间的运算符和整数一样，不用加.

model meta

function string1
  input Integer x;
  output Real y;
  output String str;
algorithm
  y := x;
  //似乎Meta已经支持了自动类型转换，实数整数直接直接赋值，而不需要用intReal(y)了
  str := stringAppend("aaa","bbb");
end string1;

function ios
  input Stream istream;
  algorithm
    print("this"); //print是内置函数?
end ios;

//函数可以作为参数
function add1 "Add 1 to integer input argument"
  input Integer x;
  output Integer y;
algorithm
  y := x+1;
end add1;

function listMap /*
** Takes a list and a function over the elements of the lists, which is applied
** for each element, producing a new list.
** For example listMap({1,2,3}, intString) => { "1", "2", "3"}
*/
  input list<Type_a> in_aList;
  input FuncType inFunc;
  output list<Type_b> out_bList;
public
  replaceable type Type_a subtypeof Any;
  replaceable type Type_b subtypeof Any;
  function FuncType
  replaceable type Type_b subtypeof Any;
  input Type_a in_a;
  output Type_b out_b;
  end FuncType;
algorithm
  out_bList:=
  matchcontinue (in_aList,inFunc)
  local
    Type_b first_1;
    list<Type_b> rest_1;
    Type_a first;
    list<Type_a> rest;
    FuncType fn;
  case ({},_) then {};
  case (first :: rest,fn)
  equation
    first_1 = fn(first);
    rest_1 = listMap(rest, fn); 
  then first_1 :: rest_1;
  end matchcontinue;
end listMap;


// 在这个函数里，match-case里放置了equation，所有这个等式能够失败，那么函数失败。
function sum
  input Integer inInteger;
  input Integer in_n;
  output Integer outRes;
algorithm
  outRes :=
  matchcontinue (inInteger,in_n)
  local Integer i,n,i1,res1;
  case (i,n)
  equation
  true = (i>n); then true;
  case (i,n)
  equation
  false = (i>n);
  i1 = i+1; 
  res1 = sum(i1,n); then i+res1;
  end matchcontinue;
end sum;



Real a = 3.14;
Real b;
equation
a*b = 32.9*3.4;


end meta;

// 逻辑判断是and not or <>（NEQ）

//个人理解：被括号括起来的应该视作 Tuples类型的字面量

//函数：Meta的函数是数学的，无副作用的。外部功能（不知道在哪），可以获取输入输出

//（限制）有match-case的函数，只能通过绑定匹配值，不支持直接使用形式参数

//MetaModelica包中含有很多内置函数

//函数的调用可能失败，而不是总返回一个值。貌似就是说matchcontinue的话，
//它如果一个case寄了，会重新回到没进入的状态，不会产生副作用，继续匹配下一个

/*
导致Modelica函数失败的最常见原因是   缺少匹配   具有成功的局部方程。

另一个原因是使用内置Modelica命令fail，这会导致带有matchcontinue关键字的匹配表达式中的一个用例立即失败，然后尝试下一个匹配的用例(如果有的话)。
另一方面，使用match关键字的匹配表达式中的失败将导致整个匹配表达式立即失败。

failure否定一个函数的成功性，反转
一个遇到fail的函数外面包裹failure还是成功
相当于not对bool变量的否定

仅在完全确定的函数中使用副作用，对于这些函数，最多只匹配一种情况，并且可能永远不会发生回溯。

*/