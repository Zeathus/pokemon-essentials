# ----------------------------------------------------------------------
# Dialogue Box Settings
# ----------------------------------------------------------------------
SPEECH_DISPLAY_LEFT = ["Azelf", "Mesprit", "Uxie", "Giratina"]

def getCharColor(name, tint, bg=0)
  if bg==0 # Light Background
    if name == "Sign"
      return Color.new(32, 18, 7) if tint == 0
      return Color.new(150, 115, 74) if tint == 1
    elsif name == "Kira"
      return Color.new(56, 7, 7) if tint == 0
      return Color.new(158, 118, 118) if tint == 1
    elsif name == "Amethyst"
      return Color.new(101, 67, 135) if tint == 0
      return Color.new(204, 179, 229) if tint == 1
    elsif name == "Nekane"
      return Color.new(7, 8, 17) if tint == 0
      return Color.new(62, 72, 127) if tint == 1
    elsif name == "Duke" || name == "Joe?" || name == "Merrick"
      return Color.new(68, 114, 84) if tint == 0
      return Color.new(157, 204, 172) if tint == 1
      #return Color.new(120, 170, 140) if tint == 0
      #return Color.new(70, 100, 80) if tint == 1
    elsif name == "Mesprit"
      return Color.new(113, 60, 86) if tint == 0
      return Color.new(249, 204, 218) if tint == 1
    elsif name == "Azelf"
      return Color.new(54, 108, 135) if tint == 0
      return Color.new(183, 215, 247) if tint == 1
    elsif name == "Uxie"
      return Color.new(198, 129, 22) if tint == 0
      return Color.new(224, 222, 145) if tint == 1
    elsif name == "Giratina"
      return Color.new(235, 50, 0) if tint == 0
      return Color.new(114, 37, 11) if tint == 1
    elsif name == "Celebi"
      if $game_switches[SPEECH_COLOR_MOD]
        return Color.new(74, 114, 74) if tint == 0
        return Color.new(164, 222, 82) if tint == 1
      else
        return Color.new(90, 96, 80) if tint == 0
        return Color.new(182, 194, 168) if tint == 1
      end
    elsif name == "R-Celebi"
      if $game_switches[SPEECH_COLOR_MOD]
        return Color.new(92, 32, 172) if tint == 0
        return Color.new(180, 140, 222) if tint == 1
      else
        return Color.new(90, 82, 96) if tint == 0
        return Color.new(180, 168, 196) if tint == 1
      end
    elsif name == "Eliana"
      return Color.new(0, 0, 50) if tint == 0
      return Color.new(120, 120, 170) if tint == 1
    elsif name == "Fintan"
      return Color.new(170, 48, 48) if tint == 0
      return Color.new(255, 190, 190) if tint == 1
    else
      return Color.new(88, 88, 80) if tint == 0
      return Color.new(168, 184, 184) if tint == 1
    end
  else # Dark Background
    if name == "Sign"
      return Color.new(32, 18, 7) if tint == 0
      return Color.new(150, 115, 74) if tint == 1
    elsif name == "Kira"
      return Color.new(198, 74, 64) if tint == 0
      return Color.new(90, 42, 42) if tint == 1
    elsif name == "Amethyst"
      return Color.new(150, 98, 164) if tint == 0
      return Color.new(54, 36, 68) if tint == 1
    elsif name == "Nekane"
      return Color.new(7, 8, 17) if tint == 0
      return Color.new(62, 72, 127) if tint == 1
    elsif name == "Duke" || name == "Joe?" || name == "Merrick"
      return Color.new(120, 170, 140) if tint == 0
      return Color.new(70, 100, 80) if tint == 1
    elsif name == "Mesprit"
      return Color.new(113, 60, 86) if tint == 0
      return Color.new(249, 204, 218) if tint == 1
    elsif name == "Azelf"
      return Color.new(54, 108, 135) if tint == 0
      return Color.new(183, 215, 247) if tint == 1
    elsif name == "Uxie"
      return Color.new(198, 129, 22) if tint == 0
      return Color.new(224, 222, 145) if tint == 1
    elsif name == "Eliana"
      return Color.new(0, 0, 50) if tint == 0
      return Color.new(120, 120, 170) if tint == 1
    else
      return Color.new(248, 248, 248) if tint == 0
      return Color.new(72, 80, 88) if tint == 1
    end
  end
end

def getTextWindow(name)
  if name == "Sign"
    return "sign"
  elsif name == "Mesprit"
    return "telepathy_mesprit"
  elsif name == "Azelf"
    return "telepathy_azelf"
  elsif name == "Uxie"
    return "telepathy_uxie"
  elsif name == "Giratina"
    return "giratina"
  else
    return false
  end
end