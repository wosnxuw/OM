encapsulated package match_use
"
  file:        match_use.mo
  package:     match_use
  description: Generated by Susan.
"

public import Tpl;

public import expression;

public function match_1
  input Tpl.Text in_txt;
  input String in_a_s;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  match(in_txt, in_a_s)
    local
      Tpl.Text txt;

    case ( txt,
           "one" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("1"));
      then txt;

    case ( txt,
           "two" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("2"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("0"));
      then txt;
  end match;
end match_1;

public function match_2
  input Tpl.Text in_txt;
  input String in_a_s;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  match(in_txt, in_a_s)
    local
      Tpl.Text txt;

    case ( txt,
           "one" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("1"));
      then txt;

    case ( txt,
           "two" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("2"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("0"));
      then txt;
  end match;
end match_2;

public function match_3
  input Tpl.Text in_txt;
  input expression.Exp in_a_ep;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  match(in_txt, in_a_ep)
    local
      Tpl.Text txt;
      expression.Exp i_rhs;
      expression.Exp i_lhs;
      Integer i_value;

    case ( txt,
           expression.ICONST(value = i_value) )
      equation
        txt = Tpl.writeStr(txt, intString(i_value));
      then txt;

    case ( txt,
           expression.PLUS(lhs = i_lhs, rhs = i_rhs) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = match_3(txt, i_lhs);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("> + "));
        txt = match_3(txt, i_rhs);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(">)"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end match;
end match_3;

annotation(__OpenModelica_generator="Susan");
end match_use;