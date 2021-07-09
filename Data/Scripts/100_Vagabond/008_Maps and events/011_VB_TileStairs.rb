def pbStairs(xOffset,yOffset)
  return false
  return false if $game_player.through
  x = $game_player.x + xOffset
  y = $game_player.y + yOffset
  if $game_player.direction==2 && PBTerrain.isStairs?($game_map.terrain_tag($game_player.x,$game_player.y)) # Down
    return true if !PBTerrain.isStairs?($game_map.terrain_tag(x,y+1))
  end
  if PBTerrain.isStairs?(Kernel.pbFacingTerrainTag)
    if Kernel.pbFacingTerrainTag==PBTerrain::StairsRight
      if $game_player.direction==6 # Right
        $game_player.move_upper_right
        return true
      elsif $game_player.direction==4 # Left
        if !PBTerrain.isStairs?($game_map.terrain_tag(x,y+1))
          return true
        end
        if PBTerrain.isStairs?($game_map.terrain_tag($game_player.x,$game_player.y))
          $game_player.move_lower_left
          return true
        end
      end
    elsif Kernel.pbFacingTerrainTag==PBTerrain::StairsLeft
      if $game_player.direction==4 # Left
        $game_player.move_upper_left
        return true
      elsif $game_player.direction==6 # Right
        if !PBTerrain.isStairs?($game_map.terrain_tag(x,y+1))
          return true
        end
        if PBTerrain.isStairs?($game_map.terrain_tag($game_player.x,$game_player.y))
          $game_player.move_lower_right
          return true
        end
      end
    end
  else
    if $game_map.terrain_tag($game_player.x,$game_player.y)==PBTerrain::StairsRight
      if $game_player.direction==4 # Left
        $game_player.move_lower_left
        return true
      end
    elsif $game_map.terrain_tag($game_player.x,$game_player.y)==PBTerrain::StairsLeft
      if $game_player.direction==6 # Right
        $game_player.move_lower_right
        return true
      end
    end
  end
  return false
end