def pbStadiumBattle(cup,index=0)
  
  name = cup[0]
  trainers = cup[3]
  trainertypes = []
  for i in trainers
    trainertypes.push(i[0])
  end
  
  opponent = [trainertypes[index], trainers[index][1]]
  
  pbStadiumStart
  pbStadiumTrainers(trainertypes,index,name)
  pbStadiumTeam(opponent[0],opponent[1])
  pbStadiumEnd
  
end

def pbStadiumFinish(cup)
  
  name = cup[0]
  trainers = cup[3]
  trainertypes = []
  for i in trainers
    trainertypes.push(i[0])
  end
  
  pbStadiumStart(true)
  pbStadiumVictory(trainertypes,name)
  pbStadiumEnd
  
end

def pbStadiumStart(finish=false)
  
  viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z = 99999
  
  sprites = {}
  
  sprites["bg"] = AnimatedPlane.new(viewport)
  sprites["bg"].setBitmap("Graphics/Pictures/stadium_bg")
  sprites["bg"].z = 1
  sprites["bg"].opacity = 0
  sprites["bg"].update
  
  pbBGMPlay(finish ? "GSC Intro" : "Stadium Loop")
  
  while sprites["bg"].opacity < 255
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].opacity += 4
    sprites["bg"].ox -= 16
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
  end
  
  while sprites["bg"].ox < 0
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 16
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
  end
  
  pbDisposeSpriteHash(sprites)
  viewport.dispose
  
end

def pbStadiumEnd
  
  viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z = 99999
  
  sprites = {}
  
  sprites["bg"] = AnimatedPlane.new(viewport)
  sprites["bg"].setBitmap("Graphics/Pictures/stadium_bg")
  sprites["bg"].z = 1
  sprites["bg"].update
  
  while sprites["bg"].opacity > 0
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].opacity -= 4
    sprites["bg"].ox -= 16
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
  end
  
  pbDisposeSpriteHash(sprites)
  viewport.dispose
  
end

def pbStadiumTrainers(trainers,index,title)
  
  viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z = 99999
  
  sprites = {}
  
  sprites["bg"] = AnimatedPlane.new(viewport)
  sprites["bg"].setBitmap("Graphics/Pictures/stadium_bg")
  sprites["bg"].z = 1
  sprites["bg"].update
  
  rows = [[1],[2],[3],[4],[3,2],[3,3],[4,3],[4,4]]
  rows = rows[trainers.length - 1]
  xcoords = [0,201,148,97,44]
  ycoords = rows.length == 1 ? [209,251,99] : [154,196,44,238]
  
  sprites["title"] = IconSprite.new(0,0,viewport)
  sprites["title"].setBitmap("Graphics/Pictures/stadium_title")
  sprites["title"].z = 2
  sprites["title"].x = xcoords[4]
  sprites["title"].y = ycoords[0]
  
  sprites["subtitle"] = IconSprite.new(0,0,viewport)
  sprites["subtitle"].setBitmap("Graphics/Pictures/stadium_subtitle")
  sprites["subtitle"].z = 2
  sprites["subtitle"].x = xcoords[4]
  sprites["subtitle"].y = ycoords[1]
  
  # Drawing cup name and battle number
  pbSetSystemFont(sprites["title"].bitmap)
  pbDrawTextPositions(sprites["title"].bitmap,
    [[title.upcase,212,6,2,Color.new(0,0,0),Color.new(120,120,120),1]])
  battletitle = _INTL("BATTLE {1}",index+1)
  battletitle = "SEMIFINAL" if (index+2)==trainers.length
  battletitle = "FINAL" if (index+1)==trainers.length
  pbSetSystemFont(sprites["subtitle"].bitmap)
  pbDrawTextPositions(sprites["subtitle"].bitmap,
    [[battletitle,212,6,2,Color.new(0,0,0),Color.new(120,120,120),1]])
  
  sprites["row1"] = IconSprite.new(0,0,viewport)
  sprites["row1"].setBitmap(_INTL("Graphics/Pictures/stadium_bar{1}",rows[0]))
  sprites["row1"].z = 2
  sprites["row1"].x = xcoords[rows[0]]
  sprites["row1"].y = ycoords[2]
  
  if rows.length == 2
    sprites["row2"] = IconSprite.new(0,0,viewport)
    sprites["row2"].setBitmap(_INTL("Graphics/Pictures/stadium_bar{1}",rows[1]))
    sprites["row2"].z = 2
    sprites["row2"].x = xcoords[rows[1]]
    sprites["row2"].y = ycoords[3]
  end
  
  
  for i in 0...trainers.length
    sprites[_INTL("lock{1}",i)] = IconSprite.new(0,0,viewport)
    sprites[_INTL("lock{1}",i)].setBitmap("Graphics/Pictures/stadium_locked")
    sprites[_INTL("lock{1}",i)].z = 5
    sprites[_INTL("lock{1}",i)].x = (i >= rows[0]) ? ((i-rows[0]) * 104) : (i * 104)
    sprites[_INTL("lock{1}",i)].x += xcoords[(i >= rows[0]) ? rows[1] : rows[0]] + 8
    sprites[_INTL("lock{1}",i)].y = ((i >= rows[0]) ? ycoords[3] : ycoords[2]) + 8
    if i <= index
      trainers[i] = getID(PBTrainers,trainers[i]) if trainers[i].is_a?(Symbol)
      sprites[_INTL("trainer{1}",i)] = IconSprite.new(0,0,viewport)
      sprite = sprites[_INTL("trainer{1}",i)]
      sprite.setBitmap(
        sprintf("Graphics/Characters/trainer%03d",trainers[i]))
      sprite.src_rect = Rect.new(
        sprite.bitmap.width / 2 - 47,0,
        94,94)
      offset = pbStadiumTrainerOffset(trainers[i])
      sprite.src_rect.x -= offset[0]
      sprite.src_rect.y -= offset[1]
      sprite.x = sprites[_INTL("lock{1}",i)].x
      sprite.y = sprites[_INTL("lock{1}",i)].y
      sprite.z = 3
      sprites[_INTL("lock{1}",i)].src_rect = Rect.new(0,0,94,94)
      if i == index
        sprites["select"] = IconSprite.new(sprite.x,sprite.y,viewport)
        sprites["select"].setBitmap("Graphics/Pictures/stadium_marker")
        sprites["select"].z = 4
      else
        sprite.tone = Tone.new(-60,-60,-60,140)
      end
    end
  end
  
  if rows.length == 2
    sprites["row1"].y -= 260
    sprites["row2"].y += 260
    sprites["title"].y -= 260
    sprites["subtitle"].y += 260
    for i in 0...trainers.length
      if i >= rows[0]
        sprites[_INTL("lock{1}",i)].y += 260
      else
        sprites[_INTL("lock{1}",i)].y -= 260
      end
      if i <= index
        sprites[_INTL("trainer{1}",i)].y = sprites[_INTL("lock{1}",i)].y
      end
      if i == index
        sprites["select"].y = sprites[_INTL("lock{1}",i)].y
      end
    end
  else
    sprites["row1"].y -= 260
    sprites["title"].y += 260
    sprites["subtitle"].y += 260
    for i in 0...trainers.length
      sprites[_INTL("lock{1}",i)].y -= 260
      if i <= index
        sprites[_INTL("trainer{1}",i)].y -= 260
      end
      if i == index
        sprites["select"].y -= 260
      end
    end
  end
  
  120.times do
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 16
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
  end
  
  pbSEPlay("Stadium Versus")
  
  13.times do
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 16
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
    if rows.length == 2
      sprites["row1"].y += 20
      sprites["row2"].y -= 20
      sprites["title"].y += 20
      sprites["subtitle"].y -= 20
      for i in 0...trainers.length
        if i >= rows[0]
          sprites[_INTL("lock{1}",i)].y -= 20
        else
          sprites[_INTL("lock{1}",i)].y += 20
        end
        if i <= index
          sprites[_INTL("trainer{1}",i)].y = sprites[_INTL("lock{1}",i)].y
        end
        if i == index
          sprites["select"].y = sprites[_INTL("lock{1}",i)].y
        end
      end
    else
      sprites["row1"].y += 20
      sprites["title"].y -= 20
      sprites["subtitle"].y -= 20
      for i in 0...trainers.length
        sprites[_INTL("lock{1}",i)].y += 20
        if i <= index
          sprites[_INTL("trainer{1}",i)].y += 20
        end
        if i == index
          sprites["select"].y += 20
        end
      end
    end
  end
  
  pbSEPlay("Blow4")
  
  blue_sprites = ["row1","title","subtitle"]
  blue_sprites.push("row2") if rows.length >= 2
  for i in 0...trainers.length
    blue_sprites.push(_INTL("lock{1}",i))
  end
  
  i = 0
  while i < (132 + (index * 6))
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 16
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
    if sprites["select"].opacity % 2 == 0
      sprites["select"].opacity += 8
      sprites["select"].opacity += 1 if sprites["select"].opacity > 240
    else
      sprites["select"].opacity -= 8
      sprites["select"].opacity -= 1 if sprites["select"].opacity < 100
    end
    
    if i > 6
      for j in 0..index
        if (i-6) > j*6
          sprites[_INTL("lock{1}",j)].src_rect.y += 12
          sprites[_INTL("lock{1}",j)].src_rect.height -= 12
        end
      end
    end
    
    if i < 8
      for s in blue_sprites
        sprites[s].tone.red += 12
        sprites[s].tone.green += 12
        sprites[s].tone.blue += 24
      end
    elsif i < 16
      for s in blue_sprites
        sprites[s].tone.red -= 12
        sprites[s].tone.green -= 12
        sprites[s].tone.blue -= 24
      end
    end
    
    i+=1
  end
  
  pbSEPlay("Wind1")
  
  32.times do
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 16
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
    if sprites["select"].opacity % 2 == 0
      sprites["select"].opacity += 8
      sprites["select"].opacity += 1 if sprites["select"].opacity > 240
    else
      sprites["select"].opacity -= 8
      sprites["select"].opacity -= 1 if sprites["select"].opacity < 100
    end
    
    if rows.length == 2
      sprites["row1"].x += 24
      sprites["row2"].x -= 24
      sprites["title"].x -= 24
      sprites["subtitle"].x += 24
      for i in 0...trainers.length
        if i >= rows[0]
          sprites[_INTL("lock{1}",i)].x -= 24
        else
          sprites[_INTL("lock{1}",i)].x += 24
        end
        if i <= index
          sprites[_INTL("trainer{1}",i)].x = sprites[_INTL("lock{1}",i)].x
        end
        if i == index
          sprites["select"].x = sprites[_INTL("lock{1}",i)].x
        end
      end
    else
      sprites["row1"].x += 24
      sprites["title"].x -= 24
      sprites["subtitle"].x += 24
      for i in 0...trainers.length
        sprites[_INTL("lock{1}",i)].x += 24
        if i <= index
          sprites[_INTL("trainer{1}",i)].x += 24
        end
        if i == index
          sprites["select"].x += 24
        end
      end
    end
  end
  
  while sprites["bg"].ox < 0
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 24
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
  end
  
  pbDisposeSpriteHash(sprites)
  viewport.dispose
  
end

def pbStadiumVictory(trainers,title)
  
  viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z = 99999
  
  sprites = {}
  
  sprites["bg"] = AnimatedPlane.new(viewport)
  sprites["bg"].setBitmap("Graphics/Pictures/stadium_bg")
  sprites["bg"].z = 1
  sprites["bg"].update

  index = trainers.length - 1
  
  rows = [[1],[2],[3],[4],[3,2],[3,3],[4,3],[4,4]]
  rows = rows[trainers.length - 1]
  xcoords = [0,201,148,97,44]
  ycoords = rows.length == 1 ? [209,251,99] : [154,196,44,238]
  
  sprites["title"] = IconSprite.new(0,0,viewport)
  sprites["title"].setBitmap("Graphics/Pictures/stadium_title")
  sprites["title"].z = 2
  sprites["title"].x = xcoords[4]
  sprites["title"].y = ycoords[0]
  
  sprites["subtitle"] = IconSprite.new(0,0,viewport)
  sprites["subtitle"].setBitmap("Graphics/Pictures/stadium_subtitle")
  sprites["subtitle"].z = 2
  sprites["subtitle"].x = xcoords[4]
  sprites["subtitle"].y = ycoords[1]
  
  # Drawing cup name and battle number
  pbSetSystemFont(sprites["title"].bitmap)
  pbDrawTextPositions(sprites["title"].bitmap,
    [[title.upcase,212,6,2,Color.new(0,0,0),Color.new(120,120,120),1]])
  battletitle = "RESULTS"
  pbSetSystemFont(sprites["subtitle"].bitmap)
  pbDrawTextPositions(sprites["subtitle"].bitmap,
    [[battletitle,212,6,2,Color.new(0,0,0),Color.new(120,120,120),1]])
  
  sprites["row1"] = IconSprite.new(0,0,viewport)
  sprites["row1"].setBitmap(_INTL("Graphics/Pictures/stadium_bar{1}",rows[0]))
  sprites["row1"].z = 2
  sprites["row1"].x = xcoords[rows[0]]
  sprites["row1"].y = ycoords[2]
  
  if rows.length == 2
    sprites["row2"] = IconSprite.new(0,0,viewport)
    sprites["row2"].setBitmap(_INTL("Graphics/Pictures/stadium_bar{1}",rows[1]))
    sprites["row2"].z = 2
    sprites["row2"].x = xcoords[rows[1]]
    sprites["row2"].y = ycoords[3]
  end
  
  for i in 0...trainers.length
    sprites[_INTL("lock{1}",i)] = IconSprite.new(0,0,viewport)
    sprites[_INTL("lock{1}",i)].setBitmap("Graphics/Pictures/stadium_defeat")
    sprites[_INTL("lock{1}",i)].z = 5
    sprites[_INTL("lock{1}",i)].x = (i >= rows[0]) ? ((i-rows[0]) * 104) : (i * 104)
    sprites[_INTL("lock{1}",i)].x += xcoords[(i >= rows[0]) ? rows[1] : rows[0]] + 8
    sprites[_INTL("lock{1}",i)].y = ((i >= rows[0]) ? ycoords[3] : ycoords[2]) + 8
    if i <= index
      trainers[i] = getID(PBTrainers,trainers[i]) if trainers[i].is_a?(Symbol)
      sprites[_INTL("trainer{1}",i)] = IconSprite.new(0,0,viewport)
      sprite = sprites[_INTL("trainer{1}",i)]
      sprite.setBitmap(
        sprintf("Graphics/Characters/trainer%03d",trainers[i]))
      sprite.src_rect = Rect.new(
        sprite.bitmap.width / 2 - 47,0,
        94,94)
      offset = pbStadiumTrainerOffset(trainers[i])
      sprite.src_rect.x -= offset[0]
      sprite.src_rect.y -= offset[1]
      sprite.x = sprites[_INTL("lock{1}",i)].x
      sprite.y = sprites[_INTL("lock{1}",i)].y
      sprite.z = 3
      sprites[_INTL("lock{1}",i)].visible = false
      sprite.tone = Tone.new(-60,-60,-60,140)
    end
  end
  
  if rows.length == 2
    sprites["row1"].y -= 260
    sprites["row2"].y += 260
    sprites["title"].y -= 260
    sprites["subtitle"].y += 260
    for i in 0...trainers.length
      if i >= rows[0]
        sprites[_INTL("lock{1}",i)].y += 260
      else
        sprites[_INTL("lock{1}",i)].y -= 260
      end
      if i <= index
        sprites[_INTL("trainer{1}",i)].y = sprites[_INTL("lock{1}",i)].y
      end
    end
  else
    sprites["row1"].y -= 260
    sprites["title"].y += 260
    sprites["subtitle"].y += 260
    for i in 0...trainers.length
      sprites[_INTL("lock{1}",i)].y -= 260
      if i <= index
        sprites[_INTL("trainer{1}",i)].y -= 260
      end
    end
  end
  
  150.times do
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 16
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
  end
  
  13.times do
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 16
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
    if rows.length == 2
      sprites["row1"].y += 20
      sprites["row2"].y -= 20
      sprites["title"].y += 20
      sprites["subtitle"].y -= 20
      for i in 0...trainers.length
        if i >= rows[0]
          sprites[_INTL("lock{1}",i)].y -= 20
        else
          sprites[_INTL("lock{1}",i)].y += 20
        end
        if i <= index
          sprites[_INTL("trainer{1}",i)].y = sprites[_INTL("lock{1}",i)].y
        end
      end
    else
      sprites["row1"].y += 20
      sprites["title"].y -= 20
      sprites["subtitle"].y -= 20
      for i in 0...trainers.length
        sprites[_INTL("lock{1}",i)].y += 20
        if i <= index
          sprites[_INTL("trainer{1}",i)].y += 20
        end
      end
    end
  end
  
  pbSEPlay("Blow4")
  
  blue_sprites = ["row1","title","subtitle"]
  blue_sprites.push("row2") if rows.length >= 2
  for i in 0...trainers.length
    blue_sprites.push(_INTL("lock{1}",i))
  end
  
  speed = 111
  i = 0
  done = false
  while !done
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 24
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
    
    if i >= speed
      for j in 0..index
        if (i-speed) == j*speed/2
          pbSEPlay("PRSFX- Feint2",120,80+((j*80)/index))
          sprites[_INTL("lock{1}",j)].visible = true
          if j==index
            done = true
          end
        end
      end
    end
    
    if i < 8
      for s in blue_sprites
        sprites[s].tone.red += 12
        sprites[s].tone.green += 12
        sprites[s].tone.blue += 24
      end
    elsif i < 16
      for s in blue_sprites
        sprites[s].tone.red -= 12
        sprites[s].tone.green -= 12
        sprites[s].tone.blue -= 24
      end
    end
    
    i+=1
  end
  
  ((index % 2 == 0) ? (speed*1.5) : speed).times do
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 24
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
  end
  
  pbMEPlay("SlotsBigWin", 140)
  
  sprites["victory"] = IconSprite.new(
    0,Graphics.height/2-40,viewport)
  sprites["victory"].setBitmap("Graphics/Pictures/stadium_victory")
  sprites["victory"].opacity = 0
  sprites["victory"].z = 9
  
  180.times do
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 24
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
    
    sprites["victory"].opacity += 12
  end
  
  pbSEPlay("Wind1")
  
  32.times do
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 24
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
    
    sprites["victory"].opacity -= 16
    
    if rows.length == 2
      sprites["row1"].x += 24
      sprites["row2"].x -= 24
      sprites["title"].x -= 24
      sprites["subtitle"].x += 24
      for i in 0...trainers.length
        if i >= rows[0]
          sprites[_INTL("lock{1}",i)].x -= 24
        else
          sprites[_INTL("lock{1}",i)].x += 24
        end
        if i <= index
          sprites[_INTL("trainer{1}",i)].x = sprites[_INTL("lock{1}",i)].x
        end
      end
    else
      sprites["row1"].x += 24
      sprites["title"].x -= 24
      sprites["subtitle"].x += 24
      for i in 0...trainers.length
        sprites[_INTL("lock{1}",i)].x += 24
        if i <= index
          sprites[_INTL("trainer{1}",i)].x += 24
        end
      end
    end
  end
  
  while sprites["bg"].ox < 0
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 24
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
  end
  
  pbDisposeSpriteHash(sprites)
  viewport.dispose
  
end



def pbStadiumTeam(type,name,team=0)
  
  type = getID(PBTrainers,type) if type.is_a?(Symbol)
  trainer = pbLoadTrainer(type,name,team)
  party = trainer[2]
  
  viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z = 99999
  
  sprites = {}
  
  sprites["bg"] = AnimatedPlane.new(viewport)
  sprites["bg"].setBitmap("Graphics/Pictures/stadium_bg")
  sprites["bg"].z = 1
  sprites["bg"].update
  
  sprites["player"] = IconSprite.new(44,44,viewport)
  sprites["player"].setBitmap("Graphics/Pictures/stadium_team_player")
  sprites["player"].z = 2
  
  sprites["player_img"] = IconSprite.new(60,52,viewport)
  sprites["player_img"].setBitmap(
    sprintf("Graphics/Characters/trainer%03d",$Trainer.trainertype))
  sprites["player_img"].z = 3
  sprites["player_img"].src_rect = Rect.new(
    sprites["player_img"].bitmap.width/2 - 47, 0, 94, 94)
  
  sprites["opponent"] = IconSprite.new(44,196,viewport)
  sprites["opponent"].setBitmap("Graphics/Pictures/stadium_team_opponent")
  sprites["opponent"].z = 2
  
  sprites["opponent_img"] = IconSprite.new(358,246,viewport)
  sprites["opponent_img"].setBitmap(
    sprintf("Graphics/Characters/trainer%03d",type))
  sprites["opponent_img"].z = 3
  sprites["opponent_img"].src_rect = Rect.new(
    sprites["opponent_img"].bitmap.width/2 - 47, 0, 94, 94)
  offset = pbStadiumTrainerOffset(type)
  sprites["opponent_img"].src_rect.x -= offset[0]
  sprites["opponent_img"].src_rect.y -= offset[1]
    
  sprites["vs"] = IconSprite.new(206,160,viewport)
  sprites["vs"].setBitmap("Graphics/Pictures/stadium_vs")
  sprites["vs"].z = 6
  sprites["vs"].opacity = 0
  
  typename = PBTrainers.getName(type)
  if typename.length > 11 && typename.include?(" ")
    typename = typename[(typename.index(" ")+1)..typename.length]
  end
    
  # Drawing cup name and battle number
  pbSetSmallFont(sprites["player"].bitmap)
  pbDrawTextPositions(sprites["player"].bitmap,
    [["Trainer",14,102,0,Color.new(250,250,250),Color.new(40,40,40),1],
     [$Trainer.name.upcase,14,124,0,Color.new(250,250,250),Color.new(40,40,40),1]])
  pbSetSmallFont(sprites["opponent"].bitmap)
  pbDrawTextPositions(sprites["opponent"].bitmap,
    [[typename,312,2,0,Color.new(250,250,250),Color.new(40,40,40),1],
     [name.upcase,312,24,0,Color.new(250,250,250),Color.new(40,40,40),1]])
  
  x_coords = [180,280,380,180,280,380]
  y_coords = [52,52,52,124,124,124]
  
  top_sprites = ["player", "player_img"]
  bottom_sprites = ["opponent", "opponent_img"]
  blue_sprites = ["player", "opponent"]
  
  for i in 0...6
    # Player party
    sprites[_INTL("plock{1}",i)] = IconSprite.new(358,246,viewport)
    sprites[_INTL("plock{1}",i)].setBitmap("Graphics/Pictures/stadium_team_lock")
    sprites[_INTL("plock{1}",i)].z = 5
    sprites[_INTL("plock{1}",i)].src_rect = Rect.new(0, 0, 90, 64)
    sprites[_INTL("plock{1}",i)].x = x_coords[i] - 12
    sprites[_INTL("plock{1}",i)].y = y_coords[i]
    if $Trainer.party.length > i
      sprites[_INTL("ppokemon{1}",i)] =
        PokemonIconSprite.new($Trainer.party[i],viewport)
      sprites[_INTL("ppokemon{1}",i)].z = 4
      sprites[_INTL("ppokemon{1}",i)].x = x_coords[i]
      sprites[_INTL("ppokemon{1}",i)].y = y_coords[i]
      top_sprites.push(_INTL("ppokemon{1}",i))
    end
    
    # Opponent party
    sprites[_INTL("olock{1}",i)] = IconSprite.new(358,246,viewport)
    sprites[_INTL("olock{1}",i)].setBitmap("Graphics/Pictures/stadium_team_lock")
    sprites[_INTL("olock{1}",i)].z = 5
    sprites[_INTL("olock{1}",i)].src_rect = Rect.new(0, 0, 90, 64)
    sprites[_INTL("olock{1}",i)].x = x_coords[i] - 126
    sprites[_INTL("olock{1}",i)].y = y_coords[i] + 152
    if party.length > i
      sprites[_INTL("opokemon{1}",i)] =
        PokemonIconSprite.new(party[i],viewport)
      sprites[_INTL("opokemon{1}",i)].z = 4
      sprites[_INTL("opokemon{1}",i)].x = x_coords[i] - 114
      sprites[_INTL("opokemon{1}",i)].y = y_coords[i] + 152
      bottom_sprites.push(_INTL("opokemon{1}",i))
    end
    top_sprites.push(_INTL("plock{1}",i))
    bottom_sprites.push(_INTL("olock{1}",i))
    blue_sprites.push(_INTL("plock{1}",i))
    blue_sprites.push(_INTL("olock{1}",i))
  end
  
  for s in top_sprites
    sprites[s].y -= 260
  end
  
  for s in bottom_sprites
    sprites[s].y += 260
  end
  
  13.times do
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 24
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
    for s in top_sprites
      sprites[s].y += 20
    end
    for s in bottom_sprites
      sprites[s].y -= 20
    end
  end
  
  pbSEPlay("Blow4")
  
  played_se = false
  i = 0
  while i < 160
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 24
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
    
    if i > 6
      for j in 0...6
        if (i-6) > j*6
          if $Trainer.party.length > j
            sprites[_INTL("plock{1}",j)].src_rect.y += 12
            sprites[_INTL("plock{1}",j)].src_rect.height -= 12
          end
          if party.length > j
            sprites[_INTL("olock{1}",j)].src_rect.y += 12
            sprites[_INTL("olock{1}",j)].src_rect.height -= 12
          end
        end
      end
    end
    
    if i % 2 == 0
      for j in 0...6
        if $Trainer.party.length > j
          sprites[_INTL("ppokemon{1}",j)].update
        end
        if party.length > j
          sprites[_INTL("opokemon{1}",j)].update
        end
      end
    end
    
    if i < 8
      for s in blue_sprites
        sprites[s].tone.red += 12
        sprites[s].tone.green += 12
        sprites[s].tone.blue += 24
      end
    elsif i < 16
      for s in blue_sprites
        sprites[s].tone.red -= 12
        sprites[s].tone.green -= 12
        sprites[s].tone.blue -= 24
      end
    end
    
    if i > 10 + ($Trainer.party.length * 6) && i > 10 + (party.length * 6) && i < 80
      pbSEPlay("Harden",160) if !played_se
      played_se = true
      sprites["vs"].opacity += 16
    end
    
    if i > 150
      sprites["vs"].opacity -= 16
    end
    
    i+=1
  end
  
  pbSEPlay("Wind1")
  
  32.times do
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 24
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
    
    sprites["vs"].opacity -= 16
    
    for s in top_sprites
      sprites[s].x -= 24
    end
    for s in bottom_sprites
      sprites[s].x += 24
    end
  end
  
  while sprites["bg"].ox < 0
    Graphics.update
    viewport.update
    Input.update
    
    sprites["bg"].ox -= 24
    sprites["bg"].ox = 0 if sprites["bg"].ox <= -512
  end
  
  pbDisposeSpriteHash(sprites)
  viewport.dispose
  
end

def pbStadiumTrainerOffset(type)
  
  case type
  when :BLACKBELT, :CRUSHGIRL
    return [  0,-10]
  when :JANITOR
    return [ -6,-10]
  when :NURSERYAID, :BUGCATCHER, :TAMER
    return [  0,-14]
  when :YOUNGSTER, :SCHOOLBOY, :SCHOOLGIRL,
       :LIBRARIAN, :DOCTOR, :ROUGHNECK,
       :CHANNELER, :ENGINEER, :BURGLAR
    return [  0,-28]
  when :RUINMANIAC
    return [ 10,-24]
  when :PRESCHOOLER_M, :PRESCHOOLER_F,
       :SWIMMER_M
    return [  0,-44]
  when :TWINS
    return [  4,-44]
  when :PKMNRANGER_M, :MINER, :GUITARIST,
       :PKMNFAN_M, :MAID
    return [  8,  0]
  when :GAMBLER
    return [ -8,  0]
  when :BACKPACKER_F, :CYCLIST_F
    return [-14,  0]
  when :FISHERMAN
    return [-36, -6]
  when :ACETRAINER_M
    return [  0,  4]
  end
  
  return [0,0]
end

def pbStadiumMenu
  
  viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  sprites = {}
  
  ret = 0
  
  cups = pbStadiumCups
  
  sprites["searchtitle"]=Window_AdvancedTextPokemon.newWithSize("",2,-16,Graphics.width,64,viewport)
  sprites["searchtitle"].windowskin=nil
  sprites["searchtitle"].baseColor=Color.new(248,248,248)
  sprites["searchtitle"].shadowColor=Color.new(0,0,0)
  sprites["searchtitle"].text=_ISPRINTF("<b><outln2><ac>Pokémon Stadium</ac><outln><b>")
  sprites["searchlist"]=Window_ComplexCommandPokemon.newEmpty(-6,32,258,352,viewport)
  sprites["searchlist"].baseColor=Color.new(88,88,80)
  sprites["searchlist"].shadowColor=Color.new(168,184,184)
  sprites["searchlist"].commands=[
    "Select a Cup",
    cups[0] + ["Cancel"]
  ]
  sprites["auxlist"]=Window_UnformattedTextPokemon.newWithSize("",254,32,264,194,viewport)
  sprites["auxlist"].baseColor=Color.new(88,88,80)
  sprites["auxlist"].shadowColor=Color.new(168,184,184)
  sprites["messagebox"]=Window_UnformattedTextPokemon.newWithSize("",254,226,264,158,viewport)
  sprites["messagebox"].baseColor=Color.new(88,88,80)
  sprites["messagebox"].shadowColor=Color.new(168,184,184)
  sprites["messagebox"].letterbyletter=false
  
  sprites["difficulty"]=IconSprite.new(384,342,viewport)
  sprites["difficulty"].setBitmap("Graphics/Pictures/stadium_difficulty")
  sprites["difficulty"].src_rect = Rect.new(0,0,120,22)
  sprites["difficulty"].z=999
  
  for i in 0...10
    sprites[_INTL("complete{1}",i)]=IconSprite.new(204,50+32*i,viewport)
    sprites[_INTL("complete{1}",i)].setBitmap("Graphics/Pictures/quests_complete")
    sprites[_INTL("complete{1}",i)].z=999
    sprites[_INTL("complete{1}",i)].visible=false
  end
  
  sprites["searchlist"].index=1
  searchlist=sprites["searchlist"]
  sprites["messagebox"].visible=true
  sprites["auxlist"].visible=true
  sprites["searchlist"].visible=true
  sprites["searchtitle"].visible=true
  pbRefreshStadiumMenu(sprites,cups)
  pbFadeInAndShow(sprites)
  pbActivateWindow(sprites,"searchlist"){
     loop do
       Graphics.update
       Input.update
       oldindex=searchlist.index
       pbUpdateSpriteHash(sprites)
       if searchlist.index==0
         if oldindex == 1
            searchlist.index = cups[0].length + 1
         else
           searchlist.index = 1
         end
       end
       if searchlist.index == 1
         searchlist.top_row = 0
         searchlist.index = 1
       end
       if searchlist.index!=oldindex
         pbRefreshStadiumMenu(sprites,cups)
       end
       if Input.trigger?(Input::C)
         pbPlayDecisionSE()
         if searchlist.index==cups[0].length + 1
           break
         else
           index = searchlist.index - 1
           Kernel.pbMessage(_INTL(
             "Do you want to attend the {1}?\\ch[1,2,Yes,No]",
             cups[0][index]))
           if $game_variables[1]==0
             ret = [
               cups[0][index],
               cups[1][index],
               cups[2][index],
               cups[3][index],
               0
             ]
             break
           end
         end
       elsif Input.trigger?(Input::B)
         pbPlayCancelSE()
         break
       end
     end
  }
  pbFadeOutAndHide(sprites)
  pbDisposeSpriteHash(sprites)
  viewport.dispose
  Input.update
  return ret
  
end

def pbRefreshStadiumMenu(sprites,cups)
  searchlist=sprites["searchlist"]
  messagebox=sprites["messagebox"]
  auxlist=sprites["auxlist"]
  difficulty=sprites["difficulty"]
  names=cups[0]
  helptexts=cups[1]
  index = searchlist.index-1
  stats=cups[2][index]
  if helptexts[index]
    auxlist.text = names[index].upcase + "\n" + helptexts[index]
    messagebox.text = sprintf(
      "Max Level: %d\nBattles: %d\nPokemon per Battle: %d\nDifficulty: ",
      stats[0],cups[3][index].length,stats[1])
    difficulty.src_rect.width = 20 * stats[2]
  else
    auxlist.text=""
    messagebox.text=""
    difficulty.src_rect.width=0
  end
  
  # Draw checkmarks for completed cups
  startindex=searchlist.top_item
  for i in 0...10
    sprite=sprites[_INTL("complete{1}",i)]
    index = i + startindex
    if index != 0
      if names[index - 1]
        if pbStadiumHasWonCup(names[index - 1])
          sprite.visible = true
          next
        end
      end
    end
    sprite.visible = false
  end
  
end

def pbStadiumHasWonCup(name)
  if $game_variables[STADIUM_WON_CUPS].is_a?(Array)
    for cup in $game_variables[STADIUM_WON_CUPS]
      return true if cup == name
    end
  end
  return false
end

def pbStadiumCup
  return $game_variables[STADIUM_CUP]
end

def pbStadiumCupIndex
  cup = pbStadiumCup
  return cup[cup.length - 1]
end

def pbStadiumCupNextIndex
  cup = pbStadiumCup
  cup[cup.length - 1]+=1
end

def pbStadiumCupIsDone
  cup = pbStadiumCup
  cup[cup.length - 1]>=cup[3].length
end

def pbStadiumCupTrainer
  cup = pbStadiumCup
  index = pbStadiumCupIndex
  return pbTrainerBattle(
    cup[3][index][0],
    cup[3][index][1],
    _I(cup[3][index][3]),
    false,
    cup[3][index][2] ? cup[3][index][2] : 0,
    true,
    nil,
    false)
end

def pbStadiumWin(cup)
  
  if !$game_variables[STADIUM_WON_CUPS].is_a?(Array)
    $game_variables[STADIUM_WON_CUPS] = []
  end
  
  if !$game_variables[STADIUM_WON_CUPS].include?(cup[0])
    $game_variables[STADIUM_WON_CUPS].push(cup[0])
    points = (100 * (2**(cup[2][2]-1)))
    $game_variables[STADIUM_POINTS] += points
    return points
  end
  
  return false
  
end

def pbStadiumSetup
  
  events = $game_map.events.values
  cup = pbStadiumCup
  index = pbStadiumCupIndex
  trainer = cup[3][index][0]
  trainer = getID(PBTrainers,trainer) if trainer.is_a?(Symbol)
  difficulty = cup[2][2]
  chance = 9 - difficulty
  chance -= 1 if cup[3].length - 2 == index
  chance -= 2 if cup[3].length - 1 == index
  chance = 2 if chance < 2
  
  spectators = [
    "NPC 02", "NPC 04", "NPC 05", "NPC 06", "NPC 07",
    "NPC 33", "NPC 35", "NPC 36", "NPC 37",
    "trchar005", "trchar006", "trchar007", "trchar008",
    "trchar012", "trchar013", "trchar011", "trchar019",
    "trchar020", "trchar022", "trchar030", "trchar031",
    "trchar032", "trchar036", "trchar037", "trchar048",
    "trchar050", "trchar051", "trchar061"
  ]
  
  rare_spectators = [
    "NPC 08", "NPC 10", "NPC 11",
    "trchar015", "trchar016", "trchar045", "trchar047",
    "trchar052", "trchar053"
  ]
  
  for event in events
    
    if event.id == 1 || event.id == 3 # Player Sprites
      event.character_name = $game_player.character_name
    elsif event.id == 2 || event.id == 4 # Opponent Sprites
      event.character_name = sprintf("trchar%03d",trainer)
    elsif event.name == "Spectator"
      if rand(chance)==0
        if rand(4)==0
          event.character_name = rare_spectators[rand(rare_spectators.length)]
        else
          event.character_name = spectators[rand(spectators.length)]
        end
      else
        event.character_name = ""
      end
    end
  end
  
end

def pbStadiumRuleset
  cup = pbStadiumCup
  maxpkmn = cup[2][1]
  maxlvl = cup[2][0]
  $game_variables[LEAGUE_MAX_PKMN] = maxpkmn
  $game_variables[LEAGUE_MAX_LVL] = maxlvl
end

def pbDisplayStadiumPointsWindow(msgwindow,goldwindow)
  coinString=$game_variables[STADIUM_POINTS].to_s
  coinwindow=Window_AdvancedTextPokemon.new(_INTL("Points:\n<ar>{1}</ar>",coinString))
  coinwindow.setSkin("Graphics/Windowskins/goldskin")
  coinwindow.resizeToFit(coinwindow.text,Graphics.width)
  coinwindow.width=160 if coinwindow.width<=160
  if msgwindow.y==0
    coinwindow.y=(goldwindow) ? goldwindow.y-coinwindow.height : Graphics.height-coinwindow.height
  else
    coinwindow.y=(goldwindow) ? goldwindow.height : 0
  end
  coinwindow.viewport=msgwindow.viewport
  coinwindow.z=msgwindow.z
  return coinwindow
end









