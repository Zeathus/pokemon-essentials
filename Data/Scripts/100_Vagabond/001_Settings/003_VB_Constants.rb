#---------------------------------------------------------------
# PLAYER STATS
# *Grouped two by two by their counterparts
#---------------------------------------------------------------
TIMES_HEALED    = 126 # Total used heal items X
TIMES_FAINTED   = 127 # Total party pokémon fainted X

TIMES_DEFEATED  = 128 # Total wild pokémon defeated
TIMES_FLED      = 129 # Total wild battled fled

TIMES_CENTER    = 130 # Total heals at pokémon centers
TIMES_BATTLED   = 131 # Total trainer battles done

TIMES_WON       = 132 # Total battles won
TIMES_LOST      = 133 # Total battles lost

TIMES_NICKNAMED = 136 # Total pokémon nicknamed
TIMES_UNNAMED   = 137 # Total pokémon not nicknamed

#---------------------------------------------------------------
# FIELD CATEGORY IDs
# *Used to categorize the location of generated trainers
#---------------------------------------------------------------
PLAINS    = 0
FOREST    = 1
MOUNTAIN  = 2
CAVE      = 3
CITY      = 4
FLOWERS   = 5
BUGFOREST = 6
WATER     = 7
SHORE     = 8
DARK      = 9
BICYCLE   = 10
DOJO      = 11
RIVER     = 12

#---------------------------------------------------------------
# MAP CATEGORY LISTINGS
# *Listed by the maps' IDs, easily checkable in private excel sheet.
#---------------------------------------------------------------
MAP_BATTLE            = []
MAP_BATTLE[PLAINS]    = [6]
MAP_BATTLE[FOREST]    = [6,7,9,13]
MAP_BATTLE[MOUNTAIN]  = [14,20]
MAP_BATTLE[CAVE]      = [20]
MAP_BATTLE[CITY]      = []
MAP_BATTLE[FLOWERS]   = [6]
MAP_BATTLE[BUGFOREST] = [7]
MAP_BATTLE[WATER]     = []
MAP_BATTLE[SHORE]     = []
MAP_BATTLE[DARK]      = []
MAP_BATTLE[BICYCLE]   = []
MAP_BATTLE[DOJO]      = []
MAP_BATTLE[RIVER]     = [9]
MAP_CITY              = [3,8,12,16]
MAP_CENTER            = [10,15,17]

#---------------------------------------------------------------
# MISC. TWEAKS
# *Different variables affecting the scripts
#---------------------------------------------------------------
# How many times a trainer must visit an area to have it preferred
PREFERRED_AREA_VISIT = 3
# How many times a trainer must visit a city to have it preferred
PREFERRED_CITY_VISIT = 6
# How long before a trainer can respawn
SPAWN_TIMER = 7

#---------------------------------------------------------------
# MAP MENTIONS
# *What word to use before a mention of a map
#---------------------------------------------------------------
MENTION_AT     = [
  PBMaps::MtPegmaHillside]
MENTION_IN     = [
  PBMaps::FeldsparTown,
  PBMaps::MicaTown]
MENTION_ON     = []
MENTION_AT_THE = []
MENTION_IN_THE = []









