################################################################################
# Type depends on the user's Personality ID.
# Boosts two stats based on Personality ID. (Diversity - Spinda)
################################################################################
class PokeBattle_Move_E00 < PokeBattle_Move
  def pbModifyType(type,attacker,opponent)
    types = [
      PBTypes::NORMAL,
      PBTypes::FIRE,
      PBTypes::WATER,
      PBTypes::GRASS,
      PBTypes::ICE,
      PBTypes::STEEL,
      PBTypes::ROCK,
      PBTypes::GROUND,
      PBTypes::FAIRY,
      PBTypes::FIGHTING,
      PBTypes::BUG,
      PBTypes::FLYING,
      PBTypes::DRAGON,
      PBTypes::GHOST,
      PBTypes::DARK,
      PBTypes::PSYCHIC,
      PBTypes::ELECTRIC,
      PBTypes::POISON
    ]
    id=attacker.pokemon.personalID
    type=types[(id % 256) % 18]
    Kernel.pbMessage(PBTypes.getName(type)) if $DEBUG && Input.press?(Input::CTRL)
    return type
  end
  
  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    ret=super(attacker,opponent,hitnum,alltargets,showanimation)
    if opponent.damagestate.calcdamage>0
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


################################################################################
# On first use, stores battle state.
# On second use, loads battle state to effectively turn back time.
# (Celebi)
################################################################################
class PokeBattle_Move_E01 < PokeBattle_Move
  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    
    if @battle.field.effects[PBEffects::BattleState]
      @battle.pbDisplay("LOAD")
      state=@battle.field.effects[PBEffects::BattleState]
      @battle.party1=state[0]
      @battle.party2=state[1]
      @battle.party1order=state[2]
      @battle.party2order=state[3]
      @battle.battlers=state[4]
      @battle.weather=state[5]
      @battle.weatherduration=state[6]
      @battle.field=state[7]
      @battle.sides=state[8]
      @battle.scene.refresh
      @battle.scene.update
    else
      @battle.pbDisplay("SAVE")
      @battle.field.effects[PBEffects::BattleState]=[
        Marshal.load(Marshal.dump(@battle.party1)),
        Marshal.load(Marshal.dump(@battle.party2)),
        Marshal.load(Marshal.dump(@battle.party1order)),
        Marshal.load(Marshal.dump(@battle.party2order)),
        Marshal.load(Marshal.dump(@battle.battlers)),
        @battle.weather,
        @battle.weatherduration,
        Marshal.load(Marshal.dump(@battle.field)),
        Marshal.load(Marshal.dump(@battle.sides))]
    end
    
    #if attacker.pbOpposingSide.effects[PBEffects::ToxicSpikes]>=2
    #  @battle.pbDisplay(_INTL("But it failed!"))
    #  return -1
    #end
    #pbShowAnimation(@id,attacker,nil,hitnum,alltargets,showanimation)
    #attacker.pbOpposingSide.effects[PBEffects::ToxicSpikes]+=1
    #if !@battle.pbIsOpposing?(attacker.index)
    #  @battle.pbDisplay(_INTL("Poison spikes were scattered all around the opposing team's feet!"))
    #else
    #  @battle.pbDisplay(_INTL("Poison spikes were scattered all around your team's feet!"))
    #end
    #return 0
  end
end