// 第二章


// Hello Wrold
class HelloWorld
    Real x(start=1,fixed=true);
    parameter Real a=1;
equation
    der(x)=-a*x;
end HelloWorld;

// What is a instance?
model dog
    constant Real legs=4;
    parameter String name="Dummy";
    // 这里，没有等式计算。字符串用等号赋值给变量。
end dog;

// Create Instance
model DogInst
    Dog d;
end DogInst;
// rename
model DogTim
    Dog d(name="Tim");
end DogTim;

//create function
function average
    input Real a;
    input Real b;
    output Real result;
algorithm
    result := (a+b)/2;
end average;

//call function

//调用的时候类似C（如果在equation中调用）
//目前不清楚如何将这个类导入那个类

// ！！！关于如何引入函数
/*
你只需要把model和function的源文件放一个文件夹下就行
不需要显示的引入
如果要使用包，似乎不需要在model里import进来
只需要modelica需要加载这个包（打开这个文件），不能不打开？

然后同一个包里的同等地位的函数之间互相可见
直接就能调用。甚至不要求前后定义顺序关系。

允许递归函数

函数是无法模拟的
所以不要omc xxx.mo(函数)

*/

class AverageTest
    Resl res;
equation
    res=average(4,6);
end AverageTest;

// class inheritance 类继承
//class model都是一个完整的类
record Bicycle
  Boolean has_wheels = true;
  Integer nrOfWheels = 2;
end Bicycle;
// extends关键字 和Java类似，然后Java是写在同一行，这个是写在里面开头处
class ChildrensBike
    extands Bicycle;
    Boolean forKids=true;
end ChildrensBike;


// equation语句有三种
// 一种是normal的，出现在equation中；一种是declaration的，是直接赋值；一种是modification的

model Equations
  Real x(start = 2);         // Modification equation
  constant Integer one = 1;  // Declaration equation
equation
  x = 3*one;                 // Normal equation
end Equations;

//下面是flat后的结果
"
class Equations
  Real x(start = 2.0);
  constant Integer one = 1;
equation
  x = 3.0;
end Equations;
"
// 个人理解modification就是用一个括号，显示的修改变量初值
// 对于一些自定义类，直接声明就只是声明出定义时的初值
model Birthyear
  parameter Integer thisYear = 2002;   // Declaration equation
  parameter Integer age =10;
  Integer birthYear;
equation
  birthYear = thisYear - age;          // Normal equation
end Birthyear;

// 上面的类用于计算年龄，但是显然数值都定死了
// 为这个类创造实例，并且修改生日
model BobBirthyear
    Birthyear bobBirthyear(age=30)
end BobBirthyear;

// Partial Class “部分类”，和其他语言的抽象类是一码事
// 例子里写了一个类，但是方程数不够，所以无法解。用一个子类继承这个抽象类，加一个方程，就能解了。
// 当方程数少于位置变量数时，可以考虑这个关键字


// 数组
class ArrayDim
    Real[3,3] identitymatrix = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
    Real    identitymatrix_2[3,3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
      String[3, 4] strings = {{"blue", "Martin", "yellow", "cake"}, {"Anna", "sun", "star", "heaven"},
                           {"candy", "Sofia", "sweet", "Balthasar"}};
end ArrayDim;

// * 重载
/*乘法运算符*在向量之间使用时是标量积，在矩阵之间使用时是矩阵乘法，在数组和标量之间使用时是元素乘法*/
// 每个元素乘2
function ElementWiseMultiplication
   input  Real[3] positionvector;
   output Real[3] result;
 algorithm
   result := positionvector*2;
end ElementWiseMultiplication;  

// 矩阵
// 这个应该来源于MatLab
// ; 和 , 分别表示行和列

// 算法语句（不只是仅function类独有的）

model AlgorithmSection
  Real x, z, u;
  parameter Real w = 3, y = 2;
  Real x1, x2, x3;
equation
  x = y*2;
  z = w;
algorithm
  x1 := z  + x;
  x2 := y  - 5;
  x3 := x2 + y;
equation
  u = x1 + x2;
end AlgorithmSection;

//通过上面的例子，algorithm语句可以嵌入到equation之中。并且equation可以有两个。
// := for while if 只能出现在algorithm语句中

// 如果我没猜错。你的所有变量只能在顶部定义，否则将会报错。
// 它不像C等一些语言，通过{}就可以划分作用域，变量对本类所有语句可见

class Summation
    Real sum(start=0);
    Integer n(start=size(a,1));
    Real a[5]={1,3,6,9,13};
algorithm
    while n>0 loop
        if a[n]>0 then
            sum:=sum+a[n];
        elseif a[n] > -1 then //一体式
            sum := sum - a[n] - 1;
        else
            sum:=sum-a[n];
        end if;
    end while;
end Summation;

// 编程思维：写一个类，根据off确定switch的值
model Lights
  Integer switch;
  Boolean off = true;
equation
  if off then
    switch = 0;
  else
    switch = 1;
  end if;
end Lights;
// 我们应该是调用的时候给出off的值（用Modification声明）


//包：通常可以包含类或者常量的定义
//包是一个受限制的增强类，主要用于管理命名空间和组织Modelica代码。
//包有只有类声明的限制，包括所有受限制的类和常量。不允许声明变量。
//包里可以放class，function，constant xxx
package MyPackage
    function division
        input Real a;
        input Real b;
        output Real res;
    algorithm
        result :=a+b;
    end division;

    constant Integer k=9;
end MyPackage;

//调用
model ModelWithx
    Real x=MyPackage.division(10,5);
end ModelWithx;