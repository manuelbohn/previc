library(catR)
library(jsonlite)

for(i in c(1:500)){
  seed = 12345 + i
  #generated item bank
  item_bank = catR::genDichoMatrix(50, model = "1PL", seed = seed)
  #generate response pattern for an ability level of 0.5
  response_pattern = catR::genPattern(0.5, item_bank, seed = seed)
  
  
  jsonlite::write_json(item_bank, paste("generated/item_bank", i, ".json"))
  jsonlite::write_json(response_pattern, paste("generated/response_pattern", i, ".json"))
  
  
  #calculate estimated ability level
  estimation = catR::thetaEst(item_bank, response_pattern, method = "ML")
  jsonlite::write_json(estimation, paste("generated/estimation", i, ".json"))
}
