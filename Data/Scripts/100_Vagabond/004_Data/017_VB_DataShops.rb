def pbShopScoriaStatBerries
  items = [
    PBItems::POMEGBERRY,
    PBItems::KELPSYBERRY,
    PBItems::QUALOTBERRY,
    PBItems::HONDEWBERRY,
    PBItems::GREPABERRY,
    PBItems::TAMATOBERRY
  ]
  for i in items
    setPrice(i,200)
  end
  return items
end

def pbShopScoriaSeeds
  items = [
    PBItems::ELECTRICSEED,
    PBItems::GRASSYSEED,
    PBItems::MISTYSEED,
    PBItems::PSYCHICSEED,
    PBItems::MIRACLESEED,
    PBItems::ABSORBBULB,
    #PBItems::LUMINOUSMOSS
  ]
  for i in items
    setPrice(i,400)
  end
  setPrice(:MIRACLESEED,1000)
  setPrice(:ABSORBBULB,300)
  return items
end

def pbShopScoriaBerries
  items = [
    PBItems::BABIRIBERRY,
    PBItems::CHARTIBERRY,
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
    PBItems::ROSELIBERRY,
    PBItems::SHUCABERRY,
    PBItems::TANGABERRY,
    PBItems::WACANBERRY,
    PBItems::YACHEBERRY
  ]
  for i in items
    setPrice(i,400)
  end
  return items
end

def pbShopScoriaHerbs
  return [
    PBItems::ENERGYPOWDER,
    PBItems::ENERGYROOT,
    PBItems::HEALPOWDER,
    PBItems::REVIVALHERB,
    PBItems::MENTALHERB,
    PBItems::POWERHERB,
    PBItems::WHITEHERB
  ]
end





