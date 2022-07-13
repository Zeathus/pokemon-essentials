def pbCheckFormEvolutionItem(pokemon)
  ret = -1
  ret = :ICESTONE if pokemon.species==:VULPIX && pokemon.form==1
  ret = :ICESTONE if pokemon.species==:SANDSHREW && pokemon.form==1
  return ret
end

# Use for getting pokemon information and stats only
# Invalid result may cause problems if trying to modify pokemon
def pbGetFirstSpecies(species)
  for i in 0...$Trainer.inactive_party.length
    if $Trainer.inactive_party[i].species==species
      return $Trainer.inactive_party[i]
    end
  end
  for i in 0...$Trainer.party.length
    if $Trainer.party[i].species==species
      return $Trainer.party[i]
    end
  end
  return PokeBattle_Pokemon.new(species,1,$Trainer)
end

def pbGetNatureModifier(nature, stat)
  changes = GameData::Nature.get(nature).stat_changes
  for i in changes
    if i[0] == stat
      return i[1] / 10
    end
  end
  return 0
end

def pbBST(species)
  dexdata=pbOpenDexData
  pbDexDataOffset(dexdata,species,10)
  stats=[
    dexdata.fgetb, # HP
    dexdata.fgetb, # Attack
    dexdata.fgetb, # Defense
    dexdata.fgetb, # Speed
    dexdata.fgetb, # Special Attack
    dexdata.fgetb  # Special Defense
    ]
  dexdata.close
  bst = 0
  for i in 0...stats.length
    bst+=stats[i]
  end
  return bst
end

def pbArrayToIVs(arr)
  return {
    :HP => arr[0],
    :ATTACK => arr[1],
    :DEFENSE => arr[2],
    :SPEED => arr[3],
    :SPECIAL_ATTACK => arr[4],
    :SPECIAL_DEFENSE => arr[5]
  }
end