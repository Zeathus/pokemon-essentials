class PokeBattle_Scene
  def pbAffinityBoostAnimation(attacker,booster)
    
    if attacker.isFainted?
      return
    end
    
    partner = booster
    partner = false if !partner || partner.isFainted?
    
    opponent = (attacker.index % 2 == 1)
    
    ### Beam
    sprites = {}
    sprites["beam"] = IconSprite.new(0,112,@viewport)
    sprites["beam"].setBitmap("Graphics/Pictures/Battle/affinityboost_bg")
    sprites["beam"].src_rect = Rect.new(0,0,512,108)
    sprites["beam"].z = 101
    sprites["beam"].mirror = opponent
    
    ### Text
    sprites["text"] = IconSprite.new(176,134,@viewport)
    sprites["text"].setBitmap("Graphics/Pictures/Battle/affinityboost_text")
    sprites["text"].src_rect = Rect.new(0,0,512,108)
    sprites["text"].z = 102
    sprites["text"].opacity = 0
    sprites["text"].x += opponent ? 70 : -70
    
    start_x = sprites["text"].x
    
    pbSEPlay("PRSFX- Zpower1")
    
    21.times do |i|
      if i % 3 == 0
        sprites["beam"].src_rect.y += 108
        if opponent
          sprites["text"].x -= 2 * (8 - i / 3)
        else
          sprites["text"].x += 2 * (8 - i / 3)
        end
      end
      sprites["text"].opacity += 16
      sprites["beam"].update
      sprites["text"].update
      @viewport.update
      Graphics.update
      Input.update
    end
    
    rand = @battle.pbRandom(100)
    if !partner && rand < 5
      # Cannot do crash animation with one pokemon
      rand = 90
    end
    
    # Whether the text slides off the screen while fading
    slide = true
    
    if rand < 60
      sprites["pkmn1"] = PokemonIconSprite.new(attacker.pokemon,@viewport)
      sprites["pkmn1"].z = 104
      sprites["pkmn1"].x = -64 + 32
      sprites["pkmn1"].y = 120 + 32
      sprites["pkmn1"].ox = 32
      sprites["pkmn1"].oy = 32
      sprites["pkmn1"].mirror = true
      
      sprites["pkmn2"] = partner ? PokemonIconSprite.new(partner.pokemon,@viewport) : Sprite.new(@viewport)
      sprites["pkmn2"].z = 103
      sprites["pkmn2"].x = 506 + 32
      sprites["pkmn2"].y = 120 + 32
      sprites["pkmn2"].ox = 32
      sprites["pkmn2"].oy = 32
    end
    
    if rand < 5
      # 5% chance of crash animation
      14.times do |i|
        sprites["pkmn1"].x += 12 - (i > 10 ? (i - 10) : 0)
        sprites["pkmn2"].x -= 12 - (i > 10 ? (i - 10) : 0)
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      17.times do |i|
        sprites["pkmn1"].x += 6
        sprites["pkmn2"].x -= 6
        sprites["pkmn1"].y += ((i - 19.0) / 4.0).floor
        sprites["pkmn2"].y += ((i - 19.0) / 4.0).floor
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      44.times do |i|
        rot = [i * 2, 30].min
        sprites["pkmn1"].x -= 4
        sprites["pkmn2"].x += 4
        sprites["pkmn1"].angle += rot
        sprites["pkmn2"].angle -= rot
        sprites["pkmn1"].y += ((i - 6.0) / 2.0).floor
        sprites["pkmn2"].y += ((i - 6.0) / 2.0).floor
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      10.times do |i|
        @viewport.update
        Graphics.update
        Input.update
      end
      
    elsif rand < 15
      # 10% chance of flip animation
      14.times do |i|
        sprites["pkmn1"].x += 12 - (i > 10 ? (i - 10) : 0)
        sprites["pkmn2"].x -= 12 - (i > 10 ? (i - 10) : 0)
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      rot = 9
      # 1/4 chance for double flip
      rot = 18 if @battle.pbRandom(4)==0
      
      40.times do |i|
        sprites["pkmn1"].x += 6
        sprites["pkmn2"].x -= 6
        sprites["pkmn1"].angle -= rot
        sprites["pkmn2"].angle += rot
        sprites["pkmn1"].y += ((i - 19.0) / 4.0).floor
        sprites["pkmn2"].y += ((i - 19.0) / 4.0).floor
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      sprites["pkmn1"].angle = 0
      sprites["pkmn2"].angle = 0
      
      16.times do |i|
        sprites["pkmn1"].x += 8 + (i < 4 ? i : 4)
        sprites["pkmn2"].x -= 8 + (i < 4 ? i : 4)
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      10.times do |i|
        @viewport.update
        Graphics.update
        Input.update
      end
      
    elsif rand < 35
      # 20% chance of joy animation
      slide = false
      
      20.times do |i|
        sprites["pkmn1"].x += 12 - (i > 8 ? (i - 8) : 0)
        sprites["pkmn2"].x -= 12 - (i > 8 ? (i - 8) : 0)
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      10.times do |i|
        @viewport.update
        Graphics.update
        Input.update
      end
      
      frames = [-6, -4, -2, 0, 2, 4, 6, 0, -6, -4, -2, 0, 2, 4, 6]
      
      30.times do |i|
        if i % 2 == 0
          sprites["pkmn1"].y += frames[i/2]
          sprites["pkmn2"].y += frames[i/2]
        end
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      10.times do |i|
        @viewport.update
        Graphics.update
        Input.update
      end
      
    elsif rand < 60
      # 25% chance of jump animation
      14.times do |i|
        sprites["pkmn1"].x += 12 - (i > 10 ? (i - 10) : 0)
        sprites["pkmn2"].x -= 12 - (i > 10 ? (i - 10) : 0)
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      40.times do |i|
        sprites["pkmn1"].x += 6
        sprites["pkmn2"].x -= 6
        sprites["pkmn1"].y += ((i - 19.0) / 4.0).floor
        sprites["pkmn2"].y += ((i - 19.0) / 4.0).floor
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      16.times do |i|
        sprites["pkmn1"].x += 8 + (i < 4 ? i : 4)
        sprites["pkmn2"].x -= 8 + (i < 4 ? i : 4)
        sprites["pkmn1"].update
        sprites["pkmn2"].update
        @viewport.update
        Graphics.update
        Input.update
      end
      
      10.times do |i|
        @viewport.update
        Graphics.update
        Input.update
      end
      
    else
      # 40% chance of no special animation
      32.times do |i|
        @viewport.update
        Graphics.update
        Input.update
      end
      
    end
    
    16.times do |i|
      sprites["beam"].opacity -= 20
      sprites["text"].opacity -= 16
      sprites["pkmn1"].opacity -= 20 if sprites["pkmn1"]
      sprites["pkmn2"].opacity -= 20 if sprites["pkmn2"]
      if slide && i % 3 == 0
        if opponent
          sprites["text"].x -= 2 * (8 - i / 3)
        else
          sprites["text"].x += 2 * (8 - i / 3)
        end
      end
      sprites["beam"].update
      sprites["text"].update
      sprites["pkmn1"].update if sprites["pkmn1"]
      sprites["pkmn2"].update if sprites["pkmn2"]
      @viewport.update
      Graphics.update
      Input.update
    end
    
    pbDisposeSpriteHash(sprites)
    
  end
end