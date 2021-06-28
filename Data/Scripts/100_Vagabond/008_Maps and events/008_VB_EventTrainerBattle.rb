class TrainerBattle
  
  attr_accessor (:trainerid)    # Trainer ID
  attr_accessor (:trainername)  # Trainer Name
  attr_accessor (:endspeech)    # End of battle speech
  attr_accessor (:doublebattle) # Double battle?
  attr_accessor (:trainerparty) # Party index
  attr_accessor (:canlose)      # Can lose?
  attr_accessor (:variable)     # Variable to store result
  attr_accessor (:levelmod)     # Level scaling?
  attr_accessor (:specialmod)   # Fixed level gap (requires scaling)
  attr_accessor (:sptrainer)    # Special trainer loading
  attr_accessor (:startover)    # If not nil, player can choose to warp here when losing
  
  def initialize(id,name)
    @trainerid    = id
    @trainername  = name
    @endspeech    = "..."
    @doublebattle = false
    @trainerparty = 0
    @canlose      = false
    @variable     = 1
    @levelmod     = true
    @specialmod   = nil
    @sptrainer    = ""
    @startover    = nil
  end
  
  def party=(value)
    @trainerparty=value
  end
  
  def double=(value)
    @doublebattle=value
  end
  
  def scaling=(value)
    @levelmod=value
  end
  
  def endspeech=(value)
    value.gsub!("\n","")
    @endspeech=value
  end
  
  def speech=(value)
    value.gsub!("\n","")
    @endspeech=value
  end
  
  def start
    $game_variables[TRAINER_BATTLE]=0
    return pbTrainerBattle(@trainerid,@trainername,@endspeech,
                           @doublebattle,@trainerparty,@canlose,
                           @variable,@levelmod,@specialmod,@sptrainer,
                           @startover)
  end
  
end

def trainerbattle(trainerid=nil,trainername=nil)
  
  if trainerid && trainername
    trainerid = getID(PBTrainers,trainerid) if trainerid.is_a?(Symbol)
    $game_variables[TRAINER_BATTLE] = TrainerBattle.new(trainerid,trainername)
  end
  
  if $game_variables[TRAINER_BATTLE].is_a?(TrainerBattle)
    return $game_variables[TRAINER_BATTLE]
  else
    raise "Must call trainerbattle(id,name) before anything else."
  end
  
end

def tbattle(trainerid=nil,trainername=nil)
  return trainerbattle(trainerid,trainername)
end











