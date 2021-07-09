def pbScaledItem(item, boost=0)
  item = getID(PBItems,item) if item.is_a?(Symbol)
  case item
  when :POTION
    level = pbPreferredLevel
    items = [
      :POTION,
      :SUPERPOTION,
      :HYPERPOTION,
      :MAXPOTION,
      :FULLRESTORE]
    index = 0
    if level >= 65
      index = 3
    elsif level >= 45
      index = 2
    elsif level >= 20
      index = 1
    else
      index = 0
    end
    index += boost
    index = items.length - 1 if index >= items.length
    index = 0 if index < 0
    return items[index]
  when :POKEBALL
    level = pbPreferredLevel
    items = [
      :POKEBALL,
      :GREATBALL,
      :ULTRABALL]
    index = 0
    if level >= 40
      index = 2
    elsif level >= 25
      index = 1
    else
      index = 0
    end
    index += boost
    index = items.length - 1 if index >= items.length
    index = 0 if index < 0
    return items[index]
  end
end