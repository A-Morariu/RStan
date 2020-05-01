###  BAYESIAN TIME SERIES WITH STAN ###

### Preamble
library(tidyverse)
library(rstan)
library(parallel)

### Data
returns <- JohnsonJohnson


### AR(1) model
AR1_code <- rstan::stanc(file = "~/Documents/Github/RStan/AR1.stan")
AR1_model <- rstan::stan_model(stanc_ret = AR1_code)

AR1_data <- list(N = length(returns),
                 returns = returns)

AR1_fit <- rstan::sampling(AR1_model,
                           data = AR1_data,
                           iter = 1000,
                           chains = 2,
                           thin = 1)
AR1_fit


### AR(p) model
ARp_code <- rstan::stanc(file = "~/Documents/Github/RStan/ARp.stan")
ARp_model <- rstan::stan_model(stanc_ret = ARp_code)

model_order <- 3
ARp_data <- list(P = model_order, # order of AR model
                 N = length(returns), # length of TS 
                 returns = returns # the data
                 ) 

ARp_fit <- rstan::sampling(ARp_model,
                           data = ARp_data,
                           iter = 1000,
                           chains = 2,
                           thin = 1)
ARp_fit

### MA(1) model
