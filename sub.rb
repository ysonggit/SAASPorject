# read from stdin and perfrom substution on lines and write-out
# to read from a file one can use ruby sub.rb < file
# to write the resullt to a file you can use ruby sub.rb <infile > outfile

pattern=/\d{9}/ # a nine digit number
pattern2 = /\d{3}\-\d{2}\-\d{4}/
replacement = "<Social-Security>"

ARGF.each do |line|
   line = line.sub(pattern, replacement)
   line = line.sub(pattern2, replacement)
   puts line
end
   
