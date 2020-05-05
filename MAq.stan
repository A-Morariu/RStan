data {
    int<lower = 0> Q;                           // order of MA model
    int<lower = Q> N;                           // number of observations
    vector[N] returns;                          // the time series vector
}
parameters {
    real mu;                                    // mean of the TS 
    vector[Q] theta;                            // model coefficients
    real<lower = 0> sigma;                      // std dev of the noise 
}
transformed parameters {
    vector[N] epsilon;                          // vector of noise at time t, to be used to estimate sigma
    
    for (n in 1:N){
        epsilon[n] = returns[n] - mu;           // initial definition of the noise at step n

        for (q in min(n-1, Q)){
            epsilon[n] = epsilon[n] - theta[q]*epsilon[n-q]; 
            // subtract the impact of the previous shocks
        }
    }
}
model {
    // helpful parameters
    vector[N] previous_step;                    // vector storing the previous steps in the predicted TS

    // priors
    mu ~ normal(0, 4);                          // flat priors - could use Cauchy for even flatter priors
    theta ~ normal(0,1)
    sigma ~ exponential(2)                      // use a prior defined on the positives only

    // the likelihood 
    for (n in 1:N){
        previous_step[n] = mu;                  // acts as a place holder, starts with 0 (based on prior)

        for (q in min(n-1, Q)){                 // same loop as above to update the previous step
            previous_step[n] = previous_step[n] + theta[q] * epsilon[n-q];
        }

        returns ~ normal(previous_step, sigma);
    }
}