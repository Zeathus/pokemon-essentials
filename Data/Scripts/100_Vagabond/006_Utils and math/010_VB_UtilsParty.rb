def pbPartyTypeCount(type)
  ret = 0
  for pkmn in $Trainer.party
    if pkmn.type1 == type || pkmn.type2 == type
      ret += 1
    end
  end
  return ret
end

def pbPartyAbilityCount(ability)
  ret = 0
  for pkmn in $Trainer.party
    if pkmn.ability == ability
      ret += 1
    end
  end
  return ret
end

def pbPartyAbilityPokemon(ability)
  for pkmn in $Trainer.party
    if pkmn.ability == ability
      return pkmn
    end
  end
  return nil
end

def pbPartyMoveCount(move)
  ret = 0
  for pkmn in $Trainer.party
    for m in pkmn.moves
      if m.id == move
        ret += 1
      end
    end
  end
  return ret
end

def pbPartyMovePokemon(move)
  for pkmn in $Trainer.party
    for m in pkmn.moves
      if m.id == move
        return pkmn
      end
    end
  end
  return nil
end

def pbRemoveSpecies(species)
  for i in 0...$Trainer.party.length
    if $Trainer.party[i].species==species
      $Trainer.party-=[$Trainer.party[i]]
      return true
    end
  end
  return false
end

def pbHasInParty?(species)
  ret=false
  for pkmn in $Trainer.party
    ret=true if pkmn.species==species
  end
  return ret
end

def pbNumberInParty(species)
  ret=0
  for pkmn in $Trainer.party
    ret+=1 if pkmn.species==species
  end
  return ret
end

def pbHasStarter(species)
  for poke in $Trainer.party
    if poke.personalID==$game_variables[STARTER_ID]
      return true
    end
  end
  
  return false
end

def pbHasJewelPokemon
  pokemon = [
    :SPOINK,
    :DRAGONAIR,
    :CLAMPERL,
    :PALKIA
  ]
  
  for i in pokemon
    if pbHasInParty?(i)
      return i
    end
  end
  
  return -1
end








