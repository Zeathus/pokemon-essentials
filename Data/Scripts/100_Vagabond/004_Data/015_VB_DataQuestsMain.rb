module PBMainQuests
  FeldsparTownGym    = 0
  BrecciaCityGym     = 1
  LapisTownGym       = 2
  GymQuest4          = 3
  GymQuest5          = 4
  GymQuest6          = 5
  GymQuest7          = 6
  GymQuest8          = 7
  TheFirstGym        = 8
  UnknownDestination = 9
  TheMysteriousGirl  = 10
  TroubleAtMtPegma   = 11
  NekaneGoneMissing  = 12
  GPOMembership      = 13
  GuardianOfEmotion  = 14
  ElianaOfTeamDao    = 15
  KeeperOfKnowledge  = 16
  NekanesMission     = 17
end

def pbAddMainQuest(quest_data)
  if !$game_variables[QUEST_MAIN][quest_data.id]
    $game_variables[QUEST_MAIN][quest_data.id]=quest_data
  else
    quest=$game_variables[QUEST_MAIN][quest_data.id]
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

def pbInitMainQuests
  if !$game_variables[QUEST_MAIN].is_a?(Array)
    $game_variables[QUEST_MAIN] = []
  end
  
  pbAddMainQuest(QuestData.new(PBMainQuests::GymQuest4,
    "temp4", 0, 0, nil, "???",
    "", [
    "temp"],
    "temp"))
  pbAddMainQuest(QuestData.new(PBMainQuests::GymQuest5,
    "temp5", 0, 0, nil, "???",
    "", [
    "temp"],
    "temp"))
  pbAddMainQuest(QuestData.new(PBMainQuests::GymQuest6,
    "temp6", 0, 0, nil, "???",
    "", [
    "temp"],
    "temp"))
  pbAddMainQuest(QuestData.new(PBMainQuests::GymQuest7,
    "temp7", 0, 0, nil, "???",
    "", [
    "temp"],
    "temp"))
  pbAddMainQuest(QuestData.new(PBMainQuests::GymQuest8,
    "temp8", 0, 0, nil, "???",
    "", [
    "temp"],
    "temp"))
  
  pbAddMainQuest(QuestData.new(PBMainQuests::FeldsparTownGym,
    "Feldspar Gym", 0, 100, nil, "???",
    "", [
    "Speak to Raphael's brother about the ore situation.",
    "Go to Mica Quarry and find the one responsible for supplying ore to Felspar Town.",
    "Report to Allon that the problem is resolved."],
    "Raphael's refinery and Gym is running again, and Allon can craft you some useful items."))
  pbAddMainQuest(QuestData.new(PBMainQuests::BrecciaCityGym,
    "Breccia Gym", 0, 100, nil, "???",
    "", [
    "Find the Gym Leader of Breccia City. He's supposedly visiting an area north of the city.",
    "Faunus wishes to see something astounding, but doesn't specify what. Maybe someone in Breccia City can tell you something."],
    "After showing Faunus something astounding, he went back to his Gym duties."))
  pbAddMainQuest(QuestData.new(PBMainQuests::LapisTownGym,
    "Lapis Lazuli Gym", 0, 100, nil, "???",
    "", [
    "Gym Leader Yadon has gone to West Andes Isle. The ferry can take you there.",
    "Help Yadon find Slowking's lost turban. One of the Pokémon at the beach must have it."],
    "You helped Yadon find Slowking's turban. Now the Gym Leader awaits in Lapis Town."))
  pbAddMainQuest(QuestData.new(PBMainQuests::TheFirstGym,
    "The First Gym", 0, 100, nil, "???",
    "", [
    "Defeat your first Pokémon Gym. Gyms can be challenged in any order."],
    "You defeated a Gym just as Duke suggested, a new quest is now available."))
  pbAddMainQuest(QuestData.new(PBMainQuests::GPOMembership,
    "G.P.O. Membership", 0, 100, nil, "???",
    "", [
    "Defeat a total of three Pokémon Gyms to apply for membership at the G.P.O.",
    "Speak to the receptionist at the G.P.O. to apply for membership."],
    "NOT YET FINISHED"))
  pbAddMainQuest(QuestData.new(PBMainQuests::UnknownDestination,
    "Vision of Ruin", 0, 100, nil, "???",
    "", [
    "Take the ferry to West Andes Isle. Any city by the ocean has a ferry. Speak to the person standing by the east shore.",
    "Use the Poké Pager to follow Amethyst to the East Andes Isle.",
    "Go to the depths of Evergone Mangrove with Amethyst."],
    "Together with Amethyst, you entered the Evergone Mangrove and found a mysterious young girl. She said she would keep you updated."))
  pbAddMainQuest(QuestData.new(PBMainQuests::TheMysteriousGirl,
    "The Mysterious Girl", 0, 100, nil, "???",
    "", [
    "Meet up with someone at the Pokémon Center in Chert City.",
    "Follow Amethyst's assistant to meet her.",
    "Find Amethyst and speak with her.",
    "Visit Nekane in her living quarters.",
    "Talk to Amethyst at her office."],
    "You gave the mysterious girl the name Nekane after remembering the strange vision you had at the Evergone Ruins."))
  pbAddMainQuest(QuestData.new(PBMainQuests::TroubleAtMtPegma,
    "Trouble at Mt. Pegma", 0, 100, nil, "???",
    "", [
    "Follow Kira to Mt. Pegma to check for any trouble.",
    "A strange group has infiltrated Mt. Pegma. Help Kira drive them out.",
    "Report back to Amethyst at the G.P.O. HQ."],
    "Together with Kira, you stopped Eliana and Team Dao from capturing Azelf. What could they be planning?"))
  pbAddMainQuest(QuestData.new(PBMainQuests::NekaneGoneMissing,
    "Nekane Gone Missing", 0, 100, nil, "???",
    "", [
    "Help Amethyst find where Nekane went. Someone in Chert City might have seen her.",
    "You found Nekane and talked about feelings. Head back to the G.P.O. and meet Amethyst."],
    "Nekane has a hard time understanding feelings. Amethyst thinks she might have a solution."))
  pbAddMainQuest(QuestData.new(PBMainQuests::GuardianOfEmotion,
    "Guardian of Emotion", 0, 100, nil, "???",
    "", [
    "Meet up with Nekane and Amethyst at Lake Canjon.",
    "Help Amethyst clear out Team Dao from Lake Canjon.",
    "Enter into Nekane's mind to help grant her emotions."],
    "You helped Mesprit grant emotions to Nekane. She's very thankful for your help."))
  pbAddMainQuest(QuestData.new(PBMainQuests::ElianaOfTeamDao,
    "Eliana of Team Dao", 0, 100, nil, "???",
    "", [
    "Kira is asking around Mica Town. Help him out by asking around Feldspar town.",
    "Duke told you that Eliana was headed to the west of Feldspar Town. Tell Kira what you've been told.",
    "Go with Kira to the west of Feldspar Town to look for Eliana."],
    "After infiltrating one of Team Dao's hideouts, you managed to capture Eliana and take her back to the G.P.O. HQ."))
  pbAddMainQuest(QuestData.new(PBMainQuests::KeeperOfKnowledge,
    "Keeper of Knowledge", 0, 100, nil, "???",
    "", [
    "Become a member of the G.P.O. to join the next mission.",
    "Meet with Amethyst and Nekane at the Ranger Outpost north of Scoria City.",
    "Continue north until you reach Amphi Town.",
    "Follow Amethyst and Nekane to Amphi Woods west of Amphi Town.",
    "You can't find your way through the mysterious Amphi Woods. Ask around town for clues.",
    "A woman named Schierke has tasked you with defeating the four elemental elders in battle. Do so and return to her.",
    "With newly gained knowledge, get through Amphi Woods with Amethyst to reach Uxie."],
    "Thanks to Uxie, Nekane regained her memory. She now wants to bring you back to the place you first met."))
  pbAddMainQuest(QuestData.new(PBMainQuests::NekanesMission,
    "Nekane's Mission", 0, 100, nil, "???",
    "", [
    "Become a member of the G.P.O. to join the next mission.",
    "Meet with Amethyst and Nekane at the Ranger Outpost north of Scoria City.",
    "Continue north until you reach Amphi Town.",
    "Follow Amethyst and Nekane to Amphi Woods west of Amphi Town.",
    "You can't find your way through the mysterious Amphi Woods. Ask around town for clues.",
    "A woman named Schierke has tasked you with defeating the four elemental elders in battle. Do so and return to her.",
    "With newly gained knowledge, get through Amphi Woods with Amethyst to reach Uxie."],
    "Thanks to Uxie, Nekane regained her memory. She now wants to bring you back to the place you first met."))
  
  pbMainQuest(:TheFirstGym).status=1 if pbMainQuest(:TheFirstGym).status<1
  
  pbMainQuest(:UnknownDestination).mapguide[0]=[16,15]
  pbMainQuest(:UnknownDestination).mapguide[1]=[20,15]
  pbMainQuest(:UnknownDestination).mapguide[2]=[20,14]
  
  pbMainQuest(:TheMysteriousGirl).mapguide[0]=[16,5]
  pbMainQuest(:TheMysteriousGirl).mapguide[1]=[16,5]
  pbMainQuest(:TheMysteriousGirl).mapguide[2]=[16,5]
  pbMainQuest(:TheMysteriousGirl).mapguide[3]=[16,5]
  pbMainQuest(:TheMysteriousGirl).mapguide[4]=[16,5]
  
  pbMainQuest(:TroubleAtMtPegma).mapguide[0]=[8,9]
  pbMainQuest(:TroubleAtMtPegma).mapguide[1]=[8,9]
  pbMainQuest(:TroubleAtMtPegma).mapguide[2]=[16,5]
  
  pbMainQuest(:GuardianOfEmotion).mapguide[0]=[26,13]
  pbMainQuest(:GuardianOfEmotion).mapguide[1]=[26,13]
  pbMainQuest(:GuardianOfEmotion).mapguide[2]=[26,13]
  
  pbMainQuest(:UnknownDestination).lock = 0#[[:QuestStatus,:TheFirstGym,2,0]]
  pbMainQuest(:TheMysteriousGirl).lock = [[:ReadMail,"Amethyst","Come on Over!",false]]
  pbMainQuest(:TroubleAtMtPegma).lock = [[:QuestStatus,:TheMysteriousGirl,2,0]]
  
  pbMainQuest(:TheFirstGym).finish = [[:BadgeCount,1]]
  
  if pbMainQuest(:GuardianOfEmotion).status==2
    changeMainQuest(:ElianaOfTeamDao, pbMainQuest(:ElianaOfTeamDao).dummy)
  end
end

def changeMainQuest(id, step=false)
  id=getID(PBMainQuests,id) if id.is_a?(Symbol)
  if !step
    step = pbMainQuest(id).step
  end
  if id==PBMainQuests::ElianaOfTeamDao
    if step==0
      pbMainQuest(id).steps = [
      "Kira has been away for a while. Ask around Feldspar Town if anyone has seen him.",
      "Duke told you that Kira was headed to the west of Feldspar Town, go look for him.",
      "Team Dao has a destroyed base to the west of Feldspar Town. Find Kira and help him out!"]
    elsif step==1
      pbMainQuest(id).steps = [
      "",
      "Kira has been away for a while. He probably went to the west of Feldspar Town.",
      "Team Dao has a destroyed base to the west of Feldspar Town. Find Kira and help him out!"]
    elsif step==2
      pbMainQuest(id).steps = [
      "",
      "Kira has been away for a while. Follow him to the west of Feldspar town.",
      "Team Dao has a destroyed base to the west of Feldspar Town. Find Kira and help him out!"]
    end
  end
end

def pbMQ(id)
  return pbMainQuest(id)
end

def pbMainQuest(id)
  id=getID(PBMainQuests,id) if id.is_a?(Symbol)
  return $game_variables[QUEST_MAIN][id]
end

def pbAdvanceStory(id, silent=false)
  id=getID(PBMainQuests,id) if id.is_a?(Symbol)
  $game_variables[QUEST_MAIN][id].step += 1
  if $game_variables[QUEST_MAIN][id].step >= $game_variables[QUEST_MAIN][id].steps.length
    $game_variables[QUEST_MAIN][id].step = $game_variables[QUEST_MAIN][id].steps.length - 1
  end
  pbUpdateMarkers
  pbDisplayQuestProgress($game_variables[QUEST_MAIN][id]) if !silent
end

def pbFinishChapter(id, silent=false)
  return if !$game_switches[HAS_QUEST_LIST]
  id=getID(PBMainQuests,id) if id.is_a?(Symbol)
  $Trainer.stats.quests_completed += 1
  $game_variables[QUEST_MAIN][id].status = 2
  pbUpdateMarkers
  pbTitleDisplay(pbMainQuest(id).name, "Quest Completed!") if !silent
  #pbDisplayQuestCompletion($game_variables[QUEST_MAIN][id]) if !silent
  grandure = ($game_variables[QUEST_MAIN][id].exp*1.0)/100
  exp = grandure * pbRewardMultiplier
  pbEXPScreen(0,exp,true) if exp > 0
  pbCheckQuestUnlocks
end

def pbNewMainQuest(id, silent=false)
  id=getID(PBMainQuests,id) if id.is_a?(Symbol)
  if pbMainQuest(id).status<1
    pbMainQuest(id).status=1
    pbUpdateMarkers
    pbTitleDisplay("Main Quest", pbMainQuest(id).name) if !silent
    #pbDisplayQuestDiscovery(pbMainQuest(id)) if notif
  end
end

def pbMainQuestUnlocks
  for quest in $game_variables[QUEST_MAIN]
    pbNewMainQuest(quest.id) if quest.unlock? && quest.status<1
    pbFinishChapter(quest.id) if quest.finish? && quest.status<2
  end
end







