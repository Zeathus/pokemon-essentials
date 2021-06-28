def pbSetEventPersistent(event,persistent=true)
  $game_variables[PERSISTENT_EVENTS]={} if $game_variables[PERSISTENT_EVENTS]==0
  if event.is_a?(Numeric)
    $game_variables[PERSISTENT_EVENTS][[$game_map.map_id,event]]=persistent
  else
    for i in event
      $game_variables[PERSISTENT_EVENTS][[$game_map.map_id,i]]=persistent
    end
  end
end