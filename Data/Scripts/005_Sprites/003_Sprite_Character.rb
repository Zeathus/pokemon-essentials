class BushBitmap
  def initialize(bitmap, isTile, depth)
    @bitmaps  = []
    @bitmap   = bitmap
    @isTile   = isTile
    @isBitmap = @bitmap.is_a?(Bitmap)
    @depth    = depth
  end

  def dispose
    @bitmaps.each { |b| b.dispose if b }
  end

  def bitmap
    thisBitmap = (@isBitmap) ? @bitmap : @bitmap.bitmap
    current = (@isBitmap) ? 0 : @bitmap.currentIndex
    if !@bitmaps[current]
      if @isTile
        @bitmaps[current] = pbBushDepthTile(thisBitmap, @depth)
      else
        @bitmaps[current] = pbBushDepthBitmap(thisBitmap, @depth)
      end
    end
    return @bitmaps[current]
  end

  def pbBushDepthBitmap(bitmap, depth)
    ret = Bitmap.new(bitmap.width, bitmap.height)
    charheight = ret.height / 4
    cy = charheight - depth - 2
    for i in 0...4
      y = i * charheight
      if cy >= 0
        ret.blt(0, y, bitmap, Rect.new(0, y, ret.width, cy))
        ret.blt(0, y + cy, bitmap, Rect.new(0, y + cy, ret.width, 2), 170)
      end
      ret.blt(0, y + cy + 2, bitmap, Rect.new(0, y + cy + 2, ret.width, 2), 85) if cy + 2 >= 0
    end
    return ret
  end

  def pbBushDepthTile(bitmap, depth)
    ret = Bitmap.new(bitmap.width, bitmap.height)
    charheight = ret.height
    cy = charheight - depth - 2
    y = charheight
    if cy >= 0
      ret.blt(0, y, bitmap, Rect.new(0, y, ret.width, cy))
      ret.blt(0, y + cy, bitmap, Rect.new(0, y + cy, ret.width, 2), 170)
    end
    ret.blt(0, y + cy + 2, bitmap, Rect.new(0, y + cy + 2, ret.width, 2), 85) if cy + 2 >= 0
    return ret
  end
end



class Sprite_Character < RPG::Sprite
  attr_accessor :character

  def initialize(viewport, character = nil)
    super(viewport)
    @character    = character
    @partner      = nil
    @isPartner    = @character.is_a?(String)
    @oldbushdepth = 0
    @spriteoffset = false
    if !character || character == $game_player || (!@isPartner && character.name[/reflection/i] rescue false)
      @reflection = Sprite_Reflection.new(self, character, viewport)
    end
    if !@isPartner
      @dropshadow = DropShadowSprite.new(self, character, viewport)
    end
    #@surfbase = Sprite_SurfBase.new(self, character, viewport) if character == $game_player
    if !@isPartner
      update
    else
      @real_x = 0
      @real_y = 0
      @direction = 0
      @visibility = true
    end
  end
  
  def initPartner
    if @partner
      @partner.dispose
    end
    @partner = Sprite_Character.new(
      self.viewport, _INTL("member{1}",
        $game_variables ? getPartyActive(1) : ""))
    @partner.setRealXY(@character.real_x, @character.real_y)
  end
  
  def partner
    return @partner
  end
  
  def visibility=(value)
    @visibility = value
  end
  
  def setRealXY(val_x,val_y)
    @real_x = val_x
    @real_y = val_y
  end

  def groundY
    return @character.screen_y_ground
  end

  def visible=(value)
    super(value)
    @reflection.visible = value if @reflection
  end

  def dispose
    @bushbitmap.dispose if @bushbitmap
    @bushbitmap = nil
    @charbitmap.dispose if @charbitmap
    @charbitmap = nil
    @reflection.dispose if @reflection
    @reflection = nil
    @surfbase.dispose if @surfbase
    @surfbase = nil
    @dropshadow.dispose if @dropshadow
    @dropshadow = nil
    if @partner
      @partner.dispose
      @partner = nil
    end
    super
  end

  def update
    return if @character.is_a?(Game_Event) && !@character.should_update?
    super
    if @tile_id != @character.tile_id ||
       @character_name != @character.character_name ||
       @character_hue != @character.character_hue ||
       @oldbushdepth != @character.bush_depth
      @tile_id        = @character.tile_id
      @character_name = @character.character_name
      @character_hue  = @character.character_hue
      @oldbushdepth   = @character.bush_depth
      if @tile_id >= 384
        @charbitmap.dispose if @charbitmap
        @charbitmap = pbGetTileBitmap(@character.map.tileset_name, @tile_id,
                                      @character_hue, @character.width, @character.height)
        @charbitmapAnimated = false
        @bushbitmap.dispose if @bushbitmap
        @bushbitmap = nil
        @spriteoffset = false
        @cw = Game_Map::TILE_WIDTH * @character.width
        @ch = Game_Map::TILE_HEIGHT * @character.height
        self.src_rect.set(0, 0, @cw, @ch)
        self.ox = @cw / 2
        self.oy = @ch
        @character.sprite_size = [@cw, @ch]
      else
        @charbitmap.dispose if @charbitmap
        @charbitmap = AnimatedBitmap.new(
           'Graphics/Characters/' + @character_name, @character_hue)
        RPG::Cache.retain('Graphics/Characters/', @character_name, @character_hue) if @character == $game_player
        @charbitmapAnimated = true
        @bushbitmap.dispose if @bushbitmap
        @bushbitmap = nil
        @spriteoffset = @character_name[/offset/i]
        @cw = @charbitmap.width / 4
        @ch = @charbitmap.height / 4
        self.ox = @cw / 2
        @character.sprite_size = [@cw, @ch]
      end
    end
    @charbitmap.update if @charbitmapAnimated
    bushdepth = @character.bush_depth
    if bushdepth == 0
      self.bitmap = (@charbitmapAnimated) ? @charbitmap.bitmap : @charbitmap
    else
      @bushbitmap = BushBitmap.new(@charbitmap, (@tile_id >= 384), bushdepth) if !@bushbitmap
      self.bitmap = @bushbitmap.bitmap
    end
    self.visible = !@character.transparent
    if @tile_id == 0
      sx = @character.pattern * @cw
      sy = ((@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
      self.oy = (@spriteoffset rescue false) ? @ch - 16 : @ch
      self.oy -= @character.bob_height
    end
    if self.visible
      if @character.is_a?(Game_Event) && @character.name[/regulartone/i]
        self.tone.set(0, 0, 0, 0)
      else
        pbDayNightTint(self)
      end
    end
    self.x          = @character.screen_x
    self.y          = @character.screen_y
    self.z          = @character.screen_z(@ch)
#    self.zoom_x     = Game_Map::TILE_WIDTH / 32.0
#    self.zoom_y     = Game_Map::TILE_HEIGHT / 32.0
    self.opacity    = @character.opacity
    self.blend_type = @character.blend_type
#    self.bush_depth = @character.bush_depth
    if @character.animation_id != 0
      animation = $data_animations[@character.animation_id]
      animation(animation, true)
      @character.animation_id = 0
    end
    @reflection.update if @reflection
    @dropshadow.update if @dropshadow
    @surfbase.update if @surfbase
    if @partner
      @partner.updatePartner(self, sx, sy, @character_name[/run/])
    end
  end

  def updatePartner(owner, sx, sy, run)
    RPG::Sprite.instance_method(:update).bind(self).call
    fullcharactername = _INTL("{1}_{2}", @character, (run ? "run" : "walk"))
    if @charactername != fullcharactername
      @charactername = fullcharactername
      @charbitmap.dispose if @charbitmap
      @charbitmap = AnimatedBitmap.new("Graphics/Characters/"+fullcharactername,
                                  owner.character.character_hue)
      @charbitmapAnimated=true
      @bushbitmap.dispose if @bushbitmap
      @bushbitmap=nil
      @cw = @charbitmap.width / 4
      @ch = @charbitmap.height / 4
      self.ox = @cw / 2
      self.oy = @ch
    end
    @charbitmap.update if @charbitmapAnimated
    self.bitmap = @charbitmap.bitmap
    self.visible = owner.visible
    self.visible = false if !@visibility || $PokemonGlobal.surfing
    self.z = owner.z
    
    owner_direction = [0, 2, 4, 6][sy / @ch]
    
    dif_x = @real_x - owner.character.real_x
    dif_y = @real_y - owner.character.real_y
    
    distance = Game_Map::TILE_WIDTH * 4
    speed = owner.character.move_speed_real
    
    if (dif_x != 0 && dif_y != 0) ||
        dif_x.abs > distance || dif_y.abs > distance
      goal_x = owner.character.real_x
      goal_y = owner.character.real_y
      if owner_direction == 2
        goal_x += distance
      elsif owner_direction == 4
        goal_x -= distance
      end
      if owner_direction == 0
        goal_y -= distance
      elsif owner_direction == 6
        goal_y += distance
      end
      
      dif_x = @real_x - goal_x
      dif_y = @real_y - goal_y
      
      if dif_x.abs > 0
        if dif_x > 0
          @real_x -= speed
          @real_x = goal_x if @real_x < goal_x
        else
          @real_x += speed
          @real_x = goal_x if @real_x > goal_x
        end
      end
      if dif_y.abs > 0
        if dif_y > 0
          @real_y -= speed
          @real_y = goal_y if @real_y < goal_y
        else
          @real_y += speed
          @real_y = goal_y if @real_y > goal_y
        end
      end
      
      if dif_y.abs > dif_x.abs
        @direction = (dif_y > 0) ? 6 : 0
      elsif dif_x.abs > dif_y.abs
        @direction = (dif_x > 0) ? 2 : 4
      end
    else
      sx = 0
      if dif_y.abs > dif_x.abs
        @direction = (dif_y > 0) ? 6 : 0
      elsif dif_x.abs > dif_y.abs
        @direction = (dif_x > 0) ? 2 : 4
      end
    end
    
    self.x = screen_x(@real_x)
    self.y = screen_y(@real_y)
    self.src_rect.set(sx, @direction * @ch / 2, @cw, @ch)
    
    if (@real_y - owner.character.real_y) < 4
      self.z = owner.z - 1
    end
    
    self.zoom_x = owner.zoom_x
    self.zoom_y = owner.zoom_y
    self.opacity = owner.opacity
    self.blend_type = owner.blend_type
    self.angle = owner.angle
  end
  
  def screen_x(real_x)
    return (real_x - $game_map.display_x + 3) / 4 + (Game_Map::TILE_WIDTH/2)
  end

  def screen_y(real_y)
    y = (real_y - $game_map.display_y + 3) / 4 + (Game_Map::TILE_HEIGHT)
    #if PBTerrain.isSwamp?(self.terrain_tag)
    #  y += 6
    #end
    #if jumping?
    #  n = (@jump_count - @jump_peak).abs
    #  return y - (@jump_peak * @jump_peak - n * n) / 2
    #end
    return y
  end
end
