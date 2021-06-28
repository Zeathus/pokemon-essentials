class PlayerStats
  attr_accessor(:battles)           # Trainer battles total
  attr_accessor(:battles_won)       # Trainer battles won
  attr_accessor(:battles_lost)      # Trainer battles lost
  attr_accessor(:wild_battles)      # Wild battles total
  attr_accessor(:wild_wins)         # Wild pokemon defeated
  attr_accessor(:wild_fled)         # Wild battles fled from
  attr_accessor(:pokemon_caught)    # Wild Pokémon caught
  attr_accessor(:pokemon_defeated)  # Enemy Trainer Pokémon KOs
  attr_accessor(:ally_fainted)      # Times Party Pokémon have fainted
  attr_accessor(:quests_completed)  # Quests completed
  attr_accessor(:heal_count)        # Heals at Pokémon Centers
  attr_accessor(:nicknamed)         # Times a Pokémon has been nicknamed
  attr_accessor(:unnamed)           # Times a Pokémon wasn't nicknamed
  attr_accessor(:money_earned)      # Total money earned
  attr_accessor(:money_spent)       # Money spent while purchasing items
  attr_accessor(:steps_taken)       # Total steps taken
  attr_accessor(:eggs_hatched)      # Eggs hatched
  attr_accessor(:affinity_boosts)   # Number of ABs performed
  
  def initialize()
    @battles          = 0
    @battles_won      = 0
    @battles_lost     = 0
    @wild_battles     = 0
    @wild_wins        = 0
    @wild_fled        = 0
    @pokemon_caught   = 0
    @pokemon_defeated = 0
    @ally_fainted     = 0
    @quests_completed = 0
    @heal_count       = 0
    @nicknamed        = 0
    @unnamed          = 0
    @money_earned     = 0
    @money_spent      = 0
    @steps_taken      = 0
    @eggs_hatched     = 0
    @affinity_boosts  = 0
  end
  
  def affinity_boosts
    return @affinity_boosts ? @affinity_boosts : 0
  end
  
  def affinity_boosts=(value)
    @affinity_boosts = value
  end
  
  def update
    $game_switches[TAKEN_STEP]=false
    return if $game_variables[QUEST_ARRAY]==0
    quests = $game_variables[QUEST_ARRAY]
    if battles_won >= 10 && pbGetQuestStatus(:NoviceBattler) != 2
      pbFinishQuest(:NoviceBattler)
    end
    if battles_won >= 50 && pbGetQuestStatus(:IntermediateBattler) != 2
      pbFinishQuest(:IntermediateBattler)
    end
    if battles_won >= 150 && pbGetQuestStatus(:VeteranBattler) != 2
      pbFinishQuest(:VeteranBattler)
    end
    if pokemon_caught >= 10 && pbGetQuestStatus(:NoviceCollector) != 2
      pbFinishQuest(:NoviceCollector)
    end
    if pokemon_caught >= 25 && pbGetQuestStatus(:IntermediateCollector) != 2
      pbFinishQuest(:IntermediateCollector)
    end
    if pokemon_caught >= 50 && pbGetQuestStatus(:VeteranCollector) != 2
      pbFinishQuest(:VeteranCollector)
    end
    pbCheckQuestUnlocks
  end
  
end

















