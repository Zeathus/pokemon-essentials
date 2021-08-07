import java.util.ArrayList;

class TM {

    private Move move;
    private ArrayList<Pokemon> pokemonList;

    public TM(Move move) {
        this.move = move;
        this.pokemonList = new ArrayList<>();
    }

    public void addPokemonSingle(Pokemon pokemon) {
        if (!pokemonList.contains(pokemon)) {
            pokemonList.add(pokemon);
        }
    }

    public void addPokemon(Pokemon pokemon) {
        addPokemonSingle(pokemon);
        for (Pokemon p : pokemon.getEvolutions()) {
            addPokemonSingle(p);
            for (Pokemon p2 : p.getEvolutions()) {
                addPokemonSingle(p2);
                for (Pokemon p3 : p2.getEvolutions()) {
                    addPokemonSingle(p3);
                }
            }
        }
    }

    public ArrayList<Pokemon> getPokemon() {
        return pokemonList;
    }

    public Move getMove() {
        return move;
    }

    public boolean removePokemon(Pokemon pokemon) {
        if (pokemonList.contains(pokemon)) {
            pokemonList.remove(pokemon);
            return true;
        }
        return false;
    }

    public boolean hasPokemon(Pokemon pokemon) {
        return pokemonList.contains(pokemon);
    }

}