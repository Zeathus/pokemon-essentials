module Compiler
  module_function

  def add_PBS_header_to_file(file)
    file.write(0xEF.chr)
    file.write(0xBB.chr)
    file.write(0xBF.chr)
    file.write("\# " + _INTL("See the documentation on the wiki to learn how to edit this file.") + "\r\n")
  end

  def write_PBS_file_generic(game_data, path)
    write_pbs_file_message_start(path)
    schema = game_data.schema
    File.open(path, "wb") { |f|
      add_PBS_header_to_file(f)
      # Write each element in turn
      game_data.each do |element|
        f.write("\#-------------------------------\r\n")
        if schema["SectionName"]
          f.write("[")
          pbWriteCsvRecord(element.get_property_for_PBS("SectionName"), f, schema["SectionName"])
          f.write("]\r\n")
        else
          f.write("[#{element.id}]\r\n")
        end
        schema.each_key do |key|
          next if key == "SectionName"
          val = element.get_property_for_PBS(key)
          next if val.nil?
          if schema[key][1][0] == "^" && val.is_a?(Array)
            val.each do |sub_val|
              f.write(sprintf("%s = ", key))
              pbWriteCsvRecord(sub_val, f, schema[key])
              f.write("\r\n")
            end
          else
            f.write(sprintf("%s = ", key))
            pbWriteCsvRecord(val, f, schema[key])
            f.write("\r\n")
          end
        end
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save Town Map data to PBS file
  #=============================================================================
  def write_town_map(path = "PBS/town_map.txt")
    write_PBS_file_generic(GameData::TownMap, path)
  end

  #=============================================================================
  # Save map connections to PBS file
  #=============================================================================
  def normalize_connection(conn)
    ret = conn.clone
    if conn[1].negative? != conn[4].negative?   # Exactly one is negative
      ret[4] = -conn[1]
      ret[1] = -conn[4]
    end
    if conn[2].negative? != conn[5].negative?   # Exactly one is negative
      ret[5] = -conn[2]
      ret[2] = -conn[5]
    end
    return ret
  end

  def get_connection_text(map1, x1, y1, map2, x2, y2)
    dims1 = MapFactoryHelper.getMapDims(map1)
    dims2 = MapFactoryHelper.getMapDims(map2)
    if x1 == 0 && x2 == dims2[0]
      return sprintf("%d,West,%d,%d,East,%d", map1, y1, map2, y2)
    elsif y1 == 0 && y2 == dims2[1]
      return sprintf("%d,North,%d,%d,South,%d", map1, x1, map2, x2)
    elsif x1 == dims1[0] && x2 == 0
      return sprintf("%d,East,%d,%d,West,%d", map1, y1, map2, y2)
    elsif y1 == dims1[1] && y2 == 0
      return sprintf("%d,South,%d,%d,North,%d", map1, x1, map2, x2)
    end
    return sprintf("%d,%d,%d,%d,%d,%d", map1, x1, y1, map2, x2, y2)
  end

  def write_connections(path = "PBS/map_connections.txt")
    conndata = load_data("Data/map_connections.dat")
    return if !conndata
    write_pbs_file_message_start(path)
    mapinfos = pbLoadMapInfos
    File.open(path, "wb") { |f|
      add_PBS_header_to_file(f)
      f.write("\#-------------------------------\r\n")
      conndata.each do |conn|
        if mapinfos
          # Skip if map no longer exists
          next if !mapinfos[conn[0]] || !mapinfos[conn[3]]
          f.write(sprintf("# %s (%d) - %s (%d)\r\n",
                          (mapinfos[conn[0]]) ? mapinfos[conn[0]].name : "???", conn[0],
                          (mapinfos[conn[3]]) ? mapinfos[conn[3]].name : "???", conn[3]))
        end
        if conn[1].is_a?(String) || conn[4].is_a?(String)
          f.write(sprintf("%d,%s,%d,%d,%s,%d", conn[0], conn[1], conn[2],
                          conn[3], conn[4], conn[5]))
        else
          ret = normalize_connection(conn)
          f.write(get_connection_text(ret[0], ret[1], ret[2], ret[3], ret[4], ret[5]))
        end
        f.write("\r\n")
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save type data to PBS file
  #=============================================================================
  def write_types(path = "PBS/types.txt")
    write_PBS_file_generic(GameData::Type, path)
  end

  #=============================================================================
  # Save ability data to PBS file
  #=============================================================================
  def write_abilities(path = "PBS/abilities.txt")
    write_PBS_file_generic(GameData::Ability, path)
  end

  #=============================================================================
  # Save move data to PBS file
  #=============================================================================
  def write_moves(path = "PBS/moves.txt")
    write_PBS_file_generic(GameData::Move, path)
  end

  #=============================================================================
  # Save item data to PBS file
  #=============================================================================
  def write_items(path = "PBS/items.txt")
    write_PBS_file_generic(GameData::Item, path)
  end

  #=============================================================================
  # Save berry plant data to PBS file
  #=============================================================================
  def write_berry_plants(path = "PBS/berry_plants.txt")
    write_PBS_file_generic(GameData::BerryPlant, path)
  end

  #=============================================================================
  # Save Pokémon data to PBS file
  # NOTE: Doesn't use write_PBS_file_generic because it needs to ignore defined
  #       species with a form that isn't 0.
  #=============================================================================
  def write_pokemon(path = "PBS/pokemon.txt")
    write_pbs_file_message_start(path)
    schema = GameData::Species.schema
    File.open(path, "wb") { |f|
      add_PBS_header_to_file(f)
      # Write each element in turn
      GameData::Species.each_species do |element|
        f.write("\#-------------------------------\r\n")
        if schema["SectionName"]
          f.write("[")
          pbWriteCsvRecord(element.get_property_for_PBS("SectionName"), f, schema["SectionName"])
          f.write("]\r\n")
        else
          f.write("[#{element.id}]\r\n")
        end
        schema.each_key do |key|
          next if key == "SectionName"
          val = element.get_property_for_PBS(key)
          next if val.nil?
          if schema[key][1][0] == "^" && val.is_a?(Array)
            val.each do |sub_val|
              f.write(sprintf("%s = ", key))
              pbWriteCsvRecord(sub_val, f, schema[key])
              f.write("\r\n")
            end
          else
            f.write(sprintf("%s = ", key))
            pbWriteCsvRecord(val, f, schema[key])
            f.write("\r\n")
          end
        end
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save Pokémon forms data to PBS file
  # NOTE: Doesn't use write_PBS_file_generic because it needs to ignore defined
  #       species with a form of 0, and needs its own schema.
  #=============================================================================
  def write_pokemon_forms(path = "PBS/pokemon_forms.txt")
    write_pbs_file_message_start(path)
    schema = GameData::Species.schema(true)
    File.open(path, "wb") { |f|
      add_PBS_header_to_file(f)
      # Write each element in turn
      GameData::Species.each do |element|
        next if element.form == 0
        f.write("\#-------------------------------\r\n")
        if schema["SectionName"]
          f.write("[")
          pbWriteCsvRecord(element.get_property_for_PBS("SectionName", true), f, schema["SectionName"])
          f.write("]\r\n")
        else
          f.write("[#{element.id}]\r\n")
        end
        schema.each_key do |key|
          next if key == "SectionName"
          val = element.get_property_for_PBS(key, true)
          next if val.nil?
          if schema[key][1][0] == "^" && val.is_a?(Array)
            val.each do |sub_val|
              f.write(sprintf("%s = ", key))
              pbWriteCsvRecord(sub_val, f, schema[key])
              f.write("\r\n")
            end
          else
            f.write(sprintf("%s = ", key))
            pbWriteCsvRecord(val, f, schema[key])
            f.write("\r\n")
          end
        end
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Write species metrics
  # NOTE: Doesn't use write_PBS_file_generic because it needs to ignore defined
  #       metrics for forms of species where the metrics are the same as for the
  #       base species.
  #=============================================================================
  def write_pokemon_metrics(path = "PBS/pokemon_metrics.txt")
    write_pbs_file_message_start(path)
    schema = GameData::SpeciesMetrics.schema
    File.open(path, "wb") { |f|
      add_PBS_header_to_file(f)
      # Write each element in turn
      GameData::SpeciesMetrics.each do |element|
        if element.form > 0
          base_element = GameData::SpeciesMetrics.get(element.species)
          next if element.back_sprite == base_element.back_sprite &&
                  element.front_sprite == base_element.front_sprite &&
                  element.front_sprite_altitude == base_element.front_sprite_altitude &&
                  element.shadow_x == base_element.shadow_x &&
                  element.shadow_size == base_element.shadow_size
        end
        f.write("\#-------------------------------\r\n")
        if schema["SectionName"]
          f.write("[")
          pbWriteCsvRecord(element.get_property_for_PBS("SectionName"), f, schema["SectionName"])
          f.write("]\r\n")
        else
          f.write("[#{element.id}]\r\n")
        end
        schema.each_key do |key|
          next if key == "SectionName"
          val = element.get_property_for_PBS(key)
          next if val.nil?
          if schema[key][1][0] == "^" && val.is_a?(Array)
            val.each do |sub_val|
              f.write(sprintf("%s = ", key))
              pbWriteCsvRecord(sub_val, f, schema[key])
              f.write("\r\n")
            end
          else
            f.write(sprintf("%s = ", key))
            pbWriteCsvRecord(val, f, schema[key])
            f.write("\r\n")
          end
        end
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save Shadow Pokémon data to PBS file
  #=============================================================================
  def write_shadow_pokemon(path = "PBS/shadow_pokemon.txt")
    write_PBS_file_generic(GameData::ShadowPokemon, path)
  end

  #=============================================================================
  # Save Regional Dexes to PBS file
  #=============================================================================
  def write_regional_dexes(path = "PBS/regional_dexes.txt")
    write_pbs_file_message_start(path)
    dex_lists = pbLoadRegionalDexes
    File.open(path, "wb") { |f|
      add_PBS_header_to_file(f)
      # Write each Dex list in turn
      dex_lists.each_with_index do |list, index|
        f.write("\#-------------------------------\r\n")
        f.write("[#{index}]")
        comma = false
        current_family = nil
        list.each do |species|
          next if !species
          if current_family&.include?(species)
            f.write(",") if comma
          else
            current_family = GameData::Species.get(species).get_family_species
            comma = false
            f.write("\r\n")
          end
          f.write(species)
          comma = true
        end
        f.write("\r\n")
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save ability data to PBS file
  #=============================================================================
  def write_ribbons(path = "PBS/ribbons.txt")
    write_PBS_file_generic(GameData::Ribbon, path)
  end

  #=============================================================================
  # Save wild encounter data to PBS file
  #=============================================================================
  def write_encounters(path = "PBS/encounters.txt")
    write_pbs_file_message_start(path)
    map_infos = pbLoadMapInfos
    File.open(path, "wb") { |f|
      idx = 0
      add_PBS_header_to_file(f)
      GameData::Encounter.each do |encounter_data|
        echo "." if idx % 50 == 0
        idx += 1
        Graphics.update if idx % 250 == 0
        f.write("\#-------------------------------\r\n")
        map_name = (map_infos[encounter_data.map]) ? " # #{map_infos[encounter_data.map].name}" : ""
        if encounter_data.version > 0
          f.write(sprintf("[%03d,%d]%s\r\n", encounter_data.map, encounter_data.version, map_name))
        else
          f.write(sprintf("[%03d]%s\r\n", encounter_data.map, map_name))
        end
        encounter_data.types.each do |type, slots|
          next if !slots || slots.length == 0
          if encounter_data.step_chances[type] && encounter_data.step_chances[type] > 0
            f.write(sprintf("%s,%d\r\n", type.to_s, encounter_data.step_chances[type]))
          else
            f.write(sprintf("%s\r\n", type.to_s))
          end
          slots.each do |slot|
            if slot[2] == slot[3]
              f.write(sprintf("    %d,%s,%d\r\n", slot[0], slot[1], slot[2]))
            else
              f.write(sprintf("    %d,%s,%d,%d\r\n", slot[0], slot[1], slot[2], slot[3]))
            end
          end
        end
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save trainer type data to PBS file
  #=============================================================================
  def write_trainer_types(path = "PBS/trainer_types.txt")
    write_PBS_file_generic(GameData::TrainerType, path)
  end

  #=============================================================================
  # Save individual trainer data to PBS file
  #=============================================================================
  def write_trainers(path = "PBS/trainers.txt")
    write_pbs_file_message_start(path)
    File.open(path, "wb") { |f|
      idx = 0
      add_PBS_header_to_file(f)
      GameData::Trainer.each do |trainer|
        echo "." if idx % 50 == 0
        idx += 1
        Graphics.update if idx % 250 == 0
        f.write("\#-------------------------------\r\n")
        if trainer.version > 0
          f.write(sprintf("[%s,%s,%d]\r\n", trainer.trainer_type, trainer.real_name, trainer.version))
        else
          f.write(sprintf("[%s,%s]\r\n", trainer.trainer_type, trainer.real_name))
        end
        f.write(sprintf("Items = %s\r\n", trainer.items.join(","))) if trainer.items.length > 0
        if trainer.real_lose_text && !trainer.real_lose_text.empty?
          f.write(sprintf("LoseText = %s\r\n", trainer.real_lose_text))
        end
        trainer.pokemon.each do |pkmn|
          f.write(sprintf("Pokemon = %s,%d\r\n", pkmn[:species], pkmn[:level]))
          f.write(sprintf("    Name = %s\r\n", pkmn[:name])) if pkmn[:name] && !pkmn[:name].empty?
          f.write(sprintf("    Form = %d\r\n", pkmn[:form])) if pkmn[:form] && pkmn[:form] > 0
          f.write(sprintf("    Gender = %s\r\n", (pkmn[:gender] == 1) ? "female" : "male")) if pkmn[:gender]
          f.write("    Shiny = yes\r\n") if pkmn[:shininess] && !pkmn[:super_shininess]
          f.write("    SuperShiny = yes\r\n") if pkmn[:super_shininess]
          f.write("    Shadow = yes\r\n") if pkmn[:shadowness]
          f.write(sprintf("    Moves = %s\r\n", pkmn[:moves].join(","))) if pkmn[:moves] && pkmn[:moves].length > 0
          f.write(sprintf("    Ability = %s\r\n", pkmn[:ability])) if pkmn[:ability]
          f.write(sprintf("    AbilityIndex = %d\r\n", pkmn[:ability_index])) if pkmn[:ability_index]
          f.write(sprintf("    Item = %s\r\n", pkmn[:item])) if pkmn[:item]
          f.write(sprintf("    Nature = %s\r\n", pkmn[:nature])) if pkmn[:nature]
          ivs_array = []
          evs_array = []
          GameData::Stat.each_main do |s|
            next if s.pbs_order < 0
            ivs_array[s.pbs_order] = pkmn[:iv][s.id] if pkmn[:iv]
            evs_array[s.pbs_order] = pkmn[:ev][s.id] if pkmn[:ev]
          end
          f.write(sprintf("    IV = %s\r\n", ivs_array.join(","))) if pkmn[:iv]
          f.write(sprintf("    EV = %s\r\n", evs_array.join(","))) if pkmn[:ev]
          f.write(sprintf("    Happiness = %d\r\n", pkmn[:happiness])) if pkmn[:happiness]
          f.write(sprintf("    Ball = %s\r\n", pkmn[:poke_ball])) if pkmn[:poke_ball]
        end
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save trainer list data to PBS file
  #=============================================================================
  def write_trainer_lists(path = "PBS/battle_facility_lists.txt")
    trainerlists = load_data("Data/trainer_lists.dat") rescue nil
    return if !trainerlists
    write_pbs_file_message_start(path)
    File.open(path, "wb") { |f|
      add_PBS_header_to_file(f)
      trainerlists.each do |tr|
        echo "."
        f.write("\#-------------------------------\r\n")
        f.write(((tr[5]) ? "[DefaultTrainerList]" : "[TrainerList]") + "\r\n")
        f.write("Trainers = " + tr[3] + "\r\n")
        f.write("Pokemon = " + tr[4] + "\r\n")
        f.write("Challenges = " + tr[2].join(",") + "\r\n") if !tr[5]
        write_battle_tower_trainers(tr[0], "PBS/" + tr[3])
        write_battle_tower_pokemon(tr[1], "PBS/" + tr[4])
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save Battle Tower trainer data to PBS file
  #=============================================================================
  def write_battle_tower_trainers(bttrainers, filename)
    return if !bttrainers || !filename
    btTrainersRequiredTypes = {
      "Type"          => [0, "e", nil],   # Specifies a trainer
      "Name"          => [1, "s"],
      "BeginSpeech"   => [2, "s"],
      "EndSpeechWin"  => [3, "s"],
      "EndSpeechLose" => [4, "s"],
      "PokemonNos"    => [5, "*u"]
    }
    File.open(filename, "wb") { |f|
      add_PBS_header_to_file(f)
      bttrainers.length.times do |i|
        next if !bttrainers[i]
        f.write("\#-------------------------------\r\n")
        f.write(sprintf("[%03d]\r\n", i))
        btTrainersRequiredTypes.each_key do |key|
          schema = btTrainersRequiredTypes[key]
          record = bttrainers[i][schema[0]]
          next if record.nil?
          f.write(sprintf("%s = ", key))
          case key
          when "Type"
            f.write(record.to_s)
          when "PokemonNos"
            f.write(record.join(","))   # pbWriteCsvRecord somehow won't work here
          else
            pbWriteCsvRecord(record, f, schema)
          end
          f.write(sprintf("\r\n"))
        end
      end
    }
    Graphics.update
  end

  #=============================================================================
  # Save Battle Tower Pokémon data to PBS file
  #=============================================================================
  def write_battle_tower_pokemon(btpokemon, filename)
    return if !btpokemon || !filename
    species = {}
    moves   = {}
    items   = {}
    natures = {}
    evs = {
      :HP              => "HP",
      :ATTACK          => "ATK",
      :DEFENSE         => "DEF",
      :SPECIAL_ATTACK  => "SA",
      :SPECIAL_DEFENSE => "SD",
      :SPEED           => "SPD"
    }
    File.open(filename, "wb") { |f|
      add_PBS_header_to_file(f)
      f.write("\#-------------------------------\r\n")
      btpokemon.length.times do |i|
        Graphics.update if i % 500 == 0
        pkmn = btpokemon[i]
        c1 = (species[pkmn.species]) ? species[pkmn.species] : (species[pkmn.species] = GameData::Species.get(pkmn.species).species.to_s)
        c2 = nil
        if pkmn.item && GameData::Item.exists?(pkmn.item)
          c2 = (items[pkmn.item]) ? items[pkmn.item] : (items[pkmn.item] = GameData::Item.get(pkmn.item).id.to_s)
        end
        c3 = (natures[pkmn.nature]) ? natures[pkmn.nature] : (natures[pkmn.nature] = GameData::Nature.get(pkmn.nature).id.to_s)
        evlist = ""
        pkmn.ev.each_with_index do |stat, i|
          evlist += "," if i > 0
          evlist += evs[stat]
        end
        c4 = c5 = c6 = c7 = ""
        [pkmn.move1, pkmn.move2, pkmn.move3, pkmn.move4].each_with_index do |move, i|
          next if !move
          text = (moves[move]) ? moves[move] : (moves[move] = GameData::Move.get(move).id.to_s)
          case i
          when 0 then c4 = text
          when 1 then c5 = text
          when 2 then c6 = text
          when 3 then c7 = text
          end
        end
        f.write("#{c1};#{c2};#{c3};#{evlist};#{c4},#{c5},#{c6},#{c7}\r\n")
      end
    }
    Graphics.update
  end

  #=============================================================================
  # Save metadata data to PBS file
  # NOTE: Doesn't use write_PBS_file_generic because it contains data for two
  #       different GameData classes.
  #=============================================================================
  def write_metadata(path = "PBS/metadata.txt")
    write_pbs_file_message_start(path)
    global_schema = GameData::Metadata.schema
    player_schema = GameData::PlayerMetadata.schema
    File.open(path, "wb") { |f|
      add_PBS_header_to_file(f)
      # Write each element in turn
      [GameData::Metadata, GameData::PlayerMetadata].each do |game_data|
        schema = global_schema if game_data == GameData::Metadata
        schema = player_schema if game_data == GameData::PlayerMetadata
        game_data.each do |element|
          f.write("\#-------------------------------\r\n")
          if schema["SectionName"]
            f.write("[")
            pbWriteCsvRecord(element.get_property_for_PBS("SectionName"), f, schema["SectionName"])
            f.write("]\r\n")
          else
            f.write("[#{element.id}]\r\n")
          end
          schema.each_key do |key|
            next if key == "SectionName"
            val = element.get_property_for_PBS(key)
            next if val.nil?
            if schema[key][1][0] == "^" && val.is_a?(Array)
              val.each do |sub_val|
                f.write(sprintf("%s = ", key))
                pbWriteCsvRecord(sub_val, f, schema[key])
                f.write("\r\n")
              end
            else
              f.write(sprintf("%s = ", key))
              pbWriteCsvRecord(val, f, schema[key])
              f.write("\r\n")
            end
          end
        end
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save map metadata data to PBS file
  # NOTE: Doesn't use write_PBS_file_generic because it writes the RMXP map name
  #       next to the section header for each map.
  #=============================================================================
  def write_map_metadata(path = "PBS/map_metadata.txt")
    write_pbs_file_message_start(path)
    map_infos = pbLoadMapInfos
    schema = GameData::MapMetadata.schema
    File.open(path, "wb") { |f|
      idx = 0
      add_PBS_header_to_file(f)
      GameData::MapMetadata.each do |element|
        echo "." if idx % 50 == 0
        idx += 1
        Graphics.update if idx % 250 == 0
        f.write("\#-------------------------------\r\n")
        map_name = (map_infos && map_infos[element.id]) ? map_infos[element.id].name : nil
        f.write(sprintf("[%03d]", element.id))
        f.write(sprintf("   # %s", map_name)) if map_name
        f.write("\r\n")
        schema.each_key do |key|
          next if key == "SectionName"
          val = element.get_property_for_PBS(key)
          next if val.nil?
          if schema[key][1][0] == "^" && val.is_a?(Array)
            val.each do |sub_val|
              f.write(sprintf("%s = ", key))
              pbWriteCsvRecord(sub_val, f, schema[key])
              f.write("\r\n")
            end
          else
            f.write(sprintf("%s = ", key))
            pbWriteCsvRecord(val, f, schema[key])
            f.write("\r\n")
          end
        end
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save dungeon tileset contents data to PBS file
  # NOTE: Doesn't use write_PBS_file_generic because it writes the tileset name
  #       next to the section header for each tileset.
  #=============================================================================
  def write_dungeon_tilesets(path = "PBS/dungeon_tilesets.txt")
    write_pbs_file_message_start(path)
    tilesets = load_data("Data/Tilesets.rxdata")
    schema = GameData::DungeonTileset.schema
    File.open(path, "wb") { |f|
      add_PBS_header_to_file(f)
      # Write each element in turn
      GameData::DungeonTileset.each do |element|
        f.write("\#-------------------------------\r\n")
        if schema["SectionName"]
          f.write("[")
          pbWriteCsvRecord(element.get_property_for_PBS("SectionName"), f, schema["SectionName"])
          f.write("]")
          f.write("   # #{tilesets[element.id].name}") if tilesets && tilesets[element.id]
          f.write("\r\n")
        else
          f.write("[#{element.id}]\r\n")
        end
        schema.each_key do |key|
          next if key == "SectionName"
          val = element.get_property_for_PBS(key)
          next if val.nil?
          if schema[key][1][0] == "^" && val.is_a?(Array)
            val.each do |sub_val|
              f.write(sprintf("%s = ", key))
              pbWriteCsvRecord(sub_val, f, schema[key])
              f.write("\r\n")
            end
          else
            f.write(sprintf("%s = ", key))
            pbWriteCsvRecord(val, f, schema[key])
            f.write("\r\n")
          end
        end
      end
    }
    process_pbs_file_message_end
  end

  #=============================================================================
  # Save dungeon parameters to PBS file
  #=============================================================================
  def write_dungeon_parameters(path = "PBS/dungeon_parameters.txt")
    write_PBS_file_generic(GameData::DungeonParameters, path)
  end

  #=============================================================================
  # Save phone messages to PBS file
  #=============================================================================
  def write_phone(path = "PBS/phone.txt")
    write_PBS_file_generic(GameData::PhoneMessage, path)
  end

  #=============================================================================
  # Save all data to PBS files
  #=============================================================================
  def write_all
    Console.echo_h1(_INTL("Writing all PBS files"))
    write_town_map
    write_connections
    write_types
    write_abilities
    write_moves
    write_items
    write_berry_plants
    write_pokemon
    write_pokemon_forms
    write_pokemon_metrics
    write_shadow_pokemon
    write_regional_dexes
    write_ribbons
    write_encounters
    write_trainer_types
    write_trainers
    write_trainer_lists
    write_metadata
    write_map_metadata
    write_dungeon_tilesets
    write_dungeon_parameters
    write_phone
    echoln ""
    Console.echo_h2(_INTL("Successfully rewrote all PBS files"), text: :green)
  end
end
