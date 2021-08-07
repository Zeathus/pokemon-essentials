import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

class PokemonEditor {

    private static boolean echoes;
    private static PokemonSystem pokedex;
    private static Scanner scanner;
    public static void main(String[] args) {

        clear();

        if (args.length >= 1) {
            if (args[0].equals("0")) {
                echoes = false;
            } else {
                echoes = true;
            }
        } else {
            echoes = false;
        }

        System.out.printf("Booting in %s mode...\n", echoes ? "Echoes" : "Vagabond");

        pokedex = new PokemonSystem(echoes,
            "../pokemon.txt",
            "../moves.txt",
            "../abilities.txt",
            "../items.txt",
            "../trainertypes.txt",
            "../trainers.txt",
            "../tm.txt",
            "../encounters.txt");

        scanner = new Scanner(System.in);

        pause();
        
        mainMenu();

        scanner.close();

        clear();
    }

    private static void pause() {
        System.out.println("Press ENTER to continue...");
        scanner.nextLine();
    }

    private static void mainMenu() {

        String[] choices = {"Exit", "Save", "Select Pokemon", "Select Move", "Select Item",
            "Select Trainer by Name", "Select Trainer by Type", "Select Trainer by Comment", "Add New...", "Mass-Edit Evolution Moves", "Mass-Edit Affinities"};

        for (int i = 0; i < choices.length; i++) {
            System.out.printf("%d) %s\n", i, choices[i]);
        }

        String command;
        loop: while (true) {
            command = menu("POKEMON EDITOR", choices);
            switch (command) {
                case "Exit": {
                    clear();
                    System.out.println("0) Save to source file and exit");
                    System.out.println("1) Save to new file and exit");
                    System.out.println("99) Exit without saving");
                    System.out.print("\nChoice: ");
                    int choice = readInt();
                    if (choice == 0) {
                        if (saveSourceFile()) {
                            System.out.println("Exitting program...");
                            break loop;
                        } else {
                            System.out.println("Error while saving, cancelling exit.");
                        }
                    } else if (choice == 1) {
                        if (saveNewFile()) {
                            System.out.println("Exitting program...");
                            break loop;
                        } else {
                            System.out.println("Error while saving, cancelling exit.");
                        }
                    } else if (choice == 99) {
                        System.out.println("Exitting program...");
                        break loop;
                    }
                    break;
                }
                case "Select Trainer by Name": {
                    trainerMenu(0, null);
                    break;
                }
                case "Select Trainer by Type": {
                    trainerMenu(1, null);
                    break;
                }
                case "Select Trainer by Comment": {
                    trainerMenu(2, null);
                    break;
                }
                case "Select Pokemon": {
                    pokemonMenu();
                    break;
                }
                case "Select Move": {
                    moveMenu();
                    break;
                }
                case "Select Item": {
                    itemMenu();
                    break;
                }
                case "Add New...": {
                    addMenu();
                    break;
                }
                case "Mass-Edit Evolution Moves": {
                    editEvolutionMoves();
                    break;
                }
                case "Mass-Edit Affinities": {
                    editAffinities();
                    break;
                }
                case "Save": {
                    save: while (true) {
                        String[] saveChoices = {"Cancel", "Overwrite base file", "Write to new files", "Create docs"};
                        command = menu("Save File", saveChoices);
                        switch (command) {
                            case "Cancel": {
                                break save;
                            }
                            case "Overwrite base file": {
                                saveSourceFile();
                                break save;
                            }
                            case "Write to new files": {
                                saveNewFile();
                                break save;
                            }
                            case "Create docs": {
                                pokedex.createDocs();
                                pause();
                                break save;
                            }
                        }
                    }
                }
            }
        }

    }
    
    private static boolean saveSourceFile() {
        boolean ret = true;
        String currentFile = "";
        try {
            currentFile = "pokemon.txt";
            File pokemonFile = new File("../pokemon.txt");
            if (pokedex.savePokemonFile(pokemonFile)) {
                System.out.println("Saved pokemon to pokemon.txt");
            } else {
                System.out.println("ERROR: Failed to save pokemon");
                ret = false;
            }
            currentFile = "moves.txt";
            File movesFile = new File("../moves.txt");
            if (pokedex.saveMovesFile(movesFile)) {
                System.out.println("Saved moves to moves.txt");
            } else {
                System.out.println("ERROR: Failed to save moves");
                ret = false;
            }
            currentFile = "abilities.txt";
            File abilitiesFile = new File("../abilities.txt");
            if (pokedex.saveAbilitiesFile(abilitiesFile)) {
                System.out.println("Saved abilities to abilities.txt");
            } else {
                System.out.println("ERROR: Failed to save abilities");
                ret = false;
            }
            currentFile = "items.txt";
            File itemsFile = new File("../items.txt");
            if (pokedex.saveItemsFile(itemsFile)) {
                System.out.println("Saved items to items.txt");
            } else {
                System.out.println("ERROR: Failed to save items");
                ret = false;
            }
            currentFile = "tm.txt";
            File tmFile = new File("../tm.txt");
            if (pokedex.saveTMFile(tmFile)) {
                System.out.println("Saved items to tm.txt");
            } else {
                System.out.println("ERROR: Failed to save tms");
                ret = false;
            }
            currentFile = "trainers.txt";
            File trainersFile = new File("../trainers.txt");
            if (pokedex.saveTrainersFile(trainersFile)) {
                System.out.println("Saved trainers to trainers.txt");
            } else {
                System.out.println("ERROR: Failed to save trainers");
                ret = false;
            }
            currentFile = "encounters.txt";
            File encounterFile = new File("../encounters.txt");
            if (pokedex.saveEncounterFile(encounterFile)) {
                System.out.println("Saved encounters to encounters.txt");
            } else {
                System.out.println("ERROR: Failed to save encounters");
                ret = false;
            }
        } catch (Exception e) {
            System.out.println("--- WARNING ---");
            System.out.printf("Something went wrong while saving %s.\n", currentFile);
            System.out.println("The PBS file became corrupted as it did not save properly.");
            pokedex.restoreBackup();
            System.out.println("Restored backup of previous version of PBS files to fix corruption.");
            System.out.printf("Ensure that all required fields in %s are filled and try to save again.\n\n", currentFile);

            System.out.println("Stack Trace:");
            e.printStackTrace();
            ret = false;
        }
        pause();
        return ret;
    }

    private static boolean saveNewFile() {
        boolean ret = true;
        String currentFile = "";
        try {
            currentFile = "pokemon.txt";
            File pokemonFile = new File("../pokemon_new.txt");
            if (pokedex.savePokemonFile(pokemonFile)) {
                System.out.println("Saved pokemon to pokemon_new.txt");
            } else {
                System.out.println("ERROR: Failed to save pokemon");
                ret = false;
            }
            currentFile = "moves.txt";
            File movesFile = new File("../moves_new.txt");
            if (pokedex.saveMovesFile(movesFile)) {
                System.out.println("Saved moves to moves_new.txt");
            } else {
                System.out.println("ERROR: Failed to save moves");
                ret = false;
            }
            currentFile = "abilities.txt";
            File abilitiesFile = new File("../abilities_new.txt");
            if (pokedex.saveAbilitiesFile(abilitiesFile)) {
                System.out.println("Saved abilities to abilities_new.txt");
            } else {
                System.out.println("ERROR: Failed to save abilities");
                ret = false;
            }
            currentFile = "items.txt";
            File itemsFile = new File("../items_new.txt");
            if (pokedex.saveItemsFile(itemsFile)) {
                System.out.println("Saved items to items_new.txt");
            } else {
                System.out.println("ERROR: Failed to save items");
                ret = false;
            }
            currentFile = "tm.txt";
            File tmFile = new File("../tm_new.txt");
            if (pokedex.saveTMFile(tmFile)) {
                System.out.println("Saved items to tm_new.txt");
            } else {
                System.out.println("ERROR: Failed to save tms");
                ret = false;
            }
            currentFile = "trainers.txt";
            File trainersFile = new File("../trainers_new.txt");
            if (pokedex.saveTrainersFile(trainersFile)) {
                System.out.println("Saved trainers to trainers_new.txt");
            } else {
                System.out.println("ERROR: Failed to save trainers");
                ret = false;
            }
            currentFile = "encounters.txt";
            File encounterFile = new File("../encounters_new.txt");
            if (pokedex.saveEncounterFile(encounterFile)) {
                System.out.println("Saved encounters to encounters_new.txt");
            } else {
                System.out.println("ERROR: Failed to save encounters");
                ret = false;
            }
        } catch (Exception e) {
            System.out.println("--- WARNING ---");
            System.out.printf("Something went wrong while saving %s.\n", currentFile);
            System.out.println("The PBS file became corrupted as it did not save properly.");
            System.out.println("No backup was restored as the original PBS files were not overwritten.");
            System.out.printf("Ensure that all required fields in %s are filled and try to save again.\n", currentFile);
            ret = false;
        }
        pause();
        return ret;
    }

    private static boolean editTrainer(Trainer trainer) {
        return editTrainer(trainer, 3, "");
    }

    private static boolean editTrainer(Trainer trainer, int mode, String search) {
        String[] choices = {"Back", "Switch Trainer", "Show Info", "Edit Party", "Edit Items", "Change Comment", "Change Type", "Change Name", "Add Copy of Trainer", "Delete Trainer"};

        if (mode == 3) {
            choices[1] = "Add Another Trainer";
        }

        String command;
        loop: while (true) {
            if (trainer.hasComment()) {
                command = menu(String.format("Checking %s\n%s", trainer, trainer.getComment()), choices);
            } else {
                command = menu(String.format("Checking %s", trainer), choices);
            }
            switch (command) {
                case "Back": {
                    break loop;
                }
                case "Switch Trainer": {
                    if (mode == 0) {
                        if (trainerMenu(mode, trainer.getName())) {
                            break loop;
                        }
                    } else if (mode == 1) {
                        if (trainerMenu(mode, trainer.getTrainerType().getInternalName())) {
                            break loop;
                        }
                    } else if (mode == 2) {
                        if (trainerMenu(mode, search)) {
                            break loop;
                        }
                    } else if (mode == 3) {
                        break loop;
                    }
                    break;
                }
                case "Add Another Trainer": {
                    System.out.println("\nRemember to fill in all fields in the edit menu after adding the new Trainer.");
                    System.out.print("Trainer Type: ");
                    String name = readString();
                    TrainerType type = pokedex.getTrainerType(name);
                    if (type == null && name.length() >= 3) {
                        for (TrainerType t : pokedex.getTrainerTypes()) {
                            if (t.getInternalName().toLowerCase().contains(name.toLowerCase())) {
                                System.out.printf("Did you mean %s? (Type 'y' to confirm)\n", t);
                                if (readString().toLowerCase().equals("y")) {
                                    type = t;
                                    break;
                                }
                            }
                        }
                    }
                    if (type == null) {
                        System.out.println("Invalid trainer type.");
                        pause();
                        break;
                    }
                    System.out.print("Trainer Name: ");
                    name = readString();
                    Trainer newTrainer = new Trainer(type, name);
                    newTrainer.addPokemon(new PartyPokemon(pokedex.getPokemon("DITTO"), 1));
                    newTrainer.setVersion(pokedex.getNextTrainerVersion(name, type));
                    pokedex.addTrainer(newTrainer);
                    editTrainer(newTrainer);
                    break loop;
                }
                case "Show Info": {
                    clear();
                    trainer.printInfo();
                    pause();
                    break;
                }
                case "Edit Party": {
                    editParty(trainer);
                    break;
                }
                case "Edit Items": {
                    editItems(trainer);
                    break;
                }
                case "Change Comment": {
                    System.out.print("Comment: ");
                    String name = readString();
                    if (name.length() > 0) {
                        trainer.setComment(name);
                    }
                    break;
                }
                case "Change Type": {
                    System.out.print("New type: ");
                    String name = readString();
                    TrainerType type = pokedex.getTrainerType(name);
                    if (type == null && name.length() >= 3) {
                        for (TrainerType t : pokedex.getTrainerTypes()) {
                            if (t.getInternalName().toLowerCase().contains(name.toLowerCase())) {
                                System.out.printf("Did you mean %s? (Type 'y' to confirm)\n", t);
                                if (readString().toLowerCase().equals("y")) {
                                    type = t;
                                    break;
                                }
                            }
                        }
                    }
                    if (type == null) {
                        System.out.println("Invalid trainer type.");
                        pause();
                        break;
                    }
                    trainer.setTrainerType(type);
                    break;
                }
                case "Change Name": {
                    System.out.print("New name: ");
                    String name = readString();
                    if (name.length() > 0) {
                        trainer.setName(name);
                    }
                    break;
                }
                case "Add Copy of Trainer": {
                    int id = pokedex.getNextTrainerVersion(trainer.getName(), trainer.getTrainerType());

                    Trainer copy = trainer.clone();
                    copy.setVersion(id);

                    pokedex.addTrainer(copy);

                    System.out.printf("\nCopy of %s added with ID %d\n\n", trainer, copy.getVersion());
                    pause();

                    break;
                }
                case "Delete Trainer": {
                    System.out.println("\nWrite the trainer's name to confirm deletion.");
                    System.out.print("Trainer Name: ");
                    String check = readString();
                    if (check.toLowerCase().equals(trainer.getName().toLowerCase())) {
                        if (pokedex.deleteTrainer(trainer)) {
                            System.out.printf("The trainer '%s' was deleted.\n", trainer);
                            pause();
                            break loop;
                        } else {
                            System.out.println("Failed when trying to delete the trainer.");
                            pause();
                        }
                    } else {
                        System.out.println("The trainer was not deleted.");
                        pause();
                    }
                    break;
                }
            }
        }

        return true;
    }

    private static void editItems(Trainer trainer) {
        
        int input = -1;

        while (input != 0) {
            clear();
            System.out.printf("EDITTING TRAINER %s\n----------------------------------\n\n", trainer);

            System.out.println("Items:");

            int count = 1;
            for (Item i : trainer.getItems()) {
                System.out.printf("%d. %s\n", count, i);
                count++;
            }

            System.out.println("");

            System.out.printf("0) Back\n1) Add Item\n2) Remove Item\n");

            System.out.printf("Choice: ");
            input = readInt();

            if (input == 0) {
                break;
            } else if (input == 1) {
                if (trainer.getItems().size() >= 8) {
                    System.out.println("Trainer cannot have more than 7 items.");
                    pause();
                } else {
                    System.out.printf("Item to add: ");
                    String itemName = readString();
                    Item item = pokedex.getItem(itemName);
                    if (item == null) {
                        System.out.println("Invalid item");
                        pause();
                    } else {
                        trainer.addItem(item);
                    }
                }
            } else if (input == 2) {
                System.out.printf("Item to remove: ");
                int item = readInt();
                if (item > 0 && item <= trainer.getItems().size()) {
                    trainer.removeItem(item - 1);
                } else {
                    System.out.println("Invalid item ID");
                    pause();
                }
            }
        }

    }

    // Mode: 0 = Name, 1 = Type, 2 = Comment
    private static boolean trainerMenu(int mode, String search) {

        ArrayList<Trainer> results;

        if (mode == 0) {
            System.out.print("\nType the Trainer's name: ");
            results = selectTrainersByName(search);
            if (results.size() <= 0) {
                System.out.println("No Trainers exist with this name.");
                pause();
                return false;
            }
        } else if (mode == 1) {
            System.out.print("\nType the Trainer Type's name: ");
            results = selectTrainersByType(search);
            if (results.size() <= 0) {
                System.out.println("No Trainers exist with this type.");
                pause();
                return false;
            }
        } else if (mode == 2) {
            System.out.print("\nType comment search term: ");
            if (search == null) {
                search = readString();
            }
            results = selectTrainersByComment(search);
            if (results.size() <= 0) {
                System.out.println("No Trainers exist with this in their comment.");
                pause();
                return false;
            }
        } else {
            System.out.println("Selection mode is invalid.");
            return false;
        }

        clear();
        System.out.println("Select the trainer you want.");
        System.out.println("(The parentheses contains either the trainer's comment or their levels)\n");
        for (int i = 0; i < results.size(); i++) {
            Trainer t = results.get(i);
            if (t.hasComment()) {
                if (results.size() >= 10) {
                    System.out.printf("%02d) %s (%s)\n", i, t, t.getComment());
                } else {
                    System.out.printf("%d) %s (%s)\n", i, t, t.getComment());
                }
            } else {
                String levels = "No Pokemon";
                if (t.getParty().size() > 0) {
                    levels = Integer.toString(t.getParty().get(0).getLevel());
                    for (int j = 1; j < t.getParty().size(); j++) {
                        levels += "/" + Integer.toString(t.getParty().get(j).getLevel());
                    }
                }
                if (results.size() >= 10) {
                    System.out.printf("%02d) %s (%s)\n", i, t, levels);
                } else {
                    System.out.printf("%d) %s (%s)\n", i, t, levels);
                }
            }
        }

        System.out.print("\nChoice: ");
        int choice = readInt();

        if (choice < 0 || choice >= results.size()) {
            System.out.println("Invalid choice.");
            pause();
            return false;
        }

        Trainer trainer = results.get(choice);

        editTrainer(trainer, mode, search);

        return true;
    }

    private static void editParty(Trainer trainer) {

        ArrayList<PartyPokemon> party = trainer.getParty();

        while (true) {
            clear();
            if (trainer.hasComment()) {
                System.out.printf("Checking %s\n%s\n------------------------\n", trainer, trainer.getComment());
            } else {
                System.out.printf("Checking %s\n------------------------\n", trainer);
            }
    
            System.out.println("0) Back");
            for (int i = 0; i < party.size(); i++) {
                System.out.printf("%d) %s\n", i + 1, party.get(i).getFullSummary());
            }
            if (party.size() < 6) {
                System.out.printf("%d) Add new Pokemon\n", party.size() + 1);
                if (party.size() > 1) {
                    System.out.printf("%d) Delete Pokemon\n", party.size() + 2);
                }
            } else if (party.size() > 1) {
                System.out.printf("%d) Delete Pokemon\n", party.size() + 1);
            }
            
            System.out.print("\nChoice: ");
            int choice = readInt();
            if (choice < 0 || choice > party.size() + 2) {
                System.out.println("Invalid choice.");
                pause();
            } else if (choice == 0) {
                break;
            } else if (choice == party.size() + 1) {
                if (party.size() < 6) {
                    PartyPokemon poke = new PartyPokemon(pokedex.getPokemon("DITTO"), 1);
                    trainer.addPokemon(poke);
                    editPartyPokemon(poke);
                } else {
                    if (party.size() > 1) {
                        System.out.println("Select the Pokemon to delete: ");
                        choice = readInt();
                        if (choice > 0 && choice <= party.size()) {
                            trainer.removePokemon(choice - 1);
                        }
                    } else {
                        System.out.println("Invalid choice.");
                        pause();
                    }
                }
            } else if (choice == party.size() + 2) {
                if (party.size() > 1) {
                    System.out.println("Select the Pokemon to delete: ");
                    choice = readInt();
                    if (choice > 0 && choice <= party.size()) {
                        trainer.removePokemon(choice - 1);
                    }
                } else {
                    System.out.println("Invalid choice.");
                    pause();
                }
            } else {
                editPartyPokemon(party.get(choice - 1));
            }

        }
        
    }

    private static void editPartyPokemon(PartyPokemon pokemon) {

        clear();

        String command;
        loop: while (true) {
            String[] choices = {"Back",
            String.format("Species (%s)", pokemon.getPokemon()),
            String.format("Level (%d)", pokemon.getLevel()),
            String.format("Item (%s)", pokemon.hasItem() ? pokemon.getItem() : "None"),
            String.format("Moves (%s)", pokemon.getMoveString()),
            String.format("Set Default Moveset"),
            String.format("Ability (%d %s)", pokemon.getAbility(), pokemon.getAbilityClass()),
            String.format("Gender (%s)", pokemon.getGender().length() > 0 ? pokemon.getGender() : "Default"),
            String.format("Nature (%s)", pokemon.getNature().length() > 0 ? pokemon.getNature() : "Random"),
            String.format("IVs (%d)", pokemon.getIVs()),
            (pokemon.getEV(0) < 0) ? "EVs (Default)" : String.format("EVs (%d/%d/%d/%d/%d/%d)", pokemon.getEV(0), pokemon.getEV(1), pokemon.getEV(2), pokemon.getEV(3), pokemon.getEV(4), pokemon.getEV(5)),
            String.format("Happiness (%d)", pokemon.getHappiness()),
            String.format("Form (%d)", pokemon.getForm()),
            String.format("Shiny (%b)", pokemon.isShiny()),
            String.format("Ball Type (%d)", pokemon.getBallType()),
            String.format("Nickname (%s)", pokemon.getNickname().length() > 0 ? pokemon.getNickname() : "None"),
            String.format("Shadow (%b)", pokemon.isShadow())};
            command = menu(String.format("Editting %s\nSelect what to edit.", pokemon), choices);
            if (command.contains("(")) {
                command = command.substring(0, command.indexOf("(") - 1);
            }
            switch (command) {
                case "Back": {
                    break loop;
                }
                case "Species": {
                    System.out.print("Select new species: ");
                    Pokemon species = selectPokemon();
                    if (species == null) {
                        System.out.println("Species does not exist.");
                        pause();
                        break;
                    }
                    pokemon.setPokemon(species);
                    break;
                }
                case "Level": {
                    System.out.print("New Level: ");
                    int value = readInt();
                    if (value < 1 || value > 100) {
                        System.out.println("Level must be between 1 and 100.");
                        pause();
                    } else {
                        pokemon.setLevel(value);
                    }
                    break;
                }
                case "Item": {
                    System.out.print("New Item (0 to remove): ");
                    String value = readString();
                    if (value.equals("0")) {
                        pokemon.setItem(null);
                        break;
                    }
                    Item item = pokedex.getItem(value);
                    if (item == null) {
                        System.out.println("Item does not exist");
                        pause();
                    } else {
                        pokemon.setItem(item);
                    }
                    break;
                }
                case "Moves": {
                    
                    while (true) {
                        clear();

                        int max = -1;
                        Move[] moves = pokemon.getMoves();

                        System.out.printf("Editting %s\nWrite the number next to a move to delete it.\n", pokemon);
                        System.out.println("---------------------\n");

                        int move_count = 0;

                        System.out.println("0) Back");
                        for (int i = 0; i < 4; i++) {
                            if (moves[i] != null) {
                                System.out.printf("%d) %s\n", i + 1, moves[i]);
                                move_count++;
                                max = i + 1;
                            } else {
                                max = i + 1;
                                System.out.printf("%d) Add Move\n", i + 1);
                                break;
                            }
                        }
                        max++;
                        System.out.printf("%d) Check Movelist", max);
                        
                        System.out.print("\nChoice: ");
                        int cmd = readInt();

                        if (cmd < 0 || cmd > 5 || (max > 0 && cmd > max)) {
                            System.out.println("Invalid choice");
                            pause();
                        } else if (cmd == 0) {
                            break;
                        } else if (cmd == max - 1 && move_count < 4) {
                            System.out.print("Move Name: ");
                            Move move = selectMove();
                            if (move == null) {
                                System.out.println("That move does not exist");
                                pause();
                            }
                            if (pokemon.getPokemon().canLearnMove(move, pokemon.getLevel())) {
                                pokemon.addMove(move);
                            } else if (pokemon.getPokemon().canLearnMove(move)) {
                                System.out.println("The Pokemon isn't a high enough level for this move.");
                                System.out.println("Type 'n' to not add the move, press Enter to add anyway.");
                                if (!readString().toLowerCase().equals("n")) {
                                    pokemon.addMove(move);
                                }
                            } else {
                                System.out.println("The Pokemon has no way to learn this move.");
                                System.out.println("Type 'add' to add anyway, press Enter to not add.");
                                if (readString().toLowerCase().equals("add")) {
                                    pokemon.addMove(move);
                                }
                            }
                        } else if (cmd == max) {
                            clear();
                            pokedex.printMoveset(pokemon.getPokemon());
                            pause();
                        } else {
                            pokemon.removeMove(moves[cmd - 1]);
                        }

                    }
                    break;
                }
                case "Set Default Moveset": {
                    if (!pokemon.getMoveString().equals("Default Moveset")) {
                        System.out.print("Are you sure? (y/n) ");
                        if (!readString().toLowerCase().equals("y")) {
                            break;
                        }
                    }
                    pokemon.setDefaultMoveset();
                    break;
                }
                case "Ability": {
                    System.out.print("Abilities: \n");
                    for (int i = 0; i <= 2; i++) {
                        System.out.printf("%d) %s\n", i, pokemon.getAbilityClass(i));
                    }
                    System.out.print("Choice: ");
                    int choice = readInt();
                    if (choice < 0 || choice > 2) {
                        System.out.println("Invalid choice.");
                        pause();
                    } else {
                        pokemon.setAbility(choice);
                    }
                    break;
                }
                case "Gender": {
                    String genderRate = pokemon.getPokemon().getGenderRate();
                    if (genderRate.equals("AlwaysMale")) {
                        System.out.println("This Species is always Male.");
                        pokemon.setGender("M");
                        pause();
                    } else if (genderRate.equals("AlwaysFemale")) {
                        System.out.println("This Species is always Female.");
                        pokemon.setGender("F");
                        pause();
                    } else if (genderRate.equals("Genderless")) {
                        System.out.println("This Species is Genderless.");
                        pokemon.setGender("");
                        pause();
                    }
                    System.out.print("New gender (M/F): ");
                    String value = readString().toLowerCase();
                    if (value.equals("m")) {
                        pokemon.setGender("M");
                    } else if (value.equals("f")) {
                        pokemon.setGender("F");
                    } else {
                        System.out.println("Invalid choice.");
                        pause();
                    }
                    break;
                }
                case "Nature": {
                    System.out.print("Choose increased stat or nature: ");
                    String upStat = readString().toUpperCase();
                    upStat = upStat.replace("SPATK", "SP.ATK").replace("SPDEF", "SP.DEF");
                    if (!Natures.isStat(upStat)) {
                        if (Natures.isNature(upStat)) {
                            pokemon.setNature(upStat);
                            break;
                        }
                        System.out.println("Stat must be one of these:");
                        System.out.println("ATTACK");
                        System.out.println("DEFENSE");
                        System.out.println("SPEED");
                        System.out.println("SP.ATK");
                        System.out.println("SP.DEF");
                        pause();
                        break;
                    }
                    System.out.print("Choose decreased stat: ");
                    String downStat = readString().toUpperCase();
                    downStat = downStat.replace("SPATK", "SP.ATK").replace("SPDEF", "SP.DEF");
                    if (!Natures.isStat(downStat)) {
                        System.out.println("Stat must be one of these:");
                        System.out.println("ATTACK");
                        System.out.println("DEFENSE");
                        System.out.println("SPEED");
                        System.out.println("SP.ATK");
                        System.out.println("SP.DEF");
                        pause();
                        break;
                    }

                    int natureID = Natures.getStatID(upStat) * 5;
                    natureID += Natures.getStatID(downStat);

                    pokemon.setNature(Natures.natures[natureID]);

                    break;
                }
                case "IVs": {
                    System.out.print("New IVs: ");
                    int value = readInt();
                    if (value < 0 || value > 31) {
                        System.out.println("IVs must be between 0 and 31.");
                        pause();
                    } else {
                        pokemon.setIVs(value);
                    }
                    break;
                }
                case "EVs": {
                    clear();
                    sub: while (true) {
                        String[] stats = {"Back",
                        String.format("HP (%d)", pokemon.getEV(0)),
                        String.format("Attack (%d)", pokemon.getEV(1)),
                        String.format("Defense (%d)", pokemon.getEV(2)),
                        String.format("Speed (%d)", pokemon.getEV(3)),
                        String.format("Sp.Atk (%d)", pokemon.getEV(4)),
                        String.format("Sp.Def (%d)", pokemon.getEV(5))};
                        command = menu(String.format("Editting %s\nSelect what to edit.", pokemon), stats);
                        if (command.contains("(")) {
                            command = command.substring(0, command.indexOf("(") - 1);
                        }
                        int updateType = 0;
                        switch (command) {
                            case "Back": {
                                break sub;
                            }
                            case "HP": {
                                System.out.print("\nNew HP EV: ");
                                int value = readInt();
                                if (value < 0) value = -1;
                                pokemon.setEV(0, value);
                                if (value < 0) {
                                    updateType = 1;
                                } else {
                                    updateType = 2;
                                }
                                break;
                            }
                            case "Attack": {
                                System.out.print("\nNew Attack EV: ");
                                int value = readInt();
                                if (value < 0) value = -1;
                                pokemon.setEV(1, value);
                                if (value < 0) {
                                    updateType = 1;
                                } else {
                                    updateType = 2;
                                }
                                break;
                            }
                            case "Defense": {
                                System.out.print("\nNew Defense EV: ");
                                int value = readInt();
                                if (value < 0) value = -1;
                                pokemon.setEV(2, value);
                                if (value < 0) {
                                    updateType = 1;
                                } else {
                                    updateType = 2;
                                }
                                break;
                            }
                            case "Speed": {
                                System.out.print("\nNew Speed EV: ");
                                int value = readInt();
                                if (value < 0) value = -1;
                                pokemon.setEV(3, value);
                                if (value < 0) {
                                    updateType = 1;
                                } else {
                                    updateType = 2;
                                }
                                break;
                            }
                            case "Sp.Atk": {
                                System.out.print("\nNew Sp.Atk EV: ");
                                int value = readInt();
                                if (value < 0) value = -1;
                                pokemon.setEV(4, value);
                                if (value < 0) {
                                    updateType = 1;
                                } else {
                                    updateType = 2;
                                }
                                break;
                            }
                            case "Sp.Def": {
                                System.out.print("\nNew Sp.Def EV: ");
                                int value = readInt();
                                if (value < 0) value = -1;
                                pokemon.setEV(5, value);
                                if (value < 0) {
                                    updateType = 1;
                                } else {
                                    updateType = 2;
                                }
                                break;
                            }
                        }
                        if (updateType == 1) {
                            for (int i = 0; i < 6; i++) {
                                pokemon.setEV(i, -1);
                            }
                        } else if (updateType == 2) {
                            for (int i = 0; i < 6; i++) {
                                if (pokemon.getEV(i) < 0) {
                                    pokemon.setEV(i, 0);
                                }
                            }
                        }
                    }
                    break;
                }
                case "Happiness": {
                    System.out.print("New happiness: ");
                    int value = readInt();
                    if (value < 0 || value > 255) {
                        System.out.println("Happiness must be between 0 and 255.");
                        pause();
                    } else {
                        pokemon.setHappiness(value);
                    }
                    break;
                }
                case "Form": {
                    System.out.print("New Form: ");
                    int value = readInt();
                    if (value < 0) {
                        System.out.println("Form must be a positive number.");
                        pause();
                    } else {
                        pokemon.setForm(value);
                    }
                    break;
                }
                case "Shiny": {
                    System.out.print("Is it shiny? (y/n) ");
                    String value = readString().toLowerCase();
                    if (value.equals("y")) {
                        pokemon.setShiny(true);
                    } else if (value.equals("n")) {
                        pokemon.setShiny(false);
                    } else {
                        System.out.println("Invalid choice.");
                        pause();
                    }
                    break;
                }
                case "Ball Type": {
                    System.out.println("> Search for '$BallTypes=' in scripts for IDs.");
                    System.out.print("New Ball Type: ");
                    int value = readInt();
                    if (value < 0) {
                        System.out.println("Ball Type must be a positive number.");
                        pause();
                    } else {
                        pokemon.setBallType(value);
                    }
                    break;
                }
                case "Nickname": {
                    System.out.print("New Nickname (0 to remove): ");
                    String value = readString();
                    if (value.equals("0")) {
                        pokemon.setNickname("");
                        break;
                    }
                    if (value.length() > 0) {
                        pokemon.setNickname(value);
                    }
                    break;
                }
                case "Shadow": {
                    System.out.print("Is it shadow? (y/n) ");
                    String value = readString().toLowerCase();
                    if (value.equals("y")) {
                        pokemon.setShadow(true);
                    } else if (value.equals("n")) {
                        pokemon.setShadow(false);
                    } else {
                        System.out.println("Invalid choice.");
                        pause();
                    }
                    break;
                }
            }
        }

    }

    private static boolean pokemonMenu() {
        System.out.print("\nType the Pokemon's name: ");
        Pokemon pokemon = selectPokemon();
        if (pokemon == null) {
            System.out.println("The given Pokemon does not exist.");
            pause();
            return false;
        }

        String[] choices = {"Back", "Switch Pokemon", "Show Stats", "Show Moveset", "Show Info", "Add/Remove Moves", "Edit Pokemon"};

        String command;
        loop: while (true) {
            command = menu(String.format("Checking #%03d %s", pokemon.getID(), pokemon.getName()), choices);
            switch (command) {
                case "Back": {
                    break loop;
                }
                case "Switch Pokemon": {
                    if (pokemonMenu()) {
                        break loop;
                    }
                    break;
                }
                case "Show Stats": {
                    clear();
                    pokedex.printStats(pokemon);
                    pause();
                    break;
                }
                case "Show Moveset": {
                    clear();
                    pokedex.printMoveset(pokemon);
                    pause();
                    break;
                }
                case "Show Info": {
                    clear();
                    pokedex.printInfo(pokemon);
                    pause();
                    break;
                }
                case "Add/Remove Moves": {
                    sub: while (true) {
                        String[] moveCommands = {"Back", "Level Up Moves", "Egg Moves", "TM/Tutor Moves",
                            String.format("Evolution Move (%s)", pokemon.hasEvolutionMove() ? pokemon.getEvolutionMove() : "None"),
                            "Echo Level Up Moves",
                            String.format("Echo Evolution Move (%s)", pokemon.hasEchoEvolutionMove() ? pokemon.getEchoEvolutionMove() : "None")};
                        command = menu(String.format("Checking #%03d %s\nAdd or Remove...", pokemon.getID(), pokemon.getName()), moveCommands);
                        if (command.contains("(")) {
                            command = command.substring(0, command.indexOf("(") - 1);
                        }
                        switch (command) {
                            case "Back": {
                                break sub;
                            }
                            case "Level Up Moves": {
                                pokemonEditLevelMoves(pokemon);
                                break;
                            }
                            case "Echo Level Up Moves": {
                                pokemonEditEchoLevelMoves(pokemon);
                                break;
                            }
                            case "Egg Moves": {
                                Pokemon firstStage = pokemon.getFirstStage();
                                pokemonEditEggMoves(firstStage);
                                break;
                            }
                            case "TM/Tutor Moves": {
                                pokemonEditTMMoves(pokemon);
                                break;
                            }
                            case "Evolution Move": {
                                System.out.print("\nWrite 0 or None to remove the Evolution Move: ");
                                System.out.print("Evolution Move Name: ");
                                String movename = readString();
                                if (movename.toLowerCase().equals("0") || movename.toLowerCase().equals("none")) {
                                    pokemon.setEvolutionMove(null);
                                } else {
                                    Move move = pokedex.getMove(movename);
                                    if (move == null) {
                                        System.out.println("That move does not exist.");
                                        pause();
                                    } else {
                                        pokemon.setEvolutionMove(move);
                                    }
                                }
                                break;
                            }
                            case "Echo Evolution Move": {
                                System.out.print("\nWrite 0 or None to remove the Echo Evolution Move: ");
                                System.out.print("Echo Evolution Move Name: ");
                                String movename = readString();
                                if (movename.toLowerCase().equals("0") || movename.toLowerCase().equals("none")) {
                                    pokemon.setEchoEvolutionMove(null);
                                } else {
                                    Move move = pokedex.getMove(movename);
                                    if (move == null) {
                                        System.out.println("That move does not exist.");
                                        pause();
                                    } else {
                                        pokemon.setEchoEvolutionMove(move);
                                    }
                                }
                                break;
                            }
                        }
                    }
                    break;
                }
                case "Edit Pokemon": {
                    editPokemon(pokemon);
                    break;
                }
            }
        }
        return true;
    }

    private static boolean moveMenu() {
        System.out.print("\nType the Move's name: ");
        Move move = selectMove();
        if (move == null) {
            System.out.println("The given Move does not exist.");
            pause();
            return false;
        }

        String[] choices = {"Back", "Switch Move", "Show Info", "Add/Remove Pokemon", "Edit Move", "Add Copy of Move", "Delete Move"};

        String command;
        loop: while (true) {
            command = menu(String.format("Checking %s", move), choices);
            switch (command) {
                case "Back": {
                    break loop;
                }
                case "Switch Move": {
                    if (moveMenu()) {
                        break loop;
                    }
                    break;
                }
                case "Show Info": {
                    clear();
                    move.printInfo();
                    pause();
                    break;
                }
                case "Add/Remove Pokemon": {
                    sub: while (true) {
                        String[] moveCommands = {"Back", "Level Up Moves", "Egg Moves", "TM/Tutor Moves"};
                        command = menu(String.format("Checking %s\nAdd or Remove...", move), moveCommands);
                        switch (command) {
                            case "Back": {
                                break sub;
                            }
                            case "Level Up Moves": {
                                moveEditLevelMoves(move);
                                break;
                            }
                            case "Egg Moves": {
                                moveEditEggMoves(move);
                                break;
                            }
                            case "TM/Tutor Moves": {
                                moveEditTMMoves(move);
                                break;
                            }
                        }
                    }
                    break;
                }
                case "Edit Move": {
                    editMove(move);
                    break;
                }
                case "Add Copy of Move": {
                    System.out.print("Internal Name of Copy: ");
                    String newInternalName = readString().toUpperCase().replace(" ", "").replace("-","").replace(":","").replace("'","");
                    Move testMove = pokedex.getMove(newInternalName);
                    if (testMove != null) {
                        System.out.println("A move with this name already exists.");
                        pause();
                        break;
                    }

                    System.out.print("Display Name of Copy: ");
                    String newName = readString();
                    testMove = pokedex.getMove(newName);
                    if (testMove != null) {
                        System.out.println("A move with this name already exists.");
                        pause();
                        break;
                    }

                    int id = pokedex.getNextMoveID();

                    Move newMove = new Move(id, newName, newInternalName,
                        move.getFunction(), move.getPower(), move.getAccuracy(),
                        move.getPP(), move.getType(), move.getCategory(),
                        move.getEffectChance(), move.getTarget(), move.getPriority(),
                        move.getFlags(), move.getDescription());
                    pokedex.addMove(newMove);

                    System.out.printf("\nCopy of %s added as %s\n\n", move, newMove);
                    pause();

                    break;
                }
                case "Delete Move": {
                    System.out.println("\nWrite the move's name to confirm deletion.");
                    System.out.print("Move Name: ");
                    String check = readString();
                    if (check.toLowerCase().equals(move.getName().toLowerCase()) ||
                            check.toUpperCase().equals(move.getInternalName())) {
                        if (pokedex.deleteMove(move)) {
                            System.out.printf("The move '%s' was deleted.\n", move.getName());
                            pause();
                            break loop;
                        } else {
                            System.out.println("Failed when trying to delete the move.");
                            pause();
                        }
                    } else {
                        System.out.println("The move was not deleted.");
                        pause();
                    }
                    break;
                }
            }
        }
        return true;
    }

    private static boolean itemMenu() {
        System.out.print("\nType the Item's name: ");
        Item item = selectItem();
        if (item == null) {
            System.out.println("The given Item does not exist.");
            pause();
            return false;
        }

        String[] choices = {"Back", "Switch Item", "Show Info", "Edit Item", "Add Copy of Item", "Delete Item"};

        String command;
        loop: while (true) {
            command = menu(String.format("Checking %s", item), choices);
            switch (command) {
                case "Back": {
                    break loop;
                }
                case "Switch Item": {
                    if (itemMenu()) {
                        break loop;
                    }
                    break;
                }
                case "Show Info": {
                    clear();
                    item.printInfo();
                    pause();
                    break;
                }
                case "Edit Item": {
                    editItem(item);
                    break;
                }
                case "Add Copy of Item": {
                    System.out.print("Internal Name of Copy: ");
                    String newInternalName = readString().toUpperCase().replace(" ", "").replace("-","").replace(":","").replace("'","");
                    Item testItem = pokedex.getItem(newInternalName);
                    if (testItem != null) {
                        System.out.println("An item with this name already exists.");
                        pause();
                        break;
                    }

                    System.out.print("Display Name of Copy: ");
                    String newName = readString();
                    testItem = pokedex.getItem(newName);
                    if (testItem != null) {
                        System.out.println("An item with this name already exists.");
                        pause();
                        break;
                    }

                    int id = pokedex.getNextItemID();

                    Item newItem = new Item(id, newInternalName, newName,
                        item.getPluralName(), item.getPocket(), item.getPrice(), item.getDescription(),
                        item.getUseField(), item.getUseBattle(), item.getSpecialItem());
                    if (newItem.hasTM()) {
                        newItem.setTM(item.getTM());
                    }
                    pokedex.addItem(newItem);

                    System.out.printf("\nCopy of %s added as %s\n\n", item, newItem);
                    pause();

                    break;
                }
                case "Delete Item": {
                    System.out.println("\nWrite the item's name to confirm deletion.");
                    System.out.print("Item Name: ");
                    String check = readString();
                    if (check.toLowerCase().equals(item.getName().toLowerCase()) ||
                            check.toUpperCase().equals(item.getInternalName())) {
                        if (pokedex.deleteItem(item)) {
                            System.out.printf("The item '%s' was deleted.\n", item.getName());
                            pause();
                            break loop;
                        } else {
                            System.out.println("Failed when trying to delete the item.");
                            pause();
                        }
                    } else {
                        System.out.println("The item was not deleted.");
                        pause();
                    }
                    break;
                }
            }
        }
        return true;
    }

    private static void editPokemon(Pokemon pokemon) {

        clear();

        String command;
        loop: while (true) {
            String[] choices = {"Back",
            String.format("Internal Name (%s)", pokemon.getInternalName()),
            String.format("Display Name (%s)", pokemon.getName()),
            String.format("Type 1 (%s)", pokemon.getType1()),
            String.format("Type 2 (%s)", pokemon.hasType2() ? pokemon.getType2() : "None"),
            String.format("Type 3 (%s)", pokemon.hasType3() ? pokemon.getType3() : "None"),
            String.format("Type 4 (%s)", pokemon.hasType4() ? pokemon.getType4() : "None"),
            String.format("Stats (%s)", Arrays.toString(pokemon.getStats())),
            String.format("Ability 1 (%s)", pokemon.getAbility1()),
            String.format("Ability 2 (%s)", pokemon.hasAbility2() ? pokemon.getAbility2() : "None"),
            String.format("Hidden Ability (%s)", pokemon.hasHiddenAbility() ? pokemon.getHiddenAbility() : "None"),
            String.format("Echo Ability (%s)", pokemon.hasEchoAbility() ? pokemon.getEchoAbility() : "None"),
            String.format("Gender Ratio (%s)", pokemon.getGenderRate()),
            String.format("Growth Rate (%s)", pokemon.getGrowthRate()),
            String.format("Base EXP (%d)", pokemon.getBaseExp()),
            String.format("Catch Rate / Rarity (%d)", pokemon.getRareness()),
            String.format("Happiness (%d)", pokemon.getHappiness()),
            String.format("Effort Points (%s)", Arrays.toString(pokemon.getEffortPoints())),
            String.format("Egg Groups (%s)", !pokemon.hasEggGroup2() ? pokemon.getCompatibility()[0] :
                String.format("%s/%s", pokemon.getCompatibility()[0], pokemon.getCompatibility()[1])),
            String.format("Steps to Hatch (%d)", pokemon.getStepsToHatch()),
            String.format("Height (%.01f)", pokemon.getHeight()),
            String.format("Weight (%.01f)", pokemon.getWeight()),
            String.format("Wild Item 50%% (%s)", pokemon.hasWildItemCommon() ? pokemon.getWildItemCommon() : "None"),
            String.format("Wild Item 5%% (%s)", pokemon.hasWildItemUncommon() ? pokemon.getWildItemUncommon() : "None"),
            String.format("Wild Item 1%% (%s)", pokemon.hasWildItemRare() ? pokemon.getWildItemRare() : "None"),
            String.format("Evolutions"),
            String.format("Dex Category (%s Pokemon)", pokemon.getKind()),
            String.format("Dex Entry")};
            command = menu(String.format("Editting %s\nSelect what to edit.", pokemon), choices);
            if (command.contains("(")) {
                command = command.substring(0, command.indexOf("(") - 1);
            }
            switch (command) {
                case "Back": {
                    break loop;
                }
                case "Internal Name": {
                    System.out.print("New Internal Name: ");
                    String value = readString().toUpperCase().replace(" ", "");
                    if (value.length() > 0) {
                        if (pokedex.pokemonInternalNameExists(value)) {
                            System.out.println("A move already has this internal name");
                            pause();
                        } else {
                            pokemon.setInternalName(value);
                        }
                    }
                    break;
                }
                case "Display Name": {
                    System.out.print("New Display Name: ");
                    String value = readString();
                    if (value.length() > 0) {
                        pokemon.setName(value);
                    }
                    break;
                }
                case "Type 1": {
                    System.out.print("New Type 1: ");
                    String value = readString().toUpperCase();
                    if (Types.isType(value)) {
                        pokemon.setType1(value);
                    } else {
                        System.out.println("Invalid Type.");
                        pause();
                    }
                    if (pokemon.getType1().equals(pokemon.getType2())) {
                        pokemon.setType2("");
                    }
                    break;
                }
                case "Type 2": {
                    System.out.println("(Write '0' to remove): ");
                    System.out.print("New Type 2: ");
                    String value = readString().toUpperCase();
                    if (value.equals("0") || value.equals(pokemon.getType1())) {
                        pokemon.setType2("");
                    } else {
                        if (Types.isType(value)) {
                            pokemon.setType2(value);
                        } else {
                            System.out.println("Invalid Type.");
                            pause();
                        }
                    }
                    break;
                }
                case "Type 3": {
                    System.out.println("(Write '0' to remove): ");
                    System.out.print("New Type 3: ");
                    String value = readString().toUpperCase();
                    if (value.equals("0")) {
                        pokemon.setType3("");
                    } else {
                        if (Types.isType(value)) {
                            pokemon.setType3(value);
                        } else {
                            System.out.println("Invalid Type.");
                            pause();
                        }
                    }
                    break;
                }
                case "Type 4": {
                    System.out.println("(Write '0' to remove): ");
                    System.out.print("New Type 4: ");
                    String value = readString().toUpperCase();
                    if (value.equals("0")) {
                        pokemon.setType4("");
                    } else {
                        if (Types.isType(value)) {
                            pokemon.setType4(value);
                        } else {
                            System.out.println("Invalid Type.");
                            pause();
                        }
                    }
                    break;
                }
                case "Stats": {
                    clear();
                    sub: while (true) {
                        String[] stats = {"Back",
                        String.format("HP (%d)", pokemon.getHP()),
                        String.format("Attack (%d)", pokemon.getAttack()),
                        String.format("Defense (%d)", pokemon.getDefense()),
                        String.format("Speed (%d)", pokemon.getSpeed()),
                        String.format("Sp.Atk (%d)", pokemon.getSpAtk()),
                        String.format("Sp.Def (%d)", pokemon.getSpDef())};
                        command = menu(String.format("Editting %s\nSelect what to edit.", pokemon), stats);
                        if (command.contains("(")) {
                            command = command.substring(0, command.indexOf("(") - 1);
                        }
                        switch (command) {
                            case "Back": {
                                break sub;
                            }
                            case "HP": {
                                System.out.print("\nNew HP Stat: ");
                                int value = readInt();
                                if (value < 1 || value > 255) {
                                    System.out.println("HP stat has to be a number between 1-255.");
                                    pause();
                                } else {
                                    pokemon.setHP(value);
                                }
                                break;
                            }
                            case "Attack": {
                                System.out.print("\nNew Attack Stat: ");
                                int value = readInt();
                                if (value < 1 || value > 255) {
                                    System.out.println("Attack stat has to be a number between 1-255.");
                                    pause();
                                } else {
                                    pokemon.setAttack(value);
                                }
                                break;
                            }
                            case "Defense": {
                                System.out.print("\nNew Defense Stat: ");
                                int value = readInt();
                                if (value < 1 || value > 255) {
                                    System.out.println("Defense stat has to be a number between 1-255.");
                                    pause();
                                } else {
                                    pokemon.setDefense(value);
                                }
                                break;
                            }
                            case "Speed": {
                                System.out.print("\nNew Speed Stat: ");
                                int value = readInt();
                                if (value < 1 || value > 255) {
                                    System.out.println("Speed stat has to be a number between 1-255.");
                                    pause();
                                } else {
                                    pokemon.setSpeed(value);
                                }
                                break;
                            }
                            case "Sp.Atk": {
                                System.out.print("\nNew Sp.Atk Stat: ");
                                int value = readInt();
                                if (value < 1 || value > 255) {
                                    System.out.println("Sp.Atk stat has to be a number between 1-255.");
                                    pause();
                                } else {
                                    pokemon.setSpAtk(value);
                                }
                                break;
                            }
                            case "Sp.Def": {
                                System.out.print("\nNew Sp.Def Stat: ");
                                int value = readInt();
                                if (value < 1 || value > 255) {
                                    System.out.println("Sp.Def stat has to be a number between 1-255.");
                                    pause();
                                } else {
                                    pokemon.setSpDef(value);
                                }
                                break;
                            }
                        }
                    }
                    break;
                }
                case "Ability 1": {
                    System.out.print("Ability Name: ");
                    Ability ability = pokedex.getAbility(readString());
                    if (ability == null) {
                        System.out.println("Ability does not exist");
                        pause();
                    } else {
                        pokemon.setAbility1(ability);
                    }
                    if (pokemon.getAbility1() == pokemon.getAbility2()) {
                        pokemon.setAbility2(null);
                    }
                    if (pokemon.getAbility1() == pokemon.getHiddenAbility()) {
                        pokemon.setHiddenAbility(null);
                    }
                    break;
                }
                case "Ability 2": {
                    System.out.println("(Write '0' to remove): ");
                    System.out.print("Ability Name: ");
                    String value = readString();
                    if (value.equals("0")) {
                        pokemon.setAbility2(null);
                    } else {
                        Ability ability = pokedex.getAbility(value);
                        if (ability == null) {
                            System.out.println("Ability does not exist");
                            pause();
                        } else if (ability == pokemon.getAbility1()) {
                            pokemon.setAbility2(null);
                        } else {
                            pokemon.setAbility2(ability);
                        }
                    }
                    if (pokemon.getAbility2() == pokemon.getHiddenAbility()) {
                        pokemon.setHiddenAbility(null);
                    }
                    break;
                }
                case "Hidden Ability": {
                    System.out.println("(Write '0' to remove): ");
                    System.out.print("Ability Name: ");
                    String value = readString();
                    if (value.equals("0")) {
                        pokemon.setHiddenAbility(null);
                    } else {
                        Ability ability = pokedex.getAbility(value);
                        if (ability == null) {
                            System.out.println("Ability does not exist");
                            pause();
                        } else if (ability == pokemon.getAbility1() || ability == pokemon.getAbility2()) {
                            pokemon.setHiddenAbility(null);
                        } else {
                            pokemon.setHiddenAbility(ability);
                        }
                    }
                    break;
                }
                case "Echo Ability": {
                    System.out.println("(Write '0' to remove): ");
                    System.out.print("Ability Name: ");
                    String value = readString();
                    if (value.equals("0")) {
                        pokemon.setEchoAbility(null);
                    } else {
                        Ability ability = pokedex.getAbility(value);
                        if (ability == null) {
                            System.out.println("Ability does not exist");
                            pause();
                        } else {
                            pokemon.setEchoAbility(ability);
                        }
                    }
                    break;
                }
                case "Gender Ratio": {
                    clear();
                    System.out.printf("Editting %s\n-----------------------\n", pokemon);
                    System.out.printf("Current Ratio: %s\n\n", pokemon.getGenderRate());
                    System.out.printf("%d) %s\n", 0, "Back");
                    for (int i = 0; i < Pokemon.genderRates.length; i++) {
                        System.out.printf("%d) %s\n", i + 1, Pokemon.genderRates[i]);
                    }
                    System.out.print("\nChoice: ");
                    int choice = readInt();
                    if (choice < 0) {
                        System.out.println("Invalid choice.");
                        pause();
                    } else if (choice > 0 && choice <= Pokemon.genderRates.length) {
                        pokemon.setGenderRate(Pokemon.genderRates[choice - 1]);
                    } else if (choice != 0) {
                        System.out.println("Invalid choice.");
                        pause();
                    }
                    break;
                }
                case "Growth Rate": {
                    clear();
                    System.out.printf("Editting %s\n-----------------------\n", pokemon);
                    System.out.printf("Current Rate: %s\n\n", pokemon.getGrowthRate());
                    System.out.printf("%d) %s\n", 0, "Back");
                    for (int i = 0; i < Pokemon.growthRates.length; i++) {
                        System.out.printf("%d) %s\n", i + 1, Pokemon.growthRates[i]);
                    }
                    System.out.print("\nChoice: ");
                    int choice = readInt();
                    if (choice < 0) {
                        System.out.println("Invalid choice.");
                        pause();
                    } else if (choice > 0 && choice <= Pokemon.growthRates.length) {
                        String rate = Pokemon.growthRates[choice - 1];
                        if (rate.contains("(")) {
                            rate = rate.substring(0, rate.indexOf("(") - 1);
                        }
                        pokemon.setGrowthRate(rate);
                    } else if (choice != 0) {
                        System.out.println("Invalid choice.");
                        pause();
                    }
                    break;
                }
                case "Base EXP": {
                    System.out.print("New Base EXP: ");
                    int value = readInt();
                    if (value < 1) {
                        System.out.println("Base EXP has to be a number that's at least 1.");
                        pause();
                    } else {
                        pokemon.setBaseExp(value);
                    }
                    break;
                }
                case "Catch Rate / Rarity": {
                    System.out.print("New Rareness: ");
                    int value = readInt();
                    if (value < 1 || value > 255) {
                        System.out.println("Rareness has to be a number between 1-255");
                        pause();
                    } else {
                        pokemon.setRareness(value);
                    }
                    break;
                }
                case "Happiness": {
                    System.out.print("New Happiness: ");
                    int value = readInt();
                    if (value < 0 || value > 255) {
                        System.out.println("Happiness has to be a number between 0-255");
                        pause();
                    } else {
                        pokemon.setHappiness(value);
                    }
                    break;
                }
                case "Effort Points": {
                    clear();
                    sub: while (true) {
                        String[] stats = {"Back",
                        String.format("HP (%d)", pokemon.getEffortPoints()[0]),
                        String.format("Attack (%d)", pokemon.getEffortPoints()[1]),
                        String.format("Defense (%d)", pokemon.getEffortPoints()[2]),
                        String.format("Speed (%d)", pokemon.getEffortPoints()[3]),
                        String.format("Sp.Atk (%d)", pokemon.getEffortPoints()[4]),
                        String.format("Sp.Def (%d)", pokemon.getEffortPoints()[5])};
                        command = menu(String.format("Editting %s\nSelect what to edit.", pokemon), stats);
                        if (command.contains("(")) {
                            command = command.substring(0, command.indexOf("(") - 1);
                        }
                        switch (command) {
                            case "Back": {
                                break sub;
                            }
                            case "HP": {
                                System.out.print("\nNew HP Value: ");
                                int value = readInt();
                                if (value < 0 || value > 3) {
                                    System.out.println("HP value has to be a number between 0-3.");
                                    pause();
                                } else {
                                    pokemon.getEffortPoints()[0] = value;
                                }
                                break;
                            }
                            case "Attack": {
                                System.out.print("\nNew Attack Value: ");
                                int value = readInt();
                                if (value < 0 || value > 3) {
                                    System.out.println("Attack value has to be a number between 0-3.");
                                    pause();
                                } else {
                                    pokemon.getEffortPoints()[1] = value;
                                }
                                break;
                            }
                            case "Defense": {
                                System.out.print("\nNew Defense Value: ");
                                int value = readInt();
                                if (value < 0 || value > 3) {
                                    System.out.println("Defense value has to be a number between 0-3.");
                                    pause();
                                } else {
                                    pokemon.getEffortPoints()[2] = value;
                                }
                                break;
                            }
                            case "Speed": {
                                System.out.print("\nNew Speed Value: ");
                                int value = readInt();
                                if (value < 0 || value > 3) {
                                    System.out.println("Speed value has to be a number between 0-3.");
                                    pause();
                                } else {
                                    pokemon.getEffortPoints()[3] = value;
                                }
                                break;
                            }
                            case "Sp.Atk": {
                                System.out.print("\nNew Sp.Atk Value: ");
                                int value = readInt();
                                if (value < 0 || value > 3) {
                                    System.out.println("Sp.Atk value has to be a number between 0-3.");
                                    pause();
                                } else {
                                    pokemon.getEffortPoints()[4] = value;
                                }
                                break;
                            }
                            case "Sp.Def": {
                                System.out.print("\nNew Sp.Def Value: ");
                                int value = readInt();
                                if (value < 0 || value > 3) {
                                    System.out.println("Sp.Def value has to be a number between 0-3.");
                                    pause();
                                } else {
                                    pokemon.getEffortPoints()[5] = value;
                                }
                                break;
                            }
                        }
                    }
                    break;
                }
                case "Egg Groups": {
                    sub: while (true) {
                        clear();
                        System.out.printf("Editting %s\n-----------------------\n", pokemon);
                        System.out.printf("Current Compatibility: %s\n\n", pokemon.hasEggGroup2() ?
                            (pokemon.getCompatibility()[0] + "/" + pokemon.getCompatibility()[1]) : pokemon.getCompatibility()[0]);
                        System.out.printf("%d) %s\n", 0, "Back");
                        for (int i = 0; i < Pokemon.eggGroups.length; i++) {
                            System.out.printf("%d) %s\n", i + 1, Pokemon.eggGroups[i]);
                        }
                        System.out.print("\nChoice: ");
                        int choice = readInt();
                        if (choice < 0) {
                            System.out.println("Invalid choice.");
                            pause();
                        } else if (choice > 0 && choice <= Pokemon.eggGroups.length) {
                            String group = Pokemon.eggGroups[choice - 1];
                            if (group.contains("(")) {
                                group = group.substring(0, group.indexOf("(") - 1);
                            }
                            System.out.println(group);
                            if (group.equals("Undiscovered") || group.equals("Ditto")) {
                                String[] comp = {group};
                                pokemon.setCompatibility(comp);
                            } else if (pokemon.getCompatibility()[0].equals(group)) {
                                if (pokemon.hasEggGroup2()) {
                                    String[] comp = {pokemon.getCompatibility()[1]};
                                    pokemon.setCompatibility(comp);
                                } else {
                                    String[] comp = {"Undiscovered"};
                                    pokemon.setCompatibility(comp);
                                }
                            } else if (pokemon.hasEggGroup2()) {
                                if (pokemon.getCompatibility()[1].equals(group)) {
                                    String[] comp = {pokemon.getCompatibility()[0]};
                                    pokemon.setCompatibility(comp);
                                } else {
                                    System.out.println("You can only have a maximum of 2 egg groups.");
                                    pause();
                                }
                            } else {
                                if (pokemon.getCompatibility()[0].equals("Undiscovered")) {
                                    String[] comp = {group};
                                    pokemon.setCompatibility(comp);
                                } else {
                                    String[] comp = {pokemon.getCompatibility()[0], group};
                                    pokemon.setCompatibility(comp);
                                }
                            }
                        } else if (choice != 0) {
                            System.out.println("Invalid choice.");
                            pause();
                        } else {
                            break sub;
                        }
                    }
                    break;
                }
                case "Steps to Hatch": {
                    System.out.print("New Value: ");
                    int value = readInt();
                    if (value < 1) {
                        System.out.println("Steps to hatch has to be a number that's at least 1.");
                        pause();
                    } else {
                        pokemon.setStepsToHatch(value);
                    }
                    break;
                }
                case "Height": {
                    System.out.print("New Height: ");
                    double value = readDouble();
                    if (value < 0.1 || value > 999.9) {
                        System.out.println("Height has to be a number between 0.1 and 999.9");
                        pause();
                    } else {
                        pokemon.setHeight(value);
                    }
                    break;
                }
                case "Weight": {
                    System.out.print("New Height: ");
                    double value = readDouble();
                    if (value < 0.1 || value > 999.9) {
                        System.out.println("Weight has to be a number between 0.1 and 999.9");
                        pause();
                    } else {
                        pokemon.setWeight(value);
                    }
                    break;
                }
                case "Wild Item 50%": {
                    System.out.print("Item Name: ");
                    String input = readString();
                    if (input.equals("0")) {
                        pokemon.setWildItemCommon(null);
                    } else {
                        Item item = pokedex.getItem(input);
                        if (item == null) {
                            System.out.println("Item does not exist");
                            pause();
                        } else {
                            pokemon.setWildItemCommon(item);
                        }
                    }
                    break;
                }
                case "Wild Item 5%": {
                    System.out.print("Item Name: ");
                    String input = readString();
                    if (input.equals("0")) {
                        pokemon.setWildItemUncommon(null);
                    } else {
                        Item item = pokedex.getItem(input);
                        if (item == null) {
                            System.out.println("Item does not exist");
                            pause();
                        } else {
                            pokemon.setWildItemUncommon(item);
                        }
                    }
                    break;
                }
                case "Wild Item 1%": {
                    System.out.print("Item Name: ");
                    String input = readString();
                    if (input.equals("0")) {
                        pokemon.setWildItemRare(null);
                    } else {
                        Item item = pokedex.getItem(input);
                        if (item == null) {
                            System.out.println("Item does not exist");
                            pause();
                        } else {
                            pokemon.setWildItemRare(item);
                        }
                    }
                    break;
                }
                case "Evolutions": {
                    sub: while (true) {
                        clear();
                        System.out.printf("Editting %s\n-----------------------\n", pokemon);
                        if (pokemon.getEvolutionData().size() > 0) {
                            System.out.printf("Current Evolutions:\n");
                        } else {
                            System.out.printf("Has no evolutions\n");
                        }

                        for (String[] s : pokemon.getEvolutionData()) {
                            System.out.printf("- %s %s %s\n", s[0], s[1], s[2]);
                        }

                        System.out.print("\nPokemon: ");
                        String pokename = readString();
                        if (pokename.length() <= 0) {
                            break sub;
                        } else if (pokename.toLowerCase().equals("clear")) {
                            pokemon.getEvolutionData().clear();
                        } else {
                            Pokemon evoPokemon = pokedex.getPokemon(pokename);
                            if (evoPokemon == null) {
                                System.out.println("That Pokemon does not exist");
                                pause();
                            } else {
                                clear();
                                System.out.printf("Editting %s\n-----------------------\n", pokemon);
                                System.out.printf("Adding Evolution: %s -> %s\n\n", pokemon, evoPokemon);
                                for (int i = 0; i < Pokemon.evolutionTypes.length; i++) {
                                    System.out.printf("%d) %s\n", i, Pokemon.evolutionTypes[i]);
                                }
                                System.out.print("\nChoice: ");
                                int choice = readInt();
                                if (choice < 0 || choice >= Pokemon.evolutionTypes.length) {
                                    System.out.println("Invalid choice");
                                    pause();
                                } else {
                                    String evoType = Pokemon.evolutionTypes[choice];
                                    String argType = Pokemon.evolutionArgType(evoType);
                                    switch (argType) {
                                        case "Level": {
                                            System.out.print("Level: ");
                                            int level = readInt();
                                            if (level < 1 || level > 100) {
                                                System.out.println("Level must be a number between 1-100");
                                                pause();
                                                break;
                                            }
                                            pokemon.addEvolution(evoPokemon.getInternalName(), evoType, Integer.toString(level));
                                            break;
                                        }
                                        case "Type": {
                                            System.out.print("Type: ");
                                            String type = readString().toUpperCase();
                                            if (!Types.isType(type)) {
                                                System.out.println("Not a valid type.");
                                                pause();
                                                break;
                                            }
                                            pokemon.addEvolution(evoPokemon.getInternalName(), evoType, type);
                                            break;
                                        }
                                        case "None": {
                                            pokemon.addEvolution(evoPokemon.getInternalName(), evoType, "");
                                            break;
                                        }
                                        case "Item": {
                                            System.out.print("Item: ");
                                            Item item = pokedex.getItem(readString());
                                            if (item == null) {
                                                System.out.println("That item does not exist");
                                                pause();
                                                break;
                                            }
                                            pokemon.addEvolution(evoPokemon.getInternalName(), evoType, item.getInternalName());
                                            break;
                                        }
                                        case "Move": {
                                            System.out.print("Move: ");
                                            Move move = pokedex.getMove(readString());
                                            if (move == null) {
                                                System.out.println("That move does not exist");
                                                pause();
                                                break;
                                            }
                                            pokemon.addEvolution(evoPokemon.getInternalName(), evoType, move.getInternalName());
                                            break;
                                        }
                                        case "Pokemon": {
                                            System.out.print("Pokemon: ");
                                            Pokemon reqPokemon = pokedex.getPokemon(readString());
                                            if (reqPokemon == null) {
                                                System.out.println("That pokemon does not exist");
                                                pause();
                                                break;
                                            }
                                            pokemon.addEvolution(evoPokemon.getInternalName(), evoType, reqPokemon.getInternalName());
                                            break;
                                        }
                                        case "Number": {
                                            if (evoType.equals("Location")) {
                                                System.out.print("Map ID: ");
                                            } else {
                                                System.out.print("Beauty Value: ");
                                            }
                                            int value = readInt();
                                            if (value < 1) {
                                                System.out.println("Value must be a positive number that's at least 1");
                                                pause();
                                                break;
                                            }
                                            pokemon.addEvolution(evoPokemon.getInternalName(), evoType, Integer.toString(value));
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    break;
                }
                case "Dex Category": {
                    System.out.print("New Category: ");
                    String value = readString();
                    if (value.length() > 0) {
                        pokemon.setKind(value);
                    }
                    break;
                }
                case "Dex Entry": {
                    System.out.printf("\nCurrent dex entry: %s\n\n", pokemon.getDexEntry());
                    System.out.print("New Entry: ");
                    String value = readString().replace("Pokemon", "Pokémon").replace("pokemon", "Pokémon");
                    if (value.length() > 0) {
                        pokemon.setDexEntry(value);
                    }
                    break;
                }
            }
        }

    }

    private static void editMove(Move move) {

        clear();

        String command;
        loop: while (true) {
            String[] choices = {"Back",
            String.format("Internal Name (%s)", move.getInternalName()),
            String.format("Display Name (%s)", move.getName()),
            String.format("Base Power (%d)", move.getPower()),
            String.format("Accuracy (%d)", move.getAccuracy()),
            String.format("PP (%d)", move.getPP()),
            String.format("Type (%s)", move.getType()),
            String.format("Category (%s)", move.getCategory()),
            String.format("Target (%s)", move.getTarget()),
            String.format("Priority (%d)", move.getPriority()),
            String.format("Flags (%s)", move.getFlags()),
            String.format("Function Code (%s)", move.getFunction()),
            String.format("Copy Function of Other Move"),
            String.format("Effect Chance (%d%c)", move.getEffectChance(), '%'),
            String.format("Description (%s)", move.getDescription())};
            command = menu(String.format("Editting %s\nSelect what to edit.", move), choices);
            if (command.contains("(")) {
                command = command.substring(0, command.indexOf("(") - 1);
            }
            switch (command) {
                case "Back": {
                    break loop;
                }
                case "Internal Name": {
                    System.out.print("New Internal Name: ");
                    String value = readString().toUpperCase().replace(" ", "");
                    if (value.length() > 0) {
                        if (pokedex.moveInternalNameExists(value)) {
                            System.out.println("A move already has this internal name");
                            pause();
                        } else {
                            move.setInternalName(value);
                        }
                    }
                    break;
                }
                case "Display Name": {
                    System.out.print("New Display Name: ");
                    String value = readString();
                    if (value.length() > 0) {
                        move.setName(value);
                    }
                    break;
                }
                case "Base Power": {
                    System.out.print("New Base Power: ");
                    int value = readInt();
                    if (value >= 0) {
                        if (move.getCategory().equals("Status")) {
                            if (value != 0) {
                                System.out.println("This is a status move. Power can only be 0.");
                                pause();
                                break;
                            }
                        } else {
                            if (value <= 0) {
                                System.out.printf("This is a %s move. Power must be at least 1.\n", move.getCategory());
                                pause();
                                break;
                            }
                        }
                        move.setPower(value);
                    } else {
                        System.out.println("Power must be a positive number.");
                        pause();
                    }
                    break;
                }
                case "Accuracy": {
                    System.out.print("New Accuracy: ");
                    int value = readInt();
                    if (value < 0 || value > 100) {
                        System.out.println("Accuracy must be a number between 0-100.");
                        pause();
                    } else {
                        move.setAccuracy(value);
                    }
                    break;
                }
                case "PP": {
                    System.out.print("New PP: ");
                    int value = readInt();
                    if (value < 0) {
                        System.out.println("PP must be a positive number. (0 = infinite).");
                        pause();
                    } else {
                        move.setPP(value);
                    }
                    break;
                }
                case "Type": {
                    System.out.print("New Type: ");
                    String value = readString().toUpperCase();
                    if (Types.isType(value)) {
                        move.setType(value);
                    } else {
                        System.out.println("Not a valid type.");
                        pause();
                    }
                    break;
                }
                case "Category": {
                    System.out.print("New Category: ");
                    String value = toProper(readString());
                    if (value.equals("Status")) {
                        move.setCategory(value);
                        if (move.getPower() != 0) {
                            move.setPower(0);
                            System.out.println("Also set Base Power to 0.");
                            pause();
                        }
                    } else if (value.equals("Physical") || value.equals("Special")) {
                        move.setCategory(value);
                        if (move.getPower() <= 0) {
                            move.setPower(1);
                            System.out.println("Also set Base Power to 1");
                            pause();
                        }
                    } else {
                        System.out.println("Not a valid category.");
                        pause();
                    }
                    break;
                }
                case "Target": {
                    clear();
                    System.out.printf("Editting %s\n--------------------\nCurrent target: ", move);
                    System.out.printf("%s (%s)\n\n", move.getTarget(), Target.getTargetName(move.getTarget()));
                    System.out.println("Target Options: ");
                    for (String s : Target.targetCodes) {
                        System.out.printf("- %s (%s)\n", s, Target.getTargetName(s));
                    }
                    System.out.print("\nNew Target Code: ");
                    String value = readString();
                    if (Target.isTargetCode(value)) {
                        move.setTarget(value);
                    } else {
                        System.out.println("Invalid target code.");
                        pause();
                    }
                    break;
                }
                case "Priority": {
                    System.out.print("New Priority: ");
                    String input = readString();
                    try {
                        int value = Integer.parseInt(input);
                        move.setPriority(value);
                    } catch (NumberFormatException e) {
                        System.out.println("Priority must be a number.");
                        pause();
                    }
                    break;
                }
                case "Flags": {
                    sub: while (true) {
                        clear();
                        System.out.printf("Editting %s\n--------------------\nActive Flags: \n", move);
                        
                        for (char c : Flags.flagCodes) {
                            if (move.hasFlag(c)) {
                                System.out.printf("- %c (%s)\n", c, Flags.getFlagName(c));
                            }
                        }
                        
                        System.out.println("--------------------\nInactive Flags: ");

                        for (char c : Flags.flagCodes) {
                            if (!move.hasFlag(c)) {
                                System.out.printf("- %c (%s)\n", c, Flags.getFlagName(c));
                            }
                        }

                        System.out.print("\nToggle Flag: ");
                        String flag = readString().toLowerCase();
                        if (flag.length() <= 0) {
                            break sub;
                        } else if (flag.length() != 1) {
                            System.out.println("Flag can only be a single character");
                            pause();
                        } else {
                            char f = flag.charAt(0);
                            if (Flags.isFlag(f)) {
                                if (!move.hasFlag(f)) {
                                    move.setFlags(move.getFlags() + f);
                                } else {
                                    move.setFlags(move.getFlags().replace(f + "", ""));
                                }
                            } else {
                                System.out.println("Invalid flag name");
                                pause();
                            }
                        }
                    }
                    break;
                }
                case "Function Code": {
                    System.out.print("New Function Code: ");
                    String code = readFunctionCode();
                    if (code == null) {
                        pause();
                    } else {
                        move.setFunction(code);
                    }
                    break;
                }
                case "Copy Function of Other Move": {
                    System.out.print("Enter Move Name: ");
                    Move copyMove = pokedex.getMove(readString());
                    if (copyMove != null) {
                        move.setFunction(copyMove.getFunction());
                    } else {
                        System.out.println("That move does not exist.");
                        pause();
                    }
                    break;
                }
                case "Effect Chance": {
                    System.out.print("New Effect Chance: ");
                    int value = readInt();
                    if (value < 0 || value > 100) {
                        System.out.println("Chance must be a number between 0-100.");
                        pause();
                    } else {
                        move.setEffectChance(value);
                    }
                    break;
                }
                case "Description": {
                    System.out.println("New Description: ");
                    String value = readString().replace("Pokemon", "Pokémon").replace("pokemon", "Pokémon");
                    if (value.length() > 0) {
                        move.setDescription(value);
                    }
                    break;
                }
            }
        }

    }

    private static void editItem(Item item) {

        clear();

        String command;
        loop: while (true) {
            String[] choices = {"Back",
            String.format("Internal Name (%s)", item.getInternalName()),
            String.format("Display Name (%s)", item.getName()),
            String.format("Plural Name (%s)", item.getPluralName()),
            String.format("Pocket (%d: %s)", item.getPocket(), Item.pocketNames[item.getPocket() - 1]),
            String.format("Price (%d)", item.getPrice()),
            String.format("Use Field (%d: %s)", item.getUseField(), Item.usesField[item.getUseField()]),
            String.format("Use Battle (%d: %s)", item.getUseBattle(), Item.usesBattle[item.getUseBattle()]),
            String.format("Special Item (%d: %s)", item.getSpecialItem(), Item.specialItems[item.getSpecialItem()]),
            String.format("Description (%s)", item.getDescription()),
            String.format("TM Move (%s)", item.hasTM() ? item.getTM() : "None")};
            command = menu(String.format("Editting %s\nSelect what to edit.", item), choices);
            if (command.contains("(")) {
                command = command.substring(0, command.indexOf("(") - 1);
            }
            switch (command) {
                case "Back": {
                    break loop;
                }
                case "Internal Name": {
                    System.out.print("New Internal Name: ");
                    String value = readString().toUpperCase().replace(" ", "");
                    if (value.length() > 0) {
                        if (pokedex.itemInternalNameExists(value)) {
                            System.out.println("An item already has this internal name");
                            pause();
                        } else {
                            item.setInternalName(value);
                        }
                    }
                    break;
                }
                case "Display Name": {
                    System.out.print("New Display Name: ");
                    String value = readString();
                    if (value.length() > 0) {
                        item.setName(value);
                        if (value.toLowerCase().charAt(value.length() - 1) != 's') {
                            item.setPluralName(value + "s");
                        } else {
                            item.setPluralName(value);
                        }
                    }
                    break;
                }
                case "Plural Name": {
                    System.out.print("New Plural Name: ");
                    String value = readString();
                    if (value.length() > 0) {
                        item.setPluralName(value);
                    }
                    break;
                }
                case "Pocket": {
                    clear();
                    System.out.printf("Editting %s\n--------------------\nCurrent Pocket: %d (%s)\n",
                        item, item.getPocket(), Item.pocketNames[item.getPocket() - 1]);
                    System.out.printf("0) Back\n");
                    for (int i = 0; i < Item.pocketNames.length; i++) {
                        System.out.printf("%d) %s\n", i+1, Item.pocketNames[i]);
                    }
                    System.out.print("\nNew Pocket: ");
                    int value = readInt();
                    if (value < 0 || value > Item.pocketNames.length) {
                        System.out.println("Invalid value.");
                        pause();
                    } else if (value != 0) {
                        item.setPocket(value);
                    }
                    break;
                }
                case "Price": {
                    System.out.print("New Price (0=unsellable): ");
                    int value = readInt();
                    if (value < 0) {
                        System.out.println("Item price has to be a number that's at least 0.");
                        pause();
                    } else {
                        item.setPrice(value);
                    }
                    break;
                }
                case "Use Field": {
                    clear();
                    System.out.printf("Editting %s\n--------------------\nCurrent Field Use: %s\n",
                        item, Item.usesField[item.getUseField()]);
                    for (int i = 0; i < Item.usesField.length; i++) {
                        System.out.printf("%d) %s\n", i, Item.usesField[i]);
                    }
                    System.out.print("\nNew Use: ");
                    int value = readInt();
                    if (value < 0 || value >= Item.usesField.length) {
                        System.out.println("Invalid value.");
                        pause();
                    } else {
                        item.setUseField(value);
                    }
                    break;
                }
                case "Use Battle": {
                    clear();
                    System.out.printf("Editting %s\n--------------------\nCurrent Battle Use: %s\n",
                        item, Item.usesBattle[item.getUseBattle()]);
                    for (int i = 0; i < Item.usesBattle.length; i++) {
                        System.out.printf("%d) %s\n", i, Item.usesBattle[i]);
                    }
                    System.out.print("\nNew Use: ");
                    int value = readInt();
                    if (value < 0 || value >= Item.usesBattle.length) {
                        System.out.println("Invalid value.");
                        pause();
                    } else {
                        item.setUseBattle(value);
                    }
                    break;
                }
                case "Special Item": {
                    clear();
                    System.out.printf("Editting %s\n--------------------\nCurrent Special Item Type: %s\n",
                        item, Item.specialItems[item.getSpecialItem()]);
                    for (int i = 0; i < Item.specialItems.length; i++) {
                        System.out.printf("%d) %s\n", i, Item.specialItems[i]);
                    }
                    System.out.print("\nNew Special Type: ");
                    int value = readInt();
                    if (value < 0 || value >= Item.specialItems.length) {
                        System.out.println("Invalid value.");
                        pause();
                    } else {
                        item.setSpecialItem(value);
                    }
                    break;
                }
                case "Description": {
                    System.out.println("New Description: ");
                    String value = readString().replace("Pokemon", "Pokémon").replace("pokemon", "Pokémon");
                    if (value.length() > 0) {
                        item.setDescription(value);
                    }
                    break;
                }
                case "TM Move": {
                    System.out.print("Move Name: ");
                    Move move = pokedex.getMove(readString());
                    if (move != null) {
                        item.setTM(move);
                        item.setPocket(4);
                        item.setUseField(3);
                        item.setUseBattle(0);
                        item.setSpecialItem(0);
                        item.setDescription(move.getDescription());
                    } else {
                        System.out.println("That move does not exist.");
                        pause();
                    }
                    break;
                }
            }
        }

    }

    private static boolean addMenu() {
        String[] choices = {"Back", "Add New Pokemon", "Add New Move", "Add New Item", "Add New Trainer"};

        String command;
        loop: while (true) {
            command = menu("Choose what to add", choices);
            switch (command) {
                case "Back": {
                    break loop;
                }
                case "Add New Pokemon": {
                    System.out.println("\nRemember to fill in all fields in the edit menu after adding the new Pokemon.");
                    System.out.print("Internal Name: ");
                    String internalName = readString().toUpperCase().replace(" ", "");
                    if (pokedex.pokemonInternalNameExists(internalName)) {
                        System.out.println("A Pokemon already has that internal name.");
                        pause();
                        break;
                    }
                    System.out.print("Display Name: ");
                    String name = readString();
                    Pokemon pokemon = new Pokemon(pokedex.getNextPokemonID(), pokedex);
                    pokemon.setInternalName(internalName);
                    pokemon.setName(name);
                    pokedex.addPokemon(pokemon);
                    editPokemon(pokemon);
                    break;
                }
                case "Add New Move": {
                    System.out.println("\nRemember to fill in all fields in the edit menu after adding the new Move.");
                    System.out.print("Internal Name: ");
                    String internalName = readString().toUpperCase().replace(" ", "");
                    if (pokedex.moveInternalNameExists(internalName)) {
                        System.out.println("A Move already has that internal name.");
                        pause();
                        break;
                    }
                    System.out.print("Display Name: ");
                    String name = readString();
                    Move move = new Move(pokedex.getNextMoveID());
                    move.setInternalName(internalName);
                    move.setName(name);
                    pokedex.addMove(move);
                    editMove(move);
                    break;
                }
                case "Add New Item": {
                    System.out.println("\nRemember to fill in all fields in the edit menu after adding the new Item.");
                    System.out.print("Internal Name: ");
                    String internalName = readString().toUpperCase().replace(" ", "");
                    if (pokedex.itemInternalNameExists(internalName)) {
                        System.out.println("An Item already has that internal name.");
                        pause();
                        break;
                    }
                    System.out.print("Display Name: ");
                    String name = readString();
                    Item item = new Item(pokedex.getNextItemID());
                    item.setInternalName(internalName);
                    item.setName(name);
                    pokedex.addItem(item);
                    editItem(item);
                    break;
                }
                case "Add New Trainer": {
                    System.out.println("\nRemember to fill in all fields in the edit menu after adding the new Trainer.");
                    System.out.print("Trainer Type: ");
                    String name = readString();
                    TrainerType type = pokedex.getTrainerType(name);
                    if (type == null && name.length() >= 3) {
                        for (TrainerType t : pokedex.getTrainerTypes()) {
                            if (t.getInternalName().toLowerCase().contains(name.toLowerCase())) {
                                System.out.printf("Did you mean %s? (Type 'y' to confirm)\n", t);
                                if (readString().toLowerCase().equals("y")) {
                                    type = t;
                                    break;
                                }
                            }
                        }
                    }
                    if (type == null) {
                        System.out.println("Invalid trainer type.");
                        pause();
                        break;
                    }
                    System.out.print("Trainer Name: ");
                    name = readString();
                    Trainer trainer = new Trainer(type, name);
                    trainer.addPokemon(new PartyPokemon(pokedex.getPokemon("DITTO"), 1));
                    trainer.setVersion(pokedex.getNextTrainerVersion(name, type));
                    pokedex.addTrainer(trainer);
                    editTrainer(trainer);
                    break;
                }
            }
        }
        return true;
    }

    private static void pokemonEditEggMoves(Pokemon pokemon) {

        while (true) {
            clear();
            System.out.println("ADD/REMOVE EGG MOVES");
            System.out.println("Write a move name that is already on");
            System.out.println("the list to delete it.");
            System.out.println("Press ENTER without writing to quit.");
            System.out.println("----------------------");
    
            pokedex.printEggMoves(pokemon);
    
            System.out.print("\nMove Name: ");
            String moveName = readString();
            if (moveName.length() <= 0) {
                return;
            }
            Move move = pokedex.getMove(moveName);
            if (move == null) {
                System.out.println("That move does not exist.\n");
                pause();
            } else {
                if (!pokemon.removeEggMove(move)) {
                    pokemon.addEggMove(move);
                }
            }
        }
    }

    private static void pokemonEditTMMoves(Pokemon pokemon) {

        while (true) {
            clear();
            System.out.println("ADD/REMOVE TM/TUTOR MOVES");
            System.out.println("Write a move name that is already on");
            System.out.println("the list to delete it.");
            System.out.println("Press ENTER without writing to quit.");
            System.out.println("-------------------");
    
            pokedex.printTMMoves(pokemon);
    
            System.out.print("\nMove Name: ");
            String moveName = readString();
            if (moveName.length() <= 0) {
                return;
            }
            Move move = pokedex.getMove(moveName);
            if (move == null) {
                System.out.println("That move does not exist.\n");
                pause();
            } else {
                TM tm = pokedex.getTM(move);
                if (tm == null) {
                    tm = new TM(move);
                    pokedex.addTM(tm);
                }
                if (!tm.removePokemon(pokemon)) {
                    tm.addPokemon(pokemon);
                }
            }
        }
    }

    private static void pokemonEditLevelMoves(Pokemon pokemon) {

        while (true) {
            clear();
            System.out.println("ADD/REMOVE LEVEL UP MOVES");
            System.out.println("Write a move name and level that ");
            System.out.println("is already on the list to delete it.");
            System.out.println("Press ENTER without writing to quit.");
            System.out.println("----------------------");
    
            pokedex.printLevelMoves(pokemon);
    
            System.out.print("\nMove Name: ");
            String moveName = readString();
            if (moveName.length() <= 0) {
                return;
            } else if (moveName.toLowerCase().equals("clear")) {
                for (int i = 1; i < 100; i++) {
                    if (pokemon.getLevelMoves().containsKey(i)) {
                        ArrayList<Move> levelMoves = pokemon.getLevelMoves().get(i);
                        if (levelMoves != null) {
                            levelMoves.clear();
                        }
                    }
                }
            } else {
                Move move = pokedex.getMove(moveName);
                if (move == null) {
                    System.out.println("That move does not exist.\n");
                    pause();
                } else {
                    System.out.print("Level: ");
                    int level = readInt();
                    if (level < 1 || level > 100) {
                        System.out.println("Level must be a number between 1-100.\n");
                        pause();
                    } else {
                        if (!pokemon.removeLevelMove(level, move)) {
                            pokemon.addLevelMove(level, move);
                        }
                    }
                }
            }
        }
    }

    private static void pokemonEditEchoLevelMoves(Pokemon pokemon) {

        while (true) {
            clear();
            System.out.println("ADD/REMOVE ECHO LEVEL UP MOVES");
            System.out.println("Write a move name and level that ");
            System.out.println("is already on the list to delete it.");
            System.out.println("Press ENTER without writing to quit.");
            System.out.println("----------------------");
    
            pokedex.printEchoLevelMoves(pokemon);
    
            System.out.print("\nMove Name: ");
            String moveName = readString();
            if (moveName.length() <= 0) {
                return;
            }
            Move move = pokedex.getMove(moveName);
            if (move == null) {
                System.out.println("That move does not exist.\n");
                pause();
            } else {
                System.out.print("Level: ");
                int level = readInt();
                if (level < 1 || level > 100) {
                    System.out.println("Level must be a number between 1-100.\n");
                    pause();
                } else {
                    if (!pokemon.removeEchoLevelMove(level, move)) {
                        pokemon.addEchoLevelMove(level, move);
                    }
                }
            }
        }
    }

    private static void moveEditLevelMoves(Move move) {

        while (true) {
            clear();
            System.out.println("ADD/REMOVE LEVEL UP MOVES");
            System.out.println("Write a pokemon name and level that is");
            System.out.println("already on the list to delete it.");
            System.out.println("Press ENTER without writing to quit.");
            System.out.println("---------------------------------------------------------");

            int x = 1;
            for (Pokemon p : pokedex.getPokedex()) {
                for (int i = 0; i < 100; i++) {
                    if (p.getLevelMoves().containsKey(i)) {
                        if (p.getLevelMoves().get(i).contains(move)) {
                            if (x >= 3) {
                                System.out.printf(" lv%3d %-12s\n", i, p.getName());
                                x = 0;
                            } else {
                                System.out.printf(" lv%3d %-12s ", i, p.getName());
                            }
                            x++;
                        }
                    }
                }
            }
            if (x != 0) {
                System.out.println("");
            }
    
            System.out.print("\nPokemon Name: ");
            String pokeName = readString();
            if (pokeName.length() <= 0) {
                return;
            }
            Pokemon pokemon = pokedex.getPokemon(pokeName);
            if (pokemon == null) {
                System.out.println("That pokemon does not exist.\n");
                pause();
            } else {
                System.out.print("Level: ");
                int level = readInt();
                if (level < 1 || level > 100) {
                    System.out.println("Level must be a number between 1-100.\n");
                    pause();
                } else {
                    if (!pokemon.removeLevelMove(level, move)) {
                        pokemon.addLevelMove(level, move);
                    }
                }
            }
        }
    }

    private static void moveEditEggMoves(Move move) {

        while (true) {
            clear();
            System.out.println("ADD/REMOVE EGG MOVES");
            System.out.println("Write a pokemon name that is already on");
            System.out.println("the list to delete it.");
            System.out.println("Press ENTER without writing to quit.");
            System.out.println("---------------------------------------------------------");

            ArrayList<Pokemon> pokemonList = pokedex.getPokemonThatLearnEggMove(move);

            int i = 1;
            for (Pokemon p : pokemonList) {
                if (i >= 4) {
                    System.out.printf(" %-12s\n", p.getName());
                    i = 0;
                } else {
                    System.out.printf(" %-12s ", p.getName());
                }
                i++;
            }
            if (i != 0) {
                System.out.println("");
            }
    
            System.out.print("\nPokemon Name: ");
            String pokeName = readString();
            if (pokeName.length() <= 0) {
                return;
            }
            Pokemon pokemon = pokedex.getPokemon(pokeName);
            if (pokemon == null) {
                System.out.println("That pokemon does not exist.\n");
                pause();
            } else {
                if (!pokemon.removeEggMove(move)) {
                    pokemon.addEggMove(move);
                }
            }
        }
    }

    private static void moveEditTMMoves(Move move) {

        while (true) {
            clear();
            System.out.println(move.getName().toUpperCase() + " - ADD/REMOVE TM/TUTOR MOVES");
            System.out.println("Write a pokemon name that is already on");
            System.out.println("the list to delete it.");
            System.out.println("Evolutions are automatically added unless removed.");
            System.out.println("Press ENTER without writing to quit.");
            System.out.println("Write 'SMOGON' in all caps to import from Smogon.com");
            System.out.println("---------------------------------------------------------");

            TM tm = pokedex.getTM(move);
            if (tm == null) {
                tm = new TM(move);
                pokedex.addTM(tm);
            }

            ArrayList<Pokemon> pokemonList = tm.getPokemon();

            int i = 1;
            for (Pokemon p : pokemonList) {
                if (i >= 5) {
                    System.out.printf(" %-12s\n", p.getName());
                    i = 0;
                } else {
                    System.out.printf(" %-12s ", p.getName());
                }
                i++;
            }
            if (i != 0) {
                System.out.println("");
            }
    
            System.out.print("\nPokemon Name: ");
            String pokeName = readString();
            if (pokeName.length() <= 0) {
                return;
            }
            if (pokeName.equals("SMOGON")) {
                clear();
                System.out.println("Do you want to import data from Smogon? (Type 'yes' to continue)");
                if (readString().toLowerCase().equals("yes")) {
                    System.out.println("Downloading...");
                    String url = "https://www.smogon.com/dex/sm/moves/" + move.getName().replace(" ", "_") + "/";
                    Parser parser = new Parser(url);
                    parser.fetch();
                    parser.parseContent();
                    ArrayList<String> internalNames = parser.getContent();
                    ArrayList<String> internalNamesForms = parser.getContent2();
                    if (internalNames.size() > 0) {
                        for (String s : internalNames) {
                            Pokemon pokemon = pokedex.getPokemon(s.trim());
                            if (pokemon == null) {
                                System.out.printf("> Could not find the Pokemon %s.\n", s.trim());
                            } else {
                                tm.addPokemon(pokemon);
                            }
                        }
                    }
                    if (internalNamesForms.size() > 0) {
                        System.out.printf("\nThese special forms can also learn %s\n", move);
                        for (String s : internalNamesForms) {
                            System.out.println("- " + s);
                        }
                    }
                    if (internalNames.size() > 0 || internalNamesForms.size() > 0) {
                        System.out.println("\nSuccessfully imported Pokemon");
                    } else {
                        System.out.println("\nNo Pokemon can learn this move");
                    }
                    pause();
                    pokedex.sortTM(tm);
                }
            } else {
                Pokemon pokemon = pokedex.getPokemon(pokeName);
                if (pokemon == null) {
                    System.out.println("That pokemon does not exist.\n");
                    pause();
                } else {
                    if (!tm.removePokemon(pokemon)) {
                        tm.addPokemon(pokemon);
                        pokedex.sortTM(tm);
                    }
                }
            }
        }
    }

    private static void editEvolutionMoves() {

        String prev = "";

        loop: while (true) {

            clear();

            System.out.println("MASS-EDIT EVOLUTION MOVES");
            System.out.println("Type the Pokemon, then the move.");
            System.out.println("Press ENTER without writing to exit.");
            System.out.println("-------------------------------------");
            System.out.printf("%s\n\n", prev);
            prev = "";

            System.out.print("Pokemon: ");
            String pokename = readString();
            if (pokename.length() <= 0) {
                break loop;
            }
            Pokemon pokemon = pokedex.getPokemon(pokename);
            if (pokemon == null) {
                System.out.println("That pokemon does not exist.");
                pause();
            } else {
                System.out.print("Move:    ");
                String movename = readString();
                Move move = pokedex.getMove(movename);
                if (move == null) {
                    System.out.println("That move does not exist.");
                    pause();
                } else {
                    pokemon.setEvolutionMove(move);
                    prev = String.format("> %s was given the evolution move %s\n", pokemon, move);
                }
            }

        }

    }

    private static void editAffinities() {

        ArrayList<String> prev = new ArrayList<>();

        loop: while (true) {

            clear();

            System.out.println("MASS-EDIT AFFINITIES");
            System.out.println("Type the Pokemon, then the type.");
            System.out.println("Press ENTER without writing to exit.");
            System.out.println("-------------------------------------");
            for (String s : prev) {
                System.out.printf("%s\n", s);
            }
            System.out.println("");

            System.out.print("Pokemon: ");
            String pokename = readString();
            if (pokename.length() <= 0) {
                break loop;
            }
            Pokemon pokemon = pokedex.getPokemon(pokename);
            if (pokemon == null) {
                System.out.println("That pokemon does not exist.");
                pause();
            } else {
                System.out.print("Type:    ");
                String typename = readString().toUpperCase();
                if (!Types.isType(typename)) {
                    System.out.println("That type does not exist.");
                    pause();
                } else {
                    pokemon.setType3(typename);
                    prev.add(String.format("> %s was given the affinity %s\n", pokemon, typename));
                }
            }

        }

    }

    private static Pokemon selectPokemon() {
        String name = readString();
        return pokedex.getPokemon(name);
    }

    private static Move selectMove() {
        String name = readString();
        return pokedex.getMove(name);
    }

    private static Item selectItem() {
        String name = readString();
        return pokedex.getItem(name);
    }

    private static ArrayList<Trainer> selectTrainersByName(String name) {
        if (name == null) {
            name = readString();
        }
        return pokedex.getTrainersByName(name);
    }

    private static ArrayList<Trainer> selectTrainersByType(String name) {
        if (name == null) {
            name = readString().replace(" ", "_");
        }
        ArrayList<Trainer> results = pokedex.getTrainersByType(name);
        if (results.size() <= 0 && name.length() >= 3) {
            for (TrainerType t : pokedex.getTrainerTypes()) {
                if (t.getInternalName().toLowerCase().contains(name.toLowerCase())) {
                    System.out.printf("Did you mean %s? (Type 'y' to confirm)\n", t);
                    if (readString().toLowerCase().equals("y")) {
                        results = pokedex.getTrainersByType(t.getInternalName());
                    }
                    if (results.size() > 0) {
                        break;
                    }
                }
            }
        }
        return results;
    }

    private static ArrayList<Trainer> selectTrainersByComment(String search) {
        if (search == null) {
            search = readString();
        }
        return pokedex.getTrainersByComment(search);
    }

    private static String menu(String title, String[] choices) {
        clear();

        System.out.printf("%s\n------------------------\n", title);

        for (int i = 0; i < choices.length; i++) {
            System.out.printf("%d) %s\n", i, choices[i]);
        }

        String choiceString = "";
        int choice = -1;
        while (choice < 0 || choice >= choices.length) {
            System.out.print("Choice: ");
            choiceString = readString();
            if (choiceString.length() <= 0) {
                choice = 0;
            } else {
                try {
                    choice = Integer.parseInt(choiceString);
                } catch (NumberFormatException e) {
                    choice = -1;
                }
            }
            if (choice < 0 || choice >= choices.length) {
                System.out.println("Invalid command.");
                pause();
            } else {
                String command = choices[choice];
                return command;
            }
            clear();
            System.out.printf("%s\n------------------------\n", title);
            for (int i = 0; i < choices.length; i++) {
                System.out.printf("%d) %s\n", i, choices[i]);
            }
        }
        return "";
    }

    private static String readString() {
        String line = scanner.nextLine();
        return line;
    }

    private static int readInt() {
        String line = scanner.nextLine();
        try {
            int i = Integer.parseInt(line);
            return i;
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private static double readDouble() {
        String line = scanner.nextLine();
        try {
            double i = Double.parseDouble(line);
            return i;
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private static void clear() {
        try {
            if (System.getProperty("os.name").equals("Linux")) {
                System.out.print("\033[H\033[2J");
                System.out.flush();
            } else {
                new ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor();
            }
        } catch (IOException e) {

        } catch (InterruptedException e) {

        }
        System.out.println("");
    }

    private static String toProper(String s) {
        String newString = "";
        for (int i = 0; i < s.length(); i++) {
            if (i == 0) {
                newString += s.substring(i, i+1).toUpperCase();
            } else {
                newString += s.substring(i, i+1).toLowerCase();
            }
        }
        return newString;
    }

    private static String readFunctionCode() {
        String input = readString().toUpperCase();

        if (input.length() != 3) {
            System.out.println("Function code must be 3 characters long.");
            return null;
        } else {
            String chars = "0123456789ABCDEF";

            for (int i = 0; i < input.length(); i++) {
                if (!chars.contains(input.substring(i, i+1))) {
                    System.out.println("Function codes can only contain 0-9 and A-F.");
                    return null;
                }
            }
            return input;
        }
    }

}