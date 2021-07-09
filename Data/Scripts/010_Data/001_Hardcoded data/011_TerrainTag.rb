module GameData
  class TerrainTag
    attr_reader :id
    attr_reader :id_number
    attr_reader :real_name
    attr_reader :can_surf
    attr_reader :waterfall   # The main part only, not the crest
    attr_reader :waterfall_crest
    attr_reader :can_fish
    attr_reader :can_dive
    attr_reader :deep_bush
    attr_reader :shows_grass_rustle
    attr_reader :shows_dust_particle
    attr_reader :land_wild_encounters
    attr_reader :land2_wild_encounters
    attr_reader :land3_wild_encounters
    attr_reader :land4_wild_encounters
    attr_reader :swamp_wild_encounters
    attr_reader :flower_wild_encounters
    attr_reader :double_wild_encounters
    attr_reader :battle_environment
    attr_reader :ledge
    attr_reader :ice
    attr_reader :bridge
    attr_reader :shows_reflections
    attr_reader :must_walk
    attr_reader :ignore_passability
    attr_reader :water_edge
    attr_reader :stair_right
    attr_reader :stair_left
    attr_reader :stair_up

    DATA = {}

    extend ClassMethods
    include InstanceMethods

    # @param other [Symbol, self, String, Integer]
    # @return [self]
    def self.try_get(other)
      return self.get(:None) if other.nil?
      validate other => [Symbol, self, String, Integer]
      return other if other.is_a?(self)
      other = other.to_sym if other.is_a?(String)
      return (self::DATA.has_key?(other)) ? self::DATA[other] : self.get(:None)
    end

    def self.load; end
    def self.save; end

    def initialize(hash)
      @id                     = hash[:id]
      @id_number              = hash[:id_number]
      @real_name              = hash[:id].to_s                || "Unnamed"
      @can_surf               = hash[:can_surf]               || false
      @waterfall              = hash[:waterfall]              || false
      @waterfall_crest        = hash[:waterfall_crest]        || false
      @can_fish               = hash[:can_fish]               || false
      @can_dive               = hash[:can_dive]               || false
      @deep_bush              = hash[:deep_bush]              || false
      @shows_grass_rustle     = hash[:shows_grass_rustle]     || false
      @shows_dust_particle    = hash[:shows_dust_particle]    || false
      @land_wild_encounters   = hash[:land_wild_encounters]   || false
      @land2_wild_encounters  = hash[:land2_wild_encounters]  || false
      @land3_wild_encounters  = hash[:land3_wild_encounters]  || false
      @land4_wild_encounters  = hash[:land4_wild_encounters]  || false
      @swamp_wild_encounters  = hash[:swamp_wild_encounters]  || false
      @flower_wild_encounters = hash[:flower_wild_encounters] || false
      @double_wild_encounters = hash[:double_wild_encounters] || false
      @battle_environment     = hash[:battle_environment]
      @ledge                  = hash[:ledge]                  || false
      @ice                    = hash[:ice]                    || false
      @bridge                 = hash[:bridge]                 || false
      @shows_reflections      = hash[:shows_reflections]      || false
      @must_walk              = hash[:must_walk]              || false
      @ignore_passability     = hash[:ignore_passability]     || false
      @water_edge             = hash[:water_edge]             || false
      @stair_right            = hash[:stair_right]            || false
      @stair_left             = hash[:stair_left]             || false
      @stair_up               = hash[:stair_up]               || false
    end

    def can_surf_freely
      return @can_surf && !@waterfall && !@waterfall_crest
    end
  end
end

#===============================================================================

GameData::TerrainTag.register({
  :id                     => :None,
  :id_number              => 0
})

GameData::TerrainTag.register({
  :id                     => :Ledge,
  :id_number              => 1,
  :ledge                  => true
})

GameData::TerrainTag.register({
  :id                     => :Grass,
  :id_number              => 2,
  :shows_grass_rustle     => true,
  :land_wild_encounters   => true,
  :battle_environment     => :Grass
})

GameData::TerrainTag.register({
  :id                     => :Sand,
  :id_number              => 3,
  :battle_environment     => :Sand
})

GameData::TerrainTag.register({
  :id                     => :Rock,
  :id_number              => 4,
  :battle_environment     => :Rock
})

GameData::TerrainTag.register({
  :id                     => :DeepWater,
  :id_number              => 5,
  :can_surf               => true,
  :can_fish               => true,
  :can_dive               => true,
  :battle_environment     => :MovingWater
})

GameData::TerrainTag.register({
  :id                     => :StillWater,
  :id_number              => 6,
  :can_surf               => true,
  :can_fish               => true,
  :battle_environment     => :StillWater,
  :shows_reflections      => true
})

GameData::TerrainTag.register({
  :id                     => :Water,
  :id_number              => 7,
  :can_surf               => true,
  :can_fish               => true,
  :battle_environment     => :MovingWater
})

GameData::TerrainTag.register({
  :id                     => :Waterfall,
  :id_number              => 8,
  :can_surf               => true,
  :waterfall              => true
})

GameData::TerrainTag.register({
  :id                     => :WaterfallCrest,
  :id_number              => 9,
  :can_surf               => true,
  :can_fish               => true,
  :waterfall_crest        => true
})

GameData::TerrainTag.register({
  :id                     => :TallGrass,
  :id_number              => 10,
  :deep_bush              => true,
  :land_wild_encounters   => true,
  :double_wild_encounters => true,
  :battle_environment     => :TallGrass,
  :must_walk              => true
})

GameData::TerrainTag.register({
  :id                     => :UnderwaterGrass,
  :id_number              => 11,
  :land_wild_encounters   => true
})

GameData::TerrainTag.register({
  :id                     => :Ice,
  :id_number              => 12,
  :battle_environment     => :Ice,
  :ice                    => true,
  :must_walk              => true
})

GameData::TerrainTag.register({
  :id                     => :Neutral,
  :id_number              => 13,
  :ignore_passability     => true
})

# NOTE: This is referenced by ID in an Events.onStepTakenFieldMovement proc that
#       adds soot to the Soot Sack if the player walks over one of these tiles.
GameData::TerrainTag.register({
  :id                     => :SootGrass,
  :id_number              => 14,
  :shows_grass_rustle     => true,
  :land_wild_encounters   => true,
  :battle_environment     => :Grass
})

GameData::TerrainTag.register({
  :id                     => :Bridge,
  :id_number              => 15,
  :bridge                 => true
})

GameData::TerrainTag.register({
  :id                     => :Puddle,
  :id_number              => 16,
  :battle_environment     => :Puddle,
  :shows_reflections      => true
})

GameData::TerrainTag.register({
  :id                     => :StairsRight,
  :id_number              => 17,
  :stair_right            => true
})

GameData::TerrainTag.register({
  :id                     => :StairsLeft,
  :id_number              => 18,
  :stair_left             => true
})

GameData::TerrainTag.register({
  :id                     => :StairsUp,
  :id_number              => 19,
  :stair_up               => true
})

GameData::TerrainTag.register({
  :id                     => :Swamp,
  :id_number              => 20,
  :battle_environment     => :Puddle,
  :swamp_wild_encounters  => true
})

GameData::TerrainTag.register({
  :id                     => :Flowers,
  :id_number              => 21,
  :shows_grass_rustle     => true,
  :battle_environment     => :Grass,
  :flower_wild_encounters => true
})

GameData::TerrainTag.register({
  :id                     => :Rocky,
  :id_number              => 22,
  :shows_dust_particle    => true,
  :battle_environment     => :Rock,
  :land_wild_encounters   => true
})

GameData::TerrainTag.register({
  :id                     => :WaterEdge,
  :id_number              => 23,
  :can_surf               => true,
  :water_edge             => true
})

GameData::TerrainTag.register({
  :id                     => :Grass2,
  :id_number              => 24,
  :shows_grass_rustle     => true,
  :battle_environment     => :Grass,
  :land2_wild_encounters  => true
})

GameData::TerrainTag.register({
  :id                     => :Grass3,
  :id_number              => 25,
  :shows_grass_rustle     => true,
  :battle_environment     => :Grass,
  :land3_wild_encounters  => true
})

GameData::TerrainTag.register({
  :id                     => :Grass4,
  :id_number              => 26,
  :shows_grass_rustle     => true,
  :battle_environment     => :Grass,
  :land4_wild_encounters  => true
})

