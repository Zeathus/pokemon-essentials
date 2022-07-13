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
  end
  
end

















