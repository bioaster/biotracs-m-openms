% BIOASTER
%> @file		PeptideIdentificationWorkflow.m
%> @class		biotracs.openms.model.PeptideIdentificationWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef PeptideIdentificationWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
        workflow;
    end
    
    methods
        % Constructor
        function this = PeptideIdentificationWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doPeptideIdentificationWorkflow();
        end
    end
    
    methods(Access = protected)
        
        function this = doPeptideIdentificationWorkflow( this )
            %Add FileImporter 'mzXML'
            mzFileImporter = biotracs.core.adapter.model.FileImporter();
            this.addNode( mzFileImporter, 'MzFileImporter' );
            
            %Add FastaImporter
            fastaImporter = biotracs.core.adapter.model.FileImporter();
            this.addNode( fastaImporter, 'FastaImporter' );
            
            %Add FastaImporterDemux
            fastaImporterDemux = biotracs.core.adapter.model.Demux();
            this.addNode( fastaImporterDemux, 'FastaImporterDemux' );
            fastaImporterDemux...
                .updateInputPortClass('ResourceSet','biotracs.data.model.DataFileSet')...
                .updateOutputPortClass('Resource','biotracs.data.model.DataFile');
            fastaImporterDemux.getOutput()...
                .resize(1)...
                .setIsResizable(false);
            
            %Add XtandemAdapter Experiment 'mzML' => 'idXML'
            xtandemAdapter = biotracs.openms.model.XTandemAdapter();
            this.addNode( xtandemAdapter, 'XTandemAdapter' );
            
            %Add MascotOnlineAdapter Experiment 'mzML' => 'idXML'
            mascotAdapterOnline = biotracs.openms.model.MascotAdapterOnline();
            this.addNode( mascotAdapterOnline, 'MascotAdapterOnline' );
            
            %Add IDPosteriorErrorProbability 'idXML' => 'idXML'
            idPosteriorErrorProbabilityXtandem = biotracs.openms.model.IDPosteriorErrorProbability();
            this.addNode( idPosteriorErrorProbabilityXtandem, 'IDPosteriorErrorProbabilityXtandem' );
            
            %Add IDPosteriorErrorProbability 'idXML' => 'idXML'
            idPosteriorErrorProbabilityMascotAdapterOnline = biotracs.openms.model.IDPosteriorErrorProbability();
            this.addNode( idPosteriorErrorProbabilityMascotAdapterOnline, 'IDPosteriorErrorProbabilityMascotAdapterOnline' );
            
            %Add Mux
            mascotXtandemMux = biotracs.core.adapter.model.Mux();
            mascotXtandemMux.getInput()...
                .resize(2)...
                .setIsResizable(false);
            this.addNode( mascotXtandemMux, 'MascotXtandemMux' );
            
            %Add IdMerger
            idMerger = biotracs.openms.model.IDMerger();
            this.addNode( idMerger, 'IDMerger' );
            
            %Add ConsensusId
            consensusId = biotracs.openms.model.ConsensusID();
            this.addNode( consensusId, 'ConsensusID' );
            
            %Add PeptideIndexer
            peptideIndexer = biotracs.openms.model.PeptideIndexer();
            this.addNode( peptideIndexer, 'PeptideIndexer' );
            
             % Add FileDispatcher
            fileDispatcherAdapter = biotracs.core.adapter.model.FileDispatcher();
            this.addNode( fileDispatcherAdapter, 'FileDispatcher' );
            
            %Add Mux
            muxAdapterIdMergerPepIndex = biotracs.core.adapter.model.Mux();
            this.addNode( muxAdapterIdMergerPepIndex, 'MuxIDMergerPepIndex' );
           
            %Add IdMerger after Peptide Indexer
            idMergerPeptideIndexer = biotracs.openms.model.IDMerger();
            this.addNode( idMergerPeptideIndexer, 'IDMergerPepIndex' );
    
            %Add FalseDiscoveryRate
            falseDiscoveryRate = biotracs.openms.model.FalseDiscoveryRate();
            this.addNode( falseDiscoveryRate, 'FalseDiscoveryRate' );
            
            %Add IdFilter
            idFilter = biotracs.openms.model.IDFilter();
            this.addNode( idFilter, 'IDFilter' );

            %Add FidoAdapter
            fidoAdapter = biotracs.openms.model.FidoAdapter();
            this.addNode( fidoAdapter, 'FidoAdapter' );
            
            %connect mz file importers
            mzFileImporter.getOutputPort('DataFileSet').connectTo( xtandemAdapter.getInputPort('DataFileSet') );
            mzFileImporter.getOutputPort('DataFileSet').connectTo( mascotAdapterOnline.getInputPort('DataFileSet') );
            xtandemAdapter.getOutputPort('DataFileSet').connectTo( idPosteriorErrorProbabilityXtandem.getInputPort('DataFileSet') );
            mascotAdapterOnline.getOutputPort('DataFileSet').connectTo( idPosteriorErrorProbabilityMascotAdapterOnline.getInputPort('DataFileSet') );      
 
            %connect fasta file importer
            fastaImporter.getOutputPort('DataFileSet').connectTo( fastaImporterDemux.getInputPort('ResourceSet') );
            fastaImporterDemux.getOutputPort('Resource').connectTo( xtandemAdapter.getInputPort('DatabaseFile') );
            fastaImporterDemux.getOutputPort('Resource').connectTo( peptideIndexer.getInputPort('DatabaseFile') );
            
            %mux mascot & xtandem
            idPosteriorErrorProbabilityXtandem.getOutputPort('DataFileSet').connectTo( mascotXtandemMux.getInputPort('Resource#1') );
            idPosteriorErrorProbabilityMascotAdapterOnline.getOutputPort('DataFileSet').connectTo( mascotXtandemMux.getInputPort('Resource#2') );
            mascotXtandemMux.getOutputPort('ResourceSet').connectTo( idMerger.getInputPort('DataFileSet'));
            
            idMerger.getOutputPort('DataFileSet').connectTo(consensusId.getInputPort('DataFileSet'));
            consensusId.getOutputPort('DataFileSet').connectTo( peptideIndexer.getInputPort('DataFileSet') );
            peptideIndexer.getOutputPort('DataFileSet').connectTo( falseDiscoveryRate.getInputPort('DataFileSet'));
            falseDiscoveryRate.getOutputPort('DataFileSet').connectTo(idFilter.getInputPort('DataFileSet'));

            peptideIndexer.getOutputPort('DataFileSet').connectTo(fileDispatcherAdapter.getInputPort('DataFileSet'));
            fileDispatcherAdapter.getOutput().connectTo( muxAdapterIdMergerPepIndex.getInput() );
            muxAdapterIdMergerPepIndex.getOutputPort('ResourceSet').connectTo( idMergerPeptideIndexer.getInputPort('DataFileSet'));
            
            idMergerPeptideIndexer.getOutputPort('DataFileSet').connectTo(fidoAdapter.getInputPort('DataFileSet'));
        end
        
    end
    
end

