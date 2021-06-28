################################################################################
# List of Habitats to display on the list, and the maps they contain
################################################################################
def pbGetHabitatList
  return [
    ["Andes Isles", :WestAndesIsle,:EastAndesIsle],
    ["Breccia Area", :BrecciaUndergrowth, :BrecciaPassage],
    ["Canjon Valley", :CanjonValley],
    ["Crosswoods", :Crosswoods],
    ["Evergone Mangrove", :EvergoneMangrove, :EvergoneHill, :EvergoneStairway],
    ["Lapis Lazuli Area", :LazuliRiver, :LazuliDistrict, :LapisDistrict],
    ["Mica Quarry", :MicaQuarryB1F, :MicaQuarryB2F, :MicaQuarryB3F, :MicaQuarryB4F, :MicaQuarryB5F],
    ["Mica Quarry Deep", :MicaQuarryB6F, :MicaQuarryB7F],
    ["Mt. Pegma Area", :MtPegmaHillside, :FeldsparTown],
    ["Mt. Pegma Interior", :MtPegma1F, :MtPegma2F, :MtPegma3F, :LakeKirrock],
    ["Quartz Area", :QuartzPassing, :QuartzFalls],
    ["Shale Area", :ShalePath, :ShaleForest, :ShaleTown],
    ["Smokey Forest", :SmokeyForest1],
    ["Canjon Area", :CanjonValley, :LakeCanjon],
    ["Scoria Area", :ScoriaCity, :ScoriaCanyon]
  ]
end

def pbGetHabitatListReward(area)
  
  rewards = [
    ["Andes Isles", PBMoves::AQUATAIL],
    ["Breccia Area", PBMoves::GIGADRAIN],
    ["Canjon Valley", PBMoves::DOUBLEEDGE],
    ["Crosswoods", PBMoves::ELECTROWEB],
    ["Evergone Mangrove", PBMoves::AMNESIA],
    ["Lazuli Area", PBMoves::WATERPULSE],
    ["Mica Quarry", PBMoves::ENDURE],
    ["Mica Quarry Deep", PBMoves::CURSE],
    ["Mt. Pegma Area", PBMoves::IRONDEFENSE],
    ["Mt. Pegma Interior", PBMoves::IRONTAIL],
    ["Quartz Area", PBMoves::BOUNCE],
    ["Shale Area", PBMoves::DESTINYBOND],
    ["Smokey Forest", PBMoves::DEFOG],
    ["Tuff Area", PBMoves::COUNTER]
  ]
    
  for i in rewards
    if i[0] == area
      return [1]
    end
  end
  
  return false
  
end

################################################################################
# Shows the "Nest" page of the Pokédex entry screen.
################################################################################
class PokemonHabitatMapScene
  def pbStartScene(species,regionmap=-1)
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites={}
    pbRgssOpen("Data/townmap.dat","rb"){|f|
       @mapdata=Marshal.load(f)
    }
    mappos=!$game_map ? nil : pbGetMetadata($game_map.map_id,MetadataMapPosition)
    @region=regionmap
    if @region<0                                    # Use player's current region
      @region=mappos ? mappos[0] : 0                           # Region 0 default
    end
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/pokedexHabitat"))
    @sprites["overlay"]=IconSprite.new(0,0,@viewport)
    @sprites["overlay"].setBitmap(_INTL("Graphics/Pictures/pokedexHabitatOverlay"))
    @sprites["overlay"].z=99
    @sprites["frame"]=IconSprite.new(0,0,@viewport)
    @sprites["frame"].setBitmap(_INTL("Graphics/Pictures/pokedexHabitatFrame"))
    @sprites["frame"].z=103
    @sprites["pokemonlist"]=IconSprite.new(0,0,@viewport)
    @sprites["pokemonlist"].setBitmap(_INTL("Graphics/Pictures/pokedexHabitatList"))
    @sprites["pokemonlist"].z=99
    @sprites["pokemonlist"].visible=false
    @sprites["pokemonlist2"]=Sprite.new(@viewport)
    @sprites["pokemonlist2"].bitmap=Bitmap.new(Graphics.width,Graphics.height)
    @sprites["pokemonlist2"].z=100
    @sprites["pokemonlist2"].visible=false
    @sprites["map"]=IconSprite.new(0,0,@viewport)
    @sprites["map"].setBitmap("Graphics/Pictures/#{@mapdata[@region][1]}")
    @sprites["map"].x+=(Graphics.width-@sprites["map"].bitmap.width)/2
    @sprites["map"].y+=(Graphics.height-@sprites["map"].bitmap.height)/2
    for hidden in REGIONMAPEXTRAS
      if hidden[0]==@region && hidden[1]>0 && $game_switches[hidden[1]]
        if !@sprites["map2"]
          @sprites["map2"]=BitmapSprite.new(480,320,@viewport)
          @sprites["map2"].x=@sprites["map"].x; @sprites["map2"].y=@sprites["map"].y
        end
        pbDrawImagePositions(@sprites["map2"].bitmap,[
           ["Graphics/Pictures/#{hidden[4]}",
              hidden[2]*PokemonRegionMapScene::SQUAREWIDTH,
              hidden[3]*PokemonRegionMapScene::SQUAREHEIGHT,0,0,-1,-1]
        ])
      end
    end
    @index = 0
    @scroll = 0
    habitats = pbGetHabitatList
    @habitatlist=[]
    for habitat in habitats
      for i in 1...habitat.length
        mapid = habitat[i]
        mapid = getID(PBMaps,mapid) if mapid.is_a?(Symbol)
        if $PokemonGlobal.visitedMaps[mapid]
          @habitatlist.push(habitat)
          break
        end
      end
    end
    @sprites["maplist"]=Sprite.new(@viewport)
    @sprites["maplist"].bitmap=Bitmap.new(Graphics.width,Graphics.height)
    @sprites["maplist"].z=100
    @sprites["rightarrow"]=AnimatedSprite.new("Graphics/Pictures/rightarrow",8,40,28,2,@viewport)
    @sprites["rightarrow"].z=200
    @sprites["rightarrow"].play
    @sprites["rightarrowenc"]=AnimatedSprite.new("Graphics/Pictures/rightarrow",340,40,28,2,@viewport)
    @sprites["rightarrowenc"].z=101
    @sprites["rightarrowenc"].visible=false
    @sprites["leftarrowenc"]=AnimatedSprite.new("Graphics/Pictures/leftarrow",12,40,28,2,@viewport)
    @sprites["leftarrowenc"].z=101
    @sprites["leftarrowenc"].visible=false
    pbDrawMapList
    @point=BitmapWrapper.new(PokemonRegionMapScene::SQUAREWIDTH+4,
                             PokemonRegionMapScene::SQUAREHEIGHT+4)
    @point.fill_rect(0,0,
                     PokemonRegionMapScene::SQUAREWIDTH+4,
                     PokemonRegionMapScene::SQUAREHEIGHT+4,Color.new(255,0,0))
    @point2=BitmapWrapper.new(PokemonRegionMapScene::SQUAREWIDTH+4,
                              PokemonRegionMapScene::SQUAREHEIGHT+4)
    @point2.fill_rect(4,0,
                      PokemonRegionMapScene::SQUAREWIDTH,
                      PokemonRegionMapScene::SQUAREHEIGHT+4,Color.new(255,0,0))
    @point3=BitmapWrapper.new(PokemonRegionMapScene::SQUAREWIDTH+4,
                              PokemonRegionMapScene::SQUAREHEIGHT+4)
    @point3.fill_rect(0,4,
                      PokemonRegionMapScene::SQUAREWIDTH+4,
                      PokemonRegionMapScene::SQUAREHEIGHT,Color.new(255,0,0))
    @point4=BitmapWrapper.new(PokemonRegionMapScene::SQUAREWIDTH+4,
                              PokemonRegionMapScene::SQUAREHEIGHT+4)
    @point4.fill_rect(4,4,
                      PokemonRegionMapScene::SQUAREWIDTH,
                      PokemonRegionMapScene::SQUAREHEIGHT,Color.new(255,0,0))
    pbDrawMapLocations
    @sprites["mapbottom"]=MapBottomSprite.new(@viewport)
    @sprites["mapbottom"].maplocation=pbGetMessage(MessageTypes::RegionNames,@region)
    @sprites["mapbottom"].mapdetails=_INTL("")
    return true
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
    @numpoints.times {|i|
       @sprites["point#{i}"].opacity=[64,96,128,160,128,96][(Graphics.frame_count/4)%6]
    }
  end
  
  def pbDrawMapList
    textpos = []
    for i in @scroll...@scroll+10
      offset=(i-@scroll)*32
      if @habitatlist[i]
        textpos.push([@habitatlist[i][0],36,34+offset,false,
          Color.new(24,24,24),Color.new(184,184,184)])
      end
    end
    @sprites["maplist"].bitmap.clear
    pbSetSystemFont(@sprites["maplist"].bitmap)
    pbDrawTextPositions(@sprites["maplist"].bitmap,textpos)
    @sprites["rightarrow"].x = 0
    @sprites["rightarrow"].y = 34 + 32*(@index-@scroll)
  end
  
  def pbDrawSubMapList
    textpos = []
    textpos.push([@habitatlist[@index][0],136,34,2,
          Color.new(24,24,24),Color.new(184,184,184)])
    arealist = @habitatlist[@index]
    namebug = false
    for i in 1...@habitatlist[@index].length
      offset=(i)*32
      if @habitatlist[i]
        mapid=arealist[i]
        mapid=getID(PBMaps,mapid) if mapid.is_a?(Symbol)
        mapname=pbGetMapNameFromId(mapid)
        mapname="-----" if !$PokemonGlobal.visitedMaps[mapid]
        if mapname != "-----" && rand(50)==0
          mapname = "NULL"
          namebug = true
        end
        textpos.push([mapname,36,34+offset,false,
          Color.new(24,24,24),Color.new(184,184,184)])
      end
    end
    @sprites["maplist"].bitmap.clear
    if namebug
      pbSetSmallFont(@sprites["maplist"].bitmap)
      pbDrawTextPositions(@sprites["maplist"].bitmap,
        [["Failed to load String 'mapname'",20,324,false,
        Color.new(0,255,0),Color.new(0,155,0,0)]])
    end
    pbSetSystemFont(@sprites["maplist"].bitmap)
    pbDrawTextPositions(@sprites["maplist"].bitmap,textpos)
    @sprites["rightarrow"].x = 0
    @sprites["rightarrow"].y = 34 + 32*(@subindex+1)
  end
  
  def pbDrawPokemonList
    encTypes = EncounterTypes::Names
    
    mapid = @habitatlist[@index][@subindex+1]
    mapid = getID(PBMaps,mapid) if mapid.is_a?(Symbol)
    encounters = $PokemonEncounters.pbMapEncounterList(mapid)
    
    @sprites["pokemonlist2"].bitmap.clear
    if !$PokemonGlobal.visitedMaps[mapid]
      pbSetSystemFont(@sprites["pokemonlist2"].bitmap)
      pbDrawTextPositions(@sprites["pokemonlist2"].bitmap,[
        ["You have not been",378,160,2,
        Color.new(24,24,24),Color.new(184,184,184)],
        ["to this area yet",378,190,2,
        Color.new(24,24,24),Color.new(184,184,184)]])
      return
    end
    
    if @enctype < 0
      @enctype = encTypes.length - 1
    end
    
    while !encounters[@enctype]
      if @enctypeback
        @enctype -= 1
        @enctype = encTypes.length - 1 if @enctype < 0
      else
        @enctype += 1
        @enctype = 0 if @enctype >= encTypes.length
      end
    end
    
    encTypeCount = 0
    for i in 0...encTypes.length
      encTypeCount += 1 if encounters[i]
    end
    if encTypeCount > 1
      @sprites["rightarrowenc"].x=458
      @sprites["rightarrowenc"].y=38
      @sprites["leftarrowenc"].x=258
      @sprites["leftarrowenc"].y=38
      @sprites["rightarrowenc"].visible=true
      @sprites["leftarrowenc"].visible=true
    else
      @sprites["rightarrowenc"].visible=false
      @sprites["leftarrowenc"].visible=false
    end
    
    imagepos = []
    textpos = []
    smalltextpos=[]
    y = 36
    
    pbSetSystemFont(@sprites["pokemonlist2"].bitmap)
    if encounters[@enctype]
      x = 272
      textpos.push([encTypes[@enctype],378,y,2,
        Color.new(24,24,24),Color.new(184,184,184)])
      textwidth=@sprites["pokemonlist2"].bitmap.text_size(encTypes[@enctype]).width
      imagepos.push([_INTL("Graphics/Pictures/pokedexHabitat{1}",encTypes[@enctype]),
        378-textwidth/2-40,y,0,0,-1,-1])
      imagepos.push([_INTL("Graphics/Pictures/pokedexHabitat{1}",encTypes[@enctype]),
        378+textwidth/2+8,y,0,0,-1,-1])
      y += 24
      count = 0
      pokemon=[]
      chances=[]
      for j in encounters[@enctype]
        pokemon.push(j[0]) if !pokemon.include?(j[0])
        chances[j[0]]=0 if !chances[j[0]]
        chances[j[0]]+=j[1]
      end
      for poke in pokemon
        if $Trainer.seen[poke]
          imagepos.push([sprintf("Graphics/Icons/icon%03d",poke),
            x,y,0,0,63,63])
        else
          imagepos.push([sprintf("Graphics/Icons/silhouette/icon%03d",poke),
            x,y,0,0,63,63])
        end
        if $Trainer.owned[poke]
          imagepos.push([sprintf("Graphics/Pictures/pokeball"),
            x+48,y+52,0,0,-1,-1])
        end
        smalltextpos.push([_INTL("{1}%",chances[poke]),x+32,y+58,2,
          Color.new(24,24,24),Color.new(184,184,184)])
        x += 70
        count+=1
        if count % 3 == 0
          y += 68 
          x = 272
        end
      end
    end
    
    pbDrawImagePositions(@sprites["pokemonlist2"].bitmap,imagepos)
    pbSetSystemFont(@sprites["pokemonlist2"].bitmap)
    pbDrawTextPositions(@sprites["pokemonlist2"].bitmap,textpos)
    pbSetSmallFont(@sprites["pokemonlist2"].bitmap)
    pbDrawTextPositions(@sprites["pokemonlist2"].bitmap,smalltextpos)
    
  end
  
  def pbDrawMapLocations
    points=[]
    if @numpoints
      @numpoints.times {|i|
         @sprites["point#{i}"].dispose
      }
    end
    mapwidth=1+PokemonRegionMapScene::RIGHT-PokemonRegionMapScene::LEFT
    i=0
    for i in 1...@habitatlist[@index].length
      enc = @habitatlist[@index][i]
      enc = getID(PBMaps,enc) if enc.is_a?(Symbol)
      mappos=pbGetMetadata(enc,MetadataMapPosition)
      if mappos && mappos[0]==@region
        showpoint=true
        for loc in @mapdata[@region][2]
          showpoint=false if loc[0]==mappos[1] && loc[1]==mappos[2] &&
                             loc[7] && !$game_switches[loc[7]]
        end
        if showpoint
          mapsize=pbGetMetadata(enc,MetadataMapSize)
          if mapsize && mapsize[0] && mapsize[0]>0
            sqwidth=mapsize[0]
            sqheight=(mapsize[1].length*1.0/mapsize[0]).ceil
            for i in 0...sqwidth
              for j in 0...sqheight
                if mapsize[1][i+j*sqwidth,1].to_i>0
                  points[mappos[1]+i+(mappos[2]+j)*mapwidth]=true
                end
              end
            end
          else
            points[mappos[1]+mappos[2]*mapwidth]=true
          end
        end
      end
    end
    i=0
    for j in 0...points.length
      if points[j]
        s=SpriteWrapper.new(@viewport)
        s.x=(j%mapwidth)*PokemonRegionMapScene::SQUAREWIDTH-2
        s.x+=(Graphics.width-@sprites["map"].bitmap.width)/2
        s.y=(j/mapwidth)*PokemonRegionMapScene::SQUAREHEIGHT-2
        s.y+=(Graphics.height-@sprites["map"].bitmap.height)/2
        if j>=1 && points[j-1]
          if j>=mapwidth && points[j-mapwidth]
            s.bitmap=@point4
          else
            s.bitmap=@point2
          end
        else
          if j>=mapwidth && points[j-mapwidth]
            s.bitmap=@point3
          else
            s.bitmap=@point
          end
        end
        @sprites["point#{i}"]=s
        i+=1
      end
    end
    @numpoints=i
    enc = @habitatlist[@index][1]
    enc = getID(PBMaps,enc) if enc.is_a?(Symbol)
    mappos=pbGetMetadata(enc,MetadataMapPosition)
    @sprites["map"].x=(Graphics.width-@sprites["map"].bitmap.width)/2
    @sprites["map"].y=(Graphics.height-@sprites["map"].bitmap.height)/2
    if mappos
      if mappos[1]<10
        @sprites["map"].x+=240
      elsif mappos[1]<20
        @sprites["map"].x+=120
      end
    end
    if @numpoints
      @numpoints.times {|i|
        if mappos[1]<10
          @sprites["point#{i}"].x+=240
        elsif mappos[1]<20
          @sprites["point#{i}"].x+=120
        end
      }
    end
  end

  def pbMapScene
    Graphics.transition
    ret=0
    refresh=true
    subview=false
    @subindex=0
    @enctype=0
    @enctypeback=false
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::UP)
        pbPlayCursorSE()
        if !subview
          @index-=1
          @scroll-=1 if @index - @scroll < 0
          if @index<0
            @index=@habitatlist.length-1
            @scroll=@habitatlist.length-10
            @scroll=0 if @scroll<0
          end
        else
          @subindex-=1
          if @subindex<0
            @subindex=@habitatlist[@index].length-2
          end
        end
        refresh=true
      elsif Input.trigger?(Input::DOWN)
        if !subview
          pbPlayCursorSE()
          @index+=1
          @scroll+=1 if @index - @scroll > 9
          if @index>@habitatlist.length-1
            @index=0
            @scroll=0
          end
        else
          @subindex+=1
          if @subindex>@habitatlist[@index].length-2
            @subindex=0
          end
        end
        refresh=true
      elsif Input.trigger?(Input::LEFT)
        if subview
          pbPlayCursorSE()
          @enctype-=1
          @enctypeback=true
        end
        refresh=true
      elsif Input.trigger?(Input::RIGHT)
        if subview
          pbPlayCursorSE()
          @enctype+=1
          @enctypeback=false
        end
        refresh=true
      elsif Input.trigger?(Input::B)
        if subview
          subview=false
          @sprites["pokemonlist"].visible=false
          @sprites["pokemonlist2"].visible=false
          @sprites["rightarrowenc"].visible=false
          @sprites["leftarrowenc"].visible=false
          pbPlayCancelSE()
          refresh=true
        else
          ret=1
          pbPlayCancelSE()
          pbFadeOutAndHide(@sprites)
          break
        end
      elsif Input.trigger?(Input::C)
        subview=true
        @subindex=0
        @enctype=0
        @sprites["pokemonlist"].visible=true
        @sprites["pokemonlist2"].visible=true
        refresh=true
      end
      if refresh
        refresh=false
        if !subview
          pbDrawMapList
          pbDrawMapLocations
        else
          pbDrawSubMapList
          pbDrawPokemonList
        end
      end
    end
    return ret
  end

  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @point.dispose
    @viewport.dispose
  end
end



class PokemonHabitatMap
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen
    species=4
    region=pbGetCurrentRegion
    @scene.pbStartScene(species,region)
    ret=@scene.pbMapScene
    @scene.pbEndScene
    return ret
  end
end