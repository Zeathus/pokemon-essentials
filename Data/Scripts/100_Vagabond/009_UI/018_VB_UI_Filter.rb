def pbScreenFilter(sprites)
  return
  for sprite in sprites
    
    bitmap = sprite.bitmap
    obitmap = Bitmap.new(bitmap.width, bitmap.height)
    obitmap.blt(0, 0, bitmap, Rect.new(0, 0, bitmap.width, bitmap.height))
    
    bitmap.clear
    for i in 0...bitmap.height
      
      r = Graphics.frame_count / 4
      offset = Math.sin(r + i) * 1.5
      bitmap.blt(offset, i*2, obitmap, Rect.new(0, i*2, obitmap.width, 2))
      
    end
    
  end
  
end