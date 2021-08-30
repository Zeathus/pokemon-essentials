# [map_id][eventid,marker,[requirements]]
# Marker: 0=question mark, 1=exclamation mark, 2=speech

def pbLoadQuestMarkers
  return if !$Markers || !$Markers[$game_map.map_id]
  for marker in $Markers[$game_map.map_id]
    next if !marker || marker.length < 3
    event = $game_map.events[marker[0]]
    page = marker[1]
    next if event.pageNum != page
    type = marker[2]
    next if !event
    active=true
    if marker.length > 3 && marker[3]
      reqs = marker[3]
      for i in reqs
        if !eval(i)
          active = false
          break
        end
      end
    end
    next if !active
    if marker.length > 4 && marker[4]
      questid = eval(marker[4])
      if type==0
        active = false if pbQuest(questid).status!=0
      else
        active = false if pbQuest(questid).status!=1
      end
    end
    if active
      pbQuestBubble(event,type)
    end
  end
end

def pbUnloadQuestMarkers
  for e in $game_map.events.values
    e.marker_id = -1
  end
end

def pbLoadItemSparkles
  for event in $game_map.events.values
    if event.name.include?("HiddenItem") &&
      !$game_self_switches[[$game_map.map_id,event.id,"A"]]
      pbQuestBubble(get_character(event.id),11)
    end
  end
end

def pbUpdateMarkers
  pbUnloadQuestMarkers
  pbLoadQuestMarkers
  #if (pbPartyAbilityCount(:KEENEYE)+
  #    pbPartyAbilityCount(:COMPOUNDEYES)+
  #    pbPartyAbilityCount(:FRISK))>0
  #  pbLoadItemSparkles
  #end
end

def pbQuestBubble(event,id=0,tinting=false)
  event.marker_id = id
  return
  if event.is_a?(Array)
    sprite=nil
    done=[]
    for i in event
      if !done.include?(i.id)
        sprite=$scene.spriteset.addUserAnimation(id,i.x,i.y,tinting,3,event)
        done.push(i.id)
      end
    end
  else
    sprite=$scene.spriteset.addUserAnimation(id,event.x,event.y,tinting,3,event)
  end
end