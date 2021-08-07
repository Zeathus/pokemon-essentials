class PokeBattle_OuterScene

    BLANK       = 0
    MESSAGE_BOX = 1
    COMMAND_BOX = 2
    FIGHT_BOX   = 3
    TARGET_BOX  = 4

    def initialize(sprites,parent,battle)
        @sprites = sprites
        @parent = parent
        @battle = battle
    end

    def pbInitMenuSprites
        @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
        @viewport.z = @parent.z
        @sprites["outerOverlay"] = IconSprite.new(0,0,@viewport)
        @sprites["outerOverlay"].setBitmap("Graphics/Pictures/Battle/outer_overlay")
        # Create message box graphic
        messageBox = pbAddSprite("messageBox",0,576-100,
           "Graphics/Pictures/Battle/overlay_message",@viewport)
        messageBox.z = 195
        # Create message window (displays the message)
        msgWindow = Window_AdvancedTextPokemon.newWithSize("",
           16+128,576-100+2,512-32,96,@viewport)
        msgWindow.z              = 200
        msgWindow.opacity        = 0
        msgWindow.baseColor      = Color.new(248,248,248)
        msgWindow.shadowColor    = Color.new(33,29,29)
        msgWindow.letterbyletter = true
        @sprites["messageWindow"] = msgWindow
        xPos = [148,386,148,386]
        yPos = [482,482,528,528]
        for i in 0...4
            @sprites[_INTL("command_{1}",i)] = OuterCommandSprite.new(xPos[i],yPos[i],@viewport,@sprites["commandWindow"],i)
            @sprites[_INTL("command_{1}",i)].z = 1
        end
        @sprites["moveInfo"] = OuterMoveInfo.new(@viewport,@sprites["fightWindow"])
        @sprites["moveInfo"].z = 1
        # Create targeting window
        @sprites["targetWindow"] = TargetMenuDisplay.new(@viewport,200,@battle.sideSizes)
        @sprites["targetWindow"].z = 1
    end

    def pbAddSprite(id,x,y,filename,viewport)
        sprite = IconSprite.new(x,y,viewport)
        if filename
            sprite.setBitmap(filename) rescue nil
        end
        @sprites[id] = sprite
        return sprite
    end

    def pbInitInfoSprites
        boxCount = 0
        for i in 0...6
            boxCount += 1 if @sprites["dataBox_#{i}"]
        end
        for i in 0...4
            dataBox = @sprites["dataBox_#{i}"]
            if dataBox
                @sprites[_INTL("info_{1}",i)] = OuterDataBox.new(0,0,@viewport,dataBox,i,boxCount)
                @sprites[_INTL("info_{1}",i)].z = 1
            end
        end
    end

    def pbShowWindow(windowType)
        for i in 0...4
            @sprites[_INTL("command_{1}",i)].visible = (windowType==COMMAND_BOX)
        end
        @sprites["moveInfo"].visible = (windowType==FIGHT_BOX)
    end

    def update(cw=nil)
        for i in 0...4
            @sprites[_INTL("command_{1}",i)].update
        end
        for i in 0...4
            @sprites[_INTL("info_{1}",i)].update if @sprites[_INTL("info_{1}",i)]
        end
        @sprites["moveInfo"].update
    end

    def dispose
        @viewport.dispose
    end

end

class OuterMoveBox < IconSprite

    def initialize(viewport,parent,pos)
        @parent = parent
        @pos = pos
        x = 132
        y = 482
        x += 186 if @pos&1==1
        y += 46  if @pos>1
        super(x,y,viewport)
        setBitmap("Graphics/Pictures/Battle/move_buttons")
        self.src_rect = Rect.new(0,0,182,42)
        @overlay = SpriteWrapper.new(viewport)
        @overlay.bitmap = Bitmap.new(self.src_rect.width,self.src_rect.height)
        @overlay.x = self.x
        @overlay.y = self.y
        @overlay.z = self.z + 1
    end

    def refresh(move,selected=false)
        @overlay.bitmap.clear
        if !move
            self.src_rect.x = -182
            self.src_rect.y = -42
            return
        end
        type_id = GameData::Type.get(move.type).id_number
        self.src_rect.x = selected ? 182 : 0
        self.src_rect.y = type_id * 42
        #moveNameBase = PokeBattle_SceneConstants::MESSAGE_BASE_COLOR
        moveNameBase = self.bitmap.get_pixel(2,self.src_rect.y+2)
        moveNameShadow = PokeBattle_SceneConstants::MESSAGE_SHADOW_COLOR
        textPos = [[move.name,92,0,2,moveNameBase,moveNameShadow]]
        pbSetSystemFont(@overlay.bitmap)
        pbDrawTextPositions(@overlay.bitmap,textPos)
    end

    def opacity=(value)
        super(value)
        @overlay.opacity = value
    end

    def color=(value)
        super(value)
        @overlay.color = value
    end

    def visible=(value)
        super(value)
        @overlay.visible = value
    end

    def z=(value)
        super(value)
        @overlay.z = self.z + 1
    end

    def dispose
        @overlay.dispose
        super
    end
end

class OuterMoveInfo < IconSprite

    def initialize(viewport,parent)
        super(502,478,viewport)
        setBitmap("Graphics/Pictures/Battle/outer_move_info")
        @typeBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
        @categoryBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/category"))
        @overlay = SpriteWrapper.new(viewport)
        @overlay.bitmap = Bitmap.new(self.bitmap.width,self.bitmap.height)
        @overlay.x = self.x
        @overlay.y = self.y
        @sprites = []
        for i in 0...4
            sprite = OuterMoveBox.new(viewport,parent,i)
            sprite.z = self.z + 1
            @sprites.push(sprite)
        end
        @overlay.z = self.z + 1
        self.visible = false
        @parent = parent
        refresh
    end

    def refresh
        @overlay.bitmap.clear
        @index = @parent.index
        @battler = @parent.battler
        return if !@battler
        move = @battler.moves[@index]
        return if !move
        base = Color.new(248,248,248)
        shadow = Color.new(80,80,88)
        @overlay.bitmap.blt(64,6,@typeBitmap.bitmap,Rect.new(0,28*GameData::Type.get(move.type).id_number,64,28))
        @overlay.bitmap.blt(64,62,@categoryBitmap.bitmap,Rect.new(0,28*move.category,64,28))
        textPos = []
        powerString = (move.baseDamage <= 0) ? "-" : move.baseDamage.to_s
        textPos.push([powerString,28,6,2,base,shadow])
        accString = (move.accuracy <= 0) ? "-" : (move.accuracy.to_s + "%")
        textPos.push([accString,28,42,2,base,shadow])
        textPos.push([move.pp.to_s,40,64,2,base,shadow])
        pbSetSmallestFont(@overlay.bitmap)
        pbDrawTextPositions(@overlay.bitmap,textPos)
        for i in 0...4
            @sprites[i].refresh(@battler.moves[i],i==@index)
        end
    end

    def opacity=(value)
        super(value)
        @overlay.opacity = value
        for i in 0...4
            @sprites[i].opacity = value
        end
    end

    def color=(value)
        super(value)
        @overlay.color = value
        for i in 0...4
            @sprites[i].color = value
        end
    end

    def visible=(value)
        super(value)
        @overlay.visible = value
        for i in 0...4
            @sprites[i].visible = value
        end
        refresh if value
    end

    def z=(value)
        super(value)
        @overlay.z = value + 1
        for i in 0...4
            @sprites[i].z = value + 1
        end
    end

    def dispose
        @overlay.dispose
        @typeBitmap.dispose
        @categoryBitmap.dispose
        for i in 0...4
            @sprites[i].dispose
        end
        super
    end

    def update
        super
        @overlay.update
        for i in 0...4
            @sprites[i].update
        end
        if @index != @parent.index || @battler != @parent.battler
            refresh
        end
    end

end

class OuterDataBox < RPG::Sprite

    def initialize(x,y,viewport,parent,pos,boxCount)
        super(viewport)
        @frame = 0
        @contents = BitmapWrapper.new(Graphics.width,Graphics.height)
        self.bitmap  = @contents
        pbSetSmallestFont(self.bitmap)
        @parent = parent
        pos = (pos + 2) % 4 if pos % 2 == 0 && boxCount >= 3
        pos = (pos + 2) % 4 if pos % 2 == 1 && boxCount >= 4
        @pos = pos
        @statX = [96,674,96,674][pos]
        @statY = [484,26,26,484][pos]
        @affinityX = (pos % 2 == 1) ? @statX - 2 : @statX - 66
        @affinityY = (pos != 1 && pos != 2) ? @statY - 60 : @statY + 120
        @battler = parent.battler
        @stages = {}
        for i in [:ATTACK,:DEFENSE,:SPECIAL_ATTACK,:SPECIAL_DEFENSE,:SPEED,:ACCURACY,:EVASION]
            @stages[i] = @battler.stages[i]
        end
        @fainted = @battler.fainted?
        @boxVisible = @parent.visible
        @typeBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
        @pkmnSprite = PokemonIconSprite.new(@battler.pokemon,viewport)
        @pkmnSprite.visible = false
        @pkmnX = (pos % 2 == 1) ? @statX - 2 : @statX - 66
        @pkmnY = (pos != 1 && pos != 2) ? @statY - 170 : @statY + 170
        @pkmnSprite.x = @pkmnX
        @pkmnSprite.y = @pkmnY
        refresh
    end

    def opacity=(value)
        super
        @pkmnSprite.opacity = value
    end
    
    def visible=(value)
        super
        @pkmnSprite.visible = visible
    end
    
    def color=(value)
        super
        @pkmnSprite.color = color
    end

    def refresh
        self.bitmap.clear
        @pkmnSprite.visible = @parent.visible
        return if !@parent.visible || !@battler || @battler.fainted?
        colors=[
            Color.new(248,248,248),Color.new(33,29,29),
            Color.new(160,160,168),Color.new(80,80,80),
            Color.new(140,225,140),Color.new(0,150,0),
            Color.new(225,140,140),Color.new(150,0,0)]
        pokemon=@parent.battler
        textPos=[]
        i = 0; j = 0
        statNames = ["ATTACK","DEFENSE","SP.ATK","SP.DEF","SPEED","ACC.","EVASION"]
        for s in [:ATTACK,:DEFENSE,:SPECIAL_ATTACK,:SPECIAL_DEFENSE,:SPEED,:ACCURACY,:EVASION]
            stage=pokemon.stages[s]
            if stage != 0
                c = stage>0 ? [colors[4],colors[5]] : [colors[6],colors[7]]
                stageStr = stage.to_s
                if $PokemonSystem.statstages==2
                    if stage>0
                        stageStr = sprintf("+%d",stage)
                    elsif stage<0
                        stageStr = sprintf("-%d",stage)
                    else
                        stageStr = "-"
                    end
                else
                    base = [:ACCURACY,:EVASION].include?(s) ? 3.0 : 2.0
                    stat=(stage>=0) ? ((base+stage)/base) : (base/(base-stage))
                    if $PokemonSystem.statstages==1
                        stat*=(stat*100).round
                        stageStr = sprintf("%d%%",stat)
                    else
                        if (base==2.0 ? (stage>=-3 && stage!=-1) : (stage%3==0))
                            stageStr = sprintf("%.01fx",stat)
                        else
                            stageStr = sprintf("%.02fx",stat)
                        end
                    end
                end
                statNameX = @statX
                statNameX += (@pos&1 == 1) ? 59 : -61
                textPos.push([stageStr,@statX,@statY-12+18*i,2,c[0],c[1]])
                textPos.push([statNames[j],statNameX,@statY-12+18*i,2,c[0],c[1]])
                i+=1
                break if i > 4
            end
            j+=1
        end
        pbDrawTextPositions(self.bitmap,textPos)
        self.bitmap.blt(@affinityX,@affinityY,@typeBitmap.bitmap,Rect.new(0,28*GameData::Type.get(@battler.pokemon.affinity1).id_number,64,28))
    end

    def dispose
        @pkmnSprite.dispose
        @typeBitmap.dispose
        super
    end

    def update
        super
        @frame = (@frame + 1) % 2
        mustRefresh = false
        if @battler != @parent.battler || @fainted != @battler.fainted? || @boxVisible != @parent.visible
            mustRefresh = true
        elsif 
            for i in [:ATTACK,:DEFENSE,:SPECIAL_ATTACK,:SPECIAL_DEFENSE,:SPEED,:ACCURACY,:EVASION]
                if @stages[i] != @battler.stages[i]
                    mustRefresh = true
                    break
                end
            end
        end
        if mustRefresh
            @battler = @parent.battler
            @pkmnSprite.pokemon = @battler.pokemon
            for i in [:ATTACK,:DEFENSE,:SPECIAL_ATTACK,:SPECIAL_DEFENSE,:SPEED,:ACCURACY,:EVASION]
                @stages[i] = @battler.stages[i]
            end
            @fainted = @battler.fainted?
            @boxVisible = @parent.visible
            refresh
        end
        @pkmnSprite.update if (@parent.selected==1 || @parent.selected==2) && @frame == 0
    end

end

class OuterCommandSprite < IconSprite
  
    def initialize(x,y,viewport=nil,parent,pos)
      super(x,y,viewport)
      @parent  = parent
      @pos = pos
      setBitmap(_INTL("Graphics/Pictures/Battle/options"))
      refresh
    end

    def getRect(i)
        return (@parent.index==@pos) ? Rect.new(234,i*44,234,44) : Rect.new(0,i*44,234,44)
    end
  
    def dispose
        super
    end

    def visible=(value)
        super(value)
        refresh if value
    end
  
    def refresh
        if @parent.mode==1 && @pos==3
            self.src_rect = getRect(5)
        else
            self.src_rect = getRect(@pos)
        end
    end
  
    def update
        super
        refresh
    end
  end