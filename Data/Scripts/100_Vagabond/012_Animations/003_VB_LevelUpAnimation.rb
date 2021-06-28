
def pbLevelUpAnimation(pokemon,battler,oldtotalhp,oldattack,olddefense,oldspeed,oldspatk,oldspdef)
  
    return if $PokemonSystem.levelup==1
    
    viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    viewport.z = 999999
    
    base1=Color.new(248,248,248)
    shadow1=Color.new(104,104,104)
    base2=Color.new(64,64,64)
    shadow2=Color.new(176,176,176)
    
    frames = [512,470,410,370,350,340]
    
    sprites = {}
    
    sprites["icon"]=PokemonIconSprite.new(pokemon,viewport)
    sprites["icon"].x = 512
    sprites["icon"].y = 12
    sprites["icon"].z = 5
    
    sprites["display"]=Sprite.new(viewport)
    sprites["display"].bitmap = BitmapCache.load_bitmap("Graphics/Pictures/levelup")
    sprites["display"].x = 512
    sprites["display"].y = 42
    sprites["display"].z = 1
    
    sprites["names"]=Sprite.new(viewport)
    sprites["names"].bitmap = Bitmap.new(
      sprites["display"].bitmap.width,sprites["display"].bitmap.height)
    sprites["names"].x = 512
    sprites["names"].y = 42
    sprites["names"].z = 2
    nametextpos=[
      [_INTL("HP"),120,30,2,base2,shadow2],
      [_INTL("Attack"),120,58,2,base2,shadow2],
      [_INTL("Defense"),120,86,2,base2,shadow2],
      [_INTL("Sp. Atk"),120,114,2,base2,shadow2],
      [_INTL("Sp. Def"),120,142,2,base2,shadow2],
      [_INTL("Speed"),120,170,2,base2,shadow2]
    ]
    pbSetSmallFont(sprites["names"].bitmap)
    pbDrawTextPositions(sprites["names"].bitmap,nametextpos)
    
    ycoords=[30,58,86,114,142,170]
    stats=[
      oldtotalhp,
      oldattack,
      olddefense,
      oldspatk,
      oldspdef,
      oldspeed]
    for i in 0...6
      sprites[_INTL("oldstats{1}",i)]=Sprite.new(viewport)
      sprites[_INTL("oldstats{1}",i)].bitmap = Bitmap.new(
        sprites["display"].bitmap.width,sprites["display"].bitmap.height)
      sprites[_INTL("oldstats{1}",i)].x = 512
      sprites[_INTL("oldstats{1}",i)].y = 42
      sprites[_INTL("oldstats{1}",i)].z = 2
      oldstattextpos=[
        [sprintf("%d",stats[i]),40,ycoords[i],2,base2,shadow2]
      ]
      pbSetSmallFont(sprites[_INTL("oldstats{1}",i)].bitmap)
      pbDrawTextPositions(sprites[_INTL("oldstats{1}",i)].bitmap,oldstattextpos)
    end
    sprites["oldlevel"]=Sprite.new(viewport)
    sprites["oldlevel"].bitmap = Bitmap.new(
      sprites["display"].bitmap.width,sprites["display"].bitmap.height)
    sprites["oldlevel"].x = 512
    sprites["oldlevel"].y = 42
    sprites["oldlevel"].z = 2
    leveltextpos=[[(pokemon.level-1).to_s,60,2,0,base1,shadow1]]
    pbSetSmallFont(sprites["oldlevel"].bitmap)
    pbDrawTextPositions(sprites["oldlevel"].bitmap,leveltextpos)
    
    stats=[
      pokemon.totalhp-oldtotalhp,
      pokemon.attack-oldattack,
      pokemon.defense-olddefense,
      pokemon.spatk-oldspatk,
      pokemon.spdef-oldspdef,
      pokemon.speed-oldspeed]
    for i in 0...6
      sprites[_INTL("increase{1}",i)]=Sprite.new(viewport)
      sprites[_INTL("increase{1}",i)].bitmap = Bitmap.new(
        sprites["display"].bitmap.width,sprites["display"].bitmap.height)
      sprites[_INTL("increase{1}",i)].x = 512
      sprites[_INTL("increase{1}",i)].y = 42
      sprites[_INTL("increase{1}",i)].z = 0
      increasetextpos=[
        [sprintf("+%d",stats[i]),40,ycoords[i],1,base1,shadow1]
      ]
      #sprites[_INTL("increase{1}",i)].bitmap.fill_rect(
      #  16,ycoords[i]+4,26,20,Color.new(0,0,0,100))
      pbSetSmallFont(sprites[_INTL("increase{1}",i)].bitmap)
      pbDrawTextPositions(sprites[_INTL("increase{1}",i)].bitmap,increasetextpos)
    end
    
    stats=[
      pokemon.totalhp,
      pokemon.attack,
      pokemon.defense,
      pokemon.spatk,
      pokemon.spdef,
      pokemon.speed]
    for i in 0...6
      sprites[_INTL("newstats{1}",i)]=Sprite.new(viewport)
      sprites[_INTL("newstats{1}",i)].bitmap = Bitmap.new(
        sprites["display"].bitmap.width,sprites["display"].bitmap.height)
      sprites[_INTL("newstats{1}",i)].x = 512
      sprites[_INTL("newstats{1}",i)].y = 42
      sprites[_INTL("newstats{1}",i)].z = 3
      sprites[_INTL("newstats{1}",i)].visible = false
      oldstattextpos=[
        [sprintf("%d",stats[i]),40,ycoords[i],2,base2,shadow2]
      ]
      pbSetSmallFont(sprites[_INTL("newstats{1}",i)].bitmap)
      pbDrawTextPositions(sprites[_INTL("newstats{1}",i)].bitmap,oldstattextpos)
    end
    sprites["newlevel"]=Sprite.new(viewport)
    sprites["newlevel"].bitmap = Bitmap.new(
      sprites["display"].bitmap.width,sprites["display"].bitmap.height)
    sprites["newlevel"].x = 512
    sprites["newlevel"].y = 42
    sprites["newlevel"].z = 3
    leveltextpos=[[pokemon.level.to_s,60,2,0,base1,shadow1]]
    pbSetSmallFont(sprites["newlevel"].bitmap)
    pbDrawTextPositions(sprites["newlevel"].bitmap,leveltextpos)
    
    max=50
    for i in 0...max
      Graphics.update
      viewport.update
      Input.update
      sprites["display"].update
      if i < 6
        sprites["display"].x = frames[i]
        sprites["names"].x = sprites["display"].x
        for j in 0...6
          sprites[_INTL("oldstats{1}",j)].x = sprites["display"].x
        end
        sprites["oldlevel"].x = sprites["display"].x
        sprites["icon"].x = sprites["display"].x + 100
      end
      if i >= 6 && i < 40
        if i == 20
          sprites["oldlevel"].visible=false
          sprites["newlevel"].x = sprites["display"].x
          sprites["newlevel"].visible=true
        end
        if (i >= 20) && (i < 24)
          frame = [-4,-2, 2, 4][i - 20]
          sprites["newlevel"].y += frame
        end
        for j in 0...6
          if (i >= 6 + j) && (i < 8 + j)
            sprites[_INTL("increase{1}",j)].x = frames[i-j-2]-40
          end
          sprites[_INTL("increase{1}",j)].z = 4 if (i == 8 + j)
          if (i >= 20 + j) && (i < 24 + j)
            sprites[_INTL("increase{1}",j)].x += 12
            sprites[_INTL("increase{1}",j)].opacity -= 48
          end
          if i == 24 + j
            sprites[_INTL("oldstats{1}",j)].visible=false
            sprites[_INTL("increase{1}",j)].visible=false
            sprites[_INTL("newstats{1}",j)].x = sprites["display"].x
            sprites[_INTL("newstats{1}",j)].visible=true
          end
          if (i >= 24 + j) && (i < 28 + j)
            frame = [-4,-2, 2, 4][i - (24 + j)]
            sprites[_INTL("newstats{1}",j)].y += frame
          end
        end
      end
      if i > max-6
        sprites["display"].x = frames[6-(i-max+6)]
        sprites["names"].x = sprites["display"].x
        for j in 0...6
          sprites[_INTL("newstats{1}",j)].x = sprites["display"].x
        end
        sprites["newlevel"].x = sprites["display"].x
        sprites["icon"].x = sprites["display"].x + 100
      end
      pbWait(1)
    end
    
    pbDisposeSpriteHash(sprites)
    viewport.dispose
    
  end