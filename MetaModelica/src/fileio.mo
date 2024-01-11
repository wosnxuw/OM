model fileio
import File;


//目前看起来，如果不在OMC开发环境下，是没有办法使用File类的
function writeToFile
  input String str;
  input String filename;
protected
  File.File file = File.File();

algorithm
  File.open(file, filename, File.Mode.Write);
  File.write(file, str);      
end writeToFile;

public function main
protected
algorithm
  writeToFile("hello world","test.txt");
end main;

equation
  main();

end fileio;