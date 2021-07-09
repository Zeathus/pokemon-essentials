def pbShopScoriaStatBerries
  items = [
    :POMEGBERRY,
    :KELPSYBERRY,
    :QUALOTBERRY,
    :HONDEWBERRY,
    :GREPABERRY,
    :TAMATOBERRY
  ]
  for i in items
    setPrice(i,200)
  end
  return items
end

def pbShopScoriaSeeds
  items = [
    :ELECTRICSEED,
    :GRASSYSEED,
    :MISTYSEED,
    :PSYCHICSEED,
    :MIRACLESEED,
    :ABSORBBULB,
    #:LUMINOUSMOSS
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
    :BABIRIBERRY,
    :CHARTIBERRY,
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
    :ROSELIBERRY,
    :SHUCABERRY,
    :TANGABERRY,
    :WACANBERRY,
    :YACHEBERRY
  ]
  for i in items
    setPrice(i,400)
  end
  return items
end

def pbShopScoriaHerbs
  return [
    :ENERGYPOWDER,
    :ENERGYROOT,
    :HEALPOWDER,
    :REVIVALHERB,
    :MENTALHERB,
    :POWERHERB,
    :WHITEHERB
  ]
end





