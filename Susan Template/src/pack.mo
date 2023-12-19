encapsulated package pack
    constant Integer k=-4;

    function funf
      input Integer x;
      output Integer y;
     algorithm
      if x==1 then
        y:=1;
      elseif x==2 then
        y:=1;
      else
        y:=funf(x-1)+funf(x-2);
      end if;
     end funf;
     
    function fund
        input Real x;
        output Real y;
    algorithm
        y:=x-9;
    end fund;
    
    
end pack;
