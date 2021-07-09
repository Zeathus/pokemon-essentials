def simtest
  sim = BattleSim.new([
  [:GARDEVOIR,40,:CHOICESPECS,[:MOONBLAST],1,1,PBNatures::MILD],
  [:CHIMECHO,60,0,[:ENTRAINMENT],0,1,PBNatures::HASTY]],
  [:SIMTRAINER, "Jishin", "Simulation Complete"],[
  [:EARTHQUAKE]],4)
  sim.start
end

def simtest3
  sim = BattleSim.new([
  [:VIGOROTH,50,0,[:TAUNT,:ENCORE,:FACADE],0,0,PBNatures::DOCILE],
  [:VIGOROTH,50,0,[:TAUNT,:ENCORE,:FACADE],0,0,PBNatures::DOCILE]],
  [:SIMTRAINER, "Test", "hello"],[
  [:PROTECT,:SWORDSDANCE,:BATONPASS,:LEECHLIFE],
  [:COSMICPOWER,:FOLLOWME],
  [:EARTHQUAKE]],0,true)
  sim.start
end

def simtest2
  sim = BattleSim.new([
  [:QUAGSIRE,50,:WIDELENS,[:EARTHQUAKE,:SURF],0,0,PBNatures::ADAMANT],
  [:TENTACRUEL,49,0,[:WRAP],0,0,PBNatures::DOCILE],
  [:MAGIKARP,19,0,[:SPLASH],2,1,PBNatures::BOLD]],
  [:COOLTRAINER_M, "Test", "hello"],[
  [:SWORDSDANCE,:PROTECT,:FLAMETHROWER,:PROTECT]])
  sim.start
end