def pbPartyTypeCount(type)
  type = getID(PBTypes,type) if type.is_a?(Symbol)
  ret = 0
  for pkmn in $Trainer.party
    if pkmn.type1 == type || pkmn.type2 == type
      ret += 1
    end
  end
  return ret
end

def pbPartyAbilityCount(ability)
  ability = getID(PBAbilities,ability) if ability.is_a?(Symbol)
  ret = 0
  for pkmn in $Trainer.party
    if pkmn.ability == ability
      ret += 1
    end
  end
  return ret
end

def pbPartyAbilityPokemon(ability)
  ability = getID(PBAbilities,ability) if ability.is_a?(Symbol)
  for pkmn in $Trainer.party
    if pkmn.ability == ability
      return pkmn
    end
  end
  return nil
end

def pbPartyMoveCount(move)
  move = getID(PBMoves,move) if move.is_a?(Symbol)
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
  move = getID(PBMoves,move) if move.is_a?(Symbol)
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
  species=getID(PBSpecies,species) if species.is_a?(Symbol)
  for i in 0...$Trainer.party.length
    if $Trainer.party[i].species==species
      $Trainer.party-=[$Trainer.party[i]]
      return true
    end
  end
  return false
end

def pbHasInParty?(species)
  species=getID(PBSpecies,species) if species.is_a?(Symbol)
  ret=false
  for pkmn in $Trainer.party
    ret=true if pkmn.species==species
  end
  return ret
end

def pbNumberInParty(species)
  species=getID(PBSpecies,species) if species.is_a?(Symbol)
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








