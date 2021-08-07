class ItemIconSmallSprite < SpriteWrapper
  attr_reader :item
  ANIMICONSIZE = 24
  FRAMESPERCYCLE = 40

  def initialize(x,y,item,viewport=nil)
    super(viewport)
    @animbitmap=nil
    @animframe=0
    @numframes=1
    @frame=0
    self.x=x
    self.y=y
    self.item=item
  end

  def width
    return 0 if !self.bitmap || self.bitmap.disposed?
    return (@numframes==1) ? self.bitmap.width : ANIMICONSIZE
  end

  def height
    return (self.bitmap && !self.bitmap.disposed?) ? self.bitmap.height : 0
  end

  def setOffset(offset=PictureOrigin::Center)
    @offset=offset
    changeOrigins
  end

  def changeOrigins
    @offset=PictureOrigin::Center if !@offset
    case @offset
    when PictureOrigin::TopLeft, PictureOrigin::Top, PictureOrigin::TopRight
      self.oy=0
    when PictureOrigin::Left, PictureOrigin::Center, PictureOrigin::Right
      self.oy=self.height/2
    when PictureOrigin::BottomLeft, PictureOrigin::Bottom, PictureOrigin::BottomRight
      self.oy=self.height
    end
    case @offset
    when PictureOrigin::TopLeft, PictureOrigin::Left, PictureOrigin::BottomLeft
      self.ox=0
    when PictureOrigin::Top, PictureOrigin::Center, PictureOrigin::Bottom
      self.ox=self.width/2
    when PictureOrigin::TopRight, PictureOrigin::Right, PictureOrigin::BottomRight
      self.ox=self.width
    end
  end

  def item=(value)
    @item=value
    @animbitmap.dispose if @animbitmap
    @animbitmap=nil
    if @item
      srcbitmap=Bitmap.new(GameData::Item.icon_filename(value))
      @animbitmap=Bitmap.new(12,12)
      @animbitmap.stretch_blt(Rect.new(0,0,11,11),srcbitmap,Rect.new(0,0,47,47))
      srcbitmap.dispose
      self.bitmap=@animbitmap
      @numframes=1
      self.src_rect=Rect.new(0,0,ANIMICONSIZE,ANIMICONSIZE)
      @animframe=0
      @frame=0
    else
      self.bitmap=nil
    end
  end

  def dispose
    @animbitmap.dispose if @animbitmap
    super
  end

  def update
    @updating=true
    super
    if @animbitmap
      @animbitmap.update
      self.bitmap=@animbitmap
    end
    @updating=false
  end
end