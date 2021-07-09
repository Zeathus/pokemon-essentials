#===============================================================================
# Day and night system
#===============================================================================
class CustomTime
  
  attr_accessor(:sec)
  attr_accessor(:min)
  attr_accessor(:hour)
  attr_accessor(:day)
  attr_accessor(:lasttime)
  attr_accessor(:pause)
  
  def initialize
    self.sec = 0
    self.min = 0
    self.hour = 12
    self.day = 1
    self.lasttime = Time.now
    self.pause = false
  end
  
  def wday
    days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ]
    return days[(day-1) % 7]
  end
  
  def month
    return ((day / 30).floor) % 12
  end
  
  def mon
    return self.month
  end
  
  def year
    return (day / 365).floor
  end
  
  def update
    return false if self.pause
    timenow = Time.now
    if timenow.sec != lasttime.sec
      self.sec += 30
      self.min += 1 if sec >= 60
      self.hour += 1 if min >= 60
      pbUpdateWeather if min >= 60
      pbGenerateForecast if hour >= 24
      self.day += 1 if hour >= 24
      self.sec = 0 if sec >= 60
      self.min = 0 if min >= 60
      self.hour = 0 if hour >= 24
      self.lasttime = timenow
      return true
    end
    self.lasttime = timenow
    return false
  end
  
  def getDigitalString(showday=false)
    if pbGetLanguage()==2 # English, 12-hour format
      hour_now = self.hour
      suffix = "AM"
      if hour_now >= 12
        suffix = "PM"
        hour_now-=12
      end
      hour_now = 12 if hour_now == 0
      if showday
        return wday + " " + _ISPRINTF("{1:02d}:{2:02d}",hour_now,self.min) + " " + suffix
      end
      return _ISPRINTF("{1:02d}:{2:02d}",hour_now,self.min) + " " + suffix
    else # Other country 24-hour format
      if showday
        return wday + " " + _ISPRINTF("{1:02d}:{2:02d}",self.hour,self.min)
      end
      return _ISPRINTF("{1:02d}:{2:02d}",self.hour,self.min)
    end
  end
  
  def forwardToTime(h, m)
    self.day += 1
    self.hour = h
    self.min = m
    pbGenerateForecast
    pbUpdateWeather
  end
  
  def to_i
    ret = self.sec
    ret += self.min * 60
    ret += self.hour * 60 * 60
    ret += self.day * 24 * 60 * 60
    return ret
  end
  
  def to_i_min
    ret = self.min
    ret += self.hour * 60
    ret += self.day * 24 * 60
    return ret
  end
  
end

def pbGetTimeNow
  if $game_variables
    if !$game_variables[TIME_AND_DAY].is_a?(CustomTime)
      $game_variables[TIME_AND_DAY]=CustomTime.new
    end
    return $game_variables[TIME_AND_DAY]
  end
  return Time.now
end

def pbGetDayNow
  if $game_variables
    if !$game_variables[TIME_AND_DAY] || $game_variables[TIME_AND_DAY]==0
      time=Time.now
      
    end
    return $game_variables[TIME_AND_DAY][1]
  end
  return PBWeekdays::Monday
end

module PBWeekdays
  Monday    = 0
  Tuesday   = 1
  Wednesday = 2
  Thursday  = 3
  Friday    = 4
  Saturday  = 5
  Sunday    = 6
end

module PBDayNight
  HourlyTones = [
    Tone.new(-70, -90,  15, 55),   # Night           # Midnight
    Tone.new(-70, -90,  15, 55),   # Night
    Tone.new(-70, -90,  15, 55),   # Night
    Tone.new(-70, -90,  15, 55),   # Night
    Tone.new(-60, -70,  -5, 50),   # Night
    Tone.new(-40, -50, -35, 50),   # Day/morning
    Tone.new(-40, -50, -35, 50),   # Day/morning     # 6AM
    Tone.new(-40, -50, -35, 50),   # Day/morning
    Tone.new(-40, -50, -35, 50),   # Day/morning
    Tone.new(-20, -25, -15, 20),   # Day/morning
    Tone.new(  0,   0,   0,  0),   # Day
    Tone.new(  0,   0,   0,  0),   # Day
    Tone.new(  0,   0,   0,  0),   # Day             # Noon
    Tone.new(  0,   0,   0,  0),   # Day
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new(  0,   0,   0,  0),   # Day/afternoon
    Tone.new( -5, -30, -20,  0),   # Day/evening     # 6PM
    Tone.new(-15, -60, -10, 20),   # Day/evening
    Tone.new(-15, -60, -10, 20),   # Day/evening
    Tone.new(-40, -75,   5, 40),   # Night
    Tone.new(-70, -90,  15, 55),   # Night
    Tone.new(-70, -90,  15, 55)    # Night
  ]
  @cachedTone = nil
  @dayNightToneLastUpdate = nil
  @oneOverSixty = 1/60.0

  # Returns true if it's day.
  def self.isDay?(time=nil)
    time = pbGetTimeNow if !time
    return (time.hour>=5 && time.hour<20)
  end

  # Returns true if it's night.
  def self.isNight?(time=nil)
    time = pbGetTimeNow if !time
    return (time.hour>=20 || time.hour<5)
  end

  # Returns true if it's morning.
  def self.isMorning?(time=nil)
    time = pbGetTimeNow if !time
    return (time.hour>=5 && time.hour<10)
  end

  # Returns true if it's the afternoon.
  def self.isAfternoon?(time=nil)
    time = pbGetTimeNow if !time
    return (time.hour>=14 && time.hour<17)
  end

  # Returns true if it's the evening.
  def self.isEvening?(time=nil)
    time = pbGetTimeNow if !time
    return (time.hour>=17 && time.hour<20)
  end
  
  def self.getTimeOfDay(time=nil)
    if self.isDay?(time)
      return "day"
    elsif self.isNight?(time)
      return "night"
    elsif self.isMorning?(time)
      return "morning"
    elsif self.isAfternoon?(time)
      return "afternoon"
    elsif self.isEvening?(time)
      return "evening"
    end
    return "day"
  end

  # Gets a number representing the amount of daylight (0=full night, 255=full day).
  def self.getShade
    time = pbGetDayNightMinutes
    time = (24*60)-time if time>(12*60)
    return 255*time/(12*60)
  end

  # Gets a Tone object representing a suggested shading
  # tone for the current time of day.
  def self.getTone
    @cachedTone = Tone.new(0,0,0) if !@cachedTone
    return @cachedTone if !Settings::TIME_SHADING
    if !@dayNightToneLastUpdate ||
       Graphics.frame_count-@dayNightToneLastUpdate>=Graphics.frame_rate*30
      getToneInternal
      @dayNightToneLastUpdate = Graphics.frame_count
    end
    return @cachedTone
  end

  def self.pbGetDayNightMinutes
    now = pbGetTimeNow   # Get the current in-game time
    return (now.hour*60)+now.min
  end

  private

  def self.getToneInternal
    # Calculates the tone for the current frame, used for day/night effects
    realMinutes = pbGetDayNightMinutes
    hour   = realMinutes/60
    minute = realMinutes%60
    tone         = PBDayNight::HourlyTones[hour]
    nexthourtone = PBDayNight::HourlyTones[(hour+1)%24]
    # Calculate current tint according to current and next hour's tint and
    # depending on current minute
    @cachedTone.red   = ((nexthourtone.red-tone.red)*minute*@oneOverSixty)+tone.red
    @cachedTone.green = ((nexthourtone.green-tone.green)*minute*@oneOverSixty)+tone.green
    @cachedTone.blue  = ((nexthourtone.blue-tone.blue)*minute*@oneOverSixty)+tone.blue
    @cachedTone.gray  = ((nexthourtone.gray-tone.gray)*minute*@oneOverSixty)+tone.gray
  end
end



def pbDayNightTint(object)
  return if !$scene.is_a?(Scene_Map)
  if Settings::TIME_SHADING && GameData::MapMetadata.exists?($game_map.map_id) &&
     GameData::MapMetadata.get($game_map.map_id).outdoor_map
    tone = PBDayNight.getTone
    if (pbGetTimeNow.hour >= 18 || pbGetTimeNow.hour <= 5) && PBMaps.hasLights
      li=0.5
      object.tone.set(tone.red*li,tone.green*li,tone.blue*li,tone.gray*li)
    else
      object.tone.set(tone.red,tone.green,tone.blue,tone.gray)
    end
  else
    object.tone.set(0,0,0,0)
  end
end



#===============================================================================
# Moon phases and Zodiac
#===============================================================================
# Calculates the phase of the moon.
# 0 - New Moon
# 1 - Waxing Crescent
# 2 - First Quarter
# 3 - Waxing Gibbous
# 4 - Full Moon
# 5 - Waning Gibbous
# 6 - Last Quarter
# 7 - Waning Crescent
def moonphase(time=nil) # in UTC
  time = pbGetTimeNow if !time
  transitions = [
     1.8456618033125,
     5.5369854099375,
     9.2283090165625,
     12.9196326231875,
     16.6109562298125,
     20.3022798364375,
     23.9936034430625,
     27.6849270496875]
  yy = time.year-((12-time.mon)/10.0).floor
  j = (365.25*(4712+yy)).floor + (((time.mon+9)%12)*30.6+0.5).floor + time.day+59
  j -= (((yy/100.0)+49).floor*0.75).floor-38 if j>2299160
  j += (((time.hour*60)+time.min*60)+time.sec)/86400.0
  v = (j-2451550.1)/29.530588853
  v = ((v-v.floor)+(v<0 ? 1 : 0))
  ag = v*29.53
  for i in 0...transitions.length
    return i if ag<=transitions[i]
  end
  return 0
end

# Calculates the zodiac sign based on the given month and day:
# 0 is Aries, 11 is Pisces. Month is 1 if January, and so on.
def zodiac(month,day)
  time = [
     3,21,4,19,   # Aries
     4,20,5,20,   # Taurus
     5,21,6,20,   # Gemini
     6,21,7,20,   # Cancer
     7,23,8,22,   # Leo
     8,23,9,22,   # Virgo
     9,23,10,22,  # Libra
     10,23,11,21, # Scorpio
     11,22,12,21, # Sagittarius
     12,22,1,19,  # Capricorn
     1,20,2,18,   # Aquarius
     2,19,3,20    # Pisces
  ]
  for i in 0...12
    return i if month==time[i*4] && day>=time[i*4+1]
    return i if month==time[i*4+2] && day<=time[i*4+3]
  end
  return 0
end

# Returns the opposite of the given zodiac sign.
# 0 is Aries, 11 is Pisces.
def zodiacOpposite(sign)
  return (sign+6)%12
end

# 0 is Aries, 11 is Pisces.
def zodiacPartners(sign)
  return [(sign+4)%12,(sign+8)%12]
end

# 0 is Aries, 11 is Pisces.
def zodiacComplements(sign)
  return [(sign+1)%12,(sign+11)%12]
end

#===============================================================================
# Days of the week
#===============================================================================
def pbIsWeekday(wdayVariable,*arg)
  timenow = pbGetTimeNow
  wday = timenow.wday
  ret = false
  for wd in arg
    ret = true if wd==wday
  end
  if wdayVariable>0
    $game_variables[wdayVariable] = [
       _INTL("Sunday"),
       _INTL("Monday"),
       _INTL("Tuesday"),
       _INTL("Wednesday"),
       _INTL("Thursday"),
       _INTL("Friday"),
       _INTL("Saturday")][wday]
    $game_map.need_refresh = true if $game_map
  end
  return ret
end

#===============================================================================
# Months
#===============================================================================
def pbIsMonth(monVariable,*arg)
  timenow = pbGetTimeNow
  thismon = timenow.mon
  ret = false
  for wd in arg
    ret = true if wd==thismon
  end
  if monVariable>0
    $game_variables[monVariable] = pbGetMonthName(thismon)
    $game_map.need_refresh = true if $game_map
  end
  return ret
end

def pbGetMonthName(month)
  return [_INTL("January"),
          _INTL("February"),
          _INTL("March"),
          _INTL("April"),
          _INTL("May"),
          _INTL("June"),
          _INTL("July"),
          _INTL("August"),
          _INTL("September"),
          _INTL("October"),
          _INTL("November"),
          _INTL("December")][month-1]
end

def pbGetAbbrevMonthName(month)
  return ["",
          _INTL("Jan."),
          _INTL("Feb."),
          _INTL("Mar."),
          _INTL("Apr."),
          _INTL("May"),
          _INTL("Jun."),
          _INTL("Jul."),
          _INTL("Aug."),
          _INTL("Sep."),
          _INTL("Oct."),
          _INTL("Nov."),
          _INTL("Dec.")][month]
end

#===============================================================================
# Seasons
#===============================================================================
def pbGetSeason
  return (pbGetTimeNow.mon-1)%4
end

def pbIsSeason(seasonVariable,*arg)
  thisseason = pbGetSeason
  ret = false
  for wd in arg
    ret = true if wd==thisseason
  end
  if seasonVariable>0
    $game_variables[seasonVariable] = [
       _INTL("Spring"),
       _INTL("Summer"),
       _INTL("Autumn"),
       _INTL("Winter")][thisseason]
    $game_map.need_refresh = true if $game_map
  end
  return ret
end

def pbIsSpring; return pbIsSeason(0,0); end # Jan, May, Sep
def pbIsSummer; return pbIsSeason(0,1); end # Feb, Jun, Oct
def pbIsAutumn; return pbIsSeason(0,2); end # Mar, Jul, Nov
def pbIsFall; return pbIsAutumn; end
def pbIsWinter; return pbIsSeason(0,3); end # Apr, Aug, Dec

def pbGetSeasonName(season)
  return [_INTL("Spring"),
          _INTL("Summer"),
          _INTL("Autumn"),
          _INTL("Winter")][season]
end
