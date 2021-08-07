import java.util.HashMap;
import java.util.ArrayList;

class PartyPokemon {

    private Pokemon pokemon;
    private int level;
    private Item item;
    private Move[] moves;
    private int ability;
    private String gender;
    private int form;
    private boolean shiny;
    private String nature;
    private int IVs;
    private int happiness;
    private String nickname;
    private boolean shadow;
    private int ballType;
    private int[] EVs;

    public PartyPokemon(Pokemon pokemon, int level) {
        this.pokemon = pokemon;
        this.level = level;
        this.moves = new Move[4];
        this.ability = 0;
        this.gender = "";
        this.form = 0;
        this.shiny = false;
        this.nature = "";
        this.IVs = 10;
        this.happiness = 70;
        this.nickname = "";
        this.shadow = false;
        this.ballType = 0;
        this.EVs = new int[6];
        for (int i = 0; i < 6; i++) {
            this.EVs[i] = -1;
        }
    }
    
    public boolean addMove(Move move) {
        for (int i = 0; i < moves.length; i++) {
            if (moves[i] == null) {
                moves[i] = move;
                return true;
            }
        }
        return false;
    }
    
    public boolean removeMove(Move move) {
        boolean found = false;
        for (int i = 0; i < moves.length; i++) {
            if (moves[i] == move && !found) {
                found = true;
                moves[i] = null;
            } else if (found) {
                moves[i - 1] = moves[i];
                moves[i] = null;
            }
        }
        return found;
    }

    public boolean hasItem() { return (item != null); }

    public Pokemon getPokemon() { return pokemon; }
    public int getLevel() { return level; }
    public Item getItem() { return item; }
    public Move[] getMoves() { return moves; }
    public int getAbility() { return ability; }
    public String getGender() { return gender; }
    public int getForm() { return form; }
    public boolean isShiny() { return shiny; }
    public String getNature() { return nature; }
    public int getIVs() { return IVs; }
    public int getHappiness() { return happiness; }
    public String getNickname() { return nickname; }
    public boolean isShadow() { return shadow; }
    public int getBallType() { return ballType; }
    public int[] getEVs() { return EVs; }
    public int getEV(int index) { return EVs[index]; }
    
    public void setPokemon(Pokemon value) { this.pokemon = value; }
    public void setLevel(int value) { this.level = value; }
    public void setItem(Item value) { this.item = value; }
    public void setMoves(Move[] value) { this.moves = value; }
    public void setAbility(int value) { this.ability = value; }
    public void setGender(String value) { this.gender = value; }
    public void setForm(int value) { this.form = value; }
    public void setShiny(boolean value) { this.shiny = value; }
    public void setNature(String value) { this.nature = value; }
    public void setIVs(int value) { this.IVs = value; }
    public void setHappiness(int value) { this.happiness = value; }
    public void setNickname(String value) { this.nickname = value; }
    public void setShadow(boolean value) { this.shadow = value; }
    public void setBallType(int value) { this.ballType = value; }
    public void setEVs(int[] value) { this.EVs = value; }
    public void setEV(int index, int value) { this.EVs[index] = value; }

    public void setBaseMoveset() {
        this.moves = new Move[4];
        HashMap<Integer, ArrayList<Move>> levelMoves = pokemon.getLevelMoves();
        for (int i = 100; i >= 1; i--) {
            if (levelMoves.containsKey(i)) {
                ArrayList<Move> moves = levelMoves.get(i);
                for (int j = moves.size() - 1; j >= 0; j--) {
                    if (!addMove(moves.get(j))) {
                        return;
                    }
                }
            }
        }
    }

    public Ability getAbilityClass() {
        if (ability == 2 && pokemon.hasHiddenAbility()) {
            return pokemon.getHiddenAbility();
        } else if (ability == 1 && pokemon.hasAbility2()) {
            return pokemon.getAbility2();
        } else {
            return pokemon.getAbility1();
        }
    }

    public Ability getAbilityClass(int ability) {
        if (ability == 2 && pokemon.hasHiddenAbility()) {
            return pokemon.getHiddenAbility();
        } else if (ability == 1 && pokemon.hasAbility2()) {
            return pokemon.getAbility2();
        } else {
            return pokemon.getAbility1();
        }
    }

    @Override
    public String toString() {
        return pokemon.toString();
    }

    public String getMoveString() {
        String moveString = "Default Moveset";
        if (moves[0] != null) {
            moveString = moves[0].toString();
            for (int i = 1; i < 4; i++) {
                if (moves[i] != null) {
                    moveString += ", " + moves[i].toString();
                }
            }
        }
        return moveString;
    }

    public String getSummary() {
        String moveString = getMoveString();
        return String.format("Lv%3d %s | %s | %s\n        Moves: %s",
            level, pokemon.getName(), hasItem() ? item : "No Item", getAbilityClass(), moveString);
    }

    public String getFullSummary() {
        String moveString = getMoveString();
        String summary = String.format("Lv%3d %s %s| %s | %s\n        | Moves: %s",
            level, pokemon.getName(), gender.length() > 0 ? "(" + gender + ") " : "",
            hasItem() ? item : "No Item", getAbilityClass(), moveString);
        if (shiny || form != 0 || nature.length() > 0 || IVs != 10 || happiness != 70 ||
            nickname.length() > 0 || shadow || ballType != 0) {
            ArrayList<String> fields = new ArrayList<>();
            if (nickname.length() > 0) {
                fields.add("Nickname: " + nickname);
            }
            if (nature.length() > 0) {
                fields.add("Nature: " + nature);
            }
            if (shiny) {
                fields.add("Shiny");
            }
            if (shadow) {
                fields.add("Shadow");
            }
            if (form != 0) {
                fields.add(String.format("Form: %d", form));
            }
            if (IVs != 0) {
                fields.add(String.format("IVs: %d", IVs));
            }
            if (EVs[0] >= 0) {
                fields.add(String.format("EVs: %d/%d/%d/%d/%d/%d", EVs[0], EVs[1], EVs[2], EVs[3], EVs[4], EVs[5]));
            }
            if (happiness != 70) {
                fields.add(String.format("Happiness: %d", happiness));
            }
            if (ballType != 0) {
                fields.add(String.format("Ball Type: %d", ballType));
            }
            for (int i = 0; i < fields.size(); i++) {
                if (i % 3 == 0) {
                    summary += "\n        ";
                }
                summary += "| " + fields.get(i) + " ";
            }
        }
        return summary;
    }

    public void setDefaultMoveset() {

        HashMap<Integer, ArrayList<Move>> moveset = pokemon.getLevelMoves();

        for (int i = 0; i <= 100; i++) {
            if (level >= i) {
                if (moveset.containsKey(i)) {
                    for (Move m : moveset.get(i)) {
    
                        if (!addMove(m)) {
                            for (int j = 0; j <= 2; j++) {
                                moves[j] = moves[j + 1]; 
                            }
                            moves[3] = null;
                            addMove(m);
                        }
    
                    }
                }
            }
        }

    }

    public PartyPokemon clone() {

        PartyPokemon pkmn = new PartyPokemon(pokemon, level);

        for (int i = 0; i < 4; i++) {
            pkmn.getMoves()[i] = moves[i];
        }
        pkmn.ability = ability;
        pkmn.gender = "" + gender;
        pkmn.form = form;
        pkmn.shiny = shiny;
        pkmn.nature = "" + nature;
        pkmn.IVs = IVs;
        pkmn.happiness = happiness;
        pkmn.nickname = "" + nickname;
        pkmn.shadow = shadow;
        pkmn.ballType = ballType;

        return pkmn;
    }

}