

def pbPlayMovie7

  pbStartCutscene
  
  viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  sprites = {}
  sprites["movie"] = Sprite.new(viewport)
  
  moviereel = AnimatedBitmap.new("Graphics/Pictures/Movies/moviereel")
  
  Graphics.update
  Input.update
  viewport.update
  
  moviebitmap = AnimatedBitmap.new("Graphics/Pictures/Movies/movie7")
  
  sprites["movie"].y = 16
  sprites["movie"].x = 256 - (moviereel.bitmap.width * 2)
  sprites["movie"].zoom_x = 4.0
  sprites["movie"].zoom_y = 4.0
  sprites["movie"].bitmap = moviereel.bitmap
  
  236.times do
    Graphics.update
    Input.update
    viewport.update
    moviereel.update
    sprites["movie"].bitmap = moviereel.bitmap
  end
  
  sprites["movie"].bitmap = nil
  
  Graphics.update
  Input.update
  viewport.update
  
  pbWait(20)
  
  sprites["movie"].bitmap = moviebitmap.bitmap
  sprites["movie"].x = 256 - (moviebitmap.bitmap.width * 2)
  
  pbMEPlay("movie7", 120)
  
  4620.times do
    Graphics.update
    Input.update
    viewport.update
    moviebitmap.update
    sprites["movie"].bitmap = moviebitmap.bitmap
  end
  
  pbDisposeSpriteHash(sprites)
  viewport.dispose
  
  pbEndCutscene
  
end