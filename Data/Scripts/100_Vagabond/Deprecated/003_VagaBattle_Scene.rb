=begin
class PokeBattle_Scene
  
  def pbStartWildBattle(battle)
    
    # Called whenever the battle begins
    @battle=battle
    @lastcmd=[0,0,0,0]
    @lastmove=[0,0,0,0]
    @showingplayer=true
    @showingenemy=true
    @sprites.clear
    @viewport=Viewport.new(0,Graphics.height/2,Graphics.width,0)
    @viewport.z=99999
    @traineryoffset=(Graphics.height-320) # Adjust player's side for screen size
    @foeyoffset=(@traineryoffset*3/4).floor  # Adjust foe's side for screen size
    pbBackdrop
    pbAddSprite("partybarfoe",
       PokeBattle_SceneConstants::FOEPARTYBAR_X,
       PokeBattle_SceneConstants::FOEPARTYBAR_Y,
       "Graphics/Pictures/battleLineup",@viewport)
    pbAddSprite("partybarplayer",
       PokeBattle_SceneConstants::PLAYERPARTYBAR_X,
       PokeBattle_SceneConstants::PLAYERPARTYBAR_Y,
       "Graphics/Pictures/battleLineup",@viewport)
    @sprites["partybarfoe"].x-=@sprites["partybarfoe"].bitmap.width
    @sprites["partybarplayer"].mirror=true
    @sprites["partybarfoe"].z=40
    @sprites["partybarplayer"].z=40
    @sprites["partybarfoe"].visible=false
    @sprites["partybarplayer"].visible=false
    if @battle.player.is_a?(Array)
      trainerfile=pbPlayerSpriteBackFile(@battle.player[0].trainertype)
      pbAddSprite("player",
           PokeBattle_SceneConstants::PLAYERTRAINERD1_X,
           PokeBattle_SceneConstants::PLAYERTRAINERD1_Y,trainerfile,@viewport)
      trainerfile=pbTrainerSpriteBackFile(@battle.player[1].trainertype)
      pbAddSprite("playerB",
           PokeBattle_SceneConstants::PLAYERTRAINERD2_X,
           PokeBattle_SceneConstants::PLAYERTRAINERD2_Y,trainerfile,@viewport)
      if @sprites["player"].bitmap
        if @sprites["player"].bitmap.width>@sprites["player"].bitmap.height
          @sprites["player"].src_rect.x=0
          @sprites["player"].src_rect.width=@sprites["player"].bitmap.width/5
        end
        @sprites["player"].x-=(@sprites["player"].src_rect.width/2)
        @sprites["player"].y-=@sprites["player"].bitmap.height
        @sprites["player"].z=30
      end
      if @sprites["playerB"].bitmap
        if @sprites["playerB"].bitmap.width>@sprites["playerB"].bitmap.height
          @sprites["playerB"].src_rect.x=0
          @sprites["playerB"].src_rect.width=@sprites["playerB"].bitmap.width/5
        end
        @sprites["playerB"].x-=(@sprites["playerB"].src_rect.width/2)
        @sprites["playerB"].y-=@sprites["playerB"].bitmap.height
        @sprites["playerB"].z=31
      end
    else
      trainerfile=pbPlayerSpriteBackFile(@battle.player.trainertype)
      pbAddSprite("player",
           PokeBattle_SceneConstants::PLAYERTRAINER_X,
           PokeBattle_SceneConstants::PLAYERTRAINER_Y,trainerfile,@viewport)
      if @sprites["player"].bitmap
        if @sprites["player"].bitmap.width>@sprites["player"].bitmap.height
          @sprites["player"].src_rect.x=0
          @sprites["player"].src_rect.width=@sprites["player"].bitmap.width/5
        end
        @sprites["player"].x-=(@sprites["player"].src_rect.width/2)
        @sprites["player"].y-=@sprites["player"].bitmap.height
        @sprites["player"].z=30
      end
    end
    if @battle.opponent
      if @battle.opponent.is_a?(Array)
        trainerfile=pbTrainerSpriteFile(@battle.opponent[1].trainertype)
        pbAddSprite("trainer2",
           PokeBattle_SceneConstants::FOETRAINERD2_X,
           PokeBattle_SceneConstants::FOETRAINERD2_Y,trainerfile,@viewport)
        trainerfile=pbTrainerSpriteFile(@battle.opponent[0].trainertype)
        pbAddSprite("trainer",
           PokeBattle_SceneConstants::FOETRAINERD1_X,
           PokeBattle_SceneConstants::FOETRAINERD1_Y,trainerfile,@viewport)
      else
        trainerfile=pbTrainerSpriteFile(@battle.opponent.trainertype)
        pbAddSprite("trainer",
           PokeBattle_SceneConstants::FOETRAINER_X,
           PokeBattle_SceneConstants::FOETRAINER_Y,trainerfile,@viewport)
      end
    else
      trainerfile="Graphics/Characters/trfront"
      pbAddSprite("trainer",
           PokeBattle_SceneConstants::FOETRAINER_X,
           PokeBattle_SceneConstants::FOETRAINER_Y,trainerfile,@viewport)
    end
    if @sprites["trainer"].bitmap
      @sprites["trainer"].x-=(@sprites["trainer"].bitmap.width/2)
      @sprites["trainer"].y-=@sprites["trainer"].bitmap.height
      @sprites["trainer"].z=8
    end
    if @sprites["trainer2"] && @sprites["trainer2"].bitmap
      @sprites["trainer2"].x-=(@sprites["trainer2"].bitmap.width/2)
      @sprites["trainer2"].y-=@sprites["trainer2"].bitmap.height
      @sprites["trainer2"].z=7
    end
    @sprites["shadow0"]=IconSprite.new(0,0,@viewport)
    @sprites["shadow0"].z=3
    pbAddSprite("shadow1",0,0,"Graphics/Pictures/battleShadow",@viewport)
    @sprites["shadow1"].z=3
    @sprites["shadow1"].visible=false
    @sprites["pokemon0"]=PokemonBattlerSprite.new(battle.doublebattle,0,@viewport)
    @sprites["pokemon0"].z=21
    @sprites["pokemon1"]=PokemonBattlerSprite.new(battle.doublebattle,1,@viewport)
    @sprites["pokemon1"].z=16
    if battle.doublebattle
      @sprites["shadow2"]=IconSprite.new(0,0,@viewport)
      @sprites["shadow2"].z=3
      pbAddSprite("shadow3",0,0,"Graphics/Pictures/battleShadow",@viewport)
      @sprites["shadow3"].z=3
      @sprites["shadow3"].visible=false
      @sprites["pokemon2"]=PokemonBattlerSprite.new(battle.doublebattle,2,@viewport)
      @sprites["pokemon2"].z=26
      @sprites["pokemon3"]=PokemonBattlerSprite.new(battle.doublebattle,3,@viewport)
      @sprites["pokemon3"].z=11
    end
    @sprites["battlebox0"]=PokemonDataBox.new(battle.battlers[0],battle.doublebattle,@viewport)
    @sprites["battlebox1"]=PokemonDataBox.new(battle.battlers[1],battle.doublebattle,@viewport)
    if battle.doublebattle
      @sprites["battlebox2"]=PokemonDataBox.new(battle.battlers[2],battle.doublebattle,@viewport)
      @sprites["battlebox3"]=PokemonDataBox.new(battle.battlers[3],battle.doublebattle,@viewport)
    end
    pbAddSprite("messagebox",0,Graphics.height-96,"Graphics/Pictures/battleMessage",@viewport)
    @sprites["messagebox"].z=90
    @sprites["helpwindow"]=Window_UnformattedTextPokemon.newWithSize("",0,0,32,32,@viewport)
    @sprites["helpwindow"].baseColor=Color.new(248,248,248)
    @sprites["helpwindow"].shadowColor=Color.new(248,248,248,100)
    @sprites["helpwindow"].visible=false
    @sprites["helpwindow"].z=90
    @sprites["messagewindow"]=Window_AdvancedTextPokemon.newWithSize("",0,0,512,200,@viewport)
    @sprites["messagewindow"].letterbyletter=true
    @sprites["messagewindow"].viewport=@viewport
    @sprites["messagewindow"].z=100
    @sprites["commandwindow"]=CommandMenuDisplay.new(battle,nil,@viewport)
    @sprites["commandwindow"].z=100
    @sprites["fightwindow"]=FightMenuDisplay.new(nil,@viewport)
    @sprites["fightwindow"].z=100
    pbShowWindow(MESSAGEBOX)
    pbSetMessageMode(false)
    trainersprite1=@sprites["trainer"]
    trainersprite2=@sprites["trainer2"]
    if !@battle.opponent
      @sprites["trainer"].visible=false
      if @battle.party2.length>=1
        if @battle.party2.length==1
          species=@battle.party2[0].species
          @sprites["pokemon1"].setPokemonBitmap(@battle.party2[0],false)
          @sprites["pokemon1"].tone=Tone.new(-128,-128,-128,-128)
          if $game_switches[FINAL_BATTLE]
            @sprites["pokemon1"].x=PokeBattle_SceneConstants::FINALBATTLE_X
            @sprites["pokemon1"].x-=@sprites["pokemon1"].width/2
            @sprites["pokemon1"].y=PokeBattle_SceneConstants::FINALBATTLE_Y
            @sprites["pokemon1"].y+=adjustBattleSpriteY(@sprites["pokemon1"],species,1)
            @sprites["pokemon1"].visible=true
            @sprites["shadow1"].x=PokeBattle_SceneConstants::FINALBATTLE_X
            @sprites["shadow1"].y=PokeBattle_SceneConstants::FINALBATTLE_Y
          else
            @sprites["pokemon1"].x=PokeBattle_SceneConstants::FOEBATTLER_X
            @sprites["pokemon1"].x-=@sprites["pokemon1"].width/2
            #@sprites["pokemon1"].y=PokeBattle_SceneConstants::FOEBATTLER_Y
            #@sprites["pokemon1"].y+=adjustBattleSpriteY(@sprites["pokemon1"],species,1)
            @sprites["pokemon1"].y=170-@sprites["pokemon1"].bitmap.height
            @sprites["pokemon1"].y-=24 if showShadow?(species)
            @sprites["pokemon1"].visible=true
            @sprites["shadow1"].x=PokeBattle_SceneConstants::FOEBATTLER_X
            @sprites["shadow1"].y=@sprites["enemybase"].y + @sprites["enemybase"].bitmap.height/2
          end
          @sprites["shadow1"].x-=@sprites["shadow1"].bitmap.width/2 if @sprites["shadow1"].bitmap!=nil
          @sprites["shadow1"].y-=@sprites["shadow1"].bitmap.height/2 if @sprites["shadow1"].bitmap!=nil
          @sprites["shadow1"].visible=showShadow?(species)
          trainersprite1=@sprites["pokemon1"]
        elsif @battle.party2.length==2
          species=@battle.party2[0].species
          @sprites["pokemon1"].setPokemonBitmap(@battle.party2[0],false)
          @sprites["pokemon1"].tone=Tone.new(-128,-128,-128,-128)
          @sprites["pokemon1"].x=PokeBattle_SceneConstants::FOEBATTLERD1_X
          @sprites["pokemon1"].x-=@sprites["pokemon1"].width/2
          #@sprites["pokemon1"].y=PokeBattle_SceneConstants::FOEBATTLERD1_Y
          #@sprites["pokemon1"].y+=adjustBattleSpriteY(@sprites["pokemon1"],species,1)
          @sprites["pokemon1"].y=180-@sprites["pokemon1"].bitmap.height
          @sprites["pokemon1"].y-=24 if showShadow?(species)
          @sprites["pokemon1"].visible=true
          @sprites["shadow1"].x=PokeBattle_SceneConstants::FOEBATTLERD1_X
          @sprites["shadow1"].y=@sprites["enemybase"].y + @sprites["enemybase"].bitmap.height/2+5
          @sprites["shadow1"].x-=@sprites["shadow1"].bitmap.width/2 if @sprites["shadow1"].bitmap!=nil
          @sprites["shadow1"].y-=@sprites["shadow1"].bitmap.height/2 if @sprites["shadow1"].bitmap!=nil
          @sprites["shadow1"].visible=showShadow?(species)
          trainersprite1=@sprites["pokemon1"]
          species=@battle.party2[1].species
          @sprites["pokemon3"].setPokemonBitmap(@battle.party2[1],false)
          @sprites["pokemon3"].tone=Tone.new(-128,-128,-128,-128)
          @sprites["pokemon3"].x=PokeBattle_SceneConstants::FOEBATTLERD2_X
          @sprites["pokemon3"].x-=@sprites["pokemon3"].width/2
          #@sprites["pokemon3"].y=PokeBattle_SceneConstants::FOEBATTLERD2_Y
          #@sprites["pokemon3"].y+=adjustBattleSpriteY(@sprites["pokemon3"],species,3)
          @sprites["pokemon3"].y=170-@sprites["pokemon3"].bitmap.height
          @sprites["pokemon3"].y-=24 if showShadow?(species)
          @sprites["pokemon3"].visible=true
          @sprites["shadow3"].x=PokeBattle_SceneConstants::FOEBATTLERD2_X
          @sprites["shadow3"].y=@sprites["enemybase"].y + @sprites["enemybase"].bitmap.height/2-5
          @sprites["shadow3"].x-=@sprites["shadow3"].bitmap.width/2 if @sprites["shadow3"].bitmap!=nil
          @sprites["shadow3"].y-=@sprites["shadow3"].bitmap.height/2 if @sprites["shadow3"].bitmap!=nil
          @sprites["shadow3"].visible=showShadow?(species)
          trainersprite2=@sprites["pokemon3"]
        end
      end
    end
    #################
    @viewport.rect.y=0
    @viewport.rect.height=Graphics.height
    #################
    if @battle.opponent
      @enablePartyAnim=true
      @partyAnimPhase=0
      @sprites["partybarfoe"].visible=true
      @sprites["partybarplayer"].visible=true
    else
      pbPlayCry(@battle.party2[0])   # Play cry for wild Pokémon
      @sprites["battlebox1"].appear
      @sprites["battlebox3"].appear if @battle.party2.length==2 
      appearing=true
      begin
        pbGraphicsUpdate
        pbInputUpdate
        pbFrameUpdate
        @sprites["pokemon1"].tone.red+=8 if @sprites["pokemon1"].tone.red<0
        @sprites["pokemon1"].tone.blue+=8 if @sprites["pokemon1"].tone.blue<0
        @sprites["pokemon1"].tone.green+=8 if @sprites["pokemon1"].tone.green<0
        @sprites["pokemon1"].tone.gray+=8 if @sprites["pokemon1"].tone.gray<0
        appearing=@sprites["battlebox1"].appearing
        if @battle.party2.length==2 
          @sprites["pokemon3"].tone.red+=8 if @sprites["pokemon3"].tone.red<0
          @sprites["pokemon3"].tone.blue+=8 if @sprites["pokemon3"].tone.blue<0
          @sprites["pokemon3"].tone.green+=8 if @sprites["pokemon3"].tone.green<0
          @sprites["pokemon3"].tone.gray+=8 if @sprites["pokemon3"].tone.gray<0
          appearing=(appearing || @sprites["battlebox3"].appearing)
        end
      end while appearing
      # Show shiny animation for wild Pokémon
      if @battle.battlers[1].isShiny? && @battle.battlescene
        pbCommonAnimation("Shiny",@battle.battlers[1],nil)
      end
      if @battle.party2.length==2
        if @battle.battlers[3].isShiny? && @battle.battlescene
          pbCommonAnimation("Shiny",@battle.battlers[3],nil)
        end
      end
    end
  end
  
end


def pbWildBattleAnimation(bgm=nil,species=-1,battle=nil)
  handled=false
  playingBGS=nil
  playingBGM=nil
  if $game_system && $game_system.is_a?(Game_System)
    playingBGS=$game_system.getPlayingBGS
    playingBGM=$game_system.getPlayingBGM
    $game_system.bgm_pause
    $game_system.bgs_pause
  end
  pbMEFade(0.25)
  pbWait(10)
  pbMEStop
  if bgm
    pbMEPlay(bgm)
    pbBGMPlay(bgm)
  else
    bgm=pbGetWildBattleBGM(0)
    pbMEPlay(bgm)
    pbBGMPlay(bgm)
  end
  viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z=99999
  viewportbgl=Viewport.new(0,0,Graphics.width,Graphics.height)
  viewportbgl.z=99998
  viewportbgr=Viewport.new(0,0,Graphics.width,Graphics.height)
  viewportbgr.z=99998
  viewportblack=Viewport.new(0,0,Graphics.width,Graphics.height)
  viewportblack.z=99997
  
  # Actual effect here
  #        V
  showingplayer=true
  showingenemy=true
  sprites = {}
  traineryoffset=(Graphics.height-320)  # Adjust player's side for screen size
  foeyoffset=(traineryoffset*3/4).floor # Adjust foe's side for screen size
  
  # Get the backdrop
  backdrop = pbBackdropFiles(battle)
  sprites["battlebgl"] = AnimatedPlane.new(viewportbgl)
  sprites["battlebgl"].setBitmap(backdrop[0])
  sprites["battlebgr"] = AnimatedPlane.new(viewportbgr)
  sprites["battlebgr"].setBitmap(backdrop[0])
  sprites["black"] = IconSprite.new(0,0,viewportblack)
  sprites["black"].bitmap = Bitmap.new(Graphics.width,Graphics.height)
  sprites["black"].bitmap.fill_rect(0,0,Graphics.width,Graphics.height,Color.new(0,0,0))
  sprites["playerbase"] = IconSprite.new(
    PokeBattle_SceneConstants::PLAYERBASEX,
    PokeBattle_SceneConstants::PLAYERBASEY,
    viewport)
  sprites["playerbase"].setBitmap(backdrop[1])
  sprites["playerbase"].x-=sprites["playerbase"].bitmap.width/2 if sprites["playerbase"].bitmap!=nil
  sprites["playerbase"].y-=64#sprites["playerbase"].bitmap.height if sprites["playerbase"].bitmap!=nil
  sprites["enemybase"] = IconSprite.new(
    PokeBattle_SceneConstants::FOEBASEX,
    PokeBattle_SceneConstants::FOEBASEY,
    viewport)
  sprites["enemybase"].setBitmap(backdrop[2])
  sprites["enemybase"].x-=sprites["enemybase"].bitmap.width/2 if sprites["enemybase"].bitmap!=nil
  sprites["enemybase"].y-=sprites["enemybase"].bitmap.height/2 if sprites["enemybase"].bitmap!=nil
  sprites["battlebgl"].z=1
  sprites["battlebgr"].z=1
  sprites["playerbase"].z=2
  sprites["enemybase"].z=2
  
  if battle.player.is_a?(Array)
    trainerfile=pbPlayerSpriteBackFile(battle.player[0].trainertype)
    sprites["player"] = IconSprite.new(
      PokeBattle_SceneConstants::PLAYERTRAINERD1_X,
      PokeBattle_SceneConstants::PLAYERTRAINERD1_Y,
      viewport)
    sprites["player"].setBitmap(trainerfile)
    trainerfile=pbTrainerSpriteBackFile(battle.player[1].trainertype)
    sprites["playerB"] = IconSprite.new(
      PokeBattle_SceneConstants::PLAYERTRAINERD2_X,
      PokeBattle_SceneConstants::PLAYERTRAINERD2_Y,
      viewport)
    sprites["playerB"].setBitmap(trainerfile)
    if sprites["player"].bitmap
      if sprites["player"].bitmap.width>sprites["player"].bitmap.height
        sprites["player"].src_rect.x=0
        sprites["player"].src_rect.width=sprites["player"].bitmap.width/5
      end
      sprites["player"].x-=(sprites["player"].src_rect.width/2)
      sprites["player"].y-=sprites["player"].bitmap.height
      sprites["player"].z=31
    end
    if sprites["playerB"].bitmap
      if sprites["playerB"].bitmap.width>sprites["playerB"].bitmap.height
        sprites["playerB"].src_rect.x=0
        sprites["playerB"].src_rect.width=sprites["playerB"].bitmap.width/5
      end
      sprites["playerB"].x-=(sprites["playerB"].src_rect.width/2)
      sprites["playerB"].y-=sprites["playerB"].bitmap.height
      sprites["playerB"].z=32
    end
  else
    trainerfile=pbPlayerSpriteBackFile(battle.player.trainertype)
    sprites["player"] = IconSprite.new(
      PokeBattle_SceneConstants::PLAYERTRAINER_X,
      PokeBattle_SceneConstants::PLAYERTRAINER_Y,
      viewport)
    sprites["player"].setBitmap(trainerfile)
    if sprites["player"].bitmap
      if sprites["player"].bitmap.width>sprites["player"].bitmap.height
        sprites["player"].src_rect.x=0
        sprites["player"].src_rect.width=sprites["player"].bitmap.width/5
      end
      sprites["player"].x-=(sprites["player"].src_rect.width/2)
      sprites["player"].y-=sprites["player"].bitmap.height
      sprites["player"].z=31
    end
  end
  sprites["shadow0"]=IconSprite.new(0,0,viewport)
  sprites["shadow0"].z=4
  sprites["shadow1"] = IconSprite.new(0,0,viewport)
  sprites["shadow1"].setBitmap("Graphics/Pictures/battleShadow")
  sprites["shadow1"].z=4
  sprites["shadow1"].visible=false
  sprites["pokemon0"]=PokemonBattlerSprite.new(battle.doublebattle,0,viewport)
  sprites["pokemon0"].z=22
  sprites["pokemon1"]=PokemonBattlerSprite.new(battle.doublebattle,1,viewport)
  sprites["pokemon1"].z=17
  if battle.doublebattle
    sprites["shadow2"]=IconSprite.new(0,0,viewport)
    sprites["shadow2"].z=4
    sprites["shadow3"] = IconSprite.new(0,0,viewport)
    sprites["shadow3"].setBitmap("Graphics/Pictures/battleShadow")
    sprites["shadow3"].z=4
    sprites["shadow3"].visible=false
    sprites["pokemon2"]=PokemonBattlerSprite.new(battle.doublebattle,2,viewport)
    sprites["pokemon2"].z=27
    sprites["pokemon3"]=PokemonBattlerSprite.new(battle.doublebattle,3,viewport)
    sprites["pokemon3"].z=12
  end
  sprites["messagebox"]=IconSprite.new(0,0,viewport)
  sprites["messagebox"].setBitmap("Graphics/Pictures/battleCommandBG")
  sprites["messagebox"].z=90
  sprites["messagebox"].y=Graphics.height
  if battle.party2.length>=1
    if battle.party2.length==1
      species=battle.party2[0].species
      sprites["pokemon1"].setPokemonBitmap(battle.party2[0],false)
      sprites["pokemon1"].tone=Tone.new(-128,-128,-128,-128)
      if $game_switches[FINAL_BATTLE]
        sprites["pokemon1"].x=PokeBattle_SceneConstants::FINALBATTLE_X
        sprites["pokemon1"].x-=sprites["pokemon1"].width/2
        sprites["pokemon1"].y=PokeBattle_SceneConstants::FINALBATTLE_Y
        sprites["pokemon1"].y+=adjustBattleSpriteY(sprites["pokemon1"],species,1)
        sprites["pokemon1"].visible=true
        sprites["shadow1"].x=PokeBattle_SceneConstants::FINALBATTLE_X
        sprites["shadow1"].y=PokeBattle_SceneConstants::FINALBATTLE_Y
      else
        sprites["pokemon1"].x=PokeBattle_SceneConstants::FOEBATTLER_X
        sprites["pokemon1"].x-=sprites["pokemon1"].width/2
        #sprites["pokemon1"].y=PokeBattle_SceneConstants::FOEBATTLER_Y
        #sprites["pokemon1"].y+=adjustBattleSpriteY(sprites["pokemon1"],species,1)
        sprites["pokemon1"].y=170-sprites["pokemon1"].bitmap.height
        sprites["pokemon1"].y-=16 if showShadow?(species)
        sprites["pokemon1"].visible=true
        sprites["shadow1"].x=PokeBattle_SceneConstants::FOEBATTLER_X
        sprites["shadow1"].y=PokeBattle_SceneConstants::FOEBATTLER_Y
      end
      sprites["shadow1"].x-=sprites["shadow1"].bitmap.width/2 if sprites["shadow1"].bitmap!=nil
      sprites["shadow1"].y-=sprites["shadow1"].bitmap.height/2 if sprites["shadow1"].bitmap!=nil
      sprites["shadow1"].visible=showShadow?(species)
      trainersprite1=sprites["pokemon1"]
    elsif battle.party2.length==2
      species=battle.party2[0].species
      sprites["pokemon1"].setPokemonBitmap(battle.party2[0],false)
      sprites["pokemon1"].tone=Tone.new(-128,-128,-128,-128)
      sprites["pokemon1"].x=PokeBattle_SceneConstants::FOEBATTLERD1_X
      sprites["pokemon1"].x-=sprites["pokemon1"].width/2
      #sprites["pokemon1"].y=PokeBattle_SceneConstants::FOEBATTLERD1_Y
      #sprites["pokemon1"].y+=adjustBattleSpriteY(sprites["pokemon1"],species,1)
      sprites["pokemon1"].y=180-sprites["pokemon1"].bitmap.height
      sprites["pokemon1"].y-=16 if showShadow?(species)
      sprites["pokemon1"].visible=true
      sprites["shadow1"].x=PokeBattle_SceneConstants::FOEBATTLERD1_X
      sprites["shadow1"].y=PokeBattle_SceneConstants::FOEBATTLERD1_Y
      sprites["shadow1"].x-=sprites["shadow1"].bitmap.width/2 if sprites["shadow1"].bitmap!=nil
      sprites["shadow1"].y-=sprites["shadow1"].bitmap.height/2 if sprites["shadow1"].bitmap!=nil
      sprites["shadow1"].visible=showShadow?(species)
      trainersprite1=sprites["pokemon1"]
      species=battle.party2[1].species
      sprites["pokemon3"].setPokemonBitmap(battle.party2[1],false)
      sprites["pokemon3"].tone=Tone.new(-128,-128,-128,-128)
      sprites["pokemon3"].x=PokeBattle_SceneConstants::FOEBATTLERD2_X
      sprites["pokemon3"].x-=sprites["pokemon3"].width/2
      #sprites["pokemon3"].y=PokeBattle_SceneConstants::FOEBATTLERD2_Y
      #sprites["pokemon3"].y+=adjustBattleSpriteY(sprites["pokemon3"],species,3)
      sprites["pokemon3"].y=170-sprites["pokemon3"].bitmap.height
      sprites["pokemon3"].y-=16 if showShadow?(species)
      sprites["pokemon3"].visible=true
      sprites["shadow3"].x=PokeBattle_SceneConstants::FOEBATTLERD2_X
      sprites["shadow3"].y=PokeBattle_SceneConstants::FOEBATTLERD2_Y
      sprites["shadow3"].x-=sprites["shadow3"].bitmap.width/2 if sprites["shadow3"].bitmap!=nil
      sprites["shadow3"].y-=sprites["shadow3"].bitmap.height/2 if sprites["shadow3"].bitmap!=nil
      sprites["shadow3"].visible=showShadow?(species)
      trainersprite2=sprites["pokemon3"]
    end
  end

  names = ["player","pokemon1","shadow1"]
  
  ox = []; oy = []
  for i in 1..2
    ox[i] = sprites[names[i]].x
    oy[i] = sprites[names[i]].y
  end
  ox[0] = sprites["player"].x
  oy[0] = sprites["player"].y
  
  for i in 1..2
    sprites[names[i]].x = Graphics.width / 2 - (sprites[names[i]].bitmap.width * 0.2) / 2.0
    sprites[names[i]].y = Graphics.height / 2 - (sprites[names[i]].bitmap.height * 0.2) / 2.0
  end
  sprites["player"].x = -128
  
  incx = []; incy = []
  for i in 0..2
    incx[i] = (((ox[i] - sprites[names[i]].x)*1.0)/16.0)
    incy[i] = (((oy[i] - sprites[names[i]].y)*1.0)/16.0)
  end
  
  for i in sprites
    i[1].opacity=0
  end
  sprites["pokemon1"].zoom_x=0.2
  sprites["pokemon1"].zoom_y=0.2
  sprites["shadow1"].zoom_x=0.2
  sprites["shadow1"].zoom_y=0.2
  sprites["messagebox"].opacity=160
  
  #sprites["battlebg"].opacity=255
  sprites["battlebgl"].ox = 0
  sprites["battlebgl"].oy = 0
  sprites["battlebgl"].update
  sprites["battlebgr"].ox = 256#-768
  sprites["battlebgr"].oy = 0
  sprites["battlebgr"].update
  viewportbgl.rect = Rect.new(
    0, 0, 0, Graphics.height)
  viewportbgr.rect = Rect.new(
    Graphics.width, 0, 0, Graphics.height)
  
  pbWait(1)
  Graphics.update
  Input.update
  viewport.update
  viewportbgl.update
  viewportbgr.update
  viewportblack.update
  pbWait(1)
  
  for a in 0...16
    pbWait(1)
    Graphics.update
    Input.update
    viewport.update
    viewportbgl.update
    viewportbgr.update
    viewportblack.update
    sprites["messagebox"].y -= 12
    if sprites["messagebox"].y < Graphics.height - sprites["messagebox"].bitmap.height
      sprites["messagebox"].y = Graphics.height - sprites["messagebox"].bitmap.height
    end
    for i in sprites
      if i[0]=="black"
        i[1].opacity += 8
      else
        i[1].opacity += 16
      end
      i[1].opacity = 255 if i[1].opacity > 255
    end
    viewportbgl.rect.width += 24
    viewportbgr.rect.width += 24
    viewportbgr.rect.x -= 24
    viewportbgr.rect.x = Graphics.width/2 if viewportbgr.rect.x < Graphics.width/2
    viewportbgl.rect.width = Graphics.width/2 if viewportbgl.rect.width > Graphics.width/2
    viewportbgr.rect.width = Graphics.width/2 if viewportbgr.rect.width > Graphics.width/2
    sprites["battlebgr"].ox+=24
    sprites["battlebgr"].ox = -256 if sprites["battlebgr"].ox > -256
    for i in 0..2
      name = names[i]
      sprites[name].x += incx[i]
      sprites[name].y += incy[i]
      sprites[name].x = ox[i] if sprites[name].x > ox[i]
      sprites[name].y = oy[i] if sprites[name].y < oy[i]
      sprites[name].zoom_x += 0.05
      sprites[name].zoom_y += 0.05
      sprites[name].zoom_x = 1 if sprites[name].zoom_x > 1.0
      sprites[name].zoom_y = 1 if sprites[name].zoom_y > 1.0
    end
    if battle.party2.length==2
      
    end
    
  end
  
  for i in 1..2
    sprites[names[i]].x = ox[i]
    sprites[names[i]].y = oy[i]
  end
  Graphics.update
  Input.update
  viewport.update
  viewportbgl.update
  viewportbgr.update
  viewportblack.update
  
  pbDisposeSpriteHash(sprites)
  
  # end of effect
  
  pbPushFade
  yield if block_given?
  pbPopFade
  for j in 0..17
    viewport.color=Color.new(0,0,0,(17-j)*15)
    Graphics.update
    Input.update
    pbUpdateSceneMap
  end
  if $game_system && $game_system.is_a?(Game_System)
    $game_system.bgm_resume(playingBGM)
    $game_system.bgs_resume(playingBGS)
  end
  $PokemonGlobal.nextBattleBGM=nil
  $PokemonGlobal.nextBattleME=nil
  $PokemonGlobal.nextBattleBack=nil
  $PokemonEncounters.clearStepCount
  viewport.dispose
  viewportbgl.dispose
  viewportbgr.dispose
  viewportblack.dispose
end

def pbBackdropFiles(battle)
  
  environ = battle.environment
  # Choose backdrop
  backdrop="Field"
  if environ==PBEnvironment::Cave
    backdrop="Cave"
  elsif environ==PBEnvironment::MovingWater || environ==PBEnvironment::StillWater
    backdrop="Water"
  elsif environ==PBEnvironment::Underwater
    backdrop="Underwater"
  elsif environ==PBEnvironment::Rock
    backdrop="Mountain"
  else
    if !$game_map || !pbGetMetadata($game_map.map_id,MetadataOutdoor)
      backdrop="IndoorA"
    end
  end
  if $game_map
    back=pbGetMetadata($game_map.map_id,MetadataBattleBack)
    if back && back!=""
      backdrop=back
    end
  end
  if $PokemonGlobal && $PokemonGlobal.nextBattleBack
    backdrop=$PokemonGlobal.nextBattleBack
  end
  # Choose bases
  base=""
  trialname=""
  if environ==PBEnvironment::Grass || environ==PBEnvironment::TallGrass
    trialname="Grass"
  elsif environ==PBEnvironment::Sand
    trialname="Sand"
  elsif $PokemonGlobal.surfing
    trialname="Water"
  end
  if pbResolveBitmap(sprintf("Graphics/Battlebacks/playerbase"+backdrop+trialname))
    base=trialname
  end
  # Choose time of day
  time=""
  if ENABLESHADING
    trialname=""
    timenow=pbGetTimeNow
    if PBDayNight.isNight?(timenow)
      trialname="Night"
    elsif PBDayNight.isEvening?(timenow)
      trialname="Eve"
    end
    if pbResolveBitmap(sprintf("Graphics/Battlebacks/battlebg"+backdrop+trialname))
      time=trialname
    end
  end
  # Check for terrain
  if battle.field.effects[PBEffects::ElectricTerrain]>0
    backdrop = "TerrainElectric"
    base = ""
    time = ""
  elsif battle.field.effects[PBEffects::MistyTerrain]>0
    backdrop = "TerrainMisty"
    base = ""
    time = ""
  elsif battle.field.effects[PBEffects::GrassyTerrain]>0
    backdrop = "TerrainGrassy"
    base = ""
    time = ""
  elsif battle.field.effects[PBEffects::PsychicTerrain]>0
    backdrop = "TerrainPsychic"
    base = ""
    time = ""
  end
  # Apply graphics
  battlebg="Graphics/Battlebacks/battlebg"+backdrop+time
  enemybase="Graphics/Battlebacks/enemybase"+backdrop+base+time
  playerbase="Graphics/Battlebacks/playerbase"+backdrop+base+time
  
  return [battlebg,playerbase,enemybase]
  
end
=end








