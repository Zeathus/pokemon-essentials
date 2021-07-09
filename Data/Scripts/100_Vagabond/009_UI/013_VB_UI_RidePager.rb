module PBRides
  None      = 0
  Ride      = 1
  Surf      = 2
  Waterfall = 3
  RockClimb = 4
  Strength  = 5
  
  def PBRides.getName(id)
    names=["None",
      "Zebstrika",
      "Wailmer",
      "Lapras",
      "Scrafty",
      "Donphan"]
    return names[id]
  end
  
  def PBRides.getSpecies(id)
    species=[0,
      :ZEBSTRIKA,
      :WAILMER,
      :LAPRAS,
      :SCRAFTY,
      :DONPHAN]
    return species[id]
  end
  
  def PBRides.getType(id)
    types=["",
      "land",
      "water",
      "water",
      "land",
      "land"]
    return types[id]
  end
end

def pbRidePager
  pbSet(RIDE_PAGER,[]) if !$game_variables[RIDE_PAGER].is_a?(Array)
  Kernel.pbMessage("What would you like to do?"+
    "\\ch[1,4,Use,Get Off,Register,Cancel]")
  it=1
  commands=""
  command_ids=[]
  for i in 0...$game_variables[RIDE_PAGER].length
    if $game_variables[RIDE_PAGER][i]
      commands+=PBRides.getName(i)+","
      command_ids[command_ids.length]=i
      it+=1
    end
  end
  commands="\\ch[1,"+it.to_s+","+commands+"Cancel]"
  case $game_variables[1]
  when 0
    Kernel.pbMessage("Choose a Pokémon to call."+commands)
    if $game_variables[1]<it-1
      return false if !pbRideLegal(command_ids[$game_variables[1]])
      pbStartRide(command_ids[$game_variables[1]])
      return true
    end
    return false
  when 1
    if $game_variables[RIDE_CURRENT]<=0
      Kernel.pbMessage("No ride is active.")
      return false
    else
      pbStopRide
      return true
    end
  when 2
    pbSet(RIDE_REGISTERED,[]) if !$game_variables[RIDE_REGISTERED].is_a?(Array)
    Kernel.pbMessage("Choose a Pokémon to register."+commands)
    rideid=command_ids[$game_variables[1]]
    if rideid==0
      Kernel.pbMessage("Can't register None.")
      return false
    end
    if $game_variables[1]<it-1
      Kernel.pbMessage("Which arrow key to link it with?"+
        "\\ch[1,5,Up,Left,Right,Down,Cancel]")
      case $game_variables[1]
      when 0
        $game_variables[RIDE_REGISTERED][Input::UP]=rideid
      when 1
        $game_variables[RIDE_REGISTERED][Input::LEFT]=rideid
      when 2
        $game_variables[RIDE_REGISTERED][Input::RIGHT]=rideid
      when 3
        $game_variables[RIDE_REGISTERED][Input::DOWN]=rideid
      end
      if $game_variables[1]<4
        Kernel.pbMessage("Pokémon registered!")
        Kernel.pbMessage("Access the registered Pokémon by pressing the R key.")
      end
    end
    return false
  end
  return false
end

def pbRegisteredRides
  return if $PokemonBag.pbQuantity(:RIDEPAGER)<=0
  return if $game_player.moving?
  if $game_variables[RIDE_CURRENT]>0 &&
     $game_variables[RIDE_CURRENT]!=PBRides::Surf
    pbStopRide
    return
  end
  pbSet(RIDE_REGISTERED,[]) if !$game_variables[RIDE_REGISTERED].is_a?(Array)
  if $game_variables[RIDE_REGISTERED].length<=0
    Kernel.pbMessage("No Pokémon have been registered.")
  else
    viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z=99999
    midx=Graphics.width/2
    midy=Graphics.height/2-16
    sprites={}
    sprites["select"]=Sprite.new(viewport)
    file="Graphics/Pictures/ridepager_qs"
    sprites["select"].bitmap=RPG::Cache.load_bitmap("",file)
    sprites["select"].x=midx-sprites["select"].bitmap.width/2
    sprites["select"].y=midy-sprites["select"].bitmap.height/2+8
    if $game_variables[RIDE_REGISTERED][Input::UP]
      species=PBRides.getSpecies($game_variables[RIDE_REGISTERED][Input::UP])
      poke=PokeBattle_Pokemon.new(species,5)
      sprites["up"]=PokemonIconSprite.new(poke,viewport)
      sprites["up"].x=midx-32
      sprites["up"].y=midy-86
    end
    if $game_variables[RIDE_REGISTERED][Input::LEFT]
      species=PBRides.getSpecies($game_variables[RIDE_REGISTERED][Input::LEFT])
      poke=PokeBattle_Pokemon.new(species,5)
      sprites["left"]=PokemonIconSprite.new(poke,viewport)
      sprites["left"].x=midx-80
      sprites["left"].y=midy-32
    end
    if $game_variables[RIDE_REGISTERED][Input::RIGHT]
      species=PBRides.getSpecies($game_variables[RIDE_REGISTERED][Input::RIGHT])
      poke=PokeBattle_Pokemon.new(species,5)
      sprites["right"]=PokemonIconSprite.new(poke,viewport)
      sprites["right"].x=midx+22
      sprites["right"].y=midy-32
    end
    if $game_variables[RIDE_REGISTERED][Input::DOWN]
      species=PBRides.getSpecies($game_variables[RIDE_REGISTERED][Input::DOWN])
      poke=PokeBattle_Pokemon.new(species,5)
      sprites["down"]=PokemonIconSprite.new(poke,viewport)
      sprites["down"].x=midx-32
      sprites["down"].y=midy+18
    end
    loop do
      Graphics.update
      viewport.update
      Input.update
      if Input.press?(Input::UP) && $game_variables[RIDE_REGISTERED][Input::UP]
        if pbRideLegal($game_variables[RIDE_REGISTERED][Input::UP])
          pbStartRide($game_variables[RIDE_REGISTERED][Input::UP],false)
        end
        break
      elsif Input.press?(Input::LEFT) && $game_variables[RIDE_REGISTERED][Input::LEFT]
        if pbRideLegal($game_variables[RIDE_REGISTERED][Input::LEFT])
          pbStartRide($game_variables[RIDE_REGISTERED][Input::LEFT],false)
        end
        break
      elsif Input.press?(Input::RIGHT) && $game_variables[RIDE_REGISTERED][Input::RIGHT]
        if pbRideLegal($game_variables[RIDE_REGISTERED][Input::RIGHT])
          pbStartRide($game_variables[RIDE_REGISTERED][Input::RIGHT],false)
        end
        break
      elsif Input.press?(Input::DOWN) && $game_variables[RIDE_REGISTERED][Input::DOWN]
        if pbRideLegal($game_variables[RIDE_REGISTERED][Input::DOWN])
          pbStartRide($game_variables[RIDE_REGISTERED][Input::DOWN],false)
        end
        break
      elsif Input.press?(Input::B)
        break
      end
    end
    pbDisposeSpriteHash(sprites)
    viewport.dispose
  end
end

def pbRideLegal(ride)
  if ride==PBRides::Strength
    hasBoulder = false
    for e in $game_map.events.values
      if e.character_name == "boulder"
        hasBoulder = true
        break
      end
    end
    if !hasBoulder
      Kernel.pbMessage("There are no boulders to push here.")
      return false
    end
  end
  return true
end

def pbStartRide(id, msg=true)
  id=getID(PBRides,id) if id.is_a?(Symbol)
  if $game_variables[RIDE_CURRENT]==id
    Kernel.pbMessage("You already have "+PBRides.getName(id)+" active.") if msg
    return
  end
  Kernel.pbMessage("Called upon " + PBRides.getName(id) +"!") if msg
  $scene.spriteset.addUserAnimation(POOF_ANIMATION_ID,$game_player.x,$game_player.y,true,$game_player)
  $game_variables[RIDE_CURRENT]=id
end

def pbStopRide
  $scene.spriteset.addUserAnimation(POOF_ANIMATION_ID,$game_player.x,$game_player.y,true,$game_player)
  $game_variables[RIDE_CURRENT]=PBRides::None
end

def pbAddRide(id)
  pbSet(RIDE_PAGER,[]) if !$game_variables[RIDE_PAGER].is_a?(Array)
  id=getID(PBRides,id) if id.is_a?(Symbol)
  $game_variables[RIDE_PAGER][id]=true
end

def pbRemoveRide(id)
  pbSet(RIDE_PAGER,[]) if !$game_variables[RIDE_PAGER].is_a?(Array)
  id=getID(PBRides,id) if id.is_a?(Symbol)
  $game_variables[RIDE_PAGER][id]=false
end

def pbHasRide(id)
  id=getID(PBRides,id) if id.is_a?(Symbol)
  if $game_variables[RIDE_PAGER][id]==true
    return true
  end
  return false
end









