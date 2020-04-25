---

title: Programming Languages for Economics
linktitle: Programming Languages
toc: true
date: "2019-08-16"
draft: false
type: post

tags:
 - tutorial
 - economics
 - programming
 - econometrics

menu: 
  resources:

---

## Introduction

In this tutorial I am going over different programming languages in Economics. In particular, I will analyze Stata, Python, Matlab, R and partially C/C++. I will try to answer the following questions (from my very limited experience):

- What are the differences between the most used programming languages in Economics?
- Which one should an under/grad Economics student learn?
- What are good sources for beginners?

In the last section, I present a simple Monte Carlo simulation with all four programming languages. 

## Comparison

### Stata

Most people in economics use Stata. Therefore it is almost compulsory to have some basic knowledge in Stata. However, as Stata is not a generic programming language, it cannot perform many features. It has an internal language for matrix algebra named Mata which is not intuitive. I personally suggest to use Stata for regressions and data cleaning. The other alternative is R.

Resources for Stata:

- [Stata help files](https://www.stata.com/features/search-help-files/): documentation material

### R

The advantage of R over Stata is that it's a generic programming language and therefore can be used for other non-statistical purposes like data scraping or machine learning*. Moreover, R has a very large number of statistics packages which makes it a close rival for what concerns econometrics. It also produces better graphs. The downside is that most packages are user-written and therefore they lack the uniformity of Stata commands. 

Resources for R:

- [CRAN Documentation](https://cran.r-project.org/doc/manuals/r-release/R-intro.html): documentation material
- [R Graph Gallery](https://www.r-graph-gallery.com): collection of graphs with R
- [R Cheat Sheets](https://rstudio.com/resources/cheatsheets/): collection of cheat sheets for R

### Python

Python is probably the best modern generic programming language. For an economist, I usually say that Python is not the best at anything but always a close call. It has a pretty good library for everything but there is usually a specialized language/software that does it better. The exceptions are data scraping, basic machine learning, natural language processing and neural networks. In these fields, Python really excels. However, as these are niches, I strongly recomment Python as a useful backup resource but not as primary programming language.

Resources for Python:

- [PythonProgramming](https://pythonprogramming.net/): many interesting free detailed tutorials
- [RealPython](https://realpython.com/): other tutorials
- [SciKit Learn](https://scikit-learn.org/stable/): for machine learning
- [NLTK](https://www.nltk.org/): for natural language processing
- [Tensorflow](https://www.tensorflow.org/): for neural networks
- [QuantEcon Python](https://python.quantecon.org/index_toc.html): macro models with Python
- [Towards Data Science](https://towardsdatascience.com/tagged/python): articles from [Medium](https://medium.com/) blog on Python programming

### Matlab

Matlab is a matrix based programming language. It is very fast and intended primarily for numerical computing. It is mostly used in macro, econometrics and empirical industrial organization.

Resources for Matlab:

- [Matlab Documentation](https://www.mathworks.com/help/matlab/): documentation material
- [Dynare](https://www.dynare.org/): package for macro models

## Example: OLS

In this example, I run a Monte Carlo simulation to estimate the distribution of the OLS coefficient in the Gauss Markov Model. In each simulation I draw $n=100$ observations from the Gauss-Markov model
$$
y_i = X_i' \beta + \varepsilon_i
$$
where $X_i$ has dimension 4, is i.i.d. standard normal distributed and $\beta = [1, 0, 0.01, -1]$.

The runtimes of the different languages are the following:

|                   | Stata           | R - dataframe   | R - matrices    | Python          | Matlab          |
| ----------------- | --------------- | --------------- | --------------- | --------------- | --------------- |
| Runtime (seconds) | 11.0            | 2.26            | 0.17            | 0.13            | 0.03            |
|<img width=150/>   |<img width=150/> |<img width=150/> |<img width=150/> |<img width=150/> |<img width=150/> |

As we can see, Matlab heavily outperforms other programming languages. Python and R constitute valud alternatives while Stata is clearly too slow. However, it has to be said that a faster implementation in Stata is possible through its internal matrix language: Mata.

### Stata

```stata
* Set seed
set seed 123

* Set parameters
local simulations = 1000
local n = 100
local K = 4
local beta_1 = 1
local beta_2 = 0
local beta_3 = 0.01
local beta_4 = -1

* Simulations
clear all
postfile buffer b_1 b_2 b_3 b_4 using temp, replace
timer clear 1
timer on 1
forval s=1(1)`simulations' {	
	qui drop _all
	qui set obs `n'
	forval k=1(1)`K' {
		qui gen x_`k' = rnormal()
	}
	qui gen y = `beta_1'*x_1+`beta_2'*x_2+`beta_3'*x_3+`beta_4'*x_4+rnormal()
	qui reg y x_*
	
	post buffer (_b[x_1]) (_b[x_2]) (_b[x_3]) (_b[x_4])	
}
timer off 1
timer list 1
postclose buffer
use temp, clear

* Plot results
set graphics off
graph drop _all
forval k=1(1)`K' {
histogram b_`k', title("beta_`k' ") name(b_`k') ytitle("") xtitle("")
}
set graphics on
graph combine b_1 b_2 b_3 b_4, col(2) iscale(1)
graph export OLS_Gaussian_Demo_Stata.png, replace
```

![Autocorrelation Function](/post/figures/OLS_Gaussian_Demo_Stata.png)

### R

```r
# Set seed
set.seed(123)

# Set parameters
simulations <- 1000
n <- 100
K <- 4
beta0 <- matrix(c(1,0,.01,-1))
betahat <- matrix(nrow = simulations, ncol = 4)

# Simulation method 1: dataframe
start_time <- Sys.time()
for (s in 1:simulations) {
  df <- data.frame(x_1 = rnorm(n = n),
                   x_2 = rnorm(n = n),
                   x_3 = rnorm(n = n),
                   x_4 = rnorm(n = n),
                   e = rnorm(n = n))
  df$y = df$x_1*beta0[1] + df$x_2*beta0[2] + df$x_3*beta0[3] + df$x_4*beta0[4] + df$e
  ols <- lm(y ~ x_1 + x_2 + x_3 + x_4 -1 , data=df)
  betahat[s,] <- ols$coefficients
}
print(Sys.time() - start_time)

# Simulation method 2: matrices
start_time <- Sys.time()
for (s in 1:simulations) {
  x <- matrix(rnorm(n*4), n, 4)
  e <- matrix(rnorm(n), n, 1)
  y = x %*% beta0 + e
  
  betahat[s,] <- solve(t(x) %*% x) %*% t(x) %*% y
}
print(Sys.time() - start_time)

# Save image
png(filename='OLS_Gaussian_Demo_R.png', units="px", width=1600, height=1600, res=300)
layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
for (k in 1:K) {
  hist(betahat[,k], main=paste('beta_',k), ylab='', xlab='')
}
dev.off()
```

![Autocorrelation Function](/post/figures/OLS_Gaussian_Demo_R.png)

### Python

```python
# Set seed
np.random.seed(123)

# Set parameters
simulations = 1000
n = 100
K = 4
beta0 = m([[1], [0], [.01], [-1]])
betahat = np.zeros((simulations, K))

# Simulation
start_time = time.time()
for s in range(simulations):
    x = rnorm(0, 1, (n, 4))
    e = rnorm(0, 1, (n, 1))
    y = d([x, beta0]) + e
    betahat[s, :] = d([inv(d([x.T, x])), x.T, y]).T
print(time.time() - start_time)

# Plot results
fig = plt.figure()
for k in range(K):
    ax = plt.subplot(221+k, title='beta_'+str(k+1))
    ax.hist(betahat[:, k], bins='auto')
plt.tight_layout()
plt.subplots_adjust(top=0.88)
fig.savefig('OLS_Gaussian_Demo_Python.png', dpi=300)
```

![Autocorrelation Function](/post/figures/OLS_Gaussian_Demo_Python.png)


### Matlab

```matlab
% Set seed
rng(123)

% Set parameters
simulations = 1000;
n = 100;
K = 4;
beta0 = [1,0,.01,-1]';
betahat = zeros(K,1000);

% Simulation
tic
for s = 1:simulations
    X = randn(n,K);
    e = randn(n,1);
    Y = X*beta0 + e;
    betahat(:,s) = (X'*X)\(X'*Y);
end
toc

% Plot results
figure('Position',[230,250,970,1010]) 
for k=1:K
    subplot(2,2,k)
    hist(betahat(1,:),20), colormap(gcf,[1,1,1])
    title(['beta\_',num2str(k)],'fontsize',14)
    set(gca,'fontsize',18)
end
print('OLS_Gaussian_Demo_Matlab','-dpng')
```

![Autocorrelation Function](/post/figures/OLS_Gaussian_Demo_Matlab.png)
