% Matlab toolbox for smoothing and mapping
%
%   
clc;
disp(' ');  
disp('                              MATLAB TOOLBOX FOR SMOOTHING AND MAPPING');
disp(' ');
disp('                   The toolbox compares SLAM oprimization strategies such as:');
disp('                   a) Incrementaly updating the Cholesky factor [1]     (CholFactor)');
disp('                   b) Incrementaly updating the Information matrix [2]  (Hessian)');
disp('                   c) Incrementaly updating the Jacobian matrix [3][4]  (Jacobian)');
disp(' ');
disp(' ');
disp('[1] Sparse Local Submap Joining Filter for Building Large-Scale Maps,S. Huang, Z. Wang and G. Dissanayake, TRO 2008');
disp('[2] Information-based Compact Pose SLAM, V. Ila, J. M. Porta, and J. Andrade-Cetto, TRO, 2010');
disp('[3] Square Root SAM: SLAM via Square Root Information Smoothing, F. Dellaert and M. Kaess, IJRR, 2006');
disp('[4] iSAM: Incremental Smoothing and Mapping, M. Kaess, A. Ranganathan, and F. Dellaert, IEEE TRO, 2008 ');

disp(' ');
disp('     The toolbox requires Tim Davis SuiteSparse toolbox which can be downloaded from here: ');
disp('                     http://www.cise.ufl.edu/research/sparse/SuiteSparse/');
disp(' ');
disp('                                    Author: Viorela Ila');

SuiteSparsePath_ela='~/Work_mac/code/SuiteSparse';
SuiteSparsePath_others='~/SuiteSparse';

if exist(SuiteSparsePath_ela,'dir') 
    path(path,genpath(SuiteSparsePath_ela));    
    path(path,genpath(pwd));
    clear SuiteSparsePath_ela;
    clear SuiteSparsePath_others;
elseif exist(SuiteSparsePath_others,'dir') 
    path(path,genpath(SuiteSparsePath_others));    
    path(path,genpath(pwd));
    clear SuiteSparsePath_ela;
    clear SuiteSparsePath_others;
else
    disp(' Can not find SuiteSparse !! ');  
    path(path,genpath(pwd));
    clear SuiteSparsePath;
end