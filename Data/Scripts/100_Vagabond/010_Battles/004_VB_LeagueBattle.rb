def pbStoreParty(variable)
  @otherparty = Marshal.load(Marshal.dump($Trainer.party))
  $game_variables[variable] = @otherparty
end

def pbRestoreParty(variable)
  @otherparty = $game_variables[variable]
  $Trainer.party = Marshal.load(Marshal.dump(@otherparty))
end

def pbChooseTeam(max)
  if $Trainer.party.length < max
    max = $Trainer.party.length
  end
  @chooseparty = pbChooseMultiplePokemon(max)
  if @chooseparty != -1
    @playparty = Marshal.load(Marshal.dump(@chooseparty))
    $Trainer.party = Marshal.load(Marshal.dump(@playparty))
    $game_switches[CHOSEN_POKEMON] = true
  else
    $game_switches[CHOSEN_POKEMON] = false
  end
end

def pbSetRuleset(maxpkmn, maxlvl)
  $game_variables[LEAGUE_MAX_PKMN]=maxpkmn
  $game_variables[LEAGUE_MAX_LVL]=maxlvl
end

def pbGymRuleset(badges=false)
  badges = pbGet(BADGE_COUNT) if !badges
  @maxpkmn=6
  @maxlvl=100
  if badges == 0
    @maxpkmn=2
    @maxlvl=13
  elsif badges == 1
    @maxpkmn=3
    @maxlvl=20
  elsif badges == 2
    @maxpkmn=4
    @maxlvl=27
  elsif badges == 3
    @maxpkmn=5
    @maxlvl=36
  elsif badges == 4
    @maxpkmn=6
    @maxlvl=43
  elsif badges == 5
    @maxpkmn=6
    @maxlvl=50
  elsif badges == 6
    @maxpkmn=6
    @maxlvl=55
  elsif badges == 7
    @maxpkmn=6
    @maxlvl=60
  elsif badges == 8
    @maxpkmn=6
    @maxlvl=70
  end
  $game_variables[LEAGUE_MAX_PKMN] = @maxpkmn
  $game_variables[LEAGUE_MAX_LVL] = @maxlvl
end

def pbChooseMultiplePokemon(max)
  @scene = PokemonScreen_Scene.new
  @party = $Trainer.party
  annot=[]
  statuses=[]
  ordinals=[
   _INTL("INELIGIBLE"),
   _INTL("NOT ENTERED"),
   _INTL("BANNED"),
   _INTL("FIRST"),
   _INTL("SECOND"),
   _INTL("THIRD"),
   _INTL("FOURTH"),
   _INTL("FIFTH"),
   _INTL("SIXTH")
  ]
  #if !ruleset.hasValidTeam?(@party)
  #  return nil
  #end
  ret=nil
  addedEntry=false
  for i in 0...@party.length
    statuses[i]=1
  #  if ruleset.isPokemonValid?(@party[i])
  #    statuses[i]=1
  #  else
  #    statuses[i]=2
  #  end  
  end
  for i in 0...@party.length
    annot[i]=statuses[i]
  end
  @scene.pbStartScene(@party,_INTL("Choose Pokémon and confirm."),annot,true)
  loop do
    realorder=[]
    for i in 0...@party.length
      for j in 0...@party.length
        if statuses[j]==i+3
          realorder.push(j)
          break
        end
      end
    end
    for i in 0...realorder.length
      statuses[realorder[i]]=i+3
    end
    for i in 0...@party.length
      annot[i]=statuses[i]
    end
    @scene.pbAnnotate(annot)
    if realorder.length==max && addedEntry#ruleset.number && addedEntry
      @scene.pbSelect(6)
    end
    @scene.pbSetHelpText(_INTL("Choose Pokémon and confirm."))
    pkmnid=@scene.pbChoosePokemon
    addedEntry=false
    if pkmnid==6 # Confirm was chosen
      ret=[]
      for i in realorder
        ret.push(@party[i])
      end
      if ret.length < 1
        Kernel.pbMessage("You need to select at least 1 Pokémon.")
        next
      end
      error=[]
      break
      #if !ruleset.isValid?(ret,error)
      #  pbDisplay(error[0])
      #  ret=nil
      #else
      #  break
      #end
    end
    if pkmnid<0 # Canceled
      if $game_switches[STADIUM_PARTY_SEL]
        cup = pbStadiumCup
        index = pbStadiumCupIndex
        type = cup[3][index][0]
        name = cup[3][index][1]
        team = cup[3][index][2]
        type = getID(PBTrainers,type) if type.is_a?(Symbol)
        trainer = pbLoadTrainer(type,name,team)
        party = trainer[2]
        text = sprintf("\\l[%d]%s's Party:\n",party.length + 2,name)
        for i in party
          text += "- " + i.name
          text += "\n"
        end
        Kernel.pbMessage(text)
        next
      end
      ret=-1
      break
    end
    cmdEntry=-1
    cmdNoEntry=-1
    cmdSummary=-1
    commands=[]
    if (statuses[pkmnid] || 0) == 1
      commands[cmdEntry=commands.length]=_INTL("Entry")
    elsif (statuses[pkmnid] || 0) > 2
      commands[cmdNoEntry=commands.length]=_INTL("No Entry")
    end
    pkmn=@party[pkmnid]
    commands[cmdSummary=commands.length]=_INTL("Summary")
    commands[commands.length]=_INTL("Cancel")
    command=@scene.pbShowCommands(_INTL("Do what with {1}?",pkmn.name),commands) if pkmn
    if cmdEntry>=0 && command==cmdEntry
      if realorder.length>=max && max>0#ruleset.number && ruleset.number>0
        #pbDisplay(_INTL("No more than {1} Pokémon may enter.",max))
        @scene.pbSetHelpText(_INTL("No more than {1} Pokémon may enter.",max))
      else
        statuses[pkmnid]=realorder.length+3
        addedEntry=true
        pbRefreshSingle(pkmnid)
      end
    elsif cmdNoEntry>=0 && command==cmdNoEntry
      statuses[pkmnid]=1
      pbRefreshSingle(pkmnid)
    elsif cmdSummary>=0 && command==cmdSummary
      @scene.pbSummary(pkmnid)
    end
  end
  @scene.pbEndScene
  return ret
end

def pbRefreshSingle(i)
  @sprites={}
  sprite=@sprites["pokemon#{i}"]
  if sprite 
    if sprite.is_a?(PokeSelectionSprite)
      sprite.pokemon=sprite.pokemon
    else
      sprite.refresh
    end
  end
end

def pbResetGymTrainers
  if !$game_switches[4] # Fire Gym
    
  end
  if !$game_switches[5] # Grass Gym
    $game_self_switches[[162,156,"A"]]=false
    $game_self_switches[[162,157,"A"]]=false
    $game_self_switches[[162,158,"A"]]=false
  end
  if !$game_switches[6]
    
  end
  if !$game_switches[7]
    
  end
  if !$game_switches[8]
    
  end
  if !$game_switches[9]
    
  end
  if !$game_switches[10]
    
  end
  if !$game_switches[11]
    
  end
end










