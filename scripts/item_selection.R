library(tidyverse)
library(brms)


data <- read_csv("../data/previc_data.csv")%>%
  mutate(age_group = factor(substr(age, 1,1)))

irt1_fit_sel <- readRDS("../saves/irt1_fit_sel.rds")

mi <- readRDS("../saves/miAllSel.rds")%>%arrange(rhs)%>%pull(mi)
items <-data%>%filter(word %in% readRDS("../saves/fit_selected_items.rds"))%>%distinct(word)%>%arrange(word)%>%pull(word)
easiness_1PL_fit_sel <- ranef(irt1_fit_sel)$word%>%as_tibble(rownames = "word")%>%arrange(word) %>%pull(Estimate.Intercept)
infit_fit_sel <- readRDS("../saves/rasch_fit_mode_fit_sel.rds") %>% filter(fit_index == "infit")%>%arrange(word)%>% pull(mode)
outfit_fit_sel <- readRDS("../saves/rasch_fit_mode_fit_sel.rds") %>% filter(fit_index == "outfit")%>%arrange(word)%>% pull(mode)

source("../scripts/helper/simulated_annealing.R")

selection <- tibble()

for(j in c(70,75,80,85,90,95,100,125,150,175,200)){
  
  for (i in c(1:20)) {
    
    sim <- simulated_annealing_rasch(j)
    
    sel <- items[unlist(sim$best_subset) == TRUE]
    
    x <- tibble(items = list(sel), size = j, iter = i)
    
    selection <- bind_rows(selection, x)
    
    saveRDS(selection, "../saves/item_selection.rds")
  }
  
}
