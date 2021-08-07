import java.util.ArrayList;
import java.util.HashMap;

class EncounterList {

    private int mapId;
    private String mapName;
    private HashMap<String, ArrayList<Encounter>> encounters;
    public static final String[] types = {
        "Land", "Land2", "Land3", "Land4", "LandNight", "LandMorning", "LandDay",
        "Cave", "Water", "RockSmash", "FishingRod", "Swamp", "Flowers",
        "HeadbuttLow", "HeadbuttHigh", "BugContest"
    };

    public EncounterList(int mapId, String mapName) {
        this.mapId = mapId;
        this.mapName = mapName;
        this.encounters = new HashMap<>();
    }

    public int getMapId() {return mapId;}
    public String getMapName() {return mapName;}
    public HashMap<String, ArrayList<Encounter>> getEncounters() {return encounters;}

    public void setMapId(int id) {this.mapId = id;}
    public void setMapName(String name) {this.mapName = name;}
    public boolean addEncounter(String type, Encounter encounter) {
        if (!isEncounterType(type)) {
            return false;
        }
        if (!encounters.containsKey(type)) {
            encounters.put(type, new ArrayList<>());
        }
        encounters.get(type).add(encounter);
        return true;
    }

    public static boolean isEncounterType(String type) {
        for (String s : types) {
            if (s.equals(type)) {
                return true;
            }
        }
        return false;
    }

}