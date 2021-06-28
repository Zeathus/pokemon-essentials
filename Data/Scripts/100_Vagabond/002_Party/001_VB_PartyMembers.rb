module PBParty
  Player    = 0
  Merrick   = 1
  Amethyst  = 2
  Kira      = 3
  Eliana    = 4
  Fintan    = 5
  Nekane    = 6
  Ziran     = 7
  
  def PBParty.len
    return 8
  end
  
  def PBParty.getName(id)
    id = getID(PBParty,id) if id.is_a?(Symbol)
    case id
    when PBParty::Player
      return $Trainer ? $Trainer.name : "Player"
    when PBParty::Merrick
      return "Duke"     # Duke sounds large. Merrick is a nod to Serebii-man
    when PBParty::Amethyst
      return "Amethyst" # The gem, colored after her name
    when PBParty::Kira
      return "Kira"     # Reference to Akira, the Sandslash user from the anime
    when PBParty::Eliana
      return "Eliana"   # Hebrew, meaning "My God has answered" (Ziran)
    when PBParty::Fintan
      return "Fintan"   # Irish, meaning "White Fire" (Reshiram)
    when PBParty::Nekane
      return "Nekane"   # Basque, meaning "Sorrows", as she is empty at first
    when PBParty::Ziran
      return "Ziran"    # Chinese, refers to a point of view in Daoist belief
    end
    return "n/a"
  end
  
  def PBParty.getTrainerType(id)
    id = getID(PBParty,id) if id.is_a?(Symbol)
    case id
    when PBParty::Player
      return PBTrainers::POKEMONTRAINER_Male
    when PBParty::Merrick
      return PBTrainers::FORETELLER
    when PBParty::Amethyst
      return PBTrainers::AMETHYST
    when PBParty::Kira
      return PBTrainers::RIVAL
    when PBParty::Eliana
      return PBTrainers::DAO_Eliana
    when PBParty::Fintan
      return PBTrainers::DAO_Fintan
    when PBParty::Nekane
      return PBTrainers::NEKANE
    when PBParty::Ziran
      return PBTrainers::DAO_Ziran
    end
    return -1
  end
  
  def PBParty.getTrainerID(id)
    id = getID(PBParty,id) if id.is_a?(Symbol)
    case id
    when PBParty::Player
      return $Trainer ? $Trainer.id : 0
    when PBParty::Merrick
      return 25111 # Celebi, with last digit repeated
    when PBParty::Amethyst
      return 1482  # SiO2: Chemical Symbol for Amethyst
    when PBParty::Kira
      return 11011 # Binary for Sandslash DEX#
    when PBParty::Eliana
      return 81204 # 8 + Zekrom dex number in octal (base 8)
    when PBParty::Fintan
      return 16283 # 16 + Reshiram dex num in hex (base 16)
    when PBParty::Nekane
      return 66666 # Obvious
    when PBParty::Ziran
      return 65829 # Mirrorable, balanced
    end
    return 0
  end
  
  def PBParty.getGender(id)
    id = getID(PBParty,id) if id.is_a?(Symbol)
    case id
    when PBParty::Player
      return $Trainer ? $Trainer.gender : 2
    when PBParty::Merrick
      return 0
    when PBParty::Amethyst
      return 1
    when PBParty::Kira
      return 0
    when PBParty::Eliana
      return 1
    when PBParty::Fintan
      return 0
    when PBParty::Nekane
      return 1
    when PBParty::Ziran
      return 0
    end
    return 2
  end
end

def isInParty
  return getPartyActive(0)>=0 && getPartyActive(1)>=0
end

def hasPartyMember(id)
  id = getID(PBParty,id) if id.is_a?(Symbol)
  pbSet(PARTY,[true]) if !pbGet(PARTY).is_a?(Array)
  return pbGet(PARTY)[id]
end

def isPartyMemberActive(id)
  id = getID(PBParty,id) if id.is_a?(Symbol)
  pbSet(PARTY,[true]) if !pbGet(PARTY).is_a?(Array)
  return pbGet(PARTY_ACTIVE)[0]==id || pbGet(PARTY_ACTIVE)[1]==id
end

def addPartyMember(id)
  id = getID(PBParty,id) if id.is_a?(Symbol)
  pbSet(PARTY,[true]) if !pbGet(PARTY).is_a?(Array)
  pbGet(PARTY)[id]=true
  if pbGet(PARTY_POKEMON)==0 || !pbGet(PARTY_POKEMON)[id]
    initPartyPokemon(id)
  end
  if !pbGet(PARTY_ACTIVE).is_a?(Array)
    pbSet(PARTY_ACTIVE,[0,-1])
  end
  members = pbGet(PARTY_ACTIVE)
  if members[1] < 0
    setPartyActive(id,1)
  elsif members[0] < 0
    setPartyActive(id,0)
  end
end

def removePartyMember(id)
  id = getID(PBParty,id) if id.is_a?(Symbol)
  pbSet(PARTY,[true]) if !pbGet(PARTY).is_a?(Array)
  pbGet(PARTY)[id]=false
end

def setPartyActive(id,pos)
  id = getID(PBParty,id) if id.is_a?(Symbol)
  if !pbGet(PARTY_ACTIVE).is_a?(Array)
    pbSet(PARTY_ACTIVE,[0,-1])
  end
  members = pbGet(PARTY_ACTIVE)
  if members[0] != id && members[1] != id
    if members[0] < 0
      members[0] = id
    elsif members[1] < 0
      members[1] = id
    else
      members[pos] = id
    end
  elsif members[0]>=0 && members[1]>=0
    otherpos=(pos + 1) % 2
    if id == members[otherpos]
      members[otherpos] = members[pos]
      members[pos] = id
    end
  end
  if members[1] >= 0
    $game_player.sprite.partner.character = _INTL("member{1}", members[1])
    $game_player.sprite.update
  end
end

def getPartyActive(pos=nil)
  if !pbGet(PARTY_ACTIVE).is_a?(Array)
    pbSet(PARTY_ACTIVE,[0,-1])
  end
  if pos
    return pbGet(PARTY_ACTIVE)[pos]
  else
    return pbGet(PARTY_ACTIVE)
  end
end







