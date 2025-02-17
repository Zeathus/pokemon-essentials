# ----------------------------------------------------------------------
# General
# ----------------------------------------------------------------------
TELEPORT_MAP    = true

# ----------------------------------------------------------------------
# Game Switches
# ----------------------------------------------------------------------
GOT_STARTER         = 3
CUSTOM_WILD          = 53
TAKEN_STEP          = 54
FORCED_RUNNING      = 55
ATTACKS_ONLY_BATTLE = 56
AI_TAKEOVER         = 57
CATCH_BLOCK          = 60
MUDAMUDA            = 61
LETHAL_LOSSES        = 62
MESPRIT_AID         = 63
HAS_POKEGEAR        = 65
SPIN_PLAYER         = 66
MAP_UPDATE          = 67
LOCK_PAUSE_MENU     = 69
QUEST_TUTORIAL      = 70
HAS_QUEST_LIST      = 71
TEMP_1              = 72
TEMP_2              = 73
TEMP_3              = 74
TEMP_4              = 75
BEING_CHALLENGED    = 76
DISABLE_EXP          = 79
SPEECH_COLOR_MOD    = 80
CAN_SURF            = 81
CHOSEN_POKEMON      = 82
GPO_MEMBER          = 85
HALCYON_ACCESS      = 86
REVERSE_CHASMS      = 87
BICYCLE_UPGRADE     = 95
ROD_UPGRADE         = 96
ANTISAVE            = 101
PERMA_SLEEP          = 102
SOFT_PARALYSIS      = 103
GHOST_ENCOUNTERS    = 104
QMARK_LEVEL          = 105
MINUS1_LEVEL        = 106
NO_TELEPORT          = 107
NO_TRAINER_CARD     = 108
HAS_HABITAT_DEX     = 109
WEATHER_RAIN        = 110
WEATHER_SUN          = 111
WEATHER_SNOW        = 112
WEATHER_STORM        = 113
SMOKEY_FOREST       = 114
STADIUM_POINT_SHOP  = 115
STADIUM_PARTY_SEL   = 116
HIDE_REFLECTIONS    = 117
SHOW_COLLISION      = 124
DEBUG_EXTRA         = 125
UNSTOPPABLE          = 146
FINAL_BATTLE        = 147
POKEPLAYER          = 151
FRIENDOFELEMENTS    = 209

# ----------------------------------------------------------------------
# Game Variables
# ----------------------------------------------------------------------
PARTY_ACTIVE        = 23
PARTY_POKEMON       = 24
PARTY               = 25
STARTER             = 34
STARTER_ID          = 35
BATTLE_SIM_AI        = 36
PLAYER_ROTATION      = 37
DAILY_MAIL          = 38
DAILY_FORECAST      = 39
BGM_OVERRIDE        = 40
TELEPORT_LIST       = 41
RIDE_PAGER          = 42
RIDE_CURRENT        = 43
RIDE_REGISTERED     = 44
DATA_CHIP_MOVES     = 45
HIGHEST_LEVEL       = 46
PLAYER_EXP          = 47
AVERAGE_LEVEL       = 48
TRAINER_ARRAY       = 49
QUEST_ARRAY         = 50
QUEST_MAIN          = 51
QUEST_SPECIAL       = 52
LAST_QUEST          = 53
LAST_PAGE            = 54
QUEST_SORTING       = 55
PAUSE_MENU_ITEMS    = 56
SPHERE_COUNT        = 57
PREF_LEVEL          = 58
CHOICES             = 59
BATTLE_PARTIES      = 60
DRINK_ACTIVE        = 61
DRINK_TIME          = 62
EXP_MODIFIER        = 63
MOVEMENT_SPEED      = 64
RKS_MEMORY_TYPE      = 66
LAST_BATTLE_OPTION  = 67
BATTLE_ORIGINAL_LVL = 68
NEKANE_STATE        = 73
CHARACTER_LOCATIONS = 74
PARTY_STORE         = 76
BAG_STORE           = 77
WILD_MODIFIER       = 80
WILD_AI_LEVEL       = 81
WILD_AI_SKILLCODE   = 82
HOLDING_BACK        = 83
WILD_UNOWN_FORM     = 84
BOSS_BATTLE         = 85
TRAINER_BATTLE      = 86
TIME_AND_DAY        = 90
LEAGUE_MAX_PKMN      = 97
LEAGUE_MAX_LVL      = 98
BADGE_COUNT         = 99
GLOBAL_TIMER        = 101
UI_ARRAY            = 102
OVERRIDE            = 104
AFFECTION           = 105
REELED_IN_POKEMON   = 106
STADIUM_POINTS      = 107
STADIUM_WON_CUPS    = 108
STADIUM_CUP         = 109
SICKZAGOON          = 110
POKEPLAYERID        = 112
LASTBATTLEDTRAINERS = 113
PERSISTENT_EVENTS   = 114
DEBUG_VAR           = 115
AMPHIWOODSPOS       = 128
AMPHIWOODSROUTE     = 129
CURRENTMINIQUEST    = 144
MINIQUESTCOUNT      = 145
MINIQUESTCOUNT2     = 146
MINIQUESTLIST       = 147
MINIQUESTDAY        = 148
MINIQUESTLIST2      = 149
MINIQUESTDAY2       = 150

# ----------------------------------------------------------------------
# Auto Levelling Settings
# ----------------------------------------------------------------------
SKIP_SCALING_MAPS = [92,93,94,95,96,97,98,99] # Mica Quarry

def pbHideReflections?(map_id)
    return [
        120 # Breccia Outlook
    ].include?(map_id)
end





