classdef ProteinQuantifierTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/ProteinQuantifier'];
    end
    
    methods (Test)
        
        function testWithLocalFiles(testCase)
            dataFile = biotracs.data.model.DataFile( [pwd, '/../../../testdata/consensusXML/test.consensusXML'] );
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile);
            
            dataFile2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/FidoidXML/Protein_trypsin_996.idXML'] );
            ds2 = biotracs.data.model.DataFileSet();
            ds2.add(dataFile2);
            
            process = biotracs.openms.model.ProteinQuantifier();
            c = process.getConfig();
            process.setInputPortData('FeatureFileSet', ds);
            process.setInputPortData('GroupProteinsFileSet', ds2);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('PeptideOut', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);
            process.run();
            resultsProteins = process.getOutputPortData('ProteinAbundanceFileSet');
            resultsPeptides = process.getOutputPortData('PeptideAbundanceFileSet');
            
            expectedOutputFilePaths1 = fullfile([ testCase.workingDir, '/testProteinAbundance.csv']);
            expectedOutputFilePaths2 = fullfile([ testCase.workingDir, '/testPeptideAbundance.csv']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/testProteinAbundance.log']);
            
            testCase.verifyEqual( exist(expectedOutputFilePaths1, 'file'), 2 );
            testCase.verifyEqual( exist(expectedOutputFilePaths2, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'),2 );
            testCase.verifyEqual( resultsProteins.getLength(), 1 );
            testCase.verifyClass( resultsProteins.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( resultsProteins.getAt(1).getPath(), expectedOutputFilePaths1 );
            testCase.verifyEqual( resultsProteins.getAt(1).exist(), true );
            testCase.verifyEqual( resultsPeptides.getLength(), 1 );
            testCase.verifyClass( resultsPeptides.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( resultsPeptides.getAt(1).getPath(), expectedOutputFilePaths2 );
            testCase.verifyEqual( resultsPeptides.getAt(1).exist(), true );
        end
        
        
    end
end