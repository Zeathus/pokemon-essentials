import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class PokemonTests {

    private static PokemonSystem pokedex;
    private static Scanner scanner;
    public static void main(String[] args) {

        clear();

        pokedex = new PokemonSystem(false,
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

        String[] choices = {"Exit", "Move Upgrade Availability"};

        for (int i = 0; i < choices.length; i++) {
            System.out.printf("%d) %s\n", i, choices[i]);
        }

        String command;
        loop: while (true) {
            command = menu(choices);
            switch (command) {
                case "Exit": {
                    System.out.println("Exitting program...");
                    pause();
                    break loop;
                }
                case "Move Upgrade Availability": {
                    moveUpgradeAvailability();
                }
            }
        }

    }

    private static String menu(String[] choices) {
        clear();

        for (int i = 0; i < choices.length; i++) {
            System.out.printf("%d) %s\n", i, choices[i]);
        }

        int choice = -1;
        while (choice < 0 || choice >= choices.length) {
            System.out.print("Choice: ");
            choice = readInt();
            if (choice < 0 || choice >= choices.length) {
                System.out.println("Invalid command.");
                pause();
            } else {
                String command = choices[choice];
                return command;
            }
            clear();
            for (int i = 0; i < choices.length; i++) {
                System.out.printf("%d) %s\n", i, choices[i]);
            }
        }
        return "";
    }

    private static void moveUpgradeAvailability() {
        clear();
        System.out.println("MOVE UPGRADE AVAILABILITY");
        System.out.println("This functionality will show what new Pokemon would");
        System.out.println("be able to learn a move if the first move could be");
        System.out.println("upgraded to the second move.");
        System.out.println("---------------------------------------------------");
        System.out.print("Move 1: ");
        String movename1 = readString().toUpperCase();
        System.out.print("Move 2: ");
        String movename2 = readString().toUpperCase();

        Move move1 = pokedex.getMove(movename1);
        Move move2 = pokedex.getMove(movename2);
        if (move1 == null) {
            System.out.println("The first move does not exist.");
        } else if (move2 == null) {
            System.out.println("The second move does not exist.");
        }

        ArrayList<Pokemon> list1 = pokedex.getPokemonThatLearnMove(move1);
        ArrayList<Pokemon> list2 = pokedex.getPokemonThatLearnMove(move2);

        System.out.println("");

        if (list1.size() <= 0) {
            System.out.println("No Pokemon learn the first move.");
            pause();
            return;
        }
        if (list2.size() <= 0) {
            System.out.println("No Pokemon learn the second move.");
            pause();
            return;
        }

        ArrayList<Pokemon> output = new ArrayList<>();

        for (Pokemon p : list1) {
            if (!list2.contains(p)) {
                output.add(p);
            }
        }

        if (output.size() <= 0) {
            System.out.printf("No new Pokemon would be able to learn %s.\n", move2.getName());
        } else {
            System.out.printf("These Pokemon can learn %s but not %s:\n", move1.getName(), move2.getName());
            for (Pokemon p : output) {
                System.out.printf("- %s\n", p.toString());
            }
        }

        pause();
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

    private static void clear() {
        try {
            new ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor();
        } catch (IOException e) {

        } catch (InterruptedException e) {

        }
        System.out.println("");
    }

}