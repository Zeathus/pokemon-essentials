class Natures {

    public static String[] natures = {
        "HARDY",    // 0
        "LONELY",   // 1
        "BRAVE",    // 2
        "ADAMANT",  // 3
        "NAUGHTY",  // 4
        "BOLD",     // 5
        "DOCILE",   // 6
        "RELAXED",  // 7
        "IMPISH",   // 8
        "LAX",      // 9
        "TIMID",    // 10
        "HASTY",    // 11
        "SERIOUS",  // 12
        "JOLLY",    // 13
        "NAIVE",    // 14
        "MODEST",   // 15
        "MILD",     // 16
        "QUIET",    // 17
        "BASHFUL",  // 18
        "RASH",     // 19
        "CALM",     // 20
        "GENTLE",   // 21
        "SASSY",    // 22
        "CAREFUL",  // 23
        "QUIRKY"    // 24
    };

    public static String[] stats = {
        "ATTACK",
        "DEFENSE",
        "SPEED",
        "SP.ATK",
        "SP.DEF"
    };

    public static int getStatID(String stat) {
        for (int i = 0; i < stats.length; i++) {
            if (stat.equals(stats[i])) {
                return i;
            }
        }
        return -1;
    }

    public static boolean isStat(String stat) {
        for (int i = 0; i < stats.length; i++) {
            if (stat.equals(stats[i])) {
                return true;
            }
        }
        return false;
    }

    public static boolean isNature(String nature) {
        for (int i = 0; i < natures.length; i++) {
            if (nature.equals(natures[i])) {
                return true;
            }
        }
        return false;
    }

    public static String upStat(String nature) {
        int id = -1;
        for (int i = 0; i < natures.length; i++) {
            if (nature.equals(nature)) {
                id = i;
            }
        }
        String upStat = stats[(int) Math.floor(id / 5)];
        String downStat = stats[id % 5];
        if (upStat.equals(downStat)) {
            return "None";
        } else {
            return upStat;
        }
    }

    public static String downStat(String nature) {
        int id = -1;
        for (int i = 0; i < natures.length; i++) {
            if (nature.equals(nature)) {
                id = i;
            }
        }
        String upStat = stats[(int) Math.floor(id / 5)];
        String downStat = stats[id % 5];
        if (upStat.equals(downStat)) {
            return "None";
        } else {
            return downStat;
        }
    }

    public static String upDownStat(String nature) {
        int id = -1;
        for (int i = 0; i < natures.length; i++) {
            if (nature.equals(nature)) {
                id = i;
            }
        }
        String upStat = stats[(int) Math.floor(id / 5)];
        String downStat = stats[id % 5];
        if (upStat.equals(downStat)) {
            return "None";
        } else {
            return String.format("+%s/-%s", upStat, downStat);
        }
    }

}