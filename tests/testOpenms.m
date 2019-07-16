%"""
%Unit tests for biotracs.openms.*
%* License: BIOASTER License
%* Created: 2016
%Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""

function testOpenms( cleanAll )
    if nargin == 0 || cleanAll
        clc; close all force;
        restoredefaultpath();
    end
    
    autoload( ...
        'PkgPaths', {fullfile(pwd, '../../')}, ...
        'Dependencies', {...
            'biotracs-m-openms', ...
        }, ...
        'Variables',  struct(...
        ) ...
    );

    %% Base tests
    import matlab.unittest.TestSuite;
    Tests = TestSuite.fromFolder('./', 'IncludingSubfolders', true);
    Tests.run;
end