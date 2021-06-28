def pbNumericUpDown(text,min=1,max=100,init=1,cancel=0)
  params=ChooseNumberParams.new
  params.setRange(min, max)
  params.setInitialValue(init)
  params.setCancelValue(cancel)
  ret=Kernel.pbMessageChooseNumber(text,params)
  return ret
end

def pbShowSpeciesPicture(specie,message="",playcry=true)
  battlername=sprintf("Graphics/Battlers/%03d%s",specie,"")
  bitmap=pbResolveBitmap(battlername)
  pbPlayCry(specie) if playcry
  if bitmap # to prevent crashes
    iconwindow=PictureWindow.new(bitmap)
    iconwindow.x=(Graphics.width/2)-(iconwindow.width/2)
    iconwindow.y=((Graphics.height-96)/2)-(iconwindow.height/2)
    Kernel.pbMessage(message)
    iconwindow.dispose
  end
end
