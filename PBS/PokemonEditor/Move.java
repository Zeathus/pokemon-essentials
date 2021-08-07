class Move implements Internal {

    private int id;
    private String name;
    private String internalName;
    private String function;
    private int power;
    private int accuracy;
    private int pp;
    private String type;
    private String category;
    private int effectChance;
    private String target;
    private int priority;
    private String flags;
    private String description;

    public Move(int id) {

        this.id = id;
        this.name = "";
        this.internalName = "";
        this.function = "000";
        this.power = 0;
        this.accuracy = 100;
        this.pp = 10;
        this.type = "NORMAL";
        this.category = "Status";
        this.effectChance = 0;
        this.target = "00";
        this.priority = 0;
        this.flags = "";
        this.description = "";

    }

    public Move(int id, String name, String internalName, String function,
            int power, int accuracy, int pp, String type, String category,
            int effectChance, String target, int priority, String flags, String description) {

        this.id = id;
        this.name = name;
        this.internalName = internalName;
        this.function = function;
        this.power = power;
        this.accuracy = accuracy;
        this.pp = pp;
        this.type = type;
        this.category = category;
        this.effectChance = effectChance;
        this.target = target;
        this.priority = priority;
        this.flags = flags;
        this.description = description;

    }

    public void printInfo() {

        System.out.printf("#%d %s\n-------------------\n", getID(), getName());

        System.out.printf("Internal Name: %s\n", internalName);
        System.out.printf("Type: %s\n", type);
        System.out.printf("Category: %s\n", category);
        System.out.printf("Power: %d\n", power);
        System.out.printf("Accuracy: %d\n", accuracy);
        System.out.printf("PP: %d\n", pp);
        if (priority != 0) {
            System.out.printf("Priority: %d\n", priority);
        }
        System.out.printf("Function: %s\n", function);
        System.out.printf("Target: %s (%s)\n", target, Target.getTargetName(target));
        if (flags.length() <= 0) {
            System.out.printf("Flags: None\n");
        } else {
            System.out.printf("Flags: -%c (%s)\n", flags.charAt(0), Flags.getFlagName(flags.charAt(0)));
            for (int i = 1; i < flags.length(); i++) {
                System.out.printf("       -%c (%s)\n", flags.charAt(i), Flags.getFlagName(flags.charAt(i)));
            }
        }
        if (effectChance > 0) {
            System.out.printf("Effect Chance: %d%c\n", effectChance, '%');
        }
        System.out.printf("Description: %s\n", description);

    }

    public boolean hasFlag(char flag) {
        for (int i = 0; i < flags.length(); i++) {
            if (flags.charAt(i) == flag) {
                return true;
            }
        }
        return false;
    }
    
    public void setID(int value) { this.id = value; }
    public void setName(String value) { this.name = value; }
    public void setInternalName(String value) { this.internalName = value; }
    public void setFunction(String value) { this.function = value; }
    public void setPower(int value) { this.power = value; }
    public void setAccuracy(int value) { this.accuracy = value; }
    public void setPP(int value) { this.pp = value; }
    public void setType(String value) { this.type = value; }
    public void setCategory(String value) { this.category = value; }
    public void setEffectChance(int value) { this.effectChance = value; }
    public void setTarget(String value) { this.target = value; }
    public void setPriority(int value) { this.priority = value; }
    public void setFlags(String value) { this.flags = value; }
    public void setDescription(String value) { this.description = value; }

    public int getID() { return this.id; }
    public String getName() { return this.name; }
    public String getInternalName() { return this.internalName; }
    public String getFunction() { return this.function; }
    public int getPower() { return this.power; }
    public int getAccuracy() { return this.accuracy; }
    public int getPP() { return this.pp; }
    public String getType() { return this.type; }
    public String getCategory() { return this.category; }
    public int getEffectChance() { return this.effectChance; }
    public String getTarget() { return this.target; }
    public int getPriority() { return this.priority; }
    public String getFlags() { return this.flags; }
    public String getDescription() { return this.description; }

    @Override
    public String toString() {
        return String.format("%s", name);
    }

}