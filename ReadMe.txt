The Mg/Ca calibration algorithm – A program to calculate the posterior probability of a temperature inferred from Globigerinoides ruber Mg/Ca

Please acknowledge the original manuscript on any publication of scientific results based in part on use of the program.

Khider, D., Huerta, G., Jackson, C., Stott, L.D., Emile-Geay, J. (2015). “A Bayesian, multivariate calibration for Globigerinoides ruber Mg/Ca”, Geochemistry, Geophysics, Geosystems

Author: Deborah Khider
University of California Santa Barbara
Santa Barbara, CA 93106
Email: khider@usc.edu

Copyright © 2015 University of California Santa Barbara

The Mg/Ca calibration algorithm is a free software: you can redistribute it and/or modify it under the terms of the Gnu General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

The Mg/Ca calibration algorithm is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANDABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.


Main scripts:

Calibration: MgCaforward.m
By default, the algorithm is coded to run the calibration model as described in the supporting manuscript. To run a different dataset, modifications are needed where the data is loaded. To change the priors, modifications are needed in the supporting BUGS file forwardMgCa.txt.

Prediction: MgCainverseT.m
By default, the algorithm is coded to run the temperature prediction model on the calibration dataset as described in the supporting manuscript. To run a different dataset, modifications are needed where the data is loaded. To change the priors, modifications are needed in the supporting BUGS file predictiveT.txt.


Associated files:

Calibration:
- calibration.txt – contains the calibration data. The file is organized as followed: column 1, Mg/Ca; column 2, temperature; column 3: salinity; column 4, deep-water DCO3--; column 5, cleaning technique (enter 0 for oxidative only and 1 for fully reductive). This file can be modified to redo the calibration using the same model but a different datasets. Please ensure you adjust the number of data points in the MgCaforward.m script
- forwardMgCa.txt – contains the BUGS routine for the calibration. This file can be modified to change the form of the calibration model or the priors set in the study. Please refer to the BUGS documentation for modifying the script (http://www.mrc-bsu.cam.ac.uk/software/bugs/)

Prediction:
- MgCacoeff.txt – contains 10,000 sets of coefficients obtained using the calibration model described in the supporting manuscript. This file can be modified with a different sets of coefficients obtained from re-running the calibration algorithm. 
- Calibration.txt – by default, the algorithm is set to predict temperature for the calibration dataset. For use with a record, this file needs to be modified. A full description of the needed modifications is given in the MgCainverseT.m script. Please ensure you adjust the number of data points in the MgCainverseT.m script. 
- predictiveT.txt - contains the BUGS routine for the prediction. This file can be modified to change the form of the calibration model or the priors set in the study. Please refer to the BUGS documentation for modifying the script (http://www.mrc-bsu.cam.ac.uk/software/bugs/)


Supporting Software

The word presented in this study is based on BUGS (Bayesian inference Using Gibbs Sampling). To ensure cross-platform compatibility, we used JAGS (http://mcmc-jags.sourceforge.net) for the computation through the Matlab interface provided by matjags (http://psiexp.ss.uci.edu/research/programs_data/jags/). Please ensure that both jags and matjags are installed properly to run this software and acknowledge the original publications when using the Mg/Ca calibration algorithm. 

Update 7/13/15: Added a R script for some of the calculations presented in the paper. The script require rjags but uses the same BUGS file already provided 
