% BIOASTER
%> @file		PeptideIdentificationWorkflowNew.m
%> @class		biotracs.openms.model.PeptideIdentificationWorkflowNew
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2018

classdef PeptideIdentificationWorkflowNew <biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        % Constructor
        function this = PeptideIdentificationWorkflowNew( )
            this@biotracs.core.mvc.model.Workflow();
            this.doBuildPeptideIdentificationWorkflow();
        end
    end
    
    methods(Access = protected)
        function this = doBuildPeptideIdentificationWorkflow( this )
            this.doCreateMzFileImporter();
            this.doCreateFastaFileImporter();
            this.doEngineIdentificationWorkflow();
            this.doPeptideIndexFiltrationWorkflow();
            this.doConnectWorkflows();
        end
        
        function [ inputAdapter ] = doCreateMzFileImporter(this)
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MzFileImporter' );
        end

        function [ inputAdapter ] = doCreateFastaFileImporter( this )
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'FastaFileImporter' );
        end
        
        function [ engineIdWorkflow ] = doEngineIdentificationWorkflow(this)
            engineIdWorkflow = biotracs.openms.model.EngineIdentificationWorkflow();
            this.addNode(engineIdWorkflow, 'EngineIdentification');
            engineIdWorkflow.createInputPortInterface( 'MascotIdentification', 'MascotAdapterOnline:DataFileSet' );
            engineIdWorkflow.createInputPortInterface( 'XtandemIdentification', 'XTandemAdapter:DataFileSet' );
            engineIdWorkflow.createInputPortInterface( 'XtandemIdentification', 'FastaImporterDemux:ResourceSet' );
            engineIdWorkflow.createOutputPortInterface( 'MergeIdentification', 'ConsensusID:DataFileSet' );
        end
        
        function [ mergeIdWorkflow ] = doMergeIdentificationWorkflow(this)
            mergeIdWorkflow = biotracs.openms.model.MergeIdentificationWorkflow();
            this.addNode(mergeIdWorkflow, 'MergeIdentification');
            mergeIdWorkflow.createInputPortInterface( 'IDMerger', 'DataFileSet' );
            mergeIdWorkflow.createOutputPortInterface( 'ConsensusID', 'DataFileSet' );
        end
 
        function [ peptideIndexFiltrationWorkflow ] = doPeptideIndexFiltrationWorkflow(this)
            peptideIndexFiltrationWorkflow = biotracs.openms.model.PeptideIndexFiltrationWorkflow();
           
            this.addNode(peptideIndexFiltrationWorkflow, 'PeptideIndexFiltration');
            peptideIndexFiltrationWorkflow.createInputPortInterface( 'PeptideIndexer', 'DataFileSet' );
            peptideIndexFiltrationWorkflow.createInputPortInterface( 'FastaImporterDemux', 'ResourceSet' );
            peptideIndexFiltrationWorkflow.createOutputPortInterface( 'IDFilter', 'DataFileSet' );
            peptideIndexFiltrationWorkflow.createOutputPortInterface( 'FidoAdapter', 'DataFileSet' );
        end
        

        function this = doConnectWorkflows(this)
            engineIdWorkflow = this.getNode('EngineIdentification');
            peptideIndexFiltrationWorkflow = this.getNode('PeptideIndexFiltration');
            
            mzFileImporter = this.getNode('MzFileImporter');
            fastaFileImporter = this.getNode('FastaFileImporter');
            
            %connect input file importers
            mzFileImporter.getOutputPort('DataFileSet').connectTo( engineIdWorkflow.getInputPort('MascotIdentification:MascotAdapterOnline:DataFileSet') );
            mzFileImporter.getOutputPort('DataFileSet').connectTo( engineIdWorkflow.getInputPort('XtandemIdentification:XTandemAdapter:DataFileSet') );
            fastaFileImporter.getOutputPort('DataFileSet').connectTo( engineIdWorkflow.getInputPort('XtandemIdentification:FastaImporterDemux:ResourceSet') );
            engineIdWorkflow.getOutputPort('MergeIdentification:ConsensusID:DataFileSet').connectTo(peptideIndexFiltrationWorkflow.getInputPort('PeptideIndexer:DataFileSet') );
            fastaFileImporter.getOutputPort('DataFileSet').connectTo( peptideIndexFiltrationWorkflow.getInputPort('FastaImporterDemux:ResourceSet') );
            
        end
    end
    
    methods(Access = protected)
    end
end