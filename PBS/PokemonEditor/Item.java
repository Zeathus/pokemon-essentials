class Item implements Internal {

    private int id;
    private String internalName;
    private String name;
    private String pluralName;
    private int pocket;
    private int price;
    private String description;
    private int useField;
    private int useBattle;
    private int specialItem;
    private Move tm;

    public Item(int id) {
        this.id = id;
        this.internalName = "";
        this.name = "";
        this.pluralName = "";
        this.pocket = 1;
        this.price = 0;
        this.description = "";
        this.useField = 0;
        this.useBattle = 0;
        this.specialItem = 0;
        this.tm = null;
    }

    public Item(int id, String internalName, String name, String pluralName, int pocket,
            int price, String description, int useField, int useBattle, int specialItem) {
        this.id = id;
        this.internalName = internalName;
        this.name = name;
        this.pluralName = pluralName;
        this.pocket = pocket;
        this.price = price;
        this.description = description;
        this.useField = useField;
        this.useBattle = useBattle;
        this.specialItem = specialItem;
        this.tm = null;
    }

    public void printInfo() {

        System.out.printf("#%d %s\n-------------------\n", getID(), getName());

        System.out.printf("Plural Name: %s\n", pluralName);
        System.out.printf("Internal Name: %s\n", internalName);
        System.out.printf("Pocket: %d (%s)\n", pocket, pocketNames[pocket]);
        System.out.printf("Price: %d\n", price);
        System.out.printf("Use Field: %d (%s)\n", useField, usesField[useField]);
        System.out.printf("Use Battle: %d (%s)\n", useBattle, usesBattle[useBattle]);
        System.out.printf("Special Item: %d (%s)\n", specialItem, specialItems[specialItem]);
        if (isTM() && hasTM()) {
            System.out.printf("TM Move: %s\n", tm);
        }
        System.out.printf("Description: %s\n", description);

    }

    public boolean isTM() {
        return (useField == 3 || useField == 4);
    }

    public boolean hasTM() {
        return (tm != null);
    }

    public int getID() { return id; }
    public String getInternalName() { return internalName; }
    public String getName() { return name; }
    public String getPluralName() { return pluralName; }
    public int getPocket() { return pocket; }
    public int getPrice() { return price; }
    public String getDescription() { return description; }
    public int getUseField() { return useField; }
    public int getUseBattle() { return useBattle; }
    public int getSpecialItem() { return specialItem; }
    public Move getTM() { return tm; }

    public void setInternalName(String value) { this.internalName = value; }
    public void setName(String value) { this.name = value; }
    public void setPluralName(String value) { this.pluralName = value; }
    public void setPocket(int value) { this.pocket = value; }
    public void setPrice(int value) { this.price = value; }
    public void setDescription(String value) { this.description = value; }
    public void setUseField(int value) { this.useField = value; }
    public void setUseBattle(int value) { this.useBattle = value; }
    public void setSpecialItem(int value) { this.specialItem = value; }
    public void setTM(Move value) { this.tm = value; }

    @Override
    public String toString() {
        return name;
    }
    
    public static String[] pocketNames = {
        "Items",
        "Medicine",
        "Poke Balls",
        "TMs & HMs",
        "Berries",
        "Gems",
        "Battle Items",
        "Key Items"
    };

    public static String[] usesField = {
        "Cannot be used outside of battle",
        "Can be used once on a Pokemon (Potion, etc.)",
        "Can be used out of battle (Repel, etc.)",
        "The item is a TM",
        "The item is an HM",
        "Can be used infinitely on a Pokemon (Poke Flute, etc.)"
    };

    public static String[] usesBattle = {
        "Cannot be used in battle",
        "Can be used once on a Pokemon (Potion, etc.)",
        "Is a Poke Ball or Battle Item (X Attack, etc.)",
        "Can be used infinitely on a Pokemon (Poke Flute, etc.)",
        "Can be used directly and infinitely",
    };

    public static String[] specialItems = {
        "Not a special item",
        "Mail item",
        "Mail item with images",
        "Snag Ball",
        "Poke Ball",
        "Berry that can be planted",
        "Key Item",
        "Evolution Stone",
        "Fossil",
        "Apricorn",
        "Elemental Gem",
        "Mulch",
        "Mega Stone"
    };

}