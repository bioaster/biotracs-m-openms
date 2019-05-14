classdef IDMapperTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/IDMapperTests'];
    end

    methods (Test)
        
        function testWithLocalFiles(testCase)
%             return;
            dataFileFF1 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/Protein_trypsin_996.featureXML'] );
            dataFileFF2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/Protein_trypsin_994.featureXML'] );
            dFF = biotracs.data.model.DataFileSet();
            dFF.add(dataFileFF1);
            dFF.add(dataFileFF2);
                                 
            
            dataFileIDF1 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/PEPidXML/Protein_trypsin_996.idXML'] );
            dataFileIDF2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/PEPidXML/Protein_trypsin_994.idXML'] );
            dIDF = biotracs.data.model.DataFileSet();
            dIDF.add(dataFileIDF1);
            dIDF.add(dataFileIDF2);
            
            
            process = biotracs.openms.model.IDMapper();
            c = process.getConfig();
            process.setInputPortData('FeatureFileSet', dFF);
            process.setInputPortData('IdFileSet', dIDF);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);           
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/Protein_trypsin_996.featureXML']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/Protein_trypsin_996.log']);
        
            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
  
        function testWithWrongFiles(testCase)
            dataFileFF1 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/Protein_trypsin_996.featureXML'] );
            dataFileFF2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/featureXML/Protein_trypsin_994.featureXML'] );
            dFF = biotracs.data.model.DataFileSet();
            dFF.add(dataFileFF1);
            dFF.add(dataFileFF2);
                                 
            
            dataFileIDF1 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/PEPidXML/Protein_trypsin_994.idXML'] );
            dataFileIDF2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/PEPidXML/Protein_trypsin_996.idXML'] );
            dIDF = biotracs.data.model.DataFileSet();
            dIDF.add(dataFileIDF1);
            dIDF.add(dataFileIDF2);
            
            
            process = biotracs.openms.model.IDMapper();
            c = process.getConfig();
            process.setInputPortData('FeatureFileSet', dFF);
            process.setInputPortData('IdFileSet', dIDF);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);
            
            try
                process.run();
                error('An error was expected');
            catch err
                testCase.verifyEqual( err.message(), 'Warning, the identified ''Protein_trypsin_996''idXML is being mapped to the mass trace ''Protein_trypsin_994'' featureXML' );
            end
            
           
        end
    end
end