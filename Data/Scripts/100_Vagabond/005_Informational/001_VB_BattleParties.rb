module PBBattles
  Amethyst1   = 0
  Kira1       = 1
  Eliana1     = 2
  Kira2       = 3
  Fintan1     = 4
end

def pbSetBattleParty(battle)
  
  battle = getID(PBBattles, battle) if battle.is_a?(Symbol)
  
  if !$game_variables[BATTLE_PARTIES].is_a?(Array)
    $game_variables[BATTLE_PARTIES] = []
  end
  
  $game_variables[BATTLE_PARTIES][battle] = []
  
  for p in $Trainer.party
    pokemon = [p.species, p.name, p.gender, p.level, p.item]
    moves = []
    for m in p.moves
      moves.push(m.id)
    end
    pokemon.push(moves)
    $game_variables[BATTLE_PARTIES][battle].push(pokemon)
  end
  
end

def pbGetBattleParty(battle)
  
  battle = getID(PBBattles, battle) if battle.is_a?(Symbol)
  
  if !$game_variables[BATTLE_PARTIES].is_a?(Array)
    $game_variables[BATTLE_PARTIES] = []
  end
  
  if $game_variables[BATTLE_PARTIES][battle]
    return $game_variables[BATTLE_PARTIES][battle]
  end
  
  return false
  
end

def pbHasBattleParty(battle)
  
  battle = getID(PBBattles, battle) if battle.is_a?(Symbol)
  
  if !$game_variables[BATTLE_PARTIES].is_a?(Array)
    $game_variables[BATTLE_PARTIES] = []
  end
  
  if $game_variables[BATTLE_PARTIES][battle]
    if $game_variables[BATTLE_PARTIES][battle].is_a?(Array)
      return true
    end
  end
  
  return false
  
end