//这个文件是伪代码，所以不一定可以运行，叫mo主要是为了代码高亮
//主要是收集我在Meta手册之外（主要是OMC）中遇到的代码

String str;
list<String> matches;
_::str::_ := matches;

问题：这里是如何处理matches数组的，现在似乎不清楚它的长度
chatGPT似乎说它是匹配数组的头，这个东西在整个源代码里是出现了一次


protected function callTargetTemplates
  input ...
  output ...
protected
  partical function Func
    input ...
    output ...
  end Func;
  Func func;

  function runToBoolean
    input Func func;
    output tuple<Boolean,list<String>> res;
  protected
    partial function Func
      output Boolean b;
    end Func;
  algorithm
    res := (func(),{});
  end runToBoolean;


end callTargetTemplates;

问题：这里，为什么一个函数内部可以定义另一个partical函数，这种partical函数都是没有函数体的
同时，一个函数内部也可以定义一个完整的函数，而在这个函数内，可以嵌套的进行上面的操作


partial function PartialRunTpl
  output tuple<Boolean,list<String>> res;
end PartialRunTpl;
list<PartialRunTpl> codegenFuncs;


codegenFuncs := {};
codegenFuncs := (function runToBoolean(func=function SerializeInitXML.simulationInitFileReturnBool(simCode=simCode, guid=guid))) :: codegenFuncs;
codegenFuncs := (function runTpl(func=function CodegenC.translateModel(in_a_simCode=simCode))) :: codegenFuncs;

问题：这里为什么函数前面要写一个function字样



值得一看：

for f in {
  (CodegenEmbeddedC.mainFile, "_main.c")
} loop
  (func,str) := f;

f是一个元组，func是之前定义的的那个不完整类Func类的对象



match simulationSettingsOpt case SOME(settings as SIMULATION_SETTINGS(__)) then settings.method else ""

这个也就是说看一下是不是 SIMULATION_SETTINGS(__)类型的，如果是，把这个变量起别名，叫做settings

