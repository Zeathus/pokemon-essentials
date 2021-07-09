def pbCustomAIModifier(move,attacker,opponent,skill,score,field)
  
  if $game_variables[BATTLE_SIM_AI]!=0
    return pbBattleSimAI(move,attacker,opponent,score,field)
  end
  
  code = pbGetOwner(attacker.index).skillCode
  
  case code
  when "raphael" # Fire-type Gym leader
    case attacker.species
    when :ROTOM
      
    when :TORKOAL
      
    when :RHYPERIOR
      
    when :KOMMOO
      
    end
  end
  
  return score
end

def pbCustomAISwitchModifier(battlers,index,alwaysSwitch)
  
  attacker = battlers[index]
  opponent=@battlers[index].pbOppositeOpposing
  opponent=opponent.pbPartner if opponent.isFainted?
  
  code = pbGetOwner(attacker.index).skillCode
  
  case code
  when "raphael" # Fire-type Gym leader
    case attacker.species
    when :ROTOM
      
    when :TORKOAL
      
    when :RHYPERIOR
      
    when :KOMMOO
      
    end
  end
  
  return false
end

def pbCustomAISwitchPriority(list,party,attacker,opponent)
  
  code = pbGetOwner(attacker.index).skillCode
  ret = [list[0]]
  
  for i in list
    pokemon = party[i]
    
    case code
    when "raphael" # Fire-type Gym leader
      
    end
  end
  
  return ret
end

def pbBattleSimAI(move,attacker,opponent,score,field)
  move_order = $game_variables[BATTLE_SIM_AI][0][attacker.pokemonIndex]
  move_status = $game_variables[BATTLE_SIM_AI][1][attacker.pokemonIndex]
  movedata = PBMoveData.new(move.id)
  if move.id==move_order[move_status]
    if movedata.category != 2 || (movedata.category == 2 && attacker.effects[PBEffects::Taunt]>=0)
      score+=1000
      $game_variables[BATTLE_SIM_AI][2][attacker.pokemonIndex]=true
    end
  end
  lastmove = 0
  for i in attacker.moves
    lastmove = i.id if i.id > 0
  end
  if move.id == lastmove
    if $game_variables[BATTLE_SIM_AI][2][attacker.pokemonIndex]
      $game_variables[BATTLE_SIM_AI][2][attacker.pokemonIndex]=false
      if move_status < move_order.length - 1
        $game_variables[BATTLE_SIM_AI][1][attacker.pokemonIndex]+=1
      end
    end
  end
  return score
end

def pbCustomAIShouldWithdraw(battlers,index,alwaysSwitch)
  move_order = $game_variables[BATTLE_SIM_AI][0][battlers[index].pokemonIndex]
  move_status = $game_variables[BATTLE_SIM_AI][1][battlers[index].pokemonIndex]
  if move_order[move_status]==:BATONPASS
    return true
  end
  return false
end











