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

def pbFormat(phrase)
  
  #Removing automatic line breaks
  phrase.gsub!("\n","")
  
  #Place player name safely (no crash if not defined)
  begin
    phrase.gsub!("PLAYER",$Trainer.name)
  rescue
    phrase.gsub!("PLAYER","(player name undefined!)")
  end
  
  #Replacing text variables
  phrase.gsub!("<MONEY>","\\G")
  phrase.gsub!("<BR>","\\n")
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
  
  return phrase
  
end

def pbTalk(text, opts={})
  format_text = pbFormat(text)

  window_type = opts["window_type"]
  speaker = opts["speaker"]
  speaker = nil if speaker == "none"
  name_tag = opts["name_tag"] || speaker
  name_tag = $Trainer.name if name_tag == "PLAYER"
  namepos = opts["namepos"] || ["right", "center", "left"][$game_system.message_position]
  portrait = opts["portrait"] || speaker
  emotion = opts["emotion"] || "neutral"
  hide_name = opts["hide_name"] || 0
  shout = opts["shout"]
  textpos = opts["textpos"]
  lines = opts["lines"] || 3

  # Only show portrait if message boxes are at the bottom and frame visible
  if $game_system.message_position != 2 ||
     $game_system.message_frame == 1 ||
     text.include?("\\ch[")
    portrait = nil
  end

  # Set speaker character specific properties if there is one
  if speaker
    window_type = getTextWindow(speaker) if !window_type
  end

  # Defining the viewport
  viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z = 999999
  sprites = {}

  color = nil
  if speaker
    color = "<c2="
    if $game_system.message_frame != 1
      color += colorToRgb16(getCharColor(speaker, 0)).to_s
      color += colorToRgb16(getCharColor(speaker, 1)).to_s
    else
      color += colorToRgb16(getCharColor(speaker, 1)).to_s
      color += colorToRgb16(getCharColor(speaker, 0)).to_s
    end
    color += ">"
  end

  if opts["choices"]
    choices = opts["choices"]
    format_text += "\\ch[1,"
    format_text += choices.length.to_s
    for choice in choices
      format_text += ","
      format_text += choice
    end
    format_text += "]"
  end

  format_text = _INTL("\\l[{1}]{2}", lines, format_text) if lines != 3 && !shout

  window_height = 32 * (lines + 1)

  # Create portrait sprite
  if portrait && emotion && emotion != "none"
    file = _INTL("Graphics/Messages/Faces/portrait_{1}_{2}", portrait.downcase, emotion.downcase)
    backup = _INTL("Graphics/Messages/Faces/portrait_{1}_{2}", portrait.downcase, "neutral")
    final_file = nil
    if pbResolveBitmap(file)
      final_file = file
    elsif pbResolveBitmap(backup)
      final_file = backup
    end
    if final_file
      sprites["portrait"] = IconSprite.new(0, 0, viewport)
      sprites["portrait"].setBitmap(final_file)
      sprites["portrait"].x = (namepos == "right") ? 50 : 490
      sprites["portrait"].y = Graphics.height - window_height - sprites["portrait"].bitmap.height + 2
    end
  end

  # Create name tag sprite
  if name_tag && hide_name != 2
    # Background
    sprites["namebox"] = IconSprite.new(0, 0, viewport)
    sprites["namebox"].setBitmap("Graphics/Messages/name_box")
    case namepos
    when "left"
      sprites["namebox"].x = 94
    when "center"
      sprites["namebox"].x = Graphics.width / 2 - sprites["namebox"].bitmap.width / 2
    when "right"
      sprites["namebox"].x = 520
    end
    case $game_system.message_position
    when 0
      sprites["namebox"].y = window_height - 16
    when 1
      sprites["namebox"].y = Graphics.height / 2 - window_height / 2 - 48
    when 2
      sprites["namebox"].y = Graphics.height - window_height - 48
    end
    sprites["namebox"].z = 1
    # Actual Name
    sprites["name"] = Sprite.new(viewport)
    sprites["name"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    sprites["name"].z = 2
    pbSetSystemFont(sprites["name"].bitmap)
    sprites["name"].bitmap.clear
    text_x = sprites["namebox"].x + sprites["namebox"].bitmap.width / 2
    text_y = sprites["namebox"].y + 10
    textpos = [[(hide_name == 0 ? name_tag : "???"), text_x, text_y, 2, getCharColor(name_tag, 1), Color.new(0, 0, 0), 1]]
    pbDrawTextPositions(sprites["name"].bitmap, textpos)
  end

  if !shout
    # Apply formatting for text
    if textpos
      if textpos == "center"
        format_text = _INTL("<ac>{1}</ac>", format_text)
      elsif textpos == "right"
        format_text = _INTL("<ar>{1}</ar>", format_text)
      else
        format_text = _INTL("<al>{1}</al>", format_text)
      end
    end
    format_text = _INTL("{1}{2}</c2>", color, format_text) if color
    format_text = _INTL("\\w[{1}]{2}", window_type, format_text) if window_type
    
    pbMessage(format_text)
    $game_system.message_effect = false
  else
    # Real textbox has commands only, actual message is drawn manually
    command = ""
    if format_text.downcase.include?("\\wtnp")
      temp_text = format_text[(format_text.index("\\wtnp"))...format_text.length]
      temp_text = temp_text[0..temp_text.index("]")]
      command = temp_text
      format_text = format_text[0...format_text.index(temp_text)] +
        format_text[(format_text.index(temp_text)+temp_text.length)...format_text.length]
    end
    command = _INTL("\\w[{1}]{2}", window_type, command) if window_type
    command = _INTL("\\l[{1}]{2}", lines, command) if lines != 3
    
    # Create actual text
    sprites["text"] = Sprite.new(viewport)
    sprites["text"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    pbSetSystemFont(sprites["text"].bitmap)
    sprites["text"].bitmap.font.size = 52
    sprites["text"].bitmap.clear
    text_y = 0
    case $game_system.message_position
    when 0
      text_y = window_height / 2 - 36
    when 1
      text_y = Graphics.height / 2 - 36
    when 2
      text_y = Graphics.height - window_height / 2 - 36
    end
    textpos = [[format_text, 128, text_y, false, getCharColor(speaker, 0), getCharColor(speaker, 1)]]
    sprites["text"].z = 3

    $PokemonTemp.textSize = 4
    pbDrawTextPositions(sprites["text"].bitmap,textpos)
    $PokemonTemp.textSize = 2
    
    pbSEPlay("Damage1",100,100)
    $game_screen.start_shake(2, 25, 10)
    pbMessage(command)

  end

  pbDisposeSpriteHash(sprites)
  viewport.dispose
end

def pbText(text)
  pbTalk(text)
end

def pbSpeech(name, emotion="neutral", phrase=nil, unknown=false, choices=nil, opts={})
  name = "none" if !name
  emotion = "none" if !emotion

  if phrase==nil
    phrase = name
    for event in $game_map.events.values
      name = event.name if @event_id == event.id
    end
  end
  
  opts = {}
  opts["speaker"] = name
  opts["emotion"] = emotion
  opts["choices"] = choices if choices
  opts["hide_name"] = 1 if unknown

  pbTalk(phrase, opts)
end

def pbShout(name, emotion="neutral", phrase=nil, unknown=false)
  if phrase==nil
    phrase = name
    for event in $game_map.events.values
      name = event.name if @event_id == event.id
    end
  end

  opts = {}
  opts["speaker"] = name
  opts["emotion"] = emotion
  opts["hide_name"] = 1 if unknown
  opts["shout"] = true

  pbTalk(phrase, opts)
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






