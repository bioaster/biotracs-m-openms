classdef AlignmentAssessmentWorkflowTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/AlignmentAssessmentWorkflowTests'];
    end
    
    methods (Test)
        
        function testSampleAlignmentAssessment(testCase)
            w = biotracs.openms.model.AlignmentAssessmentWorkflow();
            w.getConfig()...
                .updateParamValue( 'WorkingDirectory', [testCase.workingDir, '/Samples']);
            inputAdpter = w.getNode('MzFileImporter') ...
                .addInputFilePath( [pwd, '/../../../testdata/featureXML/Protein_trypsin_996.featureXML'] )...
                .addInputFilePath( [pwd, '/../../../testdata/featureXML/Protein_trypsin_994.featureXML']);
            inputAdpter.getConfig()...
                .updateParamValue('FileExtensionFilter', 'featureXML');
            mapAlignmentResult = w.getNode('MapAlignerTableParser');
            mapAlignerPoseClustering = w.getNode('MapAlignerPoseClustering');
            mapAlignerPoseClustering.getConfig() ...
                .updateParamValue('Reference', 'Protein_trypsin_994');
            w.run();
            mapAlignment = mapAlignmentResult.getOutputPortData('ResourceSet');
            mapAlignment.view('MzRtAlignment');
            mapAlignment.view('PeakAlignment','Mz', {422.2918});
        end
        
        function testQCAlignmentAssessment(testCase)
            w = biotracs.openms.model.AlignmentAssessmentWorkflow();
            w.getConfig()...
                .updateParamValue( 'WorkingDirectory', [testCase.workingDir, '/QC']);
            inputAdpter = w.getNode('MzFileImporter') ...
                .addInputFilePath( [pwd, '/../../../testdata/FeatureXML/QC3.featureXML'] )...
                .addInputFilePath( [pwd, '/../../../testdata/FeatureXML/QC4.featureXML'] );
            inputAdpter.getConfig()...
                .updateParamValue('FileExtensionFilter', 'featureXML');
            mapAlignerPoseClustering = w.getNode('MapAlignerPoseClustering');
            mapAlignerPoseClustering.getConfig() ...
                .updateParamValue('Reference', 'QC4');
            mapAlignmentResult = w.getNode('MapAlignerTableParser');
            mapStatisticsParser = w.getNode('MapStatisticsTableParser');
            w.run();
            mapAlignment = mapAlignmentResult.getOutputPortData('ResourceSet'); 
            mapAlignment.view('MzRtAlignment');
            mapAlignment.view('PeakAlignment','Mz', {496.202});
            mapStatistic= mapStatisticsParser.getOutputPortData('ResourceSet');
            mapStatistic.view('QcFeatureDistribution', 'ListOfQc', {'QC3.txt', 'QC4.txt'});
        end
        
    end
end