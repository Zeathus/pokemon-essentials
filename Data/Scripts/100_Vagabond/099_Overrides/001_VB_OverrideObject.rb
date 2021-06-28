class OverrideObject
  
  attr_accessor :tile_size
  
  def initialize
    self.tile_size = 32
  end
  
end

def override
  if $game_variables[OVERRIDE].is_a?(Integer)
    $game_variables[OVERRIDE] = OverrideObject.new
  end
  return $game_variables[OVERRIDE]
end