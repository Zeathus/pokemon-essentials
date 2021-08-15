class PokeBarSmallSprite < SpriteWrapper
  attr_reader :selected
  attr_reader :preselected
  attr_reader :switching
  attr_reader :pokemon
  attr_reader :active
  attr_accessor :text

  def initialize(pokemon,trainerid,index,viewport=nil)
    super(viewport)
    pokemon = nil if !pokemon || pokemon == 0
    @viewport = viewport
    @pokemon=pokemon
    @trainerid = trainerid
    @index=index
    @barbitmap=AnimatedBitmap.new("Graphics/Pictures/Party/bar_small")
    @other = (index % 2) == 1
    @spriteXOffset=@other ? 70 : 2
    @spriteYOffset=0
    @statusX=@other ? 56 : 36
    @statusY=@other ? 4 : 18
    @gaugeX=@other ? 10 : 42
    @gaugeY=@other ? 22 : 8
    @xvalue = -2
    @yvalues=[]
    @ystart = 142
    for i in 0...6
      if i % 2 == 0
        @yvalues.push(@ystart + 27 * i)
      else
        @yvalues.push(@ystart + 27 * (i - 1) + 20)
      end
    end
    @statuses=AnimatedBitmap.new(_INTL("Graphics/Pictures/Party/statuses_small"))
    @pkmnsprite=PokemonIconSprite.new(pokemon,viewport)
    @pkmnsprite.active=false
    @pkmnsprite.zoom_x = 0.5
    @pkmnsprite.zoom_y = 0.5
    @spriteX=@xvalue
    @spriteY=@yvalues[@index]
    @pkmnsprite.z=self.z+2
    self.x=@spriteX
    self.y=@spriteY
    refresh
  end

  def dispose
    @barbitmap.dispose
    @statuses.dispose
    @pkmnsprite.dispose
    self.bitmap.dispose
    super
  end
  
  def setValues(pokemon, trainerid)
    pokemon = nil if !pokemon || pokemon == 0
    @pokemon = pokemon
    @trainerid = trainerid
    if @pkmnsprite && !@pkmnsprite.disposed?
      @pkmnsprite.pokemon = pokemon
    end
    refresh
  end
  
  def pokemon=(value)
    @pokemon=value
    if @pkmnsprite && !@pkmnsprite.disposed?
      @pkmnsprite.pokemon=value
    end
    refresh
  end
  
  def hp
    return @pokemon.hp
  end

  def refresh
    return if disposed?
    if !self.bitmap || self.bitmap.disposed?
      self.bitmap=BitmapWrapper.new(@barbitmap.width,@barbitmap.height)
    end
    if @pkmnsprite && !@pkmnsprite.disposed?
      @pkmnsprite.x=self.x+@spriteXOffset
      @pkmnsprite.y=self.y+@spriteYOffset
    end
    self.bitmap.clear if self.bitmap
    return if !@pokemon
    self.bitmap.blt(0,0,@barbitmap.bitmap,Rect.new(@other ? 106 : 0,36 * @trainerid,106,36))
    if @pokemon && !@pokemon.egg?
      tothp=@pokemon.totalhp
      hpgauge=@pokemon.totalhp==0 ? 0 : (self.hp*54/@pokemon.totalhp)
      hpgauge=1 if hpgauge==0 && self.hp>0
      hpzone=0
      hpzone=1 if self.hp<=(@pokemon.totalhp/2).floor
      hpzone=2 if self.hp<=(@pokemon.totalhp/4).floor
      hpcolors=[
         Color.new(14,152,22),Color.new(24,192,32),   # Green
         Color.new(202,138,0),Color.new(232,168,0),   # Orange
         Color.new(218,42,36),Color.new(248,72,56)    # Red
      ]
      # fill with HP color
      self.bitmap.fill_rect(@gaugeX,@gaugeY,hpgauge,2,hpcolors[hpzone*2])
      self.bitmap.fill_rect(@gaugeX,@gaugeY+2,hpgauge,2,hpcolors[hpzone*2+1])
      self.bitmap.fill_rect(@gaugeX,@gaugeY+4,hpgauge,2,hpcolors[hpzone*2])
      if @pokemon.hp==0 || @pokemon.status != :NONE
        status=(@pokemon.hp==0) ? 5 : (GameData::Status.get(@pokemon.status).id_number - 1)
        statusrect=Rect.new(0,14*status,14,14)
        self.bitmap.blt(@statusX,@statusY,@statuses.bitmap,statusrect)
      else
        textpos = [[_INTL("HP"),@statusX - (@other ? -2 : 2),@statusY - 6,false,Color.new(252,252,252),nil]]
        pbSetSmallestFont(self.bitmap)
        pbDrawTextPositions(self.bitmap,textpos,false)
      end
    end
  end

  def update
    super
    if @pkmnsprite && !@pkmnsprite.disposed? && @pokemon
      @pkmnsprite.update
      @pkmnsprite.x=self.x+@spriteXOffset
      @pkmnsprite.y=self.y+@spriteYOffset
    end
  end
end


def pbPauseMenu
  return if !$game_switches || $game_switches[LOCK_PAUSE_MENU]
  viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z=99999
  midx=Graphics.width/2
  midy=Graphics.height/2-16
  sprites={}
  sprites["topDisplay"]=Sprite.new(viewport)
  file="Graphics/Pictures/Pause/topDisplay"
  sprites["topDisplay"].bitmap=RPG::Cache.load_bitmap("",file)
  sprites["topDisplay"].x=0
  sprites["topDisplay"].y=-128
  sprites["topDisplay"].z=0
  sprites["topOverlay"]=Sprite.new(viewport)
  sprites["topOverlay"].bitmap=Bitmap.new(640,128)
  sprites["topOverlay"].x=-64
  sprites["topOverlay"].y=-128
  sprites["topOverlay"].z=1
  sprites["topMainIcon"]=Sprite.new(viewport)
  sprites["topMainIcon"].bitmap=Bitmap.new(256,128)
  sprites["topMainIcon"].x=128
  sprites["topMainIcon"].y=-128
  sprites["topMainIcon"].z=2
  sprites["topInfo"]=Sprite.new(viewport)
  sprites["topInfo"].bitmap=Bitmap.new(512,128)
  sprites["topInfo"].x=0
  sprites["topInfo"].y=-128
  sprites["topInfo"].z=3
  
  # Party Summary
  sprites["partyHeader"]=Sprite.new(viewport)
  file="Graphics/Pictures/Party/header_small"
  sprites["partyHeader"].bitmap=RPG::Cache.load_bitmap("",file)
  sprites["partyHeader"].x=-130
  sprites["partyHeader"].y=120
  trainerid = getPartyActive(0)
  otherid = getPartyActive(1)
  party = getPartyPokemon(trainerid)
  otherparty = getPartyPokemon(otherid)
  for i in 0...3
    sprites[_INTL("pokemon{1}",i*2)]=PokeBarSmallSprite.new(party[i], trainerid, i*2, viewport)
    if otherid >= 0
      sprites[_INTL("pokemon{1}",i*2+1)]=PokeBarSmallSprite.new(otherparty[i], otherid, i*2+1, viewport)
    else
      sprites[_INTL("pokemon{1}",i*2+1)]=Sprite.new(viewport)
    end
  end
  
  for i in 0...6
    sprites[_INTL("pokemon{1}",i)].x -= 128
    sprites[_INTL("pokemon{1}",i)].update
  end
  
  # Area Map
  draw_minimap = false
  if draw_minimap
    tilew = 2
    tileh = 2
    areaBitmap = Bitmap.new($game_map.width * tilew, $game_map.height * tileh)
    colorPassable = Color.new(250,250,250)
    colorGrass = Color.new(30,200,30)
    colorSolid = Color.new(40,40,40)
    colorWater = Color.new(40,40,250)
    for y in 0...$game_map.height
      for x in 0...$game_map.width
        tag = $game_map.terrain_tag(x,y)
        if PBTerrain.isAnyGrass?(tag)
          areaBitmap.fill_rect(x*tilew,y*tileh,tilew,tileh,colorGrass)
        elsif $game_map.passable?(x,y,2) ||
              $game_map.passable?(x,y,4) ||
              $game_map.passable?(x,y,6) ||
              $game_map.passable?(x,y,8)
          areaBitmap.fill_rect(x*tilew,y*tileh,tilew,tileh,colorPassable)
        elsif PBTerrain.isWater?(tag)
          areaBitmap.fill_rect(x*tilew,y*tileh,tilew,tileh,colorWater)
        else
          areaBitmap.fill_rect(x*tilew,y*tileh,tilew,tileh,colorSolid)
        end
      end
    end
    sprites["areaMap"]=Sprite.new(viewport)
    sprites["areaMap"].bitmap = areaBitmap
    sprites["areaMap"].x = 256 - areaBitmap.width / 2
    sprites["areaMap"].y = 360 - areaBitmap.height
  end
  
  commands=pbPauseMenuItems
  lastitem=commands[0]
  bitmaps={}
  for i in commands
    file=_INTL("Graphics/Pictures/Pause/icon{1}",i)
    bitmap=RPG::Cache.load_bitmap("",file)
    bitmaps[i]=bitmap
  end
  pbPauseMenuDrawOverlay(
      sprites["topOverlay"].bitmap,
      sprites["topMainIcon"].bitmap,
      sprites["topInfo"].bitmap,
      commands,bitmaps)
  8.times do
    sprites["topDisplay"].y+=128/8
    sprites["topOverlay"].y+=128/8
    sprites["topMainIcon"].y+=128/8
    sprites["topInfo"].y+=128/8
    sprites["partyHeader"].x+=128/8
    for i in 0...6
      sprites[_INTL("pokemon{1}",i)].x += 128/8
      sprites[_INTL("pokemon{1}",i)].update
    end
    Graphics.update
    viewport.update
    Input.update
  end
  time=0.0
  close=0
  anim=""
  swapping=false
  loop do
    time+=1.0
    inAnim=!(time > 8 || (anim != "left" && anim != "right"))
    pbUpdateUI
    Graphics.update
    viewport.update
    Input.update
    pbUpdateSceneMap
    if Input.press?(Input::LEFT) && !inAnim
      commands.unshift(commands[commands.length-1])
      commands.pop
      anim="left"
      time=0
    elsif Input.press?(Input::RIGHT) && !inAnim
      commands.push(commands[0])
      commands.shift
      anim="right"
      time=0
    elsif Input.trigger?(Input::BACK)
      break
    elsif Input.trigger?(Input::USE)
      close=pbPauseCommandSelect(commands[0],[sprites,viewport,bitmaps])
      break if close == 1
      if close == 2
        tries = 0
        while commands[0] != lastitem
          item = commands.shift
          commands.push(item)
          tries+=1
          break if tries > 20 # Ensure no infinite loops
        end
        break
      end
      lastitem=commands[0]
      # Update party summary
      trainerid = getPartyActive(0)
      otherid = getPartyActive(1)
      party = getPartyPokemon(trainerid)
      otherparty = getPartyPokemon(otherid)
      for i in 0...3
        sprites[_INTL("pokemon{1}",i*2)].setValues(party[i],trainerid)
        if otherid >= 0
          sprites[_INTL("pokemon{1}",i*2+1)].setValues(otherparty[i],otherid)
        end
      end
    elsif Input.trigger?(Input::ACTION)
      if anim != "left" && anim != "right"
        time=0
        if !swapping
          swapping=commands[0]
        else
          for i in 0...commands.length
            if commands[i] == swapping
              commands[i] = commands[0]
              commands[0] = swapping
            end
          end
          swapping=false
        end
      end
    end
    pbPauseMenuDrawOverlay(
      sprites["topOverlay"].bitmap,
      sprites["topMainIcon"].bitmap,
      sprites["topInfo"].bitmap,
      commands,bitmaps,time,anim,swapping)
    if time <= 8
      if anim == "left"
        sprites["topOverlay"].x=-144+80*(time/8)
      elsif anim == "right"
        sprites["topOverlay"].x=16-80*(time/8)
      end
    else
      anim = ""
    end
  end
  if close == 0
    8.times do
      sprites["topDisplay"].y-=128/8
      sprites["topOverlay"].y-=128/8
      sprites["topMainIcon"].y-=128/8
      sprites["topInfo"].y-=128/8
      sprites["partyHeader"].x-=128/8
      for i in 0...6
        sprites[_INTL("pokemon{1}",i)].x -= 128/8
        sprites[_INTL("pokemon{1}",i)].update
      end
      Graphics.update
      viewport.update
      Input.update
    end
  end
  pbDisposeSpriteHash(sprites)
  viewport.dispose
  for i in bitmaps
    bitmaps[i[0]].dispose
  end
end

def pbPauseMenuClose(toDispose)
  pbDisposeSpriteHash(toDispose[0])
  toDispose[1].dispose
  for i in toDispose[2]
    toDispose[2][i[0]].dispose
  end
end

def pbPauseMenuDrawOverlay(overlay,mainIcon,info,commands,bitmaps,time=0,anim="",swapping=false)
  mainIcon.clear
  ssize=34
  bsize=68
  animtime=8.0
  count=commands.length
  
  textpos=[]
  smalltextpos=[]
  maintextpos=[]
  mainsmalltextpos=[]
  base=Color.new(248,248,248)
  shadow=Color.new(104,104,104)
  redrawOverlay=false
  
  if time <= 0
    redrawOverlay=true
  end
  # Not moving
  if time > animtime || (anim != "left" && anim != "right")
    # Main Icon
    bitmap=bitmaps[commands[0]]
    x=128-bsize/2
    y=48-bsize/2
    y+=Math.sin(time/4.0)*2
    mainIcon.stretch_blt(
      Rect.new(x,y,bsize,bsize),
               bitmap,Rect.new(0,0,bsize,bsize))
    maintextpos.push([pbPauseCommandName(commands[0]),128,64,2,base,shadow])
    opacity=-Math.cos(time/24.0)*255
    if opacity>0
      mainsmalltextpos.push([pbPauseCommandHotkey(commands[0]),128,-2,2,
          Color.new(248,248,248,opacity),Color.new(104,104,104,opacity)])
    end
  # Playing moving animation
  else
    if anim == "left"
      # Old Main Icon
      bitmap=bitmaps[commands[1]]
      size=bsize+((ssize-bsize)*(time/animtime)).floor
      x=128-size/2+(94*(time/animtime)).floor
      y=48-size/2+(-18*(time/animtime)).floor
      mainIcon.stretch_blt(
        Rect.new(x,y,size,size),
                 bitmap,Rect.new(0,0,bsize,bsize))
      tx=128+(94*(time/animtime)).floor
      ty=64+(-26*(time/animtime)).floor
      mainsmalltextpos.push([pbPauseCommandName(commands[1]),tx,ty,2,base,shadow])
      # New Main Icon
      bitmap=bitmaps[commands[0]]
      size=ssize+((bsize-ssize)*(time/animtime)).floor
      x=128-size/2+(-94*(1-time/animtime)).floor
      y=48-size/2+(-18*(1-time/animtime)).floor
      mainIcon.stretch_blt(
        Rect.new(x,y,size,size),
                 bitmap,Rect.new(0,0,bsize,bsize))
      tx=32+(94*(time/animtime)).floor
      ty=38+(26*(time/animtime)).floor
      mainsmalltextpos.push([pbPauseCommandName(commands[0]),tx,ty,2,base,shadow])
    elsif anim == "right"
      # Old Main Icon
      bitmap=bitmaps[commands[count-1]]
      size=bsize+((ssize-bsize)*(time/animtime)).floor
      x=128-size/2+(-94*(time/animtime)).floor
      y=48-size/2+(-18*(time/animtime)).floor
      mainIcon.stretch_blt(
        Rect.new(x,y,size,size),
                 bitmap,Rect.new(0,0,bsize,bsize))
      tx=128+(-94*(time/animtime)).floor
      ty=64+(-18*(time/animtime)).floor
      mainsmalltextpos.push([pbPauseCommandName(commands[count-1]),tx,ty,2,base,shadow])
      # New Main Icon
      bitmap=bitmaps[commands[0]]
      size=ssize+((bsize-ssize)*(time/animtime)).floor
      x=128-size/2+(94*(1-time/animtime)).floor
      y=48-size/2+(-18*(1-time/animtime)).floor
      mainIcon.stretch_blt(
        Rect.new(x,y,size,size),
                 bitmap,Rect.new(0,0,bsize,bsize))
      tx=222+(-94*(time/animtime)).floor
      ty=38+(18*(time/animtime)).floor
      mainsmalltextpos.push([pbPauseCommandName(commands[0]),tx,ty,2,base,shadow])
    end
    if time >= animtime
      anim=""
      redrawOverlay=true
    end
  end
  
  if redrawOverlay
    overlay.clear
    # Right of main icon
    for i in 0..3
      next if i==0 && anim=="left"
      next if !commands[i+1]
      bitmap=bitmaps[commands[i+1]]
      overlay.stretch_blt(
        Rect.new(414+i*80-ssize/2,30-ssize/2,ssize,ssize),
                 bitmap,Rect.new(0,0,bsize,bsize))
      smalltextpos.push([pbPauseCommandName(commands[i+1]),414+i*80,38,2,base,shadow])
    end
    # Left of main icon
    for i in 0..3
      next if i==0 && anim=="right"
      next if !commands[count-i-1]
      bitmap=bitmaps[commands[count-i-1]]
      overlay.stretch_blt(
        Rect.new(224-i*80-ssize/2,30-ssize/2,ssize,ssize),
                 bitmap,Rect.new(0,0,bsize,bsize))
      smalltextpos.push([pbPauseCommandName(commands[count-i-1]),224-i*80,38,2,base,shadow])
    end
  end
  
  # Time display
  if pbGetTimeNow.update || time==0
    info.clear
    infotextpos=[]
    infotextpos.push([pbGetTimeNow.getDigitalString(false),374,70,2,base,shadow])
    # Weather Display
    weather = "Cloudy"
    if $game_screen && $game_screen.weather_type
      weather = pbPauseWeatherName($game_screen.weather_type)
    end
    infotextpos.push([weather,138,70,2,base,shadow])
    
    pbSetSmallFont(info)
    pbDrawTextPositions(info,infotextpos)
  end
  
  if swapping
    for i in 0...maintextpos.length
      if maintextpos[i][0]==pbPauseCommandName(swapping)
        maintextpos[i][4]=Color.new(0,224,0)
        maintextpos[i][5]=Color.new(0,150,0)
      end
    end
    for i in 0...mainsmalltextpos.length
      if mainsmalltextpos[i][0]==pbPauseCommandName(swapping)
        mainsmalltextpos[i][4]=Color.new(0,224,0)
        mainsmalltextpos[i][5]=Color.new(0,150,0)
      end
    end
    for i in 0...smalltextpos.length
      if smalltextpos[i][0]==pbPauseCommandName(swapping)
        smalltextpos[i][4]=Color.new(0,224,0)
        smalltextpos[i][5]=Color.new(0,150,0)
      end
    end
  end
  
  pbSetSmallFont(mainIcon)
  pbDrawTextPositions(mainIcon,mainsmalltextpos)
  pbSetSystemFont(mainIcon)
  pbDrawTextPositions(mainIcon,maintextpos)
  
  if redrawOverlay
    pbSetSmallFont(overlay)
    pbDrawTextPositions(overlay,smalltextpos)
    pbSetSystemFont(overlay)
    pbDrawTextPositions(overlay,textpos)
  end
end

def pbPauseCommandName(command)
  case command
  when "Card"
    return $Trainer.name
  when "Dex"
    return "Pokédex"
  when "Gear"
    return "Pokégear"
  end
  return command
end

def pbPauseCommandHotkey(command)
  return ""
  case command
  when "Bag"
    return "Hotkey: B"
  when "Dex"
    return "Hotkey: D"
  when "Gear"
    return "Hotkey: G"
  when "Party"
    return "Hotkey: P"
  when "Quests"
    return "Hotkey: Q"
  end
  return ""
end

def pbPauseWeatherName(weather)
  return "Swap: Z"
  names = [
    "Cloudy",
    "Raining",
    "Storm",
    "Snowing",
    "Blizzard",
    "Sandstorm",
    "Heavy Rain",
    "Sunny",
    "Windy",
    "Blood Moon"
  ]
  return names[weather]
end

def pbPauseMenuItems
  if !$game_variables[PAUSE_MENU_ITEMS].is_a?(Array)
    $game_variables[PAUSE_MENU_ITEMS]=[]
  end
  commands=$game_variables[PAUSE_MENU_ITEMS]
  commands.push("Dex") if !commands.include?("Dex")
  commands.push("Party") if !commands.include?("Party")
  commands.push("Bag") if !commands.include?("Bag")
  commands.push("Quests") if !commands.include?("Quests") && $game_switches[HAS_QUEST_LIST]
  commands.push("Gear") if !commands.include?("Gear") && $game_switches[HAS_POKEGEAR]
  commands.push("Card") if !commands.include?("Card")
  commands.push("Save") if !commands.include?("Save")
  commands.push("Options") if !commands.include?("Options")
  return commands
end

def pbPauseCommandSelect(command,toDispose)
  case command
  when "Bag"
    item=0
    scene=PokemonBag_Scene.new
    screen=PokemonBagScreen.new(scene,$PokemonBag)
    pbFadeOutIn(99999) { 
       item=screen.pbStartScreen 
       if item
         pbPauseMenuClose(toDispose)
       end
    }
    if item
      pbUseKeyItemInField(item)
      return 1
    end
  when "Dex"
    if Settings::USE_CURRENT_REGION_DEX
      pbFadeOutIn {
        scene = PokemonPokedex_Scene.new
        screen = PokemonPokedexScreen.new(scene)
        screen.pbStartScreen
      }
    else
      if $Trainer.pokedex.accessible_dexes.length == 1 && !$game_switches[HAS_HABITAT_DEX]
        $PokemonGlobal.pokedexDex = $Trainer.pokedex.accessible_dexes[0]
        pbFadeOutIn {
          scene = PokemonPokedex_Scene.new
          screen = PokemonPokedexScreen.new(scene)
          screen.pbStartScreen
        }
      else
        pbFadeOutIn {
          scene = PokemonPokedexMenu_Scene.new
          screen = PokemonPokedexMenuScreen.new(scene)
          screen.pbStartScreen
        }
      end
    end
  when "Gear"
    pbFadeOutIn {
      scene = PokemonPokegear_Scene.new
      screen = PokemonPokegearScreen.new(scene)
      screen.pbStartScreen
    }
  when "Party"
    sscene=PokemonScreen_Scene.new
    sscreen=PokemonScreen.new(sscene,getActivePokemon(0))
    hiddenmove=nil
    pbFadeOutIn(99999) { 
       hiddenmove=sscreen.pbPokemonScreen
       if hiddenmove
         pbPauseMenuClose(toDispose)
       end
    }
    if hiddenmove
      Kernel.pbUseHiddenMove(hiddenmove[0],hiddenmove[1])
      return 1
    end
  when "Quests"
    pbFadeOutIn {
      pbShowQuests
    }
  when "Card"
    pbFadeOutIn {
      scene = PokemonTrainerCard_Scene.new
      screen = PokemonTrainerCardScreen.new(scene)
      screen.pbStartScreen
    }
  when "Options"
    pbFadeOutIn {
      scene = PokemonOption_Scene.new
      screen = PokemonOptionScreen.new(scene)
      screen.pbStartScreen
      pbUpdateSceneMap
    }
  when "Save"
    pbPauseMenuClose(toDispose)
    scene = PokemonSave_Scene.new
    screen = PokemonSaveScreen.new(scene)
    screen.pbSaveScreen
    return 2
  end
  return 0
end







