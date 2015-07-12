%% This script runs the forward model for the Mg/Ca calibration 
%using Matjags

% The BUGS code is stored in the forwardMgCa.txt file

clear all; close all;


%% Defining some MCMC parameters for JAGS
nchains  = 2; % How Many Chains?
nburnin  = 10000; % How Many Burn-in Samples?
nsamples = 10000;  % How Many Recorded Samples?

%% Defining observed data
N=186;  % number of datapoints in the calibration dataset
data=load('calibration.txt'); % the observational data

% Create a single structure that has the data for all observed JAGS nodes
datastruct = struct('N',N,'MgCa',data(:,1),'T',data(:,2),'S',data(:,3),...
    'deltaCO3',data(:,4),'clean',data(:,5));

%% Set initial values for latent variable in each chain

for i=1:nchains
    S.alpha0=-2.8;
    S.alpha1=0.08;
    S.alpha2=0.05;
    S.alpha3=0.05;
    S.alpha4=0.1;
    S.pre=0.5;
    init0(i) = S; 
end

%% Calling JAGS to sample

fprintf( 'Running JAGS...\n' );

tic

[samples, stats] = matjags( ...
    datastruct, ...                                                                 % Observed data   
    fullfile(pwd, 'forwardMgCa.txt'), ...                                           % File that contains model definition
    init0, ...                                                                      % Initial values for latent variables
    'nchains', nchains,...                                                          % Number of MCMC chains
    'nburnin', nburnin,...                                                          % Number of burnin steps
    'nsamples', nsamples, ...                                                       % Number of samples to extract
    'thin', 10, ...                                                                 % Thinning parameter
    'monitorparams', {'alpha0','alpha1','alpha2','alpha3','alpha4','tau'},...       % List of latent variables to monitor
    'workingdir','jagsMgCa');      
toc

save MgCa_coeff; %This variable contains the nsamples sets of coefficients
    