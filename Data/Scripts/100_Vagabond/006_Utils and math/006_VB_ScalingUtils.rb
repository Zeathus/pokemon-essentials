def pbPreferredLevel
  return pbPlayerLevel
end

def pbPlayerLevel
  level = $game_variables[PLAYER_EXP]**(1.0/3.0)
  level = 100 if level > 100
  level = 10 if level < 10
  return level
end

def pbTrainerAverageLevel
  party = $Trainer.party
  return 1 if party.length <= 0
  party_size = 0
  total = 0
  highest = 0
  for pkmn in party
    if !pkmn.isEgg?
      party_size += 1
      total += pkmn.level
      highest = pkmn.level if pkmn.level > highest
    end
  end
  average = total / party_size
  average = (highest - 3) if (highest - 5) > average
  $game_variables[AVERAGE_LEVEL] = average if $game_variables[AVERAGE_LEVEL] < average
  return $game_variables[AVERAGE_LEVEL]
end

def pbTrainerHighestLevel
  party = $Trainer.party
  highest = 0
  for pkmn in party
    if !pkmn.isEgg?
      highest = pkmn.level if pkmn.level > highest
    end
  end
  $game_variables[HIGHEST_LEVEL] = highest if $game_variables[HIGHEST_LEVEL] < highest
  return $game_variables[HIGHEST_LEVEL]
end

def pbTrainerLevelProgressionOld
  
  story_add = 0 # Additional levels from story progression
  quest_add = 0 # Additional levels from quest progression
  gym_add = 0 # Additional levels from gym progression
  battle_add = 0 # Additional levels from won battles
  skill_adjust = 0 # Adjust levels based on the player's skill
  
  # Minimum level based on defeated gyms
  gym_levels = [10,20,30,40,50,60,70,80,90]
  min_level = gym_levels[pbGet(BADGE_COUNT)] - 1
  if min_level < pbTrainerAverageLevel - 2
    min_level = pbTrainerAverageLevel - 2
  end
  max_level = pbTrainerHighestLevel
  
  # Story levels
  if $game_variables[QUEST_MAIN].is_a?(Array)
    story_add += 2 if pbMainQuest(:TheFirstGym).status==2
    story_add += 0 if pbMainQuest(:GPOMembership).status==2
    story_add += 2 if pbMainQuest(:UnknownDestination).status==2
    story_add += 1 if pbMainQuest(:TheMysteriousGirl).status==2
    story_add += 2 if pbMainQuest(:TroubleAtMtPegma).status==2
    story_add += 2 if pbMainQuest(:NekaneGoneMissing).status==2
    story_add += 3 if pbMainQuest(:GuardianOfEmotion).status==2
    story_add += 3 if pbMainQuest(:ElianaOfTeamDao).status==2
  end
  
  # Add grandure if a quest is completed
  if $game_variables[QUEST_ARRAY].is_a?(Array)
    for quest in $game_variables[QUEST_ARRAY]
      if quest.status==2
        quest_add += ((quest.exp * 1.0) / 100.0)
      end
    end
  end
  
  # Add or remove levels based on win/loss ratio
  if $Trainer && $Trainer.stats
    stats = $Trainer.stats
    if stats.battles > 0 && stats.battles_won > 0 && stats.battles_lost > 0
      if stats.battles > 20
        ratio = (stats.battles_won * 100.0) / stats.battles_lost
        # The player should not have to lose too often
        # Bosses are the hardest, so regular trainers should
        # be considered as easy win-fodder
        if ratio <= 100
          # More of equal amount of losses and wins
          skill_adjust -= 3
        elsif ratio <= 200
          # Win 50% more than you lose
          skill_adjust -= 2
        elsif ratio <= 300
          # Win twice as much as you lose
          skill_adjust -= 1
        elsif ratio >= 1000
          # Win ten times as much as you lose
          skill_adjust += 1
        elsif ratio >= 10000
          # Win 100x as much as you lose
          skill_adjust += 2
        end
      end
    else
      # If no battles have been lost
      if stats.battles_won > 100
        # The player obviously has it way too easy
        skill_adjust += 3
      elsif stats.battles_won > 50
        # The player still isn't satisfied
        skill_adjust += 2
      elsif stats.battles_won > 25
        # The player would like some more challenge
        skill_adjust += 1
      end
    end
  end
  
  if $PokemonSystem.difficulty==2 && skill_adjust < 0
    skill_adjust = 0
  end
  
  # Add a level for every 4 battles won
  battle_add += stats.battles_won / 4
  
  # Add 4 levels for each gym defeated
  # Levels: 0, 7, 10, 12, 14, 15, 17, 18, 20
  gym_add += Math.sqrt(pbGet(BADGE_COUNT)*50)
  
  level = 0
  level += story_add.floor
  level += quest_add.round
  level += gym_add.floor
  level += battle_add.floor
  level = min_level if level < min_level
  level = max_level if level > max_level
  level += skill_adjust.floor
  
  $game_variables[PREF_LEVEL] = level if level > $game_variables[PREF_LEVEL]
  
  return $game_variables[PREF_LEVEL]
  
end