library(catR)
library(jsonlite)

for(i in c(1:200)){
  seed = 12345+i
  #generate item bank
  item_bank = catR::genDichoMatrix(50, model = "1PL", seed = seed)
  #set response pattern
  response_pattern = c(0)
  
  #select next item
  item = catR::nextItem(item_bank, x = response_pattern)
  selected_item_index = item$item
  
  #save to json
  jsonlite::write_json(item_bank, paste("generated/selection_item", i, ".json"))
  jsonlite::write_json(selected_item_index, paste("generated/selected_item", i, ".json"))
}