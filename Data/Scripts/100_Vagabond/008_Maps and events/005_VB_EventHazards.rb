def pbLightningHit
  slots = [0, 1, 2, 3, 4, 5]
  check = false
  while !check
    slot = slots.shuffle
    if $Trainer.party.length >= slot[0] + 1
      if $Trainer.party[slot[0]].hp > 0
        maxhp = $Trainer.party[slot[0]].totalhp
        damage = maxhp / 2 + 10
        $Trainer.party[slot[0]].hp = $Trainer.party[slot[0]].hp - damage
        if $Trainer.party[slot[0]].status == 0
          $Trainer.party[slot[0]].status = 4
        end
        check = true
      end
    end
  end
end
