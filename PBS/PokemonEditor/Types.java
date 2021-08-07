class Types {

    public static String[] types = {
        "NORMAL",
        "FIGHTING",
        "FLYING",
        "POISON",
        "GROUND",
        "ROCK",
        "BUG",
        "GHOST",
        "STEEL",
        "FAIRY",
        "FIRE",
        "WATER",
        "GRASS",
        "ELECTRIC",
        "PSYCHIC",
        "ICE",
        "DRAGON",
        "DARK",
        "QMARKS",
        "SHADOW",
        "BIRD"
    };

    public static boolean isType(String type) {
        for (int i = 0; i < types.length; i++) {
            if (type.equals(types[i])) {
                return true;
            }
        }
        return false;
    }

}