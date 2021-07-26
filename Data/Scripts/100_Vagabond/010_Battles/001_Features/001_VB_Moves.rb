#===============================================================================
# Target's evasion stat changes are ignored from now on. (Miracle Eye)
# Psychic moves have normal effectiveness against the Dark-type target.
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