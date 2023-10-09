library(tidyverse)
library(brms)

data <- read_csv("../data/previc_data.csv")%>%
  mutate(age_group = factor(substr(age, 1,1)))

irt_dat_sel <- data%>%
  select(subjID, word, score, sex, aoa_rating_german)%>%
  filter(word %in% readRDS("../saves/fit_selected_items.rds"))

## 1PL Model

prior_1pl <- 
  prior("normal(0, 1)", class = "sd", group = "subjID") + 
  prior("normal(0, 3)", class = "sd", group = "word")

irt1_fit_sel <- brm(
  data = irt_dat_sel,
  family = bernoulli(),
  score ~ 1 + (1 | word) + (1 | subjID),
  prior = prior_1pl,
  control = list(adapt_delta = 0.95, max_treedepth = 20),
  cores = 6,
  chains = 6,
  iter = 8000,
  threads = threading(8), #to speed things up, comment out if not on a cluster
  backend = "cmdstanr" #to speed things up, comment out if not on a cluster
)

saveRDS(irt1_fit_sel, "../saves/irt1_fit_sel.rds")

irt1_fit_sel <- add_criterion(
  irt1_fit_sel,
  criterion = c("loo","waic"),
  cores = 2,
  ndraws = 2000
)

saveRDS(irt1_fit_sel, "../saves/irt1_fit_sel.rds")