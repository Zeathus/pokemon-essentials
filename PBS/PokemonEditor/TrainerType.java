class TrainerType implements Internal {

    int id;
    String internalName;
    String name;
    int baseMoney;
    String battleBGM;
    String victoryBGM;
    String introME;
    String gender;
    int skillLevel;
    String skillCode;

    public TrainerType(int id, String internalName, String name) {

        this.id = id;
        this.internalName = internalName;
        this.name = name;
        this.baseMoney = 30;
        this.battleBGM = "";
        this.victoryBGM = "";
        this.introME = "";
        this.gender = "Mixed";
        this.skillLevel = 0;
        this.skillCode = "";

    }

    public boolean hasBattleBGM() { return (battleBGM.length() > 0); }
    public boolean hasVictoryBGM() { return (victoryBGM.length() > 0); }
    public boolean hasIntroME() { return (introME.length() > 0); }
    public boolean hasSkillCode() { return (skillCode.length() > 0); }

    public int getID() { return id; }
    public String getInternalName() { return internalName; }
    public String getName() { return name; }
    public int getBaseMoney() { return baseMoney; }
    public String getBattleBGM() { return battleBGM; }
    public String getVictoryBGM() { return victoryBGM; }
    public String getIntroME() { return introME; }
    public String getGender() { return gender; }
    public int getSkillLevel() { return skillLevel; }
    public String getSkillCode() { return skillCode; }
    
    public void setInternalName(String value) { this.internalName = value; }
    public void setName(String value) { this.name = value; }
    public void setBaseMoney(int value) { this.baseMoney = value; }
    public void setBattleBGM(String value) { this.battleBGM = value; }
    public void setVictoryBGM(String value) { this.victoryBGM = value; }
    public void setIntroME(String value) { this.introME = value; }
    public void setGender(String value) { this.gender = value; }
    public void setSkillLevel(int value) { this.skillLevel = value; }
    public void setSkillCode(String value) { this.skillCode = value; }

    @Override
    public String toString() {
        return this.internalName;
    }

}