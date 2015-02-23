class Tacommitment < ActiveRecord::Base
  has_many :meetings, :through => :Subscription
  attr_accessor :courses_list, :not_available_times, :available_meetings
  def courses_list 
    courses_enrolled = self.commitments.scan(/(\d{3})/)
    # returns to courses_enrolled = [["750"], ["513"] ]
    courselist = [] # list of strings
    courses_enrolled.each do |ce|
      courselist.push(ce[0])
    end
    return courselist
  end
  
  def not_available_times 
    time_array =[] # array of array of strings
    # time_arry =[['08:30', '09:45', 'M'], ['08:30', '09:45', 'W']]
    self.courses_list.each do |c|
      Meeting.all.each do |m|
        if m.course.to_i == c.to_i
          time_na = []
          time_na.push(m.start)
          time_na.push(m.end)
          time_na.push(m.day)
          time_array.push(time_na)
        end
      end
    end
    return time_array
  end

  def available_meetings
    courses_to_assign =[]
    Meeting.all.each do |m|
      if m.course.to_i < 499
        # the course a TA can instruct must be below 499 level
        if !m.start.nil?
          # here compare the time interval of meeting m with the not available time of TA
          # m.start is in string format, so parse to Time format for comparison
          m_start = m.start.hour * 60 + m.start.min
          if m.start.hour < 8 and m.start.hour > 1
            m_start += 720 # 720= 12 * 60 convert to 24 hr format, the RUBY time class really sucks!
          end
          m_end = m.end.hour * 60 + m.end.min
          if m.end.hour < 8 and m.end.hour  >= 1
            m_end += 720
          end
          available = true 
          ##################################################################
          self.not_available_times.each do |nat|
            nat_start = nat[0].hour * 60 + nat[0].min
            if nat_start.hour < 8 and nat_start.hour >=1
              nat_start += 720
            end
            nat_end = nat[1].hour * 60 + nat[1].min
            if nat_end.hour < 8 and nat_start.hour >=1
              nat_end += 720
            end
            if nat[2] == m.day
              # compare time interval if the same day
              # find collision
              if nat_start >= m_start and nat_start <= m_end
                available = false
              end
              if nat_end >= m_start and nat_end <= m_end
                available = false
              end
            end
          end
          ###################################################################
          if available
            courses_to_assign.push(m)
          end
        end

      end
    end
    return courses_to_assign
  end
end

