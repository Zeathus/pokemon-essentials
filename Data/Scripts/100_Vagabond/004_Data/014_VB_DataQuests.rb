module PBQuests
  NoviceBattler         = 0
  IntermediateBattler   = 1
  VeteranBattler        = 2
  NoviceCollector       = 3
  IntermediateCollector = 4
  VeteranCollector      = 5
  Sickzagoon            = 6
  TheFieryRobin         = 7
  AnEyeForAnOwl         = 8
  ShellsForBells        = 9
  JumpingTheHoops       = 10
  DaughtersGift         = 11
  LittlePokemonBigCity  = 12
  LumberlessCarpenter   = 13
  NeedForInspiration    = 14
  UnitedCraftmanship    = 15
  FishingPractice       = 16
  FishingTrainee        = 17
  FishingAce            = 18
  FishingGuru           = 19
  SorrowfulZorua        = 20
  
end

def pbAddQuest(quest_data)
  if !$game_variables[QUEST_ARRAY][quest_data.id]
    $game_variables[QUEST_ARRAY][quest_data.id]=quest_data
  else
    quest=$game_variables[QUEST_ARRAY][quest_data.id]
    quest.name     = quest_data.name
    quest.desc     = quest_data.desc
    quest.steps    = quest_data.steps
    quest.complete = quest_data.complete
    quest.location = quest_data.location
    quest.money    = quest_data.money
    quest.exp      = quest_data.exp
    quest.item     = quest_data.item
    quest.hidden   = quest_data.hidden
  end
end

def pbInitQuests
  if !$game_variables[QUEST_ARRAY].is_a?(Array)
    $game_variables[QUEST_ARRAY] = []
  end
  
  pbAddQuest(QuestData.new(:NoviceBattler, "Novice Battler",
    1000, 100, nil, "Anywhere",
    "Defeat a total number of 10 trainers in battle. (Statistics can be viewed on the Trainer Card)", [
    "Defeat 10 trainers."],
    "You have defeated a total of 10 trainers!"))
  pbAddQuest(QuestData.new(:IntermediateBattler, "Intermediate Battler",
    3000, 150, nil, "Anywhere",
    "", [
    "Defeat a total number of 50 trainers in battle."],
    "You have defeated a total of 50 trainers!"))
  pbAddQuest(QuestData.new(:VeteranBattler, "Veteran Battler",
    5000, 200, nil, "Anywhere",
    "", [
    "Defeat a total number of 150 trainers in battle."],
    "You have defeated a total of 150 trainers!"))
  pbAddQuest(QuestData.new(:NoviceCollector, "Novice Collector",
    1000, 100, nil, "Anywhere",
    "Catch a total number of 10 wild Pokémon. (Statistics can be viewed on the Trainer Card)", [
    "Catch 10 wild pokemon."],
    "You have caught a total of 10 wild Pokémon!"))
  pbAddQuest(QuestData.new(:IntermediateCollector, "Intermediate Collector",
    3000, 150, nil, "Anywhere",
    "", [
    "Catch a total number of 25 wild Pokémon."],
    "You have caught a total of 25 wild Pokémon!"))
  pbAddQuest(QuestData.new(:VeteranCollector, "Veteran Collector",
    5000, 200, nil, "Anywhere",
    "", [
    "Catch a total number of 50 wild Pokémon."],
    "You have caught a total of 50 wild Pokémon!"))
  pbAddQuest(QuestData.new(:Sickzagoon, "Sickzagoon",
    0, 100, nil, "Near the Crosswoods",
    "", [
    "Tell the doctor in the Crosswoods about the sick Zigzagoon."],
    "The doctor fixed up the sick Zigzagoon. Hooray!"))
  pbAddQuest(QuestData.new(:TheFieryRobin, "The Fiery Robin",
    0, 125, nil, "Breccia City",
    "", [
    "Catch a Fletchling on Route 4 for the Bird Keeper in Breccia City."],
    "You caught a Fletchling for the Bird Keeper, and now they enjoy each other's company."))
  pbAddQuest(QuestData.new(:AnEyeForAnOwl, "An Eye for an Owl",
    0, 75, nil, "Breccia City",
    "", [
    "Register a Grass-type Owl Pokémon as seen in the Pokédex and show it to the girl in Breccia City."],
    "The girl was so happy to see Rowlet! She even gave you some Sweet Hearts."))
  pbAddQuest(QuestData.new(:ShellsForBells, "Shells for Bells",
    0, 75, nil, "Lapis Town",
    "", [
    "Pick up 5 Shoal Shells from the beach in Lapis Town and give them to the old man by the beach."],
    "Thanks to your help, the old man managed to make a Shell Bell for his wife."))
  pbAddQuest(QuestData.new(:JumpingTheHoops, "Jumping the Hoops",
    0, 200, nil, "???",
    "", [
    "Something went wrong during teleportation with an unknown cause. The teleporter will keep in touch.",
    "The dimension you ended up in while teleporting seemed rather odd. Maybe it can happen again.",
    "Yet again you ended up in a strange dimension. There seems to be even more to it though."],
    "NOT YET FINISHED."))
  pbAddQuest(QuestData.new(:DaughtersGift, "Daughter's Gift",
    0, 100, nil, "G.P.O. HQ",
    "", [
    "Purchase a Poké Doll from the Chert City Department Store and give it to the employee's daughter to the west in Lazuli City."],
    "With your help, the father working at the G.P.O. could give his daughter a birthday present."))
  pbAddQuest(QuestData.new(:LittlePokemonBigCity, "Little Pokémon, Big City",
    0, 150, nil, "G.P.O. HQ",
    "", [
    "Ask the people in the G.P.O. lounge if they saw where the Alolan Vulpix went.",
    "Find the Alolan Vulpix in Chert City and bring it back to the employee, Klaus."],
    "Vulpix returned back to Klaus after running away. You found it standing in the park."))
  pbAddQuest(QuestData.new(:LumberlessCarpenter, "Lumberless Carpenter",
    0, 150, :RAREBONE, "Breccia City",
    "Help Pent get his carpenter business up and running again by getting him a Timburr.", [
    "Catch a Timburr for Pent. You can find it east of the Crosswoods."],
    "Pent has got his shop up and running again! He can now craft you various items."))
  pbAddQuest(QuestData.new(:NeedForInspiration, "Need for Inspiration",
    0, 150, nil, "Lazuli City",
    "", [
    "The Lazuli City jeweler, Channelle, is in need of some inspiration. Show her a Pokémon with a pretty pearl."],
    "Channelle was happy to see the Pokémon you brought her. She even named her jewelry after it!"))
  pbAddQuest(QuestData.new(:UnitedCraftmanship, "United Craftmanship",
    0, 200, nil, "Shale Town",
    "", [
    "Have Pent, Allon and Channelle craft the three elements and bring them to Jack."],
    "Thanks to your efforts, Pent, Allon and Channelle could work together to create the Trinity Orb!"))
  pbAddQuest(QuestData.new(:FishingPractice, "Fishing Practice",
    0, 100, nil, "Shale Town",
    "", [
    "Show Ivan that you can catch a Magikarp, and he will give you a Fishing Rod."],
    "You reeled in your first fish and recieved a Fishing Rod from Ivan!"))
  pbAddQuest(QuestData.new(:FishingTrainee, "Fishing Trainee",
    0, 150, nil, "Shale Town",
    "", [
    "Manage to reel in a Horsea, then tell Ivan about it. (It doesn't have to be caught)"],
    "You reeled in a Horsea and impressed Ivan."))
  pbAddQuest(QuestData.new(:FishingAce, "Fishing Ace",
    0, 200, nil, "Shale Town",
    "", [
    "Manage to reel in a Wailord, then tell Ivan about it. Ivan will teach you a new technique if you accomplish this."],
    "You have mastered the art of Fishing after reeling in a giant Wailord."))
  pbAddQuest(QuestData.new(:FishingGuru, "Fishing Guru",
    0, 300, nil, "Shale Town",
    "", [
    "The only challenge that can prove your worth more is to reel in the Mythical Phione, rumored to reside somewhere in the region."],
    "You reeled in a Phione! You have become the best of the best. No fisherman can match your skill."))
  pbAddQuest(QuestData.new(:SorrowfulZorua, "Sorrowful Zorua",
    0, 150, nil, "Tuff Trail",
    "", [
    "A couple living at Tuff Trail has lost their Zorua. Someone might know where it went.",
    "It seems the woman's husband died half a year ago. Go visit her again at Tuff Trail.",
    "The woman's husband has gone for a walk. Find and talk to him.",
    "Zorua is disguising itself as the husband. Should you tell the woman about it?"],
    "You helped the woman at Tuff Trail come to terms with the loss of her husband."))
  
  pbQuest(:TheFieryRobin).mapguide[0]=[4,11]
  pbQuest(:AnEyeForAnOwl).mapguide[0]=[4,12]
  pbQuest(:ShellsForBells).mapguide[0]=[25,15]
  pbQuest(:DaughtersGift).mapguide[0]=[7,16]
  pbQuest(:LittlePokemonBigCity).mapguide[0]=[16,5]
  pbQuest(:LittlePokemonBigCity).mapguide[1]=[16,5]
  pbQuest(:LumberlessCarpenter).mapguide[0]=[10,12]
  pbQuest(:LumberlessCarpenter).mapguide[1]=[10,12]
  pbQuest(:LumberlessCarpenter).mapguide[2]=[5,11]
  
  pbQuest(:NoviceBattler).lock = [[:QuestStatus,:Sickzagoon,2]]
  pbQuest(:IntermediateBattler).lock = [[:QuestStatus,:NoviceBattler,2]]
  pbQuest(:VeteranBattler).lock = [[:QuestStatus,:IntermediateBattler,2]]
  pbQuest(:NoviceCollector).lock = [[:QuestStatus,:Sickzagoon,2]]
  pbQuest(:IntermediateCollector).lock = [[:QuestStatus,:NoviceCollector,2]]
  pbQuest(:VeteranCollector).lock = [[:QuestStatus,:IntermediateCollector,2]]
  pbQuest(:TheFieryRobin).lock = [[:MapVisited, PBMaps::BrecciaCity]]
  pbQuest(:AnEyeForAnOwl).lock = [[:MapVisited, PBMaps::BrecciaCity]]
  pbQuest(:LumberlessCarpenter).lock = [[:MapVisited, PBMaps::BrecciaCity]]
  #pbQuest(:ShellsForBells).lock = [[:MapVisited, PBMaps::LapisTown]]
  pbQuest(:DaughtersGift).lock = [[:MapVisited, PBMaps::GPO_HQ]]
  pbQuest(:LittlePokemonBigCity).lock = [[:MapVisited, PBMaps::GPO_HQ]]
  pbQuest(:NeedForInspiration).lock = [[:MapVisited, PBMaps::LapisDistrict]]
  pbQuest(:UnitedCraftmanship).lock = [[:QuestStatus,:LumberlessCarpenter,2],[:QuestStatus,:FeldsparTownGym,2,0],[:QuestStatus,:NeedForInspiration,2]]
  #pbQuest(:FishingPractice).lock = [[:GlobalSwitch,HAS_QUEST_LIST]]
  pbQuest(:SorrowfulZorua).lock = [[:MapVisited,PBMaps::BrecciaTrail],[:HasMember,:Amethyst]]
  
  pbQuest(:NoviceBattler).unlock=1
  pbQuest(:IntermediateBattler).unlock=1
  pbQuest(:VeteranBattler).unlock=1
  pbQuest(:NoviceCollector).unlock=1
  pbQuest(:IntermediateCollector).unlock=1
  pbQuest(:VeteranCollector).unlock=1
  
  pbQuest(:SorrowfulZorua).hidden = 1
  
  #pbQuest(:NoviceBattler).hideitem = true
end

def pbSQ(id)
  return pbQuest(id)
end

def pbQuest(id)
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  return $game_variables[QUEST_ARRAY][id]
end

def pbCheckQuestUnlocks
  before = 0
  after = 0
  for quest in $game_variables[QUEST_ARRAY]
    before+= 1 if quest.status>=0
    pbSetQuestStatus(quest.id,quest.unlock) if quest.unlock? && quest.status<quest.unlock
    after+= 1 if quest.status>=0
  end
  pbDisplayQuestAvailable(after-before) if after > before
  pbMainQuestUnlocks
end
  
def pbSetQuestStatus(id, status)
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  pbQuest(id).status = status
  pbUpdateMarkers
end

def pbDiscoverQuest(id, notif=true)
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  if pbQuest(id).status<1
    pbQuest(id).status=1
    pbDisplayQuestDiscovery(pbQuest(id)) if notif
    pbUpdateMarkers
  end
end

def pbUnlockQuest(id)
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  if $game_variables[QUEST_ARRAY][id].status == -1
    $game_variables[QUEST_ARRAY][id].status = 0
    pbUpdateMarkers
  end
end

def pbSetQuestStep(id, step)
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  $game_variables[QUEST_ARRAY][id].step = step
  pbUpdateMarkers
end

def pbAdvanceQuest(id)
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  $game_variables[QUEST_ARRAY][id].step = $game_variables[QUEST_ARRAY][id].step + 1
  pbDisplayQuestProgress($game_variables[QUEST_ARRAY][id])
  pbUpdateMarkers
end

def pbGetQuestStatus(id)
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  return $game_variables[QUEST_ARRAY][id].status
end

def pbGetQuestStep(id)
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  return $game_variables[QUEST_ARRAY][id].step
end

def isQuestDone?(id)
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  if $game_variables[QUEST_ARRAY][id].status == 2
    return true
  else
    return false
  end
end

def pbRewardMultiplier
  level = pbPlayerLevel
  #exp_need = ((((level+1)**2.85) - (level**2.85))*1.5)
  exp_need = (((level+1)**3) - (level**3))
  ret = exp_need
  return ret
end

def pbFinishQuest(id, silent=false)
  return if !$game_switches[HAS_QUEST_LIST]
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  quest = pbQuest(id)
  $Trainer.stats.quests_completed += 1
  quest.status = 2
  pbUpdateMarkers
  pbTitleDisplay(quest.name, "Quest Completed!") if !silent
  money = quest.money
  item = quest.item
  grandure = (quest.exp*1.0)/100
  exp = grandure * pbRewardMultiplier
  pbEXPScreen(0,exp,true) if exp > 0
  if item
    if item.is_a?(Array)
      pbReceiveItem(item[0],item[1])
    else
      pbReceiveItem(item)
    end
  end
  if money > 0
    pbMessage(_INTL("{1} received ${2}!",$Trainer.name,money))
    $Trainer.money += money
  end
  pbCheckQuestUnlocks
end

def pbQuestDummy(id, num = 1)
  id=getID(PBQuests,id) if id.is_a?(Symbol)
  if num == 1
    return $game_variables[50][id].dummy
  elsif num == 2
    return $game_variables[50][id].dummy2
  end
  return 0
end
  
  
  
  
  
  
  
  
  
  
  