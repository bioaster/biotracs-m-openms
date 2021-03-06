%"""
%Unit tests for biotracs.openms.model.FeatureFinderCentroided
%* License: BIOASTER License
%* Created: 2016
%Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""

function testFeatureFinderCentroided( cleanAll )
    if nargin == 0 || cleanAll
        clc; close all force;
        restoredefaultpath();
    end
    
    addpath('../../');
    autoload( ...
        'PkgPaths', {fullfile(pwd, '../../../../')}, ...
        'Dependencies', {...
            'biotracs-m-openms', ...
        }, ...
        'Variables',  struct(...
            'OpenMSBinPath', 'C:/Program Files/OpenMS-2.3.0/bin/', ...
            'XtandemExecPath', 'C:\Program Files (x86)\Xtandem\tandem-win-15-12-15-2\bin\tandem.exe', ...
            'MascotServerHostName', '10.69.20.18', ...
            'MascotServerPort', 80, ...
            'MascotServerPath', '/mascot', ...
            'MascotUseProxy', false, ...
            'MascotLogin', false ...
        ) ...
    );

    %% Tests
    import matlab.unittest.TestSuite;
    Tests = TestSuite.fromFile('./model/FeatureFinderCentroidedTests.m');
    Tests.run;
end