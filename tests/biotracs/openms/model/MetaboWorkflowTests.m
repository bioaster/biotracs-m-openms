classdef MetaboWorkflowTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/MetaboWorkflowTests'];
    end
    
    methods (Test)
        
        function testMetaboWithLocalFiles(testCase)
            metaboWorkflow = biotracs.openms.model.MetaboWorkflow();
            metaboWorkflow.getConfig()...
                .updateParamValue('WorkingDirectory', testCase.workingDir );

            inputAdpter = metaboWorkflow.getNode('MzFileImporter');
           
            inputAdpter.addInputFilePath( [pwd, '/../../../testdata/mzXML/BlankExtrac_B1_neg_20160921_066.mzXML'] );
            inputAdpter.addInputFilePath( [pwd, '/../../../testdata/mzXML/BlankExtrac_B1_neg_20160921_067.mzXML'] );

            featureExtractionWorkflow = metaboWorkflow.getNode('FeatureExtraction');
            featureFinder = featureExtractionWorkflow.getNode('FeatureFinderMetabo');
            featureFinder.getConfig()...
                .updateParamValue('NoiseThresholdInt', 1e4);

            fileFilter = featureExtractionWorkflow.getNode('FileFilter');
            fileFilter.getConfig()...
                .updateParamValue('Charge', [1,1]);

            
            featureLinkingWorkflow = metaboWorkflow.getNode('FeatureLinking');
            mapAligner = featureLinkingWorkflow.getNode('MapAlignerPoseClustering');
            mapAligner.getConfig()...
                .updateParamValue('Reference', 'BlankExtrac_B1_neg_20160921_067');        
            featureLinkerUnlabeledQT = featureLinkingWorkflow.getNode('FeatureLinkerUnlabeledQT');
            featureLinkerUnlabeledQT.getConfig()...
                .updateParamValue('MzMaxDifference', 7);            

            accurateMassSearch = featureLinkingWorkflow.getNode('AccurateMassSearch');
            mappingDatabase = biotracs.data.model.DataFile( 'C:\Program Files\OpenMS-2.3.0\share\OpenMS\CHEMISTRY\HMDBMappingFile.tsv' );
            structureDatabase = biotracs.data.model.DataFile( 'C:\Program Files\OpenMS-2.3.0\share\OpenMS\CHEMISTRY\HMDB2StructMapping.tsv' );
            negativeAdductsFile = biotracs.data.model.DataFile( [pwd, '/../../../testdata/NegativeAdducts.tsv'] );
            positiveAdductsFile = biotracs.data.model.DataFile( [pwd, '/../../../testdata/PositiveAdducts.tsv'] );
            accurateMassSearch.setInputPortData('MappingDatabase', mappingDatabase);
            accurateMassSearch.setInputPortData('StructureDatabase', structureDatabase);
            accurateMassSearch.setInputPortData('NegativeAdductsFile' , negativeAdductsFile);
            accurateMassSearch.setInputPortData('PositiveAdductsFile' , positiveAdductsFile);
            accurateMassSearch.getConfig()...
                .updateParamValue('IonizationMode', 'negative');
            
            %run
            metaboWorkflow.run();
            
            %tests 1
            results = inputAdpter.getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyEqual( results.getAt(1).exist(), true );
            
            %tests 2
            fileConverter = featureExtractionWorkflow.getNode('FileConverter');
            results = fileConverter.getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyEqual( results.getAt(1).exist(), true );
            
            %tests 3
            results = featureFinder.getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyEqual( results.getAt(1).exist(), true );
            
            %tests 4
            results = fileFilter.getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyEqual( results.getAt(1).exist(), true );
            
            %tests 5
            results = featureLinkerUnlabeledQT.getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 1 );
            testCase.verifyEqual( results.getAt(1).exist(), true );
            
            %tests 6
            textExporter = featureLinkingWorkflow.getNode('TextExporter');
            results = textExporter.getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 1 );
            testCase.verifyEqual( results.getAt(1).exist(), true );
            
            %tests 7
            results = accurateMassSearch.getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 1 );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
        
    end
end