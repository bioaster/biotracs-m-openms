classdef FeatureFinderCentroidedTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/FeatureFinderCentroidedTests'];
    end

    methods (Test)
        
        function testWithLocalFiles(testCase)
            dataFile1 = biotracs.data.model.DataFile( fullfile(pwd, '/../../../testdata/mzML/QC_B1_neg_201609019_046.mzML') );
            dataFile2 = biotracs.data.model.DataFile( fullfile(pwd, '/../../../testdata/mzML/BlankExtrac_B1_neg_20160921_066.mzML') );
            
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile1);
            ds.add(dataFile2);

            process = biotracs.openms.model.FeatureFinderCentroided();
            process.setInputPortData('DataFileSet', ds);
            process.getConfig()...
                .updateParamValue('MzToleranceMassTrace', 0.02)...
                .updateParamValue('WorkingDirectory', testCase.workingDir)...
                .updateParamValue('UseShellConfigFile', true);            
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/QC_B1_neg_201609019_046.featureXML']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/QC_B1_neg_201609019_046.log']);

            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
  
    end
end