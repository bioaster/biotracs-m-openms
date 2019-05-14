classdef FileConverterTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/FileConverterTests'];
    end

    methods (Test)
        
        function testWithLocalFiles(testCase)
            dataFile = biotracs.data.model.DataFile( [pwd, '/../../../testdata/mzXML/BlankExtrac_B1_neg_20160921_066.mzXML'] );
            dataFile2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/mzXML/BlankExtrac_B1_neg_20160921_067.mzXML'] );
            
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile);
            ds.add(dataFile2);

            process = biotracs.openms.model.FileConverter();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);            
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/BlankExtrac_B1_neg_20160921_066.mzML']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/BlankExtrac_B1_neg_20160921_066.log']);

            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end


    end
end