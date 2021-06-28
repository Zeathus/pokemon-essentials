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
  poke = PokeBattle_Pokemon.new(species,level,$Trainer)
  newspecies = pbCheckEvolution(poke)
  if newspecies>0
    encounter = newspecies
  end
  return encounter
end

def pbScaleTrainer(trainer, trainerparty, modifier)
  
  difficulty = $PokemonSystem.difficulty
  
  low_trainers = [
    PBTrainers::YOUNGSTER, PBTrainers::LASS,
    PBTrainers::BUGCATCHER,
    PBTrainers::SCHOOLBOY, PBTrainers::SCHOOLGIRL,
    PBTrainers::PRESCHOOLER_M, PBTrainers::PRESCHOOLER_F,
    PBTrainers::JANITOR,
    PBTrainers::TWINS]
  high_trainers = [
    PBTrainers::ACETRAINER_M, PBTrainers::ACETRAINER_F,
    PBTrainers::VETERAN_M, PBTrainers::VETERAN_F,
    PBTrainers::GENTLEMAN, PBTrainers::LADY,
    PBTrainers::PKMNRANGER_M, PBTrainers::PKMNRANGER_F,
    PBTrainers::GAMBLER, PBTrainers::ROUGHNECK,
    PBTrainers::DAO_Eliana, PBTrainers::DAO_Fintan]
    
  # Calculate level_base
  level_base = pbPreferredLevel
  level_base = level_base - 1 if low_trainers.include?(trainer[0].trainertype)
  level_base = level_base + 1 if high_trainers.include?(trainer[0].trainertype)
  level_base -= 1 if trainer[2].length > 4
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
    if i[0]==trainer[0].trainertype &&
       i[1]==trainer[0].name &&
       i[2]==trainerparty && i[3]
      level_base = i[3]
      overwrite_base = true
    end
  end
  if !overwrite_base
    $game_variables[LASTBATTLEDTRAINERS].push(
      [trainer[0].trainertype,trainer[0].name,trainerparty,level_base])
    if $game_variables[LASTBATTLEDTRAINERS].length > 30
      $game_variables[LASTBATTLEDTRAINERS].shift
    end
  end

  # Get the highest level
  highestlevel = 1
  for pkmn in trainer[2]
    highestlevel = pkmn.level if pkmn.level > highestlevel
  end
  
  $game_variables[BATTLE_ORIGINAL_LVL] = highestlevel
  
  # Change pokemon levels
  for pkmn in trainer[2]
    next if trainer[0].name=="Klaus" && pkmn.species==PBSpecies::VULPIX
    other_level = pkmn.level
    level_dif = other_level - highestlevel
    if level_base > other_level
      new_level = level_base + level_dif
      if level_dif <= -10
        new_level = level_base - 1
      end
      new_level = 100 if new_level > 100
      new_level = 1 if new_level < 1
      pkmn.level = new_level
      original_species = pkmn.species
      pkmn.species = pbGetEvolvedEncounter(pkmn.species, new_level - 2) if trainer[0].name != "Joey"
      pkmn.species = pbCustomEvolutionLevel(pkmn.species, new_level - 2)
      if level_base >= 16
        pkmn.species = pbGetEvolvedEncounter(pkmn.species, new_level - 2) if trainer[0].name != "Joey"
        pkmn.species = pbCustomEvolutionLevel(pkmn.species, new_level - 2)
      end
      pkmn.name = PBSpecies.getName(pkmn.species) if original_species != pkmn.species
      pkmn.resetMoves if new_level - other_level > 20 and other_level < 30
      pkmn.calcStats
    end
  end
  
  # Difficulty dependant changes
  if difficulty == 0
    # EASY
    for pkmn in trainer[2]
      pkmn.level -= 1
      pkmn.item = 0
      pkmn.natureflag = PBNatures::SERIOUS
      pkmn.iv = [0,0,0,0,0,0]
      pkmn.oiv = [0,0,0,0,0,0] if pkmn.oiv
      pkmn.calcStats
    end
  elsif difficulty == 2
    # HARD
    for pkmn in trainer[2]
      pkmn.iv = [31,31,31,31,31,31]
      pkmn.oiv = [31,31,31,31,31,31] if pkmn.oiv
      pkmn.calcStats
    end
  end
  
  return trainer

end

def pbCustomEvolutionLevel(species, level)
  list = [
    [PBSpecies::AIPOM,PBSpecies::AMBIPOM,32],
    [PBSpecies::AMAURA,PBSpecies::AURORUS,39],
    [PBSpecies::BUDEW,PBSpecies::ROSELIA,18],
    [PBSpecies::BOLDORE,PBSpecies::GIGALITH,40],
    [PBSpecies::BONSLY,PBSpecies::SUDOWOODO,15],
    [PBSpecies::CHANSEY,PBSpecies::BLISSEY,32],
    [PBSpecies::CHINGLING,PBSpecies::CHIMECHO,26],
    [PBSpecies::COTTONEE,PBSpecies::WHIMSICOTT,28],
    [PBSpecies::CLEFAIRY,PBSpecies::CLEFABLE,32],
    [PBSpecies::DUSCLOPS,PBSpecies::DUSKNOIR,45],
    [PBSpecies::DOUBLADE,PBSpecies::AEGISLASH,42],
    [PBSpecies::EELEKTRIK,PBSpecies::EELEKTROSS,46],
    [PBSpecies::LICKITUNG,PBSpecies::LICKILICKY,33],
    [PBSpecies::ELECTABUZZ,PBSpecies::ELECTIVIRE,42],
    [PBSpecies::EXEGGCUTE,PBSpecies::EXEGGUTOR,32],
    [PBSpecies::FEEBAS,PBSpecies::MILOTIC,20],
    [PBSpecies::FLOETTE,PBSpecies::FLORGES,32],
    [PBSpecies::FOMANTIS,PBSpecies::LURANTIS,34],
    [PBSpecies::GLIGAR,PBSpecies::GLISCOR,37],
    [PBSpecies::GRAVELER,PBSpecies::GOLEM,36],
    [PBSpecies::GROWLITHE,PBSpecies::ARCANINE,27],
    [PBSpecies::GLOOM,PBSpecies::VILEPLUME,34],
    [PBSpecies::GURDURR,PBSpecies::CONKELDURR,36],
    [PBSpecies::HAPPINY,PBSpecies::CHANSEY,16],
    [PBSpecies::HAUNTER,PBSpecies::GENGAR,32],
    [PBSpecies::HELIOPTILE,PBSpecies::HELIOLISK,30],
    [PBSpecies::JIGGLYPUFF,PBSpecies::WIGGLYTUFF,32],
    [PBSpecies::KADABRA,PBSpecies::ALAKAZAM,38],
    [PBSpecies::KARRABLAST,PBSpecies::ESCAVALIER,32],
    [PBSpecies::LAMPENT,PBSpecies::CHANDELURE,47],
    [PBSpecies::LOMBRE,PBSpecies::LUDICOLO,32],
    [PBSpecies::MACHOKE,PBSpecies::MACHAMP,36],
    [PBSpecies::MAGMAR,PBSpecies::MAGMORTAR,42],
    [PBSpecies::MINCCINO,PBSpecies::CINCCINO,26],
    [PBSpecies::MIMEJR,PBSpecies::MRMIME,22],
    [PBSpecies::MISDREAVUS,PBSpecies::MISMAGIUS,28],
    [PBSpecies::MUNNA,PBSpecies::MUSHARNA,27],
    [PBSpecies::MURKROW,PBSpecies::HONCHKROW,34],
    [PBSpecies::NUZLEAF,PBSpecies::SHIFTRY,32],
    [PBSpecies::NIDORINA,PBSpecies::NIDOQUEEN,36],
    [PBSpecies::NIDORINO,PBSpecies::NIDOKING,36],
    [PBSpecies::ONIX,PBSpecies::STEELIX,30],
    [PBSpecies::PANSAGE,PBSpecies::SIMISAGE,24],
    [PBSpecies::PANSEAR,PBSpecies::SIMISEAR,24],
    [PBSpecies::PANPOUR,PBSpecies::SIMIPOUR,24],
    [PBSpecies::PETILIL,PBSpecies::LILLIGANT,28],
    [PBSpecies::PICHU,PBSpecies::PIKACHU,14],
    [PBSpecies::PIKACHU,PBSpecies::RAICHU,25],
    [PBSpecies::PILOSWINE,PBSpecies::MAMOSWINE,44],
    [PBSpecies::PHANTUMP,PBSpecies::TREVENANT,32],
    [PBSpecies::PUMPKABOO,PBSpecies::GOURGEIST,32],
    [PBSpecies::POLIWHIRL,PBSpecies::POLIWRATH,34],
    [PBSpecies::PORYGON,PBSpecies::PORYGON2,16],
    [PBSpecies::PORYGON2,PBSpecies::PORYGONZ,32],
    [PBSpecies::RHYDON,PBSpecies::RHYPERIOR,50],
    [PBSpecies::RIOLU,PBSpecies::LUCARIO,28],
    [PBSpecies::ROSELIA,PBSpecies::ROSERADE,36],
    [PBSpecies::SANDSHREW,PBSpecies::SANDSLASH,22],
    [PBSpecies::SCYTHER,PBSpecies::SCIZOR,36],
    [PBSpecies::SEADRA,PBSpecies::KINGDRA,36],
    [PBSpecies::SHELLDER,PBSpecies::CLOYSTER,32],
    [PBSpecies::SHELMET,PBSpecies::ACCELGOR,32],
    [PBSpecies::SKITTY,PBSpecies::DELCATTY,22],
    [PBSpecies::SUNKERN,PBSpecies::SUNFLORA,20],
    [PBSpecies::SNEASEL,PBSpecies::WEAVILE,35],
    [PBSpecies::STARYU,PBSpecies::STARMIE,32],
    [PBSpecies::STEENEE,PBSpecies::TSAREENA,34],
    [PBSpecies::SPRITZEE,PBSpecies::AROMATISSE,30],
    [PBSpecies::SWADLOON,PBSpecies::LEAVANNY,32],
    [PBSpecies::SWIRLIX,PBSpecies::SLURPUFF,30],
    [PBSpecies::TANGELA,PBSpecies::TANGROWTH,38],
    [PBSpecies::TOGETIC,PBSpecies::TOGEKISS,42],
    [PBSpecies::TYRUNT,PBSpecies::TYRANTRUM,39],
    [PBSpecies::VULPIX,PBSpecies::NINETALES,27],
    [PBSpecies::WEEPINBELL,PBSpecies::VICTREEBEL,34],
    [PBSpecies::YANMA,PBSpecies::YANMEGA,30],
    [PBSpecies::YUNGOOS,PBSpecies::GUMSHOOS,20]
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
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  