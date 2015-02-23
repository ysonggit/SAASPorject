# To run the program, use command :
# ruby hw2.rb ClassScheduleFall.2014.02.18.txt

# convert hh:mm am/pm to 24 hour format
def convert_to_24(t_12)
  t = /^(\d+):(\d{2})/.match(t_12).to_s
  hh = /^(\d+)/.match(t_12).to_s
  _mm =/:(\d{2})/.match(t_12).to_s
  mm = /(\d{2})/.match(_mm).to_s
  ampm = /[a|p]m/.match(t_12).to_s
  if (ampm == "pm")
    hr = (hh.to_i + 12).to_s 
    return hr+':'+mm 
  end 
  return t 
end 


# convert time in 24hr to number of minutes
def num_minutes(t_24)
  hh = /^(\d+)/.match(t_24).to_s
  _mm = /:(\d{2})/.match(t_24).to_s
  mm = /(\d+)/.match(_mm).to_s
  
  return ((hh.to_i)*60 + mm.to_i)
end

# the input parameter must have the format of hh:mm am/pm - hh:mm am/pm
def time_collision(time1, time2)
  t1_start_12 = /^(\d+):(\d{2})\s*(\w+)/.match(time1).to_s
  _t1_end = /-(\s*)(\d+):(\d{2})\s*(\w+)/.match(time1).to_s
  t1_end_12 = /(\d+):(\d{2})\s*(\w+)/.match(_t1_end).to_s
  t1_start = num_minutes(convert_to_24(t1_start_12))
  t1_end = num_minutes(convert_to_24(t1_end_12))
  
  t2_start_12 = /^(\d+):(\d{2})\s*(\w+)/.match(time2).to_s
  _t2_end = /-(\s*)(\d+):(\d{2})\s*(\w+)/.match(time2).to_s
  t2_end_12 = /(\d+):(\d{2})\s*(\w+)/.match(_t2_end).to_s
  t2_start = num_minutes(convert_to_24(t2_start_12))
  t2_end = num_minutes(convert_to_24(t2_end_12))
  
  if(t1_start >= t2_start && t1_start <= t2_end)
    return true;
  end
  if (t1_end >= t2_start && t1_end <= t2_end)
    return true;
  end

  return false

end 

# the input parameter must have the format of hh:mm am/pm - hh:mm am/pm MW/TR/M/W/T/R/F
def has_collision(time1, time2)
  day1 = /[MTWRF]+/.match(time1).to_s
  day2 = /[MTWRF]+/.match(time2).to_s
  if (day1.include?(day2) || day2.include?(day1))
    return time_collision(time1, time2)
  else
    return false
  end 
end


file_lines = ARGF.readlines

puts file_lines.class 

puts file_lines.length


# create a Hash, key is course info: name, course idx, course number,
# value is the course' line number, stored in an array
line_idx = 0 
courses = Hash.new
course_lineno_array = Array.new
file_lines.each do |aline|
  line_idx +=1 
  if aline.include?("CSCE")
    course_lineno_array.push(line_idx)
    course_in_line = Array.new
    course_in_line.push(line_idx)
    #print '[', line_idx, ']', aline    
    courses[aline] = course_in_line
  end
end

# convert array to hash, the key is array element, value is the index of that element
# Hash[2031] => 13
# key is line number 2013, value is the index in the array 13.
lineno_hash = Hash[course_lineno_array.each_with_index.map {|n, i| [n, i]}]
# lineno_hash.each do |key, value|
#   puts "#{key} : #{value}"
# end

# enrich the array of course' line number by append next course' line number to the array

courses.each do |key, key_array|
 # puts "#{key} : #{key_array}"
  current_idx = lineno_hash[key_array[0]]
 # if (current_idx != 2939 ) # last class listed 
    next_idx = current_idx+1;
    next_lineno = course_lineno_array[next_idx]
    key_array.push(next_lineno)
  #else
  #  key_array.push(line_idx)
  #end
end

# so far, the Hash is like  Hash['CSCE 102'] => [1102, 1112]

# now build hash table with key as course name, and value is the array of meeting time
course_time_hash = Hash.new

courses.each do |key, key_array|
  #puts "#{key}"
  time_array = Array.new
  
  # for course #{key}, lookup time between line Key_array[0] and line Key_array[1]
  if (key_array[0] != 2939)
    for line_num in key_array[0] ... key_array[1]
      #puts key_array[0].class 
      if (file_lines[line_num].include?("Class"))
        #/(\d+):(\d{2})\s*(\w+)(\s*)-(\s*)(\d+):(\d{2})\s*(\w+)(\s*)([A-Z]+) /
        meeting_time =/(\d+):(\d{2})\s*(\w+)(\s*)-(\s*)(\d+):(\d{2})\s*(\w+)(\s*)([A-Z]+) /.match(file_lines[line_num])
        time_array.push(meeting_time.to_s)
      end
    end
  end
  course_time_hash[key] = time_array
end

# course_time_hash.each do |course, times|
#   puts "#{course}"
#   times.each do |t|
#     puts "\t #{t}"
#   end
# end

# get user's schedule and save to an array
schedule = Array.new
begin
  puts "Enter your schedule in the format of hh:mm am/pm - hh:mm am/pm MW/TR/F"
  sch = STDIN.gets
  puts sch
  if(sch.match(/(\d+):(\d{2})\s*(\w+)(\s*)-(\s*)(\d+):(\d{2})\s*(\w+)(\s*)([A-Z]+)/) )
    schedule.push(sch.chomp())
  else
    puts "wrong time format, exit!"
    exit
  end
  puts "do you want to enter your schedule ? (y/n)"
  ans = STDIN.gets.chomp
end while ans.eql?("y")

# create an array holding the key (course name) that need to be removed (collision)
to_be_removed = Array.new

# iterate the schedule array, compare the time interval one by one
schedule.each do |sch|
  #puts sch
  course_time_hash.each do |course, times|
    times.each do |t|
      if(has_collision(sch, t))
        to_be_removed.push(course)
        break
      end
    end
  end
end

to_be_removed.each do |key|
  course_time_hash.tap{|hs| hs.delete(:key)}
end

# show final possibilities
course_time_hash.each do |course, times|
  puts "#{course}"
  times.each do |t|
    puts "#{t}"
  end
end
