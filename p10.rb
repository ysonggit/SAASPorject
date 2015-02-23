load "open-uri.rb"
url = "http://bulletin.sc.edu/content.php?catoid=63&navoid=6401&filter%5Bitem_type%5D=3&filter%5Bonly_active%5D=1&filter%5B3%5D=1&filter%5Bcpage%5D=8#acalog_template_course_filter"

def get_line_number(url)
  line_idx = 0 
  webpage = open(url).each_line do |line|
    line_idx +=1 
    if line.include?("<!-- End advanced search filter. -->")
      return line_idx
    end
  end
end #end def 
 
def get_course_id_array(line_idx, url)
  course_id_array = []
  line_num = 0 
  webpage = open(url).each_line do |line|
    line_num +=1
    if line_num > line_idx 
      if line.include?("CSCE&#160;311")
        course_id = line.match(/preview_course.php\?catoid=63&coid=(\d{5})/)[1]
        course_id_array.push(course_id)
      end
    end
  end 
  return course_id_array
end #end def

line_idx = get_line_number(url)
#puts line_idx
course_id_array = get_course_id_array(line_idx, url)
#course_id_array.each {|coid| puts coid}
url_array = []
course_id_array.each do |coid|
  url_array.push("http://bulletin.sc.edu/preview_course.php?catoid=63&coid="+coid)
end

prereqs = Hash.new
courses = Array.new 
url_array.each do |i|
  webpage = open(i).each_line do |line|
    if line.include?("Prerequisites")
      pres = line.match(/(<\/strong>)([^\-]*)(<br><br>)/)
      pre_courses =  pres[2].split(",")
      pre_courses.each do |j|
        if j.include?("CSCE")
          k= j.split(" ")
          courses.push(k[1])
        else
          courses.push(j)
        end
      end 
    end 
  end 
end

prereqs["311"] = courses
puts prereqs["311"]
