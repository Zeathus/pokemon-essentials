#===============================================================================
#
#===============================================================================
class Battle::Peer
  def pbStorePokemon(player,pkmn)
    if !player.party_full?
      player.party[player.party.length] = pkmn
      return -1
    elsif !$Trainer.inactive_full?
      while 1 != (x = pbMessage(_INTL("Would you like to add {1} to your inactive party?", pkmn.name), ["Yes", "No", "Help"]))
        if x == 0
          $Trainer.inactive_party[$Trainer.inactive_party.length] = pkmn
          return -2
        elsif x == 2
          pbMessage("In addition to your regular party, you have an inactive party.")
          pbMessage("Your inactive party cannot be used in battle, neither do they gain experience through battles.")
          pbMessage("However, these Pokémon can be delivered for quests or to meet similar requirements. Eggs can also hatch in the inactive party.")
        end
      end
    end
    if Settings::HEAL_STORED_POKEMON
      old_ready_evo = pkmn.ready_to_evolve
      pkmn.heal
      pkmn.ready_to_evolve = old_ready_evo
    end
    oldCurBox = pbCurrentBox
    storedBox = $PokemonStorage.pbStoreCaught(pkmn)
    if storedBox<0
      # NOTE: Poké Balls can't be used if storage is full, so you shouldn't ever
      #       see this message.
      pbDisplayPaused(_INTL("Can't catch any more..."))
      return oldCurBox
    end
    return storedBox
  end

  def pbGetStorageCreatorName
    return pbGetStorageCreator if $player.seen_storage_creator
    return nil
  end

  def pbCurrentBox
    return $PokemonStorage.currentBox
  end

  def pbBoxName(box)
    return (box<0) ? "" : $PokemonStorage[box].name
  end

  def pbOnEnteringBattle(battle, battler, pkmn, wild = false)
    f = MultipleForms.call("getFormOnEnteringBattle",pkmn,wild)
    pkmn.form = f if f
    battler.form = pkmn.form if battler.form != pkmn.form
    MultipleForms.call("changePokemonOnEnteringBattle", battler, pkmn, battle)
  end

  # For switching out, including due to fainting, and for the end of battle
  def pbOnLeavingBattle(battle,pkmn,usedInBattle,endBattle=false)
    return if !pkmn
    f = MultipleForms.call("getFormOnLeavingBattle",pkmn,battle,usedInBattle,endBattle)
    pkmn.form = f if f && pkmn.form!=f
    pkmn.hp = pkmn.totalhp if pkmn.hp>pkmn.totalhp
<<<<<<< HEAD:Data/Scripts/011_Battle/006_Other battle types/008_PokeBattle_BattlePeer.rb
    pkmn.hp = 1 if pkmn.hp < 1 if endBattle
=======
    MultipleForms.call("changePokemonOnLeavingBattle", pkmn, battle, usedInBattle, endBattle)
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388:Data/Scripts/011_Battle/006_Other battle code/004_Battle_Peers.rb
  end
end

#===============================================================================
# Unused class.
#===============================================================================
class Battle::NullPeer
  def pbOnEnteringBattle(battle, battler, pkmn, wild = false); end
  def pbOnLeavingBattle(battle,pkmn,usedInBattle,endBattle=false); end

  def pbStorePokemon(player,pkmn)
    player.party[player.party.length] = pkmn if !player.party_full?
    return -1
  end

  def pbGetStorageCreatorName; return nil; end
  def pbCurrentBox;            return -1;  end
  def pbBoxName(box);          return "";  end
end
