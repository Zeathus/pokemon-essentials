def pbScaleWildEncounter(encounter)
  species = encounter[0]
  level = encounter[1]
  level_old = level
  level_player = pbPreferredLevel
  
  # Update level if preferred level is at least 10 above
  if level <= level_player - 10
    level_dif = level_player - level
    level += level_dif / 2
    # Never increase by more than 10
    level = level_old + 10 if level > level_old + 10
  end
  
  if level >= 10 && rand(2) == 0
    species = pbGetEvolvedEncounter(species, level)
  end
  
  # Blood Moon changes
  blood_moon = ($game_screen.weather_type==PBFieldWeather::BloodMoon)
  if blood_moon
    # 50% Level increase
    level *= 1.5 if blood_moon
    # Evolve as far as can go
    for i in 0...3
      species = pbGetEvolvedEncounter(species, level)
      species = pbCustomEvolutionLevel(species, level)
    end
  end
  
  level = 100 if level > 100
  level = level.floor
  encounter[0] = species
  encounter[1] = level
  
end

def pbGetEvolvedEncounter(species, level)
  encounter = species
  poke = Pokemon.new(species,level,$Trainer)
  newspecies = poke.check_evolution_on_level_up
  if newspecies
    encounter = newspecies
  end
  return encounter
end

def pbScaleTrainer(trainer, modifier)
  
  difficulty = $PokemonSystem.difficulty
  
  low_trainers = [
    :YOUNGSTER, :LASS,
    :BUGCATCHER,
    :SCHOOLBOY, :SCHOOLGIRL,
    :PRESCHOOLER_M, :PRESCHOOLER_F,
    :JANITOR,
    :TWINS]
  high_trainers = [
    :ACETRAINER_M, :ACETRAINER_F,
    :VETERAN_M, :VETERAN_F,
    :GENTLEMAN, :LADY,
    :PKMNRANGER_M, :PKMNRANGER_F,
    :GAMBLER, :ROUGHNECK,
    :DAO_Eliana, :DAO_Fintan]
    
  # Calculate level_base
  level_base = pbPreferredLevel
  level_base = level_base - 1 if low_trainers.include?(trainer.trainer_type)
  level_base = level_base + 1 if high_trainers.include?(trainer.trainer_type)
  level_base -= 1 if trainer.party.length > 4
  #party_dif = $Trainer.party.length - trainer[2].length
  #party_dif = 0 if party_dif > 0
  #party_dif = -3 if party_dif < -3
  #level_base += party_dif
  if modifier.is_a?(Numeric)
    level_base += modifier
  end
  
  # Check if the trainer has been battled recently
  if !$game_variables[LASTBATTLEDTRAINERS].is_a?(Array)
    $game_variables[LASTBATTLEDTRAINERS]=[]
  end
  overwrite_base = false
  for i in $game_variables[LASTBATTLEDTRAINERS]
    if i[0]==trainer.trainer_type &&
       i[1]==trainer.name &&
       i[2]
      level_base = i[2]
      overwrite_base = true
    end
  end
  if !overwrite_base
    $game_variables[LASTBATTLEDTRAINERS].push(
      [trainer.trainer_type,trainer.name,level_base])
    if $game_variables[LASTBATTLEDTRAINERS].length > 30
      $game_variables[LASTBATTLEDTRAINERS].shift
    end
  end

  # Get the highest level
  highestlevel = 1
  for pkmn in trainer.party
    highestlevel = pkmn.level if pkmn.level > highestlevel
  end
  
  $game_variables[BATTLE_ORIGINAL_LVL] = highestlevel
  
  # Change pokemon levels
  for pkmn in trainer.party
    next if trainer.name=="Klaus" && pkmn.species==:VULPIX
    other_level = pkmn.level
    level_dif = other_level - highestlevel
    if level_base > other_level
      new_level = level_base + level_dif
      if level_dif <= -10
        new_level = level_base - 1
      end
      new_level = 100 if new_level > 100
      new_level = 1 if new_level < 1
      new_level = new_level.floor
      pkmn.level = new_level
      original_species = pkmn.species
      pkmn.species = pbGetEvolvedEncounter(pkmn.species, new_level - 2) if trainer.name != "Joey"
      pkmn.species = pbCustomEvolutionLevel(pkmn.species, new_level - 2)
      if level_base >= 16
        pkmn.species = pbGetEvolvedEncounter(pkmn.species, new_level - 2) if trainer.name != "Joey"
        pkmn.species = pbCustomEvolutionLevel(pkmn.species, new_level - 2)
      end
      pkmn.name = GameData::Species.get(pkmn.species).name if original_species != pkmn.species
      pkmn.resetMoves if new_level - other_level > 20 and other_level < 30
      pkmn.calc_stats
    end
  end
  
  # Difficulty dependant changes
  if difficulty == 0
    # EASY
    for pkmn in trainer.party
      pkmn.level -= 1
      pkmn.item = 0
      pkmn.natureflag = PBNatures::SERIOUS
      pkmn.iv = pbArrayToIVs([0,0,0,0,0,0])
      pkmn.calc_stats
    end
  elsif difficulty == 2
    # HARD
    for pkmn in trainer.party
      pkmn.iv = pbArrayToIVs([31,31,31,31,31,31])
      pkmn.calc_stats
    end
  end
  
  return trainer

end

def pbCustomEvolutionLevel(species, level)
  list = [
    [:AIPOM,:AMBIPOM,32],
    [:AMAURA,:AURORUS,39],
    [:BUDEW,:ROSELIA,18],
    [:BOLDORE,:GIGALITH,40],
    [:BONSLY,:SUDOWOODO,15],
    [:CHANSEY,:BLISSEY,32],
    [:CHINGLING,:CHIMECHO,26],
    [:COTTONEE,:WHIMSICOTT,28],
    [:CLEFAIRY,:CLEFABLE,32],
    [:DUSCLOPS,:DUSKNOIR,45],
    [:DOUBLADE,:AEGISLASH,42],
    [:EELEKTRIK,:EELEKTROSS,46],
    [:LICKITUNG,:LICKILICKY,33],
    [:ELECTABUZZ,:ELECTIVIRE,42],
    [:EXEGGCUTE,:EXEGGUTOR,32],
    [:FEEBAS,:MILOTIC,20],
    [:FLOETTE,:FLORGES,32],
    [:FOMANTIS,:LURANTIS,34],
    [:GLIGAR,:GLISCOR,37],
    [:GRAVELER,:GOLEM,36],
    [:GROWLITHE,:ARCANINE,27],
    [:GLOOM,:VILEPLUME,34],
    [:GURDURR,:CONKELDURR,36],
    [:HAPPINY,:CHANSEY,16],
    [:HAUNTER,:GENGAR,32],
    [:HELIOPTILE,:HELIOLISK,30],
    [:JIGGLYPUFF,:WIGGLYTUFF,32],
    [:KADABRA,:ALAKAZAM,38],
    [:KARRABLAST,:ESCAVALIER,32],
    [:LAMPENT,:CHANDELURE,47],
    [:LOMBRE,:LUDICOLO,32],
    [:MACHOKE,:MACHAMP,36],
    [:MAGMAR,:MAGMORTAR,42],
    [:MINCCINO,:CINCCINO,26],
    [:MIMEJR,:MRMIME,22],
    [:MISDREAVUS,:MISMAGIUS,28],
    [:MUNNA,:MUSHARNA,27],
    [:MURKROW,:HONCHKROW,34],
    [:NUZLEAF,:SHIFTRY,32],
    [:NIDORINA,:NIDOQUEEN,36],
    [:NIDORINO,:NIDOKING,36],
    [:ONIX,:STEELIX,30],
    [:PANSAGE,:SIMISAGE,24],
    [:PANSEAR,:SIMISEAR,24],
    [:PANPOUR,:SIMIPOUR,24],
    [:PETILIL,:LILLIGANT,28],
    [:PICHU,:PIKACHU,14],
    [:PIKACHU,:RAICHU,25],
    [:PILOSWINE,:MAMOSWINE,44],
    [:PHANTUMP,:TREVENANT,32],
    [:PUMPKABOO,:GOURGEIST,32],
    [:POLIWHIRL,:POLIWRATH,34],
    [:PORYGON,:PORYGON2,16],
    [:PORYGON2,:PORYGONZ,32],
    [:RHYDON,:RHYPERIOR,50],
    [:RIOLU,:LUCARIO,28],
    [:ROSELIA,:ROSERADE,36],
    [:SANDSHREW,:SANDSLASH,22],
    [:SCYTHER,:SCIZOR,36],
    [:SEADRA,:KINGDRA,36],
    [:SHELLDER,:CLOYSTER,32],
    [:SHELMET,:ACCELGOR,32],
    [:SKITTY,:DELCATTY,22],
    [:SUNKERN,:SUNFLORA,20],
    [:SNEASEL,:WEAVILE,35],
    [:STARYU,:STARMIE,32],
    [:STEENEE,:TSAREENA,34],
    [:SPRITZEE,:AROMATISSE,30],
    [:SWADLOON,:LEAVANNY,32],
    [:SWIRLIX,:SLURPUFF,30],
    [:TANGELA,:TANGROWTH,38],
    [:TOGETIC,:TOGEKISS,42],
    [:TYRUNT,:TYRANTRUM,39],
    [:VULPIX,:NINETALES,27],
    [:WEEPINBELL,:VICTREEBEL,34],
    [:YANMA,:YANMEGA,30],
    [:YUNGOOS,:GUMSHOOS,20]
  ]
  for i in 0..2
    for i in 0...list.length
      if list[i][0] == species
        if level>=list[i][2]
          species = list[i][1]
        end
      end
    end
  end
  return species
end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  