def pbGetOptimalRevive(pkmn)
  return 0 if pkmn.hp>0
  items = [
    PBItems::REVIVE,
    PBItems::LUMBERRYSOUP,
    PBItems::MAXREVIVE,
    PBItems::REVIVALHERB
  ]
  for i in 0...items.length
    if $PokemonBag.pbQuantity(items[i])>0
      return items[i]
    end
  end
  return 0
end

def pbGetOptimalPotion(pkmn)
  ret=0
  return ret if pkmn.hp>=pkmn.totalhp
  items = [
    [PBItems::FULLRESTORE,999],
    [PBItems::MAXPOTION,999],
    [PBItems::BAKEDBALM,999],
    [PBItems::HYPERPOTION,120],
    [PBItems::MOOMOOMILK,100],
    [PBItems::MUSHROOMMUFFIN,100],
    [PBItems::LEMONADE,70],
    [PBItems::SUPERPOTION,60],
    [PBItems::SODAPOP,50],
    [PBItems::FRESHWATER,30],
    [PBItems::POTION,20],
    [PBItems::ORANBERRY,10]
  ]
  
  for i in 0...items.length
    if $PokemonBag.pbQuantity(items[i][0])>0
      if ret==0 || (pkmn.totalhp-pkmn.hp)<=items[i][1]
        ret = items[i][0]
      end
    end
  end
  
  return ret
end

def pbGetOptimalMedicine(pkmn)
  ret=0
  return ret if pkmn.status==0
  items=[]
  items[0]=[
    PBItems::FULLHEAL,
    PBItems::LAVACOOKIE,
    PBItems::OLDGATEAU,
    PBItems::CASTELIACONE,
    PBItems::LUMIOSEGALETTE,
    PBItems::BIGMALASADA,
    PBItems::LUMBERRY,
    PBItems::LUMBERRYSOUP,
    PBItems::FULLRESTORE
  ]
  items[PBStatuses::SLEEP]=[
    PBItems::AWAKENING,
    PBItems::CHESTOBERRY
  ]
  items[PBStatuses::POISON]=[
    PBItems::ANTIDOTE,
    PBItems::PECHABERRY
  ]
  items[PBStatuses::BURN]=[
    PBItems::BURNHEAL,
    PBItems::RAWSTBERRY
  ]
  items[PBStatuses::PARALYSIS]=[
    PBItems::PARALYZEHEAL,
    PBItems::CHERIBERRY
  ]
  items[PBStatuses::FROZEN]=[
    PBItems::ICEHEAL,
    PBItems::ASPEARBERRY
  ]
  
  for i in 0...items[pkmn.status].length
    if $PokemonBag.pbQuantity(items[pkmn.status][i])>0
      return items[pkmn.status][i]
    end
  end
  
  for i in 0...items[0].length
    if $PokemonBag.pbQuantity(items[0][i])>0
      return items[0][i]
    end
  end
  
  return ret
end

def pbGetOptimalBall(pkmn,wildpkmn)
  ret=0
  return ret if pkmn.hp>=pkmn.totalhp
  items = [
    [PBItems::POKEBALL,1],
    [PBItems::PREMIERBALL,1],
    [PBItems::GREATBALL,1.5],
    [PBItems::ULTRABALL,2],
    [PBItems::SAFARIBALL,1.5],
    [PBItems::LUXURYBALL,1],
    [PBItems::FRIENDBALL,1],
    [PBItems::LOVEBALL,
      (pkmn.species==wildpkmn.species && pkmn.gender!=wildpkmn.gender) ? 8 : 1],
    [PBItems::LEVELBALL,
      pkmn.level<=wildpkmn.level ? 1 :
      pkmn.level<wildpkmn.level*2 ? 2 :
      pkmn.level<wildpkmn.level*4 ? 4 : 8],
    [PBItems::MOONBALL,
      (isConst?(battler.species,PBSpecies,:NIDORANFE) ||
      isConst?(battler.species,PBSpecies,:NIDORINA) ||
      isConst?(battler.species,PBSpecies,:NIDOQUEEN) ||
      isConst?(battler.species,PBSpecies,:NIDORANMA) ||
      isConst?(battler.species,PBSpecies,:NIDORINO) ||
      isConst?(battler.species,PBSpecies,:NIDOKING) ||
      isConst?(battler.species,PBSpecies,:CLEFFA) ||
      isConst?(battler.species,PBSpecies,:CLEFAIRY) ||
      isConst?(battler.species,PBSpecies,:CLEFABLE) ||
      isConst?(battler.species,PBSpecies,:IGGLYBUFF) ||
      isConst?(battler.species,PBSpecies,:JIGGLYPUFF) ||
      isConst?(battler.species,PBSpecies,:WIGGLYTUFF) ||
      isConst?(battler.species,PBSpecies,:SKITTY) ||
      isConst?(battler.species,PBSpecies,:DELCATTY) ||
      isConst?(battler.species,PBSpecies,:MUNNA) ||
      isConst?(battler.species,PBSpecies,:MUSHARNA)) ? 4 : 1],
    [PBItems::LUREBALL,
      ($PokemonTemp.encounterType==EncounterTypes::FishingRod) ? 5 : 1],
    [PBItems::REPEATBALL,
      $Trainer.owned[wildpkmn.species] ? 3.5 : 1],
    [PBItems::HEAVYBALL,1],
    [PBItems::FASTBALL,1],
    [PBItems::TIMERBALL,
      (1+(wildpkmn.turncount*0.3))>4 ? 4 : (1+(wildpkmn.turncount*0.3))],
    [PBItems::NESTBALL,
      wildpkmn.level<30 ? (41-wildpkmn.level)/10 : 1],
    [PBItems::NETBALL,
      (wildpkmn.pbHasType?(:BUG) || wildpkmn.pbHasType?(:WATER)) ? 3.5 : 1],
    [PBItems::HEALBALL,
      ($Trainer.party.length<6 && wildpkmn.hp<wildpkmn.totalhp/2) ? 2.5 : 1],
    [PBItems::DIVEBALL,1],
    [PBItems::DUSKBALL,
      PBDayNight.isNight? ? 3.5 : 1],
    [PBItems::QUICKBALL,
      wildpkmn.turncount<=0 ? 5 : 1]
  ]
  
  rate=0
  for i in 0...items.length
    if $PokemonBag.pbQuantity(items[i][0])>0
      if ret==0 || rate<items[i][1]
        ret = items[i][0]
        rate = items[i][1]
      end
    end
  end
  
  return ret
end








