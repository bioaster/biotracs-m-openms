classdef XTandemAdapterTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/XTandemAdapterTests'];
    end
    
    methods (Test)
        
        function testWithLocalFiles(testCase)
%             return;
            dataFile1 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/mzML/Protein_trypsin_996.mzML'] );
            dataFile2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/mzML/Protein_trypsin_994.mzML'] );
            
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile1);
            ds.add(dataFile2);
            databaseFile= biotracs.data.model.DataFile( [pwd, '/../../../testdata/fasta/small.fasta'] );
            
            process = biotracs.openms.model.XTandemAdapter();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            process.setInputPortData('DatabaseFile', databaseFile);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('FixedModifications', 'Carabamidomethyl (C), 15dB-biotin (C)');
            c.updateParamValue('UseShellConfigFile', true);
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/Protein_trypsin_996.idXML']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/Protein_trypsin_996.log']);
            
            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
        

    end
end