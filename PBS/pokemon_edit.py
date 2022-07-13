import re
from selenium import webdriver
from time import sleep

def print_tutor_move(lines, move):
    pkmn = ""
    for l in lines:
        if "InternalName" in l:
            pkmn = l.replace("InternalName = ", "").strip()
        if "TutorMoves" in l:
            l = l.replace("TutorMoves = ", "")
            tutor_moves = l.split(",")
            if move in tutor_moves:
                print(pkmn)

def add_tutor_move(lines, pkmn, move, remove=False):
    i = 0

    while True:
        if i >= len(lines):
            print("Failed to find", pkmn)
            return
        l = lines[i]
        if "InternalName" in l:
            if l.replace("InternalName = ", "").strip() == pkmn:
                break
        i += 1

    while True:
        l = lines[i]
        if "[" in l:
            print("Failed to find tutor moves for", pkmn)
            return
        if "TutorMoves" in l:
            l = l.replace("TutorMoves = ", "")
            tutor_moves = l.split(",")
            if move in tutor_moves:
                if remove:
                    tutor_moves.remove(move)
                    lines[i] = "TutorMoves = " + ",".join(tutor_moves)
                    print("Removed", move, "from", pkmn)
                else:
                    print("Move already in TutorMoves")
            else:
                if remove:
                    print("Move not in TutorMoves")
                else:
                    tutor_moves.append(move)
                    lines[i] = "TutorMoves = " + ",".join(tutor_moves)
                    print("Added", move, "to", pkmn)
            return
        i += 1

def main():
    f = open("pokemon.txt", "r", encoding="utf-8")
    lines = [i.replace("\n", "") for i in f.readlines()]
    f.close()

    move = input("Tutor Move: ").upper()
    pkmn = input("Pokemon: ").upper()

    while len(pkmn) > 1:
        if pkmn == "SMOGON":
            driver = webdriver.Firefox()
            driver.get("https://www.smogon.com/dex/sm/moves/%s/" % move.lower())
            sleep(10)
            names = driver.find_elements_by_class_name("PokemonAltRow-name")
            for n in names:
                innerHTML = n.get_attribute("innerHTML")
                pkmn = re.search("/dex/sm/pokemon/([^/]+)", innerHTML)
                pkmn = pkmn.group(1).upper()
                for i in ["-", "'", " ", ":"]:
                    pkmn = pkmn.replace(i, "")
                add_tutor_move(lines, pkmn, move)
            driver.close()
        elif pkmn == "LIST":
            print_tutor_move(lines, move)
        elif pkmn[:1] == "-":
            add_tutor_move(lines, pkmn[1:], move, True)
        else:
            add_tutor_move(lines, pkmn, move)
        pkmn = input("Pokemon: ").upper()

    f = open("pokemon.txt", "w", encoding="utf-8")
    for l in lines:
        f.write(l)
        f.write("\n")

if __name__ == "__main__":
    main()