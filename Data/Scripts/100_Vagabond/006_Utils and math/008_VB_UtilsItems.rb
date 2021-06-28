def pbFindSphere(item)
  $game_variables[SPHERE_COUNT]+=1
  Kernel.pbReceiveItem(item)
end