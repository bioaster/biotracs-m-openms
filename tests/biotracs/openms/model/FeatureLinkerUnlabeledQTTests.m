classdef FeatureLinkerUnlabeledQTTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/FeatureLinkerUnlabeledQTTests'];
    end
    
    methods (Test)
              
         function testWithlocalFiles(testCase)
            dataFile1 =  biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/BlankExtrac_B1_neg_20160921_066.featureXML'] );
            dataFile2 =  biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/BlankExtrac_B1_neg_20160921_067.featureXML'] );
            
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile1);
            ds.add(dataFile2);

            process = biotracs.openms.model.FeatureLinkerUnlabeledQT();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('MzMaxDifference', 7);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/BlankExtrac_B1_neg_20160921_066.consensusXML']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/BlankExtrac_B1_neg_20160921_066.log']);
            
            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            testCase.verifyEqual( results.getLength(), 1 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
        
        function testWithLocalFilesAndOutputRenamed(testCase)
%             return;
            dataFile1 =  biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/BlankExtrac_B1_neg_20160921_066.featureXML'] );
            dataFile2 =  biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/BlankExtrac_B1_neg_20160921_067.featureXML'] );

            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile1);
            ds.add(dataFile2);
            
            process = biotracs.openms.model.FeatureLinkerUnlabeledQT();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('MzMaxDifference', 7);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('OutputFileName', 'MyLinkedFeatureXML');
            c.updateParamValue('UseShellConfigFile', true);
            
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/MyLinkedFeatureXML.consensusXML']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/MyLinkedFeatureXML.log']);
            
            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            testCase.verifyEqual( results.getLength(), 1 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
        
    end
end