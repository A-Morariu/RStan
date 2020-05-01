library(tidyverse)
library(rstan)
library(tidybayes)

### Create data

df <- cbind(c(rep(1, 1000)), rnorm(n = 1000, mean = 2, sd = 0.5), rexp(1000, rate = 0.1))
colnames(df) <- c("beta0", "cov1", "resp")

### Model fitting 

model_code <- stanc(file = "~/Documents/Github/RStan/initial_stan.stan")
model_model <- stan_model(stanc_ret = model_code)

stan_data <- list(N = nrow(df),
                  preds = ncol(df) - 1,
                  data_matrix = df)

results <- rstan::sampling(model_model, 
                           data = stan_data,
                           iter = 2000,
                           chains = 1,
                           thin = 1)

results

###  TIME SERIES CODING 

# formating the data
data("JohnsonJohnson")
JohnsonJohnson <- data_frame(JohnsonJohnson) %>% rename(returns = JohnsonJohnson)

# model fitting 

AR1_code <- rstan::stanc(file = "~/Documents/Github/RStan/AR1.stan")
AR1_model <- rstan::stan_model(stanc_ret = AR1_code)

AR1_data <- list(N = length(JohnsonJohnson),
                 #preds = 1,
                 returns = JohnsonJohnson)

AR1_fit <- rstan::sampling(AR1_model,
                           data = AR1_data,
                           iter = 1000,
                           chains = 1,
                           thin = 1)
AR1_fit

# General AR(p) model 

