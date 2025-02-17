#===============================================================================
# Trainer class for the player
#===============================================================================
class Player < Trainer
  # @return [Integer] the character ID of the player
  attr_accessor :character_ID
  # @return [Integer] the player's outfit
  attr_accessor :outfit
  # @return [Array<Boolean>] the player's Gym Badges (true if owned)
  attr_accessor :badges
  # @return [Integer] the player's money
  attr_reader   :money
  # @return [Integer] the player's Game Corner coins
  attr_reader   :coins
  # @return [Integer] the player's battle points
  attr_reader   :battle_points
  # @return [Integer] the player's soot
  attr_reader   :soot
  # @return [Pokedex] the player's Pokédex
  attr_reader   :pokedex
  # @return [Boolean] whether the Pokédex has been obtained
  attr_accessor :has_pokedex
  # @return [Boolean] whether the Pokégear has been obtained
  attr_accessor :has_pokegear
  # @return [Boolean] whether the player has running shoes (i.e. can run)
  attr_accessor :has_running_shoes
  # @return [Boolean] whether the creator of the Pokémon Storage System has been seen
  attr_accessor :seen_storage_creator
  # @return [Boolean] whether Mystery Gift can be used from the load screen
  attr_accessor :mystery_gift_unlocked
  # @return [Array<Array>] downloaded Mystery Gift data
  attr_accessor :mystery_gifts

  attr_accessor :playerstats
  attr_accessor :mailbox

  def trainer_type
    if @trainer_type.is_a?(Integer)
      @trainer_type = GameData::Metadata.get_player(@character_ID || 0)[0]
    end
    return @trainer_type
  end

  # Sets the player's money. It can not exceed {Settings::MAX_MONEY}.
  # @param value [Integer] new money value
  def money=(value)
    validate value => Integer
    @money = value.clamp(0, Settings::MAX_MONEY)
  end

  # Sets the player's coins amount. It can not exceed {Settings::MAX_COINS}.
  # @param value [Integer] new coins value
  def coins=(value)
    validate value => Integer
    @coins = value.clamp(0, Settings::MAX_COINS)
  end

  # Sets the player's Battle Points amount. It can not exceed
  # {Settings::MAX_BATTLE_POINTS}.
  # @param value [Integer] new Battle Points value
  def battle_points=(value)
    validate value => Integer
    @battle_points = value.clamp(0, Settings::MAX_BATTLE_POINTS)
  end

  # Sets the player's soot amount. It can not exceed {Settings::MAX_SOOT}.
  # @param value [Integer] new soot value
  def soot=(value)
    validate value => Integer
    @soot = value.clamp(0, Settings::MAX_SOOT)
  end

  # @return [Integer] the number of Gym Badges owned by the player
  def badge_count
    return @badges.length
  end

  #=============================================================================

  # (see Pokedex#seen?)
  # Shorthand for +self.pokedex.seen?+.
  def seen?(species)
    return @pokedex.seen?(species)
  end

  # (see Pokedex#owned?)
  # Shorthand for +self.pokedex.owned?+.
  def owned?(species)
    return @pokedex.owned?(species)
  end
  
  def stats
    $game_switches[TAKEN_STEP]=true
    if @playerstats == nil
      @playerstats=PlayerStats.new()
    end
    return @playerstats
  end
  
  def mail
    if @mailbox == nil
      @mailbox = MailBox.new()
      @mailbox.personal.push(GearMail.new(
        "Instructions","Welcome to your Mailbox",
        "Welcome to your own mailbox!\n\n" + 
        "Here you can receive and view your mail " + 
        "at any time. You get alerted whenever new " + 
        "mail arrive as well. There are two mail tabs:\n" + 
        "-The 'personal' tab for private mail.\n" +
        "-The 'global' tab for news and such.\n\n" +
        "Please enjoy your mailbox! "))
      @mailbox.global.push(GearMail.new(
        "Rokk News","Global News",
        "Hello Reader,\n\n" +
        "Any important news from us will find their " + 
        "way to your mailbox as soon as possible.\n\n" + 
        "Always stay up to date!\n -The Rokk News Department"))
      @mailbox.global.push(GearMail.new(
        "G.P.O.","East Andes Isle",
        "Important!\n\n" +
        "A burst of energy has been registered at the East Andes Isle. " + 
        "Please refrain from visitting the area until further notice.\n\n" + 
        "Always stay up to date!\n -The Rokk News Department"))
    end
    return @mailbox
  end

  #=============================================================================

  def initialize(name, trainer_type)
    super
    @character_ID          = -1
    @outfit                = 0
    @badges                = []
    @money                 = Settings::INITIAL_MONEY
    @coins                 = 0
    @battle_points         = 0
    @soot                  = 0
    @pokedex               = Pokedex.new
    @has_pokedex           = false
    @has_pokegear          = false
    @has_running_shoes     = false
    @seen_storage_creator  = false
    @mystery_gift_unlocked = false
    @mystery_gifts         = []
    @playerstats           = PlayerStats.new()
    @mailbox               = nil
  end
end
