def pbAllDataChipMoves
  moves = [
    [:AERIALACE,1],
    [:FALSESWIPE,1],
    [:FORESIGHT,1],
    [:MAGICALLEAF,1],
    [:SHOCKWAVE,1],
    [:SMACKDOWN,1],
    [:WORKUP,1],
    [:ANCIENTPOWER,2],
    [:BRICKBREAK,2],
    [:CHARGEBEAM,2],
    [:CLEARSMOG,2],
    [:FIREPLEDGE,2],
    [:GRASSPLEDGE,2],
    [:HELPINGHAND,2],
    [:POWERUPPUNCH,2],
    [:THIEF,2],
    [:WATERPLEDGE,2],
    [:CURSE,3],
    [:DEFOG,3],
    [:DRAGONCLAW,3],
    [:ELECTRICTERRAIN,3],
    [:FLY,3],
    [:GRASSYTERRAIN,3],
    [:HIGHHORSEPOWER,3],
    [:MISTYTERRAIN,3],
    [:PSYCHUP,3],
    [:PSYCHICTERRAIN,3],
    [:SHADOWFORCE,3],
    [:STRENGTH,3],
    [:ICYWIND,4],
    [:POLLENPUFF,4],
    [:STEALTHROCK,4],
    [:SUBSTITUTE,4],
    [:THROATCHOP,4],
    [:WILDCHARGE,4]
  ]
  
  if $PokemonBag.pbQuantity(:DATARECOVERYDEVICE)>0
    moves += [
      [:ROOST,3],
      #[:TERRAINPULSE,3],
      [:WEATHERBALL,3],
      [:FREEZEDRY,4],
      [:FUTURESIGHT,4],
      [:GIGADRAIN,4],
      [:LIQUIDATION,4],
      [:PLAYROUGH,4],
      [:SEISMICTOSS,4],
      [:SURF,4],
      #[:BODYPRESS,5],
      [:DYNAMICPUNCH,5],
      [:EXPLOSION,5],
      [:FLAREBLITZ,5],
      [:HURRICANE,5],
      [:INFERNO,5],
      [:MEGAHORN,5],
      #[:STEELBEAM,5],
      [:ZAPCANNON,5],
      [:DRACOMETEOR,6],
      [:SKYATTACK,6],
      [:METRONOME,10],
    ]
  end
  
  return moves
end

def pbAddDataChipMove(move)
  pbSet(DATA_CHIP_MOVES,[]) if !pbGet(DATA_CHIP_MOVES).is_a?(Array)
  if !$game_variables[DATA_CHIP_MOVES].include?(move)
    $game_variables[DATA_CHIP_MOVES].push(move)
  end
end

def pbHasDataChipMove(move)
  pbSet(DATA_CHIP_MOVES,[]) if !pbGet(DATA_CHIP_MOVES).is_a?(Array)
  return $game_variables[DATA_CHIP_MOVES].include?(move)
end

def pbGetDataChipMoves(pokemon)
  return [] if !pokemon || pokemon.egg? || (pokemon.isShadow? rescue false)
  allMoves = pbAllDataChipMoves
  chipMoves=[]
  # First add unlocked moves
  for i in allMoves
    if pbHasDataChipMove(i[0])
      chipMoves.push(i)
    end
  end
  # Then add locked moves
  for i in allMoves
    if !chipMoves.include?(i)
      chipMoves.push(i)
    end
  end
  # Finally, add a compatability value to each move
  # Sort compatible moves first in list
  for i in chipMoves
    i[2] = pokemon.isCompatibleWithMove?(i[0])
  end
  moves = []
  for i in chipMoves
    moves.push(i) if i[2]
  end
  for i in chipMoves
    moves.push(i) if !i[2]
  end
  return moves|[] # remove duplicates
end

def pbGetTMMoves(pokemon)
  return [] if !pokemon || pokemon.egg? || (pokemon.isShadow? rescue false)
  #itemdata=readItemList("Data/items.dat")
  moves=[]
  for i in 0...$ItemData.length
    if $ItemData[i][ITEMUSE]==3 && $PokemonBag.pbQuantity(i)>0
      machine=$ItemData[i][ITEMMACHINE]
      if pokemon.isCompatibleWithMove?(machine)
        moves.push(machine)
      end
    end
  end
  return moves|[] # remove duplicates
end

def pbGiveAllTMs
  for i in 0...$ItemData.length
    if $ItemData[i][ITEMUSE]==3 && $PokemonBag.pbQuantity(i)<=0
      $PokemonBag.pbStoreItem(i,1)
    end
  end
  Kernel.pbMessage("Got all TMs")
end