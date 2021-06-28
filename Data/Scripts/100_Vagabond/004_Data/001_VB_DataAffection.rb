module PBChar
  Player    = 0
  Nekane    = 1
  Amethyst  = 2
  Kira      = 3
  Eliana    = 4
  Admin2    = 5
  DaoBoss   = 6
  Duke      = 7
end

def pbSetAffection(char, a=0)
  pbSet(AFFECTION, []) if !pbGet(AFFECTION).is_a?(Array)
  char=getID(PBChar, char) if char.is_a?(Symbol)
  pbGet(AFFECTION)[char]=a
end

def pbAddAffection(char, a=1)
  pbSet(AFFECTION, []) if !pbGet(AFFECTION).is_a?(Array)
  char=getID(PBChar, char) if char.is_a?(Symbol)
  pbGet(AFFECTION)[char]=0 if !pbGet(AFFECTION)[char]
  pbGet(AFFECTION)[char]+=a
end

def pbGetAffection(char)
  pbSet(AFFECTION, []) if !pbGet(AFFECTION).is_a?(Array)
  char=getID(PBChar, char) if char.is_a?(Symbol)
  pbGet(AFFECTION)[char]=0 if !pbGet(AFFECTION)[char]
  pbGet(AFFECTION)[char]
end