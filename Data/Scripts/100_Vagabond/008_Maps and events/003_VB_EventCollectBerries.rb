def pbHarvestBerry(item, quantity)
  item = getID(PBItems,item) if item.is_a?(Symbol)
  Kernel.pbMessage(_INTL("It's a bush blooming of {1}. Do you want to pick them?{2}",
    PBItems.getNamePlural(item),"\\ch[1,2,Yes,No]"))
  quantity += 1 if $game_screen.weather_type==PBFieldWeather::Sun
  if pbGet(1)==0
    realqnt = quantity
    if (pbPartyAbilityCount(:HARVEST)+
        pbPartyAbilityCount(:CHEEKPOUCH)+
        pbPartyAbilityCount(:SYMBIOSIS)+
        pbPartyMoveCount(:NATURALGIFT)+
        pbPartyMoveCount(:POLLENPUFF)+
        pbPartyMoveCount(:ROTOTILLER)+
        pbPartyMoveCount(:WATERSPORT))>0
      realqnt = (realqnt * 1.5).floor
    end
    title = "ITEM COLLECTED"
    text = ""
    text2 = nil
    itemname=(realqnt>1) ? PBItems.getNamePlural(item) : PBItems.getName(item)
    if realqnt>1
      text += realqnt.to_s
      text += "x "
      text += itemname
    else
      text += itemname
    end
    if realqnt > quantity
      if pbPartyAbilityPokemon(:HARVEST)
        pkmn = pbPartyAbilityPokemon(:HARVEST)
        text2 = pkmn.name + "'s " + "Harvest: +" + (realqnt-quantity).to_s + "x"
      elsif pbPartyAbilityPokemon(:CHEEKPOUCH)
        pkmn = pbPartyAbilityPokemon(:CHEEKPOUCH)
        text2 = pkmn.name + "'s " + "Cheek Pouch: +" + (realqnt-quantity).to_s + "x"
      elsif pbPartyAbilityPokemon(:SYMBIOSIS)
        pkmn = pbPartyAbilityPokemon(:SYMBIOSIS)
        text2 = pkmn.name + "'s " + "Symbiosis: +" + (realqnt-quantity).to_s + "x"
      elsif pbPartyMovePokemon(:NATURALGIFT)
        pkmn = pbPartyMovePokemon(:NATURALGIFT)
        text2 = pkmn.name + "'s " + "Natural Gift: +" + (realqnt-quantity).to_s + "x" 
      elsif pbPartyMovePokemon(:POLLENPUFF)
        pkmn = pbPartyMovePokemon(:POLLENPUFF)
        text2 = pkmn.name + "'s " + "Pollen Puff: +" + (realqnt-quantity).to_s + "x" 
      elsif pbPartyMovePokemon(:ROTOTILLER)
        pkmn = pbPartyMovePokemon(:ROTOTILLER)
        text2 = pkmn.name + "'s " + "Rototiller: +" + (realqnt-quantity).to_s + "x" 
      elsif pbPartyMovePokemon(:WATERSPORT)
        pkmn = pbPartyMovePokemon(:WATERSPORT)
        text2 = pkmn.name + "'s " + "Water Sport: +" + (realqnt-quantity).to_s + "x" 
      end
    end
    $PokemonBag.pbStoreItem(item,realqnt)
    pbSEPlay("ItemGet",100)
    text = text.upcase if text
    text2 = text2.upcase if text2
    pbCollectNotification(text, text2, title)
    
    loot = []
    loot.push([32, PBItems::TINYMUSHROOM])
    loot.push([128, PBItems::BIGMUSHROOM])
    loot.push([256, PBItems::BALMMUSHROOM])
    loot.push([1365, PBItems::REVIVALHERB])
    loot.push([96, PBItems::MENTALHERB])
    loot.push([128, PBItems::POWERHERB])
    loot.push([128, PBItems::WHITEHERB])
    
    # Ability Dependant drops
    loot.push([32, PBItems::HONEY]) if pbPartyAbilityCount(:HONEYGATHER)>0
    loot.push([pbPartyMoveCount(:ROTOTILLER) ? 48 : 128, PBItems::ENERGYROOT])
    loot.push([pbPartyMoveCount(:ROTOTILLER) ? 64 : 256, PBItems::BIGROOT])
    loot.push([pbPartyMoveCount(:WATERSPORT) ? 64 : 256, PBItems::ABSORBBULB])
    
    # Nectars (4x the chance if the player has an Oricorio)
    case item
    when PBItems::APICOTBERRY, PBItems::BELUEBERRY, PBItems::BLUKBERRY,
         PBItems::CHESTOBERRY, PBItems::CORNNBERRY, PBItems::GANLONBERRY,
         PBItems::PAMTREBERRY, PBItems::PAYAPABERRY, PBItems::RAWSTBERRY,
         PBItems::WIKIBERRY
      loot.push([pbHasInParty?(PBSpecies::ORICORIO) ? 32 : 128, PBItems::PURPLENECTAR])
    when PBItems::COLBURBERRY, PBItems::KASIBBERRY, PBItems::KEEBERRY,
         PBItems::LANSATBERRY, PBItems::MAGOBERRY, PBItems::MAGOSTBERRY,
         PBItems::NANABBERRY, PBItems::PECHABERRY, PBItems::PERSIMBERRY,
         PBItems::PETAYABERRY, PBItems::QUALOTBERRY, PBItems::SPELONBERRY
      loot.push([pbHasInParty?(PBSpecies::ORICORIO) ? 32 : 128, PBItems::PINKNECTAR])
    when PBItems::CHERIBERRY, PBItems::CHOPLEBERRY, PBItems::CUSTAPBERRY,
         PBItems::HABANBERRY, PBItems::LEPPABERRY, PBItems::OCCABERRY,
         PBItems::POMEGBERRY, PBItems::RAZZBERRY, PBItems::ROSELIBERRY,
         PBItems::TAMATOBERRY
      loot.push([pbHasInParty?(PBSpecies::ORICORIO) ? 32 : 128, PBItems::REDNECTAR])
    when PBItems::ASPEARBERRY, PBItems::CHARTIBERRY, PBItems::GREPABERRY,
         PBItems::HONDEWBERRY, PBItems::JABOCABERRY, PBItems::NOMELBERRY,
         PBItems::PINAPBERRY, PBItems::SHUCABERRY, PBItems::SITRUSBERRY,
         PBItems::WACANBERRY
      loot.push([pbHasInParty?(PBSpecies::ORICORIO) ? 32 : 128, PBItems::YELLOWNECTAR])
    end
    
    # Seeds
    case item
    when PBItems::APICOTBERRY, PBItems::COBABERRY, PBItems::CORNNBERRY,
         PBItems::KELPSYBERRY, PBItems::ROSELIBERRY, PBItems::ROWAPBERRY,
         PBItems::YACHEBERRY, PBItems::WIKIBERRY
      loot.push([64, PBItems::MISTYSEED])
    when PBItems::COLBURBERRY, PBItems::KASIBBERRY, PBItems::KEEBERRY,
         PBItems::LANSATBERRY, PBItems::MAGOBERRY, PBItems::MAGOSTBERRY,
         PBItems::NANABBERRY, PBItems::PECHABERRY, PBItems::PERSIMBERRY,
         PBItems::PETAYABERRY, PBItems::QUALOTBERRY, PBItems::SPELONBERRY
      loot.push([64, PBItems::PSYCHICSEED])
    when PBItems::AGUAVBERRY, PBItems::BABIRIBERRY, PBItems::DURINBERRY,
         PBItems::HONDEWBERRY, PBItems::KEBIABERRY, PBItems::LUMBERRY,
         PBItems::MICLEBERRY, PBItems::RABUTABERRY, PBItems::RINDOBERRY,
         PBItems::SALACBERRY, PBItems::STARFBERRY, PBItems::WEPEARBERRY,
         PBItems::TANGABERRY
      loot.push([64, PBItems::GRASSYSEED])
    when PBItems::ASPEARBERRY, PBItems::CHARTIBERRY, PBItems::GREPABERRY,
         PBItems::JABOCABERRY, PBItems::NOMELBERRY, PBItems::PINAPBERRY,
         PBItems::SHUCABERRY, PBItems::SITRUSBERRY, PBItems::WACANBERRY
      loot.push([64, PBItems::ELECTRICSEED])
    end
    
    for bonus in loot
      rng = rand(bonus[0])
      if rng < realqnt
        $PokemonBag.pbStoreItem(bonus[1], 1)
        pbCollectNotification(PBItems.getName(bonus[1]).upcase, "BONUS ITEM!")
      end
    end
    
    return true
  end
  return false
end