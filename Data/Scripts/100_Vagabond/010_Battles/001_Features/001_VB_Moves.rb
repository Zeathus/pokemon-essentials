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