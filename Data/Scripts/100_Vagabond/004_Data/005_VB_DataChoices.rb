module PBChoices
  None               = 0
  Starter            = 1
  PlumIsTrainer      = 3
  ElianaIntroduction = 4
end

def pbSetChoice(choice, value)
  
  choice = getID(PBChoices, choice) if choice.is_a?(Symbol)
  
  if !$game_variables[CHOICES].is_a?(Array)
    $game_variables[CHOICES] = []
  end
  
  $game_variables[CHOICES][choice] = value
  
end

def pbGetChoice(choice)
  
  choice = getID(PBChoices, choice) if choice.is_a?(Symbol)
  
  if !$game_variables[CHOICES].is_a?(Array)
    $game_variables[CHOICES] = []
  end
  
  if $game_variables[CHOICES][choice]
    return $game_variables[CHOICES][choice]
  end
  
  return 0
  
end

def pbHasChoice(choice, value)
  
  choice = getID(PBChoices, choice) if choice.is_a?(Symbol)
  
  if !$game_variables[CHOICES].is_a?(Array)
    $game_variables[CHOICES] = []
  end
  
  if $game_variables[CHOICES][choice]
    return ($game_variables[CHOICES][choice]==value)
  end
  
  return false
  
end















