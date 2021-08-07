class PokeBattle_Battler

    def pbAffinityBoost
        if !opposes?
            $Trainer.stats.affinity_boosts += 1
        end
        booster = @affinitybooster
        #@battle.scene.pbAffinityBoostAnimation(self)
        allies = [self]
        allies.push(booster) if booster && !booster.fainted?
        
        for ally in allies
            if ally.hasActiveAbility?(:MENDINGBOND)
                if @hp != @totalhp && @effects[PBEffects::HealBlock] <= 0
                    pbRecoverHP(((attacker.totalhp+1)/2).floor,true)
                    if ally == self
                        @battle.pbDisplay(_INTL("{1}'s Mending Bond restored its HP!", pbThis))
                    else
                        @battle.pbDisplay(_INTL("{1}'s Mending Bond restored {2}'s HP!", ally.pbThis, pbThis))
                    end
                end
            elsif ally.hasActiveAbility?(:FIERCEBOND)
                if pbCanRaiseStatStage?(PBStats::ATTACK,self,false)
                    if ally == self
                        @battle.pbDisplay(_INTL("{1}'s Fierce Bond increased its Attack!", pbThis))
                    else
                        @battle.pbDisplay(_INTL("{1}'s Fierce Bond increased {2}'s Attack!", ally.pbThis, pbThis))
                    end
                    pbRaiseStatStage(:ATTACK,1,self,false)
                end
            elsif ally.hasActiveAbility?(:GUARDINGBOND)
                if pbCanRaiseStatStage?(PBStats::DEFENSE,self,false)
                    if ally == self
                        @battle.pbDisplay(_INTL("{1}'s Guarding Bond increased its Defense!", pbThis))
                    else
                        @battle.pbDisplay(_INTL("{1}'s Guarding Bond increased {2}'s Defense!", ally.pbThis, pbThis))
                    end
                    pbRaiseStatStage(:DEFENSE,1,self,false)
                end
            elsif ally.hasActiveAbility?(:RADIANTBOND)
                if pbCanRaiseStatStage?(PBStats::SPATK,self,false)
                    if ally == self
                        @battle.pbDisplay(_INTL("{1}'s Radiant Bond increased its Sp. Atk!", pbThis))
                    else
                        @battle.pbDisplay(_INTL("{1}'s Radiant Bond increased {2}'s Sp. Atk!", ally.pbThis, pbThis))
                    end
                    pbRaiseStatStage(:SPECIAL_ATTACK,1,self,false)
                end
            elsif ally.hasActiveAbility?(:SPIRITUALBOND)
                if pbCanRaiseStatStage?(PBStats::SPDEF,self,false)
                    if ally == self
                        @battle.pbDisplay(_INTL("{1}'s Spiritual Bond increased its Sp. Def!", pbThis))
                    else
                        @battle.pbDisplay(_INTL("{1}'s Spiritual Bond increased {2}'s Sp. Def!", ally.pbThis, pbThis))
                    end
                    pbRaiseStatStage(:SPECIAL_DEFENSE,1,self,false)
                end
            elsif ally.hasActiveAbility?(:LIVELYBOND)
                if pbCanRaiseStatStage?(PBStats::SPEED,self,false)
                    if ally == self
                        @battle.pbDisplay(_INTL("{1}'s Lively Bond increased its Speed!", pbThis))
                    else
                        @battle.pbDisplay(_INTL("{1}'s Lively Bond increased {2}'s Speed!", ally.pbThis, pbThis))
                    end
                    pbRaiseStatStage(:SPEED,1,self,false)
                end
            end
        end
    end

end