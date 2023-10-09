library(tidyverse)
library(brms)

data <- read_csv("../data/wonder_data.csv")%>%
  mutate(age_group = factor(substr(age, 1,1)))

irt_dat <- data%>%
  select(subjID, word, score, sex, aoa_rating_german)%>%
  filter(word %in% readRDS("../saves/fit_selected_items.rds"))

## 2PL Model
prior_va_2pl <- 
  prior("normal(0, 2)", class = "b", nlpar = "eta") +
  prior("normal(0, 1)", class = "b", nlpar = "logalpha") +
  prior("normal(0, 1)", class = "sd", group = "subjID", nlpar = "eta") + 
  prior("normal(0, 3)", class = "sd", group = "word", nlpar = "eta") +
  prior("normal(0, 1)", class = "sd", group = "word", nlpar = "logalpha")

irt2PL_fit_sel <- brm(
  data = irt_dat,
  family = brmsfamily("bernoulli", "identity"),
  bf(
    score ~ inv_logit(exp(logalpha) * eta),
    eta ~ 1 + (1 |i| word) + (1 | subjID),
    logalpha ~ 1 + (1 |i| word),
    nl = TRUE
  ),
  prior = prior_va_2pl,
  control = list(adapt_delta = 0.95, max_treedepth = 20),
  cores = 6,
  chains = 6,
  iter = 8000,
  threads = threading(8), #to speed things up, comment out if not on a cluster
  backend = "cmdstanr" #to speed things up, comment out if not on a cluster
)


saveRDS(irt2PL_fit_sel, "../saves/irt2PL_fit_sel.rds")

irt2PL_fit_sel <- add_criterion(
  irt2PL_fit_sel,
  criterion = c("loo","waic"),
  cores = 2,
  ndraws = 2000
)

saveRDS(irt2PL_fit_sel, "../saves/irt2PL_fit_sel.rds")