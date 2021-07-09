=begin
class PokeBattle_Pokemon
  
  def modAttack
    mult = 1.0
    
    if self.hasAbility?(:DEFEATIST)
      if self.hp>=(self.totalhp/2.0).floor
        mult*=0.5
      end
    elsif self.hasAbility?(:GUTS)
      if self.status>0
        mult*=1.5
      end
    elsif self.hasAbility?(:HUGEPOWER) || self.hasAbility?(:PUREPOWER)
      mult*=2.0
    elsif self.hasAbility?(:HUSTLE)
      mult*=1.5
    elsif self.hasAbility?(:TOXICBOOST)
      if self.status==PBStatuses::POISON
        mult*=1.5
      end
    end
    
    if !self.hasAbility?(:KLUTZ)
      if self.hasItem?(:THICKCLUB)
        if self.species==:CUBONE ||
           self.species==:MAROWAK
          mult*=2.0
        end
      elsif self.hasItem?(:MUSCLEBAND)
        mult*=1.1
      elsif self.hasItem?(:LIFEORB)
        mult*=1.3
      elsif self.hasItem?(:CHOICEBAND)
        mult*=1.5
      end
    end
    
    if self.status==PBStatuses::BURN
      if !self.hasAbility?(:GUTS)
        mult*=0.5
      end
    end
    
    return mult
  end
  
  def modDefense
    mult = 1.0
    
    if self.hasAbility?(:FLUFFY) || self.hasAbility?(:FURCOAT)
      mult*=2.0
    end
    
    if !self.hasAbility?(:KLUTZ)
      if self.hasItem?(:METALPOWDER)
        if self.species==:DITTO
          mult*=1.5
        end
      elsif self.hasItem?(:EVIOLITE)
        evos=pbGetEvolvedFormData(self.species)
        if evos && evos.length>0
          mult*=1.5
        end
      end
    end
    
    return mult
  end
  
  def modSpAtk
    mult = 1.0
    
    if self.hasAbility?(:DEFEATIST)
      if self.hp>=(self.totalhp/2.0).floor
        mult*=0.5
      end
    elsif self.hasAbility?(:FLAREBOOST)
      if self.status==PBStatuses::BURN
        mult*=1.5
      end
    elsif self.hasAbility?(:SOLARPOWER)
      if $game_screen.weather_type==PBFieldWeather::Sun
        mult*=1.5
      end
    end
    
    if !self.hasAbility?(:KLUTZ)
      if self.hasItem?(:WISEGLASSES)
        mult*=1.1
      elsif self.hasItem?(:LIFEORB)
        mult*=1.3
      elsif self.hasItem?(:CHOICESPECS)
        mult*=1.5
      end
    end
    
    return mult
  end
  
  def modSpDef
    mult = 1.0
    
    if !self.hasAbility?(:KLUTZ)
      if self.hasItem?(:METALPOWDER)
        if self.species==:DITTO
          mult*=1.5
        end
      elsif self.hasItem?(:ASSAULTVEST)
        mult*=1.5
      elsif self.hasItem?(:EVIOLITE)
        evos=pbGetEvolvedFormData(self.species)
        if evos && evos.length>0
          mult*=1.5
        end
      end
    end
    
    return mult
  end
  
  def modSpeed
    mult = 1.0
    
    if self.hasAbility?(:CHLOROPHYLL)
      if $game_screen.weather_type==PBFieldWeather::Sun
        mult*=2.0
      end
    elsif self.hasAbility?(:QUICKFEET)
      if self.status>0
        mult*=1.5
      end
    elsif self.hasAbility?(:SANDRUSH)
      if $game_screen.weather_type==PBFieldWeather::Sandstorm
        mult*=2.0
      end
    elsif self.hasAbility?(:SLUSHRUSH)
      if $game_screen.weather_type==PBFieldWeather::Snow ||
        $game_screen.weather_type==PBFieldWeather::Blizzard
        mult*=2.0
      end
    elsif self.hasAbility?(:SWIFTSWIM)
      if $game_screen.weather_type==PBFieldWeather::Rain ||
        $game_screen.weather_type==PBFieldWeather::Storm ||
        $game_screen.weather_type==PBFieldWeather::HeavyRain
        mult*=2.0
      end
    end
    
    if !self.hasAbility?(:KLUTZ)
      if self.hasItem?(:QUICKPOWDER)
        if self.species==:DITTO
          mult*=2.0
        end
      elsif self.hasItem?(:MACHOBRACE) ||
            self.hasItem?(:POWERBAND) ||
            self.hasItem?(:POWERWEIGHT) ||
            self.hasItem?(:POWERLENS) ||
            self.hasItem?(:POWERBRACER) ||
            self.hasItem?(:POWERBELT) ||
            self.hasItem?(:POWERANKLET) ||
            self.hasItem?(:IRONBALL)
        mult*=0.5
      elsif self.hasItem?(:CHOICESCARF)
        mult*=1.5
      end
    end
    
    if self.status==PBStatuses::PARALYSIS
      if !self.hasAbility?(:QUICKFEET)
        mult*=0.5
      end
    end
    
    return mult
  end
  
end
=end