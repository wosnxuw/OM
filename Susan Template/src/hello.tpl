package hello
import interface MyInterface;
template tp(Real x) ::= 
    if x then
    <<x <%(x+1)%>>>
    else
    <<x>>
    
end tp;
template ng(Real y, Text &arg) ::=
    let local_var= fu.crefSubIsScalar(10)
    let &what = buffer ""
    let &what += <<this>>
    if y then
    <<this is <%local_var%>>>
end ng;
end hello;