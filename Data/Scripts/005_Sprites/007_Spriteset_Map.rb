class ClippableSprite < Sprite_Character
  def initialize(viewport,event,tilemap)
    @tilemap = tilemap
    @_src_rect = Rect.new(0,0,0,0)
    super(viewport,event)
  end

  def update
    super
    @_src_rect = self.src_rect
    tmright = @tilemap.map_data.xsize*Game_Map::TILE_WIDTH-@tilemap.ox
    echoln("x=#{self.x},ox=#{self.ox},tmright=#{tmright},tmox=#{@tilemap.ox}")
    if @tilemap.ox-self.ox<-self.x
      # clipped on left
      diff = -self.x-@tilemap.ox+self.ox
      self.src_rect = Rect.new(@_src_rect.x+diff,@_src_rect.y,
                               @_src_rect.width-diff,@_src_rect.height)
      echoln("clipped out left: #{diff} #{@tilemap.ox-self.ox} #{self.x}")
    elsif tmright-self.ox<self.x
      # clipped on right
      diff = self.x-tmright+self.ox
      self.src_rect = Rect.new(@_src_rect.x,@_src_rect.y,
                               @_src_rect.width-diff,@_src_rect.height)
      echoln("clipped out right: #{diff} #{tmright+self.ox} #{self.x}")
    else
      echoln("-not- clipped out left: #{diff} #{@tilemap.ox-self.ox} #{self.x}")
    end
  end
end

class DropShadowSprite
  attr_accessor :visible
  attr_accessor :character

  def initialize(sprite, event, viewport=nil)
    @rsprite  = sprite
    @sprite   = nil
    @event    = event
    @disposed = false
    @viewport = viewport
    update
  end

  def dispose
    if !@disposed
      @sprite.dispose if @sprite
      @sprite=nil
      @disposed=true
    end
  end

  def disposed?
    @disposed
  end

  def update(tilemap=nil)
    return if disposed?
    if @event && @event!=$game_player
      if (@event.character_name[/trainer/] || @event.character_name[/NPC/] ||
          @event.character_name[/pkmn/]) && !@event.character_name[/member/]
        # Just-in-time creation of sprite
        if !@sprite
          @sprite=Sprite.new(@viewport)
          @sprite.bitmap=Bitmap.new(32,16)
          # True to BW
          #@sprite.bitmap.fill_rect(4,0,24,14,Color.new(0,0,0))
          #@sprite.bitmap.fill_rect(2,2,28,10,Color.new(0,0,0))
          #@sprite.bitmap.fill_rect(0,4,32,6,Color.new(0,0,0))
          #@sprite.bitmap.fill_rect(8,14,16,2,Color.new(0,0,0))
          # To prevent drop shadow clipping
          @sprite.bitmap.fill_rect(4,2,24,10,Color.new(0,0,0))
          @sprite.bitmap.fill_rect(2,4,28,8,Color.new(0,0,0))
          @sprite.bitmap.fill_rect(0,6,32,4,Color.new(0,0,0))
          @sprite.bitmap.fill_rect(6,12,20,2,Color.new(0,0,0))
        end
        if @sprite
          @sprite.visible=@rsprite.visible
          if @sprite.visible
            @sprite.x = @rsprite.x - 16
            @sprite.y = @rsprite.y - 14
            @sprite.z = @rsprite.z - 1 # below the character
            @sprite.opacity=(@rsprite.opacity*100.0)/255.0
          end
        end
      else
        if @sprite
          @sprite.dispose
          @sprite=nil
        end
      end
    end
  end
end



class Spriteset_Map
  attr_reader :map
  attr_accessor :tilemap
  @@viewport0 = Viewport.new(0, 0, Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)   # Panorama
  @@viewport0.z = -100
  @@viewport1 = Viewport.new(0, 0, Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)   # Map, events, player, fog
  @@viewport1.z = 0
  @@viewport1b= Viewport.new(0, 0, Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT) # Visual Effects
  @@viewport1b.z= 101
  @@viewport3 = Viewport.new(0, 0, Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)   # Flashing
  @@viewport3.z = 500

  def Spriteset_Map.viewport   # For access by Spriteset_Global
    return @@viewport1
  end

  def initialize(map=nil)
    @map = (map) ? map : $game_map
    @tilemap = TilemapLoader.new(@@viewport1)
    @tilemap.tileset = pbGetTileset(@map.tileset_name)
    for i in 0...7
      autotile_name = @map.autotile_names[i]
      @tilemap.autotiles[i] = pbGetAutotile(autotile_name)
    end
    @tilemap.map_data = @map.data
    @tilemap.priorities = @map.priorities
    @tilemap.terrain_tags = @map.terrain_tags
    @panorama = AnimatedPlane.new(@@viewport0)
    @fog = AnimatedPlane.new(@@viewport1)
    @fog.z = 3000
    @character_sprites = []
    for i in @map.events.keys.sort
      sprite = Sprite_Character.new(@@viewport1,@map.events[i])
      @character_sprites.push(sprite)
    end
    @wild_battle_pending = false
    @in_wild_battle = false
    @spawn_areas = []
    initSpawnAreas
    @weather = RPG::Weather.new(@@viewport1)
    @vfx = RPG::VFX.new(@viewport1b)
    pbOnSpritesetCreate(self,@@viewport1)
    update
  end

  def dispose
    @tilemap.tileset.dispose
    for i in 0...7
      @tilemap.autotiles[i].dispose
    end
    @tilemap.dispose
    @panorama.dispose
    @fog.dispose
    for sprite in @character_sprites
      sprite.dispose
    end
    @weather.dispose
    @vfx.dispose
    @tilemap = nil
    @panorama = nil
    @fog = nil
    @character_sprites.clear
    @weather = nil
  end

  def getAnimations
    return @usersprites
  end

  def restoreAnimations(anims)
    @usersprites = anims
  end

  def update
    if @panorama_name!=@map.panorama_name || @panorama_hue!=@map.panorama_hue
      @panorama_name = @map.panorama_name
      @panorama_hue  = @map.panorama_hue
      @panorama.setPanorama(nil) if @panorama.bitmap!=nil
      @panorama.setPanorama(@panorama_name,@panorama_hue) if @panorama_name!=""
      Graphics.frame_reset
    end
    if @fog_name!=@map.fog_name || @fog_hue!=@map.fog_hue
      @fog_name = @map.fog_name
      @fog_hue = @map.fog_hue
      @fog.setFog(nil) if @fog.bitmap!=nil
      @fog.setFog(@fog_name,@fog_hue) if @fog_name!=""
      Graphics.frame_reset
    end
    tmox = (@map.display_x/Game_Map::X_SUBPIXELS).round
    tmoy = (@map.display_y/Game_Map::Y_SUBPIXELS).round
    @tilemap.ox = tmox
    @tilemap.oy = tmoy
    @@viewport1.rect.set(0,0,Graphics.width,Graphics.height)
    @@viewport1.ox = 0
    @@viewport1.oy = 0
    @@viewport1.ox += $game_screen.shake
    @tilemap.update
    @panorama.ox = tmox/2
    @panorama.oy = tmoy/2
    @fog.ox         = tmox+@map.fog_ox
    @fog.oy         = tmoy+@map.fog_oy
    @fog.zoom_x     = @map.fog_zoom/100.0
    @fog.zoom_y     = @map.fog_zoom/100.0
    @fog.opacity    = @map.fog_opacity
    @fog.blend_type = @map.fog_blend_type
    @fog.tone       = @map.fog_tone
    @panorama.update
    @fog.update
    for sprite in @character_sprites
      sprite.update
    end
    if self.map!=$game_map
      @weather.fade_in(:None, 0, 20)
      @vfx.type = 0
    else
      @weather.fade_in($game_screen.weather_type, $game_screen.weather_max, $game_screen.weather_duration)
      @vfx.type = $game_screen.vfx_type
    end
    @weather.ox   = tmox
    @weather.oy   = tmoy
    @weather.update
    @vfx.update
    @@viewport1.tone = $game_screen.tone
    @@viewport3.color = $game_screen.flash_color
    @@viewport1.update
    @@viewport1b.update
    @@viewport3.update
    updateOverworldPokemon
  end
end
