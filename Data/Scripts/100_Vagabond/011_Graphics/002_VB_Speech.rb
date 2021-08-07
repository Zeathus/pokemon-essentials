class PokemonTemp
  attr_accessor :textSize
end

def pbTextEffect(type, startc=false, endc=false, speed=false)
  
  type = type.downcase
  
  if speed
    $game_system.message_effect=[type,startc,endc,speed]
  elsif endc
    $game_system.message_effect=[type,startc,endc]
  elsif startc
    $game_system.message_effect=[type,startc]
  else
    $game_system.message_effect=[type]
  end
  
end

def pbText(text)
  pbSpeech("none", "none", text)
end

def pbFormat(phrase)
  
  #Removing automatic line breaks
  phrase.gsub!("\n","")
  
  #Place player name safely (no crash if not defined)
  begin
    phrase.gsub!("PLAYER",$Trainer.name)
  rescue
    phrase.gsub!("PLAYER","(player name undefined!)")
  end
  
  phrase.gsub!("DRAGON","Vahirom")
  
  #Replacing text variables
  phrase.gsub!("MONEY","\\G")
  phrase.gsub!("BREAK","\\n")
  phrase.gsub!("WTNP","\\wtnp[20]")
  phrase.gsub!("WT","\\wt[10]")
  phrase.gsub!("STP","\\!")
  if $Trainer
    if $PokemonSystem.genderid==2
      phrase.gsub!("XE is","they are")
      phrase.gsub!("XE has","they have")
      phrase.gsub!("XE's","they're")
      phrase.gsub!("XE'S","they've")
      phrase.gsub!("XE","they")
      phrase.gsub!("XIM","them")
      phrase.gsub!("XIS","their")
      phrase.gsub!("GENDER","person")
    elsif ($Trainer.gender==0 && $PokemonSystem.genderid==0) ||
          ($Trainer.gender==1 && $PokemonSystem.genderid==1)
      phrase.gsub!("XE'S","XE's")
      phrase.gsub!("XE","he")
      phrase.gsub!("XIM","him")
      phrase.gsub!("XIS","his")
      phrase.gsub!("GENDER","boy")
    else
      phrase.gsub!("XE'S","XE's")
      phrase.gsub!("XE","she")
      phrase.gsub!("XIM","her")
      phrase.gsub!("XIS","her")
      phrase.gsub!("GENDER","girl")
    end
  end
  
  phrase.gsub!("[R]","[r]")
  phrase.gsub!("[G]","[g]")
  phrase.gsub!("[B]","[b]")
  phrase.gsub!("[Y]","[y]")
  phrase.gsub!("[P]","[p]")
  phrase.gsub!("[O]","[o]")
  phrase.gsub!("[W]","[w]")
  
  if $game_system.message_position!=1 && $game_system.message_frame!=1
    phrase.gsub!("[r]","<c2=043c3aff>")
    phrase.gsub!("[g]","<c2=06644bd2>")
    phrase.gsub!("[b]","<c2=65467b14>")
    phrase.gsub!("[y]","<c2=129B43DF>")
    phrase.gsub!("[p]","<c2=7C1F7EFF>")
    phrase.gsub!("[o]","<c2=017F473F>")
    phrase.gsub!("[w]","<c2=296B5EF5>")
  else
    phrase.gsub!("[r]","<c2=3aff043c>")
    phrase.gsub!("[g]","<c2=4bd20664>")
    phrase.gsub!("[b]","<c2=7b146546>")
    phrase.gsub!("[y]","<c2=43DF129B>")
    phrase.gsub!("[p]","<c2=7EFF7C1F>")
    phrase.gsub!("[o]","<c2=473F017F>")
    phrase.gsub!("[w]","<c2=7FFF2D49>")
  end
  
  phrase.gsub!("[/R]","[/]")
  phrase.gsub!("[/G]","[/]")
  phrase.gsub!("[/B]","[/]")
  phrase.gsub!("[/Y]","[/]")
  phrase.gsub!("[/O]","[/]")
  phrase.gsub!("[/r]","[/]")
  phrase.gsub!("[/g]","[/]")
  phrase.gsub!("[/b]","[/]")
  phrase.gsub!("[/y]","[/]")
  phrase.gsub!("[/o]","[/]")
  phrase.gsub!("[/]","</c2>")
  
  if phrase.include?("[RBOW]") && phrase.include?("[/RBOW]")
    start_index = phrase.index("[RBOW]") + 6
    end_index = phrase.index("[/RBOW]")
    
    color1 = Color.new(255,0,0)
    color2 = Color.new(255,170,170)
    
    old_str = phrase[start_index...end_index]
    new_str = ""
    
    if $game_system.message_effect && $game_system.message_effect[0]=="wavebow"
      hue_step = (360 / old_str.length).ceil
    else
      hue_step = (340 / old_str.length).ceil
    end
    
    for i in 0...old_str.length
      new_str += "<c2="
      new_str += colorToRgb16(pbHueShift(color1,-i*hue_step)).to_s
      new_str += colorToRgb16(pbHueShift(color2,-i*hue_step)).to_s
      new_str += ">"
      new_str += old_str[i..i]
      new_str += "</c2>"
    end
    
    phrase.gsub!("[RBOW]"+old_str+"[/RBOW]",new_str)
    
  end
  
  if phrase.include?("[RBOW2]") && phrase.include?("[/RBOW2]")
    start_index = phrase.index("[RBOW2]") + 7
    end_index = phrase.index("[/RBOW2]")
    
    color1 = Color.new(255,0,0)
    color2 = Color.new(255,170,170)
    
    old_str = phrase[start_index...end_index]
    new_str = ""
    
    hue_step = 360 / 12
    
    for i in 0...old_str.length
      new_str += "<c2="
      new_str += colorToRgb16(pbHueShift(color1,-i*hue_step)).to_s
      new_str += colorToRgb16(pbHueShift(color2,-i*hue_step)).to_s
      new_str += ">"
      new_str += old_str[i..i]
      new_str += "</c2>"
    end
    
    phrase.gsub!("[RBOW2]"+old_str+"[/RBOW2]",new_str)
    
  end
  
  #Placing variables
  for i in 100..150
    var = _INTL("VAR{1}",i.to_s)
    out = _INTL("\\v[{1}]",i.to_s)
    phrase.gsub!(var,out)
  end
  for i in 10..99
    var = _INTL("VAR{1}",i.to_s)
    out = _INTL("\\v[{1}]",i.to_s)
    phrase.gsub!(var,out)
  end
  for i in 1..9
    var = _INTL("VAR{1}",i.to_s)
    out = _INTL("\\v[{1}]",i.to_s)
    phrase.gsub!(var,out)
  end
  
  return phrase
  
end

def pbSpeech(name, emotion="neutral", phrase=nil, unknown=false, choices=nil)
  if phrase==nil
    phrase = name
    for event in $game_map.events.values
      name = event.name if @event_id == event.id
    end
  end
  
  player = false
  if name == "PLAYER"
    name = $Trainer.name
    player = true
  end
  
  phrase = pbFormat(phrase)
  
  #Getting the window type
  window_type = getTextWindow(name)
  if window_type
    phrase = _INTL("{1}{2}", "\\w[" + window_type + "]", phrase)
  end
  
  #Defining the viewport
  viewport_y = $game_system.message_position==0 ? -22 : 142
  viewport=Viewport.new(0,viewport_y,Graphics.width,Graphics.height)
  viewport.z=99999
  
  #Checking if portrait exists
  if !name.downcase.include?("sign") && $game_system.message_position==2 &&
     $game_system.message_frame!=1
    imgname = name.downcase
    if imgname == "nekane" && $game_variables && $game_variables[NEKANE_STATE]>0
      imgname = _INTL("nekane{1}",$game_variables[NEKANE_STATE])
    end
    file=_INTL("Graphics/Messages/Faces/portrait_{1}_{2}",imgname,emotion)
    if name.include?("?")
      filename = name + ""
      filename.gsub!("?","")
      file=_INTL("Graphics/Messages/Faces/portrait_{1}_{2}",filename,emotion)
    end
    backup=_INTL("Graphics/Messages/Faces/portrait_{1}_neutral",imgname)
    face=Sprite.new(viewport)
    if pbResolveBitmap(file)
      #Showing the portrait
      face.bitmap=RPG::Cache.load_bitmap("",file)
    elsif pbResolveBitmap(backup) && emotion != "none"
      #Showing neutral portrait if emotion isn't found
      face.bitmap=RPG::Cache.load_bitmap("",backup)
    end
    face.x = (SPEECH_DISPLAY_LEFT.include?(name)) ? 50 : 490
    face.y = 158
  end
  
  #Checks if the message is a sign
  if !name.downcase.include?("sign") && !name.downcase.include?("none") &&
     $game_system.message_position!=1 && $game_system.message_frame!=1
    #Showing the box for the name
    name_box=Sprite.new(viewport)
    file="Graphics/Messages/name_box"
    name_box.bitmap=RPG::Cache.load_bitmap("",file)
    name_box.x = (SPEECH_DISPLAY_LEFT.include?(name) || $game_system.message_position==0) ? 326 : 94
    name_box.y = 256

    #Showing the name
    sprites={}
    sprites["name"]=Sprite.new(viewport)
    sprites["name"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
    sprites["name"].z=1
    pbSetSystemFont(sprites["name"].bitmap)
    bitmap=sprites["name"].bitmap
    bitmap.clear
    #Switches name if unknown
    name2 = name
    name2 = "???" if unknown == true
    textx = (SPEECH_DISPLAY_LEFT.include?(name) || $game_system.message_position==0) ? 404 : 172
    texty = name_box.y + 6
    textpos=[[name2,textx,texty,2,getCharColor(name, 1),Color.new(0,0,0),1]]
    pbDrawTextPositions(bitmap,textpos)
  end
  
  color = "<c2="
  if $game_system.message_position!=1 && $game_system.message_frame!=1
    color += colorToRgb16(getCharColor(name, 0)).to_s
    color += colorToRgb16(getCharColor(name, 1)).to_s
  else
    color += colorToRgb16(getCharColor(name, 1)).to_s
    color += colorToRgb16(getCharColor(name, 0)).to_s
  end
  color += ">"
  
  if choices != nil
    phrase+="\\ch[1,"
    phrase+=choices.length.to_s
    for choice in choices
      phrase+=","
      phrase+=choice
    end
    phrase+="]"
  end
  
  pbMessage(_INTL("{1}{2}</c2>",color,phrase))
  $game_system.message_effect = false
  
  pbDisposeSpriteHash(sprites)
  viewport.dispose
  if choices != nil
    return $game_variables[1]
  end
end

def pbShout(name, emotion="neutral", phrase=nil, unknown=false)
  if phrase==nil
    phrase = name
    for event in $game_map.events.values
      name = event.name if @event_id == event.id
    end
  end
  #Removing automatic line breaks
  phrase.gsub!("\n","")
  
  #Replacing text variables
  command = "\\wt[20]"
  command = "\\wtnp[20]" if phrase.include?("WTNP")
  phrase.gsub!("WTNP","")
  
  #Placing variables
  for i in 100..150
    var = _INTL("VAR{1}",i.to_s)
    out = _INTL("\\v[{1}]",i.to_s)
    phrase.gsub!(var,out)
  end
  for i in 10..99
    var = _INTL("VAR{1}",i.to_s)
    out = _INTL("\\v[{1}]",i.to_s)
    phrase.gsub!(var,out)
  end
  for i in 1..9
    var = _INTL("VAR{1}",i.to_s)
    out = _INTL("\\v[{1}]",i.to_s)
    phrase.gsub!(var,out)
  end
  
  #Making it a sign if name == "Sign"
  if name == "Sign"
    phrase = _INTL("{1}{2}", "\\w[sign]", phrase)
  end
  
  #Defining the viewport
  viewport=Viewport.new(0,142,Graphics.width,Graphics.height)
  viewport.z=99999
  
  #Checking if portrait exists
  file=_INTL("Graphics/Messages/Faces/portrait_{1}_{2}",name,emotion)
  backup=_INTL("Graphics/Messages/Faces/portrait_{1}_neutral",name)
  face=Sprite.new(viewport)
  if pbResolveBitmap(file)
    #Showing the portrait
    face.bitmap=RPG::Cache.load_bitmap("",file)
  elsif pbResolveBitmap(backup) && emotion != "none"
    #Showing neutral portrait if emotion isn't found
    face.bitmap=RPG::Cache.load_bitmap("",backup)
  end
  face.x = (SPEECH_DISPLAY_LEFT.include?(name)) ? 50 : 490
  face.y = 158
  
  #Checks if the message is a sign
  if !name.downcase.include?("sign") && $game_system.message_position==2
    #Showing the box for the name
    name_box=Sprite.new(viewport)
    file="Graphics/Messages/name_box"
    name_box.bitmap=RPG::Cache.load_bitmap("",file)
    name_box.x = (SPEECH_DISPLAY_LEFT.include?(name)) ? 326 : 94
    name_box.y = 256
  
    #Showing the name
    @sprites={}
    @sprites["name"]=Sprite.new(viewport)
    @sprites["name"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
    @sprites["name"].z=1
    pbSetSystemFont(@sprites["name"].bitmap)
    bitmap=@sprites["name"].bitmap
    bitmap.clear
    #Switches name if unknown
    name2 = name
    name2 = "???" if unknown == true
    textx = (SPEECH_DISPLAY_LEFT.include?(name)) ? 404 : 172
    texty = name_box.y + 6
    textpos=[[name2,textx,texty,2,getCharColor(name, 1),Color.new(0,0,0),true]]
    pbDrawTextPositions(bitmap,textpos)
  end
  
  viewport2=Viewport.new(10,200,Graphics.width,Graphics.height)
  viewport2.z=999999
  
  @sprites["text"]=Sprite.new(viewport2)
  @sprites["text"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
  pbSetSystemFont(@sprites["text"].bitmap)
  @sprites["text"].bitmap.font.size=52
  @sprites["text"].bitmap.clear
  textpos = [[phrase,128,274,false,getCharColor(name,0),getCharColor(name,1)]]
  
  $PokemonTemp.textSize = 4
  pbDrawTextPositions(@sprites["text"].bitmap,textpos)
  $PokemonTemp.textSize = 2

  pbSEPlay("Damage1",100,100)
  $game_screen.start_shake(2, 25, 10)
  pbMessage(command)
  
  pbDisposeSpriteHash(@sprites)
  viewport.dispose
  viewport2.dispose
end

def pbShowUnownText(text)
  text.gsub!("\n","")
  showtext = ""
  alpha = "abcdefghijklmnopqrstuvwxyz!?"
  size1 = "aijlprtvyz!?"
  size2 = "bdefgkqx"
  size3 = "chmnosuw"
  length = 0
  for i in 0..text.length-1
    char = text[i..i]
    char = char.downcase
    if alpha.include?(char)
      length += 12 if size1.include?(char)
      length += 16 if size2.include?(char)
      length += 20 if size3.include?(char)
      char = "qmark" if char == "?"
      showtext += _INTL("<icon=unown_{1}>",char)
    else
      if char == " " && length >= 340
        showtext += " \n"
        length = 0
      else
        showtext += char
        showtext += " " if char == " "
        length += 8
      end
    end
  end
  showtext += " "
  Kernel.pbMessage(showtext)
end

def pbStartCutscene
  $PokemonSystem.old_fps = Graphics.frame_rate
  $PokemonSystem.lock_fps = true
  Graphics.frame_rate = 60
end

def pbEndCutscene
  $PokemonSystem.lock_fps = false
  Graphics.frame_rate = $PokemonSystem.old_fps
end

def pbDoubleSpeech(name,emotion,phrase,name2,phrase2)
  
  phrase = "\\wd" + phrase
  phrase2 = "\\wu" + phrase2
  
  thr = Thread.new {
    pbSpeech(name2,"none",phrase2)
  }
  pbSpeech(name, emotion, phrase)
  thr.join
  
end






