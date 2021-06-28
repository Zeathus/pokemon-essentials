class PBMoveEffect
  attr_reader :id,:before,:after,:accuracy,:power,:type,:damage,:critical

  def initialize(moveid)
    movedata=load_data("Data/moveeffects.dat")
    @valid = false
    if movedata[moveid]
      @valid = true
      @id = movedata[moveid][0]
      @before = movedata[moveid][1]
      @after = movedata[moveid][2]
      @accuracy = movedata[moveid][3]
      @power = movedata[moveid][4]
      @type = movedata[moveid][5]
      @damage = movedata[moveid][6]
      @critical = movedata[moveid][7]
    end
  end
  
  def isValid?
    return @valid
  end
end

# ----------------------------------
# CUSTOM MOVE CODE
# ----------------------------------
class PokeBattle_Move_FFF < PokeBattle_Move
  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    user=attacker
    target=opponent
    @effectdata = PBMoveEffect.new(@id) if !@effectdata
    before=@effectdata.before
    for i in before
      eval(i)
    end
    ret=super(attacker,opponent,hitnum,alltargets,showanimation)
    return ret
  end
  
  def pbAdditionalEffect(attacker,opponent)
    user=attacker
    target=opponent
    @effectdata = PBMoveEffect.new(@id) if !@effectdata
    after=@effectdata.after
    for i in after
      eval(i)
    end
  end
  
  def pbModifyBaseAccuracy(baseaccuracy,attacker,opponent)
    user=attacker
    target=opponent
    value=baseaccuracy
    @effectdata = PBMoveEffect.new(@id) if !@effectdata
    effects=@effectdata.accuracy
    for i in effects
      eval(i)
    end
    return value
  end
  
  def pbBaseDamageMultiplier(damagemult,attacker,opponent)
    user=attacker
    target=opponent
    value=damagemult
    @effectdata = PBMoveEffect.new(@id) if !@effectdata
    effects=@effectdata.power
    for i in effects
      eval(i)
    end
    return value
  end
  
  def pbModifyDamage(damagemult,attacker,opponent)
    user=attacker
    target=opponent
    value=damagemult
    @effectdata = PBMoveEffect.new(@id) if !@effectdata
    effects=@effectdata.damage
    for i in effects
      eval(i)
    end
    return value
  end
  
  def pbCritialOverride(attacker,opponent)
    user=attacker
    target=opponent
    @effectdata = PBMoveEffect.new(@id) if !@effectdata
    if @effectdata.critical && @effectdata.critical.is_a?(String)
      return eval(@effectdata.critical)
    end
    return false
  end
  
  def pbModifyType(type,attacker,opponent)
    user=attacker
    target=opponent
    @effectdata = PBMoveEffect.new(@id) if !@effectdata
    effects=@effectdata.type
    for i in effects
      eval(i)
    end
    return type
  end
  
end

################################################################################
# CUSTOM MOVE: Hits 2-5 times.
################################################################################
class PokeBattle_Move_FF1 < PokeBattle_Move_FFF
  def pbIsMultiHit
    return true
  end
  
  def pbNumHits(attacker)
    hitchances=[2,2,3,3,4,5]
    ret=hitchances[@battle.pbRandom(hitchances.length)]
    ret=5 if attacker.hasWorkingAbility(:SKILLLINK)
    return ret
  end
end

################################################################################
# CUSTOM MOVE: Hits 2 times.
################################################################################
class PokeBattle_Move_FF2 < PokeBattle_Move_FFF
  def pbIsMultiHit
    return true
  end

  def pbNumHits(attacker)
    return 2
  end
end

################################################################################
# CUSTOM MOVE: Hits 3 times.
################################################################################
class PokeBattle_Move_FF3 < PokeBattle_Move_FFF
  def pbIsMultiHit
    return true
  end

  def pbNumHits(attacker)
    return 3
  end
end

################################################################################
# CUSTOM MOVE: Hits 4 times.
################################################################################
class PokeBattle_Move_FF4 < PokeBattle_Move_FFF
  def pbIsMultiHit
    return true
  end

  def pbNumHits(attacker)
    return 4
  end
end

################################################################################
# CUSTOM MOVE: Hits 5 times.
################################################################################
class PokeBattle_Move_FF5 < PokeBattle_Move_FFF
  def pbIsMultiHit
    return true
  end

  def pbNumHits(attacker)
    return 5
  end
end

################################################################################
# CUSTOM MOVE: Attacks 2 rounds in the future.
################################################################################
class PokeBattle_Move_FF6 < PokeBattle_Move_FFF
  def pbDisplayUseMessage(attacker)
    return 0 if @battle.futuresight
    return super(attacker)
  end

  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    if opponent.effects[PBEffects::FutureSight]>0
      @battle.pbDisplay(_INTL("But it failed!"))
      return -1
    end
    if @battle.futuresight
      # Attack hits
      return super(attacker,opponent,hitnum,alltargets,showanimation)
    end
    # Attack is launched
    pbShowAnimation(@id,attacker,nil,hitnum,alltargets,showanimation)
    opponent.effects[PBEffects::FutureSight]=3
    opponent.effects[PBEffects::FutureSightMove]=@id
    opponent.effects[PBEffects::FutureSightUser]=attacker.pokemonIndex
    opponent.effects[PBEffects::FutureSightUserPos]=attacker.index
    @battle.pbDisplay(_INTL("{1} foresaw an attack!",attacker.pbThis))
    return 0
  end

  def pbShowAnimation(id,attacker,opponent,hitnum=0,alltargets=nil,showanimation=true,damage=nil)
    if @battle.futuresight
      return super(id,attacker,opponent,1,alltargets,showanimation,damage) # Hit opponent anim
    end
    return super(id,attacker,opponent,hitnum,alltargets,showanimation)
  end
end

################################################################################
# Trapping move. Traps for 5 or 6 rounds. Trapped Pokémon lose 1/16 of max HP
# at end of each round.
################################################################################
class PokeBattle_Move_FF7 < PokeBattle_Move_FFF
  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    ret=super(attacker,opponent,hitnum,alltargets,showanimation)
    if opponent.damagestate.calcdamage>0 && !opponent.isFainted? &&
       !opponent.damagestate.substitute
      if opponent.effects[PBEffects::MultiTurn]==0
        opponent.effects[PBEffects::MultiTurn]=5+@battle.pbRandom(2)
        if attacker.hasWorkingItem(:GRIPCLAW)
          opponent.effects[PBEffects::MultiTurn]=(USENEWBATTLEMECHANICS) ? 8 : 6
        end
        opponent.effects[PBEffects::MultiTurnAttack]=@id
        opponent.effects[PBEffects::MultiTurnUser]=attacker.index
        @battle.pbDisplay(_INTL("{1} was trapped in the vortex!",opponent.pbThis))
      end
    end
    return ret
  end
end

################################################################################
# User gains half the HP it inflicts as damage.
################################################################################
class PokeBattle_Move_FF8 < PokeBattle_Move_FFF
  def isHealingMove?
    return USENEWBATTLEMECHANICS
  end

  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    ret=super(attacker,opponent,hitnum,alltargets,showanimation)
    if opponent.damagestate.calcdamage>0
      hpgain=(opponent.damagestate.hplost/2).round
      if opponent.hasWorkingAbility(:LIQUIDOOZE)
        attacker.pbReduceHP(hpgain,true)
        @battle.pbDisplay(_INTL("{1} sucked up the liquid ooze!",attacker.pbThis))
        opponent.pbRegisterKnownAbility
      elsif attacker.effects[PBEffects::HealBlock]==0
        hpgain=(hpgain*1.3).floor if attacker.hasWorkingItem(:BIGROOT)
        attacker.pbRecoverHP(hpgain,true)
        @battle.pbDisplay(_INTL("{1} had its energy drained!",opponent.pbThis))
      end
    end
    return ret
  end
end





