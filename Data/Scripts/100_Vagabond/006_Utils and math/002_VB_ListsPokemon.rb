def pbStarter(index=nil)
  pokes=[
    # Grass
    :ODDISH,
    :SKIDDO,
    :SEEDOT,
    # Fire
    :GROWLITHE,
    :MAGBY,
    :HOUNDOUR,
    # Water
    :AZURILL,
    :BUIZEL,
    :CORPHISH,
    # Normal
    :BUNEARY,
    :STARLY,
    :MEOWTH,
    # Electric
    :MAREEP,
    :ELEKID,
    :SHINX,
    # Other
    :FLABEBE,
    :MEDITITE,
    :INKAY]
    # Don't Know
    # Random
    
  if index && index < pokes.length
    return pokes[index]
  else
    return pokes.shuffle[0]
  end
end

def pbAddStarter(species)
  
  pokemon = Pokemon.new(species,10,$Trainer)
  $game_variables[STARTER_ID] = pokemon.personalID
  pokemon.ability_index = 0
  pokemon.nature = :BASHFUL
  case species
  when :SKIDDO
    pokemon.iv = pbArrayToIVs([31,31,16,5,10,16])
  when :NUMEL
    pokemon.iv = pbArrayToIVs([31,16,16,5,31,10])
  when :KRABBY
    pokemon.iv = pbArrayToIVs([31,31,16,5,10,16])
  end
  
  pokemon.happiness = 128
  
  pokemon.calc_stats
  
  pbAddPokemon(pokemon)
  $Trainer.pokedex.set_seen(species)
  $Trainer.pokedex.set_owned(species)
  
end




