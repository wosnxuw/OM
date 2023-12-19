// 10章 -- 包
// 包约等于命名空间，类似于Java
//package是增强后的用于替代class的关键字

//import关键词
model A
    //假设要使用Add
    import Modelica.Math.ComplexNumbers;
    // ComplexNumbers.Add
    import Modelica.Math.ComplexNumbers.Add;
    // Add
    import Modelica.Math.ComplexNumbers.*;
    import Co = Modelica.Math.ComplexNumbers; //Rename improt. Python:import . as .
    // Co.Add
end A;

//如同python，你可以自由的选择导入整个包还是导入一个函数

//在这里，我们可以看到，model中也可以import，而不仅仅是package中

encapsulated package MyPack
/**/
end MyPack;
//encapsulated 封装。大概就是说解决变量名冲突问题的。

//这个包，声明了Compelx记录，和一系列操纵它的方法
//有点类似于一个真正的Java类。因为我们函数就是类，所以：类又封装为“大类”，即“包”。
encapsulated package ComplexNumbers

  record Complex
    Real re;
    Real im;
  end Complex;

  function Add
    input  Complex x;
    input  Complex y;
    output Complex z;
  algorithm
    z.re := x.re + y.re;
    z.im := x.im + y.im;
  end Add;

  function Multiply
    input  Complex x;
    input  Complex y;
    output Complex z;
  algorithm
    z.re := x.re*y.re - x.im*y.im;
    z.im := x.re*y.im + x.im*y.re;
  end Multiply;

  function MakeComplex
    input  Real x;
    input  Real y;
    output Complex z;
  algorithm
    z.re := x;
    z.im := y;
  end MakeComplex;

end ComplexNumbers;

//练习
encapsulated package Geometry
    constant Real PI=3.14;
    type Distance =Real (unit="m") //单位：米
    function Distance
        input x1
        input x2
        input y1
        input y2
        output d
    algorithm
        d := sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
    end Distance;

    function RectangleArea
    input Distance B;
    input Distance H;
    output Distance area;
    algorithm
        area := B*H;
    end RectangleArea;
end Geometry;
