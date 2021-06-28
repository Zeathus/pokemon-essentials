=begin
class PokeBattle_Scene

  attr_reader :camera_x
  attr_reader :camera_y
  attr_reader :camera_z
  attr_reader :camera_rot
  attr_reader :camera_frame
  attr_reader :camera_keyframe 
  attr_reader :camera_pause
  attr_reader :sox # Sprites orignal x coords
  attr_reader :soy # Sprites orignal y coords
  attr_reader :sozx # Sprites orignal zoom_x value
  attr_reader :sozy # Sprites orignal zoom_y value
  
  def pbCameraUpdate(force=false)
    return
    
    return if (@battlestart || @camera_pause) && !force
    
    @camera_x = 0.0 if !@camera_x
    @camera_y = 0.0 if !@camera_y
    @camera_z = 1.0 if !@camera_z
    @camera_rot = 0 if !@camera_rot
    @camera_frame = 0 if !@camera_frame
    @sox = {} if !@sox
    @soy = {} if !@soy
    @sozx = {} if !@sozx
    @sozy = {} if !@sozy
    
    # Cinematic movement code
    #if @camera_frame >= 140# && false
    #  keyframes = [
    #    [0.0, 0.0, 1.0, 120.0],
    #    [60.0, -20.0, 1.1, 120.0],
    #    [76.0, 2.0, 1.1, 120.0],
    #    [-94.0, 2.0, 0.9, 120.0],
    #    [-70.0, -12.0, 1.1, 120.0],
    #    [4.0, 0.0, 1.3, 120.0]
    #  ]
    #  @camera_keyframe = keyframes[rand(keyframes.length)]
    #  #@camera_anim += 1
    #  #@camera_anim = 0 if @camera_anim >= keyframes.length
    #  @camera_frame = 0
    #end
    
    if @camera_keyframe
      if @camera_keyframe.length<5
        duration = @camera_keyframe[3]
        @camera_keyframe[4] = (@camera_keyframe[0]-@camera_x)/duration
        @camera_keyframe[5] = (@camera_keyframe[1]-@camera_y)/duration
        @camera_keyframe[6] = (@camera_keyframe[2]-@camera_z)/duration
      end
      @camera_x += @camera_keyframe[4]
      @camera_y += @camera_keyframe[5]
      @camera_z += @camera_keyframe[6]
      @camera_keyframe[3] -= 1
      if @camera_keyframe[3] <= 0
        @camera_x = @camera_keyframe[0]
        @camera_y = @camera_keyframe[1]
        @camera_z = @camera_keyframe[2]
        @camera_keyframe = nil
      end
    end
    
    if @battlestart
      keys = ["playerbase","enemybase",
              "pokemon0","pokemon1","pokemon2","pokemon3",
              "shadow0","shadow1","shadow2","shadow3",
              "player","playerB"]
    else
      keys = ["playerbase","enemybase",
              "pokemon0","pokemon1","pokemon2","pokemon3",
              "shadow0","shadow1","shadow2","shadow3"]
    end
    
    if $DEBUG && Input.press?(Input::CTRL)
      @camera_frame = 0
      @camera_keyframe = nil
      if Input.press?(Input::L)
        @camera_z -= 0.005
        @camera_z = 0 if @camera_z <= -0.9
      elsif Input.press?(Input::R)
        @camera_z += 0.005
      elsif Input.press?(Input::LEFT)
        @camera_x += 2
      elsif Input.press?(Input::RIGHT)
        @camera_x -= 2
      elsif Input.press?(Input::UP)
        @camera_y += 2
      elsif Input.press?(Input::DOWN)
        @camera_y -= 2
      end
    end
    
    vanish = [Graphics.width/2, Graphics.height*0.265]
    
    for key in keys
      
      next if !@sprites[key]
      
      sprite = @sprites[key]
      
      if !sprite
        @sox[key]=nil
        @soy[key]=nil
        @sozx[key]=nil
        @sozy[key]=nil
        next
      end
      
      next if !sprite.bitmap
      
      # initialize original coords
      if !@sox[key]
        @sox[key] = sprite.x
        @soy[key] = sprite.y
        @sozx[key] = sprite.zoom_x
        @sozy[key] = sprite.zoom_y
      end
      
      new_x = sox[key]
      new_y = soy[key]
      new_zx = sozx[key]
      new_zy = sozy[key]
      
      #new_zx += 1.0 - @camera_z
      #new_zy += 1.0 - @camera_z
      
      if key=="enemybase"
        new_x -= @camera_rot
      elsif key=="playerbase"
        new_x += @camera_rot
      end
      
      if key=="playerbase" || key=="enemybase" || key=="player" || key=="playerB"
        new_x += @camera_x
        new_y -= (vanish[1]-(new_y + sprite.bitmap.height/2.0))*(1.0 - @camera_z)
        # Shrink objects in distance to vanish point
        if new_y != @soy[key] || @camera_y != 0
          # Y values
          old_dist = vanish[1] - (@soy[key] + sprite.bitmap.height/2.0)
          new_dist = vanish[1] - ((new_y + @camera_y) + sprite.bitmap.height/2.0)
          dif_dist = old_dist - new_dist
          rate = 1.0 - (dif_dist / old_dist)
          new_zy *= rate
          # X values
          new_dist = vanish[1] - (new_y + sprite.bitmap.height/2.0)
          dif_dist = old_dist - new_dist
          rate = 1.0 - (dif_dist / old_dist)
          old_dist = vanish[0] - new_x
          new_x += old_dist * (1.0 - rate)
          new_zx *= rate
        end
        # Neutralize center
        #new_x += (sprite.bitmap.width * (1.0-new_zx))/2.0
        new_y += (sprite.bitmap.height * (1.0-new_zy))/2.0
        sprite.zoom_x = new_zx
        sprite.zoom_y = new_zy
      elsif (key=="pokemon0" || key=="shadow0") &&
          @sprites[key] && @sprites["playerbase"]
        base=@sprites["playerbase"]
        new_zx *= base.zoom_x
        new_zy *= base.zoom_x
        sprite.zoom_x = new_zx
        sprite.zoom_y = new_zy
        new_x = base.x + (base.bitmap.width*base.zoom_x/2.0) -
          (sprite.bitmap.width*sprite.zoom_x/2.0)
        new_y = base.y + (base.bitmap.height*base.zoom_y/2) -
                (sprite.bitmap.height * sprite.zoom_y)
        if @sprites["pokemon2"]
          new_x -= (PokeBattle_SceneConstants::PLAYERBATTLER_X -
                    PokeBattle_SceneConstants::PLAYERBATTLERD1_X) *
                    @sprites["pokemon0"].zoom_x
        end
      elsif (key=="pokemon1" || key=="shadow1") &&
             @sprites[key] && @sprites["enemybase"]
        base=@sprites["enemybase"]
        new_zx *= base.zoom_x
        new_zy *= base.zoom_x
        if key=="shadow1"
          new_zy = base.zoom_y
        end
        sprite.zoom_x = new_zx
        sprite.zoom_y = new_zy
        new_x = base.x + (base.bitmap.width*base.zoom_x/2.0) -
          (sprite.bitmap.width*sprite.zoom_x/2.0)
        new_y = base.y + (base.bitmap.height*base.zoom_y/2) -
              (sprite.bitmap.height * sprite.zoom_y)
        if key=="pokemon1" && showShadow?(@battle.battlers[1].species)
          new_y -= 24 * sprite.zoom_y
        end
        if key=="shadow1"
          new_y += (sprite.bitmap.height * sprite.zoom_y)/2.0
        end
        if @sprites["pokemon3"]
          new_x -= (PokeBattle_SceneConstants::FOEBATTLER_X -
                    PokeBattle_SceneConstants::FOEBATTLERD1_X) *
                    @sprites["pokemon1"].zoom_x
        end
      elsif (key=="pokemon2" || key=="shadow2") &&
          @sprites[key] && @sprites["playerbase"]
        base=@sprites["playerbase"]
        new_zx *= base.zoom_x
        new_zy *= base.zoom_x
        sprite.zoom_x = new_zx
        sprite.zoom_y = new_zy
        new_x = base.x + (base.bitmap.width*base.zoom_x/2.0) -
          (sprite.bitmap.width*sprite.zoom_x/2.0)
        new_y = base.y + (base.bitmap.height*base.zoom_y/2) -
                (sprite.bitmap.height * sprite.zoom_y)
        new_y += 8 if key=="pokemon2"
        new_x -= (PokeBattle_SceneConstants::PLAYERBATTLER_X -
                  PokeBattle_SceneConstants::PLAYERBATTLERD2_X) *
                  @sprites["pokemon2"].zoom_x
      elsif (key=="pokemon3" || key=="shadow3") &&
             @sprites[key] && @sprites["enemybase"]
        base=@sprites["enemybase"]
        new_zx *= base.zoom_x
        new_zy *= base.zoom_x
        sprite.zoom_x = new_zx
        sprite.zoom_y = new_zy
        new_x = base.x + (base.bitmap.width*base.zoom_x/2.0) -
          (sprite.bitmap.width*sprite.zoom_x/2.0)
        new_y = base.y + (base.bitmap.height*base.zoom_y/2) -
                (sprite.bitmap.height * sprite.zoom_y)
        if key=="pokemon3" && showShadow?(@battle.battlers[3].species)
          new_y -= 24 * sprite.zoom_y
        end
        new_y -= 8 if key=="pokemon3"
        if key == "shadow3"
          sprite.zoom_y = base.zoom_y
        end
        new_x -= (PokeBattle_SceneConstants::FOEBATTLER_X -
                  PokeBattle_SceneConstants::FOEBATTLERD2_X) *
                  @sprites["pokemon3"].zoom_x
      end
      
      sprite.x = new_x
      sprite.y = new_y + (key.include?("base") ? @camera_y : 0)
      
    end
    
    # Battle Background
    sprite = @sprites["battlebg"]
    if sprite
      
      new_zx = 2.0 - @camera_z
      new_zy = 2.0 - @camera_z
      new_zy += @camera_y / 500
      new_zy = 0.1 if new_zy < 0.1
      sprite.zoom_x = new_zx
      sprite.zoom_y = new_zy
      
      new_x = @camera_x
      new_y = @camera_y
      new_x -= (sprite.bitmap.width * (1.0-sprite.zoom_x))/2.0
      #new_y -= (sprite.bitmap.height * (1.0-sprite.zoom_y))/2.0
      new_y -= (sprite.bitmap.height*0.42) * (1.0-sprite.zoom_y)
      
      sprite.ox = new_x
      sprite.oy = new_y
      
    end
    
    @camera_frame += 1
  
  end
  
  def pbSetKeyframe(x,y,zoom,time)
    return
    @camera_keyframe = [x,y,zoom,time]
    @camera_frame = 0
  end
  
  def pbRebuildCamera
    return
    @camera_frame = 0
    @camera_keyframe = nil
    @camera_pause = true
    @camera_x = 0.0
    @camera_y = 0.0
    @camera_z = 1.0
    @sox = {}
    @soy = {}
    @sozx = {}
    @sozy = {}
    #pbCameraUpdate(true)
  end
  
  def pbResetCamera
    return
    
    @camera_frame = 0
    @camera_keyframe = nil
    
    if !@sox || !@soy || !@camera_x || !@camera_y
      @camera_pause = true
      return
    end
    
    speed_x = (@camera_x*1.0) / 12.0
    speed_y = (@camera_y*1.0) / 12.0
    speed_z = (@camera_z - 1.0) / 12.0
    
    11.times do
      @camera_x -= speed_x
      @camera_y -= speed_y
      @camera_z -= speed_z
      #pbCameraUpdate(true)
      Graphics.update
      @viewport.update
      #pbWait(1)
    end
    
    @camera_pause = true
    
    keys = ["playerbase","enemybase",
            "pokemon0","pokemon1","pokemon2","pokemon3",
            "shadow0","shadow1","shadow2","shadow3"]
    
    for key in keys
      sprite = @sprites[key]
      
      if !sprite
        @sox[key]=nil
        next
      end
      
      if @sox[key]
        if !sprite.is_a?(AnimatedPlane)
          sprite.x = @sox[key]
          sprite.y = @soy[key]
        else
          sprite.ox = @sox[key]
          sprite.oy = @soy[key]
        end
        sprite.zoom_x = @sozx[key]
        sprite.zoom_y = @sozy[key]
      end
    end
    
    @camera_x = 0.0
    @camera_y = 0.0
    @camera_z = 1.0
    @sox = {}
    @soy = {}
    @sozx = {}
    @sozy = {}
    
  end
  
  def pbStartCamera
    #@camera_pause = false
  end
  
  def pbDistance(key)
    
    case key
    when "pokemon0", "shadow0", "pokemon2", "shadow2", "playerbase"
      return 10
    when "pokemon1", "shadow1", "pokemon3", "shadow3", "enemybase"
      return 30
    end
    
    return 0
    
  end
  
end
=end