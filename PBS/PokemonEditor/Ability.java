class Ability implements Internal {

    private int id;
    private String name;
    private String internalName;
    private String description;

    public Ability(int id, String name, String internalName, String description) {
        this.id = id;
        this.name = name;
        this.internalName = internalName;
        this.description = description;
    }

    public void setName(String value) { this.name = value; }
    public void setInternalName(String value) { this.internalName = value; }
    public void setDescription(String value) { this.description = value; }

    public int getID() { return this.id; }
    public String getName() { return this.name; }
    public String getInternalName() { return this.internalName; }
    public String getDescription() { return this.description; }

    @Override
    public String toString() {
        return String.format("%s", name);
    }

}