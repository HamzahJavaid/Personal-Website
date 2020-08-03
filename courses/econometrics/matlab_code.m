%% Econometric Notes - Matlab code
%  Matteo Courthoud
%  01/01/2017

cd '/Users/macbook/Dropbox/Code/website/courses/econometrics/'
%cd '/home/mcourt/Dropbox/Code/website/courses/econometrics/'
 



%% Lecture 1

% Set seed
rng(123)

% Set the number of observations
n = 100;

% Set the dimension of X
k = 2;

% Draw a sample of explanatory variables
X = rand(n, k);

% Draw the error term
sigma = 1;
e = randn(n,1)*sqrt(sigma);

% Set the parameters
b = [2; -1];

% Calculate the dependent variable
Y = X*b + e;

% Estimate beta
b_hat = inv(X'*X)*(X'*Y) % = 1.9020, -0.9305

% Equivalent but faster formulation
b_hat = (X'*X)\(X'*Y);

% Even faster (but less intuitive) formulation
b_hat = X\Y;

% Note that is generally not equivalent to Var(X)^-1 * Cov(X,y)...
Var_X = cov(X);
Cov_Xy = n/(n-1) * (mean(X .* Y) - mean(X).*mean(Y));
b_alternative = inv(Var_X) * Cov_Xy' % = 2.1525, -0.7384

% ...unless you include a constant
a = 3;
Y = a + X*b + e;
b_hat_1 = [ones(n,1), X]\Y % = 2.1525, -0.7384
Var_X = cov(X);
Cov_Xy = n/(n-1) * (mean(X .* Y) - mean(X).*mean(Y));
b_alternative = inv(Var_X) * Cov_Xy' % = 2.1525, -0.7384

% Predicted y
y_hat = X*b_hat;

% Residuals
e_hat = Y - X*b_hat;

% Projection matrix
P = X*inv(X'*X)*X';

% Annihilator matrix
M = eye(n) - P;

% Leverage
h = diag(P);

% Biased variance estimator 
sigma_hat = e_hat'*e_hat / n;

% Unbiased estimator 1
sigma_hat_2 = e_hat'*e_hat / (n-k);

% Unbiased estimator 2
sigma_hat_3 = mean( e_hat.^2 ./ (1-h) );

% R squared - uncentered
R2_uc = (y_hat'*y_hat)/ (Y'*Y);

% R squared
y_bar = mean(Y);
R2 = ((y_hat-y_bar)'*(y_hat-y_bar))/ ((Y-y_bar)'*(Y-y_bar));

% Ideal variance of the OLS estimator
var_b = sigma*inv(X'*X);

% Standard errors
std_b = sqrt(diag(var_b));



%% Lecture 2

% Set seed
rng(123)

% Homoskedastic standard errors
std_h = var(e_hat) * inv(X'*X);

% HC0 variance and standard errors
omega_hc0 = X' * diag(e_hat.^2) * X;
std_hc0 = sqrt(diag(inv(X'*X) * omega_hc0 * inv(X'*X))) % = 0.9195, 0.8631

% HC1 variance and standard errors
omega_hc1 = n/(n-k) * X' *  diag(e_hat.^2) * X;
std_hc1 = sqrt(diag(inv(X'*X) * omega_hc1 * inv(X'*X))) % = 0.9289, 0.8719

% HC2 variance and standard errors
omega_hc2 = X' * diag(e_hat.^2./(1-h)) * X;
std_hc2 = sqrt(diag(inv(X'*X) * omega_hc2 * inv(X'*X))) % = 0.9348, 0.8768

% HC3 variance and standard errors
omega_hc3 = X' * diag(e_hat.^2./(1-h).^2) * X;
std_hc3 = sqrt(diag(inv(X'*X) * omega_hc3 * inv(X'*X))) % = 0.9504, 0.8907

% Note what happens if you allow for full autocorrelation
omega_full = X'*e_hat*e_hat'*X;

% t-test for beta=0
t = abs(b_hat./(std_hc1));

% p-value
p_val = 1 - normcdf(t);

% F statistic of joint significance
SSR_u = e_hat'*e_hat;
SSR_r = Y'*Y;
F = (SSR_r - SSR_u)/k / (SSR_u/(n-k));

% 95% confidente intervals
conf_int = [b_hat - 1.96*std_hc1, b_hat + 1.96*std_hc1];



%% Lecture 3

% Set seed
rng(123)

% Set the dimension of Z
l = 3;

% Draw instruments
Z = randn(n,l);

% Correlation matrix for error terms
S = eye(2,2); S(1,2)=.8; S(2,1)=.8; 

% Endogenous X
gamma = [2, 0; 0, -1; -1, 3];
e = randn(n,2)*chol(S);
X = Z*gamma + e(:,1);

% Calculate Y
Y = X*b + e(:,2);

% Estimate beta OLS
beta_OLS = (X'*X)\(X'*Y) % = 2.1957, -0.9022

% IV: l=k=2 instruments
Z_IV = Z(:,1:k);
beta_IV = (Z_IV'*X)\(Z_IV'*Y) % = 2.1207, -1.3617

% Calculate standard errors
ehat = Y - X*beta_IV;
V_NHC_IV = var(ehat) * inv(Z_IV'*X)*Z_IV'*Z_IV*inv(Z_IV'*X);
V_HC0_IV = inv(Z_IV'*X)*Z_IV' * diag(ehat.^2) * Z_IV*inv(Z_IV'*X);

% 2SLS: l=3 instruments
Pz = Z*inv(Z'*Z)*Z';
beta_2SLS = (X'*Pz*X)\(X'*Pz*Y) % = 2.0723, -0.9628

% Calculate standard errors
ehat = Y - X*beta_2SLS;
V_NCH_2SLS = var(ehat) * inv(X'*Pz*X);
V_HC0_2SLS = inv(X'*Pz*X)*X'*Pz * diag(ehat.^2) *Pz*X*inv(X'*Pz*X);

% GMM 1-step: inefficient weighting matrix
W_1 = eye(l);

% Objective function
gmm_1 = @(b) ( Y - X*b )' * Z * W_1 *  Z' * ( Y - X*b );

% Estimate GMM
beta_gmm_1 = fminsearch(gmm_1, beta_OLS) % = 2.0763, -0.9548
ehat = Y - X*beta_gmm_1;

% Standard errors GMM
S_hat = Z'*diag(ehat.^2)*Z;
d_hat = -X'*Z;
V_gmm_1 = inv(d_hat * inv(S_hat) * d_hat');

% GMM 2-step: efficient weighting matrix
W_2 = inv(S_hat);
gmm_2 = @(b) ( Y - X*b )' * Z * W_2 *  Z' * ( Y - X*b );
beta_gmm_2 = fminsearch(gmm_2, beta_OLS) % = 2.0595, -0.9666

% Standard errors GMM
ehat = Y - X*beta_gmm_2;
S_hat = Z'*diag(ehat.^2)*Z;
d_hat = -X'*Z;
V_gmm_2 = inv(d_hat * inv(S_hat) * d_hat');



%% Lecture 5

% Set seed
rng(123)

% Define Model Parameters
n = 1000;
alpha = 1;
beta = .1;
gamma = -4;

% Set number of simulations
n_simulations = 10000;

% Preallocate simulation results
alpha_short = zeros(n_simulations,1);
alpha_long = zeros(n_simulations,1);
alpha_pretest = zeros(n_simulations,1);

% Loop over simulations
for sim = 1:n_simulations

    % Generate Data
    Z = randn(n,1);
    X = gamma*Z + randn(n,1);
    e = randn(n,1);
    Y = alpha*X+ beta*Z + e;
    
    % Alpha estimate from long regression
    alpha_short(sim) = inv(X'*X)*X'*Y;
    
    % Alpha estimate from long regression
    estimates_temp = inv([X,Z]'*[X,Z])*[X,Z]'*Y;
    alpha_long(sim) = estimates_temp(1);

    % Compute test statistic
    e = Y - [X,Z]*estimates_temp;
    t = estimates_temp(2)/sqrt(var(e)*([0,1]*inv([X,Z]'*[X,Z])*[0;1]));
    
    % Pick estimate depending on test statistic
    if abs(t)>1.96
        alpha_pretest(sim) = alpha_long(sim);
    else
        alpha_pretest(sim) = alpha_short(sim);
    end
end

% Plot results
figure
set(gcf,'position',[0,0,1000,500])
subplot(1,3,1)
hist(alpha_long, 20), title(['alpha long'],'fontsize',12)
subplot(1,3,2)
hist(alpha_short, 20), title(['alpha short'],'fontsize',12)
xlabel(['alpha=',num2str(alpha),', beta=',num2str(beta),', gamma=',num2str(gamma),', n=',num2str(n)], 'fontsize',10)
subplot(1,3,3)
hist(alpha_pretest, 20), title(['alpha pre-test'],'fontsize',12)
saveas(gcf,'figures/Fig_621.png')




% Sequence of sample sizes
n_sequence = [100,1000,10000,50000,100000];

% Initialize figure
figure
set(gcf,'position',[0,0,2000,1000])
n_fig = 1;

% Loop over data generating processes
for dgp=0:1
    for n=n_sequence
        for sim=1:n_simulations

            % Select beta according to dgp
            if dgp==0
                beta_n = beta;
            else
                beta_n = beta/sqrt(n)*sqrt(100);
            end

            % Generate Data
            Z = randn(n,1);
            X = gamma*Z + randn(n,1);
            e = randn(n,1);
            Y = alpha*X+ beta_n*Z + e;

            % Alpha estimate from long regression
            alpha_short(sim) = inv(X'*X)*X'*Y;

            % Alpha estimate from long regression
            estimates_temp = inv([X,Z]'*[X,Z])*[X,Z]'*Y;
            alpha_long(sim) = estimates_temp(1);

            % Compute test statistic
            e = Y - [X,Z]*estimates_temp;
            t = estimates_temp(2)/sqrt(var(e)*([0,1]*inv([X,Z]'*[X,Z])*[0;1]));

            % Pick estimate depending on test statistic
            if abs(t)>1.96
                alpha_pretest(sim) = alpha_long(sim);
            else
                alpha_pretest(sim) = alpha_short(sim);
            end
        end

        % Add subplot
        subplot(2,length(n_sequence),n_fig)
        hist((alpha_pretest-alpha)*sqrt(n/100), 12)
        title(['beta=',num2str(beta_n)],'fontsize',10)
        xlabel(['n=',num2str(n)], 'fontsize',10)
        n_fig = n_fig+1;

    end
end
saveas(gcf,'figures/Fig_624.png')



