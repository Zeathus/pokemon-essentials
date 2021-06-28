module PBMessages
  
  SurfConfirm       = "The water is a deep blue...\nWould you like to call Wailmer?"
  SurfStart         = "Called upon Wailmer!"
  
  SleepMoveStopped  = "...your anguished cries...find no resonance here..."
  AntiSave          = "The unsettling nature of this place makes it impossible to memorize."
  
  GhostFight        = "Spooky scary skeletons, sends shivers down your spine."
  GhostSwitch       = "You are too busy peeing your pants."
  GhostBag          = "You don't have enough confidence to grab anything."
  GhostAppear       = "Get Spook'd!"
  
end

def pbGetGuardQuote
  quotes = [
    "He seems to be making some weird origami.",
    "He's petting his Growlithe with a depressed look.",
    "He seems to be staring into oblivion contemplating the meaning of life.",
    "It sounds like he's crying quietly to himself.",
    "It seems like he has a million thoughts running through his mind at once.",
    "You hear him whisering motivational and cheering words to himself."]
  shuffled = quotes.shuffle
  return shuffled[0]
end