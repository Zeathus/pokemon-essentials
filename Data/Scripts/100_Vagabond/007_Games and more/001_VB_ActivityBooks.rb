def pbReadBook(name)
  page = 0 # Variable to keep track of the current page
  viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  file = _INTL("Graphics/Scenes/School/{1}_{2}",name,page)
  book = Sprite.new(viewport)
  if pbResolveBitmap(file)
    book.bitmap=RPG::Cache.load_bitmap("",file)
  end
  viewport.z = 200
  loop do
    Graphics.update
    Input.update
    viewport.update
    if Input.trigger?(Input::RIGHT)
      page = page + 1
      file = _INTL("Graphics/Scenes/School/{1}_{2}",name,page)
      if pbResolveBitmap(file)
        book.bitmap=RPG::Cache.load_bitmap("",file)
      else
        page = page - 1
      end
    elsif Input.trigger?(Input::LEFT)
      page = page - 1
      file = _INTL("Graphics/Scenes/School/{1}_{2}",name,page)
      if pbResolveBitmap(file)
        book.bitmap=RPG::Cache.load_bitmap("",file)
      else
        page = page + 1
      end
    elsif Input.trigger?(Input::B)
      viewport.dispose
      break
    end
  end
  viewport.dispose
end

def pbHasBook?
  books = [
  :EEVEEBOOK]
  book = 0
  for i in books
    if $PokemonBag.pbQuantity(i)>=1
      book = i
    end
  end
  return book
end