classdef TextExporterTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/TextExporterTests'];
    end
    
    methods (Test)
        
        function testWithLocalFiles(testCase)
            dataFile1 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/consensusXML/test.consensusXml'] );
            dataFile2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/Protein_trypsin_996.featureXML'] );
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile1);
            ds.add(dataFile2);
            
            process = biotracs.openms.model.TextExporter();    
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/test.csv']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/test.log']);
            
            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end

    end
end