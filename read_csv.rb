
require 'csv'

#########################################################################
#
#                 Problem 2 Solution
#       Construct Array of Hash Maps for Meetings
#       Each line in the CSV file is a Hash Map
#
#########################################################################

## read from csv
# File.foreach('course_schedule.csv') do |line|
#   row = CSV.parse(line.gsub('"', '')).first
#   #print row[0], row[1], "\n"
#   puts row.length
# end

class Meeting
  attr_accessor :course, :section, :day, :start_time, :end_time, :instructor
  
  def initialize(n, s)#, d, st, et, i)
    @course = n.to_s
    @section = s.to_s
    @day = ''
    @start_time = ''
    @end_time = ''
    @instructor  = ''
  end

  def print
    puts "Course: "+@course
    puts "section: "+@section
    puts "day: "+@day
    puts "start: "+@start_time
    puts "end: "+@end_time
    puts "Instructor: "+@instructor
  end

  def printseed
    puts "{:course => '"+@course+"', :section => '"+@section+"', :start => '"+@start_time+"', :end => '"+@end_time+"', :day => '"+@day+"', :instructor => '"+@instructor+"'},"
  end
end

csv_rows = Array.new
CSV.foreach('course_schedule.csv') do |row|
  csv_rows.push(row)
end

# construct array of meetings, each row is an array element, each element is another array of Meeting objects 
all_meetings = Array.new
csv_rows.each do | row |
  # check row[6] for days
  i = 0
  meetings = Array.new
  if row[6].length > 0
    row[6].each_char do |d|
      i +=1
      m = Meeting.new(row[0], row[1])
      m.day = d
      m.start_time = row[2]
      m.end_time = row[4]
      m.instructor = row[7]
      meetings.push(m)
    end
  else
    m = Meeting.new(row[0], row[1])
    # only lecturer info is available,so check row[7] and row[13]
    if row[7].length >0
      m.instructor = row[7]
    end
    meetings.push(m)
  end

  # if row length is 14, check row[12] for days
  if row.length > 8
    if row[12].length >0
      row[12].each_char do |d|
        i +=1
        m = Meeting.new(row[0], row[1])
        m.day = d
        m.start_time = row[8]
        m.end_time = row[10]
        m.instructor = row[13]
        meetings.push(m)
      end
    else
      m = Meeting.new(row[0], row[1])
      if row[13].length >0
        m.instructor = row[13]
      end
      meetings.push(m)
    end
  end

  all_meetings.push(meetings)
end


# print meetings
# all_meetings.each do |meetings|
#   puts "==============================================="
#   i = 0
#   meetings.each do |m|
#     i +=1
#     puts "Meeting #{i}: "
#     m.print
#   end
# end

# print meetings in form of 
# {:course => '101', :section => '001', :start => '8:30', :end => '9:20', :day => 'M', :instructor => 'TBA'},
# {:course => '101', :section => '001', :start => '8:30', :end => '9:20', :day => 'W', :instructor => 'TBA'},
# {:course => '101', :section => '001', :start => '8:30', :end => '9:20', :day => 'F', :instructor => 'TBA'} 


all_meetings.each do |meetings|
  meetings.each do |m|
    m.printseed
  end
end
