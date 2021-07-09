class CriticalSprite < SpriteWrapper
  
  attr_accessor :type
  attr_accessor :frame
  attr_accessor :opponent
  
  def initialize(user, viewport)
    super(viewport)
    @simple = user.is_a?(Numeric)
    @type = @simple ? 1 : user.type1
    @opponent = @simple ? true : ((user.index % 2) == 1)
    @src_bitmap = RPG::Cache.load_bitmap("",
      _INTL("Graphics/Pictures/Battle/critical_{1}",type.to_s))
    self.bitmap = Bitmap.new(1024,128)
    self.x = 0
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
    if frame > 36 && frame <= 40
      self.bitmap.clear
      self.bitmap.stretch_blt(
        Rect.new(0, ((frame-36)*16), 512, 128-((frame-36)*32)),
        @src_bitmap,Rect.new(0, 0, 512, 128))
      self.bitmap.blt(512, 0,
        self.bitmap, Rect.new(0, 0, 512, 128))
    end
    if @opponent
      self.x -= 64
      self.x = 0 if self.x <= -512
    else
      self.x += 64
      self.x = -512 if self.x >= 0
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
    @src_bitmap = @simple ? pbLoadSpeciesBitmap(species).bitmap : pbLoadPokemonStaticBitmap(user.pokemon)
    self.bitmap = Bitmap.new(192,128)
    if @src_bitmap.height < 128
      self.bitmap.blt(0, 64-(@src_bitmap.height/2), @src_bitmap,
        Rect.new(0, 0,
        @src_bitmap.width,@src_bitmap.height))
    else
      self.bitmap.blt(0, 0, @src_bitmap,
        Rect.new(0,@species==:HOOH ? 40 : 0,
        @src_bitmap.width,128))
    end
    self.x = @opponent ? 512 : -192
    self.y = 128
    self.mirror = !@opponent
    @xframes = [32,32,32,28,22,12,6,4,0,-2,-2,-2,-2,-2,
                -2,-2,-2,-2,-2,-2,6,12,20,
                30,42,56,64,64,64,64,64,64,64,64]
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
      if frame == 14
        pbPlayCry(@species)
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

def pbCriticalAnimation(user, force=false)
  
  return if !force && $PokemonSystem.critanim && $PokemonSystem.critanim==1
  
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 999999
  
  sprites = {}
  
  sprites["bar"]=CriticalSprite.new(user, viewport)
  sprites["bar"].z = 1
  sprites["pokemon"]=CriticalSpritePokemon.new(user, viewport)
  sprites["pokemon"].z = 2
  
  pbSEPlay("Thunder3")
  40.times do
    Graphics.update
    viewport.update
    Input.update
    sprites["bar"].update
    sprites["pokemon"].update
    pbWait(1)
  end
  
  pbDisposeSpriteHash(sprites)
  viewport.dispose
  
end

def pbLoadPokemonStaticBitmap(pokemon, back=false)
  species = pokemon.species
  ret=nil
  if pokemon.egg?
    bitmapFileName=sprintf("Graphics/Battlers/%segg",getConstantName(PBSpecies,species)) rescue nil
    if !pbResolveBitmap(bitmapFileName)
      bitmapFileName=sprintf("Graphics/Battlers/%03degg",species)
      if !pbResolveBitmap(bitmapFileName)
        bitmapFileName=sprintf("Graphics/Battlers/egg")
      end
    end
    bitmapFileName=pbResolveBitmap(bitmapFileName)
  else
    bitmapFileName=pbCheckPokemonBitmapFiles([species,back,
                                              (pokemon.isFemale?),
                                              pokemon.isShiny?,
                                              (pokemon.form rescue 0),
                                              (pokemon.isShadow? rescue false)])
    # Alter bitmap if supported
    alterBitmap=(MultipleForms.getFunction(species,"alterBitmap") rescue nil)
  end
  if bitmapFileName && alterBitmap
    animatedBitmap=RPG::Cache.load_bitmap("",bitmapFileName)
    copiedBitmap=animatedBitmap.copy
    animatedBitmap.dispose
    copiedBitmap.each {|bitmap|
       alterBitmap.call(pokemon,bitmap)
    }
    ret=copiedBitmap
  elsif bitmapFileName
    ret=RPG::Cache.load_bitmap("",bitmapFileName)
  end
  return ret
end