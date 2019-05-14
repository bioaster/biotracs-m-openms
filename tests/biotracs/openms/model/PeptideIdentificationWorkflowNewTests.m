classdef PeptideIdentificationWorkflowNewTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/T2/'];
        fastaFilePath = 'Z:\BioappsTests\Uniprot\toppas_decoy\TOPPAS_out\003-DecoyDatabase-out\uniprot_sprot.fasta';
    end
    
    methods (Test)
        
        function testPeptideIdentificationWithLocalFiles(testCase)
%             return;
            if ~exist(testCase.fastaFilePath, 'file')
                fprintf('Cannot run %s: please, provide and valid fasta file path for testing\n', class(testCase));
            end
            
            peptideIdentificationWf = biotracs.openms.model.PeptideIdentificationWorkflowNew();
            peptideIdentificationWf.getConfig()...
                .updateParamValue( 'WorkingDirectory', [testCase.workingDir , '/A/'] );
            
            engineIdentificationWf = peptideIdentificationWf.getNode('EngineIdentification');
            engineIdentificationWf.getConfig() ...
                .updateParamValue('UseMascot', 'true') ...
                .updateParamValue('UseXTandem', 'true');
                
            peptideIdentificationWf.getNode('MzFileImporter')...
                .addInputFilePath( [pwd, '/../../../testdata/mzML/Protein_trypsin_996.mzML'] )...
                .addInputFilePath( [pwd, '/../../../testdata/mzML/Protein_trypsin_994.mzML'] );

            peptideIdentificationWf.getNode('FastaFileImporter')...
                .addInputFilePath( testCase.fastaFilePath );

            peptideIdentificationWf.run();

          
        end
        
         function testPeptideIdMascotFalseWithLocalFiles(testCase)
%             return;
             if ~exist(testCase.fastaFilePath, 'file')
                fprintf('Cannot run %s: please, provide and valid fasta file path for testing\n', class(testCase));
            end
            
            peptideIdentificationWf = biotracs.openms.model.PeptideIdentificationWorkflowNew();
            peptideIdentificationWf.getConfig()...
                .updateParamValue( 'WorkingDirectory', [testCase.workingDir , '/X/'] );
            
            engineIdentificationWf = peptideIdentificationWf.getNode('EngineIdentification');
            engineIdentificationWf.getConfig() ...
                .updateParamValue('UseMascot', 'false') ...
                .updateParamValue('UseXTandem', 'true');
                
            peptideIdentificationWf.getNode('MzFileImporter')...
                .addInputFilePath( [pwd, '/../../../testdata/mzML/Protein_trypsin_996.mzML'] )...
                .addInputFilePath( [pwd, '/../../../testdata/mzML/Protein_trypsin_994.mzML'] );

            peptideIdentificationWf.getNode('FastaFileImporter')...
                .addInputFilePath( testCase.fastaFilePath );

            peptideIdentificationWf.run();

          
         end
          function testPeptideIdXTandemFalseWithLocalFiles(testCase)
%             return;
             if ~exist(testCase.fastaFilePath, 'file')
                fprintf('Cannot run %s: please, provide and valid fasta file path for testing\n', class(testCase));
            end
            
            peptideIdentificationWf = biotracs.openms.model.PeptideIdentificationWorkflowNew();
            peptideIdentificationWf.getConfig()...
                .updateParamValue( 'WorkingDirectory', [testCase.workingDir , '/M/'] );
            
            engineIdentificationWf = peptideIdentificationWf.getNode('EngineIdentification');
            engineIdentificationWf.getConfig() ...
                .updateParamValue('UseMascot', 'true') ...
                .updateParamValue('UseXTandem', 'false');
                
            peptideIdentificationWf.getNode('MzFileImporter')...
                .addInputFilePath( [pwd, '/../../../testdata/mzML/Protein_trypsin_996.mzML'] )...
                .addInputFilePath( [pwd, '/../../../testdata/mzML/Protein_trypsin_994.mzML'] );

            peptideIdentificationWf.getNode('FastaFileImporter')...
                .addInputFilePath( testCase.fastaFilePath );

            peptideIdentificationWf.run();

          
        end
    end
end