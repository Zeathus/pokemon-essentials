def pbGetDayMonth(day)
  make_st = [1, 11, 21, 31]
  make_nd = [2, 12, 22]
  make_rd = [3, 13, 23]
  ret = day.to_s + "th"
  ret = day.to_s + "st" if make_st.include?(day)
  ret = day.to_s + "nd" if make_nd.include?(day)
  ret = day.to_s + "rd" if make_rd.include?(day)
  return ret
end

def pbHasTimePassed(start, time)
  # Time is in minuted
  timeNow = pbGetTimeNow.to_i_min
  if start + time <= timeNow
    return true
  end
  return false
end