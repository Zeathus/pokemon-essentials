def pbBottleCap(type)
  pbChoosePokemon(1,3)
  if $game_variables[1] < 0
    pbSpeech("James", "none",
    "Come back if you want me to strengthen a Pokémon.")
    return false
  end
  pkmn = $Trainer.party[$game_variables[1]]
  if type == 0 # Silver
    Kernel.pbMessage(_INTL("Which stat do you want me to strengthen?\\ch[1,7,HP,Attack,Defense,Sp. Atk,Sp. Def,Speed,Cancel]"))
    choice = $game_variables[1]
    if choice >= 6
      pbSpeech("James", "none",
      "Come back if you want me to strengthen a Pokémon.")
      return false
    end
    if pkmn.iv[choice] >= 31
      pbSpeech("James", "none",
      "That stat can't grow any stronger on this Pokémon.")
    else
      pkmn.iv[choice]=31
      $PokemonBag.pbDeleteItem(PBItems::BOTTLECAP,1)
      pbSpeech("James", "none",
      _INTL(".WT.WT.WT .WT.WT.WT That should to the trick!WT {1} is stronger now!",pkmn.name))
    end
  elsif type == 1
    Kernel.pbMessage(_INTL("For a Gold Bottlecap, I can strengthen all of {1}'s stats. Do you want that?\\ch[1,2,Yes,No]", pkmn.name))
    choice = $game_variables[1]
    if choice >= 1
      pbSpeech("James", "none",
      "Come back if you want me to strengthen a Pokémon.")
      return false
    else
      if pkmn.iv[0]>=31 && pkmn.iv[1]>=31 && pkmn.iv[2]>=31 &&
        pkmn.iv[3]>=31 && pkmn.iv[4]>=31 && pkmn.iv[5]>=31
        pbSpeech("James", "none",
        "That Pokémon has already reached its full potential, I can't make it any stronger.")
      else
        for i in 0..5
          pkmn.iv[i]=31
        end
        $PokemonBag.pbDeleteItem(PBItems::GOLDBOTTLECAP,1)
        pbSpeech("James", "none",
        _INTL(".WT.WT.WT .WT.WT.WT That should to the trick!WT {1} is stronger now!",pkmn.name))
      end
    end
  end
end

def pbSellRelics
  
  relics = [
    [:BLUESHARD,400],
    [:REDSHARD,400],
    [:YELLOWSHARD,400],
    [:GREENSHARD,400],
    [:DOMEFOSSIL,2000],
    [:HELIXFOSSIL,2000],
    [:OLDAMBER,2000],
    [:ROOTFOSSIL,2000],
    [:CLAWFOSSIL,2000],
    [:ARMORFOSSIL,2000],
    [:SKULLFOSSIL,2000],
    [:COVERFOSSIL,2000],
    [:PLUMEFOSSIL,2000],
    [:SAILFOSSIL,2000],
    [:JAWFOSSIL,2000],
    [:RELICCOPPER,1000],
    [:RELICSILVER,5000],
    [:RELICGOLD,10000],
    [:RELICVASE,50000],
    [:RELICBAND,100000],
    [:RELICSTATUE,200000],
    [:RELICCROWN,300000],
    [:BLUEFLUTE,7000],
    [:YELLOWFLUTE,7500],
    [:REDFLUTE,7500],
    [:WHITEFLUTE,8000],
    [:BLACKFLUTE,8000],
    [:NUGGET,7500],
    [:BIGNUGGET,30000],
    [:RAREBONE,2000]
  ]
  
  items = []
  item = -1
  
  for i in relics
    i[0] = getID(PBItems,i[0]) if i[0].is_a?(Symbol)
    relic = i[0]
    if $PokemonBag.pbQuantity(relic)>0
      items.push(i)
      item = i
    end
  end
  
  if items.length<=0
    
    pbSpeech("Edward","none",
      "You don't have any relics?WT Please come back if you find some.")
    return false
      
  elsif items.length==1
    item = items[0]
    
    if $PokemonBag.pbQuantity(item[0])==1
      pbSpeech("Edward","none",
        _INTL("\\GI see you have found a {1}.", PBItems.getName(item[0])))
      pbSpeech("Edward","none",
        _INTL("\\GWould you like to sell the {1} to me for ${2}?{3}",
          PBItems.getName(item[0]),item[1],"\\ch[1,2,Yes,No]"))
      if $game_variables[1]==0
        $Trainer.money+=item[1]
        $PokemonBag.pbDeleteItem(item[0],1)
        pbSEPlay("purchase.wav")
        pbSpeech("Edward","none",
          "\\GThank you for helping me preserve the relic.")
      else
        pbSpeech("Edward","none",
          "\\GPlease come back if you change your mind.")
      end
    elsif $PokemonBag.pbQuantity(item[0])>1
      pbSpeech("Edward","none",
        _INTL("\\GI see you have found some {1}.", PBItems.getNamePlural(item[0])))
      toSell = pbNumericUpDown(
        _INTL("\\GHow many would you like to sell?\\n(${1} each)",item[1]),
          0,$PokemonBag.pbQuantity(item[0]))
      if toSell<=0
        pbSpeech("Edward","none",
          "\\GPlease come back if you change your mind.")
      elsif toSell>$PokemonBag.pbQuantity(item[0])
        pbSpeech("Edward","none",
          "\\GYou don't have that many to sell.")
      else
        $Trainer.money+=item[1]*toSell
        $PokemonBag.pbDeleteItem(item[0],toSell)
        pbSEPlay("purchase.wav")
        pbSpeech("Edward","none",
          "\\GThank you for helping me preserve these relics.")
      end
    end
    
  else
    
    while items.length > 0
      choices = "\\ch[1,"
      choices += (items.length + 1).to_s
      for i in items
        choices += ","
        choices += PBItems.getName(i[0]) # Item name
        choices += " ($" + i[1].to_s + ")" # Price
      end
      choices += ",Cancel]"
      pbSpeech("Edward","none",
        _INTL("\\GWhat would you like to sell?{1}",choices))
      if $game_variables[1] < items.length
        item = items[$game_variables[1]]
        
        if $PokemonBag.pbQuantity(item[0])==1
          pbSpeech("Edward","none",
            _INTL("\\GWould you like to sell the {1} to me for ${2}?{3}",
              PBItems.getName(item[0]),item[1],"\\ch[1,2,Yes,No]"))
          if $game_variables[1]==0
            $Trainer.money+=item[1]
            $PokemonBag.pbDeleteItem(item[0],1)
            pbSEPlay("purchase.wav")
            pbSpeech("Edward","none",
              "\\GThank you for helping me preserve the relic.")
          else
            pbSpeech("Edward","none",
              "\\GDo tell me if you change your mind.")
          end
        elsif $PokemonBag.pbQuantity(item[0])>1
          toSell = pbNumericUpDown(
            _INTL("\\GHow many would you like to sell? (${1} each)",item[1]),
              0,$PokemonBag.pbQuantity(item[0]))
          if toSell<=0
            pbSpeech("Edward","none",
              "\\GPDo tell me if you change your mind.")
          elsif toSell>$PokemonBag.pbQuantity(item[0])
            pbSpeech("Edward","none",
              "\\GYou don't have that many to sell.")
          else
            $Trainer.money+=item[1]*toSell
            $PokemonBag.pbDeleteItem(item[0],toSell)
            pbSEPlay("purchase.wav")
            pbSpeech("Edward","none",
              "\\GThank you for helping me preserve these relics.")
          end
        end
      else
        pbSpeech("Edward","none",
          "\\GPlease come back if you change your mind.")
        break
      end
      
      items = []
      item = -1
      for i in relics
        i[0] = getID(PBItems,i[0]) if i[0].is_a?(Symbol)
        relic = i[0]
        if $PokemonBag.pbQuantity(relic)>0
          items.push(i)
          item = i
        end
      end
    end
  end
  
  return false
  
end

def pbInnDialog(city="", price=100)
  
  if city=="placeholder" # For city-specific dialog
    
    
    
  else
    
    pbSpeech("Innkeeper","none",
      _INTL("\\GWelcome! Would you like to rest?BREAK(Costs ${1})",price),
      false,["Yes","No"])
    
  end
    
  if $game_variables[1]==0
    
    if $Trainer.money>=price
      if pbGetLanguage()==2
        pbSpeech("Innkeeper","none",
          "\\GWhen would you like to wake up?",
          false,["Morning (06 AM)","Noon (12 PM)","Evening (06 PM)","Night (12 AM)","Cancel"])
      else
        pbSpeech("Innkeeper","none",
          "\\GWhen would you like to wake up?",
          false,["Morning (06:00)","Noon (12:00)","Evening (18:00)","Night (00:00)","Cancel"])
      end
      if $game_variables[1]<4
        $Trainer.money-=price
        pbSEPlay("purchase.wav")
        pbSpeech("Innkeeper","none",
          "\\GEnjoy your stay!")
        for i in $Trainer.party
          i.heal
        end
        case $game_variables[1]
        when 0 # 06:00
          pbGetTimeNow.forwardToTime(6, 0)
        when 1 # 12:00
          pbGetTimeNow.forwardToTime(12, 0)
        when 2 # 18:00
          pbGetTimeNow.forwardToTime(18, 0)
        when 3 # 00:00
          pbGetTimeNow.forwardToTime(0, 0)
        end
        return true
      else
        pbSpeech("Innkeeper","none",
          "\\GPlease come again!")
      end
    else
      pbSpeech("Innkeeper","none",
        "\\GYou don't have enough money.")
    end
    
    return false
  else
    pbSpeech("Innkeeper","none",
      "\\GPlease come again!")
  end
  
  return false
  
end