def pbRandomFossil
  fossils = [
  :DOMEFOSSIL,
  :HELIXFOSSIL,
  :ROOTFOSSIL,
  :CLAWFOSSIL,
  :SKULLFOSSIL,
  :ARMORFOSSIL,
  :PLUMEFOSSIL,
  :COVERFOSSIL,
  :SAILFOSSIL,
  :JAWFOSSIL]
  shuffled=fossils.shuffle
  return shuffled[0]
end

def pbRandomBerry
  berries = [
  :SITRUSBERRY,
  :LUMBERRY,
  :YACHEBERRY,
  :CHARTIBERRY,
  :BABIRIBERRY,
  :CHILANBERRY,
  :CHOPLEBERRY,
  :COBABERRY,
  :COLBURBERRY,
  :HABANBERRY,
  :KASIBBERRY,
  :KEBIABERRY,
  :OCCABERRY,
  :PASSHOBERRY,
  :PAYAPABERRY,
  :RINDOBERRY,
  :SHUCABERRY,
  :TANGABERRY,
  :WACANBERRY]
  shuffled=berries.shuffle
  return shuffled[0]
end