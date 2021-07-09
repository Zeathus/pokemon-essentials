def pbCheckMail
  return if !$Trainer.has_pokegear
  
  if rand(8192)==1
    mail = GearMail.new("???", "Ancestor", "Blah blah blah blah blah.\n" +
      "This is a placeholder for a rare mail. It's a 1/8192 chance every " +
      "mail refresh, so you got lucky! Have a cookie.")
    if !pbHasMail?(mail)
      pbSendMail(mail)
    end
  end
  
  if rand(32768)==1
    pbSendMail("Samson Oak", "Hello Cousin!",
      "Hello Sammy!\n\n" + 
      "It's been ABSOLutely forever since we visited each other. " +
      "You should COMBEE with me in Alola sometime. " +
      "There hasn't been much HAPPINYng around here lately, " +
      "so it would be BOUNSWEET if you could come soon.\n\n" +
      " -Samson Oak")
    pbSendMail("Samson Oak", "Wrong Person!",
      "Oh SHUCKLE!\n" +
      "I AXEWdently mailed the wrong person. " +
      "What are the CHANSEYs?")
  end
    
  pbStoryMail
end

def pbStoryMail
  if $game_variables[103]!=0
    if pbHasTimePassed($game_variables[103],540)
      mail = GearMail.new("G.P.O.", "East Andes Isle",
      "The situation surrouding the burst of energy at the East Andes Isle " +
      "has been resolved. The area is no longer off limits as " +
      "inspection showed no potential danger around the area.\n\n" +
      "- The Global Protection Organization")
      if !pbHasMail?(mail,2)
        pbSendMail(mail,true)
      end
    end
    if pbHasTimePassed($game_variables[103],1080)
      mail = GearMail.new("Amethyst", "Come on Over!",
      "The girl has started to recover now. I took her to Chert City, you know " +
      "where that is right? That huge city in the center of the region. " +
      "You can get there easily by ship from any city by the ocean. " +
      "If you visit the Pokémon Center in Chert City, there will be " +
      "someone that can show you the way. I'm sure you will " +
      "spot him right away.\n\n" +
      "See you soon! ;)\n" +
      "- Amethyst")
      if !pbHasMail?(mail,1)
        pbSendMail(mail,false,true)
      end
      $game_variables[103]=0
    end
  end
end

def pbHasReadMail(sender, subject, global=false)
  ret = false
  mail_list = $Trainer.mail.personal
  mail_list = $Trainer.mail.global if global
  for i in mail_list
    if sender == i.sender && subject == i.subject && i.read
      ret = true
    end
  end
  return ret
end