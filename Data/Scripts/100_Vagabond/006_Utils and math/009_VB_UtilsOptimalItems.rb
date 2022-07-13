def pbGetOptimalRevive(pkmn)
  return 0 if pkmn.hp>0
  items = [
    :REVIVE,
    :LUMBERRYSOUP,
    :MAXREVIVE,
    :REVIVALHERB
  ]
  for i in 0...items.length
    if $PokemonBag.pbQuantity(items[i])>0
      return items[i]
    end
  end
  return 0
end

def pbGetOptimalPotion(pkmn)
  ret=nil
  return ret if pkmn.hp>=pkmn.totalhp
  items = [
    [:FULLRESTORE,999],
    [:MAXPOTION,999],
    [:BAKEDBALM,999],
    [:HYPERPOTION,120],
    [:MOOMOOMILK,100],
    [:MUSHROOMMUFFIN,100],
    [:LEMONADE,70],
    [:SUPERPOTION,60],
    [:SODAPOP,50],
    [:FRESHWATER,30],
    [:POTION,20],
    [:ORANBERRY,10]
  ]
  
  for i in 0...items.length
    if $PokemonBag.pbQuantity(items[i][0])>0
      if !ret || (pkmn.totalhp-pkmn.hp)<=items[i][1]
        ret = items[i][0]
      end
    end
  end
  
  return ret
end

def pbGetOptimalMedicine(pkmn)
  ret=nil
  return ret if pkmn.status==:NONE
  all_items=[
    :FULLHEAL,
    :LAVACOOKIE,
    :OLDGATEAU,
    :CASTELIACONE,
    :LUMIOSEGALETTE,
    :BIGMALASADA,
    :LUMBERRY,
    :LUMBERRYSOUP,
    :FULLRESTORE
  ]
  items={}
  items[:SLEEP]=[
    :AWAKENING,
    :CHESTOBERRY
  ]
  items[:POISON]=[
    :ANTIDOTE,
    :PECHABERRY
  ]
  items[:BURN]=[
    :BURNHEAL,
    :RAWSTBERRY
  ]
  items[:PARALYSIS]=[
    :PARALYZEHEAL,
    :CHERIBERRY
  ]
  items[:FROZEN]=[
    :ICEHEAL,
    :ASPEARBERRY
  ]
  
  for i in 0...items[pkmn.status].length
    if $PokemonBag.pbQuantity(items[pkmn.status][i])>0
      return items[pkmn.status][i]
    end
  end
  
  for i in 0...all_items.length
    if $PokemonBag.pbQuantity(all_items[i])>0
      return all_items[i]
    end
  end
  
  return ret
end

def pbGetOptimalBall(pkmn,wildpkmn)
  ret=0
  return ret if pkmn.hp>=pkmn.totalhp
  items = [
    [:POKEBALL,1],
    [:PREMIERBALL,1],
    [:GREATBALL,1.5],
    [:ULTRABALL,2],
    [:SAFARIBALL,1.5],
    [:LUXURYBALL,1],
    [:FRIENDBALL,1],
    [:LOVEBALL,
      (pkmn.species==wildpkmn.species && pkmn.gender!=wildpkmn.gender) ? 8 : 1],
    [:LEVELBALL,
      pkmn.level<=wildpkmn.level ? 1 :
      pkmn.level<wildpkmn.level*2 ? 2 :
      pkmn.level<wildpkmn.level*4 ? 4 : 8],
    [:MOONBALL,
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
    [:LUREBALL,
      ($PokemonTemp.encounterType==EncounterTypes::FishingRod) ? 5 : 1],
    [:REPEATBALL,
      $Trainer.owned[wildpkmn.species] ? 3.5 : 1],
    [:HEAVYBALL,1],
    [:FASTBALL,1],
    [:TIMERBALL,
      (1+(wildpkmn.turncount*0.3))>4 ? 4 : (1+(wildpkmn.turncount*0.3))],
    [:NESTBALL,
      wildpkmn.level<30 ? (41-wildpkmn.level)/10 : 1],
    [:NETBALL,
      (wildpkmn.pbHasType?(:BUG) || wildpkmn.pbHasType?(:WATER)) ? 3.5 : 1],
    [:HEALBALL,
      ($Trainer.party.length<6 && wildpkmn.hp<wildpkmn.totalhp/2) ? 2.5 : 1],
    [:DIVEBALL,1],
    [:DUSKBALL,
      PBDayNight.isNight? ? 3.5 : 1],
    [:QUICKBALL,
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








