#---------------------------------------------------------------------
# General UI
#---------------------------------------------------------------------
module UIType
  QUESTAVAILABLE  = 0
  QUESTDISCOVER   = 1
  QUESTPROGRESS   = 2
  MAILRECEIVED    = 3
  TEXTLEFT        = 4
  TEXTCOLLECT     = 5
  SPEEDUP         = 6
end

def pbTriggerUI(type,info)
  $game_variables[UI_ARRAY]=[] if !$game_variables[UI_ARRAY].is_a?(Array)
  anim = [type,false] + info
  $game_variables[UI_ARRAY].push(anim)
end

def pbGlobalTimer
  return $game_variables[GLOBAL_TIMER]
end

def pbUpdateUI
  #$game_variables[GLOBAL_TIMER]+=1
  #if $game_variables[GLOBAL_TIMER]>=120
  #  $game_variables[GLOBAL_TIMER]=0
  #end
  $game_variables[UI_ARRAY]=[] if !$game_variables[UI_ARRAY].is_a?(Array)
  if $game_variables[UI_ARRAY].length>0
    anim = $game_variables[UI_ARRAY][0]
    if anim[0]==UIType::QUESTAVAILABLE
      if pbUI_QuestAvailable(anim)
        $game_variables[UI_ARRAY] -= [anim]
      end
    elsif anim[0]==UIType::QUESTDISCOVER
      if pbUI_QuestDiscovery(anim)
        $game_variables[UI_ARRAY] -= [anim]
      end
    elsif anim[0]==UIType::QUESTPROGRESS
      if pbUI_QuestProgress(anim)
        $game_variables[UI_ARRAY] -= [anim]
      end
    elsif anim[0]==UIType::MAILRECEIVED
      if pbUI_MailNotification(anim)
        $game_variables[UI_ARRAY] -= [anim]
      end
    elsif anim[0]==UIType::TEXTLEFT
      if pbUI_LeftNotification(anim)
        $game_variables[UI_ARRAY] -= [anim]
      end
    elsif anim[0]==UIType::TEXTCOLLECT
      if pbUI_CollectNotification(anim)
        $game_variables[UI_ARRAY] -= [anim]
      end
    elsif anim[0]==UIType::SPEEDUP
      if pbUI_SpeedUpMessage(anim)
        $game_variables[UI_ARRAY] -= [anim]
      end
    end
  end
end


#---------------------------------------------------------------------
# Quest UI
#---------------------------------------------------------------------
def pbDisplayQuestAvailable(num)
  pbTriggerUI(UIType::QUESTAVAILABLE, [num])
end

def pbDisplayQuestDiscovery(quest)
  pbTriggerUI(UIType::QUESTDISCOVER, [quest])
end

def pbDisplayQuestProgress(quest)
  pbTriggerUI(UIType::QUESTPROGRESS, [quest])
end

def pbDisplayQuestCompletion(quest)
  anim = [0,false,quest]
  pbUI_QuestCompletion(anim)
end

def pbUI_QuestAvailable(anim)
  return true if anim[2]<=0
  anim[1]=0 if anim[1]==false
  frame = anim[1]
  num = anim[2]
  if anim.length < 4
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[3] = viewport
    sprites = {}
    anim[4] = sprites
  end
  viewport = anim[3]
  sprites = anim[4]
  if frame < 20
    if !sprites["locwindow"]
      sprites["locwindow"]=Window_AdvancedTextPokemon.new("")
      sprites["locwindow"].viewport=viewport
      sprites["locwindow"].setSkin("Graphics/Windowskins/quest_popup")
      sprites["locwindow"].baseColor=Color.new(230,230,230)
      sprites["locwindow"].shadowColor=Color.new(6,70,120)
      sprites["locwindow"].contents.font.size=18
      sprites["locwindow"].contents.font.name = "Smallest"
      text = ""
      lines = 1
      if num==1
        text += "<b>" + "NEW QUEST AVAILABLE" + "</b>"
      else
        text += "<b>" + num.to_s + " NEW QUESTS AVAILABLE" + "</b>"
      end
      sprites["locwindow"].x=512+256
      sprites["locwindow"].y=384/2 - sprites["locwindow"].lineHeight * lines / 2
      sprites["locwindow"].visible = true
      sprites["locwindow"].setTextToFit(text)
      sprites["locwindow"].width = 220
      sprites["locwindow"].contents.font.name = "Smallest"
      sprites["locwindow"].redrawText
    end
    if frame>0
      sprites["locwindow"].x =
        (512+256 - (190 * (0.5 + 0.5 * Math.sin(3.9*(frame*1.0/20) - 2)))).floor
    end
  elsif frame >= 20 && frame < 80
    
  elsif frame >= 120 && frame < 140
    sprites["locwindow"].x =
      (512+256 - (190 * (0.5 + 0.5 * Math.sin(3.9*((140-frame)*1.0/20) - 2)))).floor
  elsif frame >= 140
    pbDisposeSpriteHash(anim[4])
    anim[3].dispose
    return true
  end
  anim[1]+=1
  return false
end

def pbUI_QuestDiscovery(anim)
  anim[1]=0 if anim[1]==false
  frame = anim[1]
  quest = anim[2]
  if anim.length < 4
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[3] = viewport
    sprites = {}
    anim[4] = sprites
  end
  viewport = anim[3]
  sprites = anim[4]
  if frame < 20
    if !sprites["locwindow"]
      sprites["locwindow"]=Window_AdvancedTextPokemon.new("",2)
      sprites["locwindow"].viewport=viewport
      sprites["locwindow"].setSkin("Graphics/Windowskins/quest_popup")
      sprites["locwindow"].baseColor=Color.new(230,230,230)
      sprites["locwindow"].shadowColor=Color.new(6,70,120)
      sprites["locwindow"].contents.font.size=18
      sprites["locwindow"].contents.font.name = "Smallest"
      stops = " 0.,!?:;"
      steptext = quest.steps[quest.step]
      text = ""
      lines = 3
      text += "<b><u>" + quest.name + "</b></u><br>"
      text += "Quest Discovered!<br>"
      text += "(X for more info)"
      sprites["locwindow"].x=556+256
      sprites["locwindow"].y=384/2 - sprites["locwindow"].lineHeight * lines / 2
      sprites["locwindow"].visible = true
      sprites["locwindow"].setTextToFit(text)
      sprites["locwindow"].width = 200
      sprites["locwindow"].contents.font.name = "Smallest"
      sprites["locwindow"].redrawText
    end
    if frame>0
      sprites["locwindow"].x =
        (556 + 256 - (190 * (0.5 + 0.5 * Math.sin(3.9*(frame*1.0/20) - 2)))).floor
    end
  elsif frame >= 20 && frame < 80
    
  elsif frame >= 120 && frame < 140
    sprites["locwindow"].x =
      (556 + 256 - (190 * (0.5 + 0.5 * Math.sin(3.9*((140-frame)*1.0/20) - 2)))).floor
  elsif frame >= 140
    pbDisposeSpriteHash(anim[4])
    anim[3].dispose
    return true
  end
  anim[1]+=1
  return false
end

def pbUI_QuestDiscoveryFull(anim)
  anim[1]=0 if anim[1]==false
  frame = anim[1]
  quest = anim[2]
  if anim.length < 4
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[3] = viewport
    sprites = {}
    anim[4] = sprites
  end
  viewport = anim[3]
  sprites = anim[4]
  if frame < 20
    if !sprites["locwindow"]
      sprites["locwindow"]=Window_AdvancedTextPokemon.new("")
      sprites["locwindow"].viewport=viewport
      sprites["locwindow"].setSkin("Graphics/Windowskins/quest_popup")
      sprites["locwindow"].baseColor=Color.new(230,230,230)
      sprites["locwindow"].shadowColor=Color.new(6,70,120)
      sprites["locwindow"].contents.font.size=18
      sprites["locwindow"].contents.font.name = "Smallest"
      stops = " 0.,!?:;"
      steptext = quest.steps[quest.step]
      text = ""
      lines = 1
      text += "<b><u>" + quest.name + "</b></u><br>"
      while sprites["locwindow"].contents.text_size(steptext).width > 160
        line = ""
        while sprites["locwindow"].contents.text_size(line).width < 160
          line += steptext[0..0]
          steptext = steptext[1..steptext.length-1]
        end
        while !stops.include?(line[line.length-1..line.length-1]) || line.length<=0
          steptext = line[line.length-1..line.length-1] + steptext
          line = line[0..line.length-2]
        end
        text += line
        text += "<br>"
        lines += 1
      end
      text += steptext
      lines += 1
      sprites["locwindow"].x=512
      sprites["locwindow"].y=384/2 - sprites["locwindow"].lineHeight * lines / 2
      sprites["locwindow"].visible = true
      sprites["locwindow"].setTextToFit(text)
      sprites["locwindow"].width = 200
      sprites["locwindow"].contents.font.name = "Smallest"
      sprites["locwindow"].redrawText
    end
    if frame>0
      sprites["locwindow"].x =
        (512 - (190 * (0.5 + 0.5 * Math.sin(3.9*(frame*1.0/20) - 2)))).floor
    end
  elsif frame >= 20 && frame < 80
    
  elsif frame >= 120 && frame < 140
    sprites["locwindow"].x =
      (512 - (190 * (0.5 + 0.5 * Math.sin(3.9*((140-frame)*1.0/20) - 2)))).floor
  elsif frame >= 140
    pbDisposeSpriteHash(anim[4])
    anim[3].dispose
    return true
  end
  anim[1]+=1
  return false
end

def pbUI_QuestProgress(anim)
  anim[1]=0 if anim[1]==false
  frame = anim[1]
  quest = anim[2]
  if anim.length < 4
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[3] = viewport
    sprites = {}
    anim[4] = sprites
  end
  viewport = anim[3]
  sprites = anim[4]
  if frame < 20
    if !sprites["locwindow"]
      sprites["locwindow"]=Window_AdvancedTextPokemon.new("")
      sprites["locwindow"].viewport=viewport
      sprites["locwindow"].setSkin("Graphics/Windowskins/quest_popup")
      sprites["locwindow"].baseColor=Color.new(230,230,230)
      sprites["locwindow"].shadowColor=Color.new(6,70,120)
      sprites["locwindow"].contents.font.size=18
      sprites["locwindow"].contents.font.name = "Smallest"
      stops = " 0.,!?:;"
      steptext = quest.steps[quest.step]
      text = ""
      lines = 3
      text += "<b><u>" + quest.name + "</b></u><br>"
      text += "Quest Updated<br>"
      text += "(X for more info)"
      sprites["locwindow"].x=530+256
      sprites["locwindow"].y=384/2 - sprites["locwindow"].lineHeight * lines / 2
      sprites["locwindow"].visible = true
      sprites["locwindow"].setTextToFit(text)
      sprites["locwindow"].width = 200
      sprites["locwindow"].contents.font.name = "Smallest"
      sprites["locwindow"].redrawText
    end
    if frame>0
      sprites["locwindow"].x =
        (530+256 - (190 * (0.5 + 0.5 * Math.sin(3.9*(frame*1.0/20) - 2)))).floor
    end
  elsif frame >= 20 && frame < 80
    
  elsif frame >= 120 && frame < 140
    sprites["locwindow"].x =
      (530+256 - (190 * (0.5 + 0.5 * Math.sin(3.9*((140-frame)*1.0/20) - 2)))).floor
  elsif frame >= 140
    pbDisposeSpriteHash(anim[4])
    anim[3].dispose
    return true
  end
  anim[1]+=1
  return false
end

def pbUI_QuestProgressFull(anim)
  anim[1]=0 if anim[1]==false
  frame = anim[1]
  quest = anim[2]
  if anim.length < 4
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[3] = viewport
    sprites = {}
    anim[4] = sprites
  end
  viewport = anim[3]
  sprites = anim[4]
  if frame < 20
    if !sprites["locwindow"]
      sprites["locwindow"]=Window_AdvancedTextPokemon.new("")
      sprites["locwindow"].viewport=viewport
      sprites["locwindow"].setSkin("Graphics/Windowskins/quest_popup")
      sprites["locwindow"].baseColor=Color.new(230,230,230)
      sprites["locwindow"].shadowColor=Color.new(6,70,120)
      sprites["locwindow"].contents.font.size=18
      sprites["locwindow"].contents.font.name = "Smallest"
      stops = " 0.,!?:;"
      steptext = quest.steps[quest.step - 1]
      text = ""
      lines = 1
      text += "<b><u>" + quest.name + "</b></u><br>"
      while sprites["locwindow"].contents.text_size(steptext).width > 160
        line = ""
        while sprites["locwindow"].contents.text_size(line).width < 160
          line += steptext[0..0]
          steptext = steptext[1..steptext.length-1]
        end
        while !stops.include?(line[line.length-1..line.length-1]) || line.length<=0
          steptext = line[line.length-1..line.length-1] + steptext
          line = line[0..line.length-2]
        end
        text += line
        text += "<br>"
        lines += 1
      end
      text += steptext
      lines += 1
      sprites["locwindow"].x=512
      sprites["locwindow"].y=384/2 - sprites["locwindow"].lineHeight * lines / 2
      sprites["locwindow"].visible = true
      sprites["locwindow"].setTextToFit(text)
      sprites["locwindow"].width = 200
      sprites["locwindow"].redrawText
    end
    if frame>0
      sprites["locwindow"].x =
        (512 - (190 * (0.5 + 0.5 * Math.sin(3.9*(frame*1.0/20) - 2)))).floor
    end
  elsif frame >= 20 && frame < 50
    anim[5]=0 if !anim[5]
    anim[5]+=1
    if !sprites["checkbox"]
      sprites["checkbox"] = Sprite.new(viewport)
      sprites["checkbox"].bitmap = RPG::Cache.load_bitmap("","Graphics/Messages/checkmark/checkbox_0")
      sprites["checkbox"].x = 364
      sprites["checkbox"].y = 384/2 - 20
      sprites["checkbox"].z = 100000
    end
    if anim[5] > 8 && anim[5] < 22
      checkfile = _INTL("Graphics/Messages/checkmark/checkbox_{1}",anim[5]-8)
      sprites["checkbox"].bitmap = RPG::Cache.load_bitmap("",checkfile)
    end
  elsif frame >= 60 && frame < 70
    anim[5]=0 if frame == 60
    anim[5]+=1
    sprites["checkbox"].opacity = 255 - 255 * anim[5] / 10
  elsif frame >= 80 && frame < 100
    if !sprites["locwindow2"]
      sprites["locwindow2"]=Window_AdvancedTextPokemon.new("")
      sprites["locwindow2"].viewport=viewport
      sprites["locwindow2"].setSkin("Graphics/Windowskins/quest_popup")
      sprites["locwindow2"].baseColor=Color.new(230,230,230)
      sprites["locwindow2"].shadowColor=Color.new(6,70,120)
      sprites["locwindow2"].contents.font.size=18
      sprites["locwindow2"].contents.font.name = "Smallest"
      stops = " .,!?:;"
      steptext = quest.steps[quest.step]
      text = ""
      lines = 1
      text += "<b><u>" + quest.name + "</b></u><br>"
      while sprites["locwindow"].contents.text_size(steptext).width > 160
        line = ""
        while sprites["locwindow"].contents.text_size(line).width < 160
          line += steptext[0..0]
          steptext = steptext[1..steptext.length-1]
        end
        while !stops.include?(line[line.length-1..line.length-1]) || line.length<=0
          steptext = line[line.length-1..line.length-1] + steptext
          line = line[0..line.length-2]
        end
        text += line
        text += "<br>"
        lines += 1
      end
      text += steptext
      lines += 1
      sprites["locwindow2"].x=512
      sprites["locwindow2"].y=384/2 - sprites["locwindow2"].lineHeight * lines / 2
      sprites["locwindow2"].visible = true
      sprites["locwindow2"].setTextToFit(text)
      sprites["locwindow2"].width = 200
      sprites["locwindow2"].redrawText
    end
    sprites["locwindow"].y += 3
    sprites["locwindow"].opacity = 255 - (64 * (frame-80)/20)
    sprites["locwindow2"].x =
      (512 - (190 * (0.5 + 0.5 * Math.sin(3.9*((frame-80)*1.0/20) - 2)))).floor
  elsif frame >= 180 && frame < 210
    if frame < 200
      sprites["locwindow"].x =
        (512 - (190 * (0.5 + 0.5 * Math.sin(3.9*((200-frame)*1.0/20) - 2)))).floor
    end
    if frame >= 190
      sprites["locwindow2"].x =
        (512 - (190 * (0.5 + 0.5 * Math.sin(3.9*((210-frame)*1.0/20) - 2)))).floor
    end
  elsif frame >= 200
    pbDisposeSpriteHash(anim[4])
    anim[3].dispose
    return true
  end
  anim[1]+=1
  return false
end

def pbUI_QuestCompletion(anim)
  anim[1]=0 if anim[1]==false
  frame = anim[1]
  quest = anim[2]
  if anim.length < 4
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[3] = viewport
    sprites = {}
    anim[4] = sprites
  end
  viewport = anim[3]
  sprites = anim[4]
  while frame < 20
    frame+=1
    if !sprites["shadowl"]
      sprites["shadowl"] = Sprite.new(viewport)
      sprites["shadowl"].bitmap=RPG::Cache.load_bitmap("","Graphics/Messages/ui_shadow_left")
      sprites["shadowl"].y=Graphics.height/2-sprites["shadowl"].bitmap.height/2
      sprites["shadowl"].x=-Graphics.width
    end
    if !sprites["shadowr"]
      sprites["shadowr"] = Sprite.new(viewport)
      sprites["shadowr"].bitmap=RPG::Cache.load_bitmap("","Graphics/Messages/ui_shadow_right")
      sprites["shadowr"].y=Graphics.height/2-sprites["shadowl"].bitmap.height/2
      sprites["shadowr"].x=Graphics.width
    end
    sprites["shadowl"].x+=Graphics.width/20
    sprites["shadowr"].x-=Graphics.width/20
    pbWait(1)
  end
  write1 = 0
  write2 = 0
  while frame >= 20 && frame < 100
    frame+=1
    display = "Quest completed!"
    write1 += 1 if write1 < quest.name.length
    write2 += 1 if write1 >= quest.name.length && write2 < display.length
    if !sprites["display"]
      sprites["display"] = Sprite.new(viewport)
      sprites["display"].bitmap = BitmapWrapper.new(Graphics.width,Graphics.height)
      pbSetSystemFont(sprites["display"].bitmap)
    end
    textx=Graphics.width/2-(quest.name.length*6)
    texty=Graphics.height/2-34
    sprites["display"].bitmap.clear
    textpos=[[quest.name[0..write1],textx,texty,false,Color.new(255, 255, 255),Color.new(168, 184, 184)]]
    if write1 >= quest.name.length
      textpos.push([display[0..write2],160,Graphics.height/2+4,false,Color.new(255, 255, 255),Color.new(168, 184, 184)])
    end
    pbDrawTextPositions(sprites["display"].bitmap,textpos)
    pbWait(1)
  end
  pbFadeOutAndHide(sprites)
  pbDisposeSpriteHash(anim[4])
  anim[3].dispose
  return true
end

#---------------------------------------------------------------------
# Mail UI
#---------------------------------------------------------------------
def pbMailNotification(mail,forceopen=false,global=false)
  pbTriggerUI(UIType::MAILRECEIVED, [mail,forceopen,global])
end

def pbUI_MailNotification(anim)
  anim[1]=0 if anim[1]==false
  frame = anim[1]
  mail = anim[2]
  if anim.length < 6
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[5] = viewport
    sprites = {}
    anim[6] = sprites
  end
  viewport = anim[5]
  sprites = anim[6]
  if frame < 20
    if !sprites["locwindow"]
      sprites["locwindow"]=Window_AdvancedTextPokemon.new("")
      sprites["locwindow"].viewport=viewport
      sprites["locwindow"].setSkin("Graphics/Windowskins/mail_popup")
      sprites["locwindow"].baseColor=Color.new(230,230,230)
      sprites["locwindow"].shadowColor=Color.new(120,40,40)
      sprites["locwindow"].contents.font.size=18
      sprites["locwindow"].contents.font.name = "Smallest"
      stops = " -.,!?:;"
      steptext = mail.message
      text = ""
      lines = 2
      text += "<b><u>Received new mail</u></b><br>"
      text += "From: " + mail.sender + "<br>"
      text += "Subject: " + mail.subject + "</b></u>"
      sprites["locwindow"].x=-200
      sprites["locwindow"].y=384/2 - sprites["locwindow"].lineHeight * lines / 2
      sprites["locwindow"].visible = true
      sprites["locwindow"].setTextToFit(text)
      sprites["locwindow"].width = 200
      sprites["locwindow"].contents.font.name = "Smallest"
      sprites["locwindow"].redrawText
    end
    if frame>0
      sprites["locwindow"].x =
        (-200 + (190 * (0.5 + 0.5 * Math.sin(3.9*(frame*1.0/20) - 2)))).floor
    end
  elsif frame >= 20 && frame < 80
    
  elsif frame >= 120 && frame < 140
    sprites["locwindow"].x =
      (-200 + (190 * (0.5 + 0.5 * Math.sin(3.9*((140-frame)*1.0/20) - 2)))).floor
  elsif frame >= 140
    pbDisposeSpriteHash(anim[6])
    anim[5].dispose
    if anim[3]
      pbShowMail(true,anim[4])
    end
    return true
  end
  anim[1]+=1
  return false
end

#---------------------------------------------------------------------
# General UI
#---------------------------------------------------------------------
def pbLeftNotification(text,title=nil)
  pbTriggerUI(UIType::TEXTLEFT, [title,text])
end

def pbUI_LeftNotification(anim)
  anim[1]=0 if anim[1]==false
  frame = anim[1]
  title = anim[2]
  text  = anim[3]
  if anim.length < 5
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[4] = viewport
    sprites = {}
    anim[5] = sprites
  end
  viewport = anim[4]
  sprites = anim[5]
  if frame < 20
    if !sprites["locwindow"]
      sprites["locwindow"]=Window_AdvancedTextPokemon.new("")
      sprites["locwindow"].viewport=viewport
      sprites["locwindow"].setSkin("Graphics/Windowskins/mail_popup")
      sprites["locwindow"].baseColor=Color.new(230,230,230)
      sprites["locwindow"].shadowColor=Color.new(120,40,40)
      sprites["locwindow"].contents.font.size=18
      sprites["locwindow"].contents.font.name = "Smallest"
      stops = " -.,!?:;"
      textdisplay = ""
      lines = 2
      if title
        textdisplay += "<b><u>" + title + "</u></b><br>"
      end
      textdisplay += text
      sprites["locwindow"].x=-200
      sprites["locwindow"].y=384/2 - sprites["locwindow"].lineHeight * lines / 2
      sprites["locwindow"].visible = true
      sprites["locwindow"].setTextToFit(textdisplay)
      text_size1 = title ? sprites["locwindow"].contents.text_size(title).width : 0
      text_size2 = sprites["locwindow"].contents.text_size(text).width
      if text_size1 > text_size2
        sprites["locwindow"].width = 38 + text_size1
      else
        sprites["locwindow"].width = 38 + text_size2
      end
      sprites["locwindow"].contents.font.name = "Smallest"
      sprites["locwindow"].redrawText
    end
    if frame>0
      sprites["locwindow"].x =
        (-200 + (190 * (0.5 + 0.5 * Math.sin(3.9*(frame*1.0/20) - 2)))).floor
    end
  elsif frame >= 20 && frame < 80
    
  elsif frame >= 120 && frame < 140
    sprites["locwindow"].x =
      (-200 + (190 * (0.5 + 0.5 * Math.sin(3.9*((140-frame)*1.0/20) - 2)))).floor
  elsif frame >= 140
    pbDisposeSpriteHash(anim[5])
    anim[4].dispose
    return true
  end
  anim[1]+=1
  return false
end

def pbCollectNotification(text,text2,title=nil)
  if text2==nil
    pbTriggerUI(UIType::TEXTLEFT, [title,text])
  else
    pbTriggerUI(UIType::TEXTCOLLECT, [title,text,text2])
  end
end

def pbUI_CollectNotification(anim)
  anim[1]=0 if anim[1]==false
  frame = anim[1]
  title = anim[2]
  text  = anim[3]
  text2 = anim[4]
  if anim.length < 6
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[5] = viewport
    sprites = {}
    anim[6] = sprites
  end
  viewport = anim[5]
  sprites = anim[6]
  if frame < 20
    if !sprites["locwindow"]
      sprites["locwindow"]=Window_AdvancedTextPokemon.new("")
      sprites["locwindow"].viewport=viewport
      sprites["locwindow"].setSkin("Graphics/Windowskins/mail_popup")
      sprites["locwindow"].baseColor=Color.new(230,230,230)
      sprites["locwindow"].shadowColor=Color.new(120,40,40)
      sprites["locwindow"].contents.font.size=18
      sprites["locwindow"].contents.font.name = "Smallest"
      stops = " -.,!?:;"
      textdisplay = ""
      lines = 2
      if title
        textdisplay += "<b><u>" + title + "</u></b><br>"
      end
      textdisplay += text
      textdisplay += "<br>" + text2
      sprites["locwindow"].x=-200
      sprites["locwindow"].y=384/2 - sprites["locwindow"].lineHeight * lines / 2
      sprites["locwindow"].visible = true
      sprites["locwindow"].setTextToFit(textdisplay)
      if title && title.length > text.length && title.length > text2.length
        sprites["locwindow"].width = 40 + (8 * title.length)
      elsif text.length > text2.length
        sprites["locwindow"].width = 40 + (8 * text.length)
      else
        sprites["locwindow"].width = 20 + (8 * text2.length)
      end
      sprites["locwindow"].contents.font.name = "Smallest"
      sprites["locwindow"].redrawText
    end
    if frame>0
      sprites["locwindow"].x =
        (-200 + (190 * (0.5 + 0.5 * Math.sin(3.9*(frame*1.0/20) - 2)))).floor
    end
  elsif frame >= 20 && frame < 80
    
  elsif frame >= 120 && frame < 140
    sprites["locwindow"].x =
      (-200 + (190 * (0.5 + 0.5 * Math.sin(3.9*((140-frame)*1.0/20) - 2)))).floor
  elsif frame >= 140
    pbDisposeSpriteHash(anim[6])
    anim[5].dispose
    return true
  end
  anim[1]+=1
  return false
end


# ---------------------------------------------------------------
# Other
# ---------------------------------------------------------------

def pbSpeedUpMessage(speed)
  $game_variables[UI_ARRAY] = [] if !$game_variables[UI_ARRAY].is_a?(Array)
  for anim in $game_variables[UI_ARRAY]
    if anim[0] == UIType::SPEEDUP
      anim[2] = speed
      anim[1] = false
      return
    end
  end
  pbTriggerUI(UIType::SPEEDUP, [speed])
end

def pbUI_SpeedUpMessage(anim)
  if anim[1]==false
    anim[1]=0
  end
  frame = anim[1]
  speed = anim[2]
  if anim.length < 6
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[4] = viewport
    sprites = {}
    anim[5] = sprites
  end
  viewport = anim[4]
  sprites = anim[5]
  if frame < Graphics.frame_rate
    if !sprites["speedup"]
      sprites["speedup"]=IconSprite.new(Graphics.width-52,2,viewport)
      sprites["speedup"].setBitmap("Graphics/Pictures/speed_up")
      sprites["speedup"].src_rect = Rect.new(50*speed,0,50,34)
    end
    sprites["speedup"].src_rect.x = 50*speed
    sprites["speedup"].opacity = 255
  elsif sprites["speedup"].opacity <= 0
    pbDisposeSpriteHash(anim[5])
    anim[4].dispose
    return true
  elsif frame >= Graphics.frame_rate
    new_opacity = 255 - (frame - Graphics.frame_rate)*20
    sprites["speedup"].opacity = new_opacity < 0 ? 0 : new_opacity
  end
  anim[1]+=1
  return false
end



def pbTitleDisplay(title, subtitle=nil)
  anim = [0,false]
  anim[1]=0 if anim[1]==false
  frame = anim[1]
  quest = anim[2]
  if anim.length < 4
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    anim[3] = viewport
    sprites = {}
    anim[4] = sprites
  end
  viewport = anim[3]
  sprites = anim[4]
  while frame < 20
    frame+=1
    if !sprites["shadowl"]
      sprites["shadowl"] = Sprite.new(viewport)
      sprites["shadowl"].bitmap=RPG::Cache.load_bitmap("","Graphics/Messages/ui_shadow_left")
      sprites["shadowl"].y=Graphics.height/2-sprites["shadowl"].bitmap.height/2
      sprites["shadowl"].x=-Graphics.width
    end
    if !sprites["shadowr"]
      sprites["shadowr"] = Sprite.new(viewport)
      sprites["shadowr"].bitmap=RPG::Cache.load_bitmap("","Graphics/Messages/ui_shadow_right")
      sprites["shadowr"].y=Graphics.height/2-sprites["shadowl"].bitmap.height/2
      sprites["shadowr"].x=Graphics.width
    end
    sprites["shadowl"].x+=Graphics.width/20
    sprites["shadowr"].x-=Graphics.width/20
    pbWait(1)
  end
  write1 = 0
  write2 = 0
  while frame >= 20 && frame < 100
    frame+=1
    display = subtitle
    write1 += 1 if write1 < title.length
    if display!=nil
      write2 += 1 if write1 >= title.length && write2 < display.length
    end
    if !sprites["display"]
      sprites["display"] = Sprite.new(viewport)
      sprites["display"].z = 1
      sprites["display"].bitmap = BitmapWrapper.new(Graphics.width,Graphics.height)
      pbSetSystemFont(sprites["display"].bitmap)
    end
    textx=Graphics.width/2
    texty=Graphics.height/2-34
    texty2=Graphics.height/2+4
    sprites["display"].bitmap.clear
    if display!=nil
      textpos=[[title[0..write1],textx,texty,2,Color.new(255, 255, 255),Color.new(168, 184, 184)]]
      if write1 >= title.length
        textpos.push([display[0..write2],textx,Graphics.height/2,2,Color.new(255, 255, 255),Color.new(168, 184, 184)])
      end
    else
      textpos=[[title[0..write1],textx,(texty+texty2)/2,2,Color.new(255, 255, 255),Color.new(168, 184, 184)]]
    end
    pbDrawTextPositions(sprites["display"].bitmap,textpos)
    pbWait(1)
  end
  pbFadeOutAndHide(sprites)
  pbDisposeSpriteHash(anim[4])
  anim[3].dispose
  return true
end

def pbAddLineBreaks(text,bitmap)
  stops = " .,!?:;"
  ret = ""
  while bitmap.text_size(text).width > 160
    line = ""
    while bitmap.text_size(line).width < 160
      if text.include?(" ")
        line += text[0..text.index(" ")]
        text = text[text.index(" ")+1..text.length-1]
      else
        line += text
        text = ""
      end
    end
    ret += line
    text += "<br>"
  end
  ret += text
  return ret
end

class Window_AdvancedTextPokemon < SpriteWindow_Base
  
  def setTextSilent(text)
    @text=text
  end
  
  def redrawSimple(value)
    @waitcount=0
    @curchar=0
    @drawncurchar=-1
    @lastDrawnChar=-1
    oldtext=@text
    @text=value
    @textlength=unformattedTextLength(value)
    @scrollstate=0
    @scrollY=0
    @linesdrawn=0
    @realframes=0
    @textchars=[]
    width=1
    height=1
    numlines=0
    visiblelines=(self.height-self.borderY)/32
    if value.length==0
      @fmtchars=[]
      @bitmapwidth=width
      @bitmapheight=height
      @numtextchars=0
    else
      @fmtchars=[]
      fmt=getFormattedTextFast(self.contents,0,0,
         self.width-self.borderX-SpriteWindow_Base::TEXTPADDING,-1,
         shadowctag(@baseColor,@shadowColor)+value,32,true)
      @oldfont=self.contents.font.clone
      for ch in fmt
        chx=ch[1]+ch[3]
        chy=ch[2]+ch[4]
        width=chx if width<chx
        height=chy if height<chy
        # Don't add newline characters, since they
        # can slow down letter-by-letter display
        if ch[5] || (ch[0]!="\r")
          @fmtchars.push(ch)
          @textchars.push(ch[5] ? "" : ch[0])
        end
      end
      fmt.clear
    end
    @bitmapwidth=width
    @bitmapheight=height
    @numtextchars=@textchars.length
    stopPause
    @needclear=true
    refresh
  end
  
end





