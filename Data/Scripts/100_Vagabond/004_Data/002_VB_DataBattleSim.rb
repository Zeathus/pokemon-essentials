def simtest
  sim = BattleSim.new([
  [PBSpecies::GARDEVOIR,40,PBItems::CHOICESPECS,[PBMoves::MOONBLAST],1,1,PBNatures::MILD],
  [PBSpecies::CHIMECHO,60,0,[PBMoves::ENTRAINMENT],0,1,PBNatures::HASTY]],
  [PBTrainers::SIMTRAINER, "Jishin", "Simulation Complete"],[
  [PBMoves::EARTHQUAKE]],4)
  sim.start
end

def simtest3
  sim = BattleSim.new([
  [PBSpecies::VIGOROTH,50,0,[PBMoves::TAUNT,PBMoves::ENCORE,PBMoves::FACADE],0,0,PBNatures::DOCILE],
  [PBSpecies::VIGOROTH,50,0,[PBMoves::TAUNT,PBMoves::ENCORE,PBMoves::FACADE],0,0,PBNatures::DOCILE]],
  [PBTrainers::SIMTRAINER, "Test", "hello"],[
  [PBMoves::PROTECT,PBMoves::SWORDSDANCE,PBMoves::BATONPASS,PBMoves::LEECHLIFE],
  [PBMoves::COSMICPOWER,PBMoves::FOLLOWME],
  [PBMoves::EARTHQUAKE]],0,true)
  sim.start
end

def simtest2
  sim = BattleSim.new([
  [PBSpecies::QUAGSIRE,50,PBItems::WIDELENS,[PBMoves::EARTHQUAKE,PBMoves::SURF],0,0,PBNatures::ADAMANT],
  [PBSpecies::TENTACRUEL,49,0,[PBMoves::WRAP],0,0,PBNatures::DOCILE],
  [PBSpecies::MAGIKARP,19,0,[PBMoves::SPLASH],2,1,PBNatures::BOLD]],
  [PBTrainers::COOLTRAINER_M, "Test", "hello"],[
  [PBMoves::SWORDSDANCE,PBMoves::PROTECT,PBMoves::FLAMETHROWER,PBMoves::PROTECT]])
  sim.start
end