#===============================================================================
#
#===============================================================================
class PokemonTrainerCard_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene
    @page = 0
    @debug_count = 0
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    background = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/bg_f"))
    if ($Trainer.female? || $game_switches[GPO_MEMBER]) && background
      addBackgroundPlane(@sprites,"bg","Trainer Card/bg_f",@viewport)
    else
      addBackgroundPlane(@sprites,"bg","Trainer Card/bg",@viewport)
    end
    cardexists = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/card_f"))
    @sprites["card"] = IconSprite.new(128,96,@viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["trainer"] = IconSprite.new(336+128,124+96,@viewport)
    @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($Trainer.trainer_type))
    @sprites["trainer"].x -= (@sprites["trainer"].bitmap.width-128)/2
    @sprites["trainer"].y -= (@sprites["trainer"].bitmap.height-128)
    @sprites["trainer"].z = 2
    pbDrawTrainerCardFront
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbGetQuestProgress
    return [0, 0]
    count = $game_variables[QUEST_ARRAY].length
    complete = 0
    for i in 1..count
      if $game_variables[QUEST_ARRAY][i-1].status == 2
        complete += 1
      end
    end
    return [complete, count]
  end

  def pbDrawTrainerCardFront
    if $game_switches[GPO_MEMBER]
      @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_gpo")
    else
      if $Trainer.female? && cardexists
        @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_f")
      else
        @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card")
      end
    end
    @sprites["trainer"].visible=true
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    baseColor   = Color.new(72,72,72)
    shadowColor = Color.new(160,160,160)
    totalsec = Graphics.frame_count / Graphics.frame_rate
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    time = (hour>0) ? _INTL("{1}h {2}m",hour,min) : _INTL("{1}m",min)
    $PokemonGlobal.startTime = pbGetTimeNow if !$PokemonGlobal.startTime
    starttime = _INTL("{1} {2}, {3}",
       pbGetAbbrevMonthName($PokemonGlobal.startTime.mon),
       $PokemonGlobal.startTime.day,
       $PokemonGlobal.startTime.year)
    textPositions = [
       [_INTL("Name"),34,58,0,baseColor,shadowColor],
       [$Trainer.name,302,58,1,baseColor,shadowColor],
       [_INTL("ID No."),332,58,0,baseColor,shadowColor],
       [sprintf("%05d",$Trainer.public_ID),468,58,1,baseColor,shadowColor],
       [_INTL("Money"),34,106,0,baseColor,shadowColor],
       [_INTL("${1}",$Trainer.money.to_s_formatted),302,106,1,baseColor,shadowColor],
       [_INTL("Pokédex"),34,154,0,baseColor,shadowColor],
       [sprintf("%d/%d",$Trainer.pokedex.owned_count,$Trainer.pokedex.seen_count),302,154,1,baseColor,shadowColor],
       [_INTL("Time"),34,202,0,baseColor,shadowColor],
       [time,302,202,1,baseColor,shadowColor],
       [_INTL("Started"),34,250,0,baseColor,shadowColor],
       [starttime,302,250,1,baseColor,shadowColor]
    ]
    if $game_switches[GPO_MEMBER]
      count = $game_variables[MINIQUESTCOUNT]
      name=""
      if count==0
        name="Newbie"
      elsif count==1
        name="Beginner"
      elsif count < 6
        name="Novice"
      elsif count < 12
        name="Competent"
      elsif count < 20
        name="Proficient"
      elsif count < 30
        name="Expert"
      elsif count < 100
        name="Elite"
      elsif count < 1000
        name="Master"
      else
        name="Why?"
      end
      textPositions.push([name,424,250,2,baseColor,shadowColor])
    end
    for t in textPositions
      t[1] += 128; t[2] += 96
    end
    pbDrawTextPositions(overlay,textPositions)
    x = 72
    region = pbGetCurrentRegion(0) # Get the current region
    imagePositions = []
    for i in $Trainer.badges
      imagePositions.push(["Graphics/Pictures/Trainer Card/icon_badges",x,310,i*32,region*32,32,32])
      x += 48
    end
    for i in imagePositions
      t[1] += 128; t[2] += 96
    end
    pbDrawImagePositions(overlay,imagePositions)
  end
  
  def pbDrawTrainerCardBack
    if $game_switches[GPO_MEMBER]
      @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_gpo_2")
    else
      @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_2")
    end
    @sprites["trainer"].visible=false
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    baseColor=Color.new(72,72,72)
    shadowColor=Color.new(160,160,160)
    quest = pbGetQuestProgress
    textPositions=[
       [_INTL("Trainer Battles"),84,82,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.battles),422,82,1,baseColor,shadowColor],
       [_INTL("Wins vs. Trainers"),84,114,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.battles_won),422,114,1,baseColor,shadowColor],
       [_INTL("Wild Encounters"),84,146,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.wild_battles),422,146,1,baseColor,shadowColor],
       [_INTL("Pokémon Captured"),84,178,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.pokemon_caught),422,178,1,baseColor,shadowColor],
       [_INTL("Eggs Hatched"),84,210,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.eggs_hatched),422,210,1,baseColor,shadowColor],
       [_INTL("Steps Taken"),84,242,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.steps_taken),422,242,1,baseColor,shadowColor],
       [_INTL("Money Earned"),84,274,0,baseColor,shadowColor],
       [_INTL("${1}",$Trainer.stats.money_earned),422,274,1,baseColor,shadowColor],
       [_INTL("Money Spent"),84,306,0,baseColor,shadowColor],
       [_INTL("${1}",$Trainer.stats.money_spent),422,306,1,baseColor,shadowColor]
    ]
    for t in textPositions
      t[1] += 128; t[2] += 96
    end
    pbDrawTextPositions(overlay,textPositions,false)
  end

  def pbTrainerCard
    pbSEPlay("GUI trainer card open")
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::C)
        if @page==0
          @page=1
          pbDrawTrainerCardBack
        else
          @page=0
          pbDrawTrainerCardFront
        end
      elsif Input.trigger?(Input::BACK)
        if @debug_count == 8
          if !$DEBUG
            $DEBUG = true
            Kernel.pbMessage("DEBUG MODE ACTIVATED")
          else
            $DEBUG = false
            Kernel.pbMessage("debug mode deactivated")
          end
        end
        pbPlayCloseMenuSE
        break
      end
      if Input.trigger?(Input::LEFT)
        if @debug_count == 0
          @debug_count = 1
        else
          @debug_count = 0
        end
      end
      if Input.trigger?(Input::UP)
        if @debug_count == 1
          @debug_count = 2
        elsif @debug_count == 4
          @debug_count = 5
        elsif @debug_count == 6
          @debug_count = 7
        else
          @debug_count = 0
        end
      end
      if Input.trigger?(Input::RIGHT)
        if @debug_count == 2
          @debug_count = 3
        else
          @debug_count = 0
        end
      end
      if Input.trigger?(Input::DOWN)
        if @debug_count == 3
          @debug_count = 4
        elsif @debug_count == 5
          @debug_count = 6
        elsif @debug_count == 7
          @debug_count = 8
        else
          @debug_count = 0
        end
      end
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

#===============================================================================
#
#===============================================================================
class PokemonTrainerCardScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbTrainerCard
    @scene.pbEndScene
  end
end
