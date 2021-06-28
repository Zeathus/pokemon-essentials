class PokeBattle_Pokemon
  
  def checkMoveUpgrades
    
    #return false if @moveupgrades.length <= 0
    ret = false
    
    for move in @moves
      upgrades = pbMoveUpgrade(move.id)
      next if !upgrades
      @moveexp = [] if !@moveexp
      next if !@moveexp[move.id]
      next if @moveupgrades[move.id]
      movedata = PBMoveData.new(move.id)
      
      if @moveexp[move.id] >= upgrades[0]
        
        ret = true
        
        movename = PBMoves.getName(move.id)
        
        if upgrades.length <= 2
          
          upgrade = upgrades[1]
          
          pbSEPlay("ItemGet",100)
          if upgrade[0]<=2
            Kernel.pbMessage(_INTL("{1}'s {2} was upgraded!",
              @name, movename))
          else
            Kernel.pbMessage(_INTL("{1}'s {2} was upgraded with {3}!",
              @name, movename, PBMoveUpNames.getName(upgrade[0])))
          end
          
          upgradeData = []
          for i in 1...upgrade.length
            upgradeData.push(upgrade[i])
          end
          
          @moveupgrades[move.id]=[upgrade[0],upgradeData]
          
        else
          
          #Kernel.pbMessage("Upgrade is still a work in progress.")
          
          #next
          
          Kernel.pbMessage(@name + " has mastered " + PBMoves.getName(move.id) + "! " +
            "It can now be upgraded.")
          
          viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
          viewport.z = 99999
          base = Color.new(248,248,248)
          shadow = Color.new(104,104,104)
          base2 = Color.new(64,64,64)
          shadow2 = Color.new(176,176,176)
          baseG = Color.new(90,152,84)
          shadowG = Color.new(100,224,94)
          baseR = Color.new(160,80,80)
          shadowR = Color.new(240,96,88)
          
          textpos=[
            [_INTL("TYPE"),20,90,0,base,shadow],
            [_INTL("CATEGORY"),20,122,0,base,shadow],
            [_INTL("POWER"),20,154,0,base,shadow],
            [_INTL("ACCURACY"),20,186,0,base,shadow],
            [_INTL("TYPE"),294,90,0,base,shadow],
            [_INTL("CATEGORY"),294,122,0,base,shadow],
            [_INTL("POWER"),294,154,0,base,shadow],
            [_INTL("ACCURACY"),294,186,0,base,shadow]
          ]
          imagepos=[]
          imagepos.push(["Graphics/Pictures/types",166,92,0,movedata.type*28,64,28])
          imagepos.push(["Graphics/Pictures/category",166,124,0,movedata.category*28,64,28])
          
          textpos.push([PBMoves.getName(move.id),20,58,0,base2,shadow2])
          textpos.push([movedata.basedamage<=1 ? movedata.basedamage==1 ? "???" : "---" : sprintf("%d",movedata.basedamage),
            216,154,1,base2,shadow2])
          textpos.push([movedata.accuracy==0 ? "---" : sprintf("%d",movedata.accuracy),
            216,186,1,base2,shadow2])
          
          @sprites={}
          file = "Graphics/Pictures/moveupgrade"
          @sprites["bg"]=Sprite.new(viewport)
          @sprites["bg"].bitmap = BitmapCache.load_bitmap(file)
          @sprites["bg"].z = 1
          @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,viewport)
          @sprites["overlay"].z = 2
          overlay=@sprites["overlay"].bitmap
          pbSetSystemFont(overlay)
          
          @sprites["info"]=BitmapSprite.new(Graphics.width,Graphics.height,viewport)
          @sprites["info"].z = 2
          info=@sprites["info"].bitmap
          pbSetSystemFont(info)
          
          pbDrawTextPositions(overlay,textpos)
          pbDrawImagePositions(overlay,imagepos)
          drawTextEx(overlay,4,218,238,5,
            pbGetMessage(MessageTypes::MoveDescriptions,move.id),
            Color.new(64,64,64),Color.new(176,176,176))
          
          moveUpgrade = pbMoveUpgrade(move.id)
          options = []
          for i in 1...moveUpgrade.length
            options.push(moveUpgrade[i])
          end
          
          index = 0
          option_pos = Graphics.width/2 - options.length*28
          for i in 0...options.length
            file = _INTL("Graphics/Pictures/moveupgrade{1}",PBMoveUpNames.getImageID(options[i][0]))
            @sprites[_INTL("option{1}",i)]=Sprite.new(viewport)
            @sprites[_INTL("option{1}",i)].x = option_pos + i * 56
            @sprites[_INTL("option{1}",i)].z = 3
          end
          
          update = true
          
          loop do
            
            Graphics.update
            Input.update
            viewport.update
            
            if Input.trigger?(Input::LEFT)
              index -= 1 if index > 0
              update = true
            elsif Input.trigger?(Input::RIGHT)
              index += 1 if index < options.length - 1
              update = true
            elsif Input.trigger?(Input::C)
              Kernel.pbMessage("Would you like to upgrade " +
                PBMoves.getName(move.id) + " with " + PBMoveUpNames.getName(options[index][0]) + "?" +
                "\\ch[1,2,Yes,No]")
              if pbGet(1)==0
                upgrade = options[index]
          
                pbSEPlay("ItemGet",100)
                if upgrade[0]<=2
                  Kernel.pbMessage(_INTL("{1}'s {2} was upgraded!",
                    @name, movename))
                else
                  Kernel.pbMessage(_INTL("{1}'s {2} was upgraded with {3}!",
                    @name, movename, PBMoveUpNames.getName(upgrade[0])))
                end
                
                upgradeData = []
                for i in 1...upgrade.length
                  upgradeData.push(upgrade[i])
                end
                
                @moveupgrades[move.id]=[upgrade[0],upgradeData]
                break
              end
            end
            
            if update
              for i in 0...options.length
                file = _INTL("Graphics/Pictures/moveupgrade{1}",PBMoveUpNames.getImageID(options[i][0]))
                file += "s" if i == index
                @sprites[_INTL("option{1}",i)].bitmap = BitmapCache.load_bitmap(file)
              end
              
              imagepos=[
                ["Graphics/Pictures/types",166+274,92,0,movedata.type*28,64,28],
                ["Graphics/Pictures/category",166+274,124,0,movedata.category*28,64,28]
              ]
              textpos=[
                [PBMoves.getName(move.id) + "+",294,58,0,base2,shadow2],
                [movedata.basedamage<=1 ? movedata.basedamage==1 ? "???" : "---" : sprintf("%d",movedata.basedamage),
                216+274,154,1,base2,shadow2],
                [movedata.accuracy==0 ? "---" : sprintf("%d",movedata.accuracy),
                216+274,186,1,base2,shadow2]
              ]
              upgrade = options[index]
              
              description=false
              for i in 1...upgrade.length
                if upgrade[i][0] == PBMoveUps::Accuracy
                  textpos[2][0]=upgrade[i][1].to_s + "%"
                  textpos[2][4]=baseG
                  textpos[2][5]=shadowG
                elsif upgrade[i][0] == PBMoveUps::Power
                  textpos[1][0]=upgrade[i][1].to_s
                  textpos[1][4]=baseG
                  textpos[1][5]=shadowG
                elsif upgrade[1] == PBMoveUps::LearnMove
                  
                elsif upgrade[i][0] == PBMoveUps::Category
                  imagepos[1][4]=upgrade[i][1]*28
                elsif upgrade[i][0] == PBMoveUps::Type
                  imagepos[0][4]=upgrade[i][1]*28
                elsif upgrade[i][0] == PBMoveUps::Description
                  description=upgrade[i][1]
                end
              end
              
              info.clear
              pbDrawTextPositions(info,textpos)
              pbDrawImagePositions(info,imagepos)
              if !description
                drawTextEx(info,4+274,218,238,5,
                  pbGetMessage(MessageTypes::MoveDescriptions,move.id),
                  Color.new(64,64,64),Color.new(176,176,176))
              else
                drawTextEx(info,4+274,218,238,5,
                  description,
                  Color.new(64,64,64),Color.new(176,176,176))
              end
              
              update = false
            end
          end
          pbDisposeSpriteHash(@sprites)
          viewport.dispose
          
        end
      end
    end
    
    return ret
    
  end
end

def pbCheckMoveUpgrade(pkmn,move)
  
  if !pkmn.moveupgrades[move.id]
    return move
  end
  
  move.name       = pbMoveUpgradeName(pkmn,move.id,PBMoves.getName(move.id))
  move.basedamage = pbMoveUpgradeBaseDamage(pkmn,move.id,move.basedamage)
  move.type       = pbMoveUpgradeType(pkmn,move.id,move.type)
  move.accuracy   = pbMoveUpgradeAccuracy(pkmn,move.id,move.accuracy)
  move.category   = pbMoveUpgradeCategory(pkmn,move.id,move.category)
  move.addlEffect = pbMoveUpgradeCategory(pkmn,move.id,move.addlEffect)
  
#  attr_reader(:function)
#  attr_accessor(:priority)

  return move
  
end

def pbMoveUpgradeTitle(pkmn,move)
  
  if pkmn.moveupgrades[move]
    return pkmn.moveupgrades[move][0]
  end
  
  ex = pbExclusiveMoveUpgrade(pkmn.species,pkmn.form)
  if ex && ex[1]==move
    return PBMoveUpNames::Exclusive
  end
  
  if pbMoveUpgrade(move)
    return PBMoveUpNames::Exp
  else
    return PBMoveUpNames::None
  end
  
end

def pbMoveUpgradeName(pkmn,move,name)
  
  if !pkmn.moveupgrades[move]
    return name
  else
    name = name + "+"
  end
  
  return name
  
end

def pbMoveUpgradeBaseDamage(pkmn,move,basedamage)
  
  if !pkmn.moveupgrades[move]
    return basedamage
  end
  
  for i in pkmn.moveupgrades[move][1]
    if i[0]==PBMoveUps::Power
      basedamage=i[1]
    end
  end
  
  return basedamage
  
end

def pbMoveUpgradeType(pkmn,move,type)
  
  if !pkmn.moveupgrades[move]
    return type
  end
  
  for i in pkmn.moveupgrades[move][1]
    if i[0]==PBMoveUps::Type
      type=i[1]
    end
  end
  
  return type
  
end

def pbMoveUpgradeCategory(pkmn,move,category)
  
  if !pkmn.moveupgrades[move]
    return category
  end
  
  for i in pkmn.moveupgrades[move][1]
    if i[0]==PBMoveUps::Category
      category=i[1]
    end
  end
  
  return category
  
end

def pbMoveUpgradeAccuracy(pkmn,move,accuracy)
  
  if !pkmn.moveupgrades[move]
    return accuracy
  end
  
  for i in pkmn.moveupgrades[move][1]
    if i[0]==PBMoveUps::Accuracy
      accuracy=i[1]
    end
  end
  
  return accuracy
  
end

def pbMoveUpgradeEffectChance(pkmn,move,chance)
  
  if !pkmn.moveupgrades[move]
    return chance
  end
  
  for i in pkmn.moveupgrades[move][1]
    if i[0]==PBMoveUps::EfChance
      chance=i[1]
    end
  end
  
  return chance
  
end

def pbMoveUpgradeDescription(pkmn,move)
  
  if !pkmn.moveupgrades[move]
    return false
  end
  
  for i in pkmn.moveupgrades[move][1]
    if i[0]==PBMoveUps::Description
      return i[1]
    end
  end
  
  return false
  
end










