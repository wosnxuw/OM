package list_use

import hello;

template list_1(list<Integer> li) ::=
    let a = hello.tp(10.0)    
    li |> item => <<<%item%>>>
    //根据现在对let的理解，模板中是不能创造列表变量的，let只能创建Text，列表可能需要从MetaModelica中引入
end list_1;

template list_2(list<String> names) ::=
let xxx_name = (names |> name => 'xxx_<%name%>' ;separator=", ")
let test_list0 = {1,2,3}
let test_list1 = {"1","2","3"}
let test_list2 = {1,"2",3} //ok
//之后使用list2，它就只是123拼接，不是一个列表
//后续names之所以可以取出来，是因为它是函数的形参
//let写在开头，否则会报end相关错误
<<
Hello <%(names |> name => <<Mr.<%name%> >> ;separator=", ")%>
>>
// 在这里，可以看到嵌套的<%%>。我认为文法是这样的，函数体内放置模板语句，而=>后面也需要模板语句
// 输出：只有一个Hello，推导出的列表，用逗号空格来拼接
end list_2;

end list_use;