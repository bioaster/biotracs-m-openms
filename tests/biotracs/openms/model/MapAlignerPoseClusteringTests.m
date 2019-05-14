classdef MapAlignerPoseClusteringTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/MapAlignerPoseClusteringTests'];
    end

    methods (Test)
                
        function testMapAlignerPoseClustering(testCase)
            dataFile1 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/Protein_trypsin_996.featureXML'] );
            dataFile2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/Protein_trypsin_994.featureXML'] );
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile1);
            ds.add(dataFile2);

            process = biotracs.openms.model.MapAlignerPoseClustering();   
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('Reference', 'Protein_trypsin_996');
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('NumUsedPoints', 500);
            c.updateParamValue('UseShellConfigFile', true);
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            testCase.verifyTrue( isfile([testCase.workingDir, '/Protein_trypsin_996.featureXML']) );
            testCase.verifyTrue( isfile([testCase.workingDir, '/Protein_trypsin_994.featureXML']) );
            testCase.verifyTrue( isfile([testCase.workingDir, '/Protein_trypsin_996.log']) );
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
        end
    end
end