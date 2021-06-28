def pbGenerateForecast
  areas = [
    [[[6.5,12],[4.5,11.5]],[:BrecciaPassage,:BrecciaCity,:BrecciaUndergrowth,:DeepBreccia,:BrecciaOutlook]],
    [[[8,14],[7.5,16]],[:LazuliRiver,:LazuliDistrict,:LapisDistrict]],
    [[[8,11],[8,9]],[:MicaTown,:FeldsparTown,:MtPegmaHillside,:MtPegmaPeak]],
    [[[6,8],[4,9]],[:QuartzPassing,:QuartzFalls,:QuartzGrove]],
    [[[16,15],[18.5,15]],[:WestAndesIsle,:EastAndesIsle]],
    [[[25,12.5]],[:CanjonValley]]
  ]
  
  desert_areas = [
    PBMaps::CanjonValley
  ]
  
  weathers = [
    PBFieldWeather::None,
    PBFieldWeather::None,
    PBFieldWeather::Rain,
    PBFieldWeather::Sun,
    PBFieldWeather::Winds
  ]
  
  desert_weathers = [
    PBFieldWeather::None,
    PBFieldWeather::None,
    PBFieldWeather::None,
    PBFieldWeather::Sun,
    PBFieldWeather::Sun,
    PBFieldWeather::Sandstorm,
    PBFieldWeather::Sandstorm,
    PBFieldWeather::Sandstorm,
    PBFieldWeather::Winds
  ]
  
  weathers.push(PBFieldWeather::Sun) if pbGetTimeNow.wday=="Sunday"
  weathers.push(PBFieldWeather::Rain) if pbGetTimeNow.wday=="Wednesday"
  weathers.push(PBFieldWeather::Winds) if pbGetTimeNow.wday=="Friday"
  
  forecast=[]
  forecast[0]=[] # Array for map ids and weather
  forecast[1]=[] # Array for map icons for forecast
  
  for area in areas
    weather = weathers[rand(weathers.length)]
    if desert_areas.include?(getID(PBMaps,area[1][0]))
      weather = desert_weathers[rand(desert_weathers.length)]
    end
    for map in area[1]
      map = getID(PBMaps,map) if map.is_a?(Symbol)
      forecast[0][map]=weather
    end
    for coords in area[0]
      forecast[1].push([[coords],weather])
    end
  end
  
  bloodmoon = rand(areas.length*7)
  bloodmoon = rand(areas.length) if pbGetTimeNow.wday=="Friday" && pbGetTimeNow.day % 13 == 0
  if bloodmoon<areas.length && pbGetTimeNow.day>2
    Kernel.pbMessage("Blood Moon spawned") if debug_extra?
    area=areas[bloodmoon]
    for map in area[1]
      map = getID(PBMaps,map) if map.is_a?(Symbol)
      forecast[0][map]=PBFieldWeather::BloodMoon
    end
    for coords in area[0]
      for i in 0...forecast[1].length
        if forecast[1][i][0][0][0]==coords[0] && forecast[1][i][0][0][1]==coords[1]
          forecast[1][i][1]=PBFieldWeather::BloodMoon
        end
      end
    end
  end
  
  $game_variables[DAILY_FORECAST]=forecast
  
  pbUpdateWeather
end

def pbUpdateWeather
  if pbGetMetadata($game_map.map_id,MetadataOutdoor)
    if $game_switches[WEATHER_RAIN]
      if $game_screen.weather_type != PBFieldWeather::Rain
        $game_screen.weather(PBFieldWeather::Rain,9,200)
        return
      end
    elsif $game_switches[WEATHER_SUN]
      if $game_screen.weather_type != PBFieldWeather::Sun
        $game_screen.weather(PBFieldWeather::Sun,1,200)
        return
      end
    elsif $game_switches[WEATHER_SNOW]
      if $game_screen.weather_type != PBFieldWeather::Snow
        $game_screen.weather(PBFieldWeather::Snow,9,200)
        return
      end
    elsif $game_switches[WEATHER_STORM]
      if $game_screen.weather_type != PBFieldWeather::Storm
        $game_screen.weather(PBFieldWeather::Storm,9,200)
        return
      end
    end
  end
  forecast = pbGetForecast
  if forecast[$game_map.map_id] && pbGetMetadata($game_map.map_id,MetadataOutdoor)
    if $game_screen.weather_type != forecast[$game_map.map_id]
      weather=forecast[$game_map.map_id]
      if weather==PBFieldWeather::None
        $game_screen.weather(0,0,0)
      elsif weather==PBFieldWeather::Sun
        if pbGetTimeNow.hour<=17 && pbGetTimeNow.hour>=5
          $game_screen.weather(weather,5,200)
        else
          $game_screen.weather(0,0,0)
        end
      elsif weather==PBFieldWeather::BloodMoon
        if pbGetTimeNow.hour>=18
          $game_screen.weather(weather,5,200)
        else
          $game_screen.weather(0,0,0)
        end
      else
        $game_screen.weather(weather,5,200)
      end
    end
  else
    $game_screen.weather(0,0,0)
  end
  pbUpdateVFX
end

def pbGetForecast(index=0)
  if $game_variables[DAILY_FORECAST].is_a?(Array) && !$game_variables[DAILY_FORECAST][index].is_a?(Array)
    $game_variables[DAILY_FORECAST]=0
  end
  pbGenerateForecast if $game_variables[DAILY_FORECAST]==0
  return $game_variables[DAILY_FORECAST][index]
end











