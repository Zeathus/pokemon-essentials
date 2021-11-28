################################################################################
# This section was created solely for you to put various bits of code that
# modify various wild Pokémon and trainers immediately prior to battling them.
# Be sure that any code you use here ONLY applies to the Pokémon/trainers you
# want it to apply to!
################################################################################

# Make all wild Pokémon shiny while a certain Switch is ON (see Settings).
Events.onWildPokemonCreate += proc { |_sender, e|
  pkmn = e[0]
  if $game_switches[Settings::SHINY_WILD_POKEMON_SWITCH]
    pkmn.shiny = true
  end
}

# Used in the random dungeon map.  Makes the levels of all wild Pokémon in that
# map depend on the levels of Pokémon in the player's party.
# This is a simple method, and can/should be modified to account for evolutions
# and other such details.  Of course, you don't HAVE to use this code.
#Events.onWildPokemonCreate += proc { |_sender, e|
#  pokemon = e[0]
#  if $game_map.map_id == 51
#    new_level = pbBalancedLevel($Trainer.party) - 4 + rand(5)   # For variety
#    new_level = new_level.clamp(1, GameData::GrowthRate.max_level)
#    pokemon.level = new_level
#    pokemon.calc_stats
#    pokemon.reset_moves
#  end
#}

# Blood Moon
#Events.onWildPokemonCreate+=proc {|sender,e|
#  pokemon=e[0]
#  if $game_screen.weather_type==PBFieldWeather::BloodMoon
#    # Hidden Ability
#    if rand(2)==0
#      pokemon.abilityflag=2
#    end
#    
#    # IVs
#    ivs=[0,1,2,3,4,5].shuffle
#    for i in 0...3
#      pokemon.iv[ivs[i]]=31
#      pokemon.oiv[ivs[i]]=31
#    end
#    
#    # Shiny Change
#    if rand(500)==0
#      pokemon.shinyflag=true
#    end
#  end
#}

Events.onWildPokemonCreate += proc { |_sender, e|
<<<<<<< HEAD
  pokemon = e[0]
  if $game_variables[WILD_MODIFIER] && $game_variables[WILD_MODIFIER] != 0
    mod = $game_variables[WILD_MODIFIER]
    if mod.moves # Custom Moves
      pokemon.moves = []
      for m in mod.moves
        pokemon.moves.push(Pokemon::Move.new(m))
      end
    end
    pokemon.iv            = pbArrayToIVs(mod.iv)  if mod.iv
    pokemon.ev            = pbArrayToIVs(mod.ev)  if mod.ev
    pokemon.form          = mod.form              if mod.form
    pokemon.name          = mod.name              if mod.name
    pokemon.ability_index = mod.ability           if mod.ability
    pokemon.gender        = mod.gender            if mod.gender
    pokemon.item          = mod.item              if mod.item
    pokemon.nature        = mod.nature            if mod.nature
    pokemon.shiny         = mod.shiny             if mod.shiny
    pokemon.status        = mod.status            if mod.status
    pokemon.calc_stats
    pokemon.hp            = pokemon.totalhp
    pokemon.hp            = mod.hp                if mod.hp
    pokemon.hp           *= mod.hpmult            if mod.hpmult
    $game_variables[WILD_MODIFIER] = 0
=======
  pkmn = e[0]
  if $game_map.map_id == 51
    new_level = pbBalancedLevel($player.party) - 4 + rand(5)   # For variety
    new_level = new_level.clamp(1, GameData::GrowthRate.max_level)
    pkmn.level = new_level
    pkmn.calc_stats
    pkmn.reset_moves
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
  end
}

# This is the basis of a trainer modifier. It works both for trainers loaded
# when you battle them, and for partner trainers when they are registered.
# Note that you can only modify a partner trainer's Pokémon, and not the trainer
# themselves nor their items this way, as those are generated from scratch
# before each battle.
#Events.onTrainerPartyLoad += proc { |_sender, trainer|
#  if trainer   # An NPCTrainer object containing party/items/lose text, etc.
#    YOUR CODE HERE
#  end
#}
