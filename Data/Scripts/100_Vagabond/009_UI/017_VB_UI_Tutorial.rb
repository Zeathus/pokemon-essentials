def pbShowTutorial(name)
  
  viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z = 99999
  sprite = IconSprite.new(0, 32, viewport)
  filename = "Graphics/Tutorials/" + name + "_"
  num = 1
  
  nextSprite = IconSprite.new(390, 216, viewport)
  nextSprite.setBitmap("Graphics/Tutorials/next")
  prevSprite = IconSprite.new(82, 216, viewport)
  prevSprite.setBitmap("Graphics/Tutorials/prev")
  
  while pbResolveBitmap(filename + num.to_s)
    prevSprite.visible = (num > 1)
    sprite.setBitmap(filename + num.to_s)
    sprite.y = 32
    sprite.opacity = 0
    nextSprite.opacity = 0
    prevSprite.opacity = 0
    
    16.times do
      sprite.opacity += 16
      nextSprite.opacity += 16
      prevSprite.opacity += 16
      sprite.y -= 2
      Graphics.update
      Input.update
      viewport.update
      sprite.update
      nextSprite.update
      prevSprite.update
    end
    
    back = false
    while true
      if Input.trigger?(Input::USE)
        pbSEPlay("Choose",100)
        break
      elsif Input.trigger?(Input::BACK) && num > 1
        pbSEPlay("Choose",100)
        back = true
        break
      end
      Graphics.update
      Input.update
      viewport.update
      sprite.update
      nextSprite.update
      prevSprite.update
    end
    num += back ? -1 : 1
  end
  
  sprite.dispose
  nextSprite.dispose
  prevSprite.dispose
  viewport.dispose
  
end