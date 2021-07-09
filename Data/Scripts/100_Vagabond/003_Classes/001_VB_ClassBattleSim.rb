class BattleSim
  attr_accessor(:status)        # 0: Locked, 1: Unlocked, 2: Finished
  attr_accessor(:player_team)   # The player's team
  attr_accessor(:opponent)      # The opponent [PBTrainers, "name", "after battle"]
  attr_accessor(:move_order)    # The order the opponent will use moves
  attr_accessor(:max_turns)     # The maximum amount of turns to win
  attr_accessor(:double_battle) # If the battle is a double battle
  
  def initialize(player_team, opponent, move_order, max_turns=0, double_battle=false)
    self.status = 0
    self.player_team = []
    for pkmn in player_team
      pokemon = PokeBattle_Pokemon.new(pkmn[0],pkmn[1],$Trainer)
      pokemon.moves = []
      pokemon.item = pkmn[2]
      for move in pkmn[3]
        movedata=PBMove.new(move)
        pokemon.moves.push(movedata)
      end
      pokemon.abilityflag = pkmn[4]
      pokemon.genderflag = pkmn[5]
      pokemon.natureflag = pkmn[6]
      for i in 0..5
        pokemon.iv[i]=31
      end
      pokemon.calc_stats
      self.player_team.push(pokemon)
    end
    self.opponent = opponent
    self.move_order = move_order
    self.max_turns = max_turns
    self.double_battle = double_battle
  end
  
  def start
    old_team = Marshal.load(Marshal.dump($Trainer.party))
    $Trainer.party = []
    for pkmn in player_team
      $Trainer.party.push(pkmn)
    end
    list = []
    list2 = []
    for i in move_order
      list.push(0)
      list2.push(false)
    end
    $game_variables[BATTLE_SIM_AI]=[move_order,list,list2]
    result=pbTrainerBattle(opponent[0],opponent[1],_I(opponent[2]),double_battle,0,true)
    $game_variables[BATTLE_SIM_AI]=0
    status=2 if result=1
    $Trainer.party = Marshal.load(Marshal.dump(old_team))
    old_team=nil
  end
  
end