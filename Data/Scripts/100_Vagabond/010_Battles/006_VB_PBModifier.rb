class EncounterModifiers
  attr_accessor(:iv)
  attr_accessor(:ev)
  attr_accessor(:item)
  attr_accessor(:hp)
  attr_accessor(:name)
  attr_accessor(:status)
  attr_accessor(:moves)
  attr_accessor(:ability)
  attr_accessor(:nature)
  attr_accessor(:gender)
  attr_accessor(:shiny)
  attr_accessor(:hpmult)
  attr_accessor(:form)
  
  def initialize()
    @iv      = nil
    @ev      = nil
    @item    = nil
    @hp      = nil
    @name    = nil
    @status  = nil
    @moves   = nil
    @ability = nil
    @nature  = nil
    @gender  = nil
    @shiny   = nil
    @hpmult  = nil
    @form    = nil
  end
  
  def moves=(value)
    @moves=value
  end
  
  def status=(value)
    value = getID(PBStatuses,value) if value.is_a?(Symbol)
    @status = value
  end
  
  def nature=(value)
    value = getID(PBNatures,value) if value.is_a?(Symbol)
    @nature = value
  end
  
  def item=(value)
    value = getID(PBItems,value) if value.is_a?(Symbol)
    @item = value
  end
  
  def optimize
    @iv      = [31,31,31,31,31,31]
    @ability = 0
    @nature  = :SERIOUS
  end
end

class PokeBattle_Pokemon
  def modify
    if $game_variables[WILD_MODIFIER] && $game_variables[WILD_MODIFIER] != 0
      mod = $game_variables[WILD_MODIFIER]
      if mod.moves # Custom Moves
        @moves[0] = PBMove.new(mod.moves[0])
        @moves[1] = PBMove.new(mod.moves[1])
        @moves[2] = PBMove.new(mod.moves[2])
        @moves[3] = PBMove.new(mod.moves[3])
      end
      if mod.iv
        for i in 0..5
          @iv[i] = mod.iv[i]
          if @oiv && @oiv[i]
            @oiv[i] = mod.iv[i]
          end
        end
      end
      if mod.ev
        for i in 0..5
          @ev[i] = mod.ev[i]
        end
      end
      @name = mod.name if mod.name
      @ability_index = mod.ability if mod.ability
      @gender = mod.gender if mod.gender
      @item = mod.item if mod.item
      @natureflag = mod.nature if mod.nature
      @shinyflag = mod.shiny if mod.shiny
      @status = mod.status if mod.status
      calc_stats
      @hp = @totalhp
      @hp = mod.hp if mod.hp
      $game_variables[WILD_MODIFIER] = 0
    end
  end
end

def pbModifier
  if $game_variables[WILD_MODIFIER] == 0
    $game_variables[WILD_MODIFIER] = EncounterModifiers.new()
  end
  return $game_variables[WILD_MODIFIER]
end

def pbHoneyEncounter
  viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  viewport.z=99999
  count=0
  viewport.color.alpha-=10 
  begin
    if viewport.color.alpha<128 && count==0
      viewport.color.red=255
      viewport.color.green=0
      viewport.color.blue=0
      viewport.color.alpha+=8
    else
      count+=1
      if count>10
        viewport.color.alpha-=8 
      end
    end
    Graphics.update
    Input.update
    pbUpdateSceneMap
  end until viewport.color.alpha<=0
  viewport.dispose
  
  encounters = [:BUTTERFREE, :BUTTERFREE,
             :BEEDRILL, :BEEDRILL,
             :VENOMOTH, :VENOMOTH,
             :LEDYBA, :LEDYBA, :LEDYBA,
             :LEDIAN,
             :YANMA, :YANMA,
             :BEAUTIFLY, :BEAUTIFLY,
             :DUSTOX, :DUSTOX,
             :MASQUERAIN,
             :NINJASK, :NINJASK,
             :HERACROSS,
             :COMBEE, :COMBEE, :COMBEE, :COMBEE]
  pokemon = encounters.shuffle
  
  levels = [11, 11, 12, 13]
  level = levels.shuffle
  
  pbWildBattle(pokemon[0],level[0])
end