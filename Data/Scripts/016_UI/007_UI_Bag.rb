#===============================================================================
#
#===============================================================================
class Window_PokemonBag < Window_DrawableCommand
  attr_reader :pocket
  attr_accessor :sorting
  attr_reader :inMenu
  attr_reader :adapter

  def initialize(bag,filterlist,pocket,x,y,width,height,mode)
    @bag        = bag
    @filterlist = filterlist
    @pocket     = pocket
    @sorting    = false
    @mode       = mode
    @adapter = PokemonMartAdapter.new
    super(x,y,width,height)
    @selarrow  = @mode==0 ? AnimatedBitmap.new("Graphics/Pictures/Bag/cursor_pocket") : AnimatedBitmap.new("Graphics/Pictures/Bag/cursor")
    @swaparrow = @mode==0 ? AnimatedBitmap.new("Graphics/Pictures/Bag/cursor_swap_pocket") : AnimatedBitmap.new("Graphics/Pictures/Bag/cursor_swap")
    self.windowskin = nil
    @inMenu=true
  end

  def dispose
    @swaparrow.dispose
    super
  end

  def pocket=(value)
    @pocket = value
    thispocket = getPocket
    @item_max = thispocket.length+1
    self.index = @bag.getChoice(@pocket)
  end

  def inMenu=(value)
    @inMenu=value
    refresh
  end

  def page_row_max; return @mode==0 ? 3 : PokemonBag_Scene::ITEMSVISIBLE; end
  def page_item_max; return @mode==0 ? 15 : PokemonBag_Scene::ITEMSVISIBLE; end

  def item
    return nil if @filterlist && !@filterlist[@pocket][self.index]
    thispocket = getPocket
    item = thispocket[self.index]
    return (item) ? item[0] : nil
  end

  def itemCount
    return getPocket.length
  end
  
  def indexItem(index)
    return getPocket[index][0]
  end
  
  def indexQty(index)
    return getPocket[index][1]
  end
  
  def pocketLen
    return getPocket.length
  end

  def getPocket
    if self.pocket == 5
      return @bag.favoritesPocket
    else
      return (@filterlist) ? @filterlist[@pocket] : @bag.pockets[@pocket]
    end
  end

  def itemRect(item)
    if @mode==0
      if item<0 || item>=@item_max || item<self.top_item-1 ||
         item>self.top_item+self.page_item_max
        return Rect.new(0,0,0,0)
      else
        @column_spacing=-14
        @column_max=4
        @row_height=60
        cursor_width = (self.width-self.borderX-(@column_max-1)*@column_spacing) / @column_max
        x = item % @column_max * (cursor_width + @column_spacing)
        y = item / @column_max * @row_height - @virtualOy
        return Rect.new(x, y, cursor_width, @row_height)
      end
    else
      if item<0 || item>=@item_max || item<self.top_item-1 ||
         item>self.top_item+self.page_item_max
        return Rect.new(0,0,0,0)
      else
        cursor_width = (self.width-self.borderX-(@column_max-1)*@column_spacing) / @column_max
        x = item % @column_max * (cursor_width + @column_spacing)
        y = item / @column_max * @row_height - @virtualOy
        return Rect.new(x, y, cursor_width, @row_height)
      end

    end
  end

  def drawCursor(index,rect)
    if self.index==index && !@inMenu
      if @mode==0
        pbCopyBitmap(self.contents,@selarrow.bitmap,rect.x+10,rect.y+10)
      else
        pbCopyBitmap(self.contents,@selarrow.bitmap,rect.x,rect.y+4)
      end
    end
  end

  def drawItem(index,_count,rect)
    textpos = []
    rect = Rect.new(rect.x+16,rect.y+16,rect.width-16,rect.height)
    thispocket = getPocket
    if @mode==0
      imagepos=[]
      ypos=rect.y+4
      if index==pocketLen
        imagepos=[[sprintf("Graphics/Items/back.png"),rect.x,rect.y,0,0,-1,-1]]
        pbDrawImagePositions(self.contents,imagepos)
      else
        item=indexItem(index)
        return if item == 0
        if !GameData::Item.get(item).is_important? # Not a Key item or HM (or infinite TM)
          qty=sprintf("x%d",indexQty(index))
          xQty=rect.x+rect.width-40
          baseColor=(index==@sortIndex) ? Color.new(224,0,0) : Color.new(248,248,248)
          shadowColor=(index==@sortIndex) ? Color.new(248,144,144) : Color.new(40,40,40)
          textpos.push([qty,xQty+23,ypos+22,1,baseColor,shadowColor,1])
        elsif GameData::Item.get(item).is_TM? || GameData::Item.get(item).is_HM? # TM or HM
          name=GameData::Item.get(item).name.gsub("TM","#")
          xQty=rect.x+rect.width-40
          baseColor=(index==@sortIndex) ? Color.new(224,0,0) : Color.new(248,248,248)
          shadowColor=(index==@sortIndex) ? Color.new(248,144,144) : Color.new(40,40,40)
          textpos.push([name,xQty+23,ypos+22,1,baseColor,shadowColor,1])
        end
        imagepos=[[GameData::Item.icon_filename(item),rect.x,rect.y,0,0,-1,-1]]
        pbDrawImagePositions(self.contents,imagepos)
      end
      pbSetSmallFont(self.contents)
      pbDrawTextPositions(self.contents,textpos)
      imagepos=[["Graphics/Pictures/Bag/overlay.png",6,224,0,0,-1,-1]]
      pbDrawImagePositions(self.contents,imagepos)
      pbSetSystemFont(self.contents)
      if index!=pocketLen
        if @bag.pbIsRegistered?(indexItem(index))
          pbDrawImagePositions(self.contents,[
             ["Graphics/Pictures/Bag/icon_register",rect.x+rect.width-54,ypos-10,0,0,-1,-1]
          ])
        end
      end
    else
      if index==self.itemCount-1
        textpos.push([_INTL("CLOSE BAG"),rect.x,rect.y-2,false,self.baseColor,self.shadowColor])
      else
        item = getPocket[index][0]
        baseColor   = self.baseColor
        shadowColor = self.shadowColor
        if @sorting && index==self.index
          baseColor   = Color.new(224,0,0)
          shadowColor = Color.new(248,144,144)
        end
        textpos.push(
          [@adapter.getDisplayName(item),rect.x,rect.y-2,false,baseColor,shadowColor]
        )
        if GameData::Item.get(item).is_important?
          if @bag.pbIsRegistered?(item)
            pbDrawImagePositions(self.contents,[
              ["Graphics/Pictures/Bag/icon_register",rect.x+rect.width-72,rect.y+8,0,0,-1,24]
            ])
          elsif pbCanRegisterItem?(item)
            pbDrawImagePositions(self.contents,[
              ["Graphics/Pictures/Bag/icon_register",rect.x+rect.width-72,rect.y+8,0,24,-1,24]
            ])
          end
        else
          qty = getPocket[index][1]
          qtytext = _ISPRINTF("x{1: 3d}",qty)
          xQty    = rect.x+rect.width-self.contents.text_size(qtytext).width-16
          textpos.push([qtytext,xQty,rect.y-2,false,baseColor,shadowColor])
        end
      end
      pbDrawTextPositions(self.contents,textpos)
    end
  end

  def refresh
    @item_max = itemCount()
    self.update_cursor_rect
    dwidth  = self.width-self.borderX
    dheight = self.height-self.borderY
    self.contents = pbDoEnsureBitmap(self.contents,dwidth,dheight)
    self.contents.clear
    for i in 0...@item_max
      if @mode == 0
        next if i<self.top_item || i>self.top_item+self.page_item_max
      else
        next if i<self.top_item-1 || i>self.top_item+self.page_item_max
      end
      drawItem(i,@item_max,itemRect(i))
    end
    drawCursor(self.index,itemRect(self.index))
  end

  def update
    return if @inMenu
    super
    @uparrow.visible   = false
    @downarrow.visible = false
  end
end

#===============================================================================
# Bag visuals
#===============================================================================
class PokemonBag_Scene
  ITEMLISTBASECOLOR     = Color.new(88,88,80)
  ITEMLISTSHADOWCOLOR   = Color.new(168,184,184)
  ITEMTEXTBASECOLOR     = Color.new(248,248,248)
  ITEMTEXTSHADOWCOLOR   = Color.new(0,0,0)
  POCKETNAMEBASECOLOR   = Color.new(88,88,80)
  POCKETNAMESHADOWCOLOR = Color.new(168,184,184)
  ITEMSVISIBLE          = 7

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(bag,choosing=false,filterproc=nil,resetpocket=true)
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.ox = -128
    @viewport.oy = -96
    @viewport.z = 99999
    @bag        = bag
    @mode       = $PokemonSystem ? $PokemonSystem.bagmode : 0
    @choosing   = choosing
    #@filterproc = filterproc
    pbRefreshFilter
    lastpocket = @bag.lastpocket
    numfilledpockets = @bag.pockets.length-1
    if @choosing
      numfilledpockets = 0
      if @filterlist!=nil
        for i in 1...@bag.pockets.length
          numfilledpockets += 1 if @filterlist[i].length>0
        end
      else
        for i in 1...@bag.pockets.length
          numfilledpockets += 1 if @bag.pockets[i].length>0
        end
      end
      lastpocket = (resetpocket) ? 1 : @bag.lastpocket
      if (@filterlist && @filterlist[lastpocket].length==0) ||
         (!@filterlist && @bag.pockets[lastpocket].length==0)
        for i in 1...@bag.pockets.length
          if @filterlist && @filterlist[i].length>0
            lastpocket = i; break
          elsif !@filterlist && @bag.pockets[i].length>0
            lastpocket = i; break
          end
        end
      end
    end
    @bag.lastpocket = lastpocket
    @sliderbitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Bag/icon_slider"))
    @pocketbitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Bag/icon_pocket"))
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["bagsprite"] = IconSprite.new(30,20,@viewport)
    @sprites["pocketicon"] = BitmapSprite.new(186,32,@viewport)
    @sprites["pocketicon"].x = 0
    @sprites["pocketicon"].y = 224
    @sprites["pocketicon"].visible = false
    @sprites["itemlist"] = Window_PokemonBag.new(@bag,@filterlist,lastpocket,168,-8,314,40+32+ITEMSVISIBLE*32,@mode)
    @sprites["itemlist"].viewport    = @viewport
    @sprites["itemlist"].pocket      = lastpocket
    @sprites["itemlist"].index       = @bag.getChoice(lastpocket)
    @sprites["itemlist"].baseColor   = ITEMLISTBASECOLOR
    @sprites["itemlist"].shadowColor = ITEMLISTSHADOWCOLOR
    #@sprites["itemicon"] = ItemIconSprite.new(48,Graphics.height-48,nil,@viewport)
    #@sprites["itemtext"] = Window_UnformattedTextPokemon.newWithSize("",
    #   72, 270, Graphics.width - 72 - 24, 128, @viewport)
    @sprites["itemicon"] = ItemIconSprite.new(48,384-48,nil,@viewport)
    @sprites["itemtext"] = Window_UnformattedTextPokemon.newWithSize("",
      72, 270, 512 - 72 - 24, 128, @viewport)
    @sprites["itemtext"].baseColor   = ITEMTEXTBASECOLOR
    @sprites["itemtext"].shadowColor = ITEMTEXTSHADOWCOLOR
    @sprites["itemtext"].visible     = true
    @sprites["itemtext"].windowskin  = nil
    @sprites["helpwindow"] = Window_UnformattedTextPokemon.new("")
    @sprites["helpwindow"].visible  = false
    @sprites["helpwindow"].viewport = @viewport
    @sprites["helpwindow"].ox = 128
    @sprites["helpwindow"].oy = 96
    @sprites["msgwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["msgwindow"].visible  = false
    @sprites["msgwindow"].viewport = @viewport
    @sprites["msgwindow"].z = 999999
    @sprites["msgwindow"].ox = 128
    @sprites["msgwindow"].oy = 96
    @sprites["menusel"]=IconSprite.new(14,50,@viewport)
    @sprites["menusel"].setBitmap(sprintf("Graphics/Pictures/Bag/cursor_pocket"))
    if @mode==0
      @sprites["nametext"]=Window_UnformattedTextPokemon.new("")
      @sprites["nametext"].visible=true
      @sprites["nametext"].viewport=@viewport
      @sprites["nametext"].z=100
      @sprites["nametext"].x=190
      @sprites["nametext"].y=220
      @sprites["nametext"].width=300
      @sprites["nametext"].height=128
      @sprites["nametext"].windowskin=nil
      @sprites["nametext"].text=""
    end
    pbUpdateMenuCursor
    pbBottomLeftLines(@sprites["helpwindow"],1)
    pbDeactivateWindows(@sprites)
    pbRefresh
    pbFadeInAndShow(@sprites)
  end
  
  def pbUpdateMenuCursor
    pocket=@sprites["itemlist"].pocket
    @sprites["menusel"].x=14+(50*((pocket-1)%3))
    @sprites["menusel"].y=50+(50*((pocket-1)/3.0).floor)
    @sprites["menusel"].visible=@sprites["itemlist"].inMenu
  end

  def pbFadeOutScene
    @oldsprites = pbFadeOutAndHide(@sprites)
  end

  def pbFadeInScene
    pbFadeInAndShow(@sprites,@oldsprites)
    @oldsprites = nil
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) if !@oldsprites
    @oldsprites = nil
    pbDisposeSpriteHash(@sprites)
    @sliderbitmap.dispose
    @pocketbitmap.dispose
    @viewport.dispose
  end

  def pbDisplay(msg,brief=false)
    UIHelper.pbDisplay(@sprites["msgwindow"],msg,brief) { pbUpdate }
  end

  def pbConfirm(msg)
    UIHelper.pbConfirm(@sprites["msgwindow"],msg) { pbUpdate }
  end

  def pbChooseNumber(helptext,maximum,initnum=1)
    return UIHelper.pbChooseNumber(@sprites["helpwindow"],helptext,maximum,initnum) { pbUpdate }
  end

  def pbShowCommands(helptext,commands,index=0)
    return UIHelper.pbShowCommands(@sprites["helpwindow"],helptext,commands,index) { pbUpdate }
  end

  def pbRefresh
    # Set the background image
    @sprites["background"].setBitmap(sprintf("Graphics/Pictures/Bag/bg_#{@bag.lastpocket}"))
    # Set the bag sprite
    fbagexists = pbResolveBitmap(sprintf("Graphics/Pictures/Bag/bag_#{@bag.lastpocket}_f"))
    # Draw the pocket icons
    @sprites["pocketicon"].bitmap.clear
    if @choosing && @filterlist
      for i in 1...@bag.pockets.length
        if @filterlist[i].length==0
          @sprites["pocketicon"].bitmap.blt(6+(i-1)*22,6,
             @pocketbitmap.bitmap,Rect.new((i-1)*20,28,20,20))
        end
      end
    end
    @sprites["pocketicon"].bitmap.blt(2+(@sprites["itemlist"].pocket-1)*22,2,
       @pocketbitmap.bitmap,Rect.new((@sprites["itemlist"].pocket-1)*28,0,28,28))
    # Refresh the item window
    @sprites["itemlist"].refresh
    # Refresh more things
    pbRefreshIndexChanged
  end

  def pbRefreshIndexChanged
    itemlist = @sprites["itemlist"]
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    # Draw the pocket name
    pbDrawTextPositions(overlay,[
       [PokemonBag.pocketNames[@bag.lastpocket],94,218,2,POCKETNAMEBASECOLOR,POCKETNAMESHADOWCOLOR]
    ])
    # Draw slider arrows
    showslider = false
    if itemlist.top_row>0
      overlay.blt(470,16,@sliderbitmap.bitmap,Rect.new(0,0,36,38))
      showslider = true
    end
    if itemlist.top_item+itemlist.page_item_max<itemlist.itemCount
      overlay.blt(470,228,@sliderbitmap.bitmap,Rect.new(0,38,36,38))
      showslider = true
    end
    # Draw slider box
    if showslider
      sliderheight = 174
      boxheight = (sliderheight*itemlist.page_row_max/itemlist.row_max).floor
      boxheight += [(sliderheight-boxheight)/2,sliderheight/6].min
      boxheight = [boxheight.floor,38].max
      y = 54
      y += ((sliderheight-boxheight)*itemlist.top_row/(itemlist.row_max-itemlist.page_row_max)).floor
      overlay.blt(470,y,@sliderbitmap.bitmap,Rect.new(36,0,36,4))
      i = 0
      while i*16<boxheight-4-18
        height = [boxheight-4-18-i*16,16].min
        overlay.blt(470,y+4+i*16,@sliderbitmap.bitmap,Rect.new(36,4,36,height))
        i += 1
      end
      overlay.blt(470,y+boxheight-18,@sliderbitmap.bitmap,Rect.new(36,20,36,18))
    end
    return if itemlist.item == 0
    # Set the selected item's icon
    @sprites["itemicon"].item = itemlist.item
    # Set the selected item's description
    @sprites["itemtext"].text =
       (itemlist.item) ? GameData::Item.get(itemlist.item).description : _INTL("Close bag.")
    @sprites["nametext"].text = ((itemlist.item) ? GameData::Item.get(itemlist.item).name : "") if @mode==0
  end

  def pbRefreshFilter
    @filterlist = nil
    return if !@choosing
    return if @filterproc==nil
    @filterlist = []
    for i in 1...@bag.pockets.length
      @filterlist[i] = []
      for j in 0...@bag.pockets[i].length
        @filterlist[i].push(j) if @filterproc.call(@bag.pockets[i][j][0])
      end
    end
  end

  # Called when the item screen wants an item to be chosen from the screen
  def pbChooseItem
    @sprites["helpwindow"].visible = false
    itemwindow = @sprites["itemlist"]
    thispocket = itemwindow.getPocket
    swapinitialpos = -1
    pbActivateWindow(@sprites,"itemlist") {
      loop do
        oldindex = itemwindow.index
        Graphics.update
        Input.update
        pbUpdate
        if itemwindow.sorting && itemwindow.index>=thispocket.length
          itemwindow.index = (oldindex==thispocket.length-1) ? 0 : thispocket.length-1
        end
        if itemwindow.index!=oldindex
          # Move the item being switched
          if itemwindow.sorting
            thispocket.insert(itemwindow.index,thispocket.delete_at(oldindex))
          end
          # Update selected item for current pocket
          @bag.setChoice(itemwindow.pocket,itemwindow.index)
          pbRefresh
        end
        if itemwindow.inMenu
          # When choosing pocket
          if Input.trigger?(Input::DOWN)
            itemwindow.pocket=itemwindow.pocket+3 if itemwindow.pocket <= 6
            @bag.lastpocket=itemwindow.pocket
            thispocket = itemwindow.getPocket
            pbRefresh
            pbUpdateMenuCursor
          elsif Input.trigger?(Input::UP)
            itemwindow.pocket=itemwindow.pocket-3 if itemwindow.pocket >= 4
            @bag.lastpocket=itemwindow.pocket
            thispocket = itemwindow.getPocket
            pbRefresh
            pbUpdateMenuCursor
          elsif Input.trigger?(Input::LEFT)
            itemwindow.pocket=itemwindow.pocket-1 if itemwindow.pocket >= 2 && itemwindow.pocket % 3 != 1
            @bag.lastpocket=itemwindow.pocket
            thispocket = itemwindow.getPocket
            pbRefresh
            pbUpdateMenuCursor
          elsif Input.trigger?(Input::RIGHT)
            itemwindow.pocket=itemwindow.pocket+1 if itemwindow.pocket <= 8 && itemwindow.pocket % 3 != 0
            @bag.lastpocket=itemwindow.pocket
            thispocket = itemwindow.getPocket
            pbRefresh
            pbUpdateMenuCursor
          end
          # Confirm selection
          if Input.trigger?(Input::USE)
            itemwindow.inMenu=false
            pbUpdateMenuCursor
          end
          # Cancel switching or cancel the item screen
          if Input.trigger?(Input::B)
            return nil
          end
        elsif itemwindow.sorting
          if Input.trigger?(Input::ACTION) ||
             Input.trigger?(Input::USE)
            itemwindow.sorting = false
            pbPlayDecisionSE
            pbRefresh
          elsif Input.trigger?(Input::BACK)
            thispocket.insert(swapinitialpos,thispocket.delete_at(itemwindow.index))
            itemwindow.index = swapinitialpos
            itemwindow.sorting = false
            pbPlayCancelSE
            pbRefresh
          end
        else
          if Input.trigger?(Input::ACTION)   # Start switching the selected item
            if !@choosing
              if thispocket.length>1 && itemwindow.index<thispocket.length &&
                 !Settings::BAG_POCKET_AUTO_SORT[itemwindow.pocket]
                itemwindow.sorting = true
                swapinitialpos = itemwindow.index
                pbPlayDecisionSE
                pbRefresh
              end
            end
          elsif Input.trigger?(Input::BACK)   # Cancel the item screen
            pbPlayCloseMenuSE
            itemwindow.inMenu = true
          elsif Input.trigger?(Input::USE)   # Choose selected item
            (itemwindow.item) ? pbPlayDecisionSE : pbPlayCloseMenuSE
            return itemwindow.item
          end
        end
      end
    }
  end
end

#===============================================================================
# Bag mechanics
#===============================================================================
class PokemonBagScreen
  def initialize(scene,bag)
    @bag   = bag
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene(@bag)
    item = nil
    loop do
      item = @scene.pbChooseItem
      break if !item
      itm = GameData::Item.get(item)
      cmdRead     = -1
      cmdUse      = -1
      cmdRegister = -1
      cmdGive     = -1
      cmdToss     = -1
      cmdFavorite = -1
      cmdDebug    = -1
      commands = []
      # Generate command list
      commands[cmdRead = commands.length]       = _INTL("Read") if itm.is_mail?
      if ItemHandlers.hasOutHandler(item) || (itm.is_machine? && $Trainer.party.length>0)
        if ItemHandlers.hasUseText(item)
          commands[cmdUse = commands.length]    = ItemHandlers.getUseText(item)
        else
          commands[cmdUse = commands.length]    = _INTL("Use")
        end
      end
      commands[cmdGive = commands.length]       = _INTL("Give") if $Trainer.pokemon_party.length > 0 && itm.can_hold?
      commands[cmdToss = commands.length]       = _INTL("Toss") if !itm.is_important? || $DEBUG
      if @bag.pbIsRegistered?(item)
        commands[cmdRegister = commands.length] = _INTL("Deselect")
      elsif pbCanRegisterItem?(item)
        commands[cmdRegister = commands.length] = _INTL("Register")
      end
      if @bag.favorites.include?(item)
        commands[cmdFavorite = commands.length] = _INTL("Unfavorite")
      else
        commands[cmdFavorite = commands.length] = _INTL("Favorite")
      end
      commands[cmdDebug = commands.length]      = _INTL("Debug") if $DEBUG
      commands[commands.length]                 = _INTL("Cancel")
      # Show commands generated above
      itemname = itm.name
      command = @scene.pbShowCommands(_INTL("{1} is selected.",itemname),commands)
      if cmdRead>=0 && command==cmdRead   # Read mail
        pbFadeOutIn {
          pbDisplayMail(Mail.new(item, "", ""))
        }
      elsif cmdUse>=0 && command==cmdUse   # Use item
        ret = pbUseItem(@bag,item,@scene)
        # ret: 0=Item wasn't used; 1=Item used; 2=Close Bag to use in field
        break if ret==2   # End screen
        @scene.pbRefresh
        next
      elsif cmdGive>=0 && command==cmdGive   # Give item to Pokémon
        if $Trainer.pokemon_count == 0
          @scene.pbDisplay(_INTL("There is no Pokémon."))
        elsif itm.is_important?
          @scene.pbDisplay(_INTL("The {1} can't be held.",itemname))
        else
          pbFadeOutIn {
            sscene = PokemonParty_Scene.new
            sscreen = PokemonPartyScreen.new(sscene,$Trainer.party)
            sscreen.pbPokemonGiveScreen(item)
            @scene.pbRefresh
          }
        end
      elsif cmdToss>=0 && command==cmdToss   # Toss item
        qty = @bag.pbQuantity(item)
        if qty>1
          helptext = _INTL("Toss out how many {1}?",itm.name_plural)
          qty = @scene.pbChooseNumber(helptext,qty)
        end
        if qty>0
          itemname = itm.name_plural if qty>1
          if pbConfirm(_INTL("Is it OK to throw away {1} {2}?",qty,itemname))
            pbDisplay(_INTL("Threw away {1} {2}.",qty,itemname))
            qty.times { @bag.pbDeleteItem(item) }
            @scene.pbRefresh
          end
        end
      elsif cmdRegister>=0 && command==cmdRegister   # Register item
        if @bag.pbIsRegistered?(item)
          @bag.pbUnregisterItem(item)
        else
          @bag.pbRegisterItem(item)
        end
        @scene.pbRefresh
      elsif cmdFavorite>=0 && command==cmdFavorite
        if @bag.favorites.include?(item)
          @bag.removeFavorite(item)
        else
          @bag.addFavorite(item)
        end
      elsif cmdDebug>=0 && command==cmdDebug   # Debug
        command = 0
        loop do
          command = @scene.pbShowCommands(_INTL("Do what with {1}?",itemname),[
            _INTL("Change quantity"),
            _INTL("Make Mystery Gift"),
            _INTL("Cancel")
            ],command)
          case command
          ### Cancel ###
          when -1, 2
            break
          ### Change quantity ###
          when 0
            qty = @bag.pbQuantity(item)
            itemplural = itm.name_plural
            params = ChooseNumberParams.new
            params.setRange(0, Settings::BAG_MAX_PER_SLOT)
            params.setDefaultValue(qty)
            newqty = pbMessageChooseNumber(
               _INTL("Choose new quantity of {1} (max. #{Settings::BAG_MAX_PER_SLOT}).",itemplural),params) { @scene.pbUpdate }
            if newqty>qty
              @bag.pbStoreItem(item,newqty-qty)
            elsif newqty<qty
              @bag.pbDeleteItem(item,qty-newqty)
            end
            @scene.pbRefresh
            break if newqty==0
          ### Make Mystery Gift ###
          when 1
            pbCreateMysteryGift(1,item)
          end
        end
      end
    end
    @scene.pbEndScene
    return item
  end

  def pbDisplay(text)
    @scene.pbDisplay(text)
  end

  def pbConfirm(text)
    return @scene.pbConfirm(text)
  end

  # UI logic for the item screen for choosing an item.
  def pbChooseItemScreen(proc=nil)
    oldlastpocket = @bag.lastpocket
    oldchoices = @bag.getAllChoices
    @scene.pbStartScene(@bag,true,proc)
    item = @scene.pbChooseItem
    @scene.pbEndScene
    @bag.lastpocket = oldlastpocket
    @bag.setAllChoices(oldchoices)
    return item
  end

  # UI logic for withdrawing an item in the item storage screen.
  def pbWithdrawItemScreen
    if !$PokemonGlobal.pcItemStorage
      $PokemonGlobal.pcItemStorage = PCItemStorage.new
    end
    storage = $PokemonGlobal.pcItemStorage
    @scene.pbStartScene(storage)
    loop do
      item = @scene.pbChooseItem
      break if !item
      itm = GameData::Item.get(item)
      qty = storage.pbQuantity(item)
      if qty>1 && !itm.is_important?
        qty = @scene.pbChooseNumber(_INTL("How many do you want to withdraw?"),qty)
      end
      next if qty<=0
      if @bag.pbCanStore?(item,qty)
        if !storage.pbDeleteItem(item,qty)
          raise "Can't delete items from storage"
        end
        if !@bag.pbStoreItem(item,qty)
          raise "Can't withdraw items from storage"
        end
        @scene.pbRefresh
        dispqty = (itm.is_important?) ? 1 : qty
        itemname = (dispqty>1) ? itm.name_plural : itm.name
        pbDisplay(_INTL("Withdrew {1} {2}.",dispqty,itemname))
      else
        pbDisplay(_INTL("There's no more room in the Bag."))
      end
    end
    @scene.pbEndScene
  end

  # UI logic for depositing an item in the item storage screen.
  def pbDepositItemScreen
    @scene.pbStartScene(@bag)
    if !$PokemonGlobal.pcItemStorage
      $PokemonGlobal.pcItemStorage = PCItemStorage.new
    end
    storage = $PokemonGlobal.pcItemStorage
    loop do
      item = @scene.pbChooseItem
      break if !item
      itm = GameData::Item.get(item)
      qty = @bag.pbQuantity(item)
      if qty>1 && !itm.is_important?
        qty = @scene.pbChooseNumber(_INTL("How many do you want to deposit?"),qty)
      end
      if qty>0
        if !storage.pbCanStore?(item,qty)
          pbDisplay(_INTL("There's no room to store items."))
        else
          if !@bag.pbDeleteItem(item,qty)
            raise "Can't delete items from Bag"
          end
          if !storage.pbStoreItem(item,qty)
            raise "Can't deposit items to storage"
          end
          @scene.pbRefresh
          dispqty  = (itm.is_important?) ? 1 : qty
          itemname = (dispqty>1) ? itm.name_plural : itm.name
          pbDisplay(_INTL("Deposited {1} {2}.",dispqty,itemname))
        end
      end
    end
    @scene.pbEndScene
  end

  # UI logic for tossing an item in the item storage screen.
  def pbTossItemScreen
    if !$PokemonGlobal.pcItemStorage
      $PokemonGlobal.pcItemStorage = PCItemStorage.new
    end
    storage = $PokemonGlobal.pcItemStorage
    @scene.pbStartScene(storage)
    loop do
      item = @scene.pbChooseItem
      break if !item
      itm = GameData::Item.get(item)
      if itm.is_important?
        @scene.pbDisplay(_INTL("That's too important to toss out!"))
        next
      end
      qty = storage.pbQuantity(item)
      itemname       = itm.name
      itemnameplural = itm.name_plural
      if qty>1
        qty=@scene.pbChooseNumber(_INTL("Toss out how many {1}?",itemnameplural),qty)
      end
      if qty>0
        itemname = itemnameplural if qty>1
        if pbConfirm(_INTL("Is it OK to throw away {1} {2}?",qty,itemname))
          if !storage.pbDeleteItem(item,qty)
            raise "Can't delete items from storage"
          end
          @scene.pbRefresh
          pbDisplay(_INTL("Threw away {1} {2}.",qty,itemname))
        end
      end
    end
    @scene.pbEndScene
  end
end
