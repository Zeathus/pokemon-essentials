def pbDialogDukeUnknownDestination
  
  return if !pbGetMetadata($game_map.map_id,MetadataOutdoor)
  return if pbMainQuest(:UnknownDestination).status>0
  
  $game_system.bgm_memorize
  $game_system.bgm_fade(3)
  
  pbWait(20)
  
  pbSpeech("Duke","none",
    "Well done, PLAYER.",true)
  
  pbSEPlay("Saint9",100)
  pbToneChangeAll(Tone.new(255,255,255),6)
  pbWait(12)
  x=Graphics.width/2
  y=Graphics.height/2+52
  pbShowPicture(1,"duke",1,x,y,100,100,255)
  $game_screen.pictures[1].start_tone_change(Tone.new(255,255,255),0)
  pbToneChangeAll(Tone.new(0,0,0),10)
  $game_screen.pictures[1].start_tone_change(Tone.new(0,0,0),10)
  pbWait(52)
  
  pbBGMPlay("Foreteller")
  
  pbSpeech("Duke","neutral",
    "We meet again.")
  pbSpeech("Duke","neutral",
    "You've grown much stronger since our last encounter.")
  pbSpeech("Duke","neutral",
    "You even managed to win a Gym Badge,WT impressive.")
  pbSpeech("Duke","neutral",
    "The vision you had in Shale Forest was no coincidence.")
  pbSpeech("Duke","neutral",
    "Those ruins are your next destination to fulfill your destiny.")
  pbNewMainQuest(:UnknownDestination)
  pbSpeech("Duke","neutral",
    "Go to the West Andes Isle.WT There you will have a fateful encounter.")
  pbSpeech("Duke","neutral",
    "With whom you ask?WT That is for you to find out.")
  pbSpeech("Duke","neutral",
    "Before you go, I have something for you.")
  Kernel.pbReceiveItem(PBItems::ODDSTONE)
  pbSpeech("Duke","neutral",
    "It's a gift from a special someone.WTBREAKTake good care of it.")
  pbSpeech("Duke","huzzah",
    "Until we meet again, I bid you farewell!")
  pbShout("Duke","power",
    "VANISH!WTNP")
  
  pbToneChangeAll(Tone.new(255,255,255),6)
  $game_screen.pictures[1].start_tone_change(Tone.new(255,255,255),6)
  pbSEPlay("Saint9",100)
  pbWait(20)
  $game_screen.pictures[1].erase
  pbToneChangeAll(Tone.new(0,0,0),10)
  pbWait(30)
  
  $game_system.bgm_restore
  
end