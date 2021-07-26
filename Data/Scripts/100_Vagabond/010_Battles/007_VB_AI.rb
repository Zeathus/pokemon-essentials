class PokeBattle_Battle
  
    def pbGetEffectScore(move,damage,attacker,target,actionable,fainted,chosen=false)
      score = 0
      
      return 0 if move.pbMoveFailed(attacker,target)
      
      ### Get opponent statistics
      opponent1 = attacker.pbOppositeOpposing
      opponent1 = false if !opponent1 || opponent1.isFainted?
      opponent2 = attacker.pbOppositeOpposing2
      opponent2 = false if !opponent2 || opponent2.isFainted?
      
      physical_opponents = 0
      special_opponents = 0
      status_opponents = 0
      opponent_speeds = []
      
      unnerve = !((!opponent1 || !opponent1.hasActiveAbility?(:UNNERVE)) &&
                  (!opponent2 || !opponent2.hasActiveAbility?(:UNNERVE)))
      
      if opponent1
        opponent_speeds.push(opponent1.pbSpeed)
        has_physical = false
        has_special = false
        has_status = false
        for m in opponent1.moves
          if m.pbIsPhysical?(m.type)
            has_physical = true if m.basedamage > 40
          elsif m.pbIsSpecial?(m.type)
            has_special = true if m.basedamage > 40
          else
            has_status = true
          end
        end
        physical_opponents += 1 if has_physical
        special_opponents += 1 if has_special
        status_opponents += 1 if has_status
      end
      
      if opponent2
        opponent_speeds.push(opponent2.pbSpeed)
        has_physical = false
        has_special = false
        has_status = false
        for m in opponent2.moves
          if m.pbIsPhysical?(m.type)
            has_physical = true if m.basedamage > 40
          elsif m.pbIsSpecial?(m.type)
            has_special = true if m.basedamage > 40
          else
            has_status = true
          end
        end
        physical_opponents += 1 if has_physical
        special_opponents += 1 if has_special
        status_opponents += 1 if has_status
      end
      
      target_has_physical = false
      target_has_special = false
      target_has_status = false
      target_speed = 0
      target_item = 0
      if target
        if target.knownItem
          if target.hasActiveItem?(:AEGISTALISMAN)
            target_item = :AEGISTALISMAN
          end
        end
        target_speed = target.pbSpeed
        for m in target.moves
          if m.pbIsPhysical?(m.type)
            target_has_physical = true if m.basedamage > 40
          elsif m.pbIsSpecial?(m.type)
            target_has_special = true if m.basedamage > 40
          else
            target_has_status = true
          end
        end
      end
      
      
      ## Get attacker statistics
      speed_stat = attacker.pbSpeed
      has_physical = false
      has_special = false
      has_status = false
      for m in attacker.moves
        if m.pbIsPhysical?(m.type)
          has_physical = true if m.basedamage > 40
        elsif m.pbIsSpecial?(m.type)
          has_special = true if m.basedamage > 40
        else
          has_status = true
        end
      end
      
      partner = (attacker.pbPartner && !attacker.pbPartner.isFainted?) ? attacker.pbPartner : false
      
      ally_speeds = [speed_stat]
      ally_speeds.push(partner.pbSpeed) if partner
      
      moldbreaker = attacker.hasActiveAbility?(:MOLDBREAKER)
      
      if target
        # Try to destroy balloons
        if target.hasActiveItem?(:AIRBALLOON) &&
           (move.pbIsPhysical?(move.type) || move.pbIsSpecial?(move.type))
          score += 10
        end
        
        # Try to trigger weakening abilities
        if target.hasActiveAbility?(:DEFEATIST) ||
           target.hasActiveAbility?(:WIMPOUT) ||
           target.hasActiveAbility?(:EMERGENCYEXIT)
          if target.hp > target.totalhp * 0.5 && (target.hp - damage) < target.totalhp * 0.5
            score += 20
          end
        end
        if target.hasActiveAbility?(:SCHOOLING)
          if target.hp > target.totalhp * 0.25 && (target.hp - damage) < target.totalhp * 0.25
            score += 20
          end
        end
        
        if move.isContactMove?
          # Reduce score for recoil
          if target.hasActiveAbility?(:ROUGHSKIN) ||
             target.hasActiveAbility?(:IRONBARBS)
            score -= 5
          end
          if target.hasActiveItem?(:ROCKYHELMET)
            score -= 10
          end
        end
      end
      
      # Try to use a Gem to activate Unburden
      if attacker.hasActiveAbility?(:UNBURDEN)
        if (move.type == PBTypes::NORMAL && attacker.hasActiveItem?(:NORMALGEM)) ||
           (move.type == PBTypes::FIRE && attacker.hasActiveItem?(:FIREGEM)) ||
           (move.type == PBTypes::WATER && attacker.hasActiveItem?(:WATERGEM)) ||
           (move.type == PBTypes::GRASS && attacker.hasActiveItem?(:GRASSGEM)) ||
           (move.type == PBTypes::ELECTRIC && attacker.hasActiveItem?(:ELECTRICGEM)) ||
           (move.type == PBTypes::GROUND && attacker.hasActiveItem?(:GROUNDGEM)) ||
           (move.type == PBTypes::ROCK && attacker.hasActiveItem?(:ROCKGEM)) ||
           (move.type == PBTypes::STEEL && attacker.hasActiveItem?(:STEELGEM)) ||
           (move.type == PBTypes::DRAGON && attacker.hasActiveItem?(:DRAGONGEM)) ||
           (move.type == PBTypes::FAIRY && attacker.hasActiveItem?(:FAIRYGEM)) ||
           (move.type == PBTypes::DARK && attacker.hasActiveItem?(:DARKGEM)) ||
           (move.type == PBTypes::ICE && attacker.hasActiveItem?(:ICEGEM)) ||
           (move.type == PBTypes::BUG && attacker.hasActiveItem?(:BUGGEM)) ||
           (move.type == PBTypes::FLYING && attacker.hasActiveItem?(:FLYINGGEM)) ||
           (move.type == PBTypes::FIGHTING && attacker.hasActiveItem?(:FIGHTINGGEM)) ||
           (move.type == PBTypes::GHOST && attacker.hasActiveItem?(:GHOSTGEM)) ||
           (move.type == PBTypes::DARK && attacker.hasActiveItem?(:DARKGEM)) ||
           (move.type == PBTypes::PSYCHIC && attacker.hasActiveItem?(:PSYCHICGEM))
          score += 20
        end
      end
      
      # Return here if no extra effect is needed
      func = move.function
      return score if func == 0x000 || func == 0x001 || func == 0x002 || (target && target.damagestate.substitute)
      
      effscore = 0
      
      ### Status conditions
      if func == 0x01B
        # Psycho Shift
        if attacker.status != :NONE
          effscore += 10
          # Pretend it is a regular status move
          case attacker.status
          when :POISON
            if attacker.effects[PBEffects::Toxic]>0
              func = 0x006
            else
              func = 0x005
            end
          when :SLEEP
            func = 0x003
          when :PARALYSIS
            func = 0x007
          when :BURN
            func = 0x00A
          end
        end
      end
      
      if func == 0x005 && attacker.hasActiveItem?(:NOXIOUSCHOKER)
        func = 0x006
      end
      
      case func
      when 0x003
        # Sleep
        if target.pbCanSleep?(attacker,false,move) &&
           !target.hasActiveAbility?(:EARLYBIRD)
          effscore += 40
          actionable[target.index] = false if chosen
        end
      when 0x004
        # Drowsy (Yawn)
        if target.pbCanSleep?(attacker,false,move) &&
           !target.hasActiveAbility?(:EARLYBIRD)
          effscore += 20
        end
      when 0x005
        # Poison
        if target.pbCanPoison?(attacker,false,move) &&
           !target.hasActiveAbility?(:POISONHEAL) &&
           !target.hasActiveAbility?(:TOXICBOOST) &&
           !target.hasActiveAbility?(:GUTS) &&
           !target.hasActiveAbility?(:MAGICGUARD)
          effscore += 20
        end
      when 0x006
        # Toxic
        if target.pbCanPoison?(attacker,false,move) &&
           !target.hasActiveAbility?(:POISONHEAL) &&
           !target.hasActiveAbility?(:TOXICBOOST) &&
           !target.hasActiveAbility?(:MAGICGUARD)
          if target.hasActiveAbility?(:GUTS)
            effscore += 20
          else
            effscore += 40
          end
        end
      when 0x007
        # Paralysis
        if target.pbCanParalyze?(attacker,false,move) &&
           !target.hasActiveAbility?(:QUICKFEET)
          target_speed = target.pbSpeed
          attacker_speed = attacker.pbSpeed
          if target_speed > attacker_speed && target_speed / 2 < attacker_speed
            effscore += 15
          end
          if !attacker.pbPartner.isFainted?
            partner_speed = attacker.pbPartner.pbSpeed
            if target_speed > partner_speed
              effscore += 15
            end
          end
          if !target.hasActiveAbility?(:GUTS)
            effscore += 10
          end
        end
      when 0x00A
        # Burn
        if target.pbCanBurn?(attacker,false,move) &&
           !target.hasActiveAbility?(:GUTS) &&
           !target.hasActiveAbility?(:FLAREBOOST)
          has_physical = false
          has_special = false
          for m in target.moves
            if m.basedamage > 40
              if m.pbIsPhysical?(m.type)
                has_physical = true
              elsif m.pbIsSpecial?(m.type)
                has_special = true
              end
            end
          end
          if has_physical && has_special
            effscore += 20
          elsif has_physical
            effscore += 40
          end
        end
      when 0x013, 0x014, 0x015
        # Confusion
        if target.pbCanConfuse?(attacker,false,move) &&
           !target.hasActiveAbility?(:TANGLEDFEET)
          effscore += 30
        end
      when 0x016
        # Attract
        if target.pbCanAttract?(attacker,false)
          effscore += 35
        end
      end
      
      if target
        if target.hasActiveAbility?(:SHEDSKIN)
          effscore *= 0.5
        elsif !target.pbPartner.isFainted? && target.pbPartner.hasActiveAbility?(:HEALER)
          effscore = 0
        elsif target.hasActiveAbility?(:HYDRATION) && self.pbWeather==PBWeather::RAINDANCE
          effscore = 0
        elsif target.hasActiveAbility?(:SYNCHRONIZE)
          if ((func == 0x005 || func == 0x006) && attacker.pbCanPoison?(attacker,false,nil)) ||
             (func == 0x007 && attacker.pbCanParalyze?(attacker,false,nil)) ||
             (func == 0x00A && attacker.pbCanBurn?(attacker,false,nil))
            effscore *= 0.5
          end
        end
      end
      
      
      ### Stat changes on attacker
      statscore = 0
      
      # Decreases Stats
      if func == 0x03B || func == 0x03C || func == 0x03D || func == 0x03E || func == 0x03F
        if attacker.hasActiveAbility?(:CONTRARY)
          if func == 0x03B
            func = 0x024
          elsif func == 0x03C
            func = 0x02A
          elsif func == 0x03D
            statscore += 40
          elsif func == 0x03E
            func = 0x01F
          elsif func == 0x03F
            func = 0x032
          end
        else
          statscore -= 10
        end
      end
      
      if attacker.pbCanIncreaseStatStage?(PBStats::ATTACK,attacker,false,move,false,true)
      # Attack +1
        if func == 0x01C || func == 0x024 || func == 0x025 || func == 0x026 ||
           func == 0x027 || func == 0x029 || func == 0x036 ||
           (func == 0x028 && self.pbWeather!=PBWeather::SUNNYDAY) # Growth
          statscore += 20 if has_physical
        end
         
        # Attack +2
        if func == 0x02E || func == 0x035 ||
           (func == 0x028 && self.pbWeather==PBWeather::SUNNYDAY) # Growth
           statscore += 30 if has_physical
         end
      
        # Belly Drum
        if func == 0x03A
          if attacker.stages[PBStats::ATTACK]<=2
            # Make sure you have enough HP, more HP = higher score
            if attacker.hp >= attacker.totalhp * 0.9
              score += 40
            elsif attacker.hp >= attacker.totalhp * 0.7
              score += 30
            elsif attacker.hp >= attacker.totalhp * 0.55
              score += 15
            end
            # If you have a healing berry, assume Belly Drum is the way to go
            if !unnerve
              if attacker.hasActiveItem?(:SITRUSBERRY)
                score += 20
              elsif (attacker.hp < attacker.totalhp*0.75 || attacker.hasActiveAbility?(:GLUTTONY)) &&
                      (attacker.hasActiveItem?(:AGUAVBERRY) ||
                       attacker.hasActiveItem?(:FIGYBERRY) ||
                       attacker.hasActiveItem?(:IAPAPABERRY) ||
                       attacker.hasActiveItem?(:MAGOBERRY) ||
                       attacker.hasActiveItem?(:WIKIBERRY))
                score += 30
              end
            end
          end
        end
      end
      
      if attacker.pbCanIncreaseStatStage?(PBStats::DEFENSE,attacker,false,move,false,true)
      # Defense +1
        if func == 0x01D || func == 0x01E || func == 0x024 || func == 0x025 ||
           func == 0x02A || func == 0x136
          statscore += 5
          statscore += 10 if physical_opponents > 0
          
          if func == 0x01E && !attacker.effects[PBEffects::DefenseCurl]
            # Defense Curl
            for m in attacker.moves
              if m.function == 0x0D3
                # Has Rollout or Ice Ball
                statscore += 30
                break
              end
            end
          end
        end
         
        # Defense +2
        if func == 0x02F
           statscore += 5
           statscore += 10 if physical_opponents > 0
           statscore += 5 if physical_opponents > 1
        end
         
        # Defense +3
        if func == 0x038
           statscore += 5
           statscore += 15 if physical_opponents > 0
           statscore += 10 if physical_opponents > 1
        end
      end
      
      if attacker.pbCanIncreaseStatStage?(PBStats::SPEED,attacker,false,move,false,true)
        # Speed +1
        if func == 0x01F || func == 0x026 || func == 0x02B
          statscore += 5
          for s in opponent_speeds
            if s >= speed_stat && s < speed_stat * 1.5
              statscore += 15
            end
          end
        end
         
        # Speed +2
        if func == 0x030 || func == 0x031 || func == 0x035 || func == 0x036
          statscore += 10
          for s in opponent_speeds
            if s >= speed_stat && s < speed_stat * 2.0
              statscore += 15
            end
          end
        end
      end
      
      if attacker.pbCanIncreaseStatStage?(PBStats::SPATK,attacker,false,move,false,true)
        # Sp. Atk +1
        if func == 0x020 || func == 0x027 || func == 0x02B || func == 0x02C ||
           (func == 0x028 && self.pbWeather!=PBWeather::SUNNYDAY) # Growth
          statscore += 20 if has_special
        end
         
        # Sp. Atk +2
        if func == 0x032 || func == 0x035 ||
           (func == 0x028 && self.pbWeather==PBWeather::SUNNYDAY) # Growth
           statscore += 30 if has_special
        end
         
        # Sp. Atk +3
        if func == 0x039
           statscore += 50 if has_special
        end
      end
      
      if attacker.pbCanIncreaseStatStage?(PBStats::SPDEF,attacker,false,move,false,true)
        # Sp. Def +1
        if func == 0x021 || func == 0x02A || func == 0x02B || func == 0x02C
          statscore += 5
          statscore += 10 if special_opponents > 0
        end
        
        # Sp. Def +2
        if func == 0x033
           statscore += 5
           statscore += 10 if special_opponents > 0
           statscore += 5 if special_opponents > 1
        end
      end
      
      if attacker.pbCanIncreaseStatStage?(PBStats::EVASION,attacker,false,move,false,true)
        # Evasiveness +1
        if func == 0x022
          statscore += 20
        end
        
        # Evasiveness +2
        if func == 0x034
          statscore += 30
        end
      end
      
      if attacker.pbCanIncreaseStatStage?(PBStats::ACCURACY,attacker,false,move,false,true)
        # Accuracy +1
        if func == 0x025 || func == 0x029
          stage = attacker.stages[PBStats::ACCURACY]+6
          stages = [3.0/9.0, 3.0/8.0, 3.0/7.0, 3.0/6.0, 3.0/5.0, 3.0/4.0, 1.0,
                           4.0/3.0, 5.0/3.0, 6.0/3.0, 7.0/3.0, 8.0/3.0, 9.0/3.0]
          addscore = 20
          for m in attacker.moves
            acc = m.accuracy * stages[stage]
            if acc < 85
              statscore += addscore
              addscore -= 5
            end
          end
        end
      end
      
      # Accupressure
      if func == 0x037
        statscore += 25
      end
      
      # Boost score if the user has Stored Power
      for m in attacker.moves
        if m.function == 0x08E
          statscore *= 1.5
        end
      end
      
      if attacker.hasActiveAbility?(:SIMPLE)
        statscore *= 1.75
      end
      
      if move.isDanceMove?
        if partner && partner.hasActiveAbility?(:DANCER)
          statscore *= 1.75
        end
        if opponent1 && opponent1.hasActiveAbility?(:DANCER)
          statscore *= 0.5
        end
        if opponent1 && opponent1.hasActiveAbility?(:DANCER)
          statscore *= 0.5
        end
      end
      
      
      ### Stat changes on target
      debuffscore = 0
      
      # Swagger / Flatter
      if func == 0x040 || func == 0x041
        if target.pbCanConfuse?(attacker,false,move)
          score += 25
          # Prioritize if target has no physical moves and the move is Swagger
          score += 20 if !target_has_physical && func == 0x040
        end
        if target.hasActiveAbility?(:CONTRARY)
          score += 10
        end
      end
      
      if target
        if target.pbCanReduceStatStage?(PBStats::ATTACK,attacker,false,move,moldbreaker,true)
          # Attack -1
          if func == 0x042 || func == 0x04A || func == 0x119 || func == 0x13A ||
             (func == 0x140 && target.status == :POISON)
            if target_has_physical && target_has_special
              debuffscore += 10
            elsif target_has_physical
              debuffscore += 20
            end
          end
          
          # Attack -2
          if func == 0x04B
            if target_has_physical && target_has_special
              debuffscore += 20
            elsif target_has_physical
              debuffscore += 30
            end
          end
        end
        
        if target.pbCanReduceStatStage?(PBStats::DEFENSE,attacker,false,move,moldbreaker,true)
          # Defense -1
          if func == 0x043 || func == 0x04A || func == 0x13B
            debuffscore += 10
          end
          
          # Defense -2
          if func == 0x04C
            debuffscore += 30
          end
        end
        
        if target.pbCanReduceStatStage?(PBStats::SPEED,attacker,false,move,moldbreaker,true)
          # Speed -1
          if func == 0x044 ||
             (func == 0x140 && target.status == :POISON)
            debuffscore += 5
            for s in ally_speeds
              if s <= target_speed && s > target_speed * 2 / 3
                debuffscore += 15
              end
            end
          end
          
          # Speed -2
          if func == 0x04D
            debuffscore += 5
            for s in ally_speeds
              if s <= target_speed && s * 0.5 > target_speed * 0.5
                debuffscore += 15
              end
            end
          end
        end
        
        if target.pbCanReduceStatStage?(PBStats::SPATK,attacker,false,move,moldbreaker,true)
          # Sp. Atk -1
          if func == 0x045 || func == 0x13A || func == 0x13C ||
             (func == 0x140 && target.status == :POISON)
            if target_has_physical && target_has_special
              debuffscore += 10
            elsif target_has_special
              debuffscore += 20
            end
          end
          
          # Sp. Atk -2
          if func == 0x13D
            if target_has_physical && target_has_special
              debuffscore += 20
            elsif target_has_special
              debuffscore += 30
            end
          end
          # Captivate is not handled, useless move
        end
        
        if target.pbCanReduceStatStage?(PBStats::SPDEF,attacker,false,move,moldbreaker,true)
          # Sp. Def -1
          if func == 0x046
            debuffscore += 10
          end
          
          # Sp. Def -2
          if func == 0x04F
            debuffscore += 30
          end
        end
        
        if target.pbCanReduceStatStage?(PBStats::ACCURACY,attacker,false,move,moldbreaker,true)
          # Accuracy -1
          if func == 0x047
            score += 25
          end
        end
        
        if target.pbCanReduceStatStage?(PBStats::EVASION,attacker,false,move,moldbreaker,true)
          # Evasion -2
          if func == 0x048
            # Sweet Scent, Defog does not get score for its Evasion debuff
            if target.stages[PBStats::EVASION]>0
              score += (target.stages[PBStats::EVASION]) * 20
            end
          end
        end
        
        if debuffscore > 0
          # Target has Competitive / Defiant, be careful
          if target.hasActiveAbility?(:DEFIANT) || target.hasActiveAbility?(:COMPETITIVE)
            debuffscore -= 40
          end
        
          # Target has Contrary, DO NOT PROCEED
          if target.hasActiveAbility?(:CONTRARY)
            debuffscore = -debuffscore
          end
          
          if target.hasActiveAbility?(:SIMPLE)
            debuffscore *= 1.75
          end
        end
      end
      
      
      ### Move specific handling
      case func
      when 0x011, 0x0B4
        # Snore, Sleep Talk
        if attacker.status == :SLEEP && attacker.statusCount>1
          score += 100
        end
      when 0x012
        # Fake Out
        if attacker.turncount < 1 && !target.hasActiveAbility?(:INNERFOCUS)
          score += 50
          actionable[target.index] = false if chosen
        end
      when 0x018
        # Refresh
        if attacker.status != :NONE
          score += 20
          if attacker.status == :BURN
            # Don't leave a physical attacker burned
            for m in attacker.moves
              if m.pbIsPhysical?(m.type)
                score += 30
                break
              end
            end
          elsif attacker.status == :POISON
            # Don't stay toxiced for long
            if attacker.effects[PBEffects::Toxic]>5
              score += 50
            elsif attacker.effects[PBEffects::Toxic]>2
              score += 30
            end
          end
        end
      when 0x019
        # Heal Bell / Aromatherapy
        party = self.pbParty(attacker.index)
        for p in party
          score += 10
          if p.status == :BURN
            # Don't leave a physical attacker burned
            for m in p.moves
              if m.category == 0
                score += 20
                break
              end
            end
          elsif p.status == :POISON
            score += 30
          end
        end
      when 0x01A
        # Safeguard
        if attacker.pbOwnSide.effects[PBEffects::Safeguard]<=0
          score += 40
        end
      when 0x023
        # Focus Energy
        if attacker.effects[PBEffects::FocusEnergy]==0 &&
           attacker.pbOpposingSide.effects[PBEffects::LuckyChant]<=0 # Do not use during Lucky Chant
          addscore = 30
          if attacker.hasActiveItem?(:RAZORCLAW) || attacker.hasActiveItem?(:SCOPELENS) ||
             attacker.hasActiveAbility?(:SUPERLUCK)
            # Has a crit rate item or ability, probably uses a critical hit strategy
            addscore += 20
          end
          if attacker.hasActiveAbility?(:SNIPER)
            # Has Sniper, crit rate is ideal
            addscore += 20
          end
          # Crit Rate is not optimal against opponents with crit immunity
          if opponent1 && (opponent1.hasActiveAbility?(:SHELLARMOR) || opponent1.hasActiveAbility?(:BATTLEARMOR))
            addscore *= 0.5
          end
          if opponent2 && (opponent2.hasActiveAbility?(:SHELLARMOR) || opponent2.hasActiveAbility?(:BATTLEARMOR))
            addscore *= 0.5
          end
          score += addscore
        end
      when 0x035
        # Shell Smash
        if attacker.hasActiveItem?(:WHITEHERB)
          score += 30
        end
      when 0x049
        # Defog
        score += 10 * attacker.pbOwnSide.effects[PBEffects::Spikes]
        score += 15 * attacker.pbOwnSide.effects[PBEffects::ToxicSpikes]
        score += 20 if attacker.pbOwnSide.effects[PBEffects::StealthRock]
        score -= 10 * attacker.pbOpposingSide.effects[PBEffects::Spikes]
        score -= 15 * attacker.pbOpposingSide.effects[PBEffects::ToxicSpikes]
        score -= 20 if attacker.pbOpposingSide.effects[PBEffects::StealthRock]
      when 0x050
        # Clear Smog
        for t in 1..5
          # Gain 10 points for each stat increase
          stage = target.stages[t]
          score += stage * 10
        end
        # Make the target less evasive (does not care about accuracy buffs)
        if target.stages[PBStats::EVASION] >= 2
          score += (target.stages[t]) * 15
        end
      when 0x051
        # Haze
        for i in 0..3
          b = @battlers[i]
          if b && !b.isFainted?
            if b == attacker || b == partner
              # Prioritize if partners have negative changes
              for t in 1..5
                score -= (b.stages[t]) * 10
              end
            else
              # Prioritize if opponents have positive changes
              for t in 1..5
                score += (b.stages[t]) * 10
              end
            end
          end
        end
      when 0x052
        # Power Swap
        # The more the target's stats multiply your own, the better
        if has_physical || target_has_physical
          dif = target.attack * 1.0 / attacker.attack
          if dif > 1.0
            score += (dif - 1.0) * 40
          end
        end
        if has_special || target_has_special
          dif = target.spatk * 1.0 / attacker.spatk
          if dif > 1.0
            score += (dif - 1.0) * 40
          end
        end
        score *= 0.75 if has_physical && has_special
      when 0x053
        # Guard Swap
        # The more the target's stats multiply your own, the better
          dif = target.defense * 1.0 / attacker.defense
          if dif > 1.0
            score += (dif - 1.0) * 30
          end
          dif = target.spdef * 1.0 / attacker.spdef
          if dif > 1.0
            score += (dif - 1.0) * 30
          end
      when 0x054
        # Heart Swap
        # Better the more buffs the target has than the attacker
        ownstat = 0
        oppstat = 0
        for t in 1..5
          ownstat += attacker.stages[t]
          oppstat += target.stages[t]
        end
        score = (oppstat - ownstat) * 20
      when 0x055
        # Psych Up
        # Better the more buffs the target has than the attacker
        ownstat = 0
        oppstat = 0
        for t in 1..5
          ownstat += attacker.stages[t]
          oppstat += target.stages[t]
        end
        score = (oppstat - ownstat) * 10
      when 0x056
        # Mist
        if attacker.pbOwnSide.effects[PBEffects::Mist]<=0
          score += 30
        end
      when 0x057
        # Power Trick
        # Assume a Power Trick strategy is intended, prioritize if not yet used
        if !attacker.effects[PBEffects::PowerTrick]
          score += 50
        end
      when 0x058
        # Power Split
        if has_physical || target_has_physical
          dif = target.attack * 1.0 / attacker.attack
          if dif > 1.0
            score += (dif - 1.0) * 30
          end
        end
        if has_special || target_has_special
          dif = target.spatk * 1.0 / attacker.spatk
          if dif > 1.0
            score += (dif - 1.0) * 30
          end
        end
        score *= 0.75 if has_physical && has_special
      when 0x059
        # Guard Split
          dif = target.defense * 1.0 / attacker.defense
          if dif > 1.0
            score += (dif - 1.0) * 20
          end
          dif = target.spdef * 1.0 / attacker.spdef
          if dif > 1.0
            score += (dif - 1.0) * 20
          end
      when 0x05A
        # Pain Split
        # Calculate as if it's damage and healing points
        if target_item != :AEGISTALISMAN
          ownpercent = attacker.hp * 100 / attacker.totalhp
          opppercent = target.hp * 100 / target.totalhp
          splithp = (attacker.hp + target.hp) / 2
          score += (splithp * 100 / attacker.totalhp) - ownpercent
          score -= (splithp * 100 / target.totalhp) - opppercent
        end
      when 0x05B
        # Tailwind
        # Good move, just use it (unless Trick Room persists after this turn)
        if attacker.pbOwnSide.effects[PBEffects::Tailwind]<=0 &&
           self.field.effects[PBEffects::TrickRoom]<=1
          score += 50
        end
      when 0x05C
        # Mimic
        score += 40
      when 0x05D
        # Sketch
        score += 40
      when 0x05E
        # Conversion
        score += 40
      when 0x05F
        # Conversion 2
        score += 40
      when 0x060
        # Camouflage
        type=getConst(PBTypes,:NORMAL) || 0
        case self.environment
        when PBEnvironment::None;        type=getConst(PBTypes,:NORMAL) || 0
        when PBEnvironment::Grass;       type=getConst(PBTypes,:GRASS) || 0
        when PBEnvironment::TallGrass;   type=getConst(PBTypes,:GRASS) || 0
        when PBEnvironment::MovingWater; type=getConst(PBTypes,:WATER) || 0
        when PBEnvironment::StillWater;  type=getConst(PBTypes,:WATER) || 0
        when PBEnvironment::Underwater;  type=getConst(PBTypes,:WATER) || 0
        when PBEnvironment::Cave;        type=getConst(PBTypes,:ROCK) || 0
        when PBEnvironment::Rock;        type=getConst(PBTypes,:GROUND) || 0
        when PBEnvironment::Sand;        type=getConst(PBTypes,:GROUND) || 0
        when PBEnvironment::Forest;      type=getConst(PBTypes,:BUG) || 0
        when PBEnvironment::Snow;        type=getConst(PBTypes,:ICE) || 0
        when PBEnvironment::Volcano;     type=getConst(PBTypes,:FIRE) || 0
        when PBEnvironment::Graveyard;   type=getConst(PBTypes,:GHOST) || 0
        when PBEnvironment::Sky;         type=getConst(PBTypes,:FLYING) || 0
        when PBEnvironment::Space;       type=getConst(PBTypes,:DRAGON) || 0
        end
        if self.field.effects[PBEffects::ElectricTerrain]>0
          type=getConst(PBTypes,:ELECTRIC) if hasConst?(PBTypes,:ELECTRIC)
        elsif self.field.effects[PBEffects::GrassyTerrain]>0
          type=getConst(PBTypes,:GRASS) if hasConst?(PBTypes,:GRASS)
        elsif self.field.effects[PBEffects::MistyTerrain]>0
          type=getConst(PBTypes,:FAIRY) if hasConst?(PBTypes,:FAIRY)
        elsif self.field.effects[PBEffects::PsychicTerrain]>0
          type=getConst(PBTypes,:PSYCHIC) if hasConst?(PBTypes,:PSYCHIC)
        end
        if !attacker.pbHasType?(type)
          # Make sure the user isn't already the same type as the terrain
          score += 40
        end
      when 0x061
        # Soak
        if !target.pbHasType?(PBTypes::WATER)
          if target == partner && partner.hasActiveAbility?(:WONDERGUARD)
            score -= 1000 # Negative score is good for partner targets
          else
            score += 10
            # Prioritize if a partner can hit water-types super effectively
            allmoves = partner ? (attacker.moves + partner.moves) : attacker.moves
            for m in allmoves
              if (m.pbIsPhysical?(move.type) || m.pbIsSpecial?(move.type)) &&
                 (m.type == PBTypes::GRASS || m.type == PBTypes::ELECTRIC)
                score += 30
                break
              end
            end
            # Prioritize if you remove the target's STAB possibilities
            has_water_move = false
            for m in target.moves
              if (m.pbIsPhysical?(move.type) || m.pbIsSpecial?(move.type)) &&
                 (m.type == PBTypes::WATER)
                 has_water_move = true
                 break
              end
            end
            if !has_water_move
              score += 20
            end
          end
        end
      when 0x062
        # Reflect Type
        if attacker.type1 != target.type1 || attacker.type2 != target.type2
          score += 30
        end
      when 0x063
        # Simple Beam
        if target.ability != :SIMPLE
          if target == partner
            # Use on partner if they have a buffing move
            for m in partner.moves
              if m.function <= 0x039 && m.function >= 0x01C
                score -= 50
              end
            end
          else
            score += 30
          end
        end
      when 0x064
        # Worry Seed
        if target.ability != :INSOMNIA
          score += 30
        end
      when 0x065
        # Role Play
        if attacker.ability != target.ability
          score += 30
        end
      when 0x066
        # Entrainment
        if attacker.ability != target.ability && 
            !(target.ability == :TRUANT ||
              target.ability == :SLOWSTART ||
              target.ability == :DEFEATIST)
          score += 20
          if attacker.ability == :TRUANT ||
             attacker.ability == :SLOWSTART ||
             attacker.ability == :DEFEATIST
            score += 100
          end
        end
      when 0x067
        # Skill Swap
        if attacker.ability != target.ability
          if target == partner
            if partner.ability == :TRUANT ||
               partner.ability == :SLOWSTART ||
               partner.ability == :DEFEATIST
              score -= 300
            end
          elsif !(target.ability == :TRUANT ||
                    target.ability == :SLOWSTART ||
                    target.ability == :DEFEATIST)
            score += 20
            if attacker.ability == :TRUANT ||
               attacker.ability == :SLOWSTART ||
               attacker.ability == :DEFEATIST
              score += 100
            end
          end
        end
      when 0x068
        # Gastro Acid
        if !target.effects[PBEffects::GastroAcid] &&
           !(target.ability == :TRUANT ||
             target.ability == :SLOWSTART ||
             target.ability == :DEFEATIST)
          score += 40
        end
      when 0x069
        # Transform
        score += 50
      when 0x06A
        # Sonic Boom
        #if target.hp <= 20
        #  score += 150
        #  actionable[target.index] = false
        #  fainted[target.index] = true
        #else
        #  score += 20 / target.totalhp
        #end
      when 0x06B
        # Dragon Rage
        #if target.hp <= 40
        #  score += 150
        #  actionable[target.index] = false
        #  fainted[target.index] = true
        #else
        #  score += 40 / target.totalhp
        #end
      when 0x06C
        # Super Fang
        #score += (target.hp / 2) / target.totalhp
      when 0x06D, 0x06F
        # Night Shade / Seismic Toss, Psywave
        #if target.hp <= attacker.level
        #  score += 150
        #  actionable[target.index] = false
        #  fainted[target.index] = true
        #else
        #  score += attacker.level / target.totalhp
        #end
      when 0x06E
        # Endeavor
        #if target.hp > attacker.hp
        #  score += (attacker.hp - target.hp) / target.totalhp
        #end
      when 0x070
        # OHKO
        if !target.hasActiveAbility?(:STURDY)
          # In case of sure hit, FATALITY
          if target.effects[PBEffects::LockOn]>0
            score += 150
            actionable[target.index] = false if chosen
            fainted[target.index] = true if chosen
          elsif
            score += 30
          end
        end
      when 0x071
        # Counter
        if physical_opponents == 2
          score += 40
        elsif physical_opponents == 1
          score += 20
        end
      when 0x072
        # Mirror Coat
        if special_opponents == 2
          score += 40
        elsif special_opponents == 1
          score += 20
        end
      when 0x073
        # Metal Burst
        score += 30
      when 0x074
        # Flame Burst
        if target.pbPartner && !target.pbPartner.isFainted?
          if target.pbPartner.hp < target.pbPartner.totalhp / 16
            score += 150
            actionable[target.pbPartner.index] = false if chosen
            fainted[target.pbPartner.index] = true if chosen
          else
            score += target.pbPartner.totalhp / 16
          end
        end
      when 0x083
        # Round
        if partner
          for m in partner.moves
            if m.function == 0x083
              score += 30
              break
            end
          end
        end
      when 0x084
        # Payback
        # Double damage score if target will attack first
        if target_speed > speed_stat
          score += damage * 100 / target.totalhp
        end
      when 0x091, 0x092
        # Fury Cutter, Echoed Voice
        # Give some extra score to actually use them
        score += 10
        if attacker.hasActiveItem?(:METRONOME)
          score += 30
        end
      when 0x094, 0x095
        # Present, Magnitude
        # Random by nature
        score += self.pbRandom(50)
      when 0x09C
        # Helping Hand
        score += 20
      when 0x09D
        # Mud Sport
        # Unhandled
        score += 10
      when 0x09E
        # Water Sport
        # Unhandled
        score += 10
      when 0x0A0
        # Frost Breath / Storm Throw
        # Avoid attacking Anger Point, unless it's the ally
        if target.hasActiveAbility?(:ANGERPOINT) &&
           target.hp > target.totalhp * 0.6 && target.stages[PBStats::ATTACK] < 3
          score -= target == partner ? 200 : 120
        end
      when 0x0A1
        # Lucky Chant
        if attacker.pbOwnSide.effects[PBEffects::LuckyChant]<=0
          score += 40
        end
      when 0x0A2
        # Reflect
        if attacker.pbOwnSide.effects[PBEffects::Reflect]<=0
          score += 10
          score += 10 if attacker.hasActiveItem?(:LIGHTCLAY)
          score += 30 * physical_opponents
        end
      when 0x0A3
        # Light Screen
        if attacker.pbOwnSide.effects[PBEffects::Reflect]<=0
          score += 10
          score += 10 if attacker.hasActiveItem?(:LIGHTCLAY)
          score += 30 * special_opponents
        end
      when 0x0A5, 0x0A9
        # Sure-hit moves, Chip Away / Saced Sword
        if target.stages[PBStats::EVASION]>=2
          score += 10 * (target.stages[PBStats::EVASION] - 1)
        end
      when 0x0A6
        # Lock-On / Mind Reader
        if target.effects[PBEffects::LockOn]<=0
          if target.stages[PBStats::EVASION]>=2
            score += 10 * (target.stages[PBStats::EVASION] - 1)
          end
          for m in attacker.moves
            if m.function == 0x070
              # Add score if the user has OHKO moves
              score += 40
              break
            elsif m.accuracy <= 50
              # Add score if the user has Zap Cannon, etc
              score += 30
              break
            end
          end
        end
      when 0x0A7
        # Foresight / Odor Sleuth
        if target.pbHasType?(:GHOST) && !target.effects[PBEffects::Foresight]
          score += 30
        end
      when 0x0A8
        # Miracle Eye
        if target.pbHasType?(:DARK) && !target.effects[PBEffects::MiracleEye]
          score += 30
        end
      when 0x0AA
        # Detect / Protect
        if attacker.effects[PBEffects::ProtectRate]==1
          score += 20
          score += 20 if opponent1 && opponent1.status == :POISON
          score += 20 if opponent2 && opponent2.status == :POISON
          score += 30 if opponent1 && opponent1.effects[PBEffects::Curse]
          score += 30 if opponent2 && opponent2.effects[PBEffects::Curse]
          score += 40 if opponent1 && opponent1.effects[PBEffects::PerishSong]>0
          score += 40 if opponent2 && opponent2.effects[PBEffects::PerishSong]>0
        end
      when 0x0AB
        # Quick Guard
        score += 20 if attacker.effects[PBEffects::ProtectRate]==1
      when 0x0AC
        # Wide Guard
        score += 20 if attacker.effects[PBEffects::ProtectRate]==1
      when 0x0AD
        # Feint
        # Prioritize Feint if target has Protect
        for m in target.moves
          if m.function == 0x0AA
            score += 30
            break
          end
        end
      when 0x0AE
        # Mirror Move - Unhandled
        score += 10
      when 0x0AF
        # Copycat - Unhandled
        score += 10
      when 0x0B0
        # Me First
        # Needs to be faster than at least one opponent
        higher = 0
        for s in opponent_speeds
          higher += 1 if s < speed_stat
        end
        if higher > 0
          score += 20
          score += 15 if higher >= 2
          # Ghost is super-effective against itself
          score += 10 if (opponent1 && opponent1.pbHasType?(:GHOST)) || (opponent2 && opponent2.pbHasType?(:GHOST))
        end
      when 0x0B1
        # Magic Coat
        allmoves = []
        allmoves += opponent1.moves if opponent1
        allmoves += opponent2.moves if opponent2
        count = 0
        for m in allmoves
          if !m.pbIsPhysical?(m.type) && !m.pbIsSpecial?(m.type)
            if m.target != PBTargets::NoTarget &&
               m.target != PBTargets::User &&
               m.target != PBTargets::UserSide &&
               m.target != PBTargets::Partner &&
               m.target != PBTargets::UserOrPartner
              count += 1
            end
          end
        end
        if count >= 2
          score += 20
          score += 5 * (count - 2)
        end
      when 0x0B2
        # Snatch
        # Use if opponents have buffing moves
        if opponent1
          for m in opponent1.moves
            if m.function <= 0x039 && m.function >= 0x01C
              score += 20
              is_buffed = false
              # Assume target will not buff if they're already buffed
              for t in 1..5
                if opponent1.stages[t]>=2
                  is_buffed = true
                  break
                end
              end
              score += 30 if !is_buffed
              break
            end
          end
        end
        if opponent2
          for m in opponent2.moves
            if m.function <= 0x039 && m.function >= 0x01C
              score += 20
              is_buffed = false
              # Assume target will not buff if they're already buffed
              for t in 1..5
                if opponent2.stages[t]>=2
                  is_buffed = true
                  break
                end
              end
              score += 30 if !is_buffed
              break
            end
          end
        end
      when 0x0B5
        # Assist
        score += self.pbRandom(50)
      when 0x0B6
        # Metronome
        score += self.pbRandom(70)
      when 0x0B7
        # Torment
        if !target.effects[PBEffects::Torment] && target_item != :AEGISTALISMAN
          score += 30
          if target.effects[PBEffects::Encore]>0
            score += 50
          end
        end
      when 0x0B8
        # Imprison
        if !attacker.effects[PBEffects::Imprison]
          allmoves = []
          allmoves += opponent1.moves if opponent1
          allmoves += opponent2.moves if opponent2
          for m in allmoves
            for n in attacker.moves
              if m.id == n.id
                score += 20
              end
            end
          end
        end
      when 0x0B9
        # Disable
        if target.effects[PBEffects::Disable]<=0 && target_item != :AEGISTALISMAN
          score += 30
          if target.effects[PBEffects::Encore]>0
            score += 50
          end
        end
      when 0x0BA
        # Taunt
        if target.effects[PBEffects::Taunt]<=0
          for m in target.moves
            if !m.pbIsPhysical?(m.type) && !m.pbIsSpecial?(m.type)
                score += 25
            end
          end
        end
      when 0x0BB
        # Heal Block
        if target.effects[PBEffects::HealBlock]<=0
          for m in target.moves
            if m.isHealingMove?
              score += 30
            end
          end
        end
      when 0x0BC
        # Encore
        if target.effects[PBEffects::Encore]<=0
          if target.lastMoveUsed>0
            score += 30
            # Try to trap the target into using a status move
            lastused = PBMoveData.new(target.lastMoveUsed)
            if lastused.category == 2
              score += 30
            end
            if target.effects[PBEffects::Torment]
              score += 50
            end
          end
        end
      when 0x0C1
        # Beat Up
        if target == partner && target.hasActiveAbility?(:JUSTIFIED)
          if target.pbCanIncreaseStatStage?(PBStats::ATTACK,attacker,false,move,false,true) &&
             target.stages[PBStats::ATTACK]<3 && target.hp > target.totalhp * 0.5
            score -= 30 * self.pbParty(attacker.index).length
          else
            score += 20
          end
        elsif !target.hasActiveAbility?(:JUSTIFIED)
          score -= 20 * self.pbParty(attacker.index).length
        else
          score += 3 * self.pbParty(attacker.index).length
        end
      when 0x0C3
        # Razor Wind
        if self.pbWeather != PBWeather::WINDS &&
           !attacker.hasActiveItem?(:POWERHERB) &&
           !attacker.hasActiveAbility?(:TIMESKIP)
          # Cut damage score in half as the attack takes two turns
          score -= damage * 50 / target.totalhp
        end
      when 0x0C4
        # Solar Beam
        if self.pbWeather != PBWeather::SUNNYDAY &&
           !attacker.hasActiveItem?(:POWERHERB) &&
           !attacker.hasActiveAbility?(:TIMESKIP)
          # Cut damage score in half as the attack takes two turns
          score -= damage * 50 / target.totalhp
        end
      when 0x0C5, 0x0C6, 0x0C7, 0x0C8
        # Freeze Shock, Ice Burn, Sky Attack, Skull Bash
        if !attacker.hasActiveItem?(:POWERHERB) &&
           !attacker.hasActiveAbility?(:TIMESKIP)
          # Cut damage score in half as the attack takes two turns
          score -= damage * 50 / target.totalhp
        end
      when 0x0CF, 0x0D0
        # Trapping Moves (Fire Spin, etc.)
        score += 20
        allmoves = partner ? (attacker.moves + partner.moves) : attacker.moves
        # If ally has Perish Song, assume Perish Trap strategy
        for m in allmoves
          if m.function == 0x0E5
            score += 50
            break
          end
        end
        score += 10 if opponent1 && opponent1.effects[PBEffects::Toxic]>0
        score += 10 if opponent2 && opponent2.effects[PBEffects::Toxic]>0
        score += 20 if opponent1 && opponent1.effects[PBEffects::Curse]
        score += 20 if opponent2 && opponent2.effects[PBEffects::Curse]
        score += 30 if opponent1 && opponent1.effects[PBEffects::PerishSong]>0
        score += 30 if opponent2 && opponent2.effects[PBEffects::PerishSong]>0
      when 0x0D1
        # Uproar
        # Try not to wake opponents
        score -= 20 if opponent1 && opponent1.status == :SLEEP && opponent1.statusCount>1
        score -= 20 if opponent2 && opponent2.status == :SLEEP && opponent2.statusCount>1
        # Try to wake partner
        score += 20 if partner && partner.status == :SLEEP && partner.statusCount>1
      when 0x0D2
        # Outrage / Petal Dance / Thrash
        if attacker.hasActiveItem?(:PERSIMBERRY) || attacker.hasActiveItem?(:LUMBERRY)
          score += 10
        end
      when 0x0D3
        # Rollout / Ice Ball
        if attacker.hasActiveItem?(:METRONOME)
          score += 20
        end
        if attacker.effects[PBEffects::DefenseCurl]
          score += 30
        end
      when 0x0D4
        # Bide
        score += 20
      when 0x0D5
        # Recover / Slack Off / etc.
        if attacker.hp < attacker.totalhp * 0.75
          score += [50, 100 - [attacker.hp * 100 / attacker.totalhp, 100].min].min
        end
      when 0x0D6
        # Roost
        if attacker.hp < attacker.totalhp * 0.75
          score += [50, 100 - [attacker.hp * 100 / attacker.totalhp, 100].min].min
        end
      when 0x0D7
        # Wish
        if attacker.effects[PBEffects::Wish]<=0
          if attacker.hp < attacker.totalhp * 0.8
            score += 50
          end
          # Able to pass Wish to party members
          for p in self.pbParty(attacker.index)
            if p.hp > 0 && p.hp < p.totalhp * 0.75
              score += 10
            end
          end
        end
      when 0x0D8
        # Moonlight / Morning Sun / Synthesis
        if attacker.hp < attacker.totalhp * 0.75
          amt = 50
          if self.pbWeather==PBWeather::SUNNYDAY
            amt = 200.0 / 3.0
          elsif self.pbWeather>0
            amt = 25
          end
          score += [amt, 100 - [attacker.hp * 100 / attacker.totalhp, 100].min].min
        end
      when 0x0D9
        # Rest
        if attacker.pbCanSleep?(attacker,true,self,true) && attacker.status != :SLEEP
          # Give more leeway to amount of HP recovered if (partly) immune to sleep
          amt = 0.5
          amt = 0.6 if attacker.hasActiveAbility?(:EARLYBIRD) || attacker.hasActiveAbility?(:SHEDSKIN)
          amt = 0.7 if partner && partner.hasActiveAbility?(:HEALER)
          amt = 0.8 if attacker.hasActiveAbility?(:HYDRATION) && self.pbWeather==PBWeather::RAINDANCE
          # Give score based on HP lost and if a status can be healed
          if attacker.hp < attacker.totalhp * amt
            score += (100 - [attacker.hp * 100 / attacker.totalhp, 100].min) * (amt * 1.5)
            if attacker.status == :POISON ||
               attacker.status == :BURN ||
               attacker.status == :PARALYSIS
              score += 30
            end
          elsif attacker.status == :POISON ||
                  attacker.status == :BURN ||
                  attacker.status == :PARALYSIS
            score += 30 if attacker.hp < attacker.totalhp * 0.75
          end
        end
      when 0x0DA
        # Aqua Ring
        if !attacker.effects[PBEffects::AquaRing]
          score += 40
        end
      when 0x0DB
        # Ingrain
        if !attacker.effects[PBEffects::Ingrain]
          score += 35
        end
      when 0x0DC
        # Leech Seed
        if target.effects[PBEffects::LeechSeed]<0
          score += 30
          # Extra points if the target has a large HP Pool
          score += target.totalhp * 20 / attacker.totalhp
        end
      when 0x0DC
        # 50% Drain Moves
        # Grant score based on how much HP will be healed
        if target != partner
          amt = [damage * 50 / attacker.totalhp, 100 - [attacker.hp * 100 / attacker.totalhp, 100].min].min
          score += target.hasActiveAbility?(:LIQUIDOOZE) ? -amt : amt
        end
      when 0x0DE
        # Dream Eater
        # Will not wake up this turn, or attacker outspeeds
        if target.status == :SLEEP && (target.statusCount > 1 || speed_stat > target_speed)
          # Grant score based on how much HP will be healed
          score += [damage * 50 / attacker.totalhp, 100 - [attacker.hp * 100 / attacker.totalhp, 100].min].min
        end
      when 0x0DF
        # Heal Pulse
        # Do not use against opponents
        if target != partner
          score -= 30
        end
        if target.hp < target.totalhp * 0.75
          score -= [50, 100 - [target.hp * 100 / target.totalhp, 100].min].min
        end
      when 0x0E0
        # Explosion / Self-Destruct
        score -= 90
        # Make sure more Pokemon are available
        party_able = 0
        for p in self.pbParty(attacker.index)
          party_able += 1 if p.hp > 0
        end
        score -= 50 if party_able <= 2
        score -= 50 if party_able <= 1
      when 0x0E1
        # Final Gambit
        if target != partner
          score -= 90
          # Make sure more Pokemon are available
          party_able = 0
          for p in self.pbParty(attacker.index)
            party_able += 1 if p.hp > 0
          end
          score -= 50 if party_able <= 2
          score -= 50 if party_able <= 1
        end
      when 0x0E2
        # Memento
        if target != partner
          score -= 50
          # Prioritize more on less HP
          if attacker.hp < attacker.totalhp * 0.75
            score += (100 - [attacker.hp * 100 / attacker.totalhp, 100].min) * 2
          end
          # Make sure more Pokemon are available
          party_able = 0
          for p in self.pbParty(attacker.index)
            party_able += 1 if p.hp > 0
          end
          score -= 100 if party_able <= 2
          score -= 100 if party_able <= 1
        end
      when 0x0E3, 0x0E4
        # Healing Wish, Lunar Dance
        score -= 50
        # Prioritize more on less HP
        if attacker.hp < attacker.totalhp * 0.75
          score += 100 - [attacker.hp * 100 / attacker.totalhp, 100].min
        end
        # Make sure more Pokemon are available
        party_able = 0
        lowest_hp = 0
        for p in self.pbParty(attacker.index)
          party_able += 1 if p.hp > 0
          if attacker.pokemon != p && (!partner || partner.pokemon != p)
            this_hp = 100 - [attacker.hp * 100 / attacker.totalhp, 100].min
            if this_hp > lowest_hp
              lowest_hp = this_hp
            end
          end
        end
        score += lowest_hp
        score -= 200 if party_able <= 2
      when 0x0E5
        # Perish Song
        # Make sure not to be trapped
        if (!opponent1 || (!opponent1.hasActiveAbility?(:SHADOWTAG) && !opponent1.hasActiveAbility?(:ARENATRAP))) &&
           (!opponent2 || (!opponent2.hasActiveAbility?(:SHADOWTAG) && !opponent2.hasActiveAbility?(:ARENATRAP)))
          # More score the more opponents are unperished
          score += 70 if opponent1 && opponent1.effects[PBEffects::PerishSong]<=0
          score += 70 if opponent2 && opponent2.effects[PBEffects::PerishSong]<=0
          if score > 0
            # Bonus score for trapping opponents
            if attacker.hasActiveAbility?(:SHADOWTAG) || attacker.hasActiveAbility?(:ARENATRAP) ||
               (partner && (partner.hasActiveAbility?(:SHADOWTAG) || partner.hasActiveAbility?(:ARENATRAP)))
              score += 200
            else
               score += 25 if opponent1 && opponent1.effects[PBEffects::MultiTurn]>1
               score += 25 if opponent2 && opponent2.effects[PBEffects::MultiTurn]>1
            end
          end
        end
      when 0x0E6
        # Grudge
        if target != partner
          score -= 50
          # Prioritize more on less HP
          if attacker.hp < attacker.totalhp * 0.5
            score += 100 - [attacker.hp * 100 / attacker.totalhp, 100].min
          end
          # Make sure more Pokemon are available
          party_able = 0
          for p in self.pbParty(attacker.index)
            party_able += 1 if p.hp > 0
          end
          score -= 100 if party_able <= 2
          score -= 100 if party_able <= 1
        end
      when 0x0E7
        # Destiny Bond
        score -= 50
        # Prioritize more on less HP
        if attacker.hp < attacker.totalhp * 0.5
          score += (100 - [attacker.hp * 100 / attacker.totalhp, 100].min) * 2
        end
        # Make sure more Pokemon are available
        party_able = 0
        for p in self.pbParty(attacker.index)
          party_able += 1 if p.hp > 0
        end
        score -= 200 if party_able <= 1
      when 0x0E8
        # Endure
        if attacker.effects[PBEffects::ProtectRate]==1
          score += 15
          score += 15 if opponent1 && opponent1.status == :POISON
          score += 15 if opponent2 && opponent2.status == :POISON
          score += 25 if opponent1 && opponent1.effects[PBEffects::Curse]
          score += 25 if opponent2 && opponent2.effects[PBEffects::Curse]
          score += 35 if opponent1 && opponent1.effects[PBEffects::PerishSong]>0
          score += 35 if opponent2 && opponent2.effects[PBEffects::PerishSong]>0
        end
      when 0x0EB, 0x0EC
        # Roar / Whirlwind, Circle Throw / Dragon Tail
        if target != partner
          party_able = 0
          for p in self.pbParty(target.index)
            party_able += 1 if p.hp > 0
          end
          # Make sure opponent has enough Pokemon to switch
          if party_able > 2
            for t in 1..5
              # Gain 10 points for each stat increase
              stage = target.stages[t]
              score += stage * 10
            end
            # Use more often if switched Pokemon will be hurt by hazards
            score += 10 if target.pbOwnSide.effects[PBEffects::StealthRock]
            score += 5 * target.pbOwnSide.effects[PBEffects::Spikes]
          end
        end
      when 0x0ED
        # Baton Pass
        party_able = 0
        for p in self.pbParty(attacker.index)
          party_able += 1 if p.hp > 0
        end
        # Make sure user has enough Pokemon to switch
        if party_able > 2
          for t in 1..5
            # Gain 10 points for each stat increase to pass
            stage = attacker.stages[t]
            score += stage * 10
          end
          # Use less often if switched Pokemon will be hurt by hazards
          score -= 10 if attacker.pbOwnSide.effects[PBEffects::StealthRock]
          score -= 5 * attacker.pbOwnSide.effects[PBEffects::Spikes]
        end
      when 0x0EE
        # U-turn / Volt Switch
        party_able = 0
        for p in self.pbParty(attacker.index)
          party_able += 1 if p.hp > 0
        end
        # Make sure user has enough Pokemon to switch
        if party_able > 2
          for t in 1..5
            # Gain 10 points for each stat decrease to remove
            stage = attacker.stages[t]
            score -= stage * 10
          end
          # Use less often if switched Pokemon will be hurt by hazards
          score -= 10 if attacker.pbOwnSide.effects[PBEffects::StealthRock]
          score -= 5 * attacker.pbOwnSide.effects[PBEffects::Spikes]
        end
      when 0x0EF
        # Block / Mean Look / Spider Web
        if target.effects[PBEffects::MeanLook] < 0 && !target.pbHasType?(:GHOST)
          score += 30
          score += 10 if target.status == :POISON
          score += 20 if target.effects[PBEffects::Curse]
          score += 30 if target.effects[PBEffects::PerishSong]>0
        end
      when 0x0F0
        # Knock Off
        if !target.hasActiveAbility?(:STICKYHOLD) &&
           !target.hasActiveAbility?(:SUCTIONCUPS)
          if target.item > 0
            score += 25
          end
        end
      when 0x0F1
        # Covet / Thief
        if !target.hasActiveAbility?(:STICKYHOLD) &&
           !target.hasActiveAbility?(:SUCTIONCUPS)
          if target.item > 0 && attacker.item == 0
            score += 25
          end
        end
      when 0x0F2
        # Switcheroo / Trick
        if !target.hasActiveAbility?(:STICKYHOLD) &&
           !target.hasActiveAbility?(:SUCTIONCUPS)
          if target.item != attacker.item &&
             target.item != :FLAMEORB &&
             target.item != :TOXICORB &&
             target.item != :STICKYBARB &&
             target.item != :CHOICESPECS &&
             target.item != :CHOICESCARF &&
             target.item != :CHOICEBAND
            if attacker.item == :FLAMEORB
              if target.pbCanBurn?(nil,false,nil) &&
                 !target.hasActiveAbility?(:GUTS) &&
                 !target.hasActiveAbility?(:FLAREBOOST)
                if target_has_physical && target_has_special
                  score += 20
                elsif target_has_physical
                  score += 10
                end
              end
            elsif attacker.item == :TOXICORB
              if target.pbCanPoison?(nil,false,nil) &&
                 !target.hasActiveAbility?(:POISONHEAL) &&
                 !target.hasActiveAbility?(:TOXICBOOST) &&
                 !target.hasActiveAbility?(:MAGICGUARD)
                if target.hasActiveAbility?(:GUTS)
                  score += 20
                else
                  score += 40
                end
              end
            elsif attacker.item == :STICKYBARB
              score += 45 if !target.hasActiveAbility?(:MAGICGUARD)
            elsif attacker.item == :CHOICESCARF
              score += 50
            elsif attacker.item == :CHOICEBAND
              if !target_has_physical
                score += 60
              else
                score += 35
              end
            elsif attacker.item == :CHOICESPECS
              if !target_has_special
                score += 60
              else
                score += 35
              end
            end
          end
        end
      when 0x0F3
        # Bestow
        if partner && partner.item==0 && attacker.item > 0
          score -= 50
        end
      when 0x0F4
        # Bug Bite / Pluck
        if pbIsBerry?(attacker.item)
          score += 40
        end
      when 0x0F5
        # Incinerate
        if pbIsBerry?(attacker.item)
          score += 30
        end
      when 0x0F6
        # Recycle
        if attacker.item == 0 && attacker.pokemon.itemRecycle > 0
          score += 30
        end
      when 0x0F7
        # Fling
        if attacker.item > 0
          if attacker.item == :FLAMEORB
            if target.pbCanBurn?(attacker,false,move) &&
               !target.hasActiveAbility?(:GUTS) &&
               !target.hasActiveAbility?(:FLAREBOOST)
              if target_has_physical && target_has_special
                score += 20
              elsif target_has_physical
                score += 10
              end
            end
          elsif attacker.item == :TOXICORB || attacker.item == :POISONBARB
            if target.pbCanPoison?(attacker,false,move) &&
               !target.hasActiveAbility?(:POISONHEAL) &&
               !target.hasActiveAbility?(:TOXICBOOST) &&
               !target.hasActiveAbility?(:MAGICGUARD)
              if target.hasActiveAbility?(:GUTS)
                score += 20
              else
                score += 40
              end
            end
          elsif attacker.item == :LIGHTBALL
            if target.pbCanParalyze?(attacker,false,move) &&
               !target.hasActiveAbility?(:QUICKFEET)
              target_speed = target.pbSpeed
              attacker_speed = attacker.pbSpeed
              if target_speed > attacker_speed && target_speed / 2 < attacker_speed
                effscore += 15
              end
              if !attacker.pbPartner.isFainted?
                partner_speed = attacker.pbPartner.pbSpeed
                if target_speed > partner_speed
                  effscore += 15
                end
              end
              if !target.hasActiveAbility?(:GUTS)
                effscore += 10
              end
            end
          elsif attacker.item == :KINGSROCK || attacker.item == :RAZORFANG
            if !target.hasActiveAbility?(:INNERFOCUS)
              actionable[target.index] == false if chosen
            end
          end
        end
      when 0x0F8
        # Embargo
        if target.effects[PBEffects::Embargo] <= 0
          score += 35
        end
      when 0x0F9
        # Magic Room
        if self.field.effects[PBEffects::MagicRoom] <= 0
          score += 30
        end
      when 0x0FA
        # 25% Recoil
        if !attacker.hasActiveAbility?(:MAGICGUARD) &&
           !attacker.hasActiveAbility?(:ROCKHEAD)
          score -= damage * 25 / attacker.totalhp
          score -= 20 if damage * 0.25 > attacker.hp
        end
      when 0x0FB, 0x0FD, 0x0FE
        # 33% Recoil
        if !attacker.hasActiveAbility?(:MAGICGUARD) &&
           !attacker.hasActiveAbility?(:ROCKHEAD)
          score -= damage * 33 / attacker.totalhp
          score -= 20 if damage * 0.33 > attacker.hp
        end
      when 0x0FC
        # 50% Recoil
        if !attacker.hasActiveAbility?(:MAGICGUARD) &&
           !attacker.hasActiveAbility?(:ROCKHEAD)
          score -= damage * 50 / attacker.totalhp
          score -= 20 if damage * 0.5 > attacker.hp
        end
      when 0x0FF
        # Sunny Day
        if self.pbWeather != PBWeather::SUNNYDAY
          score += 40
          # Extra points if removing other weather
          if self.pbWeather != 0
            score += 10
          end
          score += 30 if attacker.hasActiveAbility?(:FLOWERGIFT)
          score += 30 if partner && partner.hasActiveAbility?(:FLOWERGIFT)
        end
      when 0x100
        # Rain Dance
        if self.pbWeather != PBWeather::RAINDANCE
          score += 40
          # Extra points if removing other weather
          if self.pbWeather != 0
            score += 10
          end
        end
      when 0x101
        # Sandstorm
        if self.pbWeather != PBWeather::SANDSTORM
          score += 40
          # Extra points if removing other weather
          if self.pbWeather != 0
            score += 10
          end
        end
      when 0x102
        # Hail
        if self.pbWeather != PBWeather::HAIL
          score += 40
          # Extra points if removing other weather
          if self.pbWeather != 0
            score += 10
          end
        end
      when 0x103
        # Spikes
        # Do not use against Magic Bounce and do not spam against Rapid Spin / Defog
        if (!opponent1 || (!opponent1.hasActiveAbility?(:MAGICBOUNCE) &&
            opponent1.lastMoveUsed != :RAPIDSPIN && opponent1.lastMoveUsed != :DEFOG)) &&
           (!opponent2 || (!opponent2.hasActiveAbility?(:MAGICBOUNCE) &&
            opponent2.lastMoveUsed != :RAPIDSPIN && opponent2.lastMoveUsed != :DEFOG))
          if attacker.pbOpposingSide.effects[PBEffects::Spikes] < 3
            # Check for Flying / Levitate in opposing party
            hittable = 0
            for p in self.pbParty((attacker.index + 1) % 2)
              if p.hp > 0 && !p.pbHasType?(:FLYING) && p.ability != :LEVITATE
                hittable += 1
              end
            end
            if hittable > 0
              score += 10
              # Multiple layers is wanted
              score += 5 * attacker.pbOpposingSide.effects[PBEffects::Spikes]
              score += 10 * hittable
            end
          end
        end
      when 0x104
        # Toxic Spikes
        # Do not use against Magic Bounce and do not spam against Rapid Spin / Defog
        if (!opponent1 || (!opponent1.hasActiveAbility?(:MAGICBOUNCE) &&
            opponent1.lastMoveUsed != :RAPIDSPIN && opponent1.lastMoveUsed != :DEFOG)) &&
           (!opponent2 || (!opponent2.hasActiveAbility?(:MAGICBOUNCE) &&
            opponent2.lastMoveUsed != :RAPIDSPIN && opponent2.lastMoveUsed != :DEFOG))
          if attacker.pbOpposingSide.effects[PBEffects::ToxicSpikes] < 2
            # Check for Poison / Steel types or Flying / Levitate in opposing party
            hittable = 0
            for p in self.pbParty((attacker.index + 1) % 2)
              if p.hp > 0 && !p.pbHasType?(:FLYING) && !p.pbHasType?(:STEEL) &&
                 !p.pbHasType?(:POISON) && p.ability != :LEVITATE
                hittable += 1
              elsif p.hp > 0 && p.pbHasType?(:POISON)
                score -= 15
              end
            end
            if hittable > 0
              score += 10
              # Multiple layers is wanted
              score += 15 if attacker.pbOpposingSide.effects[PBEffects::ToxicSpikes] == 1
              score += 10 * hittable
            end
          end
        end
      when 0x105
        # Stealth Rock
        # Do not use against Magic Bounce and do not spam against Rapid Spin / Defog
        if (!opponent1 || (!opponent1.hasActiveAbility?(:MAGICBOUNCE) &&
            opponent1.lastMoveUsed != :RAPIDSPIN && opponent1.lastMoveUsed != :DEFOG)) &&
           (!opponent2 || (!opponent2.hasActiveAbility?(:MAGICBOUNCE) &&
            opponent2.lastMoveUsed != :RAPIDSPIN && opponent2.lastMoveUsed != :DEFOG))
          if !attacker.pbOpposingSide.effects[PBEffects::StealthRock]
            # Check effectiveness against party
            effectiveness = 1.0
            party_size = 0
            for p in self.pbParty((attacker.index + 1) % 2)
              if p.hp > 0
                party_size += 1
                types = [p.type1]
                types.push(p.type2) if p.type2 >= 0 && p.type2 != p.type1
                for t in types
                  case t
                  when PBTypes::FIRE, PBTypes::ICE, PBTypes::FLYING, PBTypes::BUG
                    effectiveness *= 2.0
                  when PBTypes::FIGHTING, PBTypes::GROUND, PBTypes::STEEL
                    effectiveness *= 0.5
                  end
                end
              end
            end
            score += 10 * effectiveness * party_size
          end
        end
      when 0x106
        # Grass Pledge
        if partner
          fire_pledge = false
          water_pledge = false
          for m in partner.moves
            if m.id == :FIREPLEDGE
              fire_pledge = true
              break
            elsif m.id == :WATERPLEDGE
              water_pledge = true
              break
            end
          end
          if fire_pledge && attacker.pbOpposingSide.effects[PBEffects::SeaOfFire] <= 0
            score += 50
          elsif water_pledge && attacker.pbOpposingSide.effects[PBEffects::Swamp] <= 0
            score += 50
          end
        end
      when 0x107
        # Fire Pledge
        if partner
          grass_pledge = false
          water_pledge = false
          for m in partner.moves
            if m.id == :GRASSPLEDGE
              grass_pledge = true
              break
            elsif m.id == :WATERPLEDGE
              water_pledge = true
              break
            end
          end
          if grass_pledge && attacker.pbOpposingSide.effects[PBEffects::SeaOfFire] <= 0
            score += 50
          elsif water_pledge && attacker.pbOwnSide.effects[PBEffects::Rainbow] <= 0
            score += 50
          end
        end
      when 0x108
        # Water Pledge
        if partner
          fire_pledge = false
          grass_pledge = false
          for m in partner.moves
            if m.id == :FIREPLEDGE
              fire_pledge = true
              break
            elsif m.id == :GRASSPLEDGE
              grass_pledge = true
              break
            end
          end
          if fire_pledge && attacker.pbOwnSide.effects[PBEffects::Rainbow] <= 0
            score += 50
          elsif grass_pledge && attacker.pbOpposingSide.effects[PBEffects::Swamp] <= 0
            score += 50
          end
        end
      when 0x10A
        # Brick Break
        if !target.pbHasType?(:GHOST) || target.effects[PBEffects::Foresight]
          if target.pbOwnSide.effects[PBEffects::Reflect] > 0
            score += 20
          end
          if target.pbOwnSide.effects[PBEffects::LightScreen] > 0
            score += 20
          end
          if target.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
            score += 30
          end
        end
      when 0x10B
        # (High) Jump Kick
        if target != partner
          if target.pbHasType?(:GHOST) && !target.effects[PBEffects::Foresight]
            score -= 50
          end
        end
      when 0x10C
        # Substitute
        if attacker.hp > attacker.totalhp * 0.3
          if attacker.effects[PBEffects::ProtectRate]==1
            score += 15
            score += 10 if attacker.hp > attacker.totalhp * 0.5
            score += 10 if attacker.hp > attacker.totalhp * 0.75
            score += 10 if attacker.hp >= attacker.totalhp
            score += 10 if opponent1 && opponent1.status == :POISON
            score += 10 if opponent2 && opponent2.status == :POISON
            score += 15 if opponent1 && opponent1.effects[PBEffects::Curse]
            score += 15 if opponent2 && opponent2.effects[PBEffects::Curse]
            score += 20 if opponent1 && opponent1.effects[PBEffects::PerishSong]>0
            score += 20 if opponent2 && opponent2.effects[PBEffects::PerishSong]>0
          end
        end
      when 0x10D
        # Curse
        if attacker.pbHasType?(:GHOST) && !attacker.hasActiveItem?(:AEGISTALISMAN)
          if !target.effects[PBEffects::Curse] && target_item != :AEGISTALISMAN
            if attacker.hp > attacker.totalhp * 0.3
              score += 15
              score += 10 if attacker.hp > attacker.totalhp * 0.5
              score += 10 if attacker.hp > attacker.totalhp * 0.75
              score += 10 if attacker.hp >= attacker.totalhp
            end
          end
        else
          if attacker.pbCanIncreaseStatStage?(PBStats::DEFENSE,attacker,false,move,false,true)
            # Defense +1
            statscore += 5
            statscore += 10 if physical_opponents > 0
          end
          
          if attacker.pbCanIncreaseStatStage?(PBStats::ATTACK,attacker,false,move,false,true)
            # Attack +1
            statscore += 20 if has_physical
          end
        end
      when 0x10E
        # Spite
        if target.lastMoveUsed > 0 && target_item != :AEGISTALISMAN
          for m in target.moves
            # Prioritize more the less PP the target's move has
            if m.id == target.lastMoveUsed
              if m.pp < 15
                score += 30
                score += (15 - m.pp) * 2
              end
            end
          end
        end
      when 0x10F
        # Nightmare
        if target.status == :SLEEP && target.statusCount > 1 && target_item != :AEGISTALISMAN
          score += 20
          score += 20 if target.statusCount > 2
        end
      when 0x110
        # Rapid Spin
        score += 10 * attacker.pbOwnSide.effects[PBEffects::Spikes]
        score += 15 * attacker.pbOwnSide.effects[PBEffects::ToxicSpikes]
        score += 20 if attacker.pbOwnSide.effects[PBEffects::StealthRock]
      when 0x111
        # Doom Desire / Future Sight
        if target != partner
          if target.effects[PBEffects::FutureSight] <= 0
            if !attacker.hasActiveAbility?(:TIMESKIP) &&
               !attacker.hasActiveItem?(:ODDSTONE) &&
               !attacker.hasActiveItem?(:TIMESTONE)
              score -= 20
            end
          end
        end
      when 0x112
        # Stockpile
        if attacker.effects[PBEffects::Stockpile] < 3
          score += 30
        end
      when 0x113
        # Spit Up
        if target != partner && attacker.effects[PBEffects::Stockpile] > 0
          # Negative score to indicate lost stat stages
          score -=  attacker.effects[PBEffects::Stockpile] * 15
          # Damage is handled elsewhere
        end
      when 0x114
        # Swallow
        if attacker.effects[PBEffects::Stockpile] > 0
          # Negative score to indicate lost stat stages
          score -=  attacker.effects[PBEffects::Stockpile] * 15
          amt = 25
          amt = 50 if attacker.effects[PBEffects::Stockpile] == 2
          amt = 100 if attacker.effects[PBEffects::Stockpile] == 3
          score += [amt, 100 - [attacker.hp * 100 / attacker.totalhp,100].min].min
        end
      when 0x115
        # Focus Punch
        if target != partner
          can_attack = false
          if opponent1 && actionable[opponent1.index]
            can_attack = true
            score -= 20
          end
          if opponent2 && actionable[opponent2.index]
            can_attack = true
            score -= 20
          end
          score -= 40 if can_attack
        end
      when 0x116
        # Sucker Punch
        # May or may not use Sucker Punch consecutively
        if target != partner
          if attacker.lastMoveUsed == :SUCKERPUNCH
            score -= 30 + self.pbRandom(50)
          end
        end
      when 0x117
        # Follow Me / Rage Powder
        score += 35
      when 0x118
        # Gravity
        if self.field.effects[PBEffects::Gravity] <= 0
          airborne = 0
          airborne += 1 if opponent1 && opponent1.isAirborne?
          airborne += 1 if opponent2 && opponent2.isAirborne?
          score += 30 if airborne > 0
          score += 20 * airborne
        end
      when 0x119
        # Magnet Rise
        if attacker.effects[PBEffects::MagnetRise] <= 0
          score += 20
          allmoves = []
          allmoves += opponent1.moves if opponent1
          allmoves += opponent2.moves if opponent2
          for m in allmoves
            if m.type == PBTypes::GROUND
              if attacker.pbHasType?(:ELECTRIC) && attacker.pbHasType?(:STEEL)
                score += 60
              elsif attacker.pbHasType?(:ELECTRIC) || attacker.pbHasType?(:STEEL) || attacker.pbHasType?(:ROCK)
                score += 40
              else
                score += 20
              end
            end
          end
        end
      when 0x11A
        # Telekinesis
        if target.effects[PBEffects::Telekinesis] <= 0
          score += 30
        end
      when 0x11C
        # Smack Down
        if !target.effects[PBEffects::SmackDown]
          if target.isAirborne?
            score += 30
          end
        end
      when 0x11F
        # Trick Room
        if self.field.effects[PBEffects::TrickRoom] <= 0
          score += 20
          for s in opponent_speeds
            if s > speed_stat
              score += 30
            end
          end
        end
      when 0x120
        # Ally Switch
        score += 10 + self.pbRandom(40)
      when 0x124
        # Wonder Room
        if self.field.effects[PBEffects::WonderRoom] <= 0
          score += 40
        end
      when 0x125
        # Last Resort
        # Should hopefully be handled by pbMoveFailed
      when 0x137
        # Magnetic Flux
        buff_count = 0
        if attacker.hasActiveAbility?(:PLUS) || attacker.hasActiveAbility?(:MINUS)
          if attacker.pbCanIncreaseStatStage?(PBStats::DEFENSE,attacker,false,move,false,true) ||
             attacker.pbCanIncreaseStatStage?(PBStats::SPDEF,attacker,false,move,false,true)
            buff_count += 1
          end
        end
        if partner && (partner.hasActiveAbility?(:PLUS) || partner.hasActiveAbility?(:MINUS))
          if partner.pbCanIncreaseStatStage?(PBStats::DEFENSE,attacker,false,move,false,true) ||
             partner.pbCanIncreaseStatStage?(PBStats::SPDEF,attacker,false,move,false,true)
            buff_count += 1
          end
        end
        score += 30 * buff_count
      when 0x138
        # Aromatic Mist
        if partner && partner.pbCanIncreaseStatStage?(PBStats::SPDEF,attacker,false,move,false,true)
          score += 5
          score += 10 if special_opponents >= 1
          score += 10 if special_opponents >= 2
        end
      when 0x13E
        # Rototiller
        buff_count = 0
        if !attacker.isAirborne? && attacker.pbHasType?(:GRASS)
          if attacker.pbCanIncreaseStatStage?(PBStats::ATTACK,attacker,false,move,false,true) ||
             attacker.pbCanIncreaseStatStage?(PBStats::SPATK,attacker,false,move,false,true)
            buff_count += 1
          end
        end
        if partner && partner.isAirborne? && partner.pbHasType?(:GRASS)
          if partner.pbCanIncreaseStatStage?(PBStats::ATTACK,attacker,false,move,false,true) ||
             partner.pbCanIncreaseStatStage?(PBStats::SPATK,attacker,false,move,false,true)
            buff_count += 1
          end
        end
        score += 25 * buff_count
      when 0x13F
        # Flower Shield
        buff_count = 0
        if attacker.pbHasType?(:GRASS)
          if attacker.pbCanIncreaseStatStage?(PBStats::DEFENSE,attacker,false,move,false,true)
            buff_count += 1
          end
        end
        if partner && partner.pbHasType?(:GRASS)
          if partner.pbCanIncreaseStatStage?(PBStats::DEFENSE,attacker,false,move,false,true)
            buff_count += 1
          end
        end
        score += 5 * buff_count
        score += 10 * buff_count if physical_opponents >= 1
        score += 10 * buff_count if physical_opponents >= 2
      when 0x141
        # Topsy-Turvy
        total = 0
        for t in 1..5
          total += target.stages[t]
        end
        score += total * 10
      when 0x142
        # Trick-or-Treat
        if !target.pbHasType?(:GHOST) && target_item != :AEGISTALISMAN
          score += 30
        end
      when 0x143
        # Forest's Curse
        if !target.pbHasType?(:GRASS) && target_item != :AEGISTALISMAN
          score += 35
        end
      when 0x145
        # Electrify
        score += 30
      when 0x146
        # Ion Deluge
        score += 25
      when 0x148
        # Powder
        for m in target.moves
          if m.type == PBTypes::FIRE
            if attacker.lastMoveUsed == :POWDER
              score += 10 + rand(30)
            else
              score += 40
            end
          end
        end
      when 0x149
        # Mat Block
        score += 20 if attacker.effects[PBEffects::ProtectRate]==1
      when 0x14A
        # Crafty Shield
        score += 20 if attacker.effects[PBEffects::ProtectRate]==1
      when 0x14B
        # King's Shield
        if attacker.effects[PBEffects::ProtectRate]==1
          score += 25
          score += 10 if physical_opponents >= 1
          score += 10 if physical_opponents >= 2
          score += 30 if attacker.form == 1
        end
      when 0x14C
        # Spiky Shield
        if attacker.effects[PBEffects::ProtectRate]==1
          score += 25
          score += 10 if physical_opponents >= 1
          score += 10 if physical_opponents >= 2
        end
      when 0x14E
        # Geomancy
        if attacker.pbCanIncreaseStatStage?(PBStats::SPATK,attacker,false,move,false,true) &&
           attacker.pbCanIncreaseStatStage?(PBStats::SPDEF,attacker,false,move,false,true) &&
           attacker.pbCanIncreaseStatStage?(PBStats::SPEED,attacker,false,move,false,true)
          if attacker.hasActiveItem?(:POWERHERB)
            score += 120
          else
            score += 35
          end
        end
      when 0x14F
        # 75% Drain
        # Grant score based on how much HP will be healed
        if target != partner
          amt = [damage * 75 / attacker.totalhp, 100 - [attacker.hp * 100 / attacker.totalhp, 100].min].min
          score += target.hasActiveAbility?(:LIQUIDOOZE) ? -amt : amt
        end
      when 0x150
        # Fell Stinger
        if damage > target.hp
          score += 70
        end
      when 0x151
        # Parting Shot
        party_able = 0
        for p in self.pbParty(target.index)
          party_able += 1 if p.hp > 0
        end
        # Make sure user has enough Pokemon to switch
        if party_able > 2
          score += 25
          for t in 1..5
            # Gain 10 points for each stat decrease to remove
            stage = attacker.stages[t]
            score -= stage * 10
          end
          # Use less often if switched Pokemon will be hurt by hazards
          score -= 10 if target.pbOwnSide.effects[PBEffects::StealthRock]
          score -= 5 * target.pbOwnSide.effects[PBEffects::Spikes]
        end
      when 0x152
        # Fairy Lock
        score += 10 + self.pbRandom(30)
      when 0x153
        # Sticky Web
        # Do not use against Magic Bounce and do not spam against Rapid Spin / Defog
        if (!opponent1 || (!opponent1.hasActiveAbility?(:MAGICBOUNCE) &&
            opponent1.lastMoveUsed != :RAPIDSPIN && opponent1.lastMoveUsed != :DEFOG)) &&
           (!opponent2 || (!opponent2.hasActiveAbility?(:MAGICBOUNCE) &&
            opponent2.lastMoveUsed != :RAPIDSPIN && opponent2.lastMoveUsed != :DEFOG))
          if !attacker.pbOpposingSide.effects[PBEffects::StickyWeb]
            # Check party size to estimate value
            party_size = 0
            for p in self.pbParty((attacker.index + 1) % 2)
              if p.hp > 0
                party_size += 1
              end
            end
            if party_size > 2
              score += 40
              score += 15 * party_size
            end
          end
        end
      when 0x154
        # Electric Terrain
        if self.field.effects[PBEffects::ElectricTerrain] <= 0
          score += 40
          score += 20 if attacker.hasActiveItem?(:TERRAINEXTENDER)
        end
      when 0x155
        # Grassy Terrain
        if self.field.effects[PBEffects::GrassyTerrain] <= 0
          score += 40
          score += 20 if attacker.hasActiveItem?(:TERRAINEXTENDER)
          score += 30 if attacker.hasActiveAbility?(:GRASSPELT)
          score += 30 if partner && partner.hasActiveAbility?(:GRASSPELT)
        end
      when 0x156
        # Misty Terrain
        if self.field.effects[PBEffects::MistyTerrain] <= 0
          score += 40
          score += 20 if attacker.hasActiveItem?(:TERRAINEXTENDER)
        end
      when 0x15B
        # Baneful Bunker
        if attacker.effects[PBEffects::ProtectRate]==1
          score += 25
          if (opponent1 && opponent1.pbCanPoison?(attacker,false,nil)) ||
             (opponent2 && opponent2.pbCanPoison?(attacker,false,nil))
            score += 10 if physical_opponents >= 1
            score += 10 if physical_opponents >= 2
          end
        end
      when 0x15D
        # Sparkling Aria
        if target.status == :BURN
          score -= 20
        end
      when 0x15E
        # Floral Healing
        # Do not use against opponents
        if target != partner
          score -= 30
        end
        if target.hp < target.totalhp * 0.75
          amt = 50
          amt = 67 if self.field.effects[PBEffects::GrassyTerrain] > 0
          score -= [amt, 100 - [target.hp * 100 / target.totalhp, 100].min].min
        end
      when 0x15F
        # Strength Sap
        if target.pbCanReduceStatStage?(PBStats::ATTACK,attacker,false,move,moldbreaker,true)
          if !target.hasActiveAbility?(:CONTRARY)
            score += 15 if target_has_physical
            amt = target.attack * 100 / attacker.totalhp
            score += [amt, 100 - [target.hp * 100 / target.totalhp, 100].min].min
          end
        end
      when 0x160
        # Spotlight - Unhandled
        score += 10
      when 0x161
        # Toxic Thread
        if target.pbCanPoison?(attacker,false,move) &&
           !target.hasActiveAbility?(:POISONHEAL) &&
           !target.hasActiveAbility?(:TOXICBOOST) &&
           !target.hasActiveAbility?(:GUTS) &&
           !target.hasActiveAbility?(:MAGICGUARD)
          score += 20
        end
        if target.pbCanReduceStatStage?(PBStats::SPEED,attacker,false,move,moldbreaker,true)
          # Speed -1
          score += 5
          for s in ally_speeds
            if s <= target_speed && s > target_speed * 2 / 3
              score += 15
            end
          end
        end
      when 0x162
        # Laser Focus
        if !attacker.effects[PBEffects::LaserFocus] &&
           attacker.pbOpposingSide.effects[PBEffects::LuckyChant]<=0 # Do not use during Lucky Chant
          addscore = 30
          if attacker.hasActiveAbility?(:SNIPER)
            # Has Sniper, crit rate is ideal
            addscore += 30
          end
          # Crit Rate is not optimal against opponents with crit immunity
          if opponent1 && (opponent1.hasActiveAbility?(:SHELLARMOR) || opponent1.hasActiveAbility?(:BATTLEARMOR))
            addscore *= 0.5
          end
          if opponent2 && (opponent2.hasActiveAbility?(:SHELLARMOR) || opponent2.hasActiveAbility?(:BATTLEARMOR))
            addscore *= 0.5
          end
          score += addscore
        end
      when 0x163
        # Gear Up
        buff_count = 0
        if attacker.hasActiveAbility?(:PLUS) || attacker.hasActiveAbility?(:MINUS)
          if attacker.pbCanIncreaseStatStage?(PBStats::ATTACK,attacker,false,move,false,true) ||
             attacker.pbCanIncreaseStatStage?(PBStats::SPATK,attacker,false,move,false,true)
            buff_count += 1
          end
        end
        if partner && (partner.hasActiveAbility?(:PLUS) || partner.hasActiveAbility?(:MINUS))
          if partner.pbCanIncreaseStatStage?(PBStats::ATTACK,attacker,false,move,false,true) ||
             partner.pbCanIncreaseStatStage?(PBStats::SPATK,attacker,false,move,false,true)
            buff_count += 1
          end
        end
        score += 35 * buff_count
      when 0x164
        # Throat Chop
        if target.effects[PBEffects::ThroatChop] <= 0
          # Prioritize if target has sound moves
          found = false
          for m in target.moves
            if m.isSoundBased?
              score += found ? 10 : 30
            end
          end
        end
      when 0x165
        # Pollen Puff
        if target == partner
          # Nullify score lost from damaging partner
          score -= damage * 100 / target.totalhp
          if target.hp < target.totalhp * 0.75
            score -= [50, 100 - [target.hp * 100 / target.totalhp, 100].min].min
          end
        end
      when 0x166
        # Psychic Terrain
        if self.field.effects[PBEffects::PsychicTerrain] <= 0
          score += 40
          score += 20 if attacker.hasActiveItem?(:TERRAINEXTENDER)
        end
      when 0x167
        # Burn Up - Unhandled
      when 0x168
        # Speed Swap
        # The more the target's stats multiply your own, the better
        if target_speed > speed_stat
          if self.field.effects[PBEffects::TrickRoom] <= 1
            score += 30
            score += (target_speed - speed_stat) * 0.5
          end
        elsif target_speed < speed_stat
          # Swap speed 
          if self.field.effects[PBEffects::TrickRoom] > 2
            score += (target_speed - speed_stat) * 0.5
          end
        end
      when 0x169
        # Purify
        if target.status > 0
          score -= 10
          score += [50, 100 - [attacker.hp * 100 / attacker.totalhp, 100].min].min
        end
      when 0x16C
        # Instruct
        if target == partner
          score -= 40
        else
          # Do not use on opponents
          score -= 50
        end
      when 0x16D
        # Beak Blast
        if target.pbCanBurn?(attacker,false,nil)
          score += 5 if physical_opponents >= 1
          score += 5 if physical_opponents >= 2
        end
      when 0x16F
        # Aurora Veil
        if self.pbWeather == PBWeather::HAIL
          if attacker.pbOwnSide.effects[PBEffects::AuroraVeil]<=0
            score += 60
            score += 20 if attacker.hasActiveItem?(:LIGHTCLAY)
          end
        end
      when 0x170
        # Shell Trap
        if physical_opponents > 0
          # Use Shell Trap semi-randomly
          if attacker.lastMoveUsed == :SHELLTRAP
            score += 10 + self.pbRandom(40)
          else
            score += 40 + self.pbRandom(40)
          end
        else
          score -= 20
        end
      when 0x172
        # Spectral Thief
        # Better the more buffs the target has
        oppstat = 0
        for t in 1..5
          oppstat += target.stages[t]
        end
        score = oppstat * 10
      when 0x175
        # Corrosive Acid
        if !target.effects[PBEffects::CorrosiveAcid]
          if target.pbHasType?(:STEEL) || target.pbHasType?(:POISON)
            score += 30
          end
        end
      when 0x176
        # Winds
        if self.pbWeather != PBWeather::WINDS
          score += 40
          # Extra points if removing other weather
          if self.pbWeather != 0
            score += 10
          end
        end
      when 0x177
        # Mind Blown / Steel Beam
        score -= 40
      when 0x178
        # Plasma Fists
        for m in target.moves
          if m.type == PBTypes::NORMAL
            score += 10
          end
        end
      end
      
      mult = 100.0
      if move.addlEffect != 0
        mult = move.addlEffect
        mult *= 2.0 if attacker.hasActiveAbility?(:SERENEGRACE)
        mult *= 0.0 if attacker.hasActiveAbility?(:SHEERFORCE)
      end
      if target && move.category == 2
        mult *= 0.5 if target.hasActiveAbility?(:WONDERSKIN)
        mult *= -1.0 if target.hasActiveAbility?(:MAGICBOUNCE)
      end
      if move.target == PBTargets::OpposingSide && move.category == 2
        if (opponent1 && opponent1.hasActiveAbility?(:MAGICBOUNCE)) ||
           (opponent2 && opponent2.hasActiveAbility?(:MAGICBOUNCE))
          mult *= -1.0
        end
      end
      return score + (effscore + statscore + debuffscore) * mult / 100.0
    end
    
    def pbChooseMovesDoubles(index1,index2)
      attacker1=@battlers[index1]
      attacker2=@battlers[index2]
      
      # The highest damage a Pokemon can do this turn, used for switching
      dmg_potential = [0, 0, 0, 0]
      # The most damage a Pokemon can take this turn, used for switching
      hurt_potential = [0, 0, 0, 0]
      
      # Scores for all move combinations
      scores=[[0,0,0,0],
              [0,0,0,0],
              [0,0,0,0],
              [0,0,0,0]]
      
      # Optimal targets for all move combinations
      targets=[[[-1,-1],[-1,-1],[-1,-1],[-1,-1]],
               [[-1,-1],[-1,-1],[-1,-1],[-1,-1]],
               [[-1,-1],[-1,-1],[-1,-1],[-1,-1]],
               [[-1,-1],[-1,-1],[-1,-1],[-1,-1]]]
      
      # Whether a pokemon is actionable at the start of turn
      actionablestart=[true,true,true,true]
      faintedstart=[false,false,false,false]
      for i in 0...4
        if @battlers[i].isFainted?
          actionablestart[i]=false
          faintedstart[i]=true
        end
      end
      
      myChoices=[]
      totalscore=0
      skill=0
      wildbattle=!@opponent && pbIsOpposing?(index)
      if wildbattle && $game_variables[WILD_AI_LEVEL] <= 0
        # If wild battle
        # Random moves
        for i in 0...4
          if pbCanChooseMove?(index1,i,false)
            for j in 0...4
              if pbCanChooseMove?(index2,j,false)
                scores[i][j]=100
                myChoices.push([i,j])
                totalscore+=100
              end
            end
          end
        end
      else
      
        ### Predict the turn order
        # Find all participants
        participants=[]
        for i in 0...4
          if !@battlers[i].isFainted?
            participants.push(i)
          end
        end
        
        # Determine queue
        queue=[]
        while participants.length>0
          max_index = -1
          max_speed = -1
          for i in participants
            speed = @battlers[i].pbSpeed
            if speed > max_speed
              max_index = i
              max_speed = speed
            end
          end
          queue.push(max_index)
          participants.delete(max_index)
        end
        
        # First pokemon's move
        for i in 0...4
          move1 = attacker1.moves[i]
          pri1 = pbRoughPriority(attacker1,move1)
          
          # Second pokemon's move
          for j in 0...4
            move2 = attacker2.moves[j]
            pri2 = pbRoughPriority(attacker2,move2)
            
            if attacker1.moves[i].id<=0 || attacker2.moves[j].id<=0
              scores[i][j] = -9999
              next
            end
            
            # Handle positive priority
            if pri1 > 0 && pri2 > 0
              queue.delete(1)
              queue.delete(3)
              # Compare priority of both opponents
              if pri1 < pri2
                queue.unshift(3)
                queue.unshift(1)
              elsif pri1 > pri2
                queue.unshift(1)
                queue.unshift(3)
              else
                # Same priority, compare speed
                if attacker1.pbSpeed > attacker2.pbSpeed
                  queue.unshift(1)
                  queue.unshift(3)
                else
                  queue.unshift(3)
                  queue.unshift(1)
                end
              end
            elsif pri1 > 0
              # Place first opponent at start of queue
              queue.delete(1)
              queue.unshift(1)
            elsif pri2 > 0
              # Place second opponent at start of queue
              queue.delete(3)
              queue.unshift(3)
            end
            
            # Handle negative priority
            # Does not handle edge cases where both have negative priority
            if pri1 < 0
              # Place first opponent at end of queue
              queue.delete(1)
              queue.push(1)
            end
            if pri2 < 0
              # Place second opponent at end of queue
              queue.delete(3)
              queue.push(3)
            end
            
            # Create temporary actionable and fainted array for this simulation
            actionable = []
            for a in actionablestart
              actionable.push(a)
            end
            fainted = []
            for f in faintedstart
              fainted.push(f)
            end
            
            # If the first opposing pokemon has affinity boosted the other
            affinityboost = false
            
            # Simulate each turn in order with the two moves
            # Update scores and targets
            for q in queue
              battler = @battlers[q]
              next if battler.isFainted? || !actionable[q]
              
              if q % 2 == 0
                ## Player pokemon, predict damage
                # Add known moves and STAB moves to checklist
                moves = []
                for m in battler.moves
                  if battler.pbIsMoveRevealed?(m.id) ||
                     battler.pbHasType?(m.type)
                    moves.push(m)
                  end
                end
                
                # TODO
                # - Account for multi-target moves
                # - Affinity Boosts?
                
                # Stop predicting if no moves are known
                if moves.length > 0
                  
                  # Get possible targets
                  possible_targets = []
                  if @battlers[(battler.index+1) % 4] && !@battlers[(battler.index+1) % 4].isFainted?
                    possible_targets.push(@battlers[(battler.index+1) % 4])
                  end
                  if @battlers[(battler.index+3) % 4] && !@battlers[(battler.index+3) % 4].isFainted?
                    possible_targets.push(@battlers[(battler.index+3) % 4])
                  end
                  
                  best_move = nil
                  best_damage = -1
                  best_target = -1
                  fixed_move = 0
                
                  if (battler.hasActiveItem?(:CHOICEBAND) || battler.hasActiveItem?(:CHOICESPECS) ||
                     battler.hasActiveItem?(:CHOICESCARF)) && battler.effects[PBEffects::ChoiceBand] > 0
                    # Choiced
                    fixed_move = battler.effects[PBEffects::ChoiceBand]
                  elsif battler.effects[PBEffects::Encore] > 0
                    # Encore
                    fixed_move = battler.effects[PBEffects::EncoreMove]
                  end
                    
                  if fixed_move > 0
                    # Find optimal damaging play for player when move is fixed
                    for m in moves
                      if m.id == fixed_move
                        best_move = m
                        for t in possible_targets
                          damage = m.pbPredictDamage(battler, t, queue, false)
                          if damage > best_damage
                            best_damage = damage
                            best_target = t
                          end
                          hurt = damage * 100 / t.totalhp
                          if hurt > hurt_potential[t.index]
                            hurt_potential[t.index] = hurt
                          end
                        end
                      end
                    end
                  else
                    # Find optimal damaging play for player
                    for t in possible_targets
                      for m in moves
                        # PP
                        next if m.pp <= 0
                        # Torment
                        next if battler.effects[PBEffects::Torment] && battler.lastMoveUsed == m.id
                        # Disable
                        next if battler.effects[PBEffects::Disable] && battler.effects[PBEffects::DisableMove] == m.id
                        # Damage Check
                        damage = m.pbPredictDamage(battler, t, queue, false)
                        if damage > best_damage
                          best_move = m
                          best_damage = damage
                          best_target = t
                        end
                        hurt = damage * 100 / t.totalhp
                        if hurt > hurt_potential[t.index]
                          hurt_potential[t.index] = hurt
                        end
                      end
                    end
                  end
                  
                  # Ensure move is not nil
                  if best_move
                    if best_damage > best_target.hp
                      # The pokemon will faint, subtract a high score an set inactionable
                      scores[i][j] -= [best_target.hp * 200 / best_target.totalhp,50].max
                      #actionable[best_target.index] = false
                    else
                      # Subtract percentage of total hp lost from score
                      scores[i][j] -= best_damage * 100 / best_target.totalhp
                    end
                  end
                end
                
              else
                ## Opposing pokemon, test move results
                move = (q == 1) ? move1 : move2
                target = -1
                damage = -1
                
                # TODO
                # - Account for multi-hit moves
                
                target = 0
                damage = 0
                
                if move.target == PBTargets::SingleNonUser
                  # Single target allied or opposing
                  partner = battler.pbPartner
                  possible = []
                  possible.push(0) if !@battlers[0].isFainted? && !fainted[0]
                  possible.push(2) if !@battlers[2].isFainted? && !fainted[2]
                  possible.push(partner.index) if !partner.isFainted? && !fainted[partner.index]
                  highscore = -99999
                  hightarget = 0
                  highdamage = 0
                  higheffscore = 0
                  for t in possible
                    b = @battlers[t]
                    dmg = move.pbPredictDamage(battler,b,queue,affinityboost)
                    scr = dmg * 100 / @battlers[t].totalhp
                    effscr = pbGetEffectScore(move,dmg,battler,b,actionable,fainted)
                    scr += effscr
                    if !partner.isFainted? && t == partner.index
                      scr = -scr
                    end
                    if scr > highscore
                      hightarget = t
                      highscore = scr
                      higheffscore = effscr
                      highdamage = dmg
                    end
                    # Redirection
                    if (b.hasActiveAbility?(:STORMDRAIN) && move.type == PBTypes::WATER) ||
                       (b.hasActiveAbility?(:LIGHTNINGROD) && move.type == PBTypes::ELECTRIC)
                      hightarget = t
                      highscore = scr
                      higheffscore = 0
                      highdamage = 0
                      break
                    end
                  end
                  
                  damage = highdamage
                  target = hightarget
                  
                  if highscore > dmg_potential[battler.index]
                    dmg_potential[battler.index] = highscore
                  end
                  
                  # Update actionable/fainted values
                  pbGetEffectScore(move,damage,battler,@battlers[target],actionable,fainted,true)
                  
                  if @battlers[target] == partner
                    if damage > @battlers[target].hp * 1.05
                      # The partner will faint, subtract a high score and set inactionable
                      scores[i][j] -= 150
                      actionable[target] = false
                      fainted[target] = true
                    else
                      # Subtract percentage of total hp lost to score
                      scores[i][j] -= damage * 100 / @battlers[target].totalhp + higheffscore
                    end
                  else
                    if damage > @battlers[target].hp * 1.05
                      # The target will faint, add a high score and set inactionable
                      scores[i][j] += 150
                      actionable[target] = false
                      fainted[target] = true
                    else
                      # Add percentage of total hp lost to score
                      scores[i][j] += damage * 100 / @battlers[target].totalhp + higheffscore
                    end
                  end
                  
                elsif move.target == PBTargets::NoTarget || move.target == PBTargets::User ||
                        move.target == PBTargets::UserSide || move.target == PBTargets::BothSides ||
                        move.target == PBTargets::OpposingSide
                  # Moves where no specific target is interacted with
                  target = (move.target == PBTargets::OpposingSide) ? 0 : battler.index
                  scores[i][j] += pbGetEffectScore(move,0,battler,nil,actionable,fainted,true)
                  
                elsif move.target == PBTargets::AllOpposing
                  # All opposing pokemon
                  effscr = 0
                  highscore = 0
                  if !@battlers[0].isFainted? && !fainted[0] &&
                     !@battlers[2].isFainted? && !fainted[2]
                    # Both pokemon are alive, hit both targets
                    damage1 = move.pbPredictDamage(battler,@battlers[0],queue,affinityboost)
                    damage2 = move.pbPredictDamage(battler,@battlers[2],queue,affinityboost)
                    effscr1 = pbGetEffectScore(move,damage1,battler,@battlers[0],actionable,fainted,true)
                    effscr2 = pbGetEffectScore(move,damage2,battler,@battlers[2],actionable,fainted,true)
                    effscr = effscr1 + effscr2
                    target = [0, 2]
                    if damage1 > @battlers[0].hp * 1.05
                      # The target will faint, add a high score an set inactionable
                      scores[i][j] += 150
                      actionable[0] = false
                      fainted[0] = true
                    else
                      # Add percentage of total hp lost to score
                      scores[i][j] += damage1 * 100 / @battlers[0].totalhp
                    end
                    if damage2 > @battlers[2].hp * 1.05
                      # The target will faint, add a high score an set inactionable
                      scores[i][j] += 150
                      actionable[2] = false
                      fainted[2] = true
                    else
                      # Add percentage of total hp lost to score
                      scores[i][j] += damage2 * 100 / @battlers[2].totalhp
                    end
                    damage = damage1 + damage2
                    highscore = (damage1 * 100 / @battlers[0].totalhp) + (damage2 * 100 / @battlers[2].totalhp)
                  else
                    # One or no pokemon are alive
                    if !@battlers[0].isFainted? && !fainted[0]
                      damage = move.pbPredictDamage(battler,@battlers[0],queue,affinityboost)
                      effscr = pbGetEffectScore(move,damage,battler,@battlers[0],actionable,fainted,true)
                      target = 0
                      highscore = (damage * 100 / @battlers[0].totalhp)
                    elsif !@battlers[2].isFainted? && !fainted[2]
                      damage = move.pbPredictDamage(battler,@battlers[2],queue,affinityboost)
                      effscr = pbGetEffectScore(move,damage,battler,@battlers[2],actionable,fainted,true)
                      target = 2
                      highscore = (damage * 100 / @battlers[2].totalhp)
                    else
                      damage = 0
                      target = 0
                    end
                    if damage > @battlers[target].hp * 1.05
                      # The target will faint, add a high score an set inactionable
                      scores[i][j] += 150 #[@battlers[t].hp * 100 / @battlers[t].totalhp,150].max
                      actionable[target] = false
                      fainted[target] = true
                    else
                      # Add percentage of total hp lost to score
                      scores[i][j] += damage * 100 / @battlers[target].totalhp
                    end
                    scores[i][j] += effscr
                  end
                  
                  if highscore > dmg_potential[battler.index]
                    dmg_potential[battler.index] = highscore
                  end
                  
                elsif move.target == PBTargets::AllNonUsers
                  # Everyone except user
                  partner = battler.pbPartner
                  possible = []
                  possible.push(0) if !@battlers[0].isFainted? && !fainted[0]
                  possible.push(2) if !@battlers[2].isFainted? && !fainted[2]
                  possible.push(partner.index) if !partner.isFainted? && !fainted[partner.index]
                  target = 0
                  highscore = 0
                  for t in possible
                    dmg = move.pbPredictDamage(battler,@battlers[t],queue,affinityboost)
                    effscr = pbGetEffectScore(move,dmg,battler,@battlers[t],actionable,fainted,true)
                    if !partner.isFainted? && t == partner.index
                      highscore -= (dmg * 100 / partner.totalhp)
                    else
                      highscore += (dmg * 100 / @battlers[target].totalhp)
                    end
                    if dmg > @battlers[target].hp * 1.05
                      # The target will faint, add a high score an set inactionable
                      if !partner.isFainted? && t == partner.index
                        scores[i][j] -= 150
                      else
                        scores[i][j] += 150
                      end
                      actionable[target] = false
                      fainted[target] = true
                    else
                      # Add percentage of total hp lost to score
                      if !partner.isFainted? && t == partner.index
                        scores[i][j] -= dmg * 100 / @battlers[target].totalhp + effscr
                      else
                        scores[i][j] += dmg * 100 / @battlers[target].totalhp + effscr
                      end
                    end
                  end
                  
                  if highscore > dmg_potential[battler.index]
                    dmg_potential[battler.index] = highscore
                  end
                  
                elsif move.target == PBTargets::Partner
                  # Targets the partner
                  target = battler.pbPartner.index
                  if !battler.pbPartner.isFainted?
                    if !fainted[battler.pbPartner.index]
                      scores[i][j] -= pbGetEffectScore(move,0,battler,battler.pbPartner,actionable,fainted,true)
                    end
                  else
                    scores[i][j] -= 100
                  end
                  
                elsif move.target == PBTargets::UserOrPartner
                  # Targets any allied pokemon
                  target = battler.index
                  effscr = -pbGetEffectScore(move,0,battler,battler,actionable,fainted)
                  if !battler.pbPartner.isFainted? && !fainted[battler.pbPartner.index]
                    peffscr = -pbGetEffectScore(move,0,battler,battler.pbPartner,actionable,fainted)
                    if peffscr > effscr
                      target = battler.pbPartner.index
                      effscr = peffscr
                    end
                  end
                  # Update actionable/fainted
                  pbGetEffectScore(move,damage,battler,@battlers[target],actionable,fainted,true)
                  scores[i][j] += effscr
                  
                elsif move.target == PBTargets::SingleOpposing || move.target == PBTargets::RandomOpposing
                  # Single target opposing (may be random)
                  effscr = 0
                  if !@battlers[0].isFainted? && !fainted[0] &&
                     !@battlers[2].isFainted? && !fainted[2]
                    # Both pokemon are alive, consider both targets
                    damage1 = move.pbPredictDamage(battler,@battlers[0],queue,affinityboost)
                    damage2 = move.pbPredictDamage(battler,@battlers[2],queue,affinityboost)
                    effscr1 = pbGetEffectScore(move,damage1,battler,@battlers[0],actionable,fainted)
                    effscr2 = pbGetEffectScore(move,damage2,battler,@battlers[2],actionable,fainted)
                    score1 = damage1 * 100 / @battlers[0].totalhp + effscr1
                    score2 = damage2 * 100 / @battlers[2].totalhp + effscr2
                    target = (score1 >= score2) ? 0 : 2
                    damage = (target == 0) ? damage1 : damage2
                    effscr = (target == 0) ? effscr1 : effscr2
                    # Redirection
                    if (@battlers[0].hasActiveAbility?(:STORMDRAIN) && move.type == PBTypes::WATER) ||
                       (@battlers[0].hasActiveAbility?(:LIGHTNINGROD) && move.type == PBTypes::ELECTRIC)
                      target = 0
                      damage = 0
                      effscr = 0
                    elsif (@battlers[2].hasActiveAbility?(:STORMDRAIN) && move.type == PBTypes::WATER) ||
                       (@battlers[2].hasActiveAbility?(:LIGHTNINGROD) && move.type == PBTypes::ELECTRIC)
                      target = 2
                      damage = 0
                      effscr = 0
                    end
                    highscore = (damage1 * 100 / @battlers[0].totalhp) + (damage2 * 100 / @battlers[2].totalhp)
                  elsif !@battlers[0].isFainted? && !fainted[0]
                    target = 0
                    damage = move.pbPredictDamage(battler,@battlers[0],queue,affinityboost)
                    effscr = pbGetEffectScore(move,damage,battler,@battlers[0],actionable,fainted)
                    highscore = (damage * 100 / @battlers[0].totalhp)
                  elsif !@battlers[2].isFainted? && !fainted[2]
                    target = 2
                    damage = move.pbPredictDamage(battler,@battlers[2],queue,affinityboost)
                    effscr = pbGetEffectScore(move,damage,battler,@battlers[2],actionable,fainted)
                    highscore = (damage * 100 / @battlers[2].totalhp)
                  else
                    target = 0
                    damage = 0
                  end
                  
                  # Update actionable/fainted
                  pbGetEffectScore(move,damage,battler,@battlers[target],actionable,fainted,true)
                  
                  if damage > @battlers[target].hp * 1.05
                    # The target will faint, add a high score an set inactionable
                    scores[i][j] += 150 #[@battlers[t].hp * 100 / @battlers[t].totalhp,150].max
                    actionable[target] = false
                    fainted[target] = true
                  else
                    # Add percentage of total hp lost to score
                    scores[i][j] += damage * 100 / @battlers[target].totalhp
                  end
                  
                  if highscore > dmg_potential[battler.index]
                    dmg_potential[battler.index] = highscore
                  end
                  
                elsif move.target == PBTargets::OppositeOpposing
                  # Targets only the directly opposing pokemon, unused
                  target = 0
                  damage = 0
                else
                  target = 0
                  damage = 0
                end
                
                if move.pbIsPhysical?(move.type) || move.pbIsSpecial?(move.type)
                  if target.is_a?(Array)
                    for t in target
                      if battler.pbPartner.index != t
                        typemod = move.pbTypeModMessages(move.type,battler,@battlers[t],false)
                        if typemod >= 8 && battler.pbPartner.pokemon.hasAffinity?(move.type)
                          affinityboost=true
                          break
                        end
                      end
                    end
                  else
                    typemod = move.pbTypeModMessages(move.type,battler,@battlers[target],false)
                    if typemod >= 8 && battler.pbPartner.pokemon.hasAffinity?(move.type)
                      affinityboost=true
                    end
                  end
                end
                
                if affinityboost
                  # TODO - Move affinity boosted pokemon up the queue
                end
                
                # Update target matrix
                if target.is_a?(Array)
                  targets[i][j][q <= 1 ? 0 : 1] = target[0]
                else
                  targets[i][j][q <= 1 ? 0 : 1] = target
                end
                
              end
              
            end
          end
        end
      end
      
      # Find the optimal move
      maxscore=-999999
      max_i = 0
      max_j = 0
      for i in 0...4
        for j in 0...4
          if attacker1.moves[i].id>0 && attacker2.moves[j].id>0 &&
             pbCanChooseMove?(index1,i,false) && pbCanChooseMove?(index2,j,false)
            if scores[i][j] && scores[i][j] > maxscore
              maxscore=scores[i][j]
              max_i = i
              max_j = j
            end
            if debug_extra?
              Kernel.pbMessage(_INTL("{1} use {2} and {3} use {4}. Score: {5}",
                attacker1.name,
                attacker1.moves[i].name,
                attacker2.name,
                attacker2.moves[j].name,
                scores[i][j]))
            end
          else
            scores[i][j] = -1
          end
        end
      end
      
      pbShowScores(scores,attacker1,attacker2) if $DEBUG && Input.press?(Input::CTRL)
      
      will_switch = [false, false, false, false]
      
      actionable = actionablestart
      fainted = faintedstart
      prev_switch = -1
      
      
      # Check if switching is optimal
      for i in [index1, index2]
        battler = @battlers[i]
        if !wildbattle && battler.turncount
          useless_switch = false
          hurtful_switch = 0
          ability_switch = false
          healing_switch = 0
          effect_switch = -1
          # Switch if about to die to Perish Song
          if battler.effects[PBEffects::PerishSong] == 1
            hurtful_switch = 125
          end
          # Stay in for at least one turn
          if battler.turncount > 1
            # Can't choose any moves
            if !pbCanChooseMove?(i,0,false) &&
               !pbCanChooseMove?(i,1,false) &&
               !pbCanChooseMove?(i,2,false) &&
               !pbCanChooseMove?(i,3,false)
              switchscore += [30 * battler.turncount, 100].min
            end
            # Consider switching if the Pokemon has low damage potential
            if dmg_potential[i] <= 12.5
              # Determine whether or not the Pokemon performs good as support
              max_score = 0
              scores = [0]
              for m in battler.moves
                # Buffing yourself if you can't deal damage is (mostly) useless
                if m.target != PBTargets::User && (move.addlEffect == 0 || move.addlEffect >= 50)
                  next if !pbCanChooseMove?(i,battler.moves.index(m),false)
                  case m.target
                  when PBTargets::SingleNonUser
                    scores.push(pbGetEffectScore(m,0,battler,@battlers[(i + 1) % 4],actionable,fainted))
                    scores.push(pbGetEffectScore(m,0,battler,@battlers[(i + 3) % 4],actionable,fainted))
                    scores.push(-pbGetEffectScore(m,0,battler,battler.pbPartner,actionable,fainted))
                  when PBTargets::SingleOpposing
                    scores.push(pbGetEffectScore(m,0,battler,@battlers[(i + 1) % 4],actionable,fainted))
                    scores.push(pbGetEffectScore(m,0,battler,@battlers[(i + 3) % 4],actionable,fainted))
                  when PBTargets::NoTarget, PBTargets::UserSide, PBTargets::BothSides, PBTargets::OpposingSide
                    scores.push(pbGetEffectScore(m,0,battler,nil,actionable,fainted))
                  when PBTargets::AllOpposing
                    scores.push(pbGetEffectScore(m,0,battler,@battlers[(i + 1) % 4],actionable,fainted) +
                                           pbGetEffectScore(m,0,battler,@battlers[(i + 3) % 4],actionable,fainted))
                  when PBTargets::AllNonUser
                    scores.push(pbGetEffectScore(m,0,battler,@battlers[(i + 1) % 4],actionable,fainted) +
                                           pbGetEffectScore(m,0,battler,@battlers[(i + 3) % 4],actionable,fainted) -
                                           pbGetEffectScore(m,0,battler,@battlers[(i + 3) % 4],actionable,fainted))
                  when PBTargets::Partner, PBTargets::UserOrPartner
                    scores.push(-pbGetEffectScore(m,0,battler,battler.pbPartner,actionable,fainted))
                  end
                end
              end
              highscore = scores.max
                # The Pokemon does not do good support, should be switched
              if highscore < 20
                useless_switch = true
              end
            end
            # Determine whether the Pokemon can take an unhealthy amount of damage or not
            if hurt_potential[i] >= 60 && hurt_potential[i] > dmg_potential[i]
              hurtful_switch = [hurt_potential[i], 100].min
            end
            # Try to preserve abilities activated on switch-in
            if battler.hasActiveAbility?(:DROUGHT) || battler.hasActiveAbility?(:DRIZZLE) ||
               battler.hasActiveAbility?(:SNOWWARNING) || battler.hasActiveAbility?(:SANDSTREAM) ||
               battler.hasActiveAbility?(:ZEPHYR) || battler.hasActiveAbility?(:GRASSYSURGE) ||
               battler.hasActiveAbility?(:ELECTRICSURGE) || battler.hasActiveAbility?(:PSYCHICSURGE) ||
               battler.hasActiveAbility?(:MISTYSURGE) || battler.hasActiveAbility?(:INTIMIDATE)
              ability_switch = true
            end
            # Try to make use of abilities activated on switch-in
            party = pbParty(battler.index)
            for p in 0...party.length
              if pbCanSwitch?(i, p, false)
                pkmn = party[p]
                if (pkmn.hasAbility?(:DROUGHT) && pbWeather != PBWeather::SUNNYDAY) ||
                   (pkmn.hasAbility?(:DRIZZLE) && pbWeather != PBWeather::RAINDANCE) ||
                   (pkmn.hasAbility?(:SNOWWARNING) && pbWeather != PBWeather::HAIL) ||
                   (pkmn.hasAbility?(:SANDSTREAM) && pbWeather != PBWeather::SANDSTORM) ||
                   (pkmn.hasAbility?(:ZEPHYR) && pbWeather != PBWeather::WINDS) ||
                   (pkmn.hasAbility?(:GRASSYSURGE) && @field.effects[PBEffects::GrassyTerrain] <= 0) ||
                   (pkmn.hasAbility?(:ELECTRICSURGE) && @field.effects[PBEffects::ElectricTerrain] <= 0) ||
                   (pkmn.hasAbility?(:PSYCHICSURGE) && @field.effects[PBEffects::PsychicTerrain] <= 0) ||
                   (pkmn.hasAbility?(:MISTYSURGE) && @field.effects[PBEffects::MistySurge] <= 0)
                  effect_switch = p
                end
              end
            end
            # Try to heal if it's optimal
            if battler.hasActiveAbility?(:REGENERATOR) && battler.hp <= battler.totalhp * 0.4
              healing_switch = 30
              healing_switch += 10 if battler.hp < battler.totalhp * 0.6
            end
            if battler.hasActiveAbility?(:NATURALCURE) && battler.status > 0
              healing_switch = 20 if battler.status == :POISON
              healing_switch += 20 if battler.status == :POISON && battler.effects[PBEffects::Toxic] > 3
              healing_switch = 15 if battler.status == :BURN
              healing_switch = 15 if battler.status == :PARALYSIS
              healing_switch = 40 if battler.status == :SLEEP
              healing_switch = 40 if battler.status == :FREEZE
            end
          end
          
          # Check if any switch requirement is fulfilled
          should_switch = (useless_switch || hurtful_switch > 0 ||
                                         ability_switch || healing_switch > 0 || effect_switch >= 0)
          if should_switch
            
            party = pbParty(i)
            dmg_scores = [0, 0, 0, 0, 0, 0] # The damage the new Pokemon can deal
            hurt_scores = [0, 0, 0, 0, 0, 0] # The damage the new Pokemon will take
            hazard_scores = [0, 0, 0, 0, 0, 0] # The damage the new Pokemon will take
            effect_scores = [0, 0, 0, 0, 0, 0] # Extra score for switch-in effects
            can_switch = [false, false, false, false, false, false]
            
            spikes = battler.pbOwnSide.effects[PBEffects::Spikes]
            toxic_spikes = battler.pbOwnSide.effects[PBEffects::ToxicSpikes]
            rocks = battler.pbOwnSide.effects[PBEffects::StealthRock]
            
            for p in 0...party.length
              if pbCanSwitch?(i, p, false) && p != prev_switch
                pkmn = party[p]
                can_switch[p] = true
                
                # Create an imaginary battler for the party member, for damage calcs
                pkmnbattler = PokeBattle_Battler.new(self, i)
                pkmnbattler.pbInitPokemon(pkmn, p)
                
                # Take damage from hazards
                if !pkmn.hasAbility?(:MAGICGUARD)
                  if !pkmn.hasType?(:FLYING) && !pkmn.hasAbility?(:LEVITATE)
                    if spikes > 0
                      hazard_scores[p] += (100.0 / (10.0 - spikes * 2.0))
                    end
                    if toxic_spikes > 0 && !pkmn.hasType?(:POISON) && !pkmn.hasType?(:STEEL)
                      hazard_scores[p] += 12.0 * toxic_spikes
                    end
                  end
                  if rocks
                    eff = PBTypes.getCombinedEffectiveness(PBTypes::ROCK,pkmn.type1,pkmn.type2,-1)
                    if eff > 0
                      hazard_scores[p] += (100.0 * eff) / 16.0
                    end
                  end
                end
                
                dmg_score = 0
                dmg_target = 0
                hurt_score = 0
                opponents = [@battlers[(i + 1) % 4], @battlers[(i + 3) % 4]]
                for o in opponents
                  next if !o || o.isFainted?
                  
                  # Determine how much damage the opponent can deal to the new Pokemon
                  # Check for limitted choice of move
                  fixed_move = 0
                  if (battler.hasActiveItem?(:CHOICEBAND) || battler.hasActiveItem?(:CHOICESPECS) ||
                     battler.hasActiveItem?(:CHOICESCARF)) && battler.effects[PBEffects::ChoiceBand] > 0
                    # Choiced
                    fixed_move = battler.effects[PBEffects::ChoiceBand]
                  elsif battler.effects[PBEffects::Encore] > 0
                    # Encore
                    fixed_move = battler.effects[PBEffects::EncoreMove]
                  end
                  
                  for m in o.moves
                    # Check that the move is valid
                    if m.id > 0 && m.pp > 0 && (o.effects[PBEffects::Disable] <= 0 || o.effects[PBEffects::DisableMove] != m.id)
                      if fixed_move > 0
                        if m.id == fixed_move
                          dmg = m.pbPredictDamage(o, pkmnbattler, [i, o.index], false)
                          hurt_score = dmg if dmg > hurt_score
                        end
                      elsif o.pbIsMoveRevealed?(m.id) ||
                         o.pbHasType?(m.type)
                        dmg = m.pbPredictDamage(o, pkmnbattler, [i, o.index], false)
                        hurt_score = dmg if dmg > hurt_score
                      end
                    end
                  end
                  
                  # Determine how much damage the new Pokemon can deal to the opponent
                  for m in pkmnbattler.moves
                    # Check that the move is valid
                    if m.id > 0 && m.pp > 0
                      dmg = m.pbPredictDamage(pkmnbattler, o, [i, o.index], false)
                      if dmg > dmg_score
                        dmg_score = dmg
                        dmg_target = o.index
                      end
                    end
                  end
                end
                
                # Convert high scores to percentages
                hurt_scores[p] += hurt_score * 100 / pkmn.totalhp
                dmg_scores[p] += dmg_score * 100 / @battlers[dmg_target].totalhp
                
              end
            end
            
            best_switch = -1
            best_score = -50
            for p in 0...party.length
              if can_switch[p] && p != prev_switch
                pkmn = party[p]
                hp_percent = pkmn.hp * 100 / pkmn.totalhp
                hazard_score = hazard_scores[p]
                dmg_score = dmg_scores[p]
                hurt_score = hurt_scores[p]
                effect_score = effect_scores[p]
                
                # Must not die immediately from hazards
                if hazard_score < hp_percent
                  
                  viable = false
                  bonus = 0
                  # Switching because of uselessness
                  if useless_switch
                    if hurt_score + hazard_score < 60 && dmg_score > 15
                      viable = true
                    end
                  end
                  
                  # Switching for an effect
                  if effect_switch == p && dmg_potential[i] < 55 &&
                     dmg_potential[i] <= dmg_potential[(i + 2) % 4]
                    if hurt_score + hazard_score < 80
                      viable = true
                      bonus = 80
                    end
                  end
                  
                  # Switching to preserve abilities
                  if ability_switch
                    if hurt_score + hazard_score < 60 && dmg_score > 10
                      viable = true
                      bonus = 0
                      for poke in party
                        bonus += 25 if poke.hp > 0
                      end
                    end
                  end
                  
                  # Switching to heal
                  if healing_switch > 0
                    if hurt_score + hazard_score <= healing_switch && dmg_score > 10 &&
                       dmg_potential[i] < 100 - (@battlers[i].hp * 100 / @battlers[i].totalhp)
                       viable = true
                    end
                  end
                  
                  # Switching to avoid damage
                  if hurtful_switch > 0
                    if hurt_score + hazard_score < hurtful_switch / 1.5 &&
                       (hurtful_switch >= 150 || dmg_score > 10)
                      viable = true
                    end
                  end
                  
                  if viable
                    total_score = dmg_score + effect_score - hurt_score - hazard_score + bonus
                    if total_score > best_score
                      best_score = total_score
                      best_switch = p
                    end
                  end
                end
              end
            end
            
            if best_switch >= 0
              passmove = -1
              passtarget = -1
              passdamage = 0
              for k in 0...4
                m = battler.moves[k]
                if m.id > 0 && pbCanChooseMove?(i, k, false)
                  if m.function == 0x0ED # Baton Pass
                    passmove = k
                    break
                  elsif m.function == 0x0EE # U-turn / Volt Switch
                    opponent1 = battler.pbOpposing1
                    opponent2 = battler.pbOpposing2
                    partner = battler.pbPartner
                    # Avoid being redirected and not switching
                    if m.type == PBTypes::ELECTRIC
                      if (opponent1 && opponent1.hasActiveAbility?(:LIGHTNINGROD)) ||
                         (opponent2 && opponent2.hasActiveAbility?(:LIGHTNINGROD)) ||
                         (partner && partner.ha<sWorkingAbility(:LIGHTNINGROD))
                        next
                      end
                    elsif m.type == PBTypes::WATER
                      if (opponent1 && opponent1.hasActiveAbility?(:STORMDRAIN)) ||
                         (opponent2 && opponent2.hasActiveAbility?(:STORMDRAIN)) ||
                         (partner && partner.hasActiveAbility?(:STORMDRAIN))
                        next
                      end
                    end
                    # Confirm move can damage at least one target, and choose the best one
                    if opponent1 && !opponent1.isFainted?
                      damage = m.pbPredictDamage(battler, opponent1, [i, opponent1.index], false)
                      if damage > passdamage
                        passmove = k
                        passtarget = opponent1.index
                        passdamage = damage
                      end
                    end
                    if opponent2 && !opponent2.isFainted?
                      damage = m.pbPredictDamage(battler, opponent2, [i, opponent2.index], false)
                      if damage > passdamage
                        passmove = k
                        passtarget = opponent2.index
                        passdamage = damage
                      end
                    end
                  elsif m.function == 0x151 # Parting Shot
                    passmove = k
                    break
                  end
                end
              end
              
              will_switch[i] = true
              if passmove >= 0
                pbRegisterMove(i, k, false)
                pbRegisterTarget(i, passtarget) if passtarget >= 0
              else
                pbRegisterSwitch(i, best_switch)
                prev_switch = i
              end
              
            end
            
          end
        end
        if prev_switch >= 0
          break
        end
      end
      
      
      # Finally register the moves
      if !will_switch[index1]
        pbRegisterMove(index1,max_i,false)
        pbRegisterTarget(index1,targets[max_i][max_j][0])
      end
      if !will_switch[index2]
        pbRegisterMove(index2,max_j,false)
        pbRegisterTarget(index2,targets[max_i][max_j][1])
      end
      if debug_extra?
        self.pbDisplay(_INTL("Best Move: {1} use {2} and {3} use {4}",
          attacker1.name,
          attacker1.moves[i].name,
          attacker2.name,
          attacker2.moves[j].name))
      end
      
    end
    
    def pbRoughPriority(attacker,move)
      pri=move.priority
      pri+=1 if attacker.hasActiveAbility?(:PRANKSTER) &&
                move.pbIsStatus?
      pri+=1 if attacker.hasActiveAbility?(:HASTE) && attacker.turncount<=1
      pri+=1 if attacker.hasActiveAbility?(:GALEWINGS) &&
                isConst?(move.type,PBTypes,:FLYING) &&
                (attacker.hp == attacker.totalhp || @weather==PBWeather::WINDS)
      pri+=3 if attacker.hasActiveAbility?(:TRIAGE) &&
                move.isHealingMove?
      return pri
    end
    
    def pbShowScores(scores,attacker1,attacker2)
      
      viewport = Viewport.new(0,0,512,384)
      viewport.z = 999999
      
      bg = Sprite.new(viewport)
      bg.bitmap = Bitmap.new(512,384)
      bg.bitmap.fill_rect(0,0,512,384,Color.new(0,0,0))
      bg.opacity = 150
      
      text = Sprite.new(viewport)
      text.bitmap = Bitmap.new(512,384)
      pbSetSmallestFont(text.bitmap)
      
      base = Color.new(252,252,252)
      shadow = Color.new(0,0,0)
      
      textpos = []
      
      for i in 0...4
        textpos.push([attacker1.moves[i].name,110 + 100 * i,80,0,base,shadow,1])
      end
      
      for j in 0...4
        textpos.push([attacker2.moves[j].name,10,120 + j * 40,0,base,shadow,1])
      end
      
      for i in 0...4
        for j in 0...4
          textpos.push([scores[i][j].to_s,110 + 100 * i,120 + j * 40,0,base,shadow,1])
        end
      end
      
      pbDrawTextPositions(text.bitmap,textpos)
      
      8.times do
        bg.update
        text.update
        viewport.update
        Graphics.update
        Input.update
      end
      
      while !Input.trigger?(Input::C)
        bg.update
        text.update
        viewport.update
        Graphics.update
        Input.update
      end
      
      bg.dispose
      text.dispose
      viewport.dispose
      
    end
    
end