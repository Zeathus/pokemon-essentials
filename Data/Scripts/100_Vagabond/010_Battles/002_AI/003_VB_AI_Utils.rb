class PokeBattle_Battle
    
  def eachMoveIndexCombo(idxBattlers)
    return if idxBattlers.length == 0
    b0 = idxBattlers[0]
    @battlers[b0].eachMoveWithIndex do |m0,i0|
      if idxBattlers.length == 1
        yield i0, nil, nil
      else
        b1 = idxBattlers[1]
        @battlers[b1].eachMoveWithIndex do |m1,i1|
          if idxBattlers.length == 2
            yield i0, i1, nil
          else
            b2 = idxBattlers[2]
            @battlers[b2].eachMoveWithIndex do |m2,i2|
              yield i0, i1, i2
            end
          end
        end
      end
    end
  end

  def pbRoughPriority(user, move)
    pri = move.priority
    if user.abilityActive?
      pri = BattleHandlers.triggerPriorityChangeAbility(user.ability,user,move,pri)
    end
    return pri
  end

  def pbPossibleTargets(user, move)
    # The user is a catch-all target used to only calculate effect scores once, instead of once for all battlers affected by the move
    ret = []
    if [:None, :User, :UserOrNearAlly, :UserAndAllies, :AllBattlers, :AllBattlers, :UserSide, :FoeSide, :BothSides].include?(move.target)
      ret.push([user])
    end
    if [:NearAlly, :UserOrNearAlly, :NearOther].include?(move.target)
      user.eachAlly do |b|
        ret.push([b]) if b.near?(user)
      end
    end
    if [:NearFoe, :RandomNearFoe, :NearOther].include?(move.target)
      user.eachOpposing do |b|
        ret.push([b]) if b.near?(user)
      end
    end
    if [:Other].include?(move.target)
      user.eachOpposing do |b|
        ret.push([b])
      end
    end
    if [:AllNearFoes].include?(move.target)
      t = []
      user.eachOpposing do |b|
        t.push(b) if b.near?(user)
      end
      ret.push(t)
    end
    if [:AllNearOthers].include?(move.target)
      t = []
      eachBattler do |b|
        t.push(b) if b != user
      end
      ret.push(t)
    end
    # Check for redirection within each possible target
    if [:NearOther, :NearFoe, :RandomNearFoe, :NearOther, :Other].include?(move.target)
      for group in ret
        b = group[0]
        if (move.type == :WATER && b.hasActiveAbility?(:STORMDRAIN)) ||
           move.type == :ELECTRIC && b.hasActiveAbility?(:LIGHTNINGROD)
          return [group]
        end
      end
    end
    return ret
  end

  def pbShowScores(scores, idxBattlers)
    
    if idxBattlers.length > 2
      pbDisplay("Showing scores only work for up to 2 opponents.")
      return
    end

    viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    viewport.z = 999999
    viewport.ox = 0
    viewport.oy = 0
    
    bg = Sprite.new(viewport)
    bg.bitmap = Bitmap.new(512,384)
    bg.bitmap.fill_rect(0,0,512,384,Color.new(0,0,0))
    bg.opacity = 150
    bg.x = 128
    bg.y = 96
    
    text = Sprite.new(viewport)
    text.bitmap = Bitmap.new(512,384)
    pbSetSmallestFont(text.bitmap)
    text.x = 128
    text.y = 96
    
    base = Color.new(252,252,252)
    shadow = Color.new(0,0,0)
    
    textpos = []
    
    if idxBattlers.length == 1
      user = @battlers[idxBattlers[0]]
      user.eachMoveWithIndex do |m, i|
        textpos.push([m.name,110 + 100 * i,80,0,base,shadow,1])
        textpos.push([sprintf("%.2f",scores[i]),110 + 100 * i,120,0,base,shadow,1])
      end
    elsif idxBattlers.length == 2
      user1 = @battlers[idxBattlers[0]]
      user2 = @battlers[idxBattlers[1]]
      user1.eachMoveWithIndex do |m, i|
        textpos.push([user1.moves[i].name,110 + 100 * i,80,0,base,shadow,1])
      end
      user2.eachMoveWithIndex do |m, j|
        textpos.push([user2.moves[j].name,10,120 + j * 40,0,base,shadow,1])
      end
      user1.eachMoveWithIndex do |m1, i|
        user2.eachMoveWithIndex do |m2, j|
          textpos.push([sprintf("%.2f",scores[i][j]),110 + 100 * i,120 + j * 40,0,base,shadow,1])
        end
      end
    else
      pbDisplay("Showing scores only work for up to 2 opponents.")
    end
    
    if textpos.length > 0
      pbDrawTextPositions(text.bitmap,textpos)
      
      8.times do
        bg.update
        text.update
        viewport.update
        Graphics.update
        Input.update
      end
      
      while !Input.trigger?(Input::C)
        bg.update
        text.update
        viewport.update
        Graphics.update
        Input.update
      end
    end
    
    bg.dispose
    text.dispose
    viewport.dispose
    
  end

  def pbPrintQueue(queue)

    str = "Queue:"
    for i in queue
      str += " "
      str += @battlers[i].name
    end
    pbMessage(str)

  end

end

class PokeBattle_Move

    def pbPredictDamage(user, target, numTargets, queue, boost, options = 0)
      calcType = pbCalcType(user)
      target.damageState.typeMod = pbCalcTypeMod(calcType, user, target)
      if (pbImmunityByAbility(user, target)) ||
         (Effectiveness.ineffective?(target.damageState.typeMod)) ||
         (calcType == :GROUND && target.airborne? && !hitsFlyingTargets?)
        target.damageState.reset
        return 0
      end
      dmg = pbCalcDamage(user, target, numTargets)
      if boost
        dmg *= 1.3
      end
      @battle.eachBattler do |b|
        b.damageState.reset
      end
      return dmg
    end
  
  end