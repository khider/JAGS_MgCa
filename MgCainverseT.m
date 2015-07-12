%% This script runs the predictive (inverse) model for the Mg/Ca calibration using Matjags

% The BUGS code is stored in the predictivet.txt file. It assumes that
% salinity and deep-water DCO32- are known.



clear all; close all;


%% Defining some MCMC parameters for JAGS
nchains  = 1; % How Many Chains?
nburnin  = 100; % How Many Burn-in Samples?
nsamples = 1;  % How Many Recorded Samples? 

%% Defining observed data
N=186;  % number of datapoints in the record
coeff=load('MgCacoeff.txt'); % the calibration coefficients
data=load('calibration.txt'); % Get the record (here it's using the calibration data)

%The data file needs to be organized as follows: column1: MgCa,
% column2:intitial T guess,
% column 3: Salinity, column4: deep-water DC32-, column 5: cleaning (enter
% 0 for oxidative only and 1 for fully reductive), column 6: estimate of uncertainty (pre=1./sigma^2), optional)
% If using temporal precision estimate then replace coeff(1,1) by data(:,6)
% in the datatrust variable on line 34. 

tic

for l=1:10000; %Loop through the coefficients
% Create a single structure that has the data for all observed JAGS nodes

datastruct = struct('N',N,'MgCap',data(:,1),'Sp',data(:,3),...
    'Dp',data(:,4),'cleanp',data(:,5),'T0',data(:,2),'pre',coeff(l,1),...
    'alpha0',coeff(l,6),'alpha1',coeff(l,2),'alpha2',coeff(l,3),'alpha3',coeff(l,4),...
    'alpha4',coeff(l,5));

%% Set initial values for latent variable in each chain

for i=1:nchains
    S.Tpred=22*ones(N,1);
    init0(i) = S;
    clear S
end

%% Calling JAGS to sample

[samples, stats] = matjags( ...
    datastruct, ...                                                                 % Observed data   
    fullfile(pwd, 'predictiveT.txt'), ...                                           % File that contains model definition
    init0, ...                                                                      % Initial values for latent variables
    'nchains', nchains,...                                                          % Number of MCMC chains
    'nburnin', nburnin,...                                                          % Number of burnin steps
    'nsamples', nsamples, ...                                                       % Number of samples to extract
    'thin', 2, ...                                                                  % Thinning parameter
    'monitorparams', {'Tpred'},...                                                  % List of latent variables to monitor
    'workingdir','jagsT');      

Tpred(:,l)=squeeze(samples.Tpred(1,:,:))';                                          % Kee only one possible T value for each set of coefficients 

clear init0 samples stat datastruct
l

end
toc 
save Tpred %This variable keeps 10,000 possible T values based on the calibration uncertainty. 