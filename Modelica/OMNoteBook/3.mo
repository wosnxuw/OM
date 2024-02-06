//第三章

//短类定义
// 定义类有一个简短的语法，通常用于为现有类引入更多信息丰富的类型名称。
class Voltage = Real(Unit = "V");
//与用type关键字作用相同
type Voltage = Real;
//个人理解：这个type好比C中的typedef，只是为Real类引入了一个新的名字
//但是位置是反的 typedef int my_int    type my_Real = Real
//type关键字可以把一个数组定义为一个“类”
type Matrix10 = Real [10,10];
//在大多数情况下，短类定义只是定义类的较短语法，这些类也可以使用标准继承语法定义:
type Voltage
  extends Real(unit = "V", min = -220.0, max = 220.0);
end Voltage;


//内部类
model C1
  model Lpin              // Local class
    Real p;
  end Lpin;

  type Voltage = Real(unit="kV");

  Voltage v1 = 5, v2 = 1;
  Lpin pn(p = 2);
end C1;

//这些类的类名都是小写的

//Class是没有任何限制的类，connector、model、function、record等等是替代class的关键字，而这些也是类，但是是受限的（或增强)
//model和class基本相同。model不能用于connection中
//record是一个记录的类。建议定义变量，不允许存在equation语句。不能用于connection中
//type常用于引入新的类名称。一般情况下，type扩展Real，Integer，数组，record
//connector用于object之间的通信。不允许有方程。connector类的对象构成接口。
//Block的所有变量都有input和output修饰。表示这个类的变量流动。
//function不允许equation，最多一个alogrithm。不允许包含modelica内置操作符der等等。不允许用when
//package里面可以定义各种类

// 变量定义
// The variables that belong to a class are also called Fields
// OM认为类对象和int都是变量。int a只不过是Integer类的实例。


//前缀
//constant、parameter、discrete被称为可变性前缀
//constant定死了。discrete是离散的，在事件改变瞬间可变
//parameter是一种特殊类型的常量，它被实现为静态变量，初始化一次，在特定执行期间永远不会改变其值。


