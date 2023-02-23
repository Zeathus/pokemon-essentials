class CriticalSprite < SpriteWrapper

  attr_accessor :type
  attr_accessor :frame
  attr_accessor :opponent

  def initialize(user, viewport)
    super(viewport)
    @simple = user.is_a?(Numeric)
    @type = @simple ? 1 : user.types[0]
    @opponent = @simple ? true : ((user.index % 2) == 1)
    @src_bitmap = RPG::Cache.load_bitmap("",
      _INTL("Graphics/Pictures/Battle/critical_{1}",type.to_s))
    self.bitmap = Bitmap.new(1024,128)
    self.x = 128
    self.y = 128
    @frame = 0
    update
  end

  def update
    @frame += 1
    if frame <= 4
      self.bitmap.clear
      self.bitmap.stretch_blt(
        Rect.new(0, 64-(frame*16), 512, frame*32),
        @src_bitmap,Rect.new(0, 0, 512, 128))
      self.bitmap.blt(512, 0,
        self.bitmap, Rect.new(0, 0, 512, 128))
    end
    if frame > 56 && frame <= 60
      self.bitmap.clear
      self.bitmap.stretch_blt(
        Rect.new(0, ((frame-56)*16), 512, 128-((frame-56)*32)),
        @src_bitmap,Rect.new(0, 0, 512, 128))
      self.bitmap.blt(512, 0,
        self.bitmap, Rect.new(0, 0, 512, 128))
    end
    if @opponent
      self.x -= 48
      self.x = 128 if self.x <= -512 + 128
    else
      self.x += 48
      self.x = -512 + 128 if self.x >= 128
    end
  end

  def refresh
  end

  def dispose
    @src_bitmap.dispose
    super
  end

end

class CriticalSpritePokemon < SpriteWrapper

  attr_accessor :species
  attr_accessor :frame
  attr_accessor :opponent
  attr_accessor :xframes

  def initialize(user, viewport)
    super(viewport)
    @simple = user.is_a?(Numeric)
    @species = @simple ? user : user.species
    @opponent = @simple ? true : ((user.index % 2) == 1)
    @src_bitmap = @simple ? GameData::Species.front_sprite_bitmap(@species) : GameData::Species.front_sprite_bitmap(@species,user.form,user.gender,user.shiny?)
    self.bitmap = Bitmap.new(192,128)
    if @src_bitmap.height < 128
      self.bitmap.blt(0, 64-(@src_bitmap.bitmap.height/2), @src_bitmap.bitmap,
        Rect.new(0, 0,
        @src_bitmap.bitmap.width,@src_bitmap.bitmap.height))
    else
      self.bitmap.blt(0, 0, @src_bitmap.bitmap,
        Rect.new(0,@species==:HOOH ? 40 : 0,
        @src_bitmap.bitmap.width,128))
    end
    self.x = @opponent ? 512 : -192
    self.y = 128
    self.mirror = !@opponent
    @xframes = [24,24,24,24,24,24,
                18,12, 6, 2, 0, 0,
                -2,-2,-2,-2,-2,-2,
                -2,-2,-2,-2,-2,-2,
                -2,-2,-2,-2,-2,-2,
                 4, 6, 8,12,18,26,
                38,46,54,64,64,64,
                64,64,64,64,64,64,
                64,64]
    @frame = 0
    update
  end

  def update
    @frame += 1
    if frame >= 4 && @xframes[frame-4]
      if @opponent
        self.x -= @xframes[frame-4]
      else
        self.x += @xframes[frame-4]
      end
      if frame == 20
        GameData::Species.play_cry(@species, 100)
      end
    end
  end

  def refresh
  end

  def dispose
    @src_bitmap.dispose
    super
  end

end

class Battle::Scene

  def pbCriticalAnimation(user)
    @sprites["crit_bar"]=CriticalSprite.new(user, @viewport)
    @sprites["crit_bar"].z = 200
    @sprites["crit_pkmn"]=CriticalSpritePokemon.new(user, @viewport)
    @sprites["crit_pkmn"].z = 201

    pbSEPlay("Thunder3")
    60.times do
      Graphics.update
      @viewport.update
      Input.update
      @sprites["crit_bar"].update
      @sprites["crit_pkmn"].update
      pbWait(1)
    end

    @sprites["crit_bar"].dispose
    @sprites["crit_pkmn"].dispose
    @sprites["crit_bar"] = nil
    @sprites["crit_pkmn"] = nil
  end

end 