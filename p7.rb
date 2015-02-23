
puts "Enter file name: "
filename = gets.chomp
if !(File.exist?(filename))
  # file not exist then exit
  abort("File : #{filename} does not exit")
end



text = File.read(filename)
puts1 = text.gsub(/^\(?(\d{3})\)?([ .-]?)(\d{3})([ .-])(\d{4})$/, "---Phone Number---")
puts2 = puts1.gsub(/^(\d{3})([ .-])(\d{2})([ .-])(\d{4})$/, "---socsec---")
puts3 = puts2.gsub(/^[\d]{5}(-[\d]{4})?$/, "---zip---")
File.open(filename, "w"){|file| file<<puts3}


  
