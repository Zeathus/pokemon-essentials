def pbLootbox(rarity=0)
  # List items from lootboxes by tier
  lootbox_items = [
  # Tier 1
  [:ORANBERRY,:STICKYBARB,:CHARCOAL,:LAGGINGTAIL,
  :CLEVERWING,:MUSCLEWING,:GENIUSWING,:RESISTWING,:SWIFTWING],
  # Tier 2
  [:POKEBALL,:ANTIDOTE,:ICEHEAL,:BURNHEAL,:PARALYZEHEAL,:AWAKENING,:POTION],
  # Tier 3
  [:GREATBALL,:PREMIERBALL,:SITRUSBERRY,:LEPPABERRY,:SUPERPOTION,:HEALBALL],
  # Tier 4
  [:ULTRABALL,:FULLHEAL,:HYPERPOTION,:AIRBALLOON,:MENTALHERB,:REDCARD,:HEARTSCALE],
  # Tier 5
  [:DUSKBALL,:LUXURYBALL,:NESTBALL,:NETBALL,:QUICKBALL,:REPEATBALL,:TIMERBALL,
  :REVIVE,:POWERHERB,:FOCUSSASH],
  # Tier 6
  [:FASTBALL,:FRIENDBALL,:HEAVYBALL,:LEVELBALL,:LOVEBALL,:LUREBALL,
  :MOONBALL,:MAXPOTION,:WHITEHERB],
  # Tier 7
  [:FIRESTONE,:ICESTONE,:LEAFSTONE,:THUNDERSTONE,:WATERSTONE,:FULLRESTORE],
  # Tier 8
  [:MOONSTONE,:DUSKSTONE,:DAWNSTONE,:SHINYSTONE,:NUGGET,:MAXREVIVE],
  # Tier 9
  [:BIGNUGGET,:BOTTLECAP,:ABILITYCAPSULE,:RARECANDY],
  # Tier 10
  [:MASTERBALL,:HABILITYCAPSULE,:COMETSHARD,:GOLDBOTTLECAP]
  ]
  
  # List of lootbox drop rates from tier 1 to 10 (chance is 1 in *NUMBER*)
  lootbox_chances = [1,2,3,5,10,20,30,50,100,500]
  
  # Names of each tier to be displayed
  lootbox_names = ["Trash","Very common","Common","Uncommon",
  "Great","Rare","Very rare","Legendary","Mythical","Miraculous"]
  
  # Maximum item quantity for each tier
  lootbox_count = [3,3,3,3,2,2,2,2,1,1]
  
  tier = -1
  
  for i in 0...lootbox_items.length
    rng = rand(lootbox_chances[i])
    #Kernel.pbMessage(lootbox_names[i] + ": " + rng.to_s)
    if rng<=rarity
      tier = i
      #Kernel.pbMessage("Current tier: " + tier.to_s)
    end
  end
  
  Kernel.pbMessage("The lootbox contained.\\wt[10].\\wt[10].\\wt[10]")
  if tier < 0
    Kernel.pbMessage("Absolutely nothing!")
  else
    item_count = rand(lootbox_count[tier])+1
    if item_count == 1
      Kernel.pbMessage("1 " + lootbox_names[tier].downcase + " item!")
    else
      Kernel.pbMessage(item_count.to_s + " " + lootbox_names[tier].downcase + " items!")
    end
    for i in 0...item_count
      item_id = lootbox_items[tier][rand(lootbox_items[tier].length)]
      item_id = getID(PBItems,item_id)
      Kernel.pbReceiveItem(item_id)
    end
  end
end

















