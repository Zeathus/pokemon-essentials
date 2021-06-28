def pbPokemonBossBGM
  $PokemonGlobal.nextBattleBGM="Battle! VS Wild Strong Pokemon (Hero Encore)"
end

def pbBossGiratina1
  $PokemonGlobal.nextBattleBGM="Battle! VS Giratina"
  $PokemonGlobal.nextBattleBack="Giratina"
  pbModifier.optimize
  pbModifier.hpmult=10.0
  pbModifier.form=1
  pbModifier.moves=[
    PBMoves::SHADOWFORCE,
    PBMoves::AURASPHERE,
    PBMoves::EARTHPOWER,
    PBMoves::SHADOWSNEAK]
  pbBoss.add(
    [:Start],
    [:Message,"Survive for 10 turns until Giratina calms down!"])
  for i in 1..8
    pbBoss.add(
      [:Timed,i],
      [:Message,_INTL("{1} turns remaining.",10-i)])
  end
  pbBoss.add(
    [:Timed,9],
    [:Message,"1 turn remaining."])
  pbBoss.add(
    [:Timed,10],
    [:Message,"Giratina calmed down!"],
    [:WinBattle])
end

# --- Dunsparce ---
def pbBossRuinNormal
  pbPokemonBossBGM
  # Start: Gets +2 Defense/Sp.Def
  # If hit by a Physical attack, +Defense/-Sp.Def
  # If hit by a Special attack, +Sp.Def/-Defense
  pbBoss.add(
    [:Start],
    [:Message,"NAME is preparing for your attacks."],
    [:StatChange,:DEFENSE,2],
    [:StatChange,:SPDEF,2])
  pbBoss.add(
    [:Category,0],
    [:Message,"NAME is getting ready for more Physical attacks."],
    [:StatChange,:DEFENSE,2],
    [:StatChange,:SPDEF,-2])
  pbBoss.add(
    [:Category,1],
    [:Message,"NAME is getting ready for more Special attacks."],
    [:StatChange,:SPDEF,2],
    [:StatChange,:DEFENSE,-2])
end

# --- Primeape ---
def pbBossRuinFighting
  pbPokemonBossBGM
  # Start: Gets +4 Attack/Speed
  # Each Turn: -1 Defense/Sp.Def
  # Goes back to +4 Attack/Speed when at -2 Attack/Speed
  pbBoss.add(
    [:Start],
    [:Message,"NAME is full of energy and charging ahead!"],
    [:StatChange,:ATTACK,4],
    [:StatChange,:SPEED,4])
  pbBoss.add(
    [:Interval,1],
    [:Message,"NAME is getting more tired."],
    [:StatChange,:ATTACK,-1],
    [:StatChange,:SPEED,-1])
  pbBoss.add(
    [:Interval,6],
    [:Message,"NAME got rested and is rearing to go!"],
    [:StatChange,:ATTACK,6],
    [:StatChange,:SPEED,6])
end

# --- Skarmory ---
def pbBossRuinSteel
  pbPokemonBossBGM
  # Start: Lays Stealth Rock and 3 spike layers
  # Each Turn: Uses Whirlwind
  pbBoss.add(
    [:Start],
    [:Message,"NAME laid rocks and spikes at your side of the field!"],
    [:GiveEffect,:StealthRock,true],
    [:GiveEffect,:Spikes,3],
    [:Message,"NAME readied itself to blow you away every turn."])
  pbBoss.add(
    [:Interval,1],
    [:UseMove,:WHIRLWIND])
end

# --- Spiritomb ---
def pbBossRuinGhost
  pbPokemonBossBGM
  # Each Turn: Uses Spite
  pbBoss.add(
    [:Start],
    [:Message,"NAME emits an aura that sends shivers down your spine."],
    [:Message,"Be mindful of your PP."])
  pbBoss.add(
    [:Interval,1],
    [:UseMove,:SPITE])
end

# --- Darmanitan ---
def pbBossRuinFire
  pbPokemonBossBGM
  # Start: Increases defenses and is in Zen forme
  # Each Turn: Has only Bulk Up
  # When at low HP, turns aggressive and changes moves
  pbBoss.add(
    [:Start],
    [:Message,"NAME is taking a defensive position."],
    [:StatChange,:DEFENSE,2],
    [:StatChange,:SPDEF,2])
  pbBoss.add(
    [:HP,33],
    [:Message,"The pinch made NAME aggressive!"],
    [:StatChange,:SPEED,1],
    [:StatChange,:DEFENSE,-2],
    [:StatChange,:SPDEF,-2],
    [:Message,"NAME gained the ability Sheer Force!"],
    [:Ability,:SHEERFORCE],
    [:Moves,:FIREPUNCH,:BRICKBREAK,:ROCKSLIDE,0],
    [:Custom,"boss.pokemon.abilityflag=0"],
    [:Remove])
end

# --- Chimecho ---
def pbBossSmokeyForest
  pbPokemonBossBGM
  # Start: Sets infinite Misty Terrain and gains Pixilate
  # Each Turn: Powers up Echoed Voice one turn
  pbBoss.add(
    [:Start],
    [:Terrain,:MistyTerrain,999],
    [:Message,"The forest is covered in mist."],
    [:Ability,:PIXILATE],
    [:Message,"What's this?"],
    [:Message,"The Chimecho has Pixilate!"])
  pbBoss.add(
    [:Interval,1],
    [:Message,"Chimecho's voice echoes through the forest."],
    [:AddField,:EchoedVoiceCounter,1])
  pbBoss.add(
    [:Timed,1],
    [:Message,"Echoed Voice grows in power."])
end













