function coo "将致密矩阵转化为稀疏矩阵"
  input Real M[:,:];
  output Real rows[:]; 
  output Real clos[:]; 
  output Real data[:]; //这种没法直接写值进去
protected
   Real tol = 1e-5;
   Real r_temp[size(M,1)*size(M,2)];
   Real c_temp[size(M,1)*size(M,2)];
   Real d_temp[size(M,1)*size(M,2)];
   Integer counter=1;
algorithm
  for i in 1:size(M,1) loop
    for j in 1:size(M,2) loop
     if abs(M[i,j]) > tol then
      r_temp[counter]:=i;
      c_temp[counter]:=j;
      d_temp[counter]:=M[i,j];
      counter:=counter+1;
     end if;
    end for;
  end for;
  rows:=r_temp[1:counter-1];
  cols:=c_temp[1:counter-1];
  data:=d_temp[1:counter-1];
end coo;
