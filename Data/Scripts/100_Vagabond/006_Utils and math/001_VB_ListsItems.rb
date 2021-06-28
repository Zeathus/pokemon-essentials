def pbRandomFossil
  fossils = [
  PBItems::DOMEFOSSIL,
  PBItems::HELIXFOSSIL,
  PBItems::ROOTFOSSIL,
  PBItems::CLAWFOSSIL,
  PBItems::SKULLFOSSIL,
  PBItems::ARMORFOSSIL,
  PBItems::PLUMEFOSSIL,
  PBItems::COVERFOSSIL,
  PBItems::SAILFOSSIL,
  PBItems::JAWFOSSIL]
  shuffled=fossils.shuffle
  return shuffled[0]
end

def pbRandomBerry
  berries = [
  PBItems::SITRUSBERRY,
  PBItems::LUMBERRY,
  PBItems::YACHEBERRY,
  PBItems::CHARTIBERRY,
  PBItems::BABIRIBERRY,
  PBItems::CHILANBERRY,
  PBItems::CHOPLEBERRY,
  PBItems::COBABERRY,
  PBItems::COLBURBERRY,
  PBItems::HABANBERRY,
  PBItems::KASIBBERRY,
  PBItems::KEBIABERRY,
  PBItems::OCCABERRY,
  PBItems::PASSHOBERRY,
  PBItems::PAYAPABERRY,
  PBItems::RINDOBERRY,
  PBItems::SHUCABERRY,
  PBItems::TANGABERRY,
  PBItems::WACANBERRY]
  shuffled=berries.shuffle
  return shuffled[0]
end