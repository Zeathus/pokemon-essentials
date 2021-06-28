def pbShowQuests2(show_quest=nil)
  main_quests=[]
  side_quests=[]
  if !$game_variables[QUEST_MAIN].is_a?(Array)
    $game_variables[QUEST_MAIN]=[]
  end
  if !$game_variables[QUEST_ARRAY].is_a?(Array)
    $game_variables[QUEST_ARRAY]=[]
  end
  for quest in $game_variables[QUEST_MAIN]
    if quest.status>=0 || $DEBUG
      main_quests.push(quest)
    end
  end
  for quest in $game_variables[QUEST_ARRAY]
    if quest.status>=0 || $DEBUG
      side_quests.push(quest)
    end
  end
  main_quests = pbSortQuests(main_quests)
  side_quests = pbSortQuests(side_quests)
  if $game_variables[CURRENTMINIQUEST].is_a?(MiniQuest)
    side_quests = [$game_variables[CURRENTMINIQUEST]] + side_quests
  end
  no_prev = true
  
  viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z = 99999
  text_color1 = Color.new(250, 250, 250)
  text_color2 = Color.new(50, 50, 100)
  text_color4 = Color.new(100, 50, 50)#Color.new(144, 80, 80)
  
  questtab = $game_variables[LAST_PAGE]
  newtab = questtab
  selected = 0
  scroll = 0
  quest_list = main_quests if questtab==0
  quest_list = side_quests if questtab==1
  
  sprites={}
  file = _INTL("Graphics/Pictures/quests_1") if questtab==0
  file = _INTL("Graphics/Pictures/quests_2") if questtab==1
  sprites["bg"] = Sprite.new(viewport)
  sprites["bg"].bitmap = BitmapCache.load_bitmap(file)
  
  sprites["tabs"]=Sprite.new(viewport)
  sprites["tabs"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
  pbSetSystemFont(sprites["tabs"].bitmap)
  sprites["tabs"].bitmap.clear
  sprites["tabs"].z=3
  textpos=[["Main",139,62,2,text_color1,text_color2],
           ["Side",373,62,2,text_color1,text_color2]]
  pbDrawTextPositions(sprites["tabs"].bitmap,textpos)
  
  sprites["cursor"]=Sprite.new(viewport)
  file = _INTL("Graphics/Scenes/Quests/cursor2")
  sprites["cursor"].bitmap=BitmapCache.load_bitmap(file)
  sprites["cursor"].x=228
  sprites["cursor"].y=100
  sprites["cursor"].z=3
  
  sprites["scrollbar"]=Sprite.new(viewport)
  file = _INTL("Graphics/Pictures/questsScrollbar")
  sprites["scrollbar"].bitmap=BitmapCache.load_bitmap(file)
  sprites["scrollbar"].x=470
  sprites["scrollbar"].y=100
  sprites["scrollbar"].z=3
  
  for i in 0..6
    file = _INTL("Graphics/Pictures/quests_available")
    sprites[_INTL("status{1}",i)]=Sprite.new(viewport)
    sprites[_INTL("status{1}",i)].bitmap=BitmapCache.load_bitmap(file)
    sprites[_INTL("status{1}",i)].x=24
    sprites[_INTL("status{1}",i)].y=101+(i*30)
    sprites[_INTL("status{1}",i)].z=3
  end
  
  sprites["quests"] = Sprite.new(viewport)
  sprites["quests"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
  pbSetSmallFont(sprites["quests"].bitmap)
  textpos = []
  for i in scroll..(scroll+6)
    offset = (i-scroll) * 30
    if i < quest_list.length
      textpos += [[quest_list[i].name,60,102+offset,false,text_color1,text_color4]]
      if quest_list[i].status==2
        file = _INTL("Graphics/Pictures/quests_complete")
        sprites[_INTL("status{1}",i-scroll)].bitmap=BitmapCache.load_bitmap(file)
      elsif quest_list[i].status==1
        file = _INTL("Graphics/Pictures/quests_active")
        sprites[_INTL("status{1}",i-scroll)].bitmap=BitmapCache.load_bitmap(file)
      else
        file = _INTL("Graphics/Pictures/quests_available")
        sprites[_INTL("status{1}",i-scroll)].bitmap=BitmapCache.load_bitmap(file)
      end
    else
      file = _INTL("Graphics/Pictures/quests_empty")
      sprites[_INTL("status{1}",i)].bitmap=BitmapCache.load_bitmap(file)
    end
  end
  pbDrawTextPositions(sprites["quests"].bitmap,textpos)
  
  sprites["queststep"] = Sprite.new(viewport)
  sprites["queststep"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
  pbSetSmallFont(sprites["queststep"].bitmap)
  sprites["queststep"].bitmap.clear
  sprites["queststep"].z=3
  sprites["questmap"] = Sprite.new(viewport)
  file = _INTL("Graphics/Pictures/quests_map")
  sprites["questmap"].bitmap=BitmapCache.load_bitmap(file)
  sprites["questmap"].z=3
  sprites["questmap"].x=285
  sprites["questmap"].y=204
  sprites["questflag"] = Sprite.new(viewport)
  file = _INTL("Graphics/Pictures/quest_marker/marker_0")
  sprites["questflag"].bitmap=BitmapCache.load_bitmap(file)
  sprites["questflag"].z=3
  if quest_list[selected]
    quest = quest_list[selected]
    if quest.status==1 && quest.mapguide[quest.step]
      sprites["questmap"].visible=true
      sprites["questflag"].visible=true
      sprites["questflag"].x=280+5*quest.mapguide[quest.step][0]
      sprites["questflag"].y=199+5*quest.mapguide[quest.step][1]
    else
      sprites["questmap"].visible=false
      sprites["questflag"].visible=false
    end
    quest_step = quest_list[selected].pbGetStepDescription
    textpos=[]
    lines=pbLineBreakText(sprites["queststep"].bitmap,quest_step,200,8)
    for line in 0...lines.length
      textpos += [[lines[line],260,102+line*20,false,text_color1,text_color4]]
    end
    pbDrawTextPositions(sprites["queststep"].bitmap,textpos)
  else
    sprites["questmap"].visible=false
    sprites["questflag"].visible=false
  end
  
  pbFadeInAndShow(sprites)
  
  jump_to_quest = false
  jump_to_index = -1
  jump_to_page  = -1
  if show_quest
    for i in 0...main_quests.length
      if main_quests[i].name == show_quest.name && main_quests[i].id == show_quest.id
        jump_to_quest = true
        jump_to_index = i
        jump_to_page = 0
      end
    end
    for i in 0...side_quests.length
      if side_quests[i].name == show_quest.name && side_quests[i].id == show_quest.id
        jump_to_quest = true
        jump_to_index = i
        jump_to_page = 1
      end
    end
  end
  
  flag_timer = 0
  update_timer = 0
  scroll_timer = 0
  scroll_dir = ""
  fast_scroll = false
  font_size = 10
  loop do
    Graphics.update
    Input.update
    viewport.update
    update = false
    if Input.press?(Input::DOWN) && scroll_dir=="down"
      scroll_timer+=1
      if scroll_timer>=30
        fast_scroll=true
        scroll_dir = "do_down"
      end
    elsif Input.press?(Input::UP) && scroll_dir=="up"
      scroll_timer+=1
      if scroll_timer>=30
        fast_scroll=true
        scroll_dir = "do_up"
      end
    else
      scroll_timer = 0
    end
    if Input.trigger?(Input::DOWN) || scroll_dir=="do_down"
      scroll_timer = 0 if !fast_scroll
      scroll_timer = 25 if fast_scroll
      scroll_dir = "down"
      selected += 1
      scroll += 1 if selected > (scroll+6)
      if selected>quest_list.length-1
        if fast_scroll
          selected = quest_list.length-1
          scroll = quest_list.length-7 if quest_list.length > 6
        else
          selected = 0
          scroll = 0
        end
      end
      fast_scroll=false
      update = true
    elsif Input.trigger?(Input::UP) || scroll_dir=="do_up"
      scroll_timer = 0 if !fast_scroll
      scroll_timer = 25 if fast_scroll
      scroll_dir = "up"
      selected -= 1
      scroll -= 1 if selected < scroll 
      if selected < 0
        if fast_scroll
          selected = 0
          scroll = 0
        else
          selected = quest_list.length-1
          if selected > (scroll+6) && quest_list.length > 6
            scroll = quest_list.length-7
          else
            scroll = 0
          end
        end
      end
      fast_scroll=false
      update = true
    elsif Input.trigger?(Input::LEFT)
      selected = 0 if newtab == 1
      scroll = 0 if newtab == 1
      newtab = 0
      update = true
    elsif Input.trigger?(Input::RIGHT)
      selected = 0 if newtab == 0
      scroll = 0 if newtab == 0
      newtab = 1
      update = true
    elsif Input.trigger?(Input::B)
      viewport.dispose
      break
    elsif Input.trigger?(Input::A)
      method=[
        "Status",
        "Alphabetical",
        "Location"
      ][$game_variables[QUEST_SORTING]]
      Kernel.pbMessage(_INTL("What to sort by?\nCurrently: {1}{2}",method,
        "\\ch[1,4,Status,Alphabetical,Location,Cancel]"))
      if pbGet(1)<=2
        $game_variables[QUEST_SORTING]=pbGet(1)
        pbSortQuests(main_quests)
        pbSortQuests(side_quests)
        update = true
      end
    elsif $DEBUG && Input.trigger?(Input::C)
      if Input.press?(Input::CTRL)
        new_status = pbNumericUpDown(
          "Choose new quest status", -1, 2, quest_list[selected].status)
          quest_list[selected].status = new_status
      else
        new_step = pbNumericUpDown(
          "Choose new quest step", 0, quest_list[selected].steps.length-1,
        quest_list[selected].step)
        quest_list[selected].step = new_step
      end
    end
    update_timer+=1
    if update_timer>4
      update=true
      update_timer=0
    end
    if update || jump_to_quest
      if jump_to_quest
        jump_to_quest = false
        newtab = jump_to_page
        selected = jump_to_index
        scroll += selected - 6 if selected > 6
      end
      if newtab == 0
        questtab = newtab
        file = _INTL("Graphics/Pictures/quests_1")
        sprites["bg"].bitmap = BitmapCache.load_bitmap(file)
        quest_list = main_quests
      elsif newtab == 1
        questtab = newtab
        file = _INTL("Graphics/Pictures/quests_2")
        sprites["bg"].bitmap = BitmapCache.load_bitmap(file)
        quest_list = side_quests
      elsif newtab == 2
        questtab = newtab
        file = _INTL("Graphics/Pictures/quests_3")
        sprites["bg"].bitmap = BitmapCache.load_bitmap(file)
        quest_list = spec_quests
      end
      sprites["cursor"].x = 228
      sprites["cursor"].y = 100+(selected-scroll)*30
      sprites["scrollbar"].y=100
      if quest_list.length > 7 && scroll > 0
        sprites["scrollbar"].y+=(148*scroll/(quest_list.length-7))
      end
      sprites["quests"].bitmap.clear
      textpos = []
      for i in scroll..(scroll+6)
        offset = (i-scroll) * 30
        if i < quest_list.length
          if quest_list[i].hidden && quest_list[i].hidden >= 1 && quest_list[i].status == 0
            name = ""
            for t in 0...quest_list[i].name.length
              if quest_list[i].name[t..t] == " "
                name += " "
              else
                name += "?"
              end
            end
            textpos += [[name,60,102+offset,false,text_color1,text_color4]]
          else
            textpos += [[quest_list[i].name,60,102+offset,false,text_color1,text_color4]]
          end
          if quest_list[i].status==2
            file = _INTL("Graphics/Pictures/quests_complete")
            sprites[_INTL("status{1}",i-scroll)].bitmap=BitmapCache.load_bitmap(file)
          elsif quest_list[i].status==1
            file = _INTL("Graphics/Pictures/quests_active")
            sprites[_INTL("status{1}",i-scroll)].bitmap=BitmapCache.load_bitmap(file)
          elsif quest_list[i].status==0
            file = _INTL("Graphics/Pictures/quests_available")
            sprites[_INTL("status{1}",i-scroll)].bitmap=BitmapCache.load_bitmap(file)
          elsif quest_list[i].status==-1
            file = _INTL("Graphics/Pictures/quests_unavailable")
            sprites[_INTL("status{1}",i-scroll)].bitmap=BitmapCache.load_bitmap(file)
          end
        else
          file = _INTL("Graphics/Pictures/quests_empty")
          sprites[_INTL("status{1}",i)].bitmap=BitmapCache.load_bitmap(file)
        end
      end
      pbDrawTextPositions(sprites["quests"].bitmap,textpos)
      
      sprites["queststep"].bitmap.clear
      if quest_list[selected]
        quest = quest_list[selected]
        if quest.status==1 && quest.mapguide[quest.step]
          sprites["questmap"].visible=true
          sprites["questflag"].visible=true
          sprites["questflag"].x=280+5*quest.mapguide[quest.step][0]
          sprites["questflag"].y=199+5*quest.mapguide[quest.step][1]
          flag_timer+=1
          if flag_timer>=10
            flag_timer=0
          end
          file = _INTL("Graphics/Pictures/quest_marker/marker_0")
          if flag_timer>=0 && flag_timer<6
            file = _INTL("Graphics/Pictures/quest_marker/marker_{1}",flag_timer.to_s)
          end
          sprites["questflag"].bitmap=BitmapCache.load_bitmap(file)
        else
          sprites["questmap"].visible=false
          sprites["questflag"].visible=false
        end
        quest_step = quest_list[selected].pbGetStepDescription
        textpos=[]
        lines=pbLineBreakText(sprites["queststep"].bitmap,quest_step,200,8)
        for line in 0...lines.length
          textpos += [[lines[line],260,102+line*20,false,text_color1,text_color4]]
        end
        #pbSetSystemFont(sprites["queststep"].bitmap)
        #sprites["queststep"].bitmap.font.bold = true
        #sprites["queststep"].bitmap.font.name = "MS PGothic"
        #sprites["queststep"].bitmap.font.size = font_size#15
        pbDrawTextPositions(sprites["queststep"].bitmap,textpos)
      else
        sprites["questmap"].visible=false
        sprites["questflag"].visible=false
      end
    end
  end
  pbFadeOutAndHide(sprites)
  pbDisposeSpriteHash(sprites)
  viewport.dispose
end