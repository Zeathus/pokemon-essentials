import java.io.*;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Locale;

class PokemonSystem {

    private ArrayList<Pokemon> pokedex;
    private ArrayList<Move> movelist;
    private ArrayList<Ability> abilityList;
    private ArrayList<Item> itemList;
    private ArrayList<TrainerType> trainerTypes;
    private ArrayList<Trainer> trainers;
    private HashMap<Move, TM> tms;
    private ArrayList<EncounterList> encounters;
    private ArrayList<String> files;
    private boolean echoes;

    private Comparator<Internal> compareID;
    private Comparator<Move> compareName;
    private Comparator<Trainer> compareTrainer;
    
    public PokemonSystem(boolean echoes, String pokemonFile, String moveFile,
            String abilityFile, String itemFile, String ttypeFile, String trainerFile,
            String tmFile, String encounterFile) {
        this.echoes = echoes;
        pokedex = new ArrayList<>();
        movelist = new ArrayList<>();
        abilityList = new ArrayList<>();
        itemList = new ArrayList<>();
        trainerTypes = new ArrayList<>();
        trainers = new ArrayList<>();
        tms = new HashMap<>();
        encounters = new ArrayList<>();

        files = new ArrayList<>();
        files.add(pokemonFile);
        files.add(moveFile);
        files.add(abilityFile);
        files.add(itemFile);
        files.add(ttypeFile);
        files.add(trainerFile);
        files.add(tmFile);
        files.add(encounterFile);

        backupFiles();
        System.out.println("Backed up PBS files.");

        File file = new File(moveFile);
        if (file.exists()) {
            loadMoveFile(file);
        }
        System.out.printf("Loaded %d Moves into the system.\n", movelist.size());

        file = new File(abilityFile);
        if (file.exists()) {
            loadAbilityFile(file);
        }
        System.out.printf("Loaded %d Abilities into the system.\n", abilityList.size());

        file = new File(itemFile);
        if (file.exists()) {
            loadItemFile(file);
        }
        System.out.printf("Loaded %d Items into the system.\n", itemList.size());

        file = new File(pokemonFile);
        if (file.exists()) {
            loadPokemonFile(file);
        }
        System.out.printf("Loaded %d Pokemon into the system.\n", pokedex.size());
        
        file = new File(tmFile);
        if (file.exists()) {
            loadTMFile(file);
        }
        System.out.printf("Loaded %d TMs into the system.\n", tms.size());

        file = new File(ttypeFile);
        if (file.exists()) {
            loadTrainerTypeFile(file);
        }
        System.out.printf("Loaded %d Trainer Types into the system.\n", trainerTypes.size());

        file = new File(trainerFile);
        if (file.exists()) {
            loadTrainerFile(file);
        }
        System.out.printf("Loaded %d Trainers into the system.\n", trainers.size());

        file = new File(encounterFile);
        if (file.exists()) {
            loadEncounterFile(file);
        }
        System.out.printf("Loaded %d Encounter Lists into the system.\n", encounters.size());

        compareID = new Comparator<Internal>() {
            @Override
            public int compare(Internal a, Internal b) {
                return (a.getID() - b.getID());
            }
        };
        
        compareName = new Comparator<Move>() {
            @Override
            public int compare(Move a, Move b) {
                return (a.getName().compareTo(b.getName()));
            }
        };

        Collections.sort(pokedex, compareID);
        Collections.sort(movelist, compareID);
        Collections.sort(abilityList, compareID);
        Collections.sort(itemList, compareID);
        Collections.sort(trainerTypes, compareID);

        compareTrainer = new Comparator<Trainer>() {
            @Override
            public int compare(Trainer a, Trainer b) {
                int typeCmp = a.getTrainerType().getInternalName().compareTo(
                    b.getTrainerType().getInternalName());
                if (typeCmp != 0) {
                    return typeCmp;
                }
                int nameCmp = a.getName().compareTo(b.getName());
                if (nameCmp != 0) {
                    return nameCmp;
                }
                return a.getVersion() - b.getVersion();
            }
        };

        Collections.sort(trainers, compareTrainer);

    }

    public void backupFiles() {
        File backupDir = new File("Backup/");
        if (!backupDir.exists()) {
            backupDir.mkdirs();
        }
        for (String file : files) {
            File source = new File(file);
            File dest = new File(file.replace("../","Backup/"));
            FileInputStream sourceStream = null;
            FileOutputStream destStream = null;
            FileChannel sourceChannel = null;
            FileChannel destChannel = null;
            try {
                sourceStream = new FileInputStream(source);
                destStream = new FileOutputStream(dest);
                sourceChannel = sourceStream.getChannel();
                destChannel = destStream.getChannel();
                destChannel.transferFrom(sourceChannel, 0, sourceChannel.size());
            } catch (Exception e) {
                System.out.printf("ERROR: Failed to backup %s\n", source.getName());
            } finally {
                try {
                    sourceChannel.close();
                    destChannel.close();
                    sourceStream.close();
                    destStream.close();
                } catch (IOException e) {
                    System.out.println("ERROR: Failed to close file stream");
                }
            }
        }
    }

    public void restoreBackup() {
        File backupDir = new File("Backup/");
        if (!backupDir.exists()) {
            backupDir.mkdirs();
        }
        for (String file : files) {
            File source = new File(file.replace("../","Backup/"));
            File dest = new File(file);
            FileInputStream sourceStream = null;
            FileOutputStream destStream = null;
            FileChannel sourceChannel = null;
            FileChannel destChannel = null;
            try {
                sourceStream = new FileInputStream(source);
                destStream = new FileOutputStream(dest);
                sourceChannel = sourceStream.getChannel();
                destChannel = destStream.getChannel();
                destChannel.transferFrom(sourceChannel, 0, sourceChannel.size());
            } catch (Exception e) {
                System.out.printf("ERROR: Failed to backup %s\n", source.getName());
            } finally {
                try {
                    sourceChannel.close();
                    destChannel.close();
                    sourceStream.close();
                    destStream.close();
                } catch (IOException e) {
                    System.out.println("ERROR: Failed to close file stream");
                }
            }
        }
    }

    public void sortTM(TM tm) {
        tm.getPokemon().sort(compareID);
    }

    public void addTM(TM tm) {
        tms.put(tm.getMove(), tm);
    }

    public TM getTM(Move move) {
        if (tms.containsKey(move)) {
            return tms.get(move);
        }
        return null;
    }

    public HashMap<Move, TM> getTMs() {
        return tms;
    }

    // Can be either name or internalName
    public Pokemon getPokemon(String name) {
        for (Pokemon p : pokedex) {
            if (p.getInternalName().equals(name.toUpperCase())) {
                return p;
            }
        }
        for (Pokemon p : pokedex) {
            if (p.getName().toLowerCase().equals(name.toLowerCase())) {
                return p;
            }
        }
        return null;
    }

    // Can be either name or internalName
    public Pokemon getPokemonInternal(String name) {
        for (Pokemon p : pokedex) {
            if (p.getInternalName().equals(name.toUpperCase())) {
                return p;
            }
        }
        return null;
    }

    // Can be either name or internalName
    public Move getMove(String name) {
        for (Move m : movelist) {
            if (m.getInternalName().equals(name.toUpperCase())) {
                return m;
            }
        }
        for (Move m : movelist) {
            if (m.getName().toLowerCase().equals(name.toLowerCase())) {
                return m;
            }
        }
        return null;
    }

    // Can be either name or internalName
    public Move getMoveInternal(String name) {
        for (Move m : movelist) {
            if (m.getInternalName().equals(name.toUpperCase())) {
                return m;
            }
        }
        return null;
    }

    // Can be either name or internalName
    public Ability getAbility(String name) {
        for (Ability a : abilityList) {
            if (a.getInternalName().equals(name.toUpperCase())) {
                return a;
            }
        }
        for (Ability a : abilityList) {
            if (a.getName().toLowerCase().equals(name.toLowerCase())) {
                return a;
            }
        }
        return null;
    }

    // Can be either name or internalName
    public Ability getAbilityInternal(String name) {
        for (Ability a : abilityList) {
            if (a.getInternalName().equals(name.toUpperCase())) {
                return a;
            }
        }
        return null;
    }

    // Can be either name or internalName
    public Item getItem(String name) {
        for (Item i : itemList) {
            if (i.getInternalName().equals(name.toUpperCase())) {
                return i;
            }
        }
        for (Item i : itemList) {
            if (i.getName().toLowerCase().equals(name.toLowerCase())) {
                return i;
            }
        }
        return null;
    }

    // Can be either name or internalName
    public Item getItemInternal(String name) {
        for (Item i : itemList) {
            if (i.getInternalName().equals(name.toUpperCase())) {
                return i;
            }
        }
        return null;
    }

    // Can be either name or internalName
    public ArrayList<Trainer> getTrainersByName(String name) {
        ArrayList<Trainer> results = new ArrayList<>();
        for (Trainer t : trainers) {
            if (t.getName().toLowerCase().equals(name.toLowerCase())) {
                results.add(t);
            }
        }
        return results;
    }

    // Can be either name or internalName
    public ArrayList<Trainer> getTrainersByType(String type) {
        ArrayList<Trainer> results = new ArrayList<>();
        for (Trainer t : trainers) {
            if (t.getTrainerType().getInternalName().toLowerCase().equals(type.toLowerCase())) {
                results.add(t);
            }
        }
        return results;
    }

    // Can be either name or internalName
    public ArrayList<Trainer> getTrainersByComment(String search) {
        ArrayList<Trainer> results = new ArrayList<>();
        for (Trainer t : trainers) {
            if (t.getComment().toLowerCase().contains(search.toLowerCase())) {
                results.add(t);
            }
        }
        return results;
    }

    // Can be either name or internalName
    public TrainerType getTrainerType(String name) {
        for (TrainerType t : trainerTypes) {
            if (t.getInternalName().toUpperCase().equals(name.toUpperCase())) {
                return t;
            }
        }
        return null;
    }

    // Can be either name or internalName
    public Trainer getTrainer(String name, int version) {
        
        return null;
    }

    public int getNextPokemonID() {
        int i = 1;
        Collections.sort(pokedex, compareID);
        for (Pokemon p : pokedex) {
            if (i == p.getID()) {
                i++;
            }
        }
        return i;
    }

    public int getNextMoveID() {
        int i = 1;
        Collections.sort(movelist, compareID);
        for (Move m : movelist) {
            if (i == m.getID()) {
                i++;
            }
        }
        return i;
    }

    public int getNextItemID() {
        int i = 1;
        Collections.sort(itemList, compareID);
        for (Item item : itemList) {
            if (i == item.getID()) {
                i++;
            }
        }
        return i;
    }

    public int getNextTrainerVersion(String name, TrainerType type) {
        int i = -1;
        for (Trainer t : trainers) {
            if (t.getTrainerType() == type) {
                if (t.getName().equals(name)) {
                    if (t.getVersion() > i) {
                        i = t.getVersion();
                    }
                }
            }
        }
        i++;
        return i;
    }

    public void addPokemon(Pokemon pokemon) {
        pokedex.add(pokemon);
    }

    public void addMove(Move move) {
        movelist.add(move);
    }

    public void addItem(Item item) {
        itemList.add(item);
    }

    public void addTrainer(Trainer trainer) {
        trainers.add(trainer);
    }

    public boolean deleteMove(Move move) {
        return movelist.remove(move);
    }

    public boolean deleteItem(Item item) {
        return itemList.remove(item);
    }

    public boolean deleteTrainer(Trainer trainer) {
        return trainers.remove(trainer);
    }

    public void printStats(Pokemon pokemon) {
        System.out.printf("#%03d %s\n-------------------\n", pokemon.getID(), pokemon.getName());
        System.out.printf("Type: %s\n", pokemon.hasType2() ?
            String.format("%s/%s", pokemon.getType1(), pokemon.getType2()) : pokemon.getType1());
        System.out.printf("Stats:\n- HP: %d\n- Attack: %d\n- Defense: %d\n- Speed: %d\n- Sp.Atk: %d\n- Sp.Def: %d\n",
            pokemon.getHP(), pokemon.getAttack(), pokemon.getDefense(), pokemon.getSpeed(), pokemon.getSpAtk(), pokemon.getSpDef());
        System.out.printf("Abilities: %s\n", pokemon.hasAbility2() ?
            String.format("%s/%s", pokemon.getAbility1(), pokemon.getAbility2()) : pokemon.getAbility1());
        System.out.printf("Hidden Ability: %s\n", pokemon.hasHiddenAbility() ? pokemon.getHiddenAbility() : "None");

        if (pokemon.getEvolutionData().size() > 0) {
            System.out.printf("Evolutions: \n");
            for (String[] s : pokemon.getEvolutionData()) {
                System.out.printf("- %s %s %s\n", s[0], s[1], s[2]);
            }
        } else {
            System.out.printf("Evolutions: None\n");
        }
    }

    public void printMoveset(Pokemon pokemon) {
        System.out.printf("#%03d %s\n-------------------\n", pokemon.getID(), pokemon.getName());

        ArrayList<Move> allMoves = new ArrayList<>();

        System.out.println("Level Up:");
        for (int i = 0; i <= 100; i++) {
            if (pokemon.getLevelMoves().containsKey(i)) {
                ArrayList<Move> moves = pokemon.getLevelMoves().get(i);
                for (Move m : moves) {
                    System.out.printf("- %d: %s\n", i, m);
                    allMoves.add(m);
                }
            }
        }

        System.out.println("\nEgg Moves");
        boolean added = false;
        for (Move m : pokemon.getFirstStage().getEggMoves()) {
            System.out.printf("- %s\n", m);
            allMoves.add(m);
            added = true;
        }
        if (!added) {
            System.out.println("- None");
        }

        ArrayList<Pokemon> preEvos = pokemon.getAllPreEvolutions();

        if (preEvos.size() > 0) {
            added = false;
            System.out.println("\nPre-Evolution: ");
            for (Pokemon p : preEvos) {
                for (int i = 0; i <= 100; i++) {
                    if (p.getLevelMoves().containsKey(i)) {
                        ArrayList<Move> moves = p.getLevelMoves().get(i);
                        for (Move m : moves) {
                            if (!allMoves.contains(m)) {
                                System.out.printf("- %s lvl %d: %s\n", p.getName(), i, m);
                                allMoves.add(m);
                                added = true;
                            }
                        }
                    }
                }
            }
            if (!added) {
                System.out.println("- None");
            }
        }

        System.out.println("\nTM Moves");

        ArrayList<Move> moves = new ArrayList<>();

        for (Move m : tms.keySet()) {
            if (tms.get(m).hasPokemon(pokemon)) {
                moves.add(m);
            }
        }

        if (moves.size() > 0) {
            moves.sort(compareName);
            int i = 1;
            for (Move m : moves) {
                if (i >= 3) {
                    System.out.printf(" %-16s\n", m.getName());
                    i = 0;
                } else {
                    System.out.printf(" %-16s ", m.getName());
                }
                i++;
            }
            if (i != 0) {
                System.out.println("");
            }
        } else {
            System.out.println("- None");
        }
    }

    public void printLevelMoves(Pokemon pokemon) {
        System.out.printf("#%03d %s\n-------------------\n", pokemon.getID(), pokemon.getName());

        System.out.println("Level Up:");
        for (int i = 0; i <= 100; i++) {
            if (pokemon.getLevelMoves().containsKey(i)) {
                ArrayList<Move> moves = pokemon.getLevelMoves().get(i);
                for (Move m : moves) {
                    System.out.printf("- %d: %s\n", i, m);
                }
            }
        }
    }

    public void printEchoLevelMoves(Pokemon pokemon) {
        System.out.printf("#%03d %s\n-------------------\n", pokemon.getID(), pokemon.getName());

        System.out.println("Level Up:");
        for (int i = 0; i <= 100; i++) {
            if (pokemon.getEchoMoves().containsKey(i)) {
                ArrayList<Move> moves = pokemon.getEchoMoves().get(i);
                for (Move m : moves) {
                    System.out.printf("- %d: %s\n", i, m);
                }
            }
        }
    }

    public void printEggMoves(Pokemon pokemon) {
        System.out.printf("#%03d %s\n-------------------\n", pokemon.getID(), pokemon.getName());

        System.out.println("\nEgg Moves");
        boolean added = false;
        for (Move m : pokemon.getFirstStage().getEggMoves()) {
            System.out.printf("- %s\n", m);
            added = true;
        }
        if (!added) {
            System.out.println("- None");
        }
    }

    public void printTMMoves(Pokemon pokemon) {
        System.out.printf("#%03d %s\n-------------------\n", pokemon.getID(), pokemon.getName());

        System.out.println("\nTM Moves");

        ArrayList<Move> moves = new ArrayList<>();

        for (Move m : tms.keySet()) {
            if (tms.get(m).hasPokemon(pokemon)) {
                moves.add(m);
            }
        }

        if (moves.size() > 0) {
            moves.sort(compareName);
            int i = 1;
            for (Move m : moves) {
                if (i >= 3) {
                    System.out.printf(" %-16s\n", m.getName());
                    i = 0;
                } else {
                    System.out.printf(" %-16s ", m.getName());
                }
                i++;
            }
            if (i != 0) {
                System.out.println("");
            }
        } else {
            System.out.println("- None");
        }
    }

    public void printInfo(Pokemon pokemon) {
        System.out.printf("#%03d %s\n-------------------\n", pokemon.getID(), pokemon.getName());
        System.out.printf("Internal Name: %s\n", pokemon.getInternalName());
        int[] ev = pokemon.getEffortPoints();
        System.out.printf("EVs:\n- HP: %d\n- Attack: %d\n- Defense: %d\n- Speed: %d\n- Sp.Atk: %d\n- Sp.Def: %d\n",
            ev[0], ev[1], ev[2], ev[3], ev[4], ev[5]);
        System.out.printf("Gender Ratio: %s\n", pokemon.getGenderRate());
        System.out.printf("Growth Rate: %s\n", pokemon.getGrowthRate());
        System.out.printf("Base EXP: %d\n", pokemon.getBaseExp());
        System.out.printf("Rareness: %d\n", pokemon.getRareness());
        System.out.printf("Base Happiness: %d\n", pokemon.getHappiness());
        System.out.printf("Egg Groups: %s\n", pokemon.hasEggGroup2() ?
            String.format("%s/%s", pokemon.getCompatibility()[0], pokemon.getCompatibility()[1]) : pokemon.getCompatibility()[0]);
        System.out.printf("Steps to Hatch: %d\n", pokemon.getStepsToHatch());
        if (pokemon.hasWildItemCommon()) {
            System.out.printf("Wild Item 50%%: %s\n", pokemon.getWildItemCommon());
        }
        if (pokemon.hasWildItemUncommon()) {
            System.out.printf("Wild Item 5%%: %s\n", pokemon.getWildItemUncommon());
        }
        if (pokemon.hasWildItemRare()) {
            System.out.printf("Wild Item 1%%: %s\n", pokemon.getWildItemRare());
        }
        System.out.printf("Height: %.01f\n", pokemon.getHeight());
        System.out.printf("Weight: %.01f\n", pokemon.getWeight());
        System.out.println("Pokedex:");
        System.out.printf("  %s Pokemon\n", pokemon.getKind());
        System.out.printf("  %s\n", pokemon.getDexEntry());
    }

    public ArrayList<Pokemon> getPokemonThatLearnMove(Move move) {
        ArrayList<Pokemon> pokemon = new ArrayList<>();
        for (Pokemon p : pokedex) {
            if (p.canLearnMove(move)) {
                pokemon.add(p);
            }
        }
        for (Pokemon p : pokemon) {
            ArrayList<Pokemon> evos = p.getEvolutions();
            for (Pokemon e : evos) {
                if (!pokemon.contains(e)) {
                    pokemon.add(e);
                }
            }
        }
        Collections.sort(pokemon, compareID);
        return pokemon;
    }

    public ArrayList<Pokemon> getPokemonThatLearnEggMove(Move move) {
        ArrayList<Pokemon> pokemon = new ArrayList<>();
        for (Pokemon p : pokedex) {
            if (p.getEggMoves().contains(move)) {
                pokemon.add(p);
            }
        }
        return pokemon;
    }

    public boolean moveInternalNameExists(String name) {
        for (Move m : movelist) {
            if (m.getInternalName().toUpperCase().equals(name)) {
                return true;
            }
        }
        return false;
    }

    public boolean pokemonInternalNameExists(String name) {
        for (Pokemon p : pokedex) {
            if (p.getInternalName().toUpperCase().equals(name)) {
                return true;
            }
        }
        return false;
    }

    public boolean itemInternalNameExists(String name) {
        for (Item i : itemList) {
            if (i.getInternalName().toUpperCase().equals(name)) {
                return true;
            }
        }
        return false;
    }

    private void loadPokemonFile(File file) {

        BufferedReader br;
        try {
            br = new BufferedReader(new FileReader(file));
        } catch (FileNotFoundException e) {
            System.out.println("ERROR: Failed to load pokemon source file.");
            return;
        }

        ArrayList<String> lines = new ArrayList<>();
        String line;
        try {
            while ((line = br.readLine()) != null) {
                lines.add(line);
            }
        } catch (IOException e) {
            System.out.println("ERROR: Failure when reading lines in file.");
            return;
        }

        LineReader scanner = new LineReader(lines);

        line = scanner.nextLine();
        
        while (scanner.hasNextLine()) {
            if (!line.contains("[")) {
                line = scanner.nextLine();
            }
            // New Pokemon
            if (line.contains("[")) {
                int id = -1;
                try {
                    id = Integer.parseInt(line.substring(line.indexOf("[") + 1, line.indexOf("]")));
                } catch (NumberFormatException e) {
                    System.out.println("ERROR: Failed to get Pokemon ID number.");
                }
                if (id >= 0) {
                    // Create a new Pokemon
                    Pokemon pokemon = new Pokemon(id, this);
                    while (scanner.hasNextLine()) {
                        line = scanner.nextLine();

                        // Stop if reached new Pokemon
                        if (line.length() <= 0) {
                            
                        } else if (line.charAt(0) == '[') {
                            break;
                        } else if (line.contains("=")) {
                            String field = line.substring(0, line.indexOf("="));
                            String value = line.substring(line.indexOf("=") + 1);
                            switch (field) {
                                case "Name": {
                                    pokemon.setName(value);
                                    break;
                                }
                                case "InternalName": {
                                    pokemon.setInternalName(value.toUpperCase());
                                    break;
                                }
                                case "Type1": {
                                    pokemon.setType1(value);
                                    break;
                                }
                                case "Type2": {
                                    pokemon.setType2(value);
                                    break;
                                }
                                case "Type3": {
                                    pokemon.setType3(value);
                                    break;
                                }
                                case "Type4": {
                                    pokemon.setType4(value);
                                }
                                case "BaseStats": {
                                    String[] statsString = value.split(",");
                                    if (statsString.length == 6) {
                                        int[] stats = new int[6];
                                        for (int i = 0; i < 6; i++) {
                                            stats[i] = Integer.parseInt(statsString[i]);
                                        }
                                        pokemon.setStats(stats);
                                    }
                                    break;
                                }
                                case "Abilities": {
                                    String[] abilities = value.split(",");
                                    Ability ability1 = getAbility(abilities[0].trim());
                                    if (ability1 == null) {
                                        System.out.printf("> %s - Couldn't find ability: %s\n", pokemon.getName(), abilities[0]);
                                    } else {
                                        pokemon.setAbility1(ability1);
                                    }
                                    if (abilities.length >= 2) {
                                        Ability ability2 = getAbility(abilities[1].trim());
                                        if (ability2 == null) {
                                            System.out.printf("> %s - Couldn't find ability: %s\n", pokemon.getName(), abilities[1]);
                                        } else {
                                            pokemon.setAbility2(ability2);
                                        }
                                    }
                                    break;
                                }
                                case "HiddenAbility": {
                                    if (value.length() > 1) {
                                        Ability ability = getAbility(value.trim());
                                        if (ability == null) {
                                            System.out.printf("> %s - Couldn't find ability: %s\n", pokemon.getName(), value);
                                        } else {
                                            pokemon.setHiddenAbility(ability);
                                        }
                                    }
                                    break;
                                }
                                case "EchoAbility": {
                                    if (value.length() > 1) {
                                        Ability ability = getAbility(value.trim());
                                        if (ability == null) {
                                            System.out.printf("> %s - Couldn't find ability: %s\n", pokemon.getName(), value);
                                        } else {
                                            pokemon.setEchoAbility(ability);
                                        }
                                    }
                                    break;
                                }
                                case "Moves": {
                                    String[] moveset = value.split(",");
                                    for (int i = 0; i < moveset.length / 2; i++) {
                                        int level = Integer.parseInt(moveset[i * 2].trim());
                                        String movename = moveset[(i * 2) + 1].trim();
                                        Move move = getMove(movename);
                                        if (move == null) {
                                            System.out.printf("> %s - Couldn't find move: %s\n", pokemon.getName(), movename);
                                        } else {
                                            pokemon.addLevelMove(level, move);
                                        }
                                    }
                                    break;
                                }
                                case "EchoMoves": {
                                    String[] moveset = value.split(",");
                                    for (int i = 0; i < moveset.length / 2; i++) {
                                        int level = Integer.parseInt(moveset[i * 2].trim());
                                        String movename = moveset[(i * 2) + 1].trim();
                                        Move move = getMove(movename);
                                        if (move == null) {
                                            System.out.printf("> %s - Couldn't find move: %s\n", pokemon.getName(), movename);
                                        } else {
                                            pokemon.addEchoLevelMove(level, move);
                                        }
                                    }
                                    break;
                                }
                                case "EggMoves": {
                                    String[] moves = value.split(",");
                                    for (int i = 0; i < moves.length; i++) {
                                        Move move = getMove(moves[i].trim());
                                        if (move == null) {
                                            System.out.printf("> %s - Couldn't find move: %s\n", pokemon.getName(), moves[i]);
                                        } else {
                                            pokemon.addEggMove(move);
                                        }
                                    }
                                    break;
                                }
                                case "EvolutionMove": {
                                    Move move = getMove(value.trim());
                                    if (move == null) {
                                        System.out.printf("> %s - Couldn't find move: %s\n", pokemon.getName(), value);
                                    } else {
                                        pokemon.setEvolutionMove(move);;
                                    }
                                    break;
                                }
                                case "EchoEvolutionMove": {
                                    Move move = getMove(value.trim());
                                    if (move == null) {
                                        System.out.printf("> %s - Couldn't find move: %s\n", pokemon.getName(), value);
                                    } else {
                                        pokemon.setEchoEvolutionMove(move);;
                                    }
                                    break;
                                }
                                case "Evolutions": {
                                    String[] evos = value.split(",");
                                    if (evos.length > 1) {
                                        for (int i = 0; i < Math.ceil(evos.length / 3.0); i++) {
                                            if ((i * 3 + 2) >= evos.length) {
                                                pokemon.addEvolution(evos[i*3], evos[i*3+1], "");
                                            } else if ((i * 3 + 1) >= evos.length) {
                                                pokemon.addEvolution(evos[i*3], "", "");
                                            } else {
                                                pokemon.addEvolution(evos[i*3], evos[i*3+1], evos[i*3+2]);
                                            }
                                            
                                        }
                                    }
                                    break;
                                }
                                case "GenderRate": {
                                    pokemon.setGenderRate(value);
                                    break;
                                }
                                case "GrowthRate": {
                                    pokemon.setGrowthRate(value);
                                    break;
                                }
                                case "BaseEXP": {
                                    pokemon.setBaseExp(Integer.parseInt(value));
                                    break;
                                }
                                case "EffortPoints": {
                                    String[] statsString = value.split(",");
                                    if (statsString.length == 6) {
                                        int[] stats = new int[6];
                                        for (int i = 0; i < 6; i++) {
                                            stats[i] = Integer.parseInt(statsString[i]);
                                        }
                                        pokemon.setEffortPoints(stats);
                                    }
                                    break;
                                }
                                case "Rareness": {
                                    pokemon.setRareness(Integer.parseInt(value));
                                    break;
                                }
                                case "Happiness": {
                                    pokemon.setHappiness(Integer.parseInt(value));
                                    break;
                                }
                                case "Compatibility": {
                                    pokemon.setCompatibility(value.split(","));
                                    break;
                                }
                                case "StepsToHatch": {
                                    pokemon.setStepsToHatch(Integer.parseInt(value));
                                    break;
                                }
                                case "Height": {
                                    pokemon.setHeight(Double.parseDouble(value));
                                    break;
                                }
                                case "Weight": {
                                    pokemon.setWeight(Double.parseDouble(value));
                                    break;
                                }
                                case "Color": {
                                    pokemon.setColor(value);
                                    break;
                                }
                                case "WildItemCommon": {
                                    Item item = getItem(value);
                                    if (item == null) {
                                        System.out.printf("> %s - Couldn't find item: %s\n", pokemon.getName(), value);
                                    } else {
                                        pokemon.setWildItemCommon(item);;
                                    }
                                    break;
                                }
                                case "WildItemUncommon": {
                                    Item item = getItem(value);
                                    if (item == null) {
                                        System.out.printf("> %s - Couldn't find item: %s\n", pokemon.getName(), value);
                                    } else {
                                        pokemon.setWildItemUncommon(item);;
                                    }
                                    break;
                                }
                                case "WildItemRare": {
                                    Item item = getItem(value);
                                    if (item == null) {
                                        System.out.printf("> %s - Couldn't find item: %s\n", pokemon.getName(), value);
                                    } else {
                                        pokemon.setWildItemRare(item);;
                                    }
                                    break;
                                }
                                case "Incense": {
                                    Item item = getItem(value);
                                    if (item == null) {
                                        System.out.printf("> %s - Couldn't find item: %s\n", pokemon.getName(), value);
                                    } else {
                                        pokemon.setIncense(item);;
                                    }
                                    break;
                                }
                                case "RegionalNumbers": {
                                    pokemon.setRegionalNumbers(value);
                                    break;
                                }
                                case "Kind": {
                                    pokemon.setKind(value);
                                    break;
                                }
                                case "FormNames": {
                                    pokemon.setFormNames(value.split(","));
                                    break;
                                }
                                case "Pokedex": {
                                    pokemon.setDexEntry(value);
                                    break;
                                }
                                case "BattlerPlayerY": {
                                    pokemon.setBattlerPlayerY(Integer.parseInt(value));
                                    break;
                                }
                                case "BattlerEnemyY": {
                                    pokemon.setBattlerEnemyY(Integer.parseInt(value));
                                    break;
                                }
                                case "BattlerAltitude": {
                                    pokemon.setBattlerAltitude(Integer.parseInt(value));
                                    break;
                                }
                            }
                        }
                    }

                    //System.out.printf("Loaded %03d %s\n", id, pokemon.getName());
                    pokedex.add(pokemon);
                }   
            }
        }

        try {
            br.close();
        } catch (IOException e) {
            System.out.println("ERROR: Failed to close BufferedReader.");
        }

    }

    private void loadMoveFile(File file) {

        BufferedReader br;
        try {
            br = new BufferedReader(new FileReader(file));
        } catch (FileNotFoundException e) {
            System.out.println("ERROR: Failed to load move source file.");
            return;
        }

        try {
            String line = "";
            while ((line = br.readLine()) != null) {
                if (line.length() > 0) {
                    if (line.charAt(0) != '#') {
                        if (line.indexOf(",") > 4) {
                            line = line.substring(line.indexOf(",") - 1);
                        }
                        String[] data = line.split(",");
                        int id = Integer.parseInt(data[0]);
                        String internalName = data[1];
                        String name = data[2];
                        String function = data[3];
                        int power = Integer.parseInt(data[4]);
                        String type = data[5];
                        String category = data[6];
                        int accuracy = Integer.parseInt(data[7]);
                        int pp = Integer.parseInt(data[8]);
                        int effectChance = Integer.parseInt(data[9]);
                        String target = data[10];
                        int priority = Integer.parseInt(data[11]);
                        String flags = data[12];
                        String description = data[13];
                        for (int i = 14; i < data.length; i++) {
                            description = description + "," + data[i];
                        }
                        description = description.replace("\"", "");
                        Move move = new Move(id, name, internalName, function, power, accuracy,
                            pp, type, category, effectChance, target, priority, flags, description);
                        movelist.add(move);
                        //System.out.printf("Loaded %s\n", move.toString());
                    }
                }
            }
            br.close();
        } catch(IOException e) {
            System.out.println("ERROR: Failed to read from move file.");
        }
    }

    private void loadAbilityFile(File file) {

        BufferedReader br;
        try {
            br = new BufferedReader(new FileReader(file));
        } catch (FileNotFoundException e) {
            System.out.println("ERROR: Failed to load ability source file.");
            return;
        }

        try {
            String line = "";
            while ((line = br.readLine()) != null) {
                if (line.length() > 0) {
                    if (line.charAt(0) != '#') {
                        if (line.indexOf(",") > 3) {
                            line = line.substring(line.indexOf(",") - 1);
                        }
                        String[] data = line.split(",");
                        int id = Integer.parseInt(data[0]);
                        String internalName = data[1];
                        String name = data[2];
                        String description = data[3];
                        for (int i = 4; i < data.length; i++) {
                            description = description + "," + data[i];
                        }
                        description = description.replace("\"", "");
                        Ability ability = new Ability(id, name, internalName, description);
                        abilityList.add(ability);
                        //System.out.printf("Loaded %s\n", ability.toString());
                    }
                }
            }
            br.close();
        } catch(IOException e) {
            System.out.println("ERROR: Failed to read from ability file.");
        }
    }

    private void loadItemFile(File file) {

        BufferedReader br;
        try {
            br = new BufferedReader(new FileReader(file));
        } catch (FileNotFoundException e) {
            System.out.println("ERROR: Failed to load item source file.");
            return;
        }

        try {
            String line = "";
            while ((line = br.readLine()) != null) {
                if (line.length() > 0) {
                    if (line.charAt(0) != '#') {
                        String[] data = line.split(",");
                        int id = 0;
                        try {
                            id = Integer.parseInt(data[0]);
                        } catch (NumberFormatException e) {
                            data[0] = data[0].substring(data[0].length() - 1);
                            id = Integer.parseInt(data[0]);
                        }
                        String internalName = data[1];
                        String name = data[2];
                        String pluralName = data[3];
                        int pocket = Integer.parseInt(data[4]);
                        int price = Integer.parseInt(data[5]);
                        String description = data[6];
                        if (description.lastIndexOf("\"") == description.indexOf("\"")) {
                            for (int i = 7; i < data.length; i++) {
                                description = description + "," + data[i];
                                if (data[i].contains("\"")) {
                                    break;
                                }
                            }
                        }
                        description = description.replace("\"", "");
                        data = line.substring(line.lastIndexOf("\"") + 2).split(",");
                        int useField = Integer.parseInt(data[0]);
                        int useBattle = Integer.parseInt(data[1]);
                        int specialItem = Integer.parseInt(data[2]);
                        Item item = new Item(id, internalName, name, pluralName, pocket, price,
                            description, useField, useBattle, specialItem);
                        if (item.isTM()) {
                            Move move = getMove(data[3]);
                            if (move == null) {
                                System.out.printf("> %s: Did not find Move '%s'\n", name, data[3]);
                            } else {
                                item.setTM(move);
                            }
                        }
                        itemList.add(item);
                        //System.out.printf("Loaded %s\n", item);
                    }
                }
            }
            br.close();
        } catch(IOException e) {
            System.out.println("ERROR: Failed to read from ability file.");
        }
    }

    private void loadTMFile(File file) {

        BufferedReader br;
        try {
            br = new BufferedReader(new FileReader(file));
        } catch (FileNotFoundException e) {
            System.out.println("ERROR: Failed to load item source file.");
            return;
        }

        TM tm = null;

        try {
            String line = "";
            while ((line = br.readLine()) != null) {
                if (line.length() > 0) {
                    if (line.charAt(0) != '#') {
                        if (line.charAt(0) == '[') {
                            String movename = line.substring(1, line.indexOf("]"));
                            Move move = getMoveInternal(movename);
                            tm = new TM(move);
                            tms.put(move, tm);
                        } else if (tm != null) {
                            String[] list = line.split(",");
                            for (String s : list) {
                                if (s.length() > 1) {
                                    Pokemon pokemon = getPokemonInternal(s.trim());
                                    if (pokemon == null) {
                                        System.out.printf("> TM %s: Couldn't find the Pokemon '%s'\n", tm.getMove(), s.trim());
                                    } else {
                                        tm.addPokemonSingle(pokemon);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            br.close();
        } catch(IOException e) {
            System.out.println("ERROR: Failed to read from tm file.");
        }
    }

    private void loadTrainerTypeFile(File file) {

        BufferedReader br;
        try {
            br = new BufferedReader(new FileReader(file));
        } catch (FileNotFoundException e) {
            System.out.println("ERROR: Failed to load item source file.");
            return;
        }

        try {
            String line = "";
            while ((line = br.readLine()) != null) {
                if (line.length() > 0) {
                    if (line.charAt(0) != '#') {
                        String[] data = line.split(",");
                        if (data.length >= 2) {
                            int id = 0;
                            try {
                                id = Integer.parseInt(data[0]);
                            } catch (NumberFormatException e) {
                                data[0] = data[0].substring(data[0].length() - 1);
                                id = Integer.parseInt(data[0]);
                            }
                            String internalName = data[1];
                            String name = data[2];
                            
                            TrainerType type = new TrainerType(id, internalName, name);
    
                            int baseMoney = Integer.parseInt(data[3]);
                            type.setBaseMoney(baseMoney);
    
                            type.setBattleBGM(data[4]);
                            type.setVictoryBGM(data[5]);
                            type.setIntroME(data[6]);
                            type.setGender(data[7]);
                            if (data.length > 8) {
                                if (data[8].length() > 0) {
                                    int skillLevel = Integer.parseInt(data[8]);
                                    type.setSkillLevel(skillLevel);
                                }
                            }
                            if (data.length > 9) {
                                type.setSkillCode(data[9]);
                            }
    
                            trainerTypes.add(type);
                            //System.out.printf("Loaded %s\n", type);
                        }
                    }
                }
            }
            br.close();
        } catch(IOException e) {
            System.out.println("ERROR: Failed to read from ability file.");
        }
    }

    private void loadTrainerFile(File file) {

        BufferedReader br;
        try {
            br = new BufferedReader(new FileReader(file));
        } catch (FileNotFoundException e) {
            System.out.println("ERROR: Failed to load pokemon source file.");
            return;
        }

        ArrayList<String> lines = new ArrayList<>();
        String line;
        try {
            while ((line = br.readLine()) != null) {
                lines.add(line);
            }
        } catch (IOException e) {
            System.out.println("ERROR: Failure when reading lines in file.");
            return;
        }

        LineReader scanner = new LineReader(lines);

        line = "";
        
        while (scanner.hasNextLine()) {
            line = scanner.nextLine();
            if (line.length() > 0) {
                if (line.charAt(0) != '#') {
                    String typeName = line.trim();
                    if (typeName.contains("#")) {
                        typeName = typeName.substring(0, typeName.indexOf("#") - 1);
                    }
                    TrainerType type = getTrainerType(typeName);
                    if (type == null) {
                        System.out.printf("ERROR: Couldn't find Trainer Type '%s'\n", typeName);
                    } else {
                        // Read comment
                        String comment = "";
                        if (line.contains("#")) {
                            comment = line.substring(line.indexOf("#") + 1);
                        }
                        // Read name and version line
                        line = scanner.nextLine();
                        String[] data = line.split(",");
                        String name = data[0];
                        Trainer trainer = new Trainer(type, name);
                        trainer.setComment(comment);
                        if (data.length >= 2) {
                            trainer.setVersion(Integer.parseInt(data[1]));
                        }
                        // Read party length and items line
                        line = scanner.nextLine();
                        data = line.split(",");
                        int partyLen = Integer.parseInt(data[0]);
                        for (int i = 1; i < data.length; i++) {
                            Item item = getItemInternal(data[i]);
                            if (item == null) {
                                System.out.printf("ERROR: %s > Couldn't find Item '%s'", trainer, data[i]);
                            } else {
                                if (!trainer.addItem(item)) {
                                    System.out.printf("ERROR: %s > Can't carry more items (%s was not included)", trainer, data[i]);
                                }
                            }
                        }
                        // Read the lines of party pokemon
                        for (int i = 0; i < partyLen; i++) {
                            line = scanner.nextLine();
                            data = line.split(",");
                            Pokemon species = getPokemonInternal(data[0]);
                            int level = Integer.parseInt(data[1]);
                            if (species == null) {
                                System.out.printf("ERROR: %s > Couldn't find the Pokemon '%s'", trainer, data[0]);
                            } else {
                                PartyPokemon pokemon = new PartyPokemon(species, level);
                                if (data.length >= 3) {
                                    if (data[2].length() > 0) {
                                        Item item = getItem(data[2]);
                                        if (item == null) {
                                            System.out.printf("ERROR: %s > %s > Couldn't find the Item '%s'", trainer, pokemon, data[2]);
                                        } else {
                                            pokemon.setItem(item);
                                        }
                                    }
                                }
                                if (data.length >= 4) {
                                    if (data[3].length() > 0) {
                                        Move move = getMove(data[3]);
                                        if (move == null) {
                                            System.out.printf("ERROR: %s > %s > Couldn't find the Move '%s'", trainer, pokemon, data[3]);
                                        } else {
                                            pokemon.addMove(move);
                                        }
                                    }
                                }
                                if (data.length >= 5) {
                                    if (data[4].length() > 0) {
                                        Move move = getMove(data[4]);
                                        if (move == null) {
                                            System.out.printf("ERROR: %s > %s > Couldn't find the Move '%s'", trainer, pokemon, data[4]);
                                        } else {
                                            pokemon.addMove(move);
                                        }
                                    }
                                }
                                if (data.length >= 6) {
                                    if (data[5].length() > 0) {
                                        Move move = getMove(data[5]);
                                        if (move == null) {
                                            System.out.printf("ERROR: %s > %s > Couldn't find the Move '%s'", trainer, pokemon, data[5]);
                                        } else {
                                            pokemon.addMove(move);
                                        }
                                    }
                                }
                                if (data.length >= 7) {
                                    if (data[6].length() > 0) {
                                        Move move = getMove(data[6]);
                                        if (move == null) {
                                            System.out.printf("ERROR: %s > %s > Couldn't find the Move '%s'", trainer, pokemon, data[6]);
                                        } else {
                                            pokemon.addMove(move);
                                        }
                                    }
                                }
                                if (data.length >= 8) {
                                    if (data[7].length() > 0) {
                                        int ability = Integer.parseInt(data[7]);
                                        pokemon.setAbility(ability);
                                    }
                                }
                                if (data.length >= 9) {
                                    if (data[8].length() > 0) {
                                        if (data[8].equals("M") || data[8].equals("F")) {
                                            pokemon.setGender(data[8]);
                                        } else if (data[8].equals("0")) {
                                            pokemon.setGender("M");
                                        } else if (data[8].equals("1")) {
                                            pokemon.setGender("F");
                                        } else if (data[8].equals("2")) {
                                            pokemon.setGender("");
                                        } else {
                                            System.out.printf("ERROR: %s > %s > Invalid gender '%s'", trainer, pokemon, data[8]);
                                        }
                                    }
                                }
                                if (data.length >= 10) {
                                    if (data[9].length() > 0) {
                                        int form = Integer.parseInt(data[9]);
                                        pokemon.setForm(form);
                                    }
                                }
                                if (data.length >= 11) {
                                    if (data[10].length() > 0) {
                                        if (data[10].equals("1") || data[10].toLowerCase().equals("shiny")) {
                                            pokemon.setShiny(true);
                                        }
                                    }
                                }
                                if (data.length >= 12) {
                                    if (data[11].length() > 0) {
                                        pokemon.setNature(data[11]);
                                    }
                                }
                                if (data.length >= 13) {
                                    if (data[12].length() > 0) {
                                        int IVs = Integer.parseInt(data[12]);
                                        pokemon.setIVs(IVs);
                                    }
                                }
                                if (data.length >= 14) {
                                    if (data[13].length() > 0) {
                                        int happiness = Integer.parseInt(data[13]);
                                        pokemon.setHappiness(happiness);
                                    }
                                }
                                if (data.length >= 15) {
                                    if (data[14].length() > 0) {
                                        pokemon.setNickname(data[14]);
                                    }
                                }
                                if (data.length >= 16) {
                                    if (data[15].length() > 0) {
                                        if (data[15].equals("1") || data[15].toLowerCase().equals("true")) {
                                            pokemon.setShadow(true);
                                        }
                                    }
                                }
                                if (data.length >= 17) {
                                    if (data[16].length() > 0) {
                                        int ballType = Integer.parseInt(data[16].trim());
                                        pokemon.setBallType(ballType);
                                    }
                                }
                                for (int j = 0; j < 6; j++) {
                                    if (data.length >= 18 + j) {
                                        if (data[17 + j].length() > 0) {
                                            int ev = Integer.parseInt(data[17 + j].trim());
                                            pokemon.setEV(j, ev);
                                        }
                                    }
                                }

                                trainer.addPokemon(pokemon);
                            }
                        }
                        //System.out.printf("Added Trainer %s\n", trainer);
                        trainers.add(trainer);
                    }
                }
            }
        }

        try {
            br.close();
        } catch (IOException e) {
            System.out.println("ERROR: Failed to close BufferedReader.");
        }

    }

    public void loadEncounterFile(File file) {
        BufferedReader br;
        try {
            br = new BufferedReader(new FileReader(file));
        } catch (FileNotFoundException e) {
            System.out.println("ERROR: Failed to load pokemon source file.");
            return;
        }

        ArrayList<String> lines = new ArrayList<>();
        String line;
        try {
            while ((line = br.readLine()) != null) {
                lines.add(line);
            }
        } catch (IOException e) {
            System.out.println("ERROR: Failure when reading lines in file.");
            return;
        }

        LineReader scanner = new LineReader(lines);

        line = "";
        EncounterList encounterList = null;
        String encounterType = null;

        while (scanner.hasNextLine()) {
            line = scanner.nextLine().trim();
            if (line.length() > 0) {
                if (line.charAt(0) != '#') {
                    try {
                        int mapId = Integer.parseInt(line.substring(0, 3));
                        String[] split = line.split("#");
                        String mapName = null;
                        if (split.length >= 2) {
                            mapName = split[1].trim();
                        }
                        line = scanner.nextLine();
                        encounterList = new EncounterList(mapId, mapName);
                        encounters.add(encounterList);
                    } catch (NumberFormatException e) {
                        if (EncounterList.isEncounterType(line)) {
                            encounterType = line;
                        } else {
                            String[] data = line.split(",");
                            if (data.length < 2) {
                                System.out.println(String.format("To few arguments in encounters.txt line: %s", line));
                                return;
                            }
                            Pokemon poke = getPokemonInternal(data[0]);
                            if (poke == null) {
                                System.out.println(String.format("Invalid Pokemon Name '%s' in encounters.txt", data[0]));
                                return;
                            }
                            int minLevel = 0;
                            try {
                                minLevel = Integer.parseInt(data[1]);
                            } catch (NumberFormatException e2) {
                                System.out.println(String.format("Invalid min level in encounters.txt line: %s", line));
                                return;
                            }
                            int maxLevel = minLevel;
                            if (data.length > 2) {
                                try {
                                    maxLevel = Integer.parseInt(data[2]);
                                } catch (NumberFormatException e2) {
                                    System.out.println(String.format("Invalid max level in encounters.txt line: %s", line));
                                    return;
                                }
                            }
                            Encounter encounter = new Encounter(poke, minLevel, maxLevel);
                            if (data.length > 3) {
                                try {
                                    int form = Integer.parseInt(data[3]);
                                    encounter.setForm(form);
                                } catch (NumberFormatException e2) {
                                    System.out.println(String.format("Invalid form in encounters.txt line: %s", line));
                                    return;
                                }
                            }
                            encounterList.addEncounter(encounterType, encounter);
                        }
                    }
                }
            }
        }
    }

    public boolean savePokemonFile(File file) {

        Collections.sort(pokedex, compareID);

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.out.println("ERROR: Failed to create file");
                return false;
            }
        }

        PrintWriter writer;
        try {
            writer = new PrintWriter(file);
        } catch (IOException e) {
            System.out.println("ERROR: Failed to write to file");
            return false;
        }

        for (Pokemon p : pokedex) {

            writer.printf("[%d]\r\n", p.getID());
            writer.printf("Name=%s\r\n", p.getName());
            writer.printf("InternalName=%s\r\n", p.getInternalName());
            writer.printf("Type1=%s\r\n", p.getType1());
            if (p.hasType2()) {
                writer.printf("Type2=%s\r\n", p.getType2());
            }
            if (p.hasType3()) {
                writer.printf("Type3=%s\r\n", p.getType3());
            }
            if (p.hasType4()) {
                writer.printf("Type4=%s\r\n", p.getType4());
            }
            writer.printf("BaseStats=%d,%d,%d,%d,%d,%d\r\n",
                p.getHP(), p.getAttack(), p.getDefense(), p.getSpeed(), p.getSpAtk(), p.getSpDef());
            writer.printf("GenderRate=%s\r\n", p.getGenderRate());
            writer.printf("GrowthRate=%s\r\n", p.getGrowthRate());
            writer.printf("BaseEXP=%d\r\n", p.getBaseExp());
            int[] evs = p.getEffortPoints();
            writer.printf("EffortPoints=%d,%d,%d,%d,%d,%d\r\n",
                evs[0], evs[1], evs[2], evs[3], evs[4], evs[5]);
            writer.printf("Rareness=%d\r\n", p.getRareness());
            writer.printf("Happiness=%d\r\n", p.getHappiness());
            if (p.hasAbility2()) {
                writer.printf("Abilities=%s,%s\r\n", p.getAbility1().getInternalName(), p.getAbility2().getInternalName());
            } else {
                writer.printf("Abilities=%s\r\n", p.getAbility1().getInternalName());
            }
            if (p.hasHiddenAbility()) {
                writer.printf("HiddenAbility=%s\r\n", p.getHiddenAbility().getInternalName());
            }
            if (echoes && p.hasEchoAbility()) {
                writer.printf("EchoAbility=%s\r\n", p.getEchoAbility().getInternalName());
            }
            boolean first = true;
            writer.printf("Moves=");
            for (int i = 0; i < 100; i++) {
                if (p.getLevelMoves().containsKey(i)) {
                    ArrayList<Move> moves = p.getLevelMoves().get(i);
                    for (Move m : moves) {
                        if (first) {
                            writer.printf("%d,%s", i, m.getInternalName());
                            first = false;
                        } else {
                            writer.printf(",%d,%s", i, m.getInternalName());
                        }
                        
                    }
                }
            }
            writer.printf("\r\n");

            if (echoes && p.hasEchoMoveset()) {
                first = true;
                writer.printf("EchoMoves=");
                for (int i = 0; i < 100; i++) {
                    if (p.getEchoMoves().containsKey(i)) {
                        ArrayList<Move> moves = p.getEchoMoves().get(i);
                        for (Move m : moves) {
                            if (first) {
                                writer.printf("%d,%s", i, m.getInternalName());
                                first = false;
                            } else {
                                writer.printf(",%d,%s", i, m.getInternalName());
                            }
                            
                        }
                    }
                }
                writer.printf("\r\n");
            }

            if (p.getEggMoves().size() > 0) {
                first = true;
                writer.printf("EggMoves=");
                for (Move m : p.getEggMoves()) {
                    if (first) {
                        writer.printf("%s", m.getInternalName());
                        first = false;
                    } else {
                        writer.printf(",%s", m.getInternalName());
                    }
                }
                writer.printf("\r\n");
            }
            if (p.hasEvolutionMove()) {
                writer.printf("EvolutionMove=%s\r\n", p.getEvolutionMove().getInternalName());
            }
            if (echoes && p.hasEchoEvolutionMove()) {
                writer.printf("EchoEvolutionMove=%s\r\n", p.getEchoEvolutionMove().getInternalName());
            }
            if (p.hasEggGroup2()) {
                writer.printf("Compatibility=%s,%s\r\n", p.getCompatibility()[0], p.getCompatibility()[1]);
            } else {
                writer.printf("Compatibility=%s\r\n", p.getCompatibility()[0]);
            }
            writer.printf("StepsToHatch=%d\r\n", p.getStepsToHatch());
            writer.printf(String.format(Locale.US, "Height=%.01f\r\n", p.getHeight()));
            writer.printf(String.format(Locale.US, "Weight=%.01f\r\n", p.getWeight()));
            writer.printf("RegionalNumbers=%s\r\n", p.getRegionalNumbers());
            writer.printf("Color=%s\r\n", p.hasColor() ? p.getColor() : "White");
            writer.printf("Kind=%s\r\n", p.getKind());
            if (p.hasForms()) {
                first = true;
                writer.printf("FormNames=");
                for (int i = 0; i < p.getFormNames().length; i++) {
                    if (first) {
                        writer.printf("%s", p.getFormNames()[i]);
                        first = false;
                    } else {
                        writer.printf(",%s", p.getFormNames()[i]);
                    }
                }
                writer.printf("\r\n");
            }
            writer.printf("Pokedex=%s\r\n", p.getDexEntry());
            if (p.hasWildItemCommon()) {
                writer.printf("WildItemCommon=%s\r\n", p.getWildItemCommon().getInternalName());
            }
            if (p.hasWildItemUncommon()) {
                writer.printf("WildItemUncommon=%s\r\n", p.getWildItemUncommon().getInternalName());
            }
            if (p.hasWildItemRare()) {
                writer.printf("WildItemRare=%s\r\n", p.getWildItemRare().getInternalName());
            }
            writer.printf("BattlerPlayerY=%d\r\n", p.getBattlerPlayerY());
            writer.printf("BattlerEnemyY=%d\r\n", p.getBattlerEnemyY());
            writer.printf("BattlerAltitude=%d\r\n", p.getBattlerAltitude());
            writer.printf("Evolutions=");
            first = true;
            for (int i = 0; i < p.getEvolutionData().size(); i++) {
                String[] evo = p.getEvolutionData().get(i);
                if (first) {
                    writer.printf("%s,%s,%s", evo[0], evo[1], evo[2]);
                    first = false;
                } else {
                    writer.printf(",%s,%s,%s", evo[0], evo[1], evo[2]);
                }
            }
            writer.printf("\r\n");
            if (p.hasIncense()) {
                writer.printf("Incense=%s\r\n", p.getIncense().getInternalName());
            }

        }

        writer.close();

        return true;

    }

    public boolean saveMovesFile(File file) {

        Collections.sort(movelist, compareID);

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.out.println("ERROR: Failed to create file");
                return false;
            }
        }

        PrintWriter writer;
        try {
            writer = new PrintWriter(file);
        } catch (IOException e) {
            System.out.println("ERROR: Failed to write to file");
            return false;
        }

        for (Move m : movelist) {
            writer.printf("%d,%s,%s,%s,%d,%s,%s,%d,%d,%d,%s,%d,%s,\"%s\"\r\n",
                m.getID(), m.getInternalName(), m.getName(), m.getFunction(),
                m.getPower(), m.getType(), m.getCategory(), m.getAccuracy(),
                m.getPP(), m.getEffectChance(), m.getTarget(), m.getPriority(),
                m.getFlags(), m.getDescription());
        }

        writer.close();

        return true;
    }

    public boolean saveAbilitiesFile(File file) {

        Collections.sort(abilityList, compareID);

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.out.println("ERROR: Failed to create file");
                return false;
            }
        }

        PrintWriter writer;
        try {
            writer = new PrintWriter(file);
        } catch (IOException e) {
            System.out.println("ERROR: Failed to write to file");
            return false;
        }

        for (Ability a : abilityList) {
            writer.printf("%d,%s,%s,\"%s\"\r\n", a.getID(), a.getInternalName(), a.getName(), a.getDescription());
        }

        writer.close();

        return true;

    }

    public boolean saveItemsFile(File file) {

        Collections.sort(itemList, compareID);

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.out.println("ERROR: Failed to create file");
                return false;
            }
        }

        PrintWriter writer;
        try {
            writer = new PrintWriter(file);
        } catch (IOException e) {
            System.out.println("ERROR: Failed to write to file");
            return false;
        }

        for (Item i : itemList) {
            if (i.isTM() && i.hasTM()) {
                writer.printf("%d,%s,%s,%s,%d,%d,\"%s\",%d,%d,%d,%s\r\n",
                    i.getID(), i.getInternalName(), i.getName(), i.getPluralName(),
                    i.getPocket(), i.getPrice(), i.getDescription(), i.getUseField(),
                    i.getUseBattle(), i.getSpecialItem(), i.getTM().getInternalName());
            } else {
                writer.printf("%d,%s,%s,%s,%d,%d,\"%s\",%d,%d,%d,\r\n",
                i.getID(), i.getInternalName(), i.getName(), i.getPluralName(),
                i.getPocket(), i.getPrice(), i.getDescription(), i.getUseField(),
                i.getUseBattle(), i.getSpecialItem());
            }
        }

        writer.close();

        return true;

    }

    public boolean saveTMFile(File file) {

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.out.println("ERROR: Failed to create file");
                return false;
            }
        }

        PrintWriter writer;
        try {
            writer = new PrintWriter(file);
        } catch (IOException e) {
            System.out.println("ERROR: Failed to write to file");
            return false;
        }

        for (Move m : tms.keySet()) {
            TM tm = tms.get(m);
            if (tm.getPokemon().size() > 0) {
                writer.printf("[%s]\r\n", m.getInternalName());
                boolean first = true;
                for (Pokemon p : tm.getPokemon()) {
                    if (first) {
                        writer.printf("%s", p.getInternalName());
                        first = false;
                    } else {
                        writer.printf(",%s", p.getInternalName());
                    }
                }
                writer.printf("\r\n");
            }
        }

        writer.close();

        return true;

    }

    public boolean saveTrainersFile(File file) {

        Collections.sort(trainers, compareTrainer);

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.out.println("ERROR: Failed to create file");
                return false;
            }
        }

        PrintWriter writer;
        try {
            writer = new PrintWriter(file);
        } catch (IOException e) {
            System.out.println("ERROR: Failed to write to file");
            return false;
        }

        for (Trainer t : trainers) {
            writer.println("#--------------");

            // Trainer Type line
            writer.print(t.getTrainerType().getInternalName());
            if (t.hasComment()) {
                writer.printf(" #%s", t.getComment());
            }
            writer.print("\r\n");

            // Name and version number
            writer.print(t.getName());
            if (t.getVersion() > 0) {
                writer.printf(",%d", t.getVersion());
            }
            writer.print("\r\n");

            // Party length and items
            writer.printf("%d", t.getParty().size());
            if (t.hasItems()) {
                for (Item i : t.getItems()) {
                    writer.printf(",%s", i.getInternalName());
                }
            }
            writer.print("\r\n");

            // Print party pokemon
            for (PartyPokemon p : t.getParty()) {
                writer.printf("%s,%d", p.getPokemon().getInternalName(), p.getLevel());
                writer.printf(",%s", p.hasItem() ? p.getItem().getInternalName() : "");
                for (Move m : p.getMoves()) {
                    writer.print(",");
                    if (m != null) {
                        writer.printf("%s", m.getInternalName());
                    }
                }
                writer.printf(",%d,%s,%d", p.getAbility(), p.getGender(), p.getForm());
                writer.printf(",%d", p.isShiny() ? 1 : 0);
                writer.printf(",%s,%d,%d", p.getNature(), p.getIVs(), p.getHappiness());
                writer.printf(",%s,%d", p.getNickname(), p.isShadow() ? 1 : 0);
                writer.printf(",%d", p.getBallType());
                for (int i = 0; i < 6; i++) {
                    writer.printf(",%d", p.getEV(i));
                }
                writer.print("\r\n");
            }

        }

        writer.close();

        return true;

    }

    public boolean saveEncounterFile(File file) {

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.out.println("ERROR: Failed to create file");
                return false;
            }
        }

        PrintWriter writer;
        try {
            writer = new PrintWriter(file);
        } catch (IOException e) {
            System.out.println("ERROR: Failed to write to file");
            return false;
        }

        for (EncounterList el : encounters) {
            writer.printf("###########################\r\n");
            writer.printf("%03d # %s\r\n", el.getMapId(), el.getMapName());
            writer.printf("25,10,10\r\n");
            HashMap<String, ArrayList<Encounter>> list = el.getEncounters();
            for (String key : EncounterList.types) {
                if (list.containsKey(key)) {
                    writer.printf("%s\r\n", key);
                    for (Encounter e : list.get(key)) {
                        if (e.hasForm()) {
                            writer.printf("%s,%d,%d,%d\r\n",
                                e.getPokemon().getInternalName(), e.getMinLevel(), e.getMaxLevel(), e.getForm());
                        } else {
                            writer.printf("%s,%d,%d\r\n",
                                e.getPokemon().getInternalName(), e.getMinLevel(), e.getMaxLevel());
                        }
                    }
                }
            }
        }

        writer.close();

        return true;

    }

    public ArrayList<Pokemon> getPokedex() {
        return pokedex;
    }

    public ArrayList<TrainerType> getTrainerTypes() {
        return trainerTypes;
    }

    public void createDocs() {
        File dir = new File("../docs/");

        if (!dir.exists()) {
            dir.mkdir();
        }
        PrintWriter writer;

        File pokeDoc = new File(dir, "pokemon.html");

        if (!pokeDoc.exists()) {
            try {
                pokeDoc.createNewFile();
            } catch (IOException e) {
                System.out.println("ERROR: Failed to create file");
                return;
            }
        }

        try {
            writer = new PrintWriter(pokeDoc);
        } catch (IOException e) {
            System.out.println("ERROR: Failed to write to file");
            return;
        }

        writer.print("<!DOCTYPE html>\n");
        writer.print("<html>\n<head>\n<meta charset=\"UTF-8\">\n<style>\n");
        writer.print(".collapsible {background-color: #eee; padding-left: 16px; padding-right: 16px; font-size: 16px;}\n");
        writer.print(".active {background-color: #ccc;}\n");
        writer.print(".letter_div {padding: 4px; background-color: #f1f1f1; border: 1px solid black; border-radius: 4px; margin: 4px;}\n");
        writer.print(".letter {padding: 8px; display: none; background-color: #f1f1f1; overflow: hidden;}\n");
        writer.print(".poke_div {padding: 4px; background-color: #e1e1e1; border: 1px solid black; border-radius: 4px; margin: 4px;}\n");
        writer.print(".poke {padding: 6px; display: none; background-color: #e1e1e1; overflow: hidden;}\n");
        writer.print(".cell {background-color: #ffffff; border: 1px solid black}\n");
        writer.print(".cell_header {background-color: #ffffff; border: 1px solid black}\n");
        writer.print(".cell_headest {background-color: #ffffff; border: 1px solid black}\n");
        writer.print(".stat {background-color: #ffffff; border: 1px solid black}\n");
        writer.print(".stath {background-color: #ffffff; border: 1px solid black}\n");
        writer.print("td, th, tr {vertical-align: top; text-align: center; padding: 2px;}\n");
        writer.print("body {font-family:verdana}\n");
        writer.print("</style>\n</head>\n<body>\n");

        Comparator<Pokemon> compareName = new Comparator<Pokemon>() {
            @Override
            public int compare(Pokemon a, Pokemon b) {
                return (a.getName().compareTo(b.getName()));
            }
        };

        ArrayList<Pokemon> pokelist = new ArrayList<>(pokedex);
        pokelist.sort(compareName);

        char initial = '.';

        for (Pokemon p : pokelist) {
            if (p.getName().charAt(0) != '?') {
                if (p.getName().charAt(0) != initial) {
                    if (initial != '.') {
                        writer.printf("</div></div>");
                    }
                    initial = p.getName().charAt(0);
                    writer.printf("<div class=\"letter_div\">");
                    writer.printf("<button type=\"button\" class=\"collapsible collapse_%c\">%c</button><br>", initial, initial);
                    writer.printf("<script>var coll = document.querySelector(\".collapse_%c\");", initial);
                    writer.printf("coll.addEventListener(\"click\", function() {this.classList.toggle(\"active\");");
                    writer.printf("var content = document.querySelector(\".letter_%c\");", initial);
                    writer.printf("content.style.display = (content.style.display === \"block\") ? \"none\" : \"block\";});");
                    writer.printf("</script>");
                    writer.printf("<div class=\"letter letter_%c\">", initial);
                }
                writer.printf("<div class=\"poke_div\">");
                writer.printf("<button type=\"button\" class=\"collapsible collapse_%s\">%s</button><br>", p.getInternalName(), p.getName());
                writer.printf("<script>var coll = document.querySelector(\".collapse_%s\");", p.getInternalName());
                writer.printf("coll.addEventListener(\"click\", function() {this.classList.toggle(\"active\");");
                writer.printf("var content = document.querySelector(\".poke_%s\");", p.getInternalName());
                writer.printf("content.style.display = (content.style.display === \"block\") ? \"none\" : \"block\";});");
                writer.printf("</script>");
                writer.printf("<div class=\"poke poke_%s\">", p.getInternalName());
                writer.printf("<b>Base Stats</b><br>");
                writer.printf("<table class=\"stats\"><tr><th class=\"stath\">HP</th><th class=\"stath\">Attack</th><th class=\"stath\">Defense</th><th class=\"stath\">Sp.Atk</th><th class=\"stath\">Sp.Def</th><th class=\"stath\">Speed</th></tr>");
                writer.printf("<tr><td class=\"stat\">%d</td><td class=\"stat\">%d</td><td class=\"stat\">%d</td><td class=\"stat\">%d</td><td class=\"stat\">%d</td><td class=\"stat\">%d</td></tr></table><br>",
                    p.getHP(), p.getAttack(), p.getDefense(), p.getSpAtk(), p.getSpDef(), p.getSpeed());
                writer.printf("<b>Type:</b> %s%s<br>", p.getType1(), p.hasType2() ? (", " + p.getType2()) : "");
                if (echoes) {
                    if (p.hasType3()) {
                        writer.printf("<b>Echo Type:</b> %s%s", p.getType3(), p.hasType4() ? (", " + p.getType4()) : "");
                    } else {
                        writer.printf("<b>Echo Type:</b> None");
                    }
                } else {
                    if (p.hasType3()) {
                        writer.printf("<b>Affinity:</b> %s", p.getType3());
                    } else {
                        writer.printf("<b>Affinity:</b> None");
                    }
                }
                writer.printf("<br><br>");
                writer.printf("<b>Abilities:</b> %s%s<br>", p.getAbility1().getName(), p.hasAbility2() ? (", " + p.getAbility2().getName()) : "");
                if (p.hasEchoAbility()) {
                    writer.printf("<b>Echo Ability:</b> %s<br>", p.getEchoAbility().getName());
                }
                writer.printf("<b>Hidden Ability:</b> %s<br><br>", p.hasHiddenAbility() ? p.getHiddenAbility().getName() : "None");
                if (p.hasWildItemCommon() || p.hasWildItemUncommon() || p.hasWildItemRare()) {
                    writer.printf("<b>Wild Held Items:</b><br>");
                    if (p.hasWildItemCommon()) {
                        writer.printf("Common (50%%): %s<br>", p.getWildItemCommon().getName());
                    }
                    if (p.hasWildItemUncommon()) {
                        writer.printf("Uncommon (5%%): %s<br>", p.getWildItemUncommon().getName());
                    }
                    if (p.hasWildItemRare()) {
                        writer.printf("Rare (1%%): %s<br>", p.getWildItemRare().getName());
                    }
                    writer.printf("<br>");
                }
                writer.printf("<b>Evolutions:</b> (TODO)<br><br>");
                writer.printf("<table class=\"moveset\"><tr><th class=\"cell_headest\">Level Up</th><th></th>%s<th class=\"cell_headest\">TM / Tutor</th></tr>", echoes ? "<th class=\"cell_headest\">Echo Level Up</th><th></th>" : "");
                writer.printf("<tr>");
                writer.printf("<td><table class=\"levelup\"><tr><th class=\"cell_header\">Level</th><th class=\"cell_header\">Move</th></tr>");
                HashMap<Integer, ArrayList<Move>> levelMoves = p.getLevelMoves();
                for (int i = 1; i <= 100; i++) {
                    if (levelMoves.containsKey(i)) {
                        for (Move m : levelMoves.get(i)) {
                            writer.printf("<tr><td class=\"cell lvl\">%d</td><td class=\"cell lvlmove\">%s</td></tr>", i, m.getName());
                        }
                    }
                }
                writer.printf("</table></td>");
                writer.printf("<td>.....</td>");
                if (echoes) {
                    writer.printf("<td><table class=\"levelup\"><tr><th class=\"cell_header\">Level</th><th class=\"cell_header\">Move</th></tr>");
                    HashMap<Integer, ArrayList<Move>> echoMoves = p.getEchoMoves();
                    for (int i = 1; i <= 100; i++) {
                        if (levelMoves.containsKey(i)) {
                            for (Move m : levelMoves.get(i)) {
                                writer.printf("<tr><td class=\"cell lvl\">%d</td><td class=\"cell lvlmove\">%s</td></tr>", i, m.getName());
                            }
                        }
                    }
                    writer.printf("</table></td>");
                    writer.printf("<td>.....</td>");
                }
                writer.printf("<td><table class=\"tms\"><tr><th colspan=\"3\" class=\"cell_header\">Moves</th></tr>");
                ArrayList<Move> moves = new ArrayList<>();
                for (Move m : tms.keySet()) {
                    if (tms.get(m).hasPokemon(p)) {
                        moves.add(m);
                    }
                }
                if (moves.size() > 0) {
                    writer.printf("<tr>");
                    moves.sort(this.compareName);
                    int i = 1;
                    for (Move m : moves) {
                        if (i >= 3) {
                            writer.printf("<td class=\"cell tmmove\">%s</td></tr><tr>", m.getName());
                            i = 0;
                        } else {
                            writer.printf("<td class=\"cell tmmove\">%s</td>", m.getName());
                        }
                        i++;
                    }
                    while (i > 1 && i <= 3) {
                        writer.printf("<td></td>");
                        i++;
                    }
                    writer.printf("</tr>");
                }
                writer.printf("</table></td>");
                writer.printf("</table>");

                writer.printf("</div></div>");
            }
        }

        if (initial != '.') {
            writer.printf("</div></div>");
        }
        
        writer.print("</body>\n</html>");

        writer.close();

    }

}