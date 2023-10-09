items <- items
mi <- mi
easiness <- easiness_1PL_fit_sel
infit <- infit_fit_sel
outfit <- outfit_fit_sel

func <- function(x){
  abs(1-x)
}

func2 <- function(x){
  x/100
}

score_fn <- function(subset) {
  easinesses <- sort(easiness[subset])
  nn_dists <- rep(0, sum(subset)-1)
  for(i in 1:sum(subset)-1) {
    nn_dists[i] <- easinesses[i+1] - easinesses[i]
  }
  spacing <- -1*sd(nn_dists)/3
  
  # var_disc_sample <- disc_2PL[subset]
  # var_disc_2PL <- -1*var(var_disc_sample)*10
  
  infit_sample <- infit[subset]
  infit_dist <- unlist(lapply(infit_sample, func))
  mean_infit <- -4*mean(infit_dist)
  
  outfit_sample <- outfit[subset]
  outfit_dist <- unlist(lapply(outfit_sample, func))
  mean_outfit <- -2*mean(outfit_dist)
  
  mi_sample <- mi[subset]
  mi_dist <- unlist(lapply(outfit_sample, func2))
  mean_mi <- -1*mean(mi_dist)
  
  return(spacing + mean_infit + mean_outfit+ mean_mi)
  #return(spacing + mean_infit + mean_outfit)
}


proposal_fn <- function(subset) {
  # Randomly sample a number of swaps.
  # Prefer a small number of swaps for "fine tuning", but allow
  # occasional large numbers of swaps, including a complete
  # exchange of the subset
  subset_size = sum(as.integer(subset))
  max_swaps = min(subset_size, length(subset) - subset_size)
  swaps <- rbinom(1, max_swaps-1, 1/(max_swaps-1)) + 1
  
  # Choose the items to swap
  active_items <- seq(1:length(subset))[subset == TRUE]
  inactive_items <- seq(1:length(subset))[subset == FALSE]
  actives_to_swap <- sample(active_items, swaps)
  inactives_to_swap <- sample(inactive_items, swaps)
  
  # Do the swapping
  for(i in 1:swaps) {
    subset[actives_to_swap[i]] <- FALSE
    subset[inactives_to_swap[i]] <- TRUE
  }
  return(subset)
}

simulated_annealing_rasch <- function(k, cooling_ratio=0.999, reset_thresh=1000, break_thresh=10000) {
  
  N <- length(easiness)
  
  current_subset <- sample(c(rep(TRUE, k), rep(FALSE, N-k)))
  best_subset <- current_subset
  best_score <- score_fn(best_subset)
  
  temp <- 100
  rejected <- 0
  no_new_bests <- 0
  for(i in 1:1e6) {
    # Score new subset, and toss a coin
    new_subset <- proposal_fn(current_subset)
    new_score <- score_fn(new_subset)
    accept_decrease <- rbernoulli(1, temp / 100)
    
    # Accept the new subset if it's an improvement, or if our
    # cooling coin came up heads.
    if(new_score > best_score | accept_decrease) {
      current_subset <- new_subset
      rejected <- 0
      if(new_score > best_score) {
        best_subset <- new_subset
        best_score <- new_score
        no_new_bests <- 0
      } else {
        no_new_bests <- no_new_bests + 1
      }
      # Quit if we've had too many rejections in a row.
    } else {
      rejected <- rejected + 1
      no_new_bests <- no_new_bests + 1
      if(rejected == break_thresh) {
        #print(best_score)
        ret <- tibble(best_subset = list(best_subset),
                      best_score = best_score)
        
        return(ret)
      }
    }
    # Start random resets to the current best subset if we haven't
    # found anything better in quite a while.
    if(no_new_bests > reset_thresh & rbernoulli(1, 1/100)) {
      current_subset <- best_subset
    }
    
    # Cool it!
    temp <- temp*cooling_ratio
  }
  #print(best_score)
  ret <- tibble(best_subset = list(best_subset),
                best_score = best_score)
  
  return(ret)
}