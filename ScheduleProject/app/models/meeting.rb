class Meeting < ActiveRecord::Base
  belongs_to :tacommitment
  attr_accessor :available_ta_list
 
  def hour_in_24(hour_in_12)
    start_time_in_24hr = hour_in_12 # make sure it is Fixnum
    if hour_in_12 < 8 and hour_in_12 >=1
      # time at afternoon
      start_time_in_24hr += 12
    end
    return start_time_in_24hr
  end

  def available_ta_list
    talist = []
    Tacommitment.all.each do |ta|
      # compare meeting time with each TA's not available time
      meeting_start =  hour_in_24(self.start.hour) * 60 + self.start.min
      meeting_end = hour_in_24(self.end.hour) * 60 + self.end.min
      available = true
      ta.not_available_times.each do |tatime|
        tatime_start = hour_in_24(tatime[0].hour) * 60 + tatime[0].min
        tatime_end = hour_in_24(tatime[1].hour) * 60 + tatime[1].min
        if tatime[2] == self.day
          if tatime_start >= meeting_start and tatime_start <= meeting_end
            available = false
            break
          end 
          if tatime_end >= meeting_start and tatime_end <= meeting_end
            available = false
            break
          end 
        end 
      end 
      
      if available
        talist.push(ta)
      end 
    end
    return talist
  end


end
