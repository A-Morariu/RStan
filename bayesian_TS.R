###  BAYESIAN TIME SERIES WITH STAN ###

### Preamble
library(tidyverse)
library(rstan)
library(parallel)

# options(mc.cores = parallel::detectCores())
options(mc.cores = 1)
rstan_options(auto_write = TRUE)
### Data
returns <- JohnsonJohnson


### AR(1) model
AR1_code <- rstan::stanc(file = "~/Documents/Github/RStan/AR1.stan")
AR1_model <- rstan::stan_model(stanc_ret = AR1_code)

AR1_data <- list(N = length(returns),
                 returns = returns)

AR1_fit <- rstan::sampling(AR1_model,
                           data = AR1_data,
                           iter = 2000,
                           chains = 2,
                           thin = 1)
AR1_fit
plot(AR1_fit)

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
                           iter = 2000,
                           chains = 2,
                           thin = 1)
ARp_fit
plot(ARp_fit)


### ARCH(1) model
### These are easy since you just add it to the std dev
### component of the likelihood
ARCH1_code <- rstan::stanc(file = "~/Documents/Github/RStan/ARCH1.stan")
ARCH1_model <- rstan::stan_model(stanc_ret = ARCH1_code)

ARCH1_data <- list(N = length(returns), # length of TS 
                 returns = returns # the data
                 ) # this variable has to match the data section of the Stan file

ARCH1_fit <- rstan::sampling(ARCH1_model,
                           data = ARCH1_data,
                           iter = 2000,
                           chains = 8,
                           thin = 1)
ARCH1_fit
plot(ARCH1_fit)


### MA(q) model
MAq_code <- rstan::stanc(file = "~/Documents/Github/RStan/MAq.stan")
MAq_model <- rstan::stan_model(stanc_ret = MAq_code)

model_order <- 2
MAq_data <- list(Q = model_order, # order of AR model
                 T = length(returns), # length of TS 
                 returns = returns # the data
) 

MAq_fit <- rstan::sampling(MAq_model,
                           data = MAq_data,
                           iter = 4000,
                           chains = 2,
                           thin = 1,
                           control = list(adapt_delta = 0.99))
MAq_fit
plot(MAq_fit)

# attempt 2
MAq_codeV2 <- rstan::stanc(file = "~/Documents/Github/RStan/MAqV2.stan")
MAq_modelV2 <- rstan::stan_model(stanc_ret = MAq_codeV2)

model_order <- 2
MAq_dataV2 <- list(Q = model_order, # order of AR model
                 T = length(returns), # length of TS 
                 returns = returns # the data
) 

MAq_fitV2 <- rstan::sampling(MAq_modelV2,
                           data = MAq_dataV2,
                           iter = 10000,
                           chains = 2,
                           thin = 1,
                           control = list(adapt_delta = 0.99))
MAq_fitV2
plot(MAq_fitV2)


### ARMA(p,q) model
ARMApq_code <- rstan::stanc(file = '~/Documents/Github/RStan/ARMAV2.stan')
ARMApq_model <- rstan::stan_model(stanc_ret = ARMApq_code)

AR_order = 2; MA_order = 2

ARMApq_data <- list(P = AR_order,
                    Q = MA_order,
                    T = length(returns),
                    y = returns)

ARMApq_fit <- rstan::sampling(ARMApq_model,
                              data = ARMApq_data,
                              iter = 4000,
                              chains = 1,
                              thin = 1,
                              algorithm = 'HMC')
ARMApq_fit
plot(ARMApq_fit)
