classdef FileFilterTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/FileFilterTests'];
    end

    methods (Test)
        
        function testWithLocalFiles(testCase)
            return;
            dataFile1 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/consensusXML/test.consensusXML'] );
            dataFile2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/consensusXML/test2.consensusXML'] );
           
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile1);
            ds.add(dataFile2);

            process = biotracs.openms.model.FileFilter();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('Charge', [1,1]);
            c.updateParamValue('MinConsensusSize', [2,Inf]);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);            
            process.run();
            results = process.getOutputPortData('DataFileSet');

            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
        
        function testSnr(testCase)
            dataFile1 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/mzML/04_cells_BHI_biorad_4h_40ul.mzML'] );
           
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile1);
      
            
            process = biotracs.openms.model.FileFilter();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('Snr', 10);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            testCase.verifyEqual( results.getLength(), 1 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end

    end
end