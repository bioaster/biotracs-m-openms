% BIOASTER
%> @file		MascotIdentificationWorkflow.m
%> @class		biotracs.openms.model.MascotIdentificationWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef MascotIdentificationWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
        workflow;
    end
    
    methods
        % Constructor
        function this = MascotIdentificationWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.configType = 'biotracs.openms.model.MascotIdentificationWorkflowConfig';
%             useMascot = this.config.getParamValue('UseMascot');
%             if useMascot
                this.doMascotIdentificationWorkflow();
%             else
%                 this.setIsPhantom( true );
%             end
        end
    end
    
    methods(Access = protected)
        
        function this = doMascotIdentificationWorkflow( this )
            %Add FileImporter 'mzXML'
            mzFileImporter = biotracs.core.adapter.model.FileImporter();
            this.addNode( mzFileImporter, 'MzFileImporter' );
        
            %Add MascotOnlineAdapter Experiment 'mzML' => 'idXML'
            mascotAdapterOnline = biotracs.openms.model.MascotAdapterOnline();
            this.addNode( mascotAdapterOnline, 'MascotAdapterOnline' );
            
            %Add IDPosteriorErrorProbability 'idXML' => 'idXML'
            idPosteriorErrorProbabilityMascotAdapterOnline = biotracs.openms.model.IDPosteriorErrorProbability();
            this.addNode( idPosteriorErrorProbabilityMascotAdapterOnline, 'IDPosteriorErrorProbabilityMascotAdapterOnline' );
         
             
            %mux mascot & xtandem
            mzFileImporter.getOutputPort('DataFileSet').connectTo( mascotAdapterOnline.getInputPort('DataFileSet') );
            mascotAdapterOnline.getOutputPort('DataFileSet').connectTo( idPosteriorErrorProbabilityMascotAdapterOnline.getInputPort('DataFileSet') );      
  
          
        end
        
    end
    
end

