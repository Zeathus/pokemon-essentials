#===============================================================================
# Target steel type becomes susceptible to Poison-type moves (Corrosive Acid)
#===============================================================================
class PokeBattle_Move_300 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if target.effects[PBEffects::CorrosiveAcid] ||
      !target.pbHasType(:STEEL)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    target.effects[PBEffects::CorrosiveAcid] = true
    @battle.pbDisplay(_INTL("{1} became susceptible to Poison-type moves!",target.pbThis))
  end
end

#===============================================================================
# Starts windy weather. (Winds)
#===============================================================================
class PokeBattle_Move_301 < PokeBattle_WeatherMove
  def initialize(battle,move)
    super
    @weatherType = :Winds
  end
end

################################################################################
# Type depends on the user's Personality ID.
# Boosts up to two stats based on Personality ID. (Diversity)
# Exclusive to Spinda
################################################################################
class PokeBattle_Move_302 < PokeBattle_Move
  # This move definitely does not work right now
  def pbModifyType(type,attacker,opponent)
    types = [
      :NORMAL,
      :FIRE,
      :WATER,
      :GRASS,
      :ICE,
      :STEEL,
      :ROCK,
      :GROUND,
      :FAIRY,
      :FIGHTING,
      :BUG,
      :FLYING,
      :DRAGON,
      :GHOST,
      :DARK,
      :PSYCHIC,
      :ELECTRIC,
      :POISON
    ]
    id=attacker.pokemon.personalID
    type=types[(id % 256) % 18]
    pbMessage(PBTypes.getName(type)) if $DEBUG && Input.press?(Input::CTRL)
    return type
  end
  
  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    ret=super(attacker,opponent,hitnum,alltargets,showanimation)
    if opponent.damageState.calcDamage>0
      id=attacker.pokemon.personalID
      stat1=((id>>24)&255)%5+1
      stat2=((id>>8)&255)%5+1
      showanim=true
      if stat1==stat2
        if attacker.pbCanReduceStatStage?(stat1,attacker,false,self)
          attacker.pbReduceStat(stat1,2,attacker,false,self,showanim)
          showanim=false
        end
      else
        if attacker.pbCanReduceStatStage?(stat1,attacker,false,self)
          attacker.pbReduceStat(stat1,1,attacker,false,self,showanim)
          showanim=false
        end
        if attacker.pbCanReduceStatStage?(stat2,attacker,false,self)
          attacker.pbReduceStat(stat2,1,attacker,false,self,showanim)
          showanim=false
        end
      end
    end
    return ret
  end
end

#===============================================================================
# Grants a side effect if affinity boosted.
# Effect is determined by the move's type. (Boost Moves)
#===============================================================================
class PokeBattle_Move_303 < PokeBattle_Move

  def pbBaseDamage(baseDmg,user,target)
    return baseDmg if @type != :NORMAL || !(user.affinitybooster || user.effects[PBEffects::HelpingHand])
    return baseDmg * 1.5
  end

  def pbEffectAfterAllHits(user,target)
    return if user.fainted?
    return if target.damageState.unaffected
    return if !(user.affinitybooster || user.effects[PBEffects::HelpingHand])
    weather = pbGetTypeWeather(@type)
    if weather
      if !([:HarshSun, :HeavyRain, :StrongWinds, weather].include?(@battle.field.weather))
        @battle.pbStartWeather(user, weather, true, false, 2)
      end
      return
    end
    terrain = pbGetTypeTerrain(@type)
    if terrain
      if @battle.field.terrain != terrain
        @battle.pbStartTerrain(user, terrain, true, 2)
      end
      return
    end
    stat = pbGetTypeRaiseStat(@type)
    if stat
      if user.pbCanRaiseStatStage?(stat, user, self)
        user.pbRaiseStatStage(stat, 1, user)
      end
      return
    end
  end

  def pbEffectAgainstTarget(user,target)
    return if target.fainted? || target.damageState.substitute
    return if !(user.affinitybooster || user.effects[PBEffects::HelpingHand])
    stat = pbGetTypeLowerStat(@type)
    if target.pbCanLowerStatStage?(stat, user, self)
      target.pbLowerStatStage(stat, 1, user)
    end
  end

  def pbGetTypeWeather(type)
    case @type
    when :FIRE
      return :Sun
    when :WATER
      return :Rain
    when :ICE
      return :Hail
    when :ROCK
      return :Sandstorm
    when :FLYING
      return :Winds
    end
    return nil
  end

  def pbGetTypeTerrain(type)
    case @type
    when :GRASS
      return :Grassy
    when :ELECTRIC
      return :Electric
    when :FAIRY
      return :Misty
    when :PSYCHIC
      return :Psychic
    end
    return nil
  end

  def pbGetTypeRaiseStat(type)
    case @type
    when :FIGHTING
      return :ATTACK
    when :STEEL
      return :DEFENSE
    when :POISON
      return :SPECIAL_ATTACK
    when :GROUND
      return :SPECIAL_DEFENSE
    end
    return nil
  end

  def pbGetTypeLowerStat(type)
    case @type
    when :DRAGON
      return :ATTACK
    when :GHOST
      return :DEFENSE
    when :BUG
      return :SPECIAL_ATTACK
    when :DARK
      return :SPECIAL_DEFENSE
    end
    return nil
  end
end