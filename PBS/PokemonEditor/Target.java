class Target {

    public static String[] targetCodes = {
        "00",
        "01",
        "02",
        "04",
        "08",
        "10",
        "20",
        "40",
        "80",
        "100",
        "200",
        "400",
        "800"
    };

    public static String[] targetNames = {
        "Single Pokemon other than user",
        "No target (Counter, Metal Burst, etc)",
        "Single opposing Pokemon at random",
        "All opposing Pokemon",
        "All Pokemon other than the user",
        "User",
        "Both sides (Weather, etc)",
        "User's side (Reflect, etc)",
        "Opposing side (Spikes, etc)",
        "User's partner (Helping Hand)",
        "Single Pokemon on user's side (Acupressure)",
        "Single opposing Pokemon (Me First)",
        "Single opposing Pokemon directly opposite of user"
    };

    public static String getTargetName(String target) {

        for (int i = 0; i < targetCodes.length; i++) {
            if (targetCodes[i].equals(target)) {
                return targetNames[i];
            }
        }

        return "n/a";
    }

    public static boolean isTargetCode(String code) {
        for (String s : targetCodes) {
            if (s.equals(code)) {
                return true;
            }
        }
        return false;
    }

}