def pbSetCharacterLocation(char, location)
  char = getID(PBChar,char) if char.is_a?(Symbol)
  location = getID(PBMaps,location) if location.is_a?(Symbol)
  $game_variables[CHARACTER_LOCATIONS] = [] if !$game_variables[CHARACTER_LOCATIONS].is_a?(Array)
  $game_variables[CHARACTER_LOCATIONS][char] = location
end

def pbCharacterLocation(char)
  char = getID(PBChar,char) if char.is_a?(Symbol)
  location = getID(PBMaps,location) if location.is_a?(Symbol)
  $game_variables[CHARACTER_LOCATIONS] = [] if !$game_variables[CHARACTER_LOCATIONS].is_a?(Array)
  if $game_variables[CHARACTER_LOCATIONS][char]
    return $game_variables[CHARACTER_LOCATIONS][char]
  end
  return -1
end