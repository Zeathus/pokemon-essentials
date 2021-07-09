def pbCheckFormEvolutionItem(pokemon)
  ret = -1
  ret = :ICESTONE if pokemon.species==:VULPIX && pokemon.form==1
  ret = :ICESTONE if pokemon.species==:SANDSHREW && pokemon.form==1
  return ret
end

# Use for getting pokemon information and stats only
# Invalid result may cause problems if trying to modify pokemon
def pbGetFirstSpecies(species)
  species=getID(PBSpecies,species) if species.is_a?(Symbol)
  for i in 0...$Trainer.party.length
    if $Trainer.party[i].species==species
      return $Trainer.party[i]
    end
  end
  return PokeBattle_Pokemon.new(species,1,$Trainer)
end

def pbGetNatureModifier(nature, stat)
  stat = getID(PBStats,stat) if stat.is_a?(Symbol)
  if (nature/5).floor == stat && (nature%5).floor == stat
    return 0
  elsif (nature/5).floor == stat
    return 1
  elsif (nature%5).floor == stat
    return -1
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