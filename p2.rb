# opens a file and prints every line that has the word windows, case matters 
File.open('HW1-RegExpr.txt', 'r') do |f1|  
  while line = f1.gets  
    if line.include?("windows")
      puts line  
    end
  end  
end  
