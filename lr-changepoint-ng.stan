data {
  int<lower=1> N;
  real x[N];
  real y[N];
}

parameters {
  real mu1;
  real mu2;
  real gamma1;
  real gamma2;

  real<lower=0> sigma1;
  real<lower=0> sigma2;
}

transformed parameters {
  vector[N] log_p;
  {
    vector[N+1] log_p_e;
    vector[N+1] log_p_l;
    log_p_e[1] = 0;
    log_p_l[1] = 0;
    for (i in 1:N) {
      log_p_e[i + 1] = log_p_e[i] + normal_lpdf(y[i] | mu1 * x[i] + gamma1, sigma1);
      log_p_l[i + 1] = log_p_l[i] + normal_lpdf(y[i] | mu2 * x[i] + gamma2, sigma2);
    }
    log_p = rep_vector(-log(N) + log_p_l[N + 1], N) + head(log_p_e, N) - head(log_p_l, N);
  }
}

model {
    mu1 ~ normal(0, 10);
    mu2 ~ normal(0, 10);
    gamma1 ~ normal(0, 10);
    gamma2 ~ normal(0, 10);
    sigma1 ~ normal(0, 10);
    sigma2 ~ normal(0, 10);

    target += log_sum_exp(log_p);
}

generated quantities {
    int<lower=1,upper=N> tau;
    tau = categorical_rng(softmax(log_p));
}
