def pbShowMail(forceopen=false,global=false)
  personal_mail=[]
  global_mail=[]
  for i in 0...$Trainer.mail.personal.length
    personal_mail.push($Trainer.mail.personal[$Trainer.mail.personal.length-i-1])
  end
  for i in 0...$Trainer.mail.global.length
    global_mail.push($Trainer.mail.global[$Trainer.mail.global.length-i-1])
  end
  no_prev = true
  
  viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z = 99999
  text_color1 = Color.new(250, 250, 250)
  text_color2 = Color.new(50, 50, 100)
  text_color4 = Color.new(100, 50, 50)
  
  mailtab = 0
  newtab = 0
  mailtab = newtab = 1 if global
  selected = 0
  scroll = 0
  mail_list = personal_mail
  mail_list = global_mail if global
  
  sprites={}
  file = _INTL("Graphics/Pictures/mailbox_1")
  file = _INTL("Graphics/Pictures/mailbox_2") if global
  sprites["bg"] = Sprite.new(viewport)
  sprites["bg"].bitmap = BitmapCache.load_bitmap(file)
  pbFadeInAndShow(sprites)
  
  sprites["tabs"]=Sprite.new(viewport)
  sprites["tabs"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
  pbSetSystemFont(sprites["tabs"].bitmap)
  sprites["tabs"].bitmap.clear
  textpos=[["Personal",94,62,false,text_color1,text_color2],
           ["Global",342,62,false,text_color1,text_color2]]
  pbDrawTextPositions(sprites["tabs"].bitmap,textpos)
  
  sprites["cursor"]=Sprite.new(viewport)
  file = _INTL("Graphics/Scenes/Quests/cursor")
  sprites["cursor"].bitmap=BitmapCache.load_bitmap(file)
  sprites["cursor"].x=14
  sprites["cursor"].y=99
  
  sprites["scrollbar"]=Sprite.new(viewport)
  file = _INTL("Graphics/Pictures/mailboxScrollbar")
  sprites["scrollbar"].bitmap=BitmapCache.load_bitmap(file)
  sprites["scrollbar"].x=470
  sprites["scrollbar"].y=100
  sprites["scrollbar"].z=2
  
  sprites["overlay"] = Sprite.new(viewport)
  sprites["title"] = Sprite.new(viewport)
  sprites["message"] = Sprite.new(viewport)
  sprites["overlay"].visible = false
  sprites["title"].visible = false
  sprites["message"].visible = false
  
  sprites["mail"] = Sprite.new(viewport)
  sprites["mail"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
  pbSetSystemFont(sprites["mail"].bitmap)
  textpos = []
  for i in scroll..(scroll+6)
    offset = (i-scroll) * 30
    if i < mail_list.length
      textpos += [[mail_list[i].sender,36,100+offset,false,text_color1,text_color4]]
      textpos += [[mail_list[i].subject,222,100+offset,false,text_color1,text_color4]]
    end
  end
  pbDrawTextPositions(sprites["mail"].bitmap,textpos)
  
  loop do
    Graphics.update
    Input.update
    viewport.update
    update = false
    if Input.trigger?(Input::DOWN)
      selected += 1
      selected = mail_list.length-1 if selected>mail_list.length-1
      scroll += 1 if selected > (scroll+6)
      update = true
    elsif Input.trigger?(Input::UP)
      selected -= 1
      selected = 0 if selected < 0
      scroll -= 1 if selected < scroll
      update = true
    elsif Input.trigger?(Input::LEFT)
      selected = 0 if newtab == 1
      scroll = 0 if newtab == 1
      newtab = 0
      update = true
    elsif Input.trigger?(Input::RIGHT)
      selected = 0 if newtab == 0
      scroll = 0 if newtab == 0
      newtab = 1
      update = true
    elsif Input.trigger?(Input::C) || forceopen
      forceopen = false
      sprites["overlay"].visible = true
      sprites["title"].visible = true
      sprites["message"].visible = true
      info = "Graphics/Pictures/mailbox_o1"
      info = "Graphics/Pictures/mailbox_o2" if mailtab==1
      sprites["overlay"].bitmap = BitmapCache.load_bitmap(info)
      pbSetSystemFont(sprites["tabs"].bitmap)
      sprites["tabs"].bitmap.clear
      textpos=[["Personal",94,62,false,text_color1,text_color2],
               ["Global",342,62,false,text_color1,text_color2]]
      pbDrawTextPositions(sprites["tabs"].bitmap,textpos)
      sprites["mail"].bitmap.clear
      mail = mail_list[selected]
      mail.read = true
      sprites["title"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
      pbSetSystemFont(sprites["title"].bitmap)
      textpos += [[mail_list[selected].sender,36,100,false,text_color1,text_color4]]
      textpos += [[mail_list[selected].subject,222,100,false,text_color1,text_color4]]
      pbDrawTextPositions(sprites["title"].bitmap,textpos)
      sprites["message"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
      pbSetSystemFont(sprites["message"].bitmap)
      message = mail_list[selected].message
      char = ""
      line = 0
      next_string = ""
      text_length = 0
      next_line = "\n"
      textpos = []
      while message.length > 0
        if (text_length > 110 && char == " ") || message[0..0]==next_line
          text_length = 0
          textpos += [[next_string,36,130+line*28,false,text_color1,text_color4]]
          next_string = ""
          line += 1
          if message[0..0]==next_line
            message = message[1..message.length]
            next
          end
        end
        char = message[0..0]
        message = message[1..message.length]
        if char == " " || char == "i" || char == "l" or char == "'"
          text_length += 2
        else
          text_length += 4
        end
        next_string += char
      end
      textpos += [[next_string,36,130+line*28,false,text_color1,text_color4]]
      total_lines = line + 1
      pbDrawTextPositions(sprites["message"].bitmap,textpos)
      #file = _INTL("Graphics/Pictures/mailboxScrollbar")
      #sprites["scrollbar"].bitmap=BitmapCache.load_bitmap(file)
      sprites["scrollbar"].x=470
      sprites["scrollbar"].y=100
      if mail.picture != nil
        sprites["picture"]=Sprite.new(viewport)
        sprites["picture"].bitmap=BitmapCache.load_bitmap(mail.picture)
        sprites["picture"].x=36
        sprites["picture"].y=130+(line+1)*28
      end
      sprites["bottom"] = Sprite.new(viewport)
      file = "Graphics/Pictures/mailbox_bottom"
      sprites["bottom"].bitmap = BitmapCache.load_bitmap(file)
      linescroll = 0
      loop do
        Graphics.update
        viewport.update
        Input.update
        update = false
        if Input.trigger?(Input::B) || Input.trigger?(Input::C)
          sprites["message"].visible = false
          sprites["overlay"].visible = false
          sprites["title"].visible = false
          sprites["message"].visible = false
          update = true
          break
        elsif Input.trigger?(Input::UP)
          if linescroll > 0
            linescroll -= 1
            update = true
          end
        elsif Input.trigger?(Input::DOWN)
          if linescroll + 6 < total_lines
            linescroll += 1
            update = true
          elsif mail.picture != nil
            if (linescroll + 6) * 28 < total_lines * 28 + (sprites["picture"].bitmap.height)
              linescroll += 1
              update = true
            end
          end
        end
        if update
          sprites["scrollbar"].x=470
          sprites["scrollbar"].y=100
          if total_lines > 6 && linescroll > 0
            if mail.picture != nil
              value = (148*linescroll)
              divisor = (total_lines-5)+(sprites["picture"].bitmap.height/28).floor
              value = value / divisor
              sprites["scrollbar"].y+=value
            else
              sprites["scrollbar"].y+=(148*linescroll/(total_lines-6))
            end
          end
          char = ""
          line = 0
          next_string = ""
          text_length = 0
          message = mail_list[selected].message
          sprites["message"].bitmap.clear
          textpos = []
          while message.length > 0
            if (text_length > 110 && char == " ") || message[0..0]==next_line
              text_length = 0
              textpos += [[next_string,36,130+(line-linescroll)*28,false,text_color1,text_color4]] if line >= linescroll
              next_string = ""
              line += 1
              if message[0..0]==next_line
                message = message[1..message.length]
                next
              end
            end
            char = message[0..0]
            message = message[1..message.length]
            if char == " " || char == "i" || char == "l" or char == "'"
              text_length += 2
            else
              text_length += 4
            end
            next_string += char
          end
          textpos += [[next_string,36,130+(line-linescroll)*28,false,text_color1,text_color4]]
          pbDrawTextPositions(sprites["message"].bitmap,textpos)
          if sprites["picture"]
            sprites["picture"].y=130+(line-linescroll+1)*28
          end
        end
      end
    elsif Input.trigger?(Input::B)
      viewport.dispose
      break
    end
    if update
      if newtab == 0
        mailtab = newtab
        file = _INTL("Graphics/Pictures/mailbox_1")
        #sprites["bg"].dispose
        #sprites["bg"] = Sprite.new(viewport)
        sprites["bg"].bitmap = BitmapCache.load_bitmap(file)
        mail_list = personal_mail
        newtab = -1
        scroll = 0
        selected = 0
      elsif newtab == 1
        mailtab = newtab
        file = _INTL("Graphics/Pictures/mailbox_2")
        #sprites["bg"].dispose
        #sprites["bg"] = Sprite.new(viewport)
        sprites["bg"].bitmap = BitmapCache.load_bitmap(file)
        mail_list = global_mail
        newtab = -1
        scroll = 0
        selected = 0
      end
      sprites["cursor"].x = 14
      sprites["cursor"].y = 99+(selected-scroll)*30
      sprites["scrollbar"].x=470
      sprites["scrollbar"].y=100
      if mail_list.length > 7 && scroll > 0
        sprites["scrollbar"].y+=(148*scroll/(mail_list.length-7))
      end
      sprites["mail"].bitmap.clear
      pbSetSystemFont(sprites["mail"].bitmap)
      textpos = []
      for i in (scroll)..(scroll+6)
        offset = (i-scroll) * 30
        if i < mail_list.length
          textpos += [[mail_list[i].sender,36,100+offset,false,text_color1,text_color4]]
          textpos += [[mail_list[i].subject,222,100+offset,false,text_color1,text_color4]]
        end
      end
      pbDrawTextPositions(sprites["mail"].bitmap,textpos)
    end
  end
  pbFadeOutAndHide(sprites)
  pbDisposeSpriteHash(sprites)
  viewport.dispose
end