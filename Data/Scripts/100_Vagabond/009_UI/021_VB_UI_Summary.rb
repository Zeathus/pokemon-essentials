class MoveSelectionSprite < SpriteWrapper
    attr_reader :preselected
    attr_reader :index
  
    def initialize(viewport=nil,fifthmove=false)
      super(viewport)
      @movesel=AnimatedBitmap.new(
        fifthmove ? "Graphics/Pictures/Summary/cursor_move_learn" :
                    "Graphics/Pictures/Summary/cursor_move")
      @frame=0
      @index=0
      @fifthmove=fifthmove
      @preselected=false
      @updating=false
      @spriteVisible=true
      refresh
    end
  
    def dispose
      @movesel.dispose
      super
    end
  
    def index=(value)
      @index=value
      refresh
    end
  
    def preselected=(value)
      @preselected=value
      refresh
    end
  
    def visible=(value)
      super
      @spriteVisible=value if !@updating
    end
  
    def refresh
      w=@movesel.width
      h=@movesel.height/2
      if @fifthmove
        self.x=260
        self.y=46
        self.y+=62 * self.index
        self.y+=18 if self.index==4
      else
        self.x=64
        self.y=48
        self.x+=220 if self.index % 2 == 1
        self.y+=84 if self.index >= 2
      end
      self.bitmap=@movesel.bitmap
      if self.preselected
        self.src_rect.set(0,h,w,h)
      else
        self.src_rect.set(0,0,w,h)
      end
    end
  
    def update
      @updating=true
      super
      @movesel.update
      @updating=false
      refresh
    end
  end
  
  
  
  class PokemonSummaryScene
    def pbPokerus(pkmn)
      return pkmn.pokerusStage
    end
  
    def pbUpdate
      pbUpdateSpriteHash(@sprites)
    end
  
    def pbStartScene(party,partyindex)
      @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z=99999
      @party=party
      @partyindex=partyindex
      @pokemon=@party[@partyindex]
      @sprites={}
      @typebitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
      @sprites["bg"]=IconSprite.new(0,0,@viewport)
      @sprites["bg"].setBitmap("Graphics/Pictures/Summary/summarybg")
      @sprites["bg"].z=0
      for i in 0...@party.length
        @sprites[_INTL("pokebar{1}",i)]=IconSprite.new(0,0,@viewport)
        @sprites[_INTL("pokebar{1}",i)].setBitmap("Graphics/Pictures/Summary/bar")
        @sprites[_INTL("pokebar{1}",i)].x=14
        @sprites[_INTL("pokebar{1}",i)].y=36+i*56
        @sprites[_INTL("pokebar{1}",i)].z=1
        @sprites[_INTL("pokeicon{1}",i)]=PokemonBoxIcon.new(@party[i],@viewport)
        @sprites[_INTL("pokeicon{1}",i)].x=10
        @sprites[_INTL("pokeicon{1}",i)].y=18+i*56
        @sprites[_INTL("pokeicon{1}",i)].z=2
        if @partyindex==i
          @sprites[_INTL("pokebar{1}",i)].setBitmap("Graphics/Pictures/Summary/bar_selected")
          @sprites[_INTL("pokebar{1}",i)].x=4
          @sprites[_INTL("pokeicon{1}",i)].x=0
        end
      end
      @sprites["bg2"]=IconSprite.new(0,0,@viewport)
      if @pokemon.egg?
        @sprites["bg2"].setBitmap(_INTL("Graphics/Pictures/Summary/summarybg9"))
      else
        @sprites["bg2"].setBitmap(_INTL("Graphics/Pictures/Summary/summarybg{1}",GameData::Type.get(@pokemon.type1).id_number))
      end
      @sprites["bg2"].z=3
      @sprites["background"]=IconSprite.new(0,0,@viewport)
      @sprites["background"].z=4
      @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
      @sprites["overlay"].z=5
      @sprites["pokemon"]=PokemonSprite.new(@viewport)
      @sprites["pokemon"].setPokemonBitmap(@pokemon)
      @sprites["pokemon"].setOffset(PictureOrigin::TopLeft)
      @sprites["pokemon"].mirror=false
      @sprites["pokemon"].color=Color.new(0,0,0,0)
      @sprites["pokemon"].z=6
      pbPositionPokemonSprite(@sprites["pokemon"],224,116)
      @sprites["pokeicon"]=PokemonBoxIcon.new(@pokemon,@viewport)
      @sprites["pokeicon"].x=14
      @sprites["pokeicon"].y=52
      @sprites["pokeicon"].mirror=false
      @sprites["pokeicon"].visible=false
      @sprites["pokeicon"].z=7
      @sprites["movepresel"]=MoveSelectionSprite.new(@viewport)
      @sprites["movepresel"].visible=false
      @sprites["movepresel"].preselected=true
      @sprites["movepresel"].z=7
      @sprites["movesel"]=MoveSelectionSprite.new(@viewport)
      @sprites["movesel"].visible=false
      @sprites["movesel"].z=8
      @page=0
      drawPageInfo(@pokemon)
      pbFadeInAndShow(@sprites) { pbUpdate }
    end
  
    def pbStartForgetScene(party,partyindex,moveToLearn)
      @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z=99999
      @party=party
      @partyindex=partyindex
      @pokemon=@party[@partyindex]
      @sprites={}
      @page=3
      @typebitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
      @sprites["bg"]=IconSprite.new(0,0,@viewport)
      @sprites["bg"].setBitmap("Graphics/Pictures/Summary/summarybg")
      @sprites["bg"].z=0
      @sprites["background"]=IconSprite.new(0,0,@viewport)
      @sprites["background"].z=4
      @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
      @sprites["overlay"].z=5
      @sprites["pokeicon"]=PokemonBoxIcon.new(@pokemon,@viewport)
      @sprites["pokeicon"].x=14
      @sprites["pokeicon"].y=-12
      @sprites["pokeicon"].mirror=false
      @sprites["pokeicon"].z=7
      @sprites["movesel"]=MoveSelectionSprite.new(@viewport,moveToLearn>0)
      @sprites["movesel"].visible=false
      @sprites["movesel"].visible=true
      @sprites["movesel"].index=0
      @sprites["movesel"].z=8
      drawSelectedMove(@pokemon,moveToLearn,@pokemon.moves[0].id)
      pbFadeInAndShow(@sprites)
    end
  
    def pbEndScene
      pbFadeOutAndHide(@sprites) { pbUpdate }
      pbDisposeSpriteHash(@sprites)
      @typebitmap.dispose
      @viewport.dispose
    end
  
    #def drawMarkings(bitmap,x,y,width,height,markings)
    #  totaltext=""
    #  oldfontname=bitmap.font.name
    #  oldfontsize=bitmap.font.size
    #  oldfontcolor=bitmap.font.color
    #  bitmap.font.size=24
    #  bitmap.font.name="Arial"
    #  PokemonStorage::MARKINGCHARS.each{|item| totaltext+=item }
    #  totalsize=bitmap.text_size(totaltext)
    #  realX=x+(width/2)-(totalsize.width/2)
    #  realY=y+(height/2)-(totalsize.height/2)
    #  i=0
    #  PokemonStorage::MARKINGCHARS.each{|item|
    #     marked=(markings&(1<<i))!=0
    #     bitmap.font.color=(marked) ? Color.new(72,64,56) : Color.new(184,184,160)
    #     itemwidth=bitmap.text_size(item).width
    #     bitmap.draw_text(realX,realY,itemwidth+2,totalsize.height,item)
    #     realX+=itemwidth
    #     i+=1
    #  }
    #  bitmap.font.name=oldfontname
    #  bitmap.font.size=oldfontsize
    #  bitmap.font.color=oldfontcolor
    #end

    def drawMarkings(bitmap,x,y,width,height,markings)
      markings = @pokemon.markings
      markrect = Rect.new(0,0,16,16)
      for i in 0...6
        markrect.x = i*16
        markrect.y = (markings&(1<<i)!=0) ? 16 : 0
        #bitmap.blt(x+i*16,y,@markingbitmap.bitmap,markrect)
      end
    end
    
    def updatePokeIcons
      if @pokemon.egg?
        @sprites["bg2"].setBitmap(_INTL("Graphics/Pictures/Summary/summarybg9"))
      else
        @sprites["bg2"].setBitmap(_INTL("Graphics/Pictures/Summary/summarybg{1}",GameData::Type.get(@pokemon.type1).id_number))
      end
      for i in 0...@party.length
        @sprites[_INTL("pokebar{1}",i)].x=14
        @sprites[_INTL("pokebar{1}",i)].y=36+i*56
        @sprites[_INTL("pokeicon{1}",i)].x=10
        @sprites[_INTL("pokeicon{1}",i)].y=18+i*56
        if @partyindex==i
          @sprites[_INTL("pokebar{1}",i)].setBitmap("Graphics/Pictures/Summary/bar_selected")
          @sprites[_INTL("pokebar{1}",i)].x=4
          @sprites[_INTL("pokeicon{1}",i)].x=0
        else
          @sprites[_INTL("pokebar{1}",i)].setBitmap("Graphics/Pictures/Summary/bar")
        end
      end
    end
  
    def drawPageInfo(pokemon)
      @sprites["pokemon"].visible=true
      overlay=@sprites["overlay"].bitmap
      overlay.clear
      updatePokeIcons
      if pokemon.egg?
        @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_1_egg")
      else
        @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_1")
      end
      imagepos=[]
      circleFile = _INTL("Graphics/Pictures/Summary/summaryCircle{1}",GameData::Type.get(@pokemon.type1).id_number)
      if pokemon.egg?
        circleFile = _INTL("Graphics/Pictures/Summary/summaryCircle9")
      end
      imagepos.push([circleFile,188,80,0,0,-1,-1])
      pbDrawImagePositions(@sprites["bg2"].bitmap,imagepos)
      imagepos=[]
      if pbPokerus(pokemon)==1 || pokemon.hp==0 || @pokemon.status!=:None
        status=6 if pbPokerus(pokemon)==1
        status=(GameData::Status.get(@pokemon.status).id_number - 1) if @pokemon.status!=:None
        status=5 if pokemon.hp==0
        imagepos.push(["Graphics/Pictures/Party/statuses",348,80,0,32*status,32,32])
      end
      if pokemon.shiny?
        imagepos.push([sprintf("Graphics/Pictures/shiny"),80,134,0,0,-1,-1])
      end
      if pbPokerus(pokemon)==2
        imagepos.push([sprintf("Graphics/Pictures/Summary/icon_pokerus"),0,0,0,0,-1,-1])
      end
      ballused=@pokemon.poke_ball ? @pokemon.poke_ball : :POKEBALL
      ballimage=sprintf("Graphics/Pictures/Summary/icon_ball_%s",ballused.to_s)
      imagepos.push([ballimage,198,80,0,0,-1,-1])
      if (pokemon.isShadow? rescue false)
        imagepos.push(["Graphics/Pictures/Summary/overlay_shadow",224,240,0,0,-1,-1])
        shadowfract=pokemon.heartgauge*1.0/PokeBattle_Pokemon::HEARTGAUGESIZE
        imagepos.push(["Graphics/Pictures/Summary/overlay_shadowbar",242,280,0,0,(shadowfract*248).floor,-1])
      end
      pbDrawImagePositions(overlay,imagepos)
      base=Color.new(248,248,248)
      shadow=Color.new(104,104,104)
      pbSetSystemFont(overlay)
      numberbase=(pokemon.shiny?) ? Color.new(248,56,32) : Color.new(64,64,64)
      numbershadow=(pokemon.shiny?) ? Color.new(224,152,144) : Color.new(176,176,176)
      publicID=pokemon.owner.public_id
      speciesname=GameData::Species.get(pokemon.species).name
      growth_rate=pokemon.growth_rate
      startexp=growth_rate.minimum_exp_for_level(pokemon.level)
      endexp=growth_rate.minimum_exp_for_level(pokemon.level + 1)
      pokename=@pokemon.name
      timeReceived=""
      if pokemon.timeReceived
        month=pbGetAbbrevMonthName(pokemon.timeReceived.mon)
        date=pokemon.timeReceived.day
        year=pokemon.timeReceived.year
        timeReceived=_INTL("{1} {2}, {3}",month,date,year)
      end
      mapname=pbGetMapNameFromId(pokemon.obtain_map)
      if (pokemon.obtain_text rescue false) && pokemon.obtain_text!=""
        mapname=pokemon.obtain_text
      end
      if !mapname || mapname==""
        mapname=_INTL("Faraway place")
      end
      textpos=[
         [pokename,288,12,2,base,shadow],
         [pokemon.level.to_s,452,80,0,base,shadow],
         [_INTL("Trainer"),86,80,0,base,shadow],
      ]
      smalltextpos=[]
      if !pokemon.egg?
        smalltextpos.push([_INTL("{1} - {2}",timeReceived,mapname),288,350,2,base,shadow])
      else
        eggstate=_INTL("It will take a long time to hatch.")
        eggstate=_INTL("It doesn't seem close to hatching.") if pokemon.eggsteps<10200
        eggstate=_INTL("It moves occasionally. Getting closer.") if pokemon.eggsteps<2550
        eggstate=_INTL("Sounds are coming from inside!") if pokemon.eggsteps<1275
        textpos.push([eggstate,288,342,2,base,shadow])
      end
      if pokemon.hasItem?
        smalltextpos.push([PBItems.getName(pokemon.item),288,268,2,base,shadow])
      else
        smalltextpos.push([_INTL("No Item"),288,268,2,Color.new(208,208,200),Color.new(120,144,184)])
      end
      smalltextpos.push([_INTL("Exp. Points"),406,128,0,base,shadow])
      smalltextpos.push([_INTL("To Next Lv."),406,180,0,base,shadow])
      smalltextpos.push([_INTL("O.T."),74,180,0,base,shadow])
      if !pokemon.egg?
        smalltextpos.push([_INTL("Happiness"),74,128,0,base,shadow])
        smalltextpos.push([sprintf("#%03d "+speciesname,GameData::Species.get(pokemon.species).id_number),288,48,2,base,shadow])
        smalltextpos.push([sprintf("%d",pokemon.exp),504,150,1,Color.new(64,64,64),Color.new(176,176,176)])
        smalltextpos.push([sprintf("%d",endexp-pokemon.exp),504,202,1,Color.new(64,64,64),Color.new(176,176,176)])
        #mettext=[_INTL("Met at Lv."),
        #         _INTL("Egg received."),
        #         _INTL("Traded at Lv."),
        #         "",
        #         _INTL("Had a fateful encounter at Lv.")
        #         ][pokemon.obtainMode]
        mettext="Met at Lv."
        smalltextpos.push([mettext,406,232,0,base,shadow])
        smalltextpos.push([sprintf("%d",pokemon.obtain_level),504,254,1,Color.new(64,64,64),Color.new(176,176,176)])
        smalltextpos.push([sprintf("%3d",pokemon.happiness),172,150,1,Color.new(64,64,64),Color.new(176,176,176)])
      else
        smalltextpos.push([_INTL("Steps"),74,128,0,base,shadow])
        dexdata=pbOpenDexData
        pbDexDataOffset(dexdata,pokemon.species,21)
        maxeggsteps=dexdata.fgetw
        dexdata.close
        goneeggsteps=maxeggsteps-pokemon.eggsteps
        eggbarlen=(32.0-(pokemon.eggsteps*32.0/maxeggsteps)).floor*2
        smalltextpos.push(["-",504,150,1,Color.new(64,64,64),Color.new(176,176,176)])
        smalltextpos.push(["-",504,202,1,Color.new(64,64,64),Color.new(176,176,176)])
        smalltextpos.push(["-",504,254,1,Color.new(64,64,64),Color.new(176,176,176)])
        smalltextpos.push([sprintf("%d",goneeggsteps),172,150,1,Color.new(64,64,64),Color.new(176,176,176)])
        overlay.fill_rect(110,116,eggbarlen,2,Color.new(86,214,92))
        overlay.fill_rect(110,118,eggbarlen,4,Color.new(96,255,132))
      end
      idno=(pokemon.owner.name=="" || pokemon.egg?) ? "-" : sprintf("%05d",publicID)
      smalltextpos.push(["ID No.",74,232,0,base,shadow])
      smalltextpos.push([idno,172,254,1,Color.new(64,64,64),Color.new(176,176,176)])
      if pokemon.egg?
        smalltextpos.push(["-",172,202,1,Color.new(64,64,64),Color.new(176,176,176)])
      elsif pokemon.owner.name==""
        smalltextpos.push(["RENTAL",172,202,1,Color.new(64,64,64),Color.new(176,176,176)])
      else
        ownerbase=Color.new(64,64,64)
        ownershadow=Color.new(176,176,176)
        if pokemon.owner.gender==0 # male OT
          ownerbase=Color.new(24,112,216)
          ownershadow=Color.new(136,168,208)
        elsif pokemon.owner.gender==1 # female OT
          ownerbase=Color.new(248,56,32)
          ownershadow=Color.new(224,152,144)
        end
        smalltextpos.push([pokemon.owner.name,172,202,1,ownerbase,ownershadow])
        if pokemon.male?
          textpos.push([_INTL("♂"),230,80,0,Color.new(24,112,216),Color.new(136,168,208)])
        elsif pokemon.female?
          textpos.push([_INTL("♀"),230,80,0,Color.new(248,56,32),Color.new(224,152,144)])
        end
      end
      pbSetSystemFont(overlay)
      pbDrawTextPositions(overlay,textpos,false)
      pbSetSmallFont(overlay)
      pbDrawTextPositions(overlay,smalltextpos,false)
      drawMarkings(overlay,62,286,72,20,pokemon.markings)
      if !pokemon.egg?
        type1rect=Rect.new(0,GameData::Type.get(pokemon.type1).id_number*28,64,28)
        type2rect=Rect.new(0,GameData::Type.get(pokemon.type2).id_number*28,64,28)
        affinity1rect=Rect.new(0,GameData::Type.get(pokemon.affinity1).id_number*28,64,28)
        affinity2rect=Rect.new(0,GameData::Type.get(pokemon.affinity2).id_number*28,64,28)
        if pokemon.type1==pokemon.type2
          overlay.blt(256-74,316,@typebitmap.bitmap,type1rect)
        else
          overlay.blt(222-74,316,@typebitmap.bitmap,type1rect)
          overlay.blt(290-74,316,@typebitmap.bitmap,type2rect)
        end
        if pokemon.affinity1==pokemon.affinity2
          overlay.blt(256+74,316,@typebitmap.bitmap,affinity1rect)
        else
          overlay.blt(222+74,316,@typebitmap.bitmap,affinity1rect)
          overlay.blt(290+74,316,@typebitmap.bitmap,affinity2rect)
        end
        if pokemon.level<Settings::MAXIMUM_LEVEL
          overlay.fill_rect(440,116,(pokemon.exp-startexp)*64/(endexp-startexp),2,Color.new(72,120,160))
          overlay.fill_rect(440,118,(pokemon.exp-startexp)*64/(endexp-startexp),4,Color.new(24,144,248))
        end
        overlay.fill_rect(110,116,(pokemon.happiness+1)/8*2,2,Color.new(214,86,172))
        overlay.fill_rect(110,118,(pokemon.happiness+1)/8*2,4,Color.new(255,96,232))
      end
    end
  
    def drawPageStats(pokemon)
      @sprites["pokemon"].visible=false
      overlay=@sprites["overlay"].bitmap
      overlay.clear
      updatePokeIcons
      @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_2")
      imagepos=[]
      if pbPokerus(pokemon)==1 || pokemon.hp==0 || @pokemon.status!=:None
        status=6 if pbPokerus(pokemon)==1
        status=GameData::Status.get(@pokemon.status).id_number if @pokemon.status!=:None
        status=5 if pokemon.hp==0
        #imagepos.push(["Graphics/Pictures/statuses",124,100,0,16*status,44,16])
      end
      if pokemon.shiny?
        imagepos.push([sprintf("Graphics/Pictures/shiny"),2,134,0,0,-1,-1])
      end
      if pbPokerus(pokemon)==2
        imagepos.push([sprintf("Graphics/Pictures/Summary/icon_pokerus"),176,100,0,0,-1,-1])
      end
      pbDrawImagePositions(overlay,imagepos)
      base=Color.new(64,64,64)
      shadow=Color.new(176,176,176)
      base2=Color.new(248,248,248)
      shadow2=Color.new(104,104,104)
      statshadows=[]
      for i in 0...5; statshadows[i]=[base2,shadow2]; end
      if !(pokemon.isShadow? rescue false) || pokemon.heartStage<=3
        nat = GameData::Nature.get(pokemon.nature).id_number
        natup=(nat/5).floor
        natdn=(nat%5).floor
        statshadows[natup]=[Color.new(0,150,0),Color.new(160,255,160)] if natup!=natdn
        statshadows[natdn]=[Color.new(150,0,0),Color.new(255,160,160)] if natup!=natdn
      end
      statshadows2=[]
      pbSetSystemFont(overlay)
      abilityname=GameData::Ability.get(pokemon.ability).name
      abilitydesc=GameData::Ability.get(pokemon.ability).description
      pokename=@pokemon.name
      speciesname = GameData::Species.get(pokemon.species).name
      basestats=pokemon.baseStats
      textpos=[
        [pokename,288,12,2,base2,shadow2],
        [_INTL("Ability"),142,312,2,base2,shadow2],
        [abilityname,142,346,2,base2,shadow2]
      ]
      smalltextpos=[
        [pokemon.level.to_s,134,82,0,base2,shadow2],
        [sprintf("#%03d "+speciesname,GameData::Species.get(pokemon.species).id_number),288,48,2,base2,shadow2],
        [_INTL("HP"),112,110,2,Color.new(248,248,248),Color.new(104,104,104)],
        [sprintf("%3d/%3d",pokemon.hp,pokemon.totalhp),206,110,2,Color.new(64,64,64),Color.new(176,176,176)],
        [_INTL("Attack"),134,138,2,statshadows[0][0],statshadows[0][1]],
        [sprintf("%d",pokemon.attack),228,138,2,base,shadow],
        [_INTL("Defense"),134,166,2,statshadows[1][0],statshadows[1][1]],
        [sprintf("%d",pokemon.defense),228,166,2,base,shadow],
        [_INTL("Sp. Atk"),134,194,2,statshadows[3][0],statshadows[3][1]],
        [sprintf("%d",pokemon.spatk),228,194,2,base,shadow],
        [_INTL("Sp. Def"),134,222,2,statshadows[4][0],statshadows[4][1]],
        [sprintf("%d",pokemon.spdef),228,222,2,base,shadow],
        [_INTL("Speed"),134,250,2,statshadows[2][0],statshadows[2][1]],
        [sprintf("%d",pokemon.speed),228,250,2,base,shadow],
        [sprintf("%d",pokemon.ev[:HP]),296,110,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.ev[:ATTACK]),296,138,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.ev[:DEFENSE]),296,166,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.ev[:SPECIAL_ATTACK]),296,194,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.ev[:SPECIAL_DEFENSE]),296,222,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.ev[:SPEED]),296,250,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.iv[:HP]),350,110,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.iv[:ATTACK]),350,138,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.iv[:DEFENSE]),350,166,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.iv[:SPECIAL_ATTACK]),350,194,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.iv[:SPECIAL_DEFENSE]),350,222,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",pokemon.iv[:SPEED]),350,250,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",basestats[:HP]),404,110,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",basestats[:ATTACK]),404,138,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",basestats[:DEFENSE]),404,166,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",basestats[:SPECIAL_ATTACK]),404,194,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",basestats[:SPECIAL_DEFENSE]),404,222,2,Color.new(64,64,64),Color.new(176,176,176)],
        [sprintf("%d",basestats[:SPEED]),404,250,2,Color.new(64,64,64),Color.new(176,176,176)],
        [_INTL("{1} Nature",GameData::Nature.get(pokemon.nature).name),180,280,2,base2,shadow2]
      ]
      if pokemon.hasItem?
        smalltextpos.push([GameData::Items.get(pokemon.item).name,398,280,2,base2,shadow2])
      else
        smalltextpos.push([_INTL("No Item"),398,280,2,Color.new(208,208,200),Color.new(120,144,184)])
      end
      pbSetSmallFont(overlay)
      pbDrawTextPositions(overlay,smalltextpos,false)
      pbSetSystemFont(overlay)
      pbDrawTextPositions(overlay,textpos,false)
      pbSetSmallFont(overlay)
      drawTextEx(overlay,226,316,286,2,abilitydesc,base2,shadow2,true)
      pbSetSystemFont(overlay)
      #drawMarkings(overlay,15,291,72,20,pokemon.markings)
      if pokemon.hp>0
        hpcolors=[
           Color.new(24,192,32),Color.new(0,144,0),     # Green
           Color.new(248,184,0),Color.new(184,112,0),   # Orange
           Color.new(240,80,32),Color.new(168,48,56)    # Red
        ]
        hpzone=0
        hpzone=1 if pokemon.hp<=(@pokemon.totalhp/2).floor
        hpzone=2 if pokemon.hp<=(@pokemon.totalhp/4).floor
        #overlay.fill_rect(360,110,pokemon.hp*96/pokemon.totalhp,2,hpcolors[hpzone*2+1])
        #overlay.fill_rect(360,112,pokemon.hp*96/pokemon.totalhp,4,hpcolors[hpzone*2])
      end
    end
    
    def drawPageMoves(pokemon)
      overlay=@sprites["overlay"].bitmap
      overlay.clear
      updatePokeIcons
      @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_3")
      @sprites["pokemon"].visible=false
      @sprites["pokeicon"].visible=false
      overlay=@sprites["overlay"].bitmap
      overlay.clear
      base=Color.new(248,248,248)
      shadow=Color.new(104,104,104)
      @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_movedetail")
      pbSetSystemFont(overlay)
      textpos=[
         [pokemon.name,288,12,2,base,shadow],
         [_INTL("TYPE"),72,222,0,base,shadow],
         [_INTL("CATEGORY"),72,254,0,base,shadow],
      ]
      smalltextpos=[
         [_INTL("POWER"),116,284,2,base,shadow],
         [_INTL("ACCURACY"),220,284,2,base,shadow],
         [_INTL("EFFECT"),116,332,2,base,shadow],
         [_INTL("PRIORITY"),220,332,2,base,shadow]
      ]
      smallesttextpos=[]
      type1rect=Rect.new(0,GameData::Type.get(pokemon.type1).id_number*28,64,28)
      type2rect=Rect.new(0,GameData::Type.get(pokemon.type2).id_number*28,64,28)
      if pokemon.type1==pokemon.type2
        overlay.blt(130,78,@typebitmap.bitmap,type1rect)
      else
        overlay.blt(96,78,@typebitmap.bitmap,type1rect)
        overlay.blt(166,78,@typebitmap.bitmap,type2rect)
      end
      imagepos=[]
      xPos=70
      yPos=54
      for i in 0...4
        moveobject=pokemon.moves[i]
        movedata=GameData::Move.get(moveobject.id)
        if moveobject
          if moveobject.id!=0
            imagepos.push(["Graphics/Pictures/Summary/move_slot",xPos,yPos,0,
               GameData::Type.get(moveobject.type).id_number*80,216,80])
            #upgrade = pbMoveUpgradeTitle(pokemon,moveobject.id)
            #imagepos.push(["Graphics/Pictures/summary4upgrade",xPos+6,yPos+62,0,
            #   upgrade*14,204,14])
            textpos.push([movedata.name,xPos+106,yPos+4,2,
               Color.new(64,64,64),Color.new(176,176,176)])
            if moveobject.totalpp>0
              textpos.push([_ISPRINTF("PP"),xPos+30,yPos+32,0,
                 Color.new(64,64,64),Color.new(176,176,176)])
              textpos.push([sprintf("%d/%d",moveobject.pp,moveobject.totalpp),
                 xPos+186,yPos+32,1,Color.new(64,64,64),Color.new(176,176,176)])
              accuracy = movedata.accuracy
              if movedata.base_damage > 0
                smallesttextpos.push([sprintf("%d PWR   %s ACC",
                   movedata.base_damage,accuracy==0 ? "-" : sprintf("%d",accuracy)),
                   xPos+106,yPos+56,2,Color.new(252,252,252),Color.new(33,33,33)])
              else
                smallesttextpos.push([sprintf("%s ACCURACY",accuracy==0 ? "---" : sprintf("%d",accuracy)),
                   xPos+106,yPos+56,2,Color.new(252,252,252),Color.new(33,33,33)])
              end
            end
          else
            textpos.push(["-",316,yPos,0,Color.new(64,64,64),Color.new(176,176,176)])
            textpos.push(["--",442,yPos+32,1,Color.new(64,64,64),Color.new(176,176,176)])
          end
        end
        xPos+=220 if i % 2 == 0
        xPos-=220 if i % 2 == 1
        yPos+=84 if i % 2 == 1
      end
      pbDrawImagePositions(overlay,imagepos)
      pbSetSmallestFont(overlay)
      pbDrawTextPositions(overlay,smallesttextpos,false)
      pbSetSmallFont(overlay)
      pbDrawTextPositions(overlay,smalltextpos,false)
      pbSetSystemFont(overlay)
      pbDrawTextPositions(overlay,textpos,false)
      xPos=132
      yPos=118
      for i in 0...4
        moveobject=pokemon.moves[i]
        xPos+=220 if i % 2 == 0
        xPos-=220 if i % 2 == 1
        yPos+=84 if i % 2 == 1
      end
    end
  
    def drawSelectedMove(pokemon,moveToLearn,moveid)
      overlay=@sprites["overlay"].bitmap
      @sprites["pokemon"].visible=false if @sprites["pokemon"]
      @sprites["pokeicon"].setBitmap(GameData::Species.icon_filename_from_pokemon(pokemon))
      @sprites["pokeicon"].src_rect=Rect.new(0,0,64,64)
      @sprites["pokeicon"].visible=(moveToLearn!=0)
      movedata=GameData::Move.get(moveid)
      basedamage=movedata.base_damage
      type=GameData::Type.get(movedata.type).id_number
      category=movedata.category
      accuracy=movedata.accuracy
      effectch=movedata.effect_chance
      priority=movedata.priority
      if pokemon.ability==:PRANKSTER && category==2
        priority+=1
      end
      drawMoveSelection(pokemon,moveToLearn)
      pbSetSystemFont(overlay)
      move=movedata.id_number
      textcolor=[
        basedamage==movedata.base_damage ? Color.new(64,64,64) : Color.new(0,150,0),
        accuracy==movedata.accuracy ? Color.new(64,64,64) : Color.new(0,150,0),
        effectch==movedata.effect_chance ? Color.new(64,64,64) : Color.new(0,150,0),
        priority==movedata.priority ? Color.new(64,64,64) : Color.new(0,150,0)
      ]
      textshadow=[
        basedamage==movedata.base_damage ? Color.new(198,176,176) : Color.new(176,198,176),
        accuracy==movedata.accuracy ? Color.new(198,176,176) : Color.new(176,198,176),
        effectch==movedata.effect_chance ? Color.new(198,176,176) : Color.new(176,198,176),
        priority==movedata.priority ? Color.new(198,176,176) : Color.new(176,198,176)
      ]
      text_x = moveToLearn!=0 ? 60 : 116
      text_y = moveToLearn!=0 ? 142 : 308
      xdif = moveToLearn!=0 ? 120 : 104
      textpos=[
         [basedamage<=1 ? basedamage==1 ? "???" : "---" : sprintf("%d",basedamage),
            text_x,text_y,2,textcolor[0],textshadow[0]],
         [accuracy==0 ? "---" : sprintf("%d",accuracy)+"%",
            text_x+xdif,text_y,2,textcolor[1],textshadow[1]],
         [effectch==0 ? "---" : sprintf("%d",effectch)+"%",
            text_x,text_y+48,2,textcolor[2],textshadow[2]],
         [priority==0 ? "---" : sprintf("%s%d",priority>0 ? "+" : "-",priority),
            text_x+xdif,text_y+48,2,textcolor[3],textshadow[3]]
      ]
      pbSetSmallFont(overlay)
      pbDrawTextPositions(overlay,textpos,false)
      pbSetSystemFont(overlay)
      text_x = moveToLearn!=0 ? 166 : 198
      text_y = moveToLearn!=0 ? 56 : 222
      imagepos=[["Graphics/Pictures/category",text_x,text_y+32,0,category*28,64,28],
                ["Graphics/Pictures/types",text_x,text_y,0,type*28,64,28]]
      pbDrawImagePositions(overlay,imagepos)
      drawTextEx(overlay,moveToLearn!=0 ? 8 : 278,moveToLearn!=0 ? text_y+164 : 226,238,5,
         movedata.description,
         Color.new(248,248,248),Color.new(104,104,104),true)
    end
  
    def drawMoveSelection(pokemon,moveToLearn)
      overlay=@sprites["overlay"].bitmap
      overlay.clear
      base=Color.new(248,248,248)
      shadow=Color.new(104,104,104)
      @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_movedetail")
      if moveToLearn!=0
        @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_learnmove")
      end
      pbSetSystemFont(overlay)
      text_x = moveToLearn!=0 ? 8 : 72
      text_y = moveToLearn!=0 ? 56 : 222
      textpos=[
         [pokemon.name,moveToLearn!=0 ? 90 : 288,12,moveToLearn!=0 ? 0 : 2,base,shadow],
         [_INTL("TYPE"),text_x,text_y,0,base,shadow],
         [_INTL("CATEGORY"),text_x,text_y+32,0,base,shadow]
      ]
      text_x = moveToLearn!=0 ? 60 : 116
      text_y = moveToLearn!=0 ? 118 : 284
      xdif = moveToLearn!=0 ? 120 : 104
      smalltextpos=[
         [_INTL("POWER"),text_x,text_y,2,base,shadow],
         [_INTL("ACCURACY"),text_x+xdif,text_y,2,base,shadow],
         [_INTL("EFFECT"),text_x,text_y+48,2,base,shadow],
         [_INTL("PRIORITY"),text_x+xdif,text_y+48,2,base,shadow]
      ]
      textpos.push(["Learn Move",374,12,2,base,shadow]) if moveToLearn!=0
      pbSetSmallFont(overlay)
      pbDrawTextPositions(overlay,smalltextpos,false)
      pbSetSystemFont(overlay)
      pbDrawTextPositions(overlay,textpos,false)
      textpos=[]
      #type1rect=Rect.new(0,pokemon.type1*28,64,28)
      #type2rect=Rect.new(0,pokemon.type2*28,64,28)
      #if pokemon.type1==pokemon.type2
      #  overlay.blt(130,78,@typebitmap.bitmap,type1rect)
      #else
      #  overlay.blt(96,78,@typebitmap.bitmap,type1rect)
      #  overlay.blt(166,78,@typebitmap.bitmap,type2rect)
      #end
      smallesttextpos=[]
      imagepos=[]
      xPos = (moveToLearn!=0) ? 266 : 70
      yPos = (moveToLearn!=0) ? 52 : 54
      for i in 0...5
        moveobject=nil
        if i==4
          moveobject=Pokemon::Move.new(moveToLearn) if moveToLearn!=0
          yPos+=18
        else
          moveobject=pokemon.moves[i]
        end
        if moveobject
          if moveobject.id!=0
            movedata=GameData::Move.get(moveobject.id)
            if moveToLearn!=0
              imagepos.push(["Graphics/Pictures/Summary/move_slot_learn",xPos,yPos,0,
                GameData::Type.get(moveobject.type).id_number*60,216,60])
            else
              imagepos.push(["Graphics/Pictures/Summary/move_slot",xPos,yPos,0,
                GameData::Type.get(moveobject.type).id_number*80,216,80])
            end
            textpos.push([movedata.name,xPos+106,yPos+4,2,
               Color.new(64,64,64),Color.new(176,176,176)])
            if moveobject.totalpp>0
              textpos.push([_ISPRINTF("PP"),xPos+30,moveToLearn!=0 ? yPos+28 : yPos+32,0,
                 Color.new(64,64,64),Color.new(176,176,176)])
              textpos.push([sprintf("%d/%d",moveobject.pp,moveobject.totalpp),
                 xPos+186,moveToLearn!=0 ? yPos+28 : yPos+32,1,Color.new(64,64,64),Color.new(176,176,176)])
            end
            accuracy = movedata.accuracy
            if movedata.base_damage > 0
              smallesttextpos.push([sprintf("%d PWR   %s ACC",
                 movedata.base_damage,accuracy==0 ? "-" : sprintf("%d",accuracy)),
                 xPos+106,yPos+56,2,Color.new(252,252,252),Color.new(33,33,33)])
            else
              smallesttextpos.push([sprintf("%s ACCURACY",accuracy==0 ? "---" : sprintf("%d",accuracy)),
                 xPos+106,yPos+56,2,Color.new(252,252,252),Color.new(33,33,33)])
            end
          else
            textpos.push(["-",316,yPos,0,Color.new(64,64,64),Color.new(176,176,176)])
            textpos.push(["--",442,yPos+32,1,Color.new(64,64,64),Color.new(176,176,176)])
          end
        end
        if moveToLearn!=0
          yPos+=62
        else
          xPos+=220 if i % 2 == 0
          xPos-=220 if i % 2 == 1
          yPos+=84 if i % 2 == 1
        end
      end
      pbDrawImagePositions(overlay,imagepos)
      if moveToLearn==0
        pbSetSmallestFont(overlay)
        pbDrawTextPositions(overlay,smallesttextpos,false)
      end
      pbSetSystemFont(overlay)
      pbSetSmallFont(overlay) if moveToLearn!=0
      pbDrawTextPositions(overlay,textpos,false)
      pbSetSystemFont(overlay) if moveToLearn!=0
      if moveToLearn==0
        xPos=132
        yPos=118
        for i in 0...4
          moveobject=pokemon.moves[i]
          xPos+=220 if i % 2 == 0
          xPos-=220 if i % 2 == 1
          yPos+=84 if i % 2 == 1
        end
      end
    end
  
    def pbChooseMoveToForget(moveToLearn)
      selmove=0
      ret=0
      maxmove=(moveToLearn>0) ? 4 : 3
      loop do
        Graphics.update
        Input.update
        pbUpdate
        if Input.trigger?(Input::B)
          ret=4
          break
        end
        if Input.trigger?(Input::C)
          break
        end
        if Input.trigger?(Input::DOWN)
          selmove+=1
          if selmove<4 && selmove>=@pokemon.numMoves
            selmove=(moveToLearn>0) ? maxmove : 0
          end
          selmove=0 if selmove>maxmove
          @sprites["movesel"].index=selmove
          newmove=(selmove==4) ? moveToLearn : @pokemon.moves[selmove].id
          drawSelectedMove(@pokemon,moveToLearn,newmove)
          ret=selmove
        end
        if Input.trigger?(Input::UP)
          selmove-=1
          selmove=maxmove if selmove<0
          if selmove<4 && selmove>=@pokemon.numMoves
            selmove=@pokemon.numMoves-1
          end
          @sprites["movesel"].index=selmove
          newmove=(selmove==4) ? moveToLearn : @pokemon.moves[selmove].id
          drawSelectedMove(@pokemon,moveToLearn,newmove)
          ret=selmove
        end
      end
      return (ret==4) ? -1 : ret
    end
  
    def pbMoveSelection
      @sprites["movesel"].visible=true
      @sprites["movesel"].index=0
      selmove=0
      oldselmove=0
      switching=false
      drawSelectedMove(@pokemon,0,@pokemon.moves[selmove].id)
      offset=0
      loop do
        Graphics.update
        Input.update
        pbUpdate
        if @sprites["movepresel"].index==@sprites["movesel"].index
          @sprites["movepresel"].z=@sprites["movesel"].z+1
        else
          @sprites["movepresel"].z=@sprites["movesel"].z
        end
        if Input.trigger?(Input::B)
          break if !switching
          @sprites["movepresel"].visible=false
          switching=false
        end
        if Input.trigger?(Input::A)
          if Input.press?(Input::CTRL)
            offset-=1
          else
            offset+=1
          end
          drawSelectedMove(@pokemon,0,@pokemon.moves[selmove].id + offset)
          pbMessage(PBMoves.getName(@pokemon.moves[selmove].id + offset))
        end
        if Input.trigger?(Input::C)
          if selmove==4
            break if !switching
            @sprites["movepresel"].visible=false
            switching=false
          else
            if !(@pokemon.isShadow? rescue false)
              if !switching
                @sprites["movepresel"].index=selmove
                oldselmove=selmove
                @sprites["movepresel"].visible=true
                switching=true
              else
                tmpmove=@pokemon.moves[oldselmove]
                @pokemon.moves[oldselmove]=@pokemon.moves[selmove]
                @pokemon.moves[selmove]=tmpmove
                @sprites["movepresel"].visible=false
                switching=false
                drawSelectedMove(@pokemon,0,@pokemon.moves[selmove].id)
              end
            end
          end
        end
        if Input.trigger?(Input::DOWN)
          selmove+=2 if selmove<=1
          selmove=0 if selmove<4 && selmove>=@pokemon.numMoves
          selmove=0 if selmove>=4
          selmove=4 if selmove<0
          @sprites["movesel"].index=selmove
          newmove=@pokemon.moves[selmove].id
          pbPlayCursorSE()
          drawSelectedMove(@pokemon,0,newmove)
        end
        if Input.trigger?(Input::UP)
          selmove-=2 if selmove>=2
          if selmove<4 && selmove>=@pokemon.numMoves
            selmove=@pokemon.numMoves-1
          end
          selmove=0 if selmove>=4
          selmove=@pokemon.numMoves-1 if selmove<0
          @sprites["movesel"].index=selmove
          newmove=@pokemon.moves[selmove].id
          pbPlayCursorSE()
          drawSelectedMove(@pokemon,0,newmove)
        end
        if Input.trigger?(Input::RIGHT)
          selmove+=1 if selmove % 2 == 0
          selmove=0 if selmove<4 && selmove>=@pokemon.numMoves
          selmove=0 if selmove>=4
          selmove=4 if selmove<0
          @sprites["movesel"].index=selmove
          newmove=@pokemon.moves[selmove].id
          pbPlayCursorSE()
          drawSelectedMove(@pokemon,0,newmove)
        end
        if Input.trigger?(Input::LEFT)
          selmove-=1 if selmove % 2 == 1
          selmove=0 if selmove<4 && selmove>=@pokemon.numMoves
          selmove=0 if selmove>=4
          selmove=4 if selmove<0
          @sprites["movesel"].index=selmove
          newmove=@pokemon.moves[selmove].id
          pbPlayCursorSE()
          drawSelectedMove(@pokemon,0,newmove)
        end
      end 
      @sprites["movesel"].visible=false
    end
  
    def pbGoToPrevious
      if @page!=0
        newindex=@partyindex
        while newindex>0
          newindex-=1
          if @party[newindex] && !@party[newindex].egg?
            @partyindex=newindex
            break
          end
        end
      else
        newindex=@partyindex
        while newindex>0
          newindex-=1
          if @party[newindex]
            @partyindex=newindex
            break
          end
        end
      end
    end
  
    def pbGoToNext
      if @page!=0
        newindex=@partyindex
        while newindex<@party.length-1
          newindex+=1
          if @party[newindex] && !@party[newindex].egg?
            @partyindex=newindex
            break
          end
        end
      else
        newindex=@partyindex
        while newindex<@party.length-1
          newindex+=1
          if @party[newindex]
            @partyindex=newindex
            break
          end
        end
      end
    end
  
    def pbScene
      GameData::Species.play_cry(@pokemon)
      loop do
        Graphics.update
        Input.update
        pbUpdate
        if Input.trigger?(Input::B)
          break
        end
        dorefresh=false
        if Input.trigger?(Input::C)
          if @page==0
            break
          elsif @page==2
            pbMoveSelection
            dorefresh=true
            drawPageMoves(@pokemon)
          end
        end
        if Input.trigger?(Input::UP) && @partyindex>0
          oldindex=@partyindex
          pbGoToPrevious
          if @partyindex!=oldindex
            @pokemon=@party[@partyindex]
            @sprites["pokemon"].setPokemonBitmap(@pokemon)
            @sprites["pokemon"].color=Color.new(0,0,0,0)
            pbPositionPokemonSprite(@sprites["pokemon"],224,116)
            dorefresh=true
            GameData::Species.play_cry(@pokemon)
          end
        end
        if Input.trigger?(Input::DOWN) && @partyindex<@party.length-1
          oldindex=@partyindex
          pbGoToNext
          if @partyindex!=oldindex
            @pokemon=@party[@partyindex]
            @sprites["pokemon"].setPokemonBitmap(@pokemon)
            @sprites["pokemon"].color=Color.new(0,0,0,0)
            pbPositionPokemonSprite(@sprites["pokemon"],224,116)
            dorefresh=true
            GameData::Species.play_cry(@pokemon)
          end
        end
        if Input.trigger?(Input::LEFT) && !@pokemon.egg?
          oldpage=@page
          @page-=1
          @page=2 if @page<0
          @page=0 if @page>2
          dorefresh=true
          if @page!=oldpage # Move to next page
            pbPlayCursorSE()
            dorefresh=true
          end
        end
        if Input.trigger?(Input::RIGHT) && !@pokemon.egg?
          oldpage=@page
          @page+=1
          @page=2 if @page<0
          @page=0 if @page>2
          if @page!=oldpage # Move to next page
            pbPlayCursorSE()
            dorefresh=true
          end
        end
        if $DEBUG && Input.trigger?(Input::A)
          @test = 0 if !@test
          @test+=1
          drawPageStats(@pokemon)
        end
        if dorefresh
          case @page
          when 0
            drawPageInfo(@pokemon)
          when 1
            drawPageStats(@pokemon)
          when 2
            drawPageMoves(@pokemon)
          end
        end
      end
      return @partyindex
    end
  end
  
  
  
  class PokemonSummary
    def initialize(scene)
      @scene=scene
    end
  
    def pbStartScreen(party,partyindex)
      @scene.pbStartScene(party,partyindex)
      ret=@scene.pbScene
      @scene.pbEndScene
      return ret
    end
  
    def pbStartForgetScreen(party,partyindex,moveToLearn)
      ret=-1
      @scene.pbStartForgetScene(party,partyindex,moveToLearn)
      loop do
        ret=@scene.pbChooseMoveToForget(moveToLearn)
        if ret>=0 && moveToLearn!=0 && pbIsHiddenMove?(party[partyindex].moves[ret].id) && !$DEBUG
          pbMessage(_INTL("HM moves can't be forgotten now.")){ @scene.pbUpdate }
        else
          break
        end
      end
      @scene.pbEndScene
      return ret
    end
  
    def pbStartChooseMoveScreen(party,partyindex,message)
      ret=-1
      @scene.pbStartForgetScene(party,partyindex,0)
      pbMessage(message){ @scene.pbUpdate }
      loop do
        ret=@scene.pbChooseMoveToForget(0)
        if ret<0
          pbMessage(_INTL("You must choose a move!")){ @scene.pbUpdate }
        else
          break
        end
      end
      @scene.pbEndScene
      return ret
    end
  end