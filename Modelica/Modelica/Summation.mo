class Summation
  Real sum(start=0);
  Integer n(start=size(a,1));
  Real a[5]={1,3,6,9,13};
algorithm
  while n>0 loop
      if a[n]>0 then
        sum:=sum+a[n];
      else
        sum:=sum-a[n];
      end if;
  end while;
end Summation;
