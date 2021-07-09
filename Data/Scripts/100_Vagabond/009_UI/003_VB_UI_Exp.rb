def pbEXPScreen(expgain,sharedexp,fulltoall=false)
  
  return if $game_switches[DISABLE_EXP]
  
  if expgain > 0 || sharedexp > 0
    
    if $game_variables[PLAYER_EXP] < 10**3
      # Set player level to 10 if not set yet
      $game_variables[PLAYER_EXP] = 10**3
    end
    if pbPlayerLevel < 100
      $game_variables[PLAYER_EXP] += (expgain + sharedexp) * 0.35
    end
    
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z = 99999
    
    active = []
    inactive = []
    for i in 0...PBParty.len
      if hasPartyMember(i)
        if isPartyMemberActive(i)
          active.push(i)
        else
          inactive.push(i)
        end
      end
    end
    
    newexp_active = []
    newexp_inactive = []
    levelups_active = []
    levelups_inactive = []
    
    shared_factor = fulltoall ? 0.5 : 0.3
    shared_mul = (0.5 * active.length) + (shared_factor * inactive.length)
    shared_mul = (shared_mul / (active.length + inactive.length)).ceil
    
    highest_level = 0
    for i in $Trainer.party
      highest_level = i.level if i.level > highest_level
    end
    
    #### Active Party level up calcs
    levelup = false
    for i in 0...active.length
      party = getPartyPokemon(active[i])
      newexp_active[i] = []
      levelups = [i]
      for j in 0...party.length
        thispoke = party[j]
        growthrate = thispoke.growthrate
        
        exp = ((expgain * 0.5) + (sharedexp * shared_mul)).ceil
        
        if isConst?(thispoke.item,PBItems,:LUCKYEGG)
          exp = (exp * 1.5).ceil
        end
        
        # Boost exp for underleveled Pokemon in Player's party
        if thispoke.level < (highest_level - 2) && $Trainer.party.include?(thispoke)
          exp = (exp * 1.5).ceil
        end
        
        newexp=PBExperience.pbAddExperience(thispoke.exp,exp,growthrate)
        newexp_active[i][j] = newexp
        
        newlevel=PBExperience.pbGetLevelFromExperience(newexp,growthrate)
        if newlevel > thispoke.level
          levelup = true
          levelups.push(j)
        else
          thispoke.exp=newexp
        end
      end
      if levelups.length > 1
        levelups_active.push(levelups)
      end
    end
    
    #### Inactive Party level up calcs
    for i in 0...inactive.length
      party = getPartyPokemon(inactive[i])
      newexp_inactive[i] = []
      levelups = [i+active.length]
      for j in 0...party.length
        thispoke = party[j]
        growthrate = thispoke.growthrate
        
        exp = ((expgain * 0.3) + (sharedexp * shared_mul)).ceil
        
        if isConst?(thispoke.item,PBItems,:LUCKYEGG)
          exp = (exp * 1.5).ceil
        end
        
        newexp=PBExperience.pbAddExperience(thispoke.exp,exp,growthrate)
        newexp_inactive[i][j] = newexp
        
        newlevel=PBExperience.pbGetLevelFromExperience(newexp,growthrate)
        if newlevel > thispoke.level
          levelup = true
          levelups.push(j)
        else
          thispoke.exp=newexp
        end
      end
      if levelups.length > 1
        levelups_inactive.push(levelups)
      end
    end
    
    if levelup
      
      #### Title
      sprites = {}
      sprites["levelup"] = IconSprite.new(0,-26,viewport)
      sprites["levelup"].setBitmap("Graphics/Pictures/expscreen_levelup")
      sprites["levelup"].src_rect=Rect.new(0,0,512,148)
      sprites["levelup"].z=10
      
      # Text colors
      base = Color.new(252,252,252)
      shadow = Color.new(0,0,0)
      
      # Speed up hint
      sprites["hint"] = Sprite.new(viewport)
      sprites["hint"].bitmap = Bitmap.new(120,60)
      sprites["hint"].x = 400
      sprites["hint"].y = 300
      sprites["hint"].z = 10
      sprites["hint"].opacity = 0
      textpos=[["X:",10,20,0,base,shadow,1],
               ["Fast",30,12,0,base,shadow,1],
               ["Forward",30,28,0,base,shadow,1]]
      pbSetSmallFont(sprites["hint"].bitmap)
      pbDrawTextPositions(sprites["hint"].bitmap,textpos)
    
      20.times do
        Graphics.update
        Input.update
      end
      
      pbSEPlay("Up")
      28.times do |i|
        if i % 4 == 0
          sprites["levelup"].src_rect.y += 148
        end
        sprites["levelup"].update
        sprites["hint"].opacity = (i-10) * 16
        viewport.update
        Graphics.update
        Input.update
      end
      
      if !Input.press?(Input::B)
        16.times do
          Graphics.update
          Input.update
        end
      end
      
      # Misc data needed for display
      active_all = active + inactive
      newexp_all = newexp_active + newexp_inactive
      levelups_all = levelups_active + levelups_inactive
      numlines = levelups_all.length
      spacing = 80
      startx = 256 - (spacing * (numlines-1) / 2)
      
      #### Display party lines
      for i in 0...levelups_all.length
        party = levelups_all[i]
        partyindex = party[0]
        
        linesprite = IconSprite.new(startx + spacing * i - 52, 0, viewport)
        linesprite.setBitmap("Graphics/Pictures/expscreen_party")
        linesprite.src_rect = Rect.new(0,384*active_all[partyindex],104,384)
        linesprite.z = 8
        sprites[_INTL("line{1}",partyindex)]=linesprite
        
        type = PBParty.getTrainerType(active_all[partyindex])
        charsprite = IconSprite.new(0, 0, viewport)
        charsprite.setBitmap(sprintf("Graphics/Characters/trchar%03d",type))
        charsprite.src_rect = Rect.new(0,0,charsprite.bitmap.width/4,charsprite.bitmap.height/4)
        charsprite.x = startx + spacing * i - charsprite.bitmap.width / 8
        charsprite.y = 192 - charsprite.bitmap.height / 4
        charsprite.z = 9
        charsprite.opacity = 0
        sprites[_INTL("char{1}",partyindex)]=charsprite
        
        pbSEPlay("Saint3")
        if !Input.press?(Input::B)
          24.times do |k|
            if k % 4 == 0
              linesprite.src_rect.x += 104
              charsprite.y -= (24 - k) / 2
              charsprite.opacity = 16 * k
            end
            linesprite.update
            charsprite.update
            viewport.update
            Graphics.update
            Input.update
          end
        else
          6.times do |k|
            linesprite.src_rect.x += 104
            charsprite.y -= (6 - k) * 2
            charsprite.opacity = 64 * k
            linesprite.update
            charsprite.update
            viewport.update
            Graphics.update
            Input.update
          end
        end
        
        6.times do
          Graphics.update
          Input.update
        end
        
      end
      
      #### Display and level up pokemon
      for i in 0...levelups_all.length
        party = levelups_all[i]
        partyindex = party[0]
        
        for j in 1...party.length
          # Get pokemon
          pkmnindex = party[j]
          thispoke = getPartyPokemon(active_all[partyindex])[pkmnindex]
          
          # Get pokemon icon sprite
          params=[thispoke.species,thispoke.gender,0,thispoke.form]
          filename = pbCheckPokemonIconFiles(params)
          
          # Appearance Animation
          sprite = IconSprite.new(startx+spacing*i-32,192,viewport)
          sprite.setBitmap(filename)
          sprite.src_rect=Rect.new(0,0,64,64)
          sprite.opacity = 0
          sprite.z = 9
          sprites[_INTL("pkmn{1}_{2}",partyindex,pkmnindex)]=sprite
          
          lvlsprite = Sprite.new(viewport)
          lvlbitmap = Bitmap.new(80,40)
          lvlsprite.bitmap = lvlbitmap
          lvlsprite.opacity = 0
          lvlsprite.x = startx+spacing*i-40
          lvlsprite.y = 170
          lvlsprite.z = 10
          sprites[_INTL("lvl{1}_{2}",partyindex,pkmnindex)]=lvlsprite
          
          textpos=[["Lv."+thispoke.level.to_s,40,10,2,base,shadow,1]]
          pbSetSmallFont(lvlbitmap)
          pbDrawTextPositions(lvlbitmap,textpos)
          
          if !Input.press?(Input::B)
            18.times do |k|
              if k % 4 == 0
                sprite.y -= (16 - k) / 2
                sprite.opacity = 16 * k
                lvlsprite.y -= (16 - k) / 2
                lvlsprite.opacity = 16 * k
              end
              sprite.update
              lvlsprite.update
              viewport.update
              Graphics.update
              Input.update
            end
          else
            9.times do |k|
              if k % 2 == 0
                sprite.y -= (16 - k * 2) / 2
                sprite.opacity = 32 * k
                lvlsprite.y -= (16 - k * 2) / 2
                lvlsprite.opacity = 32 * k
              end
              sprite.update
              lvlsprite.update
              viewport.update
              Graphics.update
              Input.update
            end
          end
          
          if !Input.press?(Input::B)
            10.times do
              Graphics.update
              Input.update
            end
          end
          
          # Level up
          growthrate = thispoke.growthrate
          newexp = newexp_all[partyindex][pkmnindex]
          newlevel = PBExperience.pbGetLevelFromExperience(newexp,growthrate)
          while thispoke.level < newlevel
            tmpexp = PBExperience.pbGetStartExperience(thispoke.level+1,growthrate)
            thispoke.exp = tmpexp
            
            # Level Animation
            lvlbitmap.clear
            textpos=[["Lv."+thispoke.level.to_s,40,10,2,base,shadow,1]]
            pbSetSmallFont(lvlbitmap)
            pbDrawTextPositions(lvlbitmap,textpos)
            
            pbSEPlay("expfull")
            if !Input.press?(Input::B)
              frames = [-6,-4,-2,0,0,2,4,6]
              16.times do |i|
                if i % 2 == 0
                  sprite.y += frames[i / 2]
                  lvlsprite.y += frames[i / 2]
                end
                sprite.update
                lvlsprite.update
                viewport.update
                Graphics.update
                Input.update
              end
              
              10.times do
                Graphics.update
                Input.update
              end
            else
              frames = [-8,-4,0,0,4,8]
              6.times do |i|
                sprite.y += frames[i]
                lvlsprite.y += frames[i]
                sprite.update
                lvlsprite.update
                viewport.update
                Graphics.update
                Input.update
              end
            end
            
            # Learn Moves
            movelist=thispoke.getMoveList
            for k in movelist
              if k[0]==thispoke.level   # Learned a new move
                pbLearnMove(thispoke,k[1],true)
              end
            end
            
            # Evolve
            newspecies = pbCheckEvolution(thispoke)
            if newspecies > 0
              20.times do
                Graphics.update
                Input.update
              end
              pbFadeOutInWithMusic(99999){
                evo=PokemonEvolutionScene.new
                evo.pbStartScreen(thispoke,newspecies)
                evo.pbEvolution
                evo.pbEndScreen
              }
              # Update icon
              if newspecies == thispoke.species
                params=[newspecies,thispoke.gender,0,thispoke.form]
                filename = pbCheckPokemonIconFiles(params)
                sprite.setBitmap(filename)
                sprite.src_rect=Rect.new(0,0,64,64)
                sprite.update
              end
              20.times do
                Graphics.update
                Input.update
              end
            end
          end
          thispoke.exp = newexp
          
          # Hide if there are more pokemon
          if i < party.length - 1
            if !Input.press?(Input::B)
              18.times do |i|
                if i % 4 == 0
                  sprite.y -= (16 - i) / 2
                  sprite.opacity = 256 - 16 * i
                  lvlsprite.y -= (16 - i) / 2
                  lvlsprite.opacity = 256 - 16 * i
                end
                sprite.update
                lvlsprite.update
                viewport.update
                Graphics.update
                Input.update
              end
            else
              
            9.times do |i|
              if i % 2 == 0
                sprite.y -= (16 - i * 2) / 2
                sprite.opacity = 256 - 32 * i
                lvlsprite.y -= (16 - i * 2) / 2
                lvlsprite.opacity = 256 - 32 * i
              end
              sprite.update
              lvlsprite.update
              viewport.update
              Graphics.update
              Input.update
            end
            end
          end
          
        end
      end
      
      for member in active + inactive
        for i in getPartyPokemon(member)
          i.calc_stats
        end
      end
      
      pbFadeOutAndHide(sprites)
      pbDisposeSpriteHash(sprites)
      
    end
    
  end
end

# EXPMODE - -1:None, 0:Smart, 1:Even, 2:Manual

def pbGrantExpScreen(exp)
  if $PokemonSystem.expmode==-1
    Kernel.pbMessage("Completing quests will grant experience points for your Pokémon.")
    loop do
      Kernel.pbMessage(_INTL("How would you like experience to be distributed?{1}",
        "\\ch[1,0,Smart,Even,Manual]"))
        $PokemonSystem.expmode=$game_variables[1]
      case $game_variables[1]
      when 0
        Kernel.pbMessage("With smart experience distribution, the amount of experience a Pokémon receives is determined by its growth rate.")
        Kernel.pbMessage("Lower level Pokémon will also get more experience in favor of higher level Pokémon.")
      when 1
        Kernel.pbMessage("With even experience distribution all party members will gain an equal amount of experience.")
      when 2
        Kernel.pbMessage("With manual experience distribution, you can manually distribute experience how you want.")
      end
      Kernel.pbMessage("Is this okay?\\ch[1,2,Yes,No]")
      if $game_variables[1]==0
        Kernel.pbMessage("Experience distribution can be changed in options later too.")
        break
      end
    end
  end
  
  no_room = true
  for pkmn in $Trainer.party
    no_room = false if pkmn.level<100
  end
  if no_room
    Kernel.pbMessage("No Pokémon can receive any experience.")
    return
  end
  
  viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z = 99999
  text_color1 = Color.new(250, 250, 250)
  text_color2 = Color.new(50, 50, 50)
  
  sprites={}
  file = _INTL("Graphics/Scenes/expgrant")
  sprites["bg"] = Sprite.new(viewport)
  sprites["bg"].bitmap = RPG::Cache.load_bitmap("",file)
  
  slot_file = "Graphics/Scenes/expgrant_auto"
  slot_file = "Graphics/Scenes/expgrant_manual" if $PokemonSystem.expmode==2
  
  for i in 0...$Trainer.party.length
    sprites[_INTL("slot{1}",i)] = Sprite.new(viewport)
    sprites[_INTL("slot{1}",i)].bitmap = RPG::Cache.load_bitmap("",slot_file)
    sprites[_INTL("slot{1}",i)].x = 80
    sprites[_INTL("slot{1}",i)].y = 2 + 60 * i
    
    sprites[_INTL("icon{1}",i)] = PokemonIconSprite.new($Trainer.party[i],viewport)
    sprites[_INTL("icon{1}",i)].x = 112
    sprites[_INTL("icon{1}",i)].y = 60 * i - 4
    sprites[_INTL("icon{1}",i)].z = 3
  end
  
  pbFadeInAndShow(sprites)
  
  exp_gain = []
  
  if $PokemonSystem.expmode==2
    sprites["cursor"] = Sprite.new(viewport)
    slot_file = "Graphics/Scenes/expgrant_selected"
    sprites["cursor"].bitmap = RPG::Cache.load_bitmap("",slot_file)
    sprites["cursor"].x = 80
    sprites["cursor"].y = 2
    sprites["cursor"].z = 2
    sprites["levels"] = Sprite.new(viewport)
    sprites["levels"].bitmap = BitmapWrapper.new(Graphics.width,Graphics.height)
    pbSetSystemFont(sprites["levels"].bitmap)
    sprites["levels"].z = 3
    init_levels = []
    new_levels = []
    for pkmn in $Trainer.party
      init_levels.push(pkmn.level)
      new_levels.push(pkmn.level)
      exp_gain.push(0)
    end
    selected = 0
    last_input = ""
    loop do
      Graphics.update
      Input.update
      viewport.update
      if Input.repeat?(Input::LEFT)
        growthrate=$Trainer.party[selected].growthrate
        startexp=PBExperience.pbGetStartExperience($Trainer.party[selected].level,growthrate)
        endexp=PBExperience.pbGetStartExperience($Trainer.party[selected].level+1,growthrate)
        exp_gain[selected]-=((endexp-startexp)/30).floor
        exp_gain[selected]=0 if exp_gain[selected]<0
      elsif Input.repeat?(Input::RIGHT)
        growthrate=$Trainer.party[selected].growthrate
        startexp=PBExperience.pbGetStartExperience($Trainer.party[selected].level,growthrate)
        endexp=PBExperience.pbGetStartExperience($Trainer.party[selected].level+1,growthrate)
        exp_gain[selected]+=((endexp-startexp)/30).floor if new_levels[selected]<100 && init_levels[selected]<100
        exp_gain_sum = 0
        for i in exp_gain
          exp_gain_sum+=i
        end
        while exp_gain_sum > exp
          exp_gain[selected]-=1
          exp_gain_sum=0
          for i in exp_gain
            exp_gain_sum+=i
          end
        end
      else
        last_input = ""
      end
      for i in 0...$Trainer.party.length
        sprites[_INTL("icon{1}",i)].update
      end
      textpos=[]
      sprites["cursor"].y = 2 + 60 * selected
      sprites["levels"].bitmap.clear
      for i in 0...$Trainer.party.length
        if $Trainer.party[i].level<PBExperience::MAXLEVEL
          new_levels[i] = init_levels[i]
          exp_mod = 0
          growthrate=$Trainer.party[i].growthrate
          startexp=PBExperience.pbGetStartExperience($Trainer.party[i].level,growthrate)
          endexp=PBExperience.pbGetStartExperience($Trainer.party[i].level+1,growthrate)
          addedexp = (($Trainer.party[i].exp+exp_gain[i]-startexp)*128/(endexp-startexp)).floor
          while ($Trainer.party[i].exp+exp_gain[i]-startexp)>=(endexp-startexp)
            new_levels[i]+=1
            if new_levels[i]<100
              exp_mod+=(endexp-startexp)
              level_dif = new_levels[i] - init_levels[i]
              startexp=PBExperience.pbGetStartExperience($Trainer.party[i].level+level_dif,growthrate)
              endexp=PBExperience.pbGetStartExperience($Trainer.party[i].level+level_dif+1,growthrate)
              addedexp = (($Trainer.party[i].exp+exp_gain[i]-startexp)*128/(endexp-startexp)).floor
            else
              new_levels[i]=100
              addedexp = 0
              exp_gain[i]=PBExperience.pbGetStartExperience(100,growthrate)-$Trainer.party[i].exp
              break
            end
          end
          sprites["levels"].bitmap.fill_rect(294,16+i*60,addedexp,2,Color.new(160,72,120))
          sprites["levels"].bitmap.fill_rect(294,18+i*60,addedexp,4,Color.new(248,24,144))
          if new_levels[i]==init_levels[i]
            expgauge = (($Trainer.party[i].exp-startexp)*128/(endexp-startexp)).floor
            expgauge = 0 if ($Trainer.party[i].exp-startexp)<=0
            sprites["levels"].bitmap.fill_rect(294,16+i*60,expgauge,2,Color.new(72,120,160))
            sprites["levels"].bitmap.fill_rect(294,18+i*60,expgauge,4,Color.new(24,144,248))
          end
          exp_text = ($Trainer.party[i].exp+exp_gain[i]-startexp).to_s + "/" + (endexp-startexp).to_s
          exp_text = "Max" if new_levels[i]==100 || init_levels[i]==100
          textpos+=[[exp_text,252,28+i*60,false,text_color1,text_color2]]
        end
        textpos+=[[init_levels[i].to_s,216,2+i*60,false,text_color1,text_color2]]
        textpos+=[[new_levels[i].to_s,216,28+i*60,false,text_color1,text_color2]]
      end
      exp_gain_sum = 0
      for i in exp_gain
        exp_gain_sum+=i
      end
      exp_remain = (exp - exp_gain_sum).floor
      pbDrawTextPositions(sprites["levels"].bitmap,textpos)
      textpos=[["Exp. Remaining: " + exp_remain.to_s,256,358,2,text_color1,text_color2]]
      pbSetSmallFont(sprites["levels"].bitmap)
      pbDrawTextPositions(sprites["levels"].bitmap,textpos)
      pbSetSystemFont(sprites["levels"].bitmap)
      if Input.trigger?(Input::UP)
        selected -= 1 if selected > 0
      elsif Input.trigger?(Input::DOWN)
        selected += 1 if selected < $Trainer.party.length - 1
      elsif Input.trigger?(Input::BACK) || Input.trigger?(Input::USE)
        exp_gain_sum=0
        for i in exp_gain
          exp_gain_sum+=i
        end
        all_100 = true
        for i in 0...$Trainer.party.length
          all_100 = false if exp_gain[i]<PBExperience.pbGetStartExperience(100,growthrate)-$Trainer.party[i].exp
        end
        if exp_gain_sum < exp.floor && !all_100
          exp_remain = (exp - exp_gain_sum).floor
          Kernel.pbMessage("You still have " + exp_remain.to_s + " exp. remaining.")
          Kernel.pbMessage("This exp. will be lost if you exit.\nIs this okay?\\ch[1,0,Yes,No]")
          if $game_variables[1]==0
            break
          end
        else
          Kernel.pbMessage("Is this distribution fine?\\ch[1,2,Yes,No]")
          if $game_variables[1]==0
            break
          end
        end
      end
    end
    sprites["cursor"].dispose
    sprites["levels"].dispose
  end
  
  slot_file = "Graphics/Scenes/expgrant_auto"
  
  for i in 0...$Trainer.party.length
    sprites[_INTL("slot{1}",i)].bitmap = RPG::Cache.load_bitmap("",slot_file)
    sprites[_INTL("slot{1}",i)].x = 80
    sprites[_INTL("slot{1}",i)].y = 2 + 60 * i
  end
  
  if $PokemonSystem.expmode>=0
    init_levels = []
    for pkmn in $Trainer.party
      init_levels.push(pkmn.level)
    end
    if $PokemonSystem.expmode==1
      exp_split = (exp / $Trainer.party.length).floor
      for pkmn in $Trainer.party
        exp_gain.push(exp_split)
      end
    elsif $PokemonSystem.expmode==0
      growth_sum = 0.0
      level_sum = 0
      for pkmn in $Trainer.party
        level_sum+=pkmn.level
        growthrate=pkmn.growthrate
        growth_sum += 600000.0 if growthrate==1
        growth_sum += 800000.0 if growthrate==4
        growth_sum += 1000000.0 if growthrate==0
        growth_sum += 1059860.0 if growthrate==3
        growth_sum += 1250000.0 if growthrate==5
        growth_sum += 1640000.0 if growthrate==2
      end
      level_avg = level_sum/$Trainer.party.length
      exp_per_growth = exp * 1.0 / growth_sum
      for pkmn in $Trainer.party
        growthrate=pkmn.growthrate
        max_exp = 1000000
        max_exp = 600000 if growthrate==1
        max_exp = 800000 if growthrate==4
        max_exp = 1000000 if growthrate==0
        max_exp = 1059860 if growthrate==3
        max_exp = 1250000 if growthrate==5
        max_exp = 1640000 if growthrate==2
        multiplier = 2.00-(pkmn.level*1.00/level_avg)
        multiplier = 0 if multiplier < 0
        this_exp_gain=max_exp*exp_per_growth*multiplier
        exp_gain.push(this_exp_gain)
      end
    end
    current = 0
    exp_gained = 0
    per_frame = (exp/200).floor
    per_frame = 1 if per_frame < 1
    loop do
      Graphics.update
      Input.update
      viewport.update
      for i in 0...$Trainer.party.length
        sprites[_INTL("icon{1}",i)].update
      end
      textpos=[]
      if sprites["levels"]
        sprites["levels"].dispose
      end
      if $Trainer.party[current].level>=100
        exp_gained=exp_gain[current]
      end
      sprites["levels"] = Sprite.new(viewport)
      sprites["levels"].bitmap = BitmapWrapper.new(Graphics.width,Graphics.height)
      pbSetSystemFont(sprites["levels"].bitmap)
      sprites["levels"].bitmap.clear
      sprites["levels"].z=3
      for i in 0...$Trainer.party.length
        if $Trainer.party[i].level<PBExperience::MAXLEVEL
          growthrate=$Trainer.party[i].growthrate
          startexp=PBExperience.pbGetStartExperience($Trainer.party[i].level,growthrate)
          endexp=PBExperience.pbGetStartExperience($Trainer.party[i].level+1,growthrate)
          expgauge = (($Trainer.party[i].exp-startexp+per_frame)*128/(endexp-startexp)).floor
          expgauge = 0 if ($Trainer.party[i].exp-startexp)<=0
          sprites["levels"].bitmap.fill_rect(294,16+i*60,expgauge,2,Color.new(72,120,160))
          sprites["levels"].bitmap.fill_rect(294,18+i*60,expgauge,4,Color.new(24,144,248))
          exp_text = ($Trainer.party[i].exp-startexp).to_s + "/" + (endexp-startexp).to_s
          if ($Trainer.party[i].exp-startexp+per_frame)>=(endexp-startexp)
            exp_text = (endexp-startexp).to_s + "/" + (endexp-startexp).to_s
          end
          textpos+=[[exp_text,252,28+i*60,false,text_color1,text_color2]]
        end
        textpos+=[[$Trainer.party[i].level.to_s,216,14+i*60,false,text_color1,text_color2]]
      end
      pbDrawTextPositions(sprites["levels"].bitmap,textpos)
      pokemon = $Trainer.party[current]
      if exp_gained < exp_gain[current]
        exp_gained += per_frame
        pokemon.exp += per_frame
        if pokemon.level > init_levels[current]
          init_levels[current]+=1
          growthrate=pokemon.growthrate
          startexp=PBExperience.pbGetStartExperience(pokemon.level,growthrate)
          exp_gained-=(pokemon.exp-startexp)
          pokemon.changeHappiness("level up")
          pokemon.calc_stats
          pbSEPlay("expfull",100,100)
          Kernel.pbMessage(_INTL("{1} was elevated to Level {2}!",pokemon.name,pokemon.level))
          movelist=pokemon.getMoveList
          for i in movelist
            if i[0]==pokemon.level          # Learned a new move
              pbLearnMove(pokemon,i[1],true)
            end
          end
          newspecies=pbCheckEvolution(pokemon)
          if newspecies>0
            pbFadeOutInWithMusic(99999){
            evo=PokemonEvolutionScene.new
            evo.pbStartScreen(pokemon,newspecies)
            evo.pbEvolution
            evo.pbEndScreen
            }
            sprites[_INTL("icon{1}",current)].dispose
            sprites[_INTL("icon{1}",current)] = PokemonIconSprite.new($Trainer.party[current],viewport)
            sprites[_INTL("icon{1}",current)].x = 112
            sprites[_INTL("icon{1}",current)].y = 56 * current
          end
        end
      else
        if current < $Trainer.party.length - 1
          current += 1
          exp_gained = 0
        else
          break
        end
      end
    end
  end
  exp_gain_total = 0
  for i in exp_gain
    exp_gain_total+=i
  end
  pbWait(20)
  pbFadeOutAndHide(sprites)
  pbDisposeSpriteHash(sprites)
  viewport.dispose
end

def pbAddExpField(pokemon, exp, scene)
  initlevel = pokemon.level
  for e in 1..exp
    pokemon.exp = pokemon.exp + 1
    if pokemon.level > initlevel
      newlevel = pokemon.level
      levelchange = newlevel - initlevel
      pokemon.level = newlevel - levelchange
      pbChangeLevel(pokemon,newlevel,scene)
      initlevel = newlevel
    end
  end
  Kernel.pbMessage(_INTL("{1} gained {2} experience.", pokemon.name, exp.to_s))
end