
model list_use
function myStringDelimitList
  input list<String> stringList;
  input String delimiter;
  output String outString;
algorithm
  outString := match stringList
    local
      String head;
      StringList tail;
    // Remember to match the empty list
    case {} then "" ; 
    // {}实际上就是构造了一个列表，但是是空的
    // The last element does not need the delimiter
    case {head} then head;
    // {head} 也构造了一个列表，但里面仅有一个元素，那就是head
    // Pattern-matching using the cons operator
    case head::tail then head + delimiter + myStringDelimitList(tail,delimiter);
    // :: 是拼接符。因此head::tail也构造了一个列表，这个列表必然长度大于1
    //注意head是String类型，而tail是StringList，这保证了{head}一定有一个元素
  end match;
end myStringDelimitList;
end list_use;