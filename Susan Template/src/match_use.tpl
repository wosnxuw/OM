package match_use
import interface Exp_define;

template match_1(String s) ::=
    match s
    case "one" then 1
    case "two" then 2
    case _ then 0 //_ 为通配符，类似*，必然会进入
    end match
end match_1;

// 最后落入else
template match_2(String s) ::=
    match s
    case "one" then 1
    case "two" then 2
    else 0 //else 没高亮，但是是对的
    end match
end match_2;

template match_3(Exp ep) ::=
    match ep
    case ICONST(__) then value
    case PLUS(__) then '(<%match_3(lhs)%>> + <%match_3(rhs)%>>)'
    // end match at here is optional , bus must at nested match
end match_3;

end match_use;