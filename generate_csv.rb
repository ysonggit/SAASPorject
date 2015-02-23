# read inpt file using ARGF
# run shell command$ ruby generate_csv.rb ClassScheduleFall.2014.02.18.txt  
require 'csv'

#########################################################################
#
#                 Problem 1 Solution
#       Read from ClassScheduleFall.2014.02.18.txt 
#       Write to course_schedule.csv 
#
#########################################################################

file_lines = ARGF.readlines

# define a class for schedule format
class Schedule
  attr_accessor :start_time, :start_ampm, :end_time, :end_ampm, :day, :instructor
  def initialize(s, a, e, p, d, i)
    @start_time = s.to_s
    @start_ampm = a.to_s
    @end_time = e.to_s
    @end_ampm = p.to_s
    @day = d.to_s
    @instructor = i.to_s
  end

  def print
    puts @start_time+" "+@start_ampm+" - "+@end_time+" "+@end_ampm+" "+@day+"  "+@instructor
  end
end

# define a class to hold course information
class Course
  attr_accessor :course_num, :section_num, :schedules
  def initialize(course_num, section_num)
    @course_num = course_num.to_s
    @section_num = section_num.to_s
    @schedules = Array.new
  end
end

# create a Hash, key is course info: name, course idx, course number,
# value is the course' line number, stored in an array
line_idx = 0 
courses_array = Array.new
courses_array_idx = 0
file_lines.each do |aline|
  
  if aline.include?("- CSCE") # add - CSCE to filter some string with Csce
    #print '[', line_idx, ']', aline    
    /(\d{3})(\s*)(-)(\s*)([A-Z]\d{2}|\d{3})/ =~ aline
    #print $1, ' -- ', $5, "\n"
    _course = Course.new($1, $5)
    courses_array.push(_course)
    courses_array_idx += 1
  end
  
  if( (line_idx >11) && aline.include?("Class") )
    start_time = ''
    start_ampm = ''
    end_time = ''
    end_ampm = ''
    day = ''
    instructor = 'TBA'
    /((\d+):(\d{2}))(\s*)(\w+)(\s*)-(\s*)((\d+):(\d{2}))(\s*)(\w+)(\s*)([A-Z]+) / =~ aline
    
    if !($1.nil?)
      #print $1, $5 , $8, $12, $14, "\n"
      start_time = $1
      start_ampm = $5
      end_time = $8
      end_ampm = $12
      day = $14
    end
    
    #/Lecture(\s*)([^\/|^\(]*)/ =~ aline
    #/Lecture(\s*)([\/]*)([^\(]*)/=~ aline
    # if ($2 != "\/")
    #   instructor = $3
    # else
    #   instructor ='TBA'
    # end
    lecturer = /Lecture(\s*)([\/]*)([^\(]*)/.match(aline)
    if (lecturer.to_s.include?('TBA'))
      instructor ='TBA'
    else
      /Lecture(\s*)([\/]*)([^\(]*)/ =~ aline
      instructor = $3
    end
    
    lecturer2 = /Study(\s*)([^\(]*)/.match(aline)
    if lecturer2.to_s.include?('TBA')
      instructor = 'TBA'
    else
      /Study(\s*)([^\(]*)/=~ aline
      if !($2.nil?)
        instructor = $2
      end
    end

    /Thesis(\s*)([^\(]*)/=~ aline
    if !($2.nil?)
      instructor = $2
    end

    /Dissertation(\s*)([^\(]*)/=~ aline
    if !($2.nil?)
      instructor = $2
    end

    _schedule = Schedule.new(start_time, start_ampm, end_time, end_ampm, day, instructor)
    courses_array[courses_array_idx-1].schedules.push(_schedule)
  end

  line_idx +=1 
end


# ## check array of Course objects
# courses_array.each do |c|
#   print "=========================================\n"
#   print c.course_num, " - ", c.section_num, "\n"
#   c.schedules.each do |s|
#     s.print
#   end
# end

## write to CSV file 
CSV.open("course_schedule.csv", "ab") do |row|
  courses_array.each do |c|
    if c.schedules.length == 1
      c.schedules.each do |s|
        row<<[c.course_num, c.section_num, s.start_time, s.start_ampm, s.end_time, s.end_ampm, s.day, s.instructor]
      end
    else
      row<<[c.course_num, c.section_num, c.schedules[0].start_time, c.schedules[0].start_ampm, c.schedules[0].end_time, c.schedules[0].end_ampm, c.schedules[0].day, c.schedules[0].instructor, c.schedules[1].start_time, c.schedules[1].start_ampm, c.schedules[1].end_time, c.schedules[1].end_ampm, c.schedules[1].day, c.schedules[1].instructor]
    end
  end
end



