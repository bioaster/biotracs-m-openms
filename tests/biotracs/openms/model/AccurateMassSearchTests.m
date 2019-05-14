classdef AccurateMassSearchTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/AccurateMassSearchTests'];
    end
    
    methods (Test)
        
        function testWithLocalFiles(testCase)
            dataFile = biotracs.data.model.DataFile( [pwd, '/../../../testdata/consensusXML/test.consensusXml' ]);
            mappingDatabase= biotracs.data.model.DataFile( 'C:\Program Files\OpenMS-2.3.0\share\OpenMS\CHEMISTRY\HMDBMappingFile.tsv');
            structureDatabase= biotracs.data.model.DataFile( 'C:\Program Files\OpenMS-2.3.0\share\OpenMS\CHEMISTRY\HMDB2StructMapping.tsv');
            negativeAdductsFile= biotracs.data.model.DataFile( [pwd, '/../../../testdata/NegativeAdducts.tsv']);
            positiveAdductsFile= biotracs.data.model.DataFile( [pwd, '/../../../testdata/PositiveAdducts.tsv']);
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile);
            
            process = biotracs.openms.model.AccurateMassSearch();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            process.setInputPortData('MappingDatabase', mappingDatabase);
            process.setInputPortData('StructureDatabase', structureDatabase);
            process.setInputPortData('NegativeAdductsFile' , negativeAdductsFile);
            process.setInputPortData('PositiveAdductsFile' , positiveAdductsFile);

            c.updateParamValue('IonizationMode', 'negative');
            c.updateParamValue('WorkingDirectory', [testCase.workingDir,'/WithLocalFiles/']);
            c.updateParamValue('UseShellConfigFile', true);
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/WithLocalFiles/test.tsv']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/WithLocalFiles/test.log']);
            
            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            
            testCase.verifyEqual( results.getLength(), 1 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
    end
end