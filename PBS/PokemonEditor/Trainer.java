import java.util.ArrayList;

class Trainer {

    private TrainerType trainerType;
    private String name;
    private int version;
    private ArrayList<Item> items;
    private ArrayList<PartyPokemon> party;
    private String comment;

    public Trainer(TrainerType trainerType, String name) {
        this.trainerType = trainerType;
        this.name = name;
        this.version = 0;
        this.items = new ArrayList<>();
        this.party = new ArrayList<>();
        this.comment = "";
    }

    public boolean addItem(Item item) {
        if (items.size() < 8) {
            items.add(item);
            return true;
        }
        return false;
    }

    public void removeItem(int index) {
        if (index >= 0 && index < items.size()) {
            items.remove(index);
        }
    }

    public boolean addPokemon(PartyPokemon pokemon) {
        if (party.size() < 6) {
            party.add(pokemon);
            return true;
        }
        return false;
    }

    public boolean removePokemon(int index) {
        if (party.size() > 1) {
            if (index > 0 && index < party.size()) {
                party.remove(index);
            }
            return true;
        }
        return false;
    }

    public boolean hasComment() { return (comment.length() > 0); }
    public boolean hasItems() { return (items.size() > 0); }

    public TrainerType getTrainerType() { return trainerType; }
    public String getName() { return name; }
    public int getVersion() { return version; }
    public ArrayList<Item> getItems() { return items; }
    public ArrayList<PartyPokemon> getParty() { return party; }
    public String getComment() { return comment; }

    public void setTrainerType(TrainerType value) { this.trainerType = value; }
    public void setName(String value) { this.name = value; }
    public void setVersion(int value) { this.version = value; }
    public void setItems(ArrayList<Item> value) { this.items = value; }
    public void setParty(ArrayList<PartyPokemon> value) { this.party = value; }
    public void setComment(String value) { this.comment = value; }

    @Override
    public String toString() {
        return String.format("%s %s (%s)", trainerType, name, version);
    }

    public void printInfo() {

        System.out.printf("%s\n-------------------\n", toString());

        System.out.printf("Comment: %s\n", hasComment() ? comment : "None");
        if (hasItems()) {
            System.out.printf("Items: %s" + items.get(0));
            for (int i = 1; i < items.size(); i++) {
                System.out.printf(", %s", items.get(i));
            }
            System.out.printf("\n");
        } else {
            System.out.printf("Items: %s\n", "None");
        }
        if (party.size() > 0) {
            System.out.println("Party: ");
            for (PartyPokemon p : party) {
                System.out.printf("  %s\n", p.getSummary());
            }
        }
    }

    public Trainer clone() {

        Trainer clone = new Trainer(trainerType, name);

        clone.version = version;
        for (Item i : items) {
            clone.addItem(i);
        }
        for (PartyPokemon p : party) {
            clone.addPokemon(p.clone());
        }
        clone.comment = "" + comment;

        return clone;

    }

}