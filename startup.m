% Matlab toolbox for smoothing and mapping
%
%   
clc;
disp(' ');  
disp('                          MATLAB TOOLBOX FOR SMOOTHING AND MAPPING');
disp(' ');
disp('              The toolbox implements the SAM and iSAM metrods from the papers:');
disp('Square Root SAM: SLAM via Square Root Information Smoothing, F. Dellaert and M. Kaess, IJRR, 2006');
disp('iSAM: Incremental Smoothing and Mapping, M. Kaess, A. Ranganathan, and F. Dellaert, IEEE TRO, 2008 ');
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