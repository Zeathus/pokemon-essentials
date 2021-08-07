class Encounter {

    private Pokemon pokemon;
    private int minLevel;
    private int maxLevel;
    private int form;

    public Encounter(Pokemon pokemon, int minLevel, int maxLevel) {
        this.pokemon = pokemon;
        this.minLevel = minLevel;
        this.maxLevel = maxLevel;
        this.form = -1;
    }

    public Pokemon getPokemon() {return pokemon;}
    public int getMinLevel() {return minLevel;}
    public int getMaxLevel() {return maxLevel;}
    public int getForm() {return form;}
    public boolean hasForm() {return form >= 0;}

    public void setPokemon(Pokemon pokemon) {this.pokemon = pokemon;}
    public void setMinLevel(int level) {this.minLevel = level;}
    public void setMaxLevel(int level) {this.maxLevel = level;}
    public void setForm(int form) {this.form = form;}

}