DebugMenuCommands.register("vagabond", {
    "parent"      => "main",
    "name"        => _INTL("Vagabond options..."),
    "description" => _INTL("Anything new added by Vagabond.")
  })

DebugMenuCommands.register("initstats", {
    "parent"      => "vagabond",
    "name"        => _INTL("Reset Statistics"),
    "description" => _INTL("Resets all player stats such as those on the trainer card."),
    "effect"      => proc {
        Kernel.pbMessage(_INTL("Reset all trainer stats"))
        $Trainer.playerstats = PlayerStats.new()
    }
  })

DebugMenuCommands.register("allnumber", {
    "parent"      => "vagabond",
    "name"        => _INTL("Get All Trainer Phones"),
    "description" => _INTL("Gets the phone numbers of all wandering trainers."),
    "effect"      => proc {
        for i in $game_variables[TRAINER_ARRAY]
          phonenum=[]
          phonenum.push(true)
          phonenum.push(i.id)
          phonenum.push(PBTrainers.getName(i.id) + " " + i.name)
          phonenum.push(i.name)
          phonenum.push(0)
          $PokemonGlobal.phoneNumbers.push(phonenum)
        end
        Kernel.pbMessage("All numbers added")
    }
  })

DebugMenuCommands.register("initmail", {
    "parent"      => "vagabond",
    "name"        => _INTL("Reset Mailbox"),
    "description" => _INTL("Empties your mailbox."),
    "effect"      => proc {
        Kernel.pbMessage(_INTL("Reset the Mail Box"))
        $Trainer.mailbox = nil
    }
  })

DebugMenuCommands.register("initquests", {
    "parent"      => "vagabond",
    "name"        => _INTL("Reset Quests"),
    "description" => _INTL("Sets all quests to their initial state."),
    "effect"      => proc {
        Kernel.pbMessage(_INTL("Side Quests re-initialized."))
        $game_variables[QUEST_ARRAY]=0
        pbInitQuests
        pbInitMainQuests
    }
  })

DebugMenuCommands.register("unlockquests", {
    "parent"      => "vagabond",
    "name"        => _INTL("Unlock All Side Quests"),
    "description" => _INTL("Sets all side quests as available."),
    "effect"      => proc {
        for quest in $game_variables[QUEST_ARRAY]
          pbUnlockQuest(quest.id)
        end
        Kernel.pbMessage(_INTL("Unlocked All Side Quests"))
    }
  })

DebugMenuCommands.register("inittrainers", {
    "parent"      => "vagabond",
    "name"        => _INTL("Reset Trainers"),
    "description" => _INTL("Resets all wandering trainers to their initial state."),
    "effect"      => proc {
        Kernel.pbMessage(_INTL("Trainers re-initialized."))
        pbInitTrainers
    }
  })

DebugMenuCommands.register("debugextra", {
    "parent"      => "vagabond",
    "name"        => _INTL("Debug++"),
    "description" => _INTL("Activates additional debug messages ingame."),
    "effect"      => proc {
        $game_switches[DEBUG_EXTRA] = !debug_extra?
        if debug_extra?
          Kernel.pbMessage(_INTL("Extra Debug Enabled"))
        else
          Kernel.pbMessage(_INTL("Extra Debug Disabled"))
        end
    }
  })

DebugMenuCommands.register("showcollisions", {
    "parent"      => "vagabond",
    "name"        => _INTL("Show Collisions"),
    "description" => _INTL("Toggle an overlay to view all collisions in the world."),
    "effect"      => proc {
        if $game_switches[SHOW_COLLISION]
          $game_switches[SHOW_COLLISION]=false
          pbHideCollision
        else
          $game_switches[SHOW_COLLISION]=true
          pbShowCollision
        end
    }
  })