classdef MapStatisticsTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/MapStatisticsTests'];
    end

    methods (Test)
        
        function testMapStatistics(testCase)
            dataFile = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/Protein_trypsin_996.featureXML'] );
            dataFile2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/Protein_trypsin_997.featureXML'] );
            dataFile3 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/QC3.featureXML'] );
            dataFile4 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/QC4.featureXML'] );
            
            
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile);
            ds.add(dataFile2);
            ds.add(dataFile3);
            ds.add(dataFile4);
            

            process = biotracs.openms.model.MapStatistics();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('WorkingDirectory', [testCase.workingDir, '/OnlyQc']);
            c.updateParamValue('UseShellConfigFile', true);
            c.updateParamValue('TypeOfFiles', 'QC');
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/OnlyQc/QC3.txt']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/OnlyQc/QC3.log']);

            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
  
    end
end