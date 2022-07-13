def pbHasPinkPearlPokemon
  for pkmn in ($Trainer.party + $Trainer.inactive_party)
    if pbPinkPearlPokemon?(pkmn) > 0
      return pkmn
    end
  end
  return false
end

def pbPinkPearlPokemon?(pkmn)
  normal = [
    :PERSIAN,
    :SLOWKING,
    :SPOINK,
    :CLAMPERL
  ]
  shiny = [
    :PERSIAN,
    :SLOWKING
  ]
  rare = [
    :PALKIA,
    :PHIONE,
    :MANAPHY,
    :DIANCIE
  ]
  return 3 if pkmn.shiny? && pkmn.species == :MELOETTA && pkmn.form == 1
  return 0 if pkmn.form != 0
  return 1 if !pkmn.shiny? && normal.include?(pkmn.species)
  return 1 if pkmn.shiny? && shiny.include?(pkmn.species)
  return 2 if rare.include?(pkmn.species)
  return 0
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




