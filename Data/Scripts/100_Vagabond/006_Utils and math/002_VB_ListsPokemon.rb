def pbStarter(index=nil)
  pokes=[
    # Grass
    PBSpecies::ODDISH,
    PBSpecies::SKIDDO,
    PBSpecies::SEEDOT,
    # Fire
    PBSpecies::GROWLITHE,
    PBSpecies::MAGBY,
    PBSpecies::HOUNDOUR,
    # Water
    PBSpecies::AZURILL,
    PBSpecies::BUIZEL,
    PBSpecies::CORPHISH,
    # Normal
    PBSpecies::BUNEARY,
    PBSpecies::STARLY,
    PBSpecies::MEOWTH,
    # Electric
    PBSpecies::MAREEP,
    PBSpecies::ELEKID,
    PBSpecies::SHINX,
    # Other
    PBSpecies::FLABEBE,
    PBSpecies::MEDITITE,
    PBSpecies::INKAY]
    # Don't Know
    # Random
    
  if index && index < pokes.length
    return pokes[index]
  else
    return pokes.shuffle[0]
  end
end

def pbAddStarter(species)
  
  pokemon = PokeBattle_Pokemon.new(species,10,$Trainer)
  $game_variables[STARTER_ID]=pokemon.personalID
  pokemon.abilityflag=0
  pokemon.natureflag=PBNatures::BASHFUL
  case species
  when PBSpecies::SKIDDO
    pokemon.iv = [31,31,16,5,10,16]
  when PBSpecies::NUMEL
    pokemon.iv = [31,16,16,5,31,10]
  when PBSpecies::KRABBY
    pokemon.iv = [31,31,16,5,10,16]
  end
  
  pokemon.happiness=128
  
  pokemon.calcStats
  
  pbAddPokemon(pokemon)
  $Trainer.seen[species]=true
  $Trainer.owned[species]=true
  
end

def pbAddStarterOld(species)
  
  pokemon = PokeBattle_Pokemon.new(species,5,$Trainer)
  $game_variables[STARTER_ID]=pokemon.personalID
  case species
  when PBSpecies::GROWLITHE, PBSpecies::MAGBY, PBSpecies::STARLY,
       PBSpecies::MAREEP, PBSpecies::ELEKID, PBSpecies::MEDITITE,
       PBSpecies::INKAY, PBSpecies::EEVEE
    pokemon.abilityflag=0
  when PBSpecies::ODDISH, PBSpecies::HOUNDOUR, PBSpecies::AZURILL,
       PBSpecies::MEOWTH, PBSpecies::SHINX, PBSpecies::BUIZEL,
       PBSpecies::FLABEBE
    pokemon.abilityflag=1
  when PBSpecies::SKIDDO, PBSpecies::SEEDOT, PBSpecies::CORPHISH,
       PBSpecies::BUNEARY
    pokemon.abilityflag=2
  end
  
  pokemon.happiness=128
  pbAddPokemon(pokemon)
  $Trainer.seen[species]=true
  $Trainer.owned[species]=true
  
end





