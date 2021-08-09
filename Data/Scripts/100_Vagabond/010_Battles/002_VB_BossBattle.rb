module PBTrigger
  
  None      = 0  # No effect
  Start     = 1  # Once at the start of battle
  Timed     = 2  # Once after a set amount of turns
  Interval  = 3  # Every time a set amount of turns have passed (optional turn offset)
  HP        = 4  # When the pokemon's HP goes below a certain percent
  Item      = 5  # When the player uses a specific item (or any item if unspecified)
  Damaged   = 6  # When the pokemon takes damage
  Category  = 7  # When the pokemon is hit by a move of a certain category
  Contact   = 8  # When the pokemon is hit by a contact move
  Type      = 9  # When the pokemon is hit by a move of a certain type
  Move      = 10 # When the pokemon is hit by a specific move
  Switch    = 11 # When the player switches out their pokemon
  Weather   = 12 # At end of turn during a certain weather
  Terrain   = 13 # At end of turn during a certain terrain
  Field     = 14 # At end of turn when a certain effect affects the pokemon's side 
  Effect    = 15 # At end of turn when a certain effect affects the pokemon
  Sturdy    = 16 # Prevent HP loss from attacks before this HP
  Status    = 17 # At end of turn if the pokemon is statused
  MoveGroup = 18 # When the pokemon is hit by a group of moves (sound, powder,etc)
  Custom    = 19 # At end of turn if script returns true
  
end


module PBBossEffect
  
  None        = 0  # No effect
  Message     = 1  # Display a message in battle
  Moveset     = 2  # Change the pokemon's moveset
  Moves       = 2
  Item        = 3  # Change the pokemon's held item
  HeldItem    = 3
  Ability     = 4  # Change the pokemon's ability
  Shininess   = 5  # Change the pokemon's shininess
  Shiny       = 5
  Species     = 6  # Change the pokemon's species
  Form        = 7  # Change the pokemon's form
  Nature      = 8  # Change the pokemon's nature
  IV          = 9  # Change the pokemon's IVs
  EV          = 10 # Change the pokemon's EVs
  Type1       = 11 # Change the pokemon's primary type
  Type2       = 12 # Change the pokemon's secondary type
  Type3       = 13 # Change the pokemon's tertiary type
  Level       = 14 # Change the pokemon's level
  StatChange  = 15 # Increase or decrease one of the pokemon's stats
  SetStat     = 16 # Set the stat level for one of the pokemon's stats
  Invincible  = 17 # The pokemon is invincible for a set number of turns
  WinBattle   = 18 # The battle ends as if the player won
  LoseBattle  = 19 # The battle ends as if the player lost
  EndBattle   = 20 # The battle ends with a neutral decision (Run)
  DealDamage  = 21 # Deal a certain amount of damage to the player
  TakeDamage  = 22 # Receive a certain amount of damage
  DealKO      = 23 # Always knocks out the player's pokemon
  DamageParty = 24 # Deals damage to all pokemon in the player's party
  DealStatus  = 25 # Gives the player's active pokemon a status effect (if possible)
  TakeStatus  = 26 # Give the pokemon a specific status effect (if possible)
  HealStatus  = 27 # Heal the pokemon of its status effect
  PlayerStat  = 28 # Increases or decreases the player's stats
  ChangeBG    = 29 # Change the battle background
  Background  = 29
  ChangeMusic = 30 # Change the battle music
  ChangeBGM   = 30
  PlayMusic   = 30
  PlayBGM     = 30
  PlaySound   = 31 # Play a given sound effect
  PlaySE      = 31
  PlayCry     = 32 # Plays the pokemon's cry
  MoveAnim    = 33 # Plays a given move animation
  MoveOut     = 34 # Move out of the screen
  MoveIn      = 35 # Move into the screen
  Weather     = 36 # Sets the weather
  Terrain     = 37 # Sets the terrain
  Field       = 37
  UseMove     = 38 # Use a specific move
  GiveField   = 39 # Toggle effect on the player's side
  TakeField   = 40 # Toggle effect on the pokemon's side
  AddField    = 52 # Toggle effect on the pokemon's side
  GiveEffect  = 41 # Toggle effect on the player's active pokemon
  TakeEffect  = 42 # Toggle effect on the pokemon
  AddEffect   = 51 # Adds a number to one of the pokemon's effects
  Remove      = 43 # Remove effect trigger, to only trigger once
  Phase       = 44 # Deletes current effect list and moves to next phase
  NextPhase   = 44
  Flash       = 45 # Flash the screen, same parameters  as event command
  ScreenFlash = 45
  Shake       = 46 # Shake the screen, same parameters  as event command
  ScreenShake = 46
  ToneChange  = 47 # Change the screen color tone
  ChangeTone  = 47
  ScreenTone  = 47
  Name        = 48 # Change the pokemon's name
  CommonAnim  = 49 # Play a common animation
  Wait        = 50 # Wait some frames
  Custom      = 53 # Write a string to execute
  If          = 54 # Write a string that must return true for effects to trigger
  Condition   = 54
  Speech      = 55 # pbSpeech
  Gauge       = 56 # Accepts negative and positive values, float values do %
  RemoveGauge = 57
  
end

module PBGauge
  Full = 0
  Half = 1
  Long = 2
end


class BossBattle
  
  attr_accessor :triggers  # List of all triggers, which are lists of effects
      # List is structured as such: [[:Trigger, *args],[:Effect, *args]]
  attr_accessor :nextphase # BossBattle object called for new instance effect
  attr_accessor :backdrop  # Current background override
  attr_accessor :outside   # If the pokemon should be outside the screen
  attr_accessor :gauges
  
  def initialize
    
    self.triggers   = []
    self.nextphase  = false
    self.backdrop   = false
    self.outside    = false
    self.gauges     = []
    
  end
  
  
  def clear
    
    self.triggers   = []
    self.nextphase  = false
    self.backdrop   = false
    self.outside    = false
    self.gauges     = []
    
  end
  
  
  def changePokemon(battle, battler, pokemon)
    battle.scene.pbChangePokemon(battler,pokemon)
    if self.outside
      battle.scene.sprites["pokemon1"].x+=24*12
      battle.scene.sprites["shadow1"].x+=24*12
    end
  end
  
  
  def getSturdy
    
    list = []
    
    for t in self.triggers
      if t[0][0]==PBTrigger::Sturdy
        list.push(t[0][1])
      end
    end
    
    return list
    
  end
  
  
  def execute(battle, battler, effect, trigger)
    
    effecttype = effect[0]
    
    # Copy to avoid editting original effect
    effect_copy = []
    for i in 0...effect.length
      effect_copy.push(effect[i])
    end
    effect = effect_copy
    
    # Randomizer
    for i in 1...effect.length
      if effect[i].is_a?(Array)
        effect[i] = effect[i].shuffle[0]
      end
    end
    
    case effecttype
    when PBBossEffect::Message
      message = self.formatMessage(effect[1], battle, battler)
      battle.pbDisplay(message)
    when PBBossEffect::Moveset
      for i in 0...4
        moveid = effect[i+1]
        move = PBMove.new(moveid)
        battler.moves[i]=PokeBattle_Move.new(battle,move)
      end
    when PBBossEffect::HeldItem
      battler.item = effect[1]
    when PBBossEffect::Ability
      battler.ability = effect[1]
    when PBBossEffect::Shininess
      battler.pokemon.shinyflag = effect[1]
      self.changePokemon(battle,battler,battler.pokemon)
    when PBBossEffect::Species
      hp_percent = battler.hp * 1.0 / battler.totalhp
      level = battler.level
      battler.pokemon.species = effect[1]
      battler.species = effect[1]
      battler.pbUpdate(true)
      battler.level = level
      battler.pokemon.level = level
      battler.pbUpdate
      battler.hp = battler.totalhp * hp_percent
      self.changePokemon(battle,battler,battler.pokemon)
    when PBBossEffect::Form
      hp_percent = battler.hp * 1.0 / battler.totalhp
      battler.form = effect[1]
      battler.pbUpdate(true)
      battler.hp = battler.totalhp * hp_percent
      self.changePokemon(battle,battler,battler.pokemon)
    when PBBossEffect::Nature
      battler.pokemon.natureflag = effect[1]
      hp_percent = battler.hp * 1.0 / battler.totalhp
      battler.pbUpdate
      battler.hp = battler.totalhp * hp_percent
    when PBBossEffect::IV
      for i in 0...6
        battler.pokemon.iv[i] = effect[i+1]
        battler.pokemon.oiv[i] = effect[i+1]
        battler.iv[i] = effect[i+1]
        battler.oiv[i] = effect[i+1]
      end
      hp_percent = battler.hp * 1.0 / battler.totalhp
      battler.pbUpdate
      battler.hp = battler.totalhp * hp_percent
    when PBBossEffect::EV
      for i in 0...6
        battler.pokemon.ev[i] = effect[i+1]
      end
      hp_percent = battler.hp * 1.0 / battler.totalhp
      battler.pbUpdate
      battler.hp = battler.totalhp * hp_percent
    when PBBossEffect::Type1
      battler.type1 = effect[1]
    when PBBossEffect::Type2
      battler.type2 = effect[1]
    when PBBossEffect::Type3
      battler.effects[PBEffects::Type3] = effect[1]
    when PBBossEffect::Level
      if effect[1] + battler.pokemon.level > 100
        battler.pokemon.level = 100
        battler.level = 100
      elsif effect[1] + battler.pokemon.level < 1
        battler.pokemon.level = 1
        battler.level = 1
      else
        battler.pokemon.level += effect[1]
        battler.level += effect[1]
      end
      hp_percent = battler.hp * 1.0 / battler.totalhp
      battler.pbUpdate
      battler.hp = battler.totalhp * hp_percent
    when PBBossEffect::StatChange
      if effect[2] > 0
        battler.pbRaiseStatStage(effect[1],effect[2],battler)
      elsif effect[2] < 0
        battler.pbLowerStatStage(effect[1],-effect[2],battler)
      else
        battler.stages[effect[1]]=effect[2]
      end
    when PBBossEffect::SetStat
      battler.stages[effect[1]]=effect[2]
    when PBBossEffect::Invincible
      # TODO
    when PBBossEffect::WinBattle
      battle.decision = 1
    when PBBossEffect::LoseBattle
      battle.decision = 2
    when PBBossEffect::EndBattle
      battle.decision = 3
    when PBBossEffect::DealDamage
      target = battler.pbOppositeOpposing
      if !target.isFainted?
        losehp = effect[1]
        if effect[1] % 1 != 0 # Treat as percentage
          losehp *= target.totalhp
        end
        losehp = target.hp if losehp > target.hp
        battle.scene.pbDamageAnimation(target,0)
        target.pbReduceHP(losehp)
      end
    when PBBossEffect::TakeDamage
      if !battler.isFainted?
        losehp = effect[1]
        if effect[1] % 1 != 0 # Treat as percentage
          losehp *= battler.totalhp
        end
        losehp = battler.hp if losehp > battler.hp
        battle.scene.pbDamageAnimation(battler,0)
        battler.pbReduceHP(losehp)
      end
    when PBBossEffect::DealKO
      target = battler.pbOppositeOpposing
      if !target.isFainted?
        losehp = target.hp
        battle.scene.pbDamageAnimation(target,0)
        target.pbReduceHP(losehp)
        target.pbFaint
      end
    when PBBossEffect::DamageParty
      target = battler.pbOppositeOpposing
      for i in 0...6
        if $Trainer.party[i] && i != target.pokemonIndex
          pkmn = $Trainer.party[i]
          losehp = effect[1]
          if losehp % 1 != 0 # Treat as percentage
            losehp *= pkmn.totalhp
          end
          losehp = pkmn.hp if losehp > pkmn.hp
          pkmn.hp -= losehp
        end
      end
    when PBBossEffect::DealStatus
      target = battler.pbOppositeOpposing
      case effect[1]
      when PBStatuses::POISON
        if target.pbCanPoison?(battler,(effect.length==3 && effect[2]))
          target.pbPoison(battler)
        end
      when PBStatuses::PARALYSIS
        if target.pbCanParalyze?(battler,(effect.length==3 && effect[2]))
          target.pbParalyze(battler)
        end
      when PBStatuses::SLEEP
        if target.pbCanSleep?(battler,(effect.length==3 && effect[2]))
          target.pbSleep(battler)
        end
      when PBStatuses::FROZEN
        if target.pbCanFreeze?(battler,(effect.length==3 && effect[2]))
          target.pbFreeze(battler)
        end
      when PBStatuses::BURN
        if target.pbCanBurn?(battler,(effect.length==3 && effect[2]))
          target.pbBurn(battler)
        end
      end
    when PBBossEffect::TakeStatus
      battler.status = effect[1]
    when PBBossEffect::HealStatus
      battler.status = 0
    when PBBossEffect::PlayerStat
      target = battler.pbOppositeOpposing
      if effect[2] > 0
        target.pbIncreaseStat(effect[1],effect[2],battler,true)
      elsif effect[2] < 0
        target.pbReduceStat(effect[1],-effect[2],battler,true)
      else
        target.stages[effect[1]]=effect[2]
      end
    when PBBossEffect::ChangeBG
      self.backdrop = effect[1]
      battle.scene.pbBackdrop(backdrop)
    when PBBossEffect::ChangeMusic
      if effect.length==4
        pbBGMPlay(effect[1], effect[2], effect[3])
      elsif effect.length==3
        pbBGMPlay(effect[1], effect[2])
      else
        pbBGMPlay(effect[1])
      end
    when PBBossEffect::PlaySound
      pbSEPlay(effect[1])
    when PBBossEffect::PlayCry
      pbPlayCry(battler.species)
    when PBBossEffect::MoveAnim
      target = battler.pbOppositeOpposing
      battle.pbAnimation(effect[1],battler,target)
    when PBBossEffect::MoveOut
      12.times do
        battle.scene.sprites["pokemon1"].x+=24
        battle.scene.sprites["shadow1"].x+=24
        Graphics.update
        Input.update
        pbWait(1)
      end
      self.outside = true
    when PBBossEffect::MoveIn
      12.times do
        battle.scene.sprites["pokemon1"].x-=24
        battle.scene.sprites["shadow1"].x-=24
        Graphics.update
        Input.update
        pbWait(1)
      end
      self.outside = false
    when PBBossEffect::Weather
      battle.weather = effect[1]
      battle.weatherduration = effect[2]
      case effect[1]
      when PBWeather::SUNNYDAY
        battle.pbCommonAnimation("Sunny",nil,nil)
      when PBWeather::RAINDANCE
        battle.pbCommonAnimation("Rain",nil,nil)
      when PBWeather::HAIL
        battle.pbCommonAnimation("Hail",nil,nil)
      when PBWeather::WINDS
        battle.pbCommonAnimation("Winds",nil,nil)
      when PBWeather::SANDSTORM
        battle.pbCommonAnimation("Sandstorm",nil,nil)
      end
    when PBBossEffect::Terrain
      effect[1] = getID(PBEffects,effect[1]) if effect[1].is_a?(Symbol)
      battle.field.effects[PBEffects::ElectricTerrain]=0
      battle.field.effects[PBEffects::GrassyTerrain]=0
      battle.field.effects[PBEffects::MistyTerrain]=0
      battle.field.effects[PBEffects::PsychicTerrain]=0
      battle.field.effects[effect[1]] = effect[2]
      battle.scene.pbBackdrop(backdrop)
    when PBBossEffect::UseMove
      moveid = effect[1]
      movedata = PBMove.new(moveid)
      move = PokeBattle_Move.pbFromPBMove(battle,movedata)
      choices = [1, i, move, -1]
      battler.pbUseMove(choices, false, true)
    when PBBossEffect::GiveField
      effect[1] = getID(PBEffects,effect[1]) if effect[1].is_a?(Symbol)
      target = battler.pbOppositeOpposing
      target.pbOwnSide.effects[effect[1]]=effect[2]
    when PBBossEffect::TakeField
      effect[1] = getID(PBEffects,effect[1]) if effect[1].is_a?(Symbol)
      battler.pbOwnSide.effects[effect[1]]=effect[2]
    when PBBossEffect::AddField
      effect[1] = getID(PBEffects,effect[1]) if effect[1].is_a?(Symbol)
      battler.pbOwnSide.effects[effect[1]]+=effect[2]
    when PBBossEffect::GiveEffect
      effect[1] = getID(PBEffects,effect[1]) if effect[1].is_a?(Symbol)
      target = battler.pbOppositeOpposing
      target.effects[effect[1]]=effect[2]
    when PBBossEffect::TakeEffect
      effect[1] = getID(PBEffects,effect[1]) if effect[1].is_a?(Symbol)
      battler.effects[effect[1]]=effect[2]
    when PBBossEffect::AddEffect
      effect[1] = getID(PBEffects,effect[1]) if effect[1].is_a?(Symbol)
      battler.effects[effect[1]]+=effect[2]
    when PBBossEffect::Remove
      for i in self.triggers
        if trigger.length == i[0].length
          same = true
          for j in 0...trigger.length
            same = false if trigger[j] != i[0][j]
          end
          if same
            i[1][0] = PBBossEffect::None
          end
        end
      end
    when PBBossEffect::Phase
      $game_variables[BOSS_BATTLE]=self.nextphase
    when PBBossEffect::Flash
      # TODO
    when PBBossEffect::Shake
      # TODO
    when PBBossEffect::ChangeTone
      # TODO
    when PBBossEffect::Name
      battler.name = effect[1]
    when PBBossEffect::CommonAnim
      if effect[1].is_a?(Symbol) || effect[1].is_a?(Numeric)
        effect[1] = PBMoves.getName(effect[1])
        while effect[1].include?(" ")
          effect[1].gsub!(" ","")
        end
      end
      battle.pbCommonAnimation(effect[1],battler,nil)
    when PBBossEffect::Wait
      pbWait(effect[1])
    when PBBossEffect::Custom
      boss = battler
      player = battler.pbOppositeOpposing
      eval(effect[1])
      return true
    when PBBossEffect::If
      ret = false
      boss = battler
      player = battler.pbOppositeOpposing
      eval("ret = (" + effect[1] + ")")
      return ret
    when PBBossEffect::Speech
      pbSpeech(effect[1],effect[2],effect[3])
    when PBBossEffect::Gauge
      id = effect[1]
      return if !@gauges[id]
      value = @gauges[id][2]
      old_value = value
      max = @gauges[id][3]
      if effect[2] % 1 == 0
        value += effect[2]
        value = 0 if value < 0
        value = max if value > max
      else
        value += effect[2] * max
        value = 0 if value < 0
        value = max if value > max
      end
      if old_value > value
        while @gauges[id][2] > value
          @gauges[id][2] -= 1
          battle.scene.pbRefresh
          Graphics.update
          Input.update
        end
      elsif old_value < value
        while @gauges[id][2] < value
          @gauges[id][2] += 1
          battle.scene.pbRefresh
          Graphics.update
          Input.update
        end
      end
      battle.scene.pbRefresh
      if @gauges[id][2] == max && old_value != max
        for eff in @gauges[id][7]
          self.execute(battle, battler, eff, trigger)
        end
      elsif @gauges[id][2] == 0 && old_value != 0
        for eff in @gauges[id][6]
          self.execute(battle, battler, eff, trigger)
        end
      end
    when PBBossEffect::RemoveGauge
      @gauges[effect[1]]=false
      battle.scene.pbRefresh
    end
    
    return true
    
  end
  
  
  def formatMessage(message, battle, pokemon)
    
    message = message + ""
    
    # Player name
    while message.include?("PLAYER")
      message.gsub!("PLAYER",$Trainer.name)
    end
    # The enemy pokemon's name
    while message.include?("NAME")
      message.gsub!("NAME",pokemon.name)
    end
    # The enemy pokemon's types
    while message.include?("TYPE1")
      type = PBTypes.getName(pokemon.type1)
      message.gsub!("TYPE1",type)
    end
    while message.include?("TYPE2")
      type = PBTypes.getName(pokemon.type2)
      message.gsub!("TYPE2",type)
    end
    while message.include?("TYPE3")
      type = PBTypes.getName(pokemon.effects[PBEffects::Type3])
      message.gsub!("TYPE3",type)
    end
    
    return message
    
  end
  
  
  def checkTrigger(battle, pokemon, triggertype, value=false)
    
    triggertype = getID(PBTrigger, triggertype) if triggertype.is_a?(Symbol)
    
    for i in self.triggers
      t = i[0] # The trigger, not the entire effect list
      
      # Check if triggertype matches
      if t[0]==triggertype
        # Execute if conditions are met
        if self.canTrigger(t, value)
          if !self.execute(battle, pokemon, i[1], t)
            return
          end
        end
      end
    end
    
  end
  
  
  def canTrigger(t, value)
    # t = trigger
    triggertype = t[0]
    
    case triggertype
    when PBTrigger::Start
      # Start is only called at start of battle and always activates
      return true
    when PBTrigger::Timed
      # value = current turn count
      return true if t[1]==value
    when PBTrigger::Interval
      # value = current turn count
      if t.length == 3 # if it has an offset
        if (value - t[2]) % t[1] == 0
          return true
        end
      else # no offset
        return true if (value % t[1]) == 0
      end
    when PBTrigger::HP
      # value = pokemon object
      if (value.hp * 100.0 / value.totalhp).ceil <= t[1]
        return true
      end
    when PBTrigger::Item
      # value = item used
      if t.length == 2 # Requires specific item
        return true if t[1] == value
      else # any item
        return true
      end
    when PBTrigger::Damaged
      # value = damage taken
      if t.length == 2 # Minimum damage taken
        return true if value > t[1]
      else # any damage taken
        return true
      end
    when PBTrigger::Category
      # value = move.category
      return true if t[1] == value
    when PBTrigger::Contact
      # Always triggers when hit by contact move
      return true
    when PBTrigger::Type
      # value = move.type
      return true if t[1] == value
    when PBTrigger::Move
      # value = moveid
      return true if t[1] == value
    when PBTrigger::Switch
      # Always called when switching
      return true
    when PBTrigger::Weather
      # value = current weather
      if t.length==3
        return true if t[1] == t[2]
      else
        return true if t[1] == value
      end
    when PBTrigger::Terrain
      # value = pbField.effects
      t[1] = getID(PBEffects,t[1]) if t[1].is_a?(Symbol)
      if t.length==3
        return true if (value[t[1]]>0) == t[2]
      else
        return true if value[t[1]]>0
      end
    when PBTrigger::Field
      # value = pokemon.pbOwnSide.effects
      t[1] = getID(PBEffects,t[1]) if t[1].is_a?(Symbol)
      if t.length == 3 # Specifies on/off
        if value[t[1]].is_a?(Numeric) # Is a number
          return true if (value[t[1]] > 0)==t[2]
        else # probably a boolean
          return true if value[t[1]]==t[2]
        end
      else # only checks on
        if value[t[1]].is_a?(Numeric) # Is a number
          return true if value[t[1]] > 0
        else # probably a boolean
          return true if value[t[1]]
        end
      end
    when PBTrigger::Effect
      # value = pokemon.effects
      t[1] = getID(PBEffects,t[1]) if t[1].is_a?(Symbol)
      if t.length == 3 # Specifies on/off
        if value[t[1]].is_a?(Numeric) # Is a number
          return true if (value[t[1]] > 0)==t[2]
        else # probably a boolean
          return true if value[t[1]]==t[2]
        end
      else # only checks on
        if value[t[1]].is_a?(Numeric) # Is a number
          return true if value[t[1]] > 0
        else # probably a boolean
          return true if value[t[1]]
        end
      end
    when PBTrigger::Status
      # value = pokemon.status
      if t.length == 1
        return true if value > 0
      else
        if t.length == 3 # Specifies on/off
          return true if (value == t[1]) == t[2]
        else # only checks on
          return true if value == t[1]
        end
      end
    when PBTrigger::MoveGroup
      # value = [move,attacker]
      move = value[0]
      attacker = value[1]
      case t[1].downcase
      when "multipletargets" # Dazzling Gleam / Earthquake
        return move.pbTargetsMultiple?(attacker)
      when "alltargets" # Earthquake
        return move.target==PBTargets::AllNonUsers
      when "priority" # More than 0 priority, Quick Attack
        return move.pbPriority(attacker) > 0
      when "-priority" # Negative priority, Storm Throw
        return move.pbPriority(attacker) < 0
      when "multihit" # Moves that hit more than once, 2-5 hits, etc.
        return move.pbIsMultiHit
      when "recoil" # Recoil moves, Take Down
        return move.isRecoilMove?
      when "gravity" # Can't be used in gravity, Fly, Bounce
        return move.unusableInGravity?
      when "canmirrormove" # Can be used by mirror move
        return move.canMirrorMove?
      when "canmagiccoat" # Can be reversed by magic coat
        return move.canMagicCoat?
      when "cansnatch" # Can be stolen by snatch
        return move.canSnatch?
      when "highcrit" # Has high crit rate
        return move.hasHighCriticalRate?
      when "biting" # Is a biting move, Fire Fang
        return move.isBitingMove?
      when "punching" # Is a punching move, Thunder Punch
        return move.isPunchingMove?
      when "sound" # Is a sound move, Uproar
        return move.isSoundBased?
      when "powder" # Is a powder move, Sleep Powder
        return move.isPowderMove?
      when "pulse" # Is a pulse move, Water Pulse, Aura Sphere
        return move.isPulseMove?
      when "bomb" # Is a bomb move, Sludge Bomb
        return move.isBombMove?
      when "trample" # Always hits minimize
        return move.tramplesMinimize?
      when "beam" # Is a beam move
        return move.isBeamMove?
      when "dance" # Is a dance move
        return move.isDanceMove?
      end
    when PBTrigger::Custom
      ret = false
      battle = value[0]
      boss = value[1]
      player = boss.pbOppositeOpposing
      eval("ret = (" + t[1] + ")")
      return ret
    end
    
    return false
  end
  
  
  def add(*arg)
    
    trigger = arg[0]
    
    trigger[0] = getID(PBTrigger,trigger[0]) if trigger[0].is_a?(Symbol)
    
    if arg.length>1
      for i in 1...arg.length
        arg[i][0] = getID(PBBossEffect,arg[i][0]) if arg[i][0].is_a?(Symbol)
      end
    end
    
    case trigger[0]
    # No arguments
    when PBTrigger::Start, PBTrigger::Damaged, PBTrigger::Contact,
         PBTrigger::Switch
      if trigger.length != 1
        raise ArgumentError.new(
          _INTL("\n\nWrong number of arguments for boss trigger\n"))
      end
    # 0-1 arguments
    when PBTrigger::Item
      if trigger.length > 2
        raise ArgumentError.new(
          _INTL("\n\nWrong number of arguments for boss trigger\n"))
      end
    # 1 argument
    when PBTrigger::Timed, PBTrigger::HP, PBTrigger::Category,
         PBTrigger::Type, PBTrigger::Move, PBTrigger::Sturdy,
         PBTrigger::MoveGroup
      if trigger.length != 2
        raise ArgumentError.new(
          _INTL("\n\nWrong number of arguments for boss trigger\n"))
      end
    # 1-2 arguments
    when PBTrigger::Interval, PBTrigger::Weather, PBTrigger::Terrain,
         PBTrigger::Effect, PBTrigger::Field
      if trigger.length > 3 || trigger.length < 2
        raise ArgumentError.new(
          _INTL("\n\nWrong number of arguments for boss trigger\n"))
      end
      if trigger[0] == PBTrigger::Terrain || trigger[0] == PBTrigger::Effect
        trigger[1] = getID(PBEffects,trigger[1]) if trigger[1].is_a?(Symbol)
      end
    end
    
    if arg.length==1
      arg[1]=[PBBossEffect::None]
    end
    
    for i in 1...arg.length
      self.triggers.push([trigger, arg[i]])
    end
    
  end
  
  
  def addGauge(type, name, max, color, start=false)
    type = getID(PBGauge,type) if type.is_a?(Symbol)
    
    if color.is_a?(String)
      color = color.downcase
      if color == "hp"
      elsif color == "red"
        color = Color.new(255,0,0)
        color2 = Color.new(200,0,0)
      elsif color == "blue"
        color = Color.new(0,0,255)
        color2 = Color.new(0,0,200)
      elsif color == "green"
        color = Color.new(0,255,0)
        color2 = Color.new(0,200,0)
      else
        color = Color.new(255,255,255)
        color2 = Color.new(200,200,200)
      end
    elsif !color2
      red = color.red - 50
      green = color.green - 50
      blue = color.blue - 50
      red = 0 if red < 0
      green = 0 if green < 0
      blue = 0 if blue < 0
      color2 = Color.new(red, green, blue)
    end
    
    start = max if !start
    
    @gauges.push([type, name, start, max, color, color2, [], []])
    
  end
  
  def addGaugeEffect(id,type,effect)
    effect[0] = getID(PBBossEffect,effect[0]) if effect[0].is_a?(Symbol)
    @gauges[id][6+type].push(effect)
  end
  
  
  def phase
    
    if !self.nextphase
      self.nextphase = BossBattle.new
    end
    return self.nextphase
    
  end
  
  def phase=(value)
    
      self.nextphase = value
    
  end
  
end


def pbBoss
  if $game_variables[BOSS_BATTLE].is_a?(Numeric)
    $game_variables[BOSS_BATTLE] = BossBattle.new
  end
  return $game_variables[BOSS_BATTLE]
end

def pbBossTrigger(battle, pokemon, triggertype, value=false)
  return false if !pokemon.opposes?
  return false if pokemon.fainted?
  triggertype = getID(PBTrigger, triggertype) if triggertype.is_a?(Symbol)
  if !$game_variables[BOSS_BATTLE].is_a?(Numeric)
    pbBoss.checkTrigger(battle, pokemon, triggertype, value)
    return true
  end
end









