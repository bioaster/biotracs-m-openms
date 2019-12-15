% BIOASTER
%> @file		XtandemIdentificationWorkflow.m
%> @class		biotracs.openms.model.XtandemIdentificationWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef XtandemIdentificationWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
        workflow;
    end
    
    methods
        % Constructor
        function this = XtandemIdentificationWorkflow( )
            %#function biotracs.openms.model.XtandemIdentificationWorkflowConfig
            
            this@biotracs.core.mvc.model.Workflow();
            this.configType = 'biotracs.openms.model.XtandemIdentificationWorkflowConfig';
            this.doXtandemIdentificationWorkflow();
        end
    end
    
    methods(Access = protected)
        
        function this = doXtandemIdentificationWorkflow( this )
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
            
           
            %Add IDPosteriorErrorProbability 'idXML' => 'idXML'
            idPosteriorErrorProbabilityXtandem = biotracs.openms.model.IDPosteriorErrorProbability();
            this.addNode( idPosteriorErrorProbabilityXtandem, 'IDPosteriorErrorProbabilityXtandem' );
            
            %connect mz file importers
            mzFileImporter.getOutputPort('DataFileSet').connectTo( xtandemAdapter.getInputPort('DataFileSet') );
            xtandemAdapter.getOutputPort('DataFileSet').connectTo( idPosteriorErrorProbabilityXtandem.getInputPort('DataFileSet') );
            
            %connect fasta file importer
            fastaImporter.getOutputPort('DataFileSet').connectTo( fastaImporterDemux.getInputPort('ResourceSet') );
            fastaImporterDemux.getOutputPort('Resource').connectTo( xtandemAdapter.getInputPort('DatabaseFile') );
           
          
        end
        
    end
    
end

