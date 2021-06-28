def debug_extra?
  return false if !$DEBUG
  return $game_switches[DEBUG_EXTRA]
end

def pbShowCollision
  if $game_variables[DEBUG_VAR]==0
    $game_variables[DEBUG_VAR]=[]
    $game_variables[DEBUG_VAR][0]=Viewport.new(0,0,Graphics.width,Graphics.height)
    $game_variables[DEBUG_VAR][1]=Sprite.new($game_variables[DEBUG_VAR][0])
    $game_variables[DEBUG_VAR][1].bitmap = Bitmap.new(Graphics.width,Graphics.height)
  end
  viewport=$game_variables[DEBUG_VAR][0]
  viewport.z = 99999
  color_passable = Color.new(250, 250, 250)
  color_solid = Color.new(250,0, 0)
  
  sprite=$game_variables[DEBUG_VAR][1]
  sprite.opacity = 100
  sprite.bitmap.clear
  for x in ($game_player.x-8)..($game_player.x+8)
    for y in ($game_player.y-6)..($game_player.y+6)
      realx = x - $game_player.x + 8
      realy = y - $game_player.y + 6
      solid_do = !$game_map.passable?(x, y, 2)
      solid_le = !$game_map.passable?(x, y, 4)
      solid_ri = !$game_map.passable?(x, y, 6)
      solid_up = !$game_map.passable?(x, y, 8)
      if solid_do && solid_le && solid_ri && solid_up
        sprite.bitmap.fill_rect(realx*32-16,realy*32-16,32,32,color_solid)
      else
        if solid_do
          sprite.bitmap.fill_rect(realx*32-16,realy*32+8,32,8,color_solid)
        end
        if solid_le
          sprite.bitmap.fill_rect(realx*32-16,realy*32-16,8,32,color_solid)
        end
        if solid_ri
          sprite.bitmap.fill_rect(realx*32+8,realy*32-16,8,32,color_solid)
        end
        if solid_up
          sprite.bitmap.fill_rect(realx*32-16,realy*32-16,32,8,color_solid)
        end
      end
    end
  end
  viewport.update
  Graphics.update
  Input.update
end

def pbHideCollision
  if $game_variables[DEBUG_VAR] != 0
    $game_variables[DEBUG_VAR][1].dispose
    $game_variables[DEBUG_VAR][0].dispose
    $game_variables[DEBUG_VAR] = 0
  end
end

def pbDisableOverlays
  if $game_switches[SHOW_COLLISION]
    pbHideCollision
  end
end

def pbTestBattle
  pbTrainerBattle(PBTrainers::YOUNGSTER, "Test", _I("..."))
end






