module PBLocks
  # Arguments needed are listed behind each variable
  # *Means a value is optional
  # For unlocks, all requirements are treated as a minimum value
  # For quest markers, they are treates as an absolute value
  MapVisited      = 1  # [:MapVisited, map_id]
  QuestStatus     = 2  # [:QuestStatus, quest_id, status, *questtype]
  TrainerBattled  = 3  # [:TrainerBattled, trainer_name]
  GlobalSwitch    = 4  # [:GlobalSwitch, switch_id]
  EventSelfSwitch = 5  # [:EventSelfSwitch, map_id, event_id, switch]
  Variable        = 6  # [:Variable, var_id, comparator, value]
  BadgeCount      = 7  # [:BadgeCount, min_badges]
  HasBadge        = 8  # [:HasBadge, badge_id]
  AverageLevel    = 9  # [:AverageLevel, min_level]
  ReadMail        = 10 # [:ReadMail, sender, subject, *mailbox]
  HasPokemon      = 11 # [:HasPokemon, PBSpecies]
  HasItem         = 12 # [:HasItem, PBItems, amount]
  PokedexSeen     = 13 # [:Pokedex, PBSpecies]
  QuestStep       = 14 # [:QuestStep, quest_id, step, *questtype]
  HasMember       = 15 # [:HasMember, member_id]
end

class QuestData
  attr_accessor(:id)          # ID used for the display order
  attr_accessor(:name)        # The name of the quest
  attr_accessor(:desc)        # The description of the quest
  attr_accessor(:step)        # The steps the player is currently on
  attr_accessor(:steps)       # Array of steps required to complete the quest
  attr_accessor(:complete)    # Text to display when a quest is complete
  attr_accessor(:hidden)      # If the quest name and area is shown or not
  attr_accessor(:status)      # -1 = None, 0 = Available, 1 = Active, 2 = Complete
  attr_accessor(:location)    # The location of the quest
  attr_accessor(:money)       # Money rewarded by the quest
  attr_accessor(:exp)         # Exp reward multiplier, is divided by 100
  attr_accessor(:item)        # Item rewarded by the quest
  attr_accessor(:hideitem)    # Show item as unknown
  attr_accessor(:trainer)     # If the quest is obtained from a generated trainer
  attr_accessor(:lock)        # Unlock requirments: [[type,vars],[type2,vars2],...]
  attr_accessor(:unlock)      # The status of the quest when unlocked
  attr_accessor(:finish)      # Requirements to automatically finish the quest
  attr_accessor(:mapguide)    # Display where to go on the map
  attr_accessor(:dummy)       # Dummy variable to be used for a variety of things
  attr_accessor(:dummy2)      # Secondary dummy to be used if needed
  
  def initialize(id,name,money,exp,item,location,desc,steps,complete,trainer=false)
    self.id       = getID(PBQuests,id)
    self.name     = name
    self.money    = money
    self.exp      = exp
    self.item     = item
    self.hideitem = false
    self.location = location
    self.desc     = desc
    self.step     = 0
    self.steps    = steps
    self.complete = complete
    self.hidden   = 0
    self.status   = -1
    self.trainer  = trainer
    self.lock     = 0
    self.unlock   = 0
    self.finish   = 0
    self.mapguide = []
    self.dummy    = 0
    self.dummy2   = 0
  end
  
  def unlock?
    return false if lock==0
    ret=true
    for i in lock
      i[0]=getID(PBLocks,i[0]) if i[0].is_a?(Symbol)
      if i[0]==PBLocks::MapVisited
        ret=false if $PokemonGlobal.visitedMaps[i[1]]!=true
      elsif i[0]==PBLocks::QuestStatus
        if i.length<4
          i[1]=getID(PBQuests,i[1]) if i[1].is_a?(Symbol)
          ret=false if $game_variables[QUEST_ARRAY][i[1]].status<i[2]
        else
          if i[3]==0
            i[1]=getID(PBMainQuests,i[1]) if i[1].is_a?(Symbol)
            ret=false if $game_variables[QUEST_MAIN][i[1]].status<i[2]
          elsif i[3]==1
            i[1]=getID(PBQuests,i[1]) if i[1].is_a?(Symbol)
            ret=false if $game_variables[QUEST_ARRAY][i[1]].status<i[2]
          else
            i[1]=getID(PBQuests,i[1]) if i[1].is_a?(Symbol)
            ret=false if $game_variables[QUEST_SPECIAL][i[1]].status<i[2]
          end
        end
      elsif i[0]==PBLocks::TrainerBattled
        ret=false if pbTrainerFromName(i[1]).battled==false
      elsif i[0]==PBLocks::GlobalSwitch
        ret=false if $game_switches[i[1]]==false
      elsif i[0]==PBLocks::EventSelfSwitch
        ret=false if !$game_self_switches[[i[1], i[2], i[3]]]
      elsif i[0]==PBLocks::Variable
        if i[1]==0 # Equal To
          ret=false if $game_variables[i[0]]!=i[2]
        elsif i[1]==1 # Above
          ret=false if $game_variables[i[0]]<=i[2]
        elsif i[1]==2 # Below
          ret=false if $game_variables[i[0]]>=i[2]
        elsif i[1]==3 # Not Equal To
          ret=false if $game_variables[i[0]]==i[2]
        end
      elsif i[0]==PBLocks::BadgeCount
        ret=false if $game_variables[BADGE_COUNT]<i[1]
      elsif i[0]==PBLocks::HasBadge
        ret=false if $game_switches[4+i[1]]==false
      elsif i[0]==PBLocks::AverageLevel
        ret=false if pbTrainerAverageLevel<i[1]
      elsif i[0]==PBLocks::ReadMail
        if i.length<4
          ret=false if !pbHasReadMail(i[1],i[2])
        else
          ret=false if !pbHasReadMail(i[1],i[2],i[3])
        end
      elsif i[0]==PBLocks::QuestStep
        i[1]=getID(PBQuests,i[1]) if i[1].is_a?(Symbol)
        if i.length<4
          ret=false if $game_variables[QUEST_ARRAY][i[1]].step<i[2]
        else
          if i[3]==0
            ret=false if $game_variables[QUEST_MAIN][i[1]].step<i[2]
          elsif i[3]==1
            ret=false if $game_variables[QUEST_ARRAY][i[1]].step<i[2]
          else
            ret=false if $game_variables[QUEST_SPECIAL][i[1]].step<i[2]
          end
        end
      elsif i[0]==PBLocks::HasMember
        ret=false if !hasPartyMember(i[1])
      end
    end
    return ret
  end
  
  def finish?
    return false if finish==0
    ret=true
    for i in finish
      i[0]=getID(PBLocks,i[0]) if i[0].is_a?(Symbol)
      if i[0]==PBLocks::MapVisited
        ret=false if $PokemonGlobal.visitedMaps[i[1]]!=true
      elsif i[0]==PBLocks::QuestStatus
        i[1]=getID(PBQuests,i[1]) if i[1].is_a?(Symbol)
        ret=false if $game_variables[QUEST_ARRAY][i[1]].status<i[2]
      elsif i[0]==PBLocks::TrainerBattled
        ret=false if pbTrainerFromName(i[1]).battled==false
      elsif i[0]==PBLocks::GlobalSwitch
        ret=false if $game_switches[i[1]]==false
      elsif i[0]==PBLocks::EventSelfSwitch
        ret=false if $game_self_switches[[i[1], i[2], i[3]]]
      elsif i[0]==PBLocks::Variable
        if i[1]==0 # Equal To
          ret=false if $game_variables[i[0]]!=i[2]
        elsif i[1]==1 # Above
          ret=false if $game_variables[i[0]]<=i[2]
        elsif i[1]==2 # Below
          ret=false if $game_variables[i[0]]>=i[2]
        elsif i[1]==3 # Not Equal To
          ret=false if $game_variables[i[0]]==i[2]
        end
      elsif i[0]==PBLocks::BadgeCount
        ret=false if $game_variables[BADGE_COUNT]<i[1]
      elsif i[0]==PBLocks::HasBadge
        ret=false if $game_switches[4+i[1]]==false
      elsif i[0]==PBLocks::AverageLevel
        ret=false if pbTrainerAverageLevel<i[1]
      elsif i[0]==PBLocks::ReadMail
        if i.length<4
          ret=false if !pbHasReadMail(i[1],i[2])
        else
          ret=false if !pbHasReadMail(i[1],i[2],i[3])
        end
      end
    end
    return ret
  end
  
  def getName
    if self.status != -1 && !self.hidden
      return self.name
    elsif self.status == 1 || self.status == 2
      return self.name
    elsif self.status == -1 && !self.hidden
      return "Unavailable"
    else
      return "?????"
    end
  end
  
  def getStatus
    if self.status == -1
      return "?: "
    elsif self.status == 0
      return "?: "
    elsif self.status == 1
      return "O: "
    elsif self.status == 2
      return "X: "
    else
      return "(#Status Error)"
    end
  end
  
  def pbGetStepDescription
    ret=""
    if hidden && hidden >= 2 && status <= 0
      ret= _INTL("This is a hidden quest. You have to find it on your own.")
    elsif status == -1
      ret= _INTL("This quest is not avaialable yet.")
    elsif status == 0
      if trainer
        trainer = pbTrainerFromName(location)
        if trainer.last_area >= 1
          ret= _INTL("This quest is from the trainer {1}, who is currently around {2}", trainer.name, pbGetMapName(trainer.last_area))
        else
          ret= _INTL("This quest is from the trainer {1}. They prefer {2}", trainer.name, trainer.pbPreferredAreaString)
        end
      else
        ret= _INTL("This quest is located {1}.", location)
      end
    elsif status == 1
      ret= _INTL(steps[step])
    elsif status == 2
      if self.complete
        ret= self.complete
      else
        ret= _INTL("This quest has been completed.")
      end
    end
    char = "\n"
    ret.gsub!(char,"")
    return ret
  end
end