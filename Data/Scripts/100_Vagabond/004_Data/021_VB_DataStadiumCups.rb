def pbStadiumCups
  
  titles = []
  descriptions = []
  stats = [] # [max_level, max_pkmn, difficulty]
  trainers = [] # [type, name, party, win, *before, *after]
  
  titles.push("Tutorial Cup")
  descriptions.push("Get used to the Stadium battles with this Tutorial Cup.")
  stats.push([10,2,1])
  trainers.push([
    [PBTrainers::YOUNGSTER, "Ichi", 0,
      "You beat me...",
      "First time here?WT Good luck beating me!",
      "Good luck, pal.WT You're strong!"],
    [PBTrainers::LASS, "Ni", 0,
      "Nice work!",
      "I'm the second one up!WT Are you pumped?",
      "I'm sure you'll win the next battle!"],
    [PBTrainers::PRESCHOOLER_M, "San", 0,
      "I've been whomped...",
      "I've come to WHOMP you!"],
    [PBTrainers::SCHOOLBOY, "Yon", 0,
      "Looks like you're ready to go!",
      "Getting used to the stadium?WT I'm your final match this Cup!",
      "This was just the tutorial Cup.WT Just wait until you get to the really tough matches!"]
  ])
  
  if pbStadiumHasWonCup("Tutorial Cup") || $DEBUG
    
    # Phantom Cup (Persona 5)
    titles.push("Phantom Cup")
    descriptions.push("Face off against rebellious thieves from another realm.")
    stats.push([40,2,3])
    trainers.push([
      [PBTrainers::LADY, "Haru", 0, "..."],
      [PBTrainers::SCHOOLGIRL, "Futaba", 0, "..."],
      [PBTrainers::CYCLIST_F, "Makoto", 0, "..."],
      [PBTrainers::PAINTER, "Yusuke", 0, "..."],
      [PBTrainers::LADY, "Ann", 0, "..."],
      [PBTrainers::YOUNGSTER, "Ryuji", 0, "..."],
      [PBTrainers::BURGLAR, "Morgana", 0, "..."],
      [PBTrainers::GAMBLER, "Ren", 0, "..."]
    ])
    
    # Phantom Cup (Persona 5)
    titles.push("Aegis Cup")
    descriptions.push("Battle a foreign party of unique opponents.")
    stats.push([50,3,4])
    trainers.push([
      [PBTrainers::ROUGHNECK, "Zeke", 0, "..."],
      [PBTrainers::VETERAN_F, "Morag", 0, "..."],
      [PBTrainers::ENGINEER, "Tora", 0, "..."],
      [PBTrainers::NURSE, "Nia", 0, "..."],
      [PBTrainers::MINER, "Rex", 0, "..."]
    ])
    # No More Tutorial Cup
    titles.push("No More Tutorial")
    descriptions.push("The Tutorial Cup trainers are back for a long awaited rematch.")
    stats.push([50,3,5])
    trainers.push([
      [PBTrainers::ACETRAINER_M, "Ichi", 0,
        "You beat me again...",
        "This has been a long time coming, hasn't it?",
        "You've really been keeping up all this time!"],
      [PBTrainers::ACETRAINER_F, "Ni", 0,
        "Impressive!",
        "Wow, we've both come really far, haven't we?",
        "You'll probably ace the other trainers here!"],
      [PBTrainers::RICHBOY, "San", 0,
        "Yet again...",
        "Last time I got whomped, but this time shall be different!"],
      [PBTrainers::VETERAN_M, "Yon", 0,
        "I can't surpass you...",
        "I will go all out this time, for a rematch!",
        "You've come so far since the Tutorial Cup.WT This was a fun battle. "]
    ])
  
  end
  
  #titles.push("Xenoblade 2 Cup")
  
  #titles.push("Kanto Cup")
  #titles.push("Johto Cup")
  #titles.push("Hoenn Cup")
  #titles.push("Sinnoh Cup")
  #titles.push("Unova Cup")
  #titles.push("Kalos Cup")
  #titles.push("Alola Cup")
  
  return [titles,descriptions,stats,trainers]
  
end