class Flags {

    public static char[] flagCodes = {
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n'
    };

    public static String[] flagNames = {
        "The move makes physical contact with the target",
        "The target can use Protect or Detect to protect itself from the move",
        "The target can use Magic Coat to redirect the move",
        "The target can use Snatch to steal the effect of the move",
        "The move can be copied by Mirror Move",
        "The move has a 10% chance of flinching when holding a King's Rock",
        "If the user is frozen, the move will thaw it out before it is used",
        "The move has a high critical hit rate",
        "The move is a biting move (Strong Jaw)",
        "The move is a punching move (Iron Fist)",
        "The move is a sound-based move (Soundproof)",
        "The move is a powder-based move (Grass-type immunity)",
        "The move is a pulse-based move (Mega Launcher)",
        "The move is a bomb-based move (Bulletproof)"
    };

    public static String getFlagName(char flag) {

        for (int i = 0; i < flagCodes.length; i++) {
            if (flagCodes[i] == flag) {
                return flagNames[i];
            }
        }

        return "n/a";
    }

    public static boolean isFlag(char flag) {

        for (char c : flagCodes) {
            if (c == flag) {
                return true;
            }
        }

        return false;
    }

}