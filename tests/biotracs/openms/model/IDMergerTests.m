classdef IDMergerTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/IDMergerTests'];
    end
    
    methods (Test)
        
        function testWithLocalFiles(testCase)
            dataFile1a = biotracs.data.model.DataFile ('../../../testdata/PEPidXML/Protein_trypsin_996.idXML');
            dataFile1b = biotracs.data.model.DataFile ('../../../testdata/PEPidXML/Protein_trypsin_994.idXML');
            dataFile2a = biotracs.data.model.DataFile ('../../../testdata/PEPidXML/Protein_trypsin_996.idXML');
            dataFile2b = biotracs.data.model.DataFile ('../../../testdata/PEPidXML/Protein_trypsin_994.idXML');
            ds1 = biotracs.data.model.DataFileSet();
            ds1.add(dataFile1a);
            ds1.add(dataFile1b);
            ds2 = biotracs.data.model.DataFileSet();
            ds2.add(dataFile2a);
            ds2.add(dataFile2b);
            ds = biotracs.core.mvc.model.ResourceSet();
            ds.add(ds1);
            ds.add(ds2);

            process = biotracs.openms.model.IDMerger();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);            
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/Protein_trypsin_996.idXML']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/Protein_trypsin_996.log']);
            
            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2);
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
        
        function testWithLocalOneFolder(testCase)
            dataFile1a = biotracs.data.model.DataFile ('../../../testdata/PEPidXML/Protein_trypsin_996.idXML');
            dataFile1b = biotracs.data.model.DataFile ('../../../testdata/PEPidXML/Protein_trypsin_994.idXML');
            ds1 = biotracs.data.model.DataFileSet();
            ds1.add(dataFile1a);
            ds1.add(dataFile1b);
            ds = biotracs.core.mvc.model.ResourceSet();
            ds.add(ds1);
            
            process = biotracs.openms.model.IDMerger();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);            
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/Protein_trypsin_994.idXML']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/Protein_trypsin_994.log']);
            
            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2);
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
        
    end
end