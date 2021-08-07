import java.util.ArrayList;
import java.util.HashMap;

class Pokemon implements Internal {

    // Main information
    private int id;
    private String name;
    private String internalName;
    private String type1;
    private String type2;
    private String type3;
    private String type4;
    private int[] stats;
    private Ability ability1;
    private Ability ability2;
    private Ability abilityH;
    private Ability abilityE;
    private HashMap<Integer, ArrayList<Move>> levelMoves;
    private HashMap<Integer, ArrayList<Move>> echoMoves;
    private ArrayList<Move> eggMoves;
    private Move evolutionMove;
    private Move echoEvoMove;
    private ArrayList<String[]> evolutionData;
    private PokemonSystem pokedex;

    // Additional information
    private String genderRate;
    private String growthRate;
    private int baseExp;
    private int[] effortPoints;
    private int rareness;
    private int happiness;
    private String[] compatibility;
    private int stepsToHatch;
    private double height;
    private double weight;
    private String kind;
    private String[] formNames;
    private String regionalNumbers;
    private String dexEntry;
    private String color;
    private Item wildItemCommon;
    private Item wildItemUncommon;
    private Item wildItemRare;
    private Item incense;
    private int battlerPlayerY;
    private int battlerEnemyY;
    private int battlerAltitude;


    public Pokemon(int id, PokemonSystem pokedex) {
        this.id = id;
        this.name = "";
        this.internalName = "";
        this.type1 = "";
        this.type2 = "";
        this.type3 = "";
        this.type4 = "";
        this.stats = new int[6];
        this.effortPoints = new int[6];
        this.ability1 = null;
        this.ability2 = null;
        this.abilityH = null;
        this.abilityE = null;
        this.genderRate = "";
        this.growthRate = "";
        this.baseExp = 0;
        this.rareness = 0;
        this.happiness = 0;
        this.compatibility = new String[1];
        this.compatibility[0] = "Undiscovered";
        this.stepsToHatch = 0;
        this.wildItemCommon = null;
        this.wildItemUncommon = null;
        this.wildItemRare = null;
        this.incense = null;
        this.height = 0;
        this.weight = 0;
        this.kind = "";
        this.formNames = new String[0];
        this.regionalNumbers = "";
        this.dexEntry = "";
        this.color = "White";
        this.battlerPlayerY = 0;
        this.battlerEnemyY = 0;
        this.battlerAltitude = 0;
        this.levelMoves = new HashMap<>();
        this.echoMoves = new HashMap<>();
        this.eggMoves = new ArrayList<>();
        this.evolutionData = new ArrayList<>();
        this.evolutionMove = null;
        this.echoEvoMove = null;
        this.pokedex = pokedex;
    }

    public void addLevelMove(int level, Move move) {
        if (!levelMoves.containsKey(level)) {
            levelMoves.put(level, new ArrayList<>());
        }
        levelMoves.get(level).add(move);
    }

    public boolean removeLevelMove(int level, Move move) {
        if (levelMoves.containsKey(level)) {
            for (Move m : levelMoves.get(level)) {
                if (m == move) {
                    levelMoves.get(level).remove(m);
                    return true;
                }
            }
        }
        return false;
    }

    public void addEchoLevelMove(int level, Move move) {
        if (!echoMoves.containsKey(level)) {
            echoMoves.put(level, new ArrayList<>());
        }
        echoMoves.get(level).add(move);
    }

    public boolean removeEchoLevelMove(int level, Move move) {
        if (echoMoves.containsKey(level)) {
            for (Move m : echoMoves.get(level)) {
                if (m == move) {
                    echoMoves.get(level).remove(m);
                    return true;
                }
            }
        }
        return false;
    }

    public void addEggMove(Move move) {
        eggMoves.add(move);
    }

    public boolean removeEggMove(Move move) {
        if (eggMoves.contains(move)) {
            eggMoves.remove(move);
            return true;
        }
        return false;
    }

    public void addEvolution(String pokemon, String type, String requirement) {
        String[] evolution = {pokemon, type, requirement};
        evolutionData.add(evolution);
    }

    public boolean canLearnMove(Move move) {
        return canLearnMove(move, 0);
    }

    public boolean canLearnMove(Move move, int level) {
        for (int i = 0; i <= ((level > 0) ? level : 100); i++) {
            if (levelMoves.containsKey(i)) {
                ArrayList<Move> moves = levelMoves.get(i);
                if (moves.contains(move)) {
                    return true;
                }
            }
        }

        if (eggMoves.contains(move)) {
            return true;
        }

        ArrayList<Pokemon> preEvos = getPreEvolutions();
        if (preEvos.size() > 0) {
            for (Pokemon p : preEvos) {
                if (p.canLearnMove(move, level)) {
                    return true;
                }
            }
        }

        TM tm = pokedex.getTM(move);
        if (tm != null) {
            if (tm.hasPokemon(this)) {
                return true;
            }
        }

        return false;
    }

    public boolean canLearnMoveThisStage(Move move) {
        for (int i = 0; i <= 100; i++) {
            if (levelMoves.containsKey(i)) {
                ArrayList<Move> moves = levelMoves.get(i);
                if (moves.contains(move)) {
                    return true;
                }
            }
        }

        if (eggMoves.contains(move)) {
            return true;
        }

        return false;
    }

    public ArrayList<Pokemon> getEvolutions() {
        ArrayList<Pokemon> pokemon = new ArrayList<>();
        for (Pokemon p : pokedex.getPokedex()) {
            for (String[] s : this.evolutionData) {
                if (s[0].equals(p.internalName)) {
                    pokemon.add(p);
                }
            }
        }
        return pokemon;
    }

    public ArrayList<Pokemon> getPreEvolutions() {
        ArrayList<Pokemon> pokemon = new ArrayList<>();
        for (Pokemon p : pokedex.getPokedex()) {
            for (String[] s : p.getEvolutionData()) {
                if (s[0].equals(this.internalName)) {
                    pokemon.add(p);
                }
            }
        }
        return pokemon;
    }

    public ArrayList<Pokemon> getAllPreEvolutions() {
        ArrayList<Pokemon> pokemon = new ArrayList<>();
        for (Pokemon p : pokedex.getPokedex()) {
            for (String[] s : p.getEvolutionData()) {
                if (s[0].equals(this.internalName)) {
                    pokemon.add(p);
                    for (Pokemon p2 : p.getAllPreEvolutions()) {
                        pokemon.add(p2);
                    }
                }
            }
        }
        return pokemon;
    }

    public Pokemon getFirstStage() {

        ArrayList<Pokemon> preEvos = getPreEvolutions();
        if (preEvos.size() > 0) {
            Pokemon firstStage = preEvos.get(0);
            while (preEvos.size() > 0) {
                firstStage = preEvos.get(0);
                preEvos = firstStage.getPreEvolutions();
            }
            return firstStage;
        }
        return this;
    }

    public boolean hasType2() { return (type2.length() > 0); }
    public boolean hasType3() { return (type3.length() > 0); }
    public boolean hasType4() { return (type4.length() > 0); }
    public boolean hasAbility2() { return (ability2 != null); }
    public boolean hasHiddenAbility() { return (abilityH != null); }
    public boolean hasEchoAbility() { return (abilityE != null); }
    public boolean hasEggGroup2() { return (compatibility.length > 1); }
    public boolean hasForms() { return (formNames.length > 0); }
    public boolean hasWildItemCommon() { return (wildItemCommon != null); }
    public boolean hasWildItemUncommon() { return (wildItemUncommon != null); }
    public boolean hasWildItemRare() { return (wildItemRare != null); }
    public boolean hasIncense() { return (incense != null); }
    public boolean hasEvolutionMove() { return (evolutionMove != null); }
    public boolean hasEchoEvolutionMove() { return (echoEvoMove != null); }
    public boolean hasEchoMoveset() { return (echoMoves.size() > 0); }
    public boolean hasColor() { return (color.length() > 0); }

    public void setName(String value) { this.name = value; }
    public void setInternalName(String value) { this.internalName = value; }
    public void setType1(String value) { this.type1 = value; }
    public void setType2(String value) { this.type2 = value; }
    public void setType3(String value) { this.type3 = value; }
    public void setType4(String value) { this.type4 = value; }
    public void setStats(int[] value) { this.stats = value; }
    public void setHP(int value) { stats[0] = value; }
    public void setAttack(int value) { stats[1] = value; }
    public void setDefense(int value) { stats[2] = value; }
    public void setSpeed(int value) { stats[3] = value; }
    public void setSpAtk(int value) { stats[4] = value; }
    public void setSpDef(int value) { stats[5] = value; }
    public void setAbility1(Ability value) { this.ability1 = value; }
    public void setAbility2(Ability value) { this.ability2 = value; }
    public void setHiddenAbility(Ability value) { this.abilityH = value; }
    public void setEchoAbility(Ability value) { this.abilityE = value; }
    public void setEvolutionMove(Move value) { this.evolutionMove = value; }
    public void setEchoEvolutionMove(Move value) { this.echoEvoMove = value; }
    public void setGenderRate(String value) { this.genderRate = value; }
    public void setGrowthRate(String value) { this.growthRate = value; }
    public void setBaseExp(int value) { this.baseExp = value; }
    public void setEffortPoints(int[] value) { this.effortPoints = value; }
    public void setRareness(int value) { this.rareness = value; }
    public void setHappiness(int value) { this.happiness = value; }
    public void setCompatibility(String[] value) { this.compatibility = value; }
    public void setStepsToHatch(int value) { this.stepsToHatch = value; }
    public void setHeight(double value) { this.height = value; }
    public void setWeight(double value) { this.weight = value; }
    public void setWildItemCommon(Item value) { this.wildItemCommon = value; }
    public void setWildItemUncommon(Item value) { this.wildItemUncommon = value; }
    public void setWildItemRare(Item value) { this.wildItemRare = value; }
    public void setIncense(Item value) { this.incense = value; }
    public void setRegionalNumbers(String value) { this.regionalNumbers = value; }
    public void setKind(String value) { this.kind = value; }
    public void setFormNames(String[] value) { this.formNames = value; }
    public void setDexEntry(String value) { this.dexEntry = value; }
    public void setColor(String value) { this.color = value; }
    public void setBattlerPlayerY(int value) { this.battlerPlayerY = value; }
    public void setBattlerEnemyY(int value) { this.battlerEnemyY = value; }
    public void setBattlerAltitude(int value) { this.battlerAltitude = value; }

    public int getID() { return id; }
    public String getName() { return name; }
    public String getInternalName() { return internalName; }
    public String getType1() { return type1; }
    public String getType2() { return type2; }
    public String getType3() { return type3; }
    public String getType4() { return type4; }
    public int[] getStats() { return stats; }
    public int getHP() { return stats[0]; }
    public int getAttack() { return stats[1]; }
    public int getDefense() { return stats[2]; }
    public int getSpeed() { return stats[3]; }
    public int getSpAtk() { return stats[4]; }
    public int getSpDef() { return stats[5]; }
    public Ability getAbility1() { return ability1; }
    public Ability getAbility2() { return ability2; }
    public Ability getHiddenAbility() { return abilityH; }
    public Ability getEchoAbility() { return abilityE; }
    public Move getEvolutionMove() { return evolutionMove; }
    public Move getEchoEvolutionMove() { return echoEvoMove; }
    public String getGenderRate() { return genderRate; }
    public String getGrowthRate() { return growthRate; }
    public int getBaseExp() { return baseExp; }
    public int[] getEffortPoints() { return effortPoints; }
    public int getRareness() { return rareness; }
    public int getHappiness() { return happiness; }
    public String[] getCompatibility() { return compatibility; }
    public int getStepsToHatch() { return stepsToHatch; }
    public double getHeight() { return height; }
    public double getWeight() { return weight; }
    public Item getWildItemCommon() { return wildItemCommon; }
    public Item getWildItemUncommon() { return wildItemUncommon; }
    public Item getWildItemRare() { return wildItemRare; }
    public Item getIncense() { return incense; }
    public String getRegionalNumbers() { return regionalNumbers; }
    public String getKind() { return kind; }
    public String[] getFormNames() { return formNames; }
    public String getDexEntry() { return dexEntry; }
    public String getColor() { return color; }
    public int getBattlerPlayerY() { return battlerPlayerY; }
    public int getBattlerEnemyY() { return battlerEnemyY; }
    public int getBattlerAltitude() { return battlerAltitude; }
    public HashMap<Integer, ArrayList<Move>> getLevelMoves() { return levelMoves; }
    public HashMap<Integer, ArrayList<Move>> getEchoMoves() { return echoMoves; }
    public ArrayList<Move> getEggMoves() { return eggMoves; }

    public ArrayList<String[]> getEvolutionData() {
        return evolutionData;
    }

    @Override
    public String toString() {
        return String.format("#%03d %s", id, name);
    }

    public static String[] genderRates = {
        "AlwaysMale",
        "FemaleOneEighth",
        "Female25Percent",
        "Female50Percent",
        "Female75Percent",
        "FemaleSevenEighths",
        "AlwaysFemale",
        "Genderless"
    };

    public static String[] growthRates = {
        "Erratic (600,000 exp)",
        "Fast (800,000 exp)",
        "Medium (1,000,000 exp)",
        "Parabolic (1,059,860 exp)",
        "Slow (1,250,000 exp)",
        "Fluctuating (1,640,000 exp)"
    };

    public static String[] eggGroups = {
        "Monster",
        "Water1 (Sea Creatures)",
        "Water2 (Fish)",
        "Water3 (Shellfish)",
        "Bug",
        "Flying",
        "Field",
        "Fairy",
        "Grass",
        "Humanlike",
        "Mineral",
        "Amorphous",
        "Ditto",
        "Dragon",
        "Undiscovered"
    };

    public static String[] colors = {
        "Black",
        "Blue",
        "Brown",
        "Gray",
        "Green",
        "Pink",
        "Purple",
        "Red",
        "White",
        "Yellow"
    };

    public static String[] evolutionTypes = {
        "Level",
        "LevelMale",
        "LevelFemale",
        "LevelDay",
        "LevelNight",
        "LevelDarkInParty",
        "LevelRain",
        "HappinessMoveType",
        "Happiness",
        "HappinessDay",
        "HappinessNight",
        "Item",
        "ItemMale",
        "ItemFemale",
        "DayHoldItem",
        "NightHoldItem",
        "HasMove",
        "HasInParty",
        "Location",
        "Trade",
        "TradeItem",
        "TradeSpecies",
        "AttackGreater",
        "AtkDefEqual",
        "DefenseGreater",
        "Silcoon",
        "Cascoon",
        "Ninjask",
        "Shedinja",
        "Beauty"
    };

    public static String evolutionArgType(String type) {
        switch (type) {
            case "Level":
            case "LevelMale":
            case "LevelFemale":
            case "LevelDay":
            case "LevelNight":
            case "LevelDarkInParty":
            case "LevelRain":
            case "AttackGreater":
            case "AtkDefEqual":
            case "DefenseGreater":
            case "Silcoon":
            case "Cascoon":
            case "Ninjask":
            case "Shedinja": {
                return "Level";
            }
            case "HappinessMoveType": {
                return "Type";
            }
            case "Happiness":
            case "HappinessDay":
            case "HappinessNight":
            case "Trade": {
                return "None";
            }
            case "Item":
            case "ItemMale":
            case "ItemFemale":
            case "DayHoldItem":
            case "NightHoldItem":
            case "TradeItem": {
                return "Item";
            }
            case "HasMove": {
                return "Move";
            }
            case "HasInParty":
            case "TradeSpecies": {
                return "Pokemon";
            }
            case "Location":
            case "Beauty": {
                return "Number";
            }
            
        }
        return "";
    }

}