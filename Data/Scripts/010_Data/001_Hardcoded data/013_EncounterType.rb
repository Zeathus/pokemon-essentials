module GameData
  class EncounterType
    attr_reader :id
    attr_reader :real_name
    attr_reader :type   # :land, :cave, :water, :fishing, :contest, :none
    attr_reader :trigger_chance

    DATA = {}

    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end

    def initialize(hash)
      @id             = hash[:id]
      @real_name      = hash[:id].to_s        || "Unnamed"
      @type           = hash[:type]           || :none
      @trigger_chance = hash[:trigger_chance] || 0
    end
  end
end

#===============================================================================

GameData::EncounterType.register({
  :id             => :Land,
  :type           => :land,
<<<<<<< HEAD
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 21
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :LandDay,
  :type           => :land,
<<<<<<< HEAD
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 21
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :LandNight,
  :type           => :land,
<<<<<<< HEAD
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 21
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :LandMorning,
  :type           => :land,
<<<<<<< HEAD
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 21
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :LandAfternoon,
  :type           => :land,
<<<<<<< HEAD
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 21
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :LandEvening,
  :type           => :land,
<<<<<<< HEAD
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 21
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :Cave,
  :type           => :cave,
<<<<<<< HEAD
  :trigger_chance => 5,
  :old_slots      => [20, 20, 20, 10, 10, 10, 5, 5]
=======
  :trigger_chance => 5
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :CaveDay,
  :type           => :cave,
<<<<<<< HEAD
  :trigger_chance => 5,
  :old_slots      => [20, 20, 20, 10, 10, 10, 5, 5]
=======
  :trigger_chance => 5
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :CaveNight,
  :type           => :cave,
<<<<<<< HEAD
  :trigger_chance => 5,
  :old_slots      => [20, 20, 20, 10, 10, 10, 5, 5]
=======
  :trigger_chance => 5
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :CaveMorning,
  :type           => :cave,
<<<<<<< HEAD
  :trigger_chance => 5,
  :old_slots      => [20, 20, 20, 10, 10, 10, 5, 5]
=======
  :trigger_chance => 5
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :CaveAfternoon,
  :type           => :cave,
<<<<<<< HEAD
  :trigger_chance => 5,
  :old_slots      => [20, 20, 20, 10, 10, 10, 5, 5]
=======
  :trigger_chance => 5
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :CaveEvening,
  :type           => :cave,
<<<<<<< HEAD
  :trigger_chance => 5,
  :old_slots      => [20, 20, 20, 10, 10, 10, 5, 5]
=======
  :trigger_chance => 5
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :Water,
  :type           => :water,
<<<<<<< HEAD
  :trigger_chance => 2,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 2
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :WaterDay,
  :type           => :water,
<<<<<<< HEAD
  :trigger_chance => 2,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 2
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :WaterNight,
  :type           => :water,
<<<<<<< HEAD
  :trigger_chance => 2,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 2
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :WaterMorning,
  :type           => :water,
<<<<<<< HEAD
  :trigger_chance => 2,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 2
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :WaterAfternoon,
  :type           => :water,
<<<<<<< HEAD
  :trigger_chance => 2,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
=======
  :trigger_chance => 2
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :WaterEvening,
  :type           => :water,
<<<<<<< HEAD
  :trigger_chance => 2,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
})

GameData::EncounterType.register({
  :id             => :FishingRod,
  :type           => :fishing,
  :old_slots      => [40, 30, 15, 10, 5]
=======
  :trigger_chance => 2
})

GameData::EncounterType.register({
  :id             => :OldRod,
  :type           => :fishing
})

GameData::EncounterType.register({
  :id             => :GoodRod,
  :type           => :fishing
})

GameData::EncounterType.register({
  :id             => :SuperRod,
  :type           => :fishing
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :RockSmash,
  :type           => :none,
<<<<<<< HEAD
  :trigger_chance => 50,
  :old_slots      => [60, 30, 10]
=======
  :trigger_chance => 50
>>>>>>> 479aeacc2c9dddad1b701c1a92a2a1f915e34388
})

GameData::EncounterType.register({
  :id             => :HeadbuttLow,
  :type           => :none
})

GameData::EncounterType.register({
  :id             => :HeadbuttHigh,
  :type           => :none
})

GameData::EncounterType.register({
  :id             => :BugContest,
  :type           => :contest,
  :trigger_chance => 21
})

GameData::EncounterType.register({
  :id             => :Land2,
  :type           => :land2,
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
})

GameData::EncounterType.register({
  :id             => :Land3,
  :type           => :land3,
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
})

GameData::EncounterType.register({
  :id             => :Land4,
  :type           => :land4,
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
})

GameData::EncounterType.register({
  :id             => :Flowers,
  :type           => :flower,
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
})

GameData::EncounterType.register({
  :id             => :Swamp,
  :type           => :swamp,
  :trigger_chance => 21,
  :old_slots      => [30, 20, 20, 10, 10, 5, 5]
})
