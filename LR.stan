data {
  int<lower=1> N;
  int<lower=1> K;
  matrix[N,K]  X;
  vector[N]    y;
}
parameters {
  vector[K] beta;
  real<lower=0> sigma;
}
model {
  y ~ normal(X * beta, sigma);
}
