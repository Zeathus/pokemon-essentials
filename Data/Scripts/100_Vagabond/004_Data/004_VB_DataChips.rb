def pbAllDataChipMoves
  moves = [
    [PBMoves::AERIALACE,1],
    [PBMoves::FALSESWIPE,1],
    [PBMoves::FORESIGHT,1],
    [PBMoves::MAGICALLEAF,1],
    [PBMoves::SHOCKWAVE,1],
    [PBMoves::SMACKDOWN,1],
    [PBMoves::WORKUP,1],
    [PBMoves::ANCIENTPOWER,2],
    [PBMoves::BRICKBREAK,2],
    [PBMoves::CHARGEBEAM,2],
    [PBMoves::CLEARSMOG,2],
    [PBMoves::FIREPLEDGE,2],
    [PBMoves::GRASSPLEDGE,2],
    [PBMoves::HELPINGHAND,2],
    [PBMoves::POWERUPPUNCH,2],
    [PBMoves::THIEF,2],
    [PBMoves::WATERPLEDGE,2],
    [PBMoves::CURSE,3],
    [PBMoves::DEFOG,3],
    [PBMoves::DRAGONCLAW,3],
    [PBMoves::ELECTRICTERRAIN,3],
    [PBMoves::FLY,3],
    [PBMoves::GRASSYTERRAIN,3],
    [PBMoves::HIGHHORSEPOWER,3],
    [PBMoves::MISTYTERRAIN,3],
    [PBMoves::PSYCHUP,3],
    [PBMoves::PSYCHICTERRAIN,3],
    [PBMoves::SHADOWFORCE,3],
    [PBMoves::STRENGTH,3],
    [PBMoves::ICYWIND,4],
    [PBMoves::POLLENPUFF,4],
    [PBMoves::STEALTHROCK,4],
    [PBMoves::SUBSTITUTE,4],
    [PBMoves::THROATCHOP,4],
    [PBMoves::WILDCHARGE,4]
  ]
  
  if $PokemonBag.pbQuantity(:DATARECOVERYDEVICE)>0
    moves += [
      [PBMoves::ROOST,3],
      #[PBMoves::TERRAINPULSE,3],
      [PBMoves::WEATHERBALL,3],
      [PBMoves::FREEZEDRY,4],
      [PBMoves::FUTURESIGHT,4],
      [PBMoves::GIGADRAIN,4],
      [PBMoves::LIQUIDATION,4],
      [PBMoves::PLAYROUGH,4],
      [PBMoves::SEISMICTOSS,4],
      [PBMoves::SURF,4],
      #[PBMoves::BODYPRESS,5],
      [PBMoves::DYNAMICPUNCH,5],
      [PBMoves::EXPLOSION,5],
      [PBMoves::FLAREBLITZ,5],
      [PBMoves::HURRICANE,5],
      [PBMoves::INFERNO,5],
      [PBMoves::MEGAHORN,5],
      #[PBMoves::STEELBEAM,5],
      [PBMoves::ZAPCANNON,5],
      [PBMoves::DRACOMETEOR,6],
      [PBMoves::SKYATTACK,6],
      [PBMoves::METRONOME,10],
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
  return [] if !pokemon || pokemon.isEgg? || (pokemon.isShadow? rescue false)
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
  return [] if !pokemon || pokemon.isEgg? || (pokemon.isShadow? rescue false)
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