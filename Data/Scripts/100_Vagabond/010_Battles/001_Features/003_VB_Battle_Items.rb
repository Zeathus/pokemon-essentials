BattleHandlers::AccuracyCalcUserItem.add(:ALLSEEINGTOTEM,
    proc { |item,mods,user,target,move,type|
        next unless move.powderMove?
        mods[:accuracy_multiplier] *= 1.25
    }
)

BattleHandlers::DamageCalcTargetItem.add(:BEETLEBARK,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :BUG
    }
)

BattleHandlers::DamageCalcTargetItem.add(:DARKRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :GRASS
    }
)

BattleHandlers::DamageCalcTargetItem.add(:DRACOSHIELD,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :DRAGON
    }
)

BattleHandlers::DamageCalcTargetItem.add(:ELECTRICRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :ELECTRIC
    }
)

BattleHandlers::DamageCalcTargetItem.add(:FAIRYRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :FAIRY
    }
)

BattleHandlers::DamageCalcTargetItem.add(:FIGHTINGRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :FIGHTING
    }
)

BattleHandlers::DamageCalcTargetItem.add(:HEATMEDALLION,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :FIRE
    }
)

BattleHandlers::DamageCalcTargetItem.add(:FLYINGRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :FLYING
    }
)

BattleHandlers::DamageCalcTargetItem.add(:GHOSTRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :GHOST
    }
)

BattleHandlers::DamageCalcTargetItem.add(:NATURESGUARD,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :GRASS
    }
)

BattleHandlers::DamageCalcTargetItem.add(:GROUNDRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :GROUND
    }
)

BattleHandlers::DamageCalcTargetItem.add(:FROSTBRACELET,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :ICE
    }
)

BattleHandlers::DamageCalcTargetItem.add(:NORMALRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :NORMAL
    }
)

BattleHandlers::DamageCalcTargetItem.add(:POISONRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :POISON
    }
)

BattleHandlers::DamageCalcTargetItem.add(:PSYCHICRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :PSYCHIC
    }
)

BattleHandlers::DamageCalcTargetItem.add(:ROCKRESIST,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :ROCK
    }
)

BattleHandlers::DamageCalcTargetItem.add(:IRONGAUNTLETS,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :STEEL
    }
)

BattleHandlers::DamageCalcTargetItem.add(:OCEANNECKLACE,
    proc { |item,user,target,move,mults,baseDmg,type|
        mults[:final_damage_multiplier] *= 0.8 if type == :WATER
    }
)

BattleHandlers::WeatherExtenderItem.add(:VELVETYROCK,
    proc { |item,weather,duration,battler,battle|
      next 3 if weather == :Winds
    }
)

BattleHandlers::WeightCalcItem.add(:HEAVYSTONE,
    proc { |item,battler,w|
        next [w*2,999].min
    }
)