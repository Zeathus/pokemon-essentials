module PBMoveUpNames
  None          = 0
  Exp           = 1
  Upgraded      = 2
  PowerPlus     = 3
  AccuracyUp = Accuracy = 4
  EffectUp      = 5
  EffectChance  = 6
  Physical      = 7
  Special       = 8
  Priority      = 9
  TypeNormal    = 10
  TypeFighting  = 11
  TypeFlying    = 12
  TypePoison    = 13
  TypeGround    = 14
  TypeRock      = 15
  TypeBug       = 16
  TypeGhost     = 17
  TypeSteel     = 18
  TypeQMarks    = 19
  TypeFire      = 20
  TypeWater     = 21
  TypeGrass     = 22
  TypeElectric  = 23
  TypePsychic   = 24
  TypeIce       = 25
  TypeDragon    = 26
  TypeDark      = 27
  TypeFairy     = 28
  Exclusive     = 29
  
  def PBMoveUpNames.getImageID(id)
    if id<=2
      return 0 # Blank
    elsif id==3
      return 2 # Eye
    elsif id<=5
      return 1 # Arrow Up
    elsif id==6
      return 4 # Percent
    elsif id<=8
      return 6 # CAT
    elsif id==9
      return 5 # Arrow Left
    elsif id<=28
      return 7 # TYPE
    elsif id==29
      return 8 # Exclusive (Star)
    end
    return 0
  end
  
  def PBMoveUpNames.getName(id)
    names = [
      "-",
      "-",
      "-",
      "Power Plus",
      "Accuracy Up",
      "Effect Up",
      "Effect Chance",
      "Physical",
      "Special",
      "Priority",
      "Normal-Type",
      "Fighting-Type",
      "Flying-Type",
      "Poison-Type",
      "Ground-Type",
      "Rock-Type",
      "Bug-Type",
      "Ghost-Type",
      "Steel-Type",
      "???-Type",
      "Fire-Type",
      "Water-Type",
      "Grass-Type",
      "Electric-Type",
      "Psychic-Type",
      "Ice-Type",
      "Dragon-Type",
      "Dark-Type",
      "Fairy-Type",
      "Exclusive"
    ]
    return names[id]
  end
end

module PBMoveUps
  None          = 0
  Accuracy      = 1
  Power         = 2
  Effect        = 3
  EfChance      = 4
  LearnMove     = 5
  Category      = 6
  Type          = 7
  Priority      = 8
  Special       = 9
  Name          = 10
  Description   = 11
end

def pbMoveUpgrade(moveid)
  return false
  moveUpgrades = []
  
  # return [exp,[
  # [upgrade option 1],
  # [upgrade option 2]]]
  
  # lvl 5  = 61 Exp
  # lvl 15 = 631 Exp
  # lvl 30 = 2611 Exp
  # lvl 50 = 7351 Exp
  
  case moveid
  # 100% Accuracy, 2000 EXP 
  when PBMoves::SMOG, PBMoves::KINESIS, PBMoves::POISONGAS, PBMoves::PRESENT,
       PBMoves::METALCLAW
    return [2000,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,100]]]
  # 100% Accuracy, 2500 EXP 
  when PBMoves::ROCKTHROW, PBMoves::TRIPLEKICK, PBMoves::WRAP, PBMoves::BIND,
       PBMoves::SUBMISSION, PBMoves::PINMISSILE, PBMoves::BONERUSH,
       PBMoves::ROCKTOMB, PBMoves::MUDSHOT, PBMoves::MUDBOMB, PBMoves::CIRCLETHROW,
       PBMoves::THUNDERFANG, PBMoves::ICEFANG, PBMoves::FIREFANG,
       PBMoves::ELECTROWEB
    return [2500,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,100]]]
  # 100% Accuracy, 3000 EXP
  when PBMoves::FLY, PBMoves::BONEMERANG, PBMoves::HYPERFANG, PBMoves::CRUSHCLAW,
       PBMoves::SUPERFANG, PBMoves::OCTAZOOKA, PBMoves::ICYWIND, PBMoves::BOUNCE,
       PBMoves::ROCKBLAST, PBMoves::AQUATAIL, PBMoves::AIRSLASH,
       PBMoves::RAZORSHELL, PBMoves::LEAFTORNADO, PBMoves::TAILSLAP
    return [3000,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,100]]]
  # 100% Accuracy, 3500 EXP
  when PBMoves::FIRESPIN, PBMoves::CLAMP, PBMoves::WHIRLPOOL, PBMoves::ROCKSLIDE,
       PBMoves::BLAZEKICK, PBMoves::AIRCUTTER, PBMoves::SANDTOMB,
       PBMoves::DRAGONTAIL, PBMoves::FROSTBREATH, PBMoves::DRILLRUN,
       PBMoves::DUALCHOP, PBMoves::SNARL, PBMoves::HIGHHORSEPOWER
    return [3500,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,100]]]
  # 100% Accuracy, 4000 EXP
  when PBMoves::FLYINGPRESS, PBMoves::ICICLECRASH, PBMoves::NIGHTDAZE,
       PBMoves::GLACIATE, PBMoves::ZENHEADBUTT, PBMoves::PBMoves::SKYUPPERCUT,
       PBMoves::BELCH, PBMoves::PLAYROUGH
    return [4000,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,100]]]
  # 100% Accuracy, 5000 EXP
  when PBMoves::SKYATTACK, PBMoves::AEROBLAST, PBMoves::SACREDFIRE,
       PBMoves::BLASTBURN, PBMoves::HYDROCANNON, PBMoves::FRENZYPLANT,
       PBMoves::HYPERBEAM, PBMoves::GIGAIMPACT, PBMoves::ROCKWRECKER,
       PBMoves::ROAROFTIME, PBMoves::ICEBURN, PBMoves::FREEZESHOCK,
       PBMoves::OVERHEAT, PBMoves::LEAFSTORM, PBMoves::DRACOMETEOR,
       PBMoves::PSYCHOBOOST, PBMoves::HAMMERARM, PBMoves::FLEURCANNON,
       PBMoves::SPACIALREND, PBMoves::VCREATE, PBMoves::DIAMONDSTORM,
       PBMoves::STEAMERUPTION, PBMoves::LIGHTOFRUIN, PBMoves::ICEHAMMER,
       PBMoves::NATURESMADNESS
    return [5000,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,100]]]
  # 90% Accuracy, 3000 EXP
  when PBMoves::MEGAHORN, PBMoves::CROSSCHOP, PBMoves::WILLOWISP,
       PBMoves::MUDDYWATER, PBMoves::ROCKCLIMB, PBMoves::GEARGRIND
    return [3000,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,90]]]
  # 85% Accuracy, 3000 EXP
  when PBMoves::IRONTAIL
    return [3000,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,85]]]
  # 25 Base Power, 3000 EXP
  when PBMoves::ARMTHRUST
    return [3000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,25]]]
  # 40 Base Power, 3000 EXP
  when PBMoves::INFESTATION
    return [3000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,40]]]
  # 50 Base Power, 3000 EXP
  when PBMoves::POWERUPPUNCH
    return [3000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,50]]]
  # 60 Base Power, 3000 EXP
  when PBMoves::PAYDAY, PBMoves::KARATECHOP, PBMoves::FELLSTINGER
    return [3000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,60]]]
  # 70 Base Power, 4000 EXP
  when PBMoves::GUST, PBMoves::TWISTER, PBMoves::FAIRYWIND
    return [4000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,70]]]
  # 75 Base Power, 3000 EXP
  when PBMoves::SHADOWPUNCH
    return [3000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,75]]]
  # 80 Base Power, 3500 EXP
  when PBMoves::MISTBALL, PBMoves::LUSTERPURGE, PBMoves::FREEZEDRY
    return [3500,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,80]]]
  # 90 Base Power, 4000 EXP
  when PBMoves::WATERFALL, PBMoves::SMELLINGSALTS, PBMoves::WAKEUPSLAP,
       PBMoves::DRAGONPULSE, PBMoves::POWERGEM
    return [4000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,90]]]
  # 100 Base Power, 3000 EXP
  when PBMoves::FIRELASH, PBMoves::DRAGONHAMMER
    return [3000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,100]]]
  # 120 Base Power, 3500 EXP
  when PBMoves::DREAMEATER, PBMoves::BEAKBLAST
    return [3500,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,120]]]
  # 200 Base Power, 4000 EXP
  when PBMoves::SHELLTRAP
    return [4000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,200]]]
  # 120 Base Power, 85% Accurate Moves
  when PBMoves::POWERWHIP, PBMoves::GUNKSHOT, PBMoves::HEADSMASH
    return [4000,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,90]]]
  # 120 Base Power, 70% Accurate Moves
  when PBMoves::FOCUSBLAST, PBMoves::STONEEDGE
    return [4000,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,85]]]
  # 110 Base Power, 70% Accurate Moves
  when PBMoves::THUNDER, PBMoves::BLIZZARD, PBMoves::HURRICANE
    return [4000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,115]],
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,80]]]
  # 110 Base Power, 85% Accurate Moves
  when PBMoves::HYDROPUMP, PBMoves::FIREBLAST
    return [4000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,115]],
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,90]]]
  # 95 Base Power, 100% Accurate
  when PBMoves::THUNDERBOLT, PBMoves::FLAMETHROWER
    return [3000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,95]],
      [PBMoveUpNames::EffectChance,[PBMoveUps::EfChance,20]]]
  # 25< Power, 85% Accurate 2-5 hit moves
  when PBMoves::FURYATTACK, PBMoves::SPIKECANNON, PBMoves::FURYSWIPES,
       PBMoves::DOUBLESLAP
    return [2500,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,25]],
      [PBMoveUpNames::Accuracy,[PBMoveUps::Accuracy,100]]]
  # Brick Break
  when PBMoves::BRICKBREAK
    # TODO Double damage when breaking screens
  when PBMoves::BRINE
    # TODO Double damage when below 75% HP instead of 50%
  when PBMoves::TELEKINESIS
    # TODO Disable target's Ground-type moves
  when PBMoves::SYNCHRONOISE
    # TODO 75 Base Power, Doubled against same-type pokemon
  when PBMoves::ELECTROBALL
    # TODO Calculate damage using Speed instead of Sp. Atk
  when PBMoves::INCINERATE
    # TODO Doubled damage when burning an item
  when PBMoves::RELICSONG
    # TODO Type depends on Meloetta's Form
  when PBMoves::POLLENPUFF
    # TODO The user can target itself
  when PBMoves::TRIATTACK
    return [3000,
      [PBMoveUpNames::TypeElectric,[PBMoveUps::Type,PBTypes::ELECTRIC]],
      [PBMoveUpNames::TypeFire,[PBMoveUps::Type,PBTypes::FIRE]],
      [PBMoveUpNames::TypeIce,[PBMoveUps::Type,PBTypes::ICE]]]
  # Ice Beam
  when PBMoves::ICEBEAM
    return [3000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,95]]]
  # Bite
  when PBMoves::BITE
    # Become Crunch
  # Poison Fang
  when PBMoves::POISONFANG
    return [2500,
      [PBMoveUpNames::EffectChance,[PBMoveUps::EfChance,100],[PBMoveUps::Description,
          "The user bites the target with toxic fangs. This also leaves the target badly poisoned."]]]
  # Constrict
  when PBMoves::CONSTRICT
    return [1500,
      [PBMoveUpNames::Upgraded,[PBMoveUps::EfChance,100],[PBMoveUps::Power,40],[PBMoveUps::Description,
          "The target is attacked with long, creeping tentacles or vines. This also lowers the target's Speed stat."]]]
  # Charge Beam
  when PBMoves::CHARGEBEAM
    return [2500,
      [PBMoveUpNames::Upgraded,[PBMoveUps::EfChance,100],[PBMoveUps::Accuracy,100],[PBMoveUps::Description,
          "The user attacks with an electric charge. The user uses the remaining electricity to raise its Sp. Atk stat."]]]
  # Rock Smash
  when PBMoves::ROCKSMASH
    return [2000,
      [PBMoveUpNames::Upgraded,[PBMoveUps::EfChance,100],[PBMoveUps::Power,60],[PBMoveUps::Description,
          "The user attacks with a punch. This also lowers the target's Defense stat."]]]
  # Strength
  when PBMoves::STRENGTH
    return [3000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,85]],
      [PBMoveUpNames::TypeFighting,[PBMoveUps::Type,PBTypes::FIGHTING]]]
  # Slam
  when PBMoves::SLAM
    # Become Body Slam
  # Cut
  when PBMoves::CUT
    return [1500,
      [PBMoveUpNames::TypeGrass,[PBMoveUps::Power,60],[PBMoveUps::Type,PBTypes::GRASS]]]
  # Comet Punch
  when PBMoves::COMETPUNCH
    return [3000,
      [PBMoveUpNames::PowerPlus,[PBMoveUps::Power,25]],
      [PBMoveUpNames::Priority,[PBMoveUps::Priority,1],[PBMoveUps::Description,
          "The target is hit two to five times in a row. This move always goes first."]],
      [PBMoveUpNames::TypeFighting,[PBMoveUps::Type,PBTypes::FIGHTING]]]
  # Double Kick
  when PBMoves::DOUBLEKICK
    # Become Triple Kick
  when PBMoves::RAZORWIND
    return [2000,
      [PBMoveUpNames::TypeFlying,[PBMoveUps::Type,PBTypes::FLYING]]]
  # Jump Kick
  when PBMoves::JUMPKICK
    return [3000,
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,100]]]
      # Become High Jump Kick
  # Absorb
  when PBMoves::ABSORB
    # Become Mega Drain
  # Mega Drain
  when PBMoves::MEGADRAIN
    # Become Giga Drain
  # Bubble
  when PBMoves::BUBBLE
    # Become Bubble Beam
  # Psycho Cut
  when PBMoves::PSYCHOCUT
    return [3000,
      [PBMoveUpNames::Power,[PBMoveUps::Power,80]]],
      [PBMoveUpNames::Special,[PBMoveUps::Category,1]]
  # Mega Punch
  when PBMoves::MEGAPUNCH
    return [3000,
      [PBMoveUpNames::TypeFighting,[PBMoveUps::Type,PBTypes::FIGHTING],[PBMoveUps::Accuracy,90]],
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,100]]]
  # Mega Kick
  when PBMoves::MEGAKICK
    return [3500,
      [PBMoveUpNames::TypeFighting,[PBMoveUps::Type,PBTypes::FIGHTING]],
      [PBMoveUpNames::AccuracyUp,[PBMoveUps::Accuracy,90]]]
  end
  return false
end