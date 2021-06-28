ItemHandlers::UseOnPokemon.add(:HABILITYCAPSULE,proc{|item,pokemon,scene|
   abils=pokemon.getAbilityList
   abil1=0
   for i in abils
     abil1=i[0] if i[1]==2
   end
   if pokemon.hasHiddenAbility?#abil1<=0 || abil2<=0 || 
     scene.pbDisplay(_INTL("It already has it's hidden ability."))
     next false
   end
   if abil1==0 || abil1==""#abil1<=0 || abil2<=0 || 
     scene.pbDisplay(_INTL("It  won't have any effect."))
     next false
   end
   newabil=(pokemon.abilityIndex+1)%2
   newabilname=PBAbilities.getName(abil1)#(newabil==0) ? abil1 : abil2)
   if scene.pbConfirm(_INTL("Would you like to change {1}'s Ability to {2}?",
      pokemon.name,newabilname))
     pokemon.setAbility(2)
     scene.pbRefresh
     scene.pbDisplay(_INTL("{1}'s Ability changed to {2}!",pokemon.name,
        PBAbilities.getName(pokemon.ability)))
     next true
   end
   next false
})

ItemHandlers::UseOnPokemon.add(:HELIODORGEMSTONE,proc{|item,pokemon,scene|
    Kernel.pbMessage(_INTL("{1} wants to strengthen its Attack.",pokemon.name))
    Kernel.pbMessage(_INTL("Which trait should be weakened in return?\\wt[4]{1}",
      "\\ch[1,6,Attack,Defense,Sp. Atk,Sp. Def,Speed,Cancel]"))
    case $game_variables[1]
    when 0
      pokemon.natureflag=PBNatures::HARDY
    when 1
      pokemon.natureflag=PBNatures::LONELY
    when 2
      pokemon.natureflag=PBNatures::ADAMANT
    when 3
      pokemon.natureflag=PBNatures::NAUGHTY
    when 4
      pokemon.natureflag=PBNatures::BRAVE
    when 5
      next false
    end
    scene.pbDisplay(_INTL("{1} nature was changed to {2}.",pokemon.name,PBNatures.getName(pokemon.natureflag)))
    scene.pbRefresh
    next true
})

ItemHandlers::UseOnPokemon.add(:HOWLITEGEMSTONE,proc{|item,pokemon,scene|
    Kernel.pbMessage(_INTL("{1} wants to harden its Defense.",pokemon.name))
    Kernel.pbMessage(_INTL("Which trait should be weakened in return?\\wt[4]{1}",
      "\\ch[1,6,Attack,Defense,Sp. Atk,Sp. Def,Speed,Cancel]"))
    case $game_variables[1]
    when 0
      pokemon.natureflag=PBNatures::BOLD
    when 1
      pokemon.natureflag=PBNatures::DOCILE
    when 2
      pokemon.natureflag=PBNatures::IMPISH
    when 3
      pokemon.natureflag=PBNatures::LAX
    when 4
      pokemon.natureflag=PBNatures::RELAXED
    when 5
      next false
    end
    scene.pbDisplay(_INTL("{1} nature was changed to {2}.",pokemon.name,PBNatures.getName(pokemon.natureflag)))
    scene.pbRefresh
    next true
})

ItemHandlers::UseOnPokemon.add(:AMETRINEGEMSTONE,proc{|item,pokemon,scene|
    Kernel.pbMessage(_INTL("{1} wants to empower its Special Attack.",pokemon.name))
    Kernel.pbMessage(_INTL("Which trait should be weakened in return?\\wt[4]{1}",
      "\\ch[1,6,Attack,Defense,Sp. Atk,Sp. Def,Speed,Cancel]"))
    case $game_variables[1]
    when 0
      pokemon.natureflag=PBNatures::MODEST
    when 1
      pokemon.natureflag=PBNatures::MILD
    when 2
      pokemon.natureflag=PBNatures::BASHFUL
    when 3
      pokemon.natureflag=PBNatures::RASH
    when 4
      pokemon.natureflag=PBNatures::QUIET
    when 5
      next false
    end
    scene.pbDisplay(_INTL("{1} nature was changed to {2}.",pokemon.name,PBNatures.getName(pokemon.natureflag)))
    scene.pbRefresh
    next true
})

ItemHandlers::UseOnPokemon.add(:AEGIRINEGEMSTONE,proc{|item,pokemon,scene|
    Kernel.pbMessage(_INTL("{1} wants to optimize its Special Defense.",pokemon.name))
    Kernel.pbMessage(_INTL("Which trait should be weakened in return?\\wt[4]{1}",
      "\\ch[1,6,Attack,Defense,Sp. Atk,Sp. Def,Speed,Cancel]"))
    case $game_variables[1]
    when 0
      pokemon.natureflag=PBNatures::CALM
    when 1
      pokemon.natureflag=PBNatures::GENTLE
    when 2
      pokemon.natureflag=PBNatures::CAREFUL
    when 3
      pokemon.natureflag=PBNatures::QUIRKY
    when 4
      pokemon.natureflag=PBNatures::SASSY
    when 5
      next false
    end
    scene.pbDisplay(_INTL("{1} nature was changed to {2}.",pokemon.name,PBNatures.getName(pokemon.natureflag)))
    scene.pbRefresh
    next true
})

ItemHandlers::UseOnPokemon.add(:PHENACITEGEMSTONE,proc{|item,pokemon,scene|
    Kernel.pbMessage(_INTL("{1} wants to increase its Speed.",pokemon.name))
    Kernel.pbMessage(_INTL("Which trait should be weakened in return?\\wt[4]{1}",
      "\\ch[1,6,Attack,Defense,Sp. Atk,Sp. Def,Speed,Cancel]"))
    case $game_variables[1]
    when 0
      pokemon.natureflag=PBNatures::TIMID
    when 1
      pokemon.natureflag=PBNatures::HASTY
    when 2
      pokemon.natureflag=PBNatures::JOLLY
    when 3
      pokemon.natureflag=PBNatures::NAIVE
    when 4
      pokemon.natureflag=PBNatures::SERIOUS
    when 5
      next false
    end
    scene.pbDisplay(_INTL("{1} nature was changed to {2}.",pokemon.name,PBNatures.getName(pokemon.natureflag)))
    scene.pbRefresh
    next true
})