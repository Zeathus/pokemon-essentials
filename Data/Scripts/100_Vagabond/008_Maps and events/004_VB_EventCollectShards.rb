def pbMineShards(item, quantity)
  item = getID(PBItems,item) if item.is_a?(Symbol)
  Kernel.pbMessage(_INTL("{1} are protruding from the rock. Do you want to mine them?{2}",
    PBItems.getNamePlural(item),"\\ch[1,2,Yes,No]"))
  if pbGet(1)==0
    realqnt = quantity
    if (pbPartyMoveCount(:METALCLAW)+
        pbPartyMoveCount(:HORNDRILL)+
        pbPartyMoveCount(:DRILLRUN)+
        pbPartyMoveCount(:CRUSHCLAW)+
        pbPartyMoveCount(:DIG)+
        pbPartyMoveCount(:ROCKSMASH))>0
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
      if pbPartyMovePokemon(:METALCLAW)
        pkmn = pbPartyMovePokemon(:METALCLAW)
        text2 = pkmn.name + "'s " + "Metal Claw: +" + (realqnt-quantity).to_s + "x"
      elsif pbPartyMovePokemon(:HORNDRILL)
        pkmn = pbPartyMovePokemon(:HORNDRILL)
        text2 = pkmn.name + "'s " + "Horn Drill: +" + (realqnt-quantity).to_s + "x"
      elsif pbPartyMovePokemon(:DRILLRUN)
        pkmn = pbPartyMovePokemon(:DRILLRUN)
        text2 = pkmn.name + "'s " + "Drill Run: +" + (realqnt-quantity).to_s + "x" 
      elsif pbPartyMovePokemon(:CRUSHCLAW)
        pkmn = pbPartyMovePokemon(:CRUSHCLAW)
        text2 = pkmn.name + "'s " + "Crush Claw: +" + (realqnt-quantity).to_s + "x" 
      elsif pbPartyMovePokemon(:DIG)
        pkmn = pbPartyMovePokemon(:DIG)
        text2 = pkmn.name + "'s " + "Dig: +" + (realqnt-quantity).to_s + "x" 
      elsif pbPartyMovePokemon(:ROCKSMASH)
        pkmn = pbPartyMovePokemon(:ROCKSMASH)
        text2 = pkmn.name + "'s " + "Rock Smash: +" + (realqnt-quantity).to_s + "x" 
      end
    end
    $PokemonBag.pbStoreItem(item,realqnt)
    pbSEPlay("ItemGet",100)
    text = text.upcase if text
    text2 = text2.upcase if text2
    pbCollectNotification(text, text2, title)
    
    loot = []
    loot.push([500, PBItems::OVALSTONE])
    loot.push([1365, PBItems::NUGGET])
    loot.push([4096, PBItems::BIGNUGGET])
    loot.push([20, PBItems::HEARTSCALE])
    loot.push([100, PBItems::EVERSTONE])
    loot.push([80, PBItems::HARDSTONE])
    loot.push([150, PBItems::IRONBALL])
    loot.push([500, PBItems::KINGSROCK])
    loot.push([150, PBItems::METALPOWDER])
    loot.push([150, PBItems::QUICKPOWDER])
    loot.push([500, PBItems::PROTECTOR])
    if item == PBItems::GREENSHARD
      loot.push([200, PBItems::LEAFSTONE])
      loot.push([300, PBItems::VELVETYROCK])
    elsif item == PBItems::REDSHARD
      loot.push([200, PBItems::FIRESTONE])
      loot.push([300, PBItems::HEATROCK])
    elsif item == PBItems::YELLOWSHARD
      loot.push([200, PBItems::THUNDERSTONE])
      loot.push([300, PBItems::SMOOTHROCK])
    elsif item == PBItems::BLUESHARD
      loot.push([200, PBItems::WATERSTONE])
      loot.push([300, PBItems::DAMPROCK])
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