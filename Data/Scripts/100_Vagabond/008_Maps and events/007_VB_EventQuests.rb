def pbGenerateGravestone
  timenow = pbGetTimeNow
  month = pbGetAbbrevMonthName(timenow.mon)
  day = timenow.day
  day = pbGetDayMonth(day)
  year = timenow.year
  month_to = timenow.mon - 5
  day_to = timenow.day - 13
  year_to = timenow.year - 73
  day_to = day_to + 30 if day_to < 1
  month_to = month_to + 12 if month_to < 1
  month_to = pbGetAbbrevMonthName(month_to)
  day_to = pbGetDayMonth(day_to)
  $game_variables[GRAVESTONE_DATE] = _INTL("{1} {2} {3} - {4} {5} {6}", day_to, month_to, year_to, day, month, year)
end