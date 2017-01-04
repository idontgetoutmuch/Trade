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
      real mu;
      real sigma;
      log_p = rep_vector(-log(N), N);
      for (tau in 1:N)
        for (i in 1:N) {
          mu = i < tau ? (mu1 * x[i] + gamma1) : (mu2 * x[i] + gamma2);
          sigma = i < tau ? sigma1 : sigma2;
          log_p[tau] = log_p[tau] + normal_lpdf(y[i] | mu, sigma);
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
