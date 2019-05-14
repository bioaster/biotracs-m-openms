% BIOASTER
%> @file		PeptideIdentificationXtandemWorkflow.m
%> @class		biotracs.openms.model.PeptideIdentificationXtandemWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017

classdef PeptideIdentificationXtandemWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
        workflow;
    end
    
    methods
        % Constructor
        function this = PeptideIdentificationXtandemWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doPeptideIdentificationXtandemWorkflow();
        end
    end
    
    methods(Access = protected)
        function this = doPeptideIdentificationXtandemWorkflow( this )
            %Add FileImporter 'mzXML'
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MzFileImporter' );
            
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
            
            %Add XTAndem  'mzML' => 'idXML'
            xtandemAdapter = biotracs.openms.model.XTandemAdapter();
            this.addNode( xtandemAdapter, 'XTandemAdapter' );
            
            %Add IDPosteriorErrorProbability 'idXML' => 'idXML'
            idPosteriorErrorProbabilityMascotAdapterOnline = biotracs.openms.model.IDPosteriorErrorProbability();
            this.addNode( idPosteriorErrorProbabilityMascotAdapterOnline, 'IDPosteriorErrorProbabilityMascotAdapterOnline' );

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
            
            inputAdapter.getOutputPort('DataFileSet').connectTo( xtandemAdapter.getInputPort('DataFileSet') );
             fastaImporterDemux.getOutputPort('Resource').connectTo( xtandemAdapter.getInputPort('DatabaseFile') );

            xtandemAdapter.getOutputPort('DataFileSet').connectTo( idPosteriorErrorProbabilityMascotAdapterOnline.getInputPort('DataFileSet') );            
            fastaImporter.getOutputPort('DataFileSet').connectTo( fastaImporterDemux.getInputPort('ResourceSet') );
            fastaImporterDemux.getOutputPort('Resource').connectTo( peptideIndexer.getInputPort('DatabaseFile') );
            idPosteriorErrorProbabilityMascotAdapterOnline.getOutputPort('DataFileSet').connectTo( peptideIndexer.getInputPort('DataFileSet') );
            
            peptideIndexer.getOutputPort('DataFileSet').connectTo( falseDiscoveryRate.getInputPort('DataFileSet'));
            falseDiscoveryRate.getOutputPort('DataFileSet').connectTo(idFilter.getInputPort('DataFileSet'));
            
            peptideIndexer.getOutputPort('DataFileSet').connectTo(fileDispatcherAdapter.getInputPort('DataFileSet'));
            fileDispatcherAdapter.getOutput().connectTo( muxAdapterIdMergerPepIndex.getInput() );
            muxAdapterIdMergerPepIndex.getOutputPort('ResourceSet').connectTo( idMergerPeptideIndexer.getInputPort('DataFileSet'));
            
            idMergerPeptideIndexer.getOutputPort('DataFileSet').connectTo(fidoAdapter.getInputPort('DataFileSet'));
        end
    end
    
end

