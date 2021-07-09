
def getActivePokemon(pos)
  id = getPartyActive(pos)
  if id == PBParty::Player
    return $Trainer.party
  end
  return pbGet(PARTY_POKEMON)[id]
end

def getPartyPokemon(id)
  id = getID(PBParty,id) if id.is_a?(Symbol)
  if id == PBParty::Player
    return $Trainer.party
  end
  return pbGet(PARTY_POKEMON)[id]
end

def initPartyPokemon(id)
  pbSet(PARTY_POKEMON,[]) if !pbGet(PARTY_POKEMON).is_a?(Array)
  id = getID(PBParty,id) if id.is_a?(Symbol)
  parties = pbGet(PARTY_POKEMON)
  party = []
  case id
  when PBParty::Merrick
    party.push(createPartyPokemon(
      id,:RIOLU,10,[:QUICKATTACK,:METALCLAW,:VACUUMWAVE,:ENDURE],1,
      :HASTY,0,[10,31,16,31,16,5]))
    party.push(createPartyPokemon(
      id,:BRONZOR,9,[:CONFUSION,:TACKLE,:CONFUSERAY,:PAYBACK],0,
      :CALM,2,[16,5,31,10,16,31]))
  when PBParty::Amethyst
    party.push(createPartyPokemon(
      id,:SNEASEL,5,[],0,:CALM,1,[10,31,16,31,5,16]))
    party.push(createPartyPokemon(
      id,:MISDREAVUS,5,[],1,:HASTY,0,[16,5,10,31,31,16]))
  when PBParty::Kira
    party.push(createPartyPokemon(
      id,:SANDSHREW,5,[],1,:ADAMANT,2,[16,31,31,16,5,10]))
    party.push(createPartyPokemon(
      id,:LARVESTA,5,[],0,:TIMID,0,[16,5,16,10,31,31]))
  when PBParty::Eliana
    
  when PBParty::Fintan
    
  when PBParty::Nekane
    
  when PBParty::Ziran
    
  end
  parties[id]=party
end

def addTestPokemon
  $Trainer.party.push(createPartyPokemon(
    0,:RIOLU,5,[],1,:HASTY,0,[10,31,16,31,16,5]))
end
  
def addTestPokemon2
  party = pbGet(PARTY_POKEMON)[PBParty::Kira]
  party.push(createPartyPokemon(
    PBParty::Kira,:TYRANTRUM,50,[],1,:ADAMANT,0,[31,31,16,10,5,16]))
end

def createPartyPokemon(id,species,level,moves,ability,nature,gender,ivs=nil)
  id = getID(PBParty,id) if id.is_a?(Symbol)
  
  poke = Pokemon.new(species,level)
  
  # Trainer fields
  poke.owner.name   = PBParty.getName(id)
  poke.owner.id     = PBParty.getTrainerID(id)
  poke.owner.gender = PBParty.getGender(id)
  
  # Set Moves
  for i in moves
    #i = getID(PBMoves,i) if i.is_a?(Symbol)
    poke.learn_move(i)
  end
  poke.record_first_moves
  
  # Ability
  poke.ability_index = ability
  
  # Gender
  poke.gender = gender
  
  # Nature
  poke.nature = nature
  
  # IVs
  if ivs
    for i in 0...6
      poke.iv[i] = ivs[i]
    end
  end
  
  poke.calc_stats
  
  return poke
end