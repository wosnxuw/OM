model match_use
uniontype Exp 
 record INTconst Integer int; end INTconst; 
 record ADDop Exp exp1; Exp exp2; end ADDop;
end Exp; 

// INTconst这种名字 叫做“构造函数”constructors。因为它们用于构造tagged标记实例
// 你看它的AST里面，每个节点都是一种ADDop或者INTconst

uniontype Number
record INT Integer int; end INT;
record RATIONAL Integer dividend, divisor; end RATIONAL;
record REAL Real real; end REAL;
record COMPLEX Real re,im; end COMPLEX;
end Number;

// construct a Number instance REAL(3.14) to hold a real number or another instance COMPLEX(2.1,3.5) to hold a complex number.
// 通过REAL()构造出的这种对象，就直接是Number了
// Number是C的“联合”union，是C++的std::variant，需要用match访问

type StringOption = Option<String>;

function stringOrDefault
  input StringOption strOpt;
  input String default;
  output String str;
algorithm
  str := match strOpt
    case SOME(str) then str;
    else default;
  end match;
end stringOrDefault;

// Option这种泛型有两种类型，类型是SOME(变量)或者NONE()
// SOME和NONE类似于前面提到的构造器
// 这个东西本质就是为了区分空和非空，NONE对应null。SOME对应本身的值。
// SOME(str)是一种模式，当 strOpt 是 Option<String> 类型，
// 并且确实包含一个字符串时，它匹配 SOME 构造器。
// str是那个以前的模式变量，后续str将绑定到strOpt中的值
/*
uniontype option
 replaceable type Type_a subtypeof Any;
 record NONE end NONE;
 record SOME Type_a elem; end SOME;
end option;
*/

// 算阶乘
function fac
 input Integer inValue;
 output Integer outValue;
algorithm 
outValue:= matchcontinue inValue
 local Integer n;
 case 0 then 1;
 case n then if n>0 then n*fac(n-1) else fail();
 end matchcontinue;
end fac; 
// 0 是最好理解的，是第一种情况：Literal Pattern 字面量模式
// 字面量模式应该是case那玩意能求出一个具体数值
// n 这是一个在match 和第一个case之间定义的变量，没初值
// 这是第二种情况：Variable Pattern 变量模式
// 只要inValue和n的变量类型相同，就可以把inValue的值赋予（或者叫“绑定”）给n
// 所以随便来一个整数，都能到n这里

function match_exp
 input Exp inExp;
 output Integer out;
algorithm
out :=
match inExp
 case INTconst(int=v1) then 1;
 case ADDop(exp1=e1,exp2=e2) then 2;
end match;
end match_exp;


// 每个时刻，只能有一种Record在联合体内部
// 这是第三种情况：Structured Pattern Matching 结构化模式匹配
/*
case INTconst(int=v1) 是匹配 Exp 类型中的 INTconst 构造器。
如果 inExp 是 INTconst 类型，
这个模式匹配成功，并将 INTconst 中的 int 字段的值绑定到变量 v1。
*/

// 如果是INTconst(__)，则是把int字段的值，绑定到local变量int。

  function func
    input Integer x;
    input Integer y;
    output Integer z;
  algorithm
    z :=
    matchcontinue (x,y)
      local
        Integer i;
        Integer r1,r2;
      case (i as 11,r1) then i;
      case (_,23) then 1;
      case (_,r2 as _) then r2;
    end matchcontinue;
  end func;

// as 在这里，似乎是你先local一个变量
// 然后 <Local变量> as <模式> ，你以后可以使用这个local变量，它被绑定为as后面的值
// 主要是为了后续继续使用这个变量


// 问题：fail() 函数使用

end match_use;