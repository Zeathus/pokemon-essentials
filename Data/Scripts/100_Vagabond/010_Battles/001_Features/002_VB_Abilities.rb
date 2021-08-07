BattleHandlers::PriorityChangeAbility.add(:HASTE,
  proc { |ability,battler,move,pri|
    next pri+1 if battler.turnCount <= 1
  }
)

BattleHandlers::CertainSwitchingUserAbility.add(:RUNAWAY,
  proc { |ability,switcher,battle|
    next true
  }
)

BattleHandlers::EOREffectAbility.add(:EVERLASTING,
  proc { |ability,battler,battle|
    if battler.species == :SHEDINJA_R
      if battler.form == 1 && battler.turnCount > battler.effects[PBEffects::EverlastingFainted]
        battler.pbChangeForm(0,_INTL("{1} returned to its original form!", battler.pbThis))
      end
    end
  }
)

BattleHandlers::EOREffectAbility.add(:TWILIGHT,
  proc { |ability,battler,battle|
    if pbDualFormPokemon.include?(battler.species)
      battler.pbChangeForm(battler.form==0 ? 1 : 0,
        _INTL("{1} returned to its original form!", battler.pbThis))
    end
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:ILLUMINATE,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:base_damage_multiplier] /= 2 if type == :DARK
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:DIVIDE,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:final_damage_multiplier] /= 2
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:LUNARPOWER,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if user.battle.field.terrain == :Misty
      mults[:defense_multiplier] *= 1.5
    end
  }
)

BattleHandlers::DamageCalcUserAbility.copy(:HUGEPOWER,:MULTIPLY)

BattleHandlers::AbilityOnSwitchIn.add(:ZEPHYR,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Winds, battler, battle)
  }
)