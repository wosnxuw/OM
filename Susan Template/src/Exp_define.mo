interface package Exp_define
package expression

uniontype Exp
record ICONST 
Integer value; 
end ICONST; 
record PLUS 
Exp lhs; 
Exp rhs; 
end PLUS; 
end Exp;

end expression;
end Exp_define;