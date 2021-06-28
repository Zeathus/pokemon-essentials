def pbStartEditMoveset
  pbFadeOutIn(99999){
     scene=PokemonScreen_Scene.new
     screen=PokemonScreen.new(scene,$Trainer.party)
     screen.pbStartScene(_INTL("Edit which Pokémon?"),false)
     loop do
       chosen=screen.pbChoosePokemon
       if chosen>=0
         pokemon=$Trainer.party[chosen]
         if pokemon.isEgg?
           Kernel.pbMessage(_INTL("{1} can't be taught to an Egg.",movename))
         elsif (pokemon.isShadow? rescue false)
           Kernel.pbMessage(_INTL("Shadow Pokémon can't be taught any moves."))
         else
           pbEditMoveset(pokemon)
         end
       else
         break
       end
     end
     screen.pbEndScene
  }
end

def pbEditMoveset(pokemon)
  pbFadeOutIn(99998) {
    scene = EditMovesetScreen.new
    scene.pbStartScreen(pokemon)
    scene.pbEndScreen
  }
  
end

class EditMovesetMove < Sprite
  def initialize(viewport,x,y,buttonBitmap)
    super(viewport)
    @buttonBitmap = buttonBitmap
    @chipBitmap = BitmapCache.load_bitmap("Graphics/Pictures/editMovesetChip")
    self.bitmap = Bitmap.new(224,46)
    @move = nil
    @selected = false
    self.x = x
    self.y = y
    self.z = 10
    @chip = false
    refresh
  end
  
  def move=(value)
    @move = value
  end
  
  def selected=(value)
    @selected = value
  end
  
  def chip=(value)
    @chip = value
  end
  
  def refresh
    moveid = !@move ? -1 : (@chip ? @move[0] : @move)
    if !@move || moveid <= 0
      self.visible = false
      return
    end
    self.visible = true
    self.bitmap.clear
    if !@chip || (pbHasDataChipMove(@move[0]) && @move[2])
      type=PBMoveData.new(moveid).type
      self.bitmap.blt(0,0,@buttonBitmap,
        Rect.new(@selected ? 224 : 0,46 * type,224,46))
      textpos = [[PBMoves.getName(moveid),112,8,2,
           Color.new(64,64,64),Color.new(176,176,176)]]
      pbSetSystemFont(self.bitmap)
      pbDrawTextPositions(self.bitmap,textpos)
    else
      type=PBMoveData.new(moveid).type
      self.bitmap.blt(0,0,@buttonBitmap,
        Rect.new(448 + (@selected ? 224 : 0),46 * type,224,46))
      textpos = []
      smalltextpos = []
      smallesttextpos = []
      if !pbHasDataChipMove(@move[0])
        self.bitmap.blt(196,16,@chipBitmap,
          Rect.new(0,0,14,14))
        if $PokemonBag.pbQuantity(:DATACHIP)>=@move[1]
          smalltextpos.push([_INTL("{1}x",@move[1]),184,8,2,
               Color.new(0,252,0),Color.new(0,100,0)])
        else
          smalltextpos.push([_INTL("{1}x",@move[1]),184,8,2,
               Color.new(252,0,0),Color.new(100,0,0)])
        end
        if !@move[2]
          smallesttextpos.push([PBMoves.getName(moveid).upcase,28,2,0,
               Color.new(0,252,0),Color.new(0,100,0)])
          smallesttextpos.push(["INCOMPATIBLE",28,16,0,
               Color.new(252,0,0),Color.new(100,0,0)])
        else
          textpos.push([PBMoves.getName(moveid),28,8,0,
               Color.new(0,252,0),Color.new(0,100,0)])
        end
      else
        if !@move[2]
          smallesttextpos.push([PBMoves.getName(moveid).upcase,112,2,2,
               Color.new(0,252,0),Color.new(0,100,0)])
          smallesttextpos.push(["INCOMPATIBLE",112,16,2,
               Color.new(252,0,0),Color.new(100,0,0)])
        else
          textpos = [[PBMoves.getName(moveid),112,8,2,
               Color.new(64,64,64),Color.new(176,176,176)]]
        end
      end
      pbSetSystemFont(self.bitmap)
      pbDrawTextPositions(self.bitmap,textpos)
      pbSetSmallFont(self.bitmap)
      pbDrawTextPositions(self.bitmap,smalltextpos)
      pbSetSmallestFont(self.bitmap)
      pbDrawTextPositions(self.bitmap,smallesttextpos)
    end
  end
  
  def dispose
    @chipBitmap.dispose if !@chipBitmap.disposed?
    @buttonBitmap.dispose if !@buttonBitmap.disposed?
    super
  end
  
end

class EditMovesetScreen
  
  def update
    pbUpdateSpriteHash(@sprites)
    @viewport.update
  end
  
  def pbRefresh
    base = Color.new(64,64,64)
    shadow = Color.new(176,176,176)
    
    move = @listMoves[@currentList][@listIndex[@currentList]]
    move = move[0] if dataChipList?
    if @switching
      move = @pokemon.moves[@switchIndex].id
    end

    @sprites["overlay"].bitmap.clear
    textpos = [[@pokemon.name,116,6,2,base,shadow],
               [@listNames[@currentList],377,6,2,base,shadow],
               [_INTL("TYPE"),14,260,0,base,shadow],
               [_INTL("CATEGORY"),14,294,0,base,shadow]]
    smalltextpos=[[_INTL("POWER"),60,326,2,base,shadow],
                  [_INTL("ACCURACY"),174,326,2,base,shadow],
                  [dataChipList? ?
                    _INTL("You have {1} Data Chips",$PokemonBag.pbQuantity(:DATACHIP)) :
                    "Press Z to change sorting",
                    268,350,0,base,shadow]]
    
    if move && move > 0
      movedata = PBMoveData.new(move)
      basedamage = movedata.basedamage
      accuracy = movedata.accuracy
      smalltextpos.push([basedamage<=1 ? basedamage==1 ? "???" : "---" : sprintf("%d",basedamage),
                     60,348,2,base,shadow])
      smalltextpos.push([accuracy==0 ? "---" : sprintf("%d",accuracy)+"%",
                     174,348,2,base,shadow])
      imagepos=[["Graphics/Pictures/category",156,296,0,movedata.category*28,64,28],
                ["Graphics/Pictures/types",156,262,0,movedata.type*28,64,28]]
      pbDrawImagePositions(@sprites["overlay"].bitmap,imagepos)
    end
    
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawTextPositions(@sprites["overlay"].bitmap,textpos)
    pbSetSmallFont(@sprites["overlay"].bitmap)
    pbDrawTextPositions(@sprites["overlay"].bitmap,smalltextpos)
    
    for i in 0...4
      @sprites[_INTL("active{1}",i)].move = @pokemon.moves[i].id
      if @switching
        @sprites[_INTL("active{1}",i)].selected = (@switchIndex == i)
      else
        @sprites[_INTL("active{1}",i)].selected = false
      end
      @sprites[_INTL("active{1}",i)].refresh
    end
    
    list = @listMoves[@currentList]
    index = @listIndex[@currentList]
    scroll = @listScroll[@currentList]
    for i in 0...6
      @sprites[_INTL("list{1}",i)].chip = dataChipList?
      @sprites[_INTL("list{1}",i)].move = list[scroll + i]
      @sprites[_INTL("list{1}",i)].selected = (index - scroll == i)
      @sprites[_INTL("list{1}",i)].refresh
    end
    
    maxscroll = list.length > 6 ? (list.length - 6) : 1
    @sprites["scrollbar"].y = 50 + (258 * scroll / maxscroll)
  end
  
  def pbStartScreen(pokemon)
    @pokemon = pokemon
    
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    
    @buttonBitmap = BitmapCache.load_bitmap("Graphics/Pictures/editMovesetButtons")
    
    @sprites["bg"] = IconSprite.new(0,0,@viewport)
    @sprites["bg"].setBitmap("Graphics/Pictures/editMovesetBG")
    
    @sprites["overlay"] = Sprite.new(@viewport)
    @sprites["overlay"].bitmap = Bitmap.new(512,384)
    @sprites["overlay"].z = 1
    
    @sprites["scrollbar"] = IconSprite.new(0,0,@viewport)
    @sprites["scrollbar"].setBitmap("Graphics/Pictures/editMovesetScrollbar")
    @sprites["scrollbar"].x = 500
    @sprites["scrollbar"].y = 50
    @sprites["scrollbar"].z = 2
    
    for i in 0...4
      @sprites[_INTL("active{1}",i)] = EditMovesetMove.new(@viewport,4,52+i*48,@buttonBitmap)
    end
    
    for i in 0...6
      @sprites[_INTL("list{1}",i)] = EditMovesetMove.new(@viewport,264,52+i*48,@buttonBitmap)
      @sprites[_INTL("list{1}",i)].move = 1
    end
    
    @listMoves = [
      pbGetRelearnableMoves(@pokemon),
      pbGetTMMoves(@pokemon),
      pbGetDataChipMoves(@pokemon)
    ]
    @listNames = [
      "Level Up",
      "TMs",
      "Data Chips"
    ]
    @listCount = [@listMoves.length,@listNames.length].min
    @listIndex = [0] * @listCount
    @listScroll = [0] * @listCount
    @currentList = 0
    @switching = false
    @switchIndex = 0
    @pressUp = 0
    @pressDown = 0
    @sorting = 0
    
    pbRefresh
    pbFadeInAndShow(@sprites)
    pbMain
  end
  
  def pbMain
    loop do
      update
      Input.update
      Graphics.update
      mustrefresh = false
      if Input.press?(Input::UP)
        @pressUp += 1
      else
        @pressUp = 0
      end
      if Input.press?(Input::DOWN)
        @pressDown += 1
      else
        @pressDown = 0
      end
      if @switching
        lastIndex = 0
        for i in 0...4
          if @pokemon.moves[i] && @pokemon.moves[i].id > 0
            lastIndex = i
          end
        end
        if @pressUp == 1 || (@pressUp > 20 && @pressUp % 8 == 0)
          if @switchIndex > 0
            @switchIndex -= 1
            mustrefresh = true
          elsif @pressUp == 1
            @switchIndex = lastIndex
            mustrefresh = true
          end
        elsif @pressDown == 1 || (@pressDown > 20 && @pressDown % 8 == 0)
          if @switchIndex < lastIndex
            @switchIndex += 1
            mustrefresh = true
          elsif @pressDown == 1
            @switchIndex = 0
            mustrefresh = true
          end
        end
      else
        if @pressUp == 1 || (@pressUp > 20 && @pressUp % 8 == 0)
          if @listIndex[@currentList] > 0
            @listIndex[@currentList] -= 1
            mustrefresh = true
          elsif @pressUp == 1
            @listIndex[@currentList] = @listMoves[@currentList].length - 1
            mustrefresh = true
          end
        elsif @pressDown == 1 || (@pressDown > 20 && @pressDown % 8 == 0)
          if @listIndex[@currentList] < @listMoves[@currentList].length - 1
            @listIndex[@currentList] += 1
            mustrefresh = true
          elsif @pressDown == 1
            @listIndex[@currentList] = 0
            mustrefresh = true
          end
        elsif Input.trigger?(Input::LEFT)
          @currentList -= 1
          @currentList = @listCount - 1 if @currentList < 0
          mustrefresh = true
        elsif Input.trigger?(Input::RIGHT)
          @currentList += 1
          @currentList = 0 if @currentList >= @listCount
          mustrefresh = true
        end
      end
      
      if Input.trigger?(Input::C)
        move = @listMoves[@currentList][@listIndex[@currentList]]
        if @switching
          pbSetMove(@switchIndex,dataChipList? ? move[0] : move)
          @switching = false
          mustrefresh = true
        elsif move
          if dataChipList?
            if !pbHasDataChipMove(move[0])
              if $PokemonBag.pbQuantity(:DATACHIP)<move[1]
                Kernel.pbMessage(_INTL("You don't have enough Data Chips to unlock {1}.",PBMoves.getName(move[0])))
              else
                if $game_variables[DATA_CHIP_MOVES].length <= 0
                  Kernel.pbMessage(_INTL("By unlocking {1}, you will be using Data Chips.",PBMoves.getName(move[0])))
                  Kernel.pbMessage(_INTL("{1} will then be permanently available for all compatible Pokémon.",PBMoves.getName(move[0])))
                end
                command = Kernel.pbMessage(_INTL("Do you want to extract {1} from {2} Data Chips?",PBMoves.getName(move[0]),move[1]),["Yes","No"],-1)
                if command == 0
                  $PokemonBag.pbDeleteItem(:DATACHIP,move[1])
                  pbAddDataChipMove(move[0])
                  mustrefresh = true
                end
              end
            elsif !move[2]
              Kernel.pbMessage(_INTL("{1} cannot learn {2}",
                @pokemon.name,PBMoves.getName(move[0])))
            else
              @switchIndex = 0
              @switching = true
              mustrefresh = true
            end
          else
            @switchIndex = 0
            @switching = true
            mustrefresh = true
          end
        end
      elsif Input.trigger?(Input::B)
        if @switching
          @switching = false
          mustrefresh = true
        else
          break
        end
      elsif Input.trigger?(Input::A)
        choice = Kernel.pbMessage("What would you like to sort by?",
          ["Level / TM#","Name","Type","Category","Power"],-1,nil,@sorting)
        if choice >= 0 && choice != @sorting
          lastmove = @listMoves[@currentList][@listIndex[@currentList]]
          @sorting = choice
          if @sorting == 0 # Level / TM#
            @listMoves = [
              pbGetRelearnableMoves(@pokemon),
              pbGetTMMoves(@pokemon),
              pbGetDataChipMoves(@pokemon)
            ]
          elsif @sorting == 1 # Name
            for i in 0...@listCount
              @listMoves[i].sort! {|a,b|
                a = a[0] if a.is_a?(Array)
                b = b[0] if b.is_a?(Array)
                PBMoves.getName(a)<=>PBMoves.getName(b)}
            end
          elsif @sorting == 2 # Type
            for i in 0...@listCount
              @listMoves[i].sort! {|a,b|
                a = a[0] if a.is_a?(Array)
                b = b[0] if b.is_a?(Array)
                ta = PBMoveData.new(a).type
                tb = PBMoveData.new(b).type
                (ta == tb) ? PBMoves.getName(a)<=>PBMoves.getName(b) : ta<=>tb}
            end
          elsif @sorting == 3 # Category
            for i in 0...@listCount
              @listMoves[i].sort! {|a,b|
                a = a[0] if a.is_a?(Array)
                b = b[0] if b.is_a?(Array)
                ca = PBMoveData.new(a).category
                cb = PBMoveData.new(b).category
                (ca == cb) ? PBMoves.getName(a)<=>PBMoves.getName(b) : ca<=>cb}
            end
          elsif @sorting == 4 # Power
            for i in 0...@listCount
              @listMoves[i].sort! {|a,b|
                a = a[0] if a.is_a?(Array)
                b = b[0] if b.is_a?(Array)
                pa = PBMoveData.new(a).basedamage
                pb = PBMoveData.new(b).basedamage
                (pa == pb) ? PBMoves.getName(a)<=>PBMoves.getName(b) : pb<=>pa}
            end
          end
          @listIndex[@currentList] = @listMoves[@currentList].index(lastmove)
          mustrefresh = true
        end
      end
      
      if mustrefresh
        @listIndex[@currentList] = 0 if @listIndex[@currentList] < 0
        if @listIndex[@currentList] < @listScroll[@currentList]
          @listScroll[@currentList] = @listIndex[@currentList]
        elsif @listIndex[@currentList] > @listScroll[@currentList] + 5
          @listScroll[@currentList] = @listIndex[@currentList] - 5
        end
        pbRefresh
      end
    end
  end
  
  def pbSetMove(index,move)
    # Do not update if move is the same
    return if @pokemon.moves[index].id == move
    
    # If move is already elsewhere in the moveset, swap places
    for i in 0...4
      if @pokemon.moves[i].id == move
        m = @pokemon.moves[i]
        @pokemon.moves[i] = @pokemon.moves[index]
        @pokemon.moves[index] = m
        return
      end
    end
    
    @pokemon.moves[index] = PBMove.new(move)
  end
  
  def dataChipList?
    return @currentList == 2
  end
  
  def pbEndScreen
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
  
end





