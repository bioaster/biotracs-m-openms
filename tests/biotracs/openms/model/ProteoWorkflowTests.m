classdef ProteoWorkflowTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/ProteoWorkflowTests'];
        fastaFilePath = 'Z:\BioappsTests\Uniprot\toppas_decoy\TOPPAS_out\003-DecoyDatabase-out\uniprot_sprot.fasta';
    end
    
    methods (Test)
        
        function testProteoWithLocalFiles(testCase)
            if ~exist(testCase.fastaFilePath, 'file')
                fprintf('Cannot run %s: please, provide and valid fasta file path for testing\n', class(testCase));
            end
            
            proteoWorkflow = biotracs.openms.model.ProteoWorkflow();
            proteoWorkflow.getConfig()...
                .updateParamValue( 'WorkingDirectory', [testCase.workingDir , '/ProteoWorkflow/'] );
            
            proteoWorkflow.getNode('MzFileImporter')...
                .addInputFilePath( [pwd, '/../../../testdata/mzXML/Protein_trypsin_996.mzXML'] )...
                .addInputFilePath( [pwd, '/../../../testdata/mzXML/Protein_trypsin_994.mzXML'] );


            peptideIdentificationWorkflow = proteoWorkflow.getNode('PeptideIdentification');
            xtandemAdapter = peptideIdentificationWorkflow.getNode('XTandemAdapter');

            proteoWorkflow.getNode('FastaFileImporter')...
                .addInputFilePath( testCase.fastaFilePath );

            xtandemAdapter.getConfig()...
                .updateParamValue('MaxPrecursorCharge', 2);

             featureLinking = proteoWorkflow.getNode('FeatureLinking');
            mapAligner = featureLinking.getNode('MapAlignerPoseClustering');
            mapAligner.getConfig() ...
                .updateParamValue('Reference', 'Protein_trypsin_996');
                
           
            proteoWorkflow.run();

            proteinQuantifyingWorkflow = proteoWorkflow.getNode('ProteinQuantifying');
            proteinQuantifier = proteinQuantifyingWorkflow.getNode('ProteinQuantifier');
            resultsProteins = proteinQuantifier.getOutputPortData('ProteinAbundanceFileSet');
            resultsPeptides = proteinQuantifier.getOutputPortData('PeptideAbundanceFileSet');
            
            testCase.verifyEqual( resultsProteins.getLength(), 1 );
            testCase.verifyEqual( resultsProteins.getAt(1).exist(), true );
            testCase.verifyEqual( resultsPeptides.getLength(), 1 );
            testCase.verifyEqual( resultsPeptides.getAt(1).exist(), true );
        end
        
        
    end
end