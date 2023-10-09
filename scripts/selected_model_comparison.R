library(brms)
library(tidyverse)

## load data and models

data <- read_csv("../data/previc_data.csv")%>%
  mutate(age_group = factor(substr(age, 1,1)))

irt_dat <- data%>%
  select(subjID, word, score, sex, aoa_rating_german)

irt1_fit_sel <- readRDS("../saves/irt1_fit_sel.rds")

rasch_fit_mode_fit_sel <- readRDS("../saves/rasch_fit_mode_fit_sel.rds")

irt2PL_fit_sel <- readRDS("../saves/irt2PL_fit_sel.rds")

## make indices

mi <- readRDS("../saves/miAllSel.rds")%>%arrange(rhs)%>%pull(mi)
items <-data%>%filter(word %in% readRDS("../saves/fit_selected_items.rds"))%>%distinct(word)%>%arrange(word)%>%pull(word)
easiness_1PL_fit_sel <- ranef(irt1_fit_sel)$word%>%as_tibble(rownames = "word")%>%arrange(word) %>%pull(Estimate.Intercept)
infit_fit_sel <- rasch_fit_mode_fit_sel %>% filter(fit_index == "infit")%>%arrange(word)%>% pull(mode)
outfit_fit_sel <- rasch_fit_mode_fit_sel %>% filter(fit_index == "outfit")%>%arrange(word)%>% pull(mode)

source("../scripts/simulated_annealing.R")

## compare models and save output

model_comparison <- tibble()

for(j in 1:5){

  for (i in c(70,75,80,85,90,95,100,125, 175)) {

    sim <- simulated_annealing_rasch(i)

    sel <- items[unlist(sim$best_subset) == TRUE]

    sub_dat <- irt_dat%>%filter(word %in% sel)

    m1PL <- update(irt1_fit_sel, newdata =sub_dat, chains = 6, cores = 6, threads = threading(6), backend = "cmdstanr")%>%add_criterion(c("loo"), cores = 2, ndraws = 2000)
  	m2PL <- update(irt2PL_fit_sel, newdata =sub_dat, chains = 6, cores = 6, threads = threading(6), backend = "cmdstanr")%>%add_criterion(c("loo"), cores = 2, ndraws = 2000)

  	comp <- loo_compare(m1PL, m2PL)%>%as_tibble(rownames = "model")%>%mutate(items = list(sel), size = i, iter = j)%>%mutate_at(c(2:9), as.numeric)

    model_comparison <- bind_rows(model_comparison, comp)

    saveRDS(model_comparison, "../saves/model_comparison.rds")
  }

}

saveRDS(model_comparison, "../saves/model_comparison.rds")
