% BIOASTER
%> @file		MergeIdentificationWorkflow.m
%> @class		biotracs.openms.model.MergeIdentificationWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef MergeIdentificationWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        % Constructor
        function this = MergeIdentificationWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doMergeIdentificationWorkflow();
        end
    end
    
    methods(Access = protected)
        
        function this = doMergeIdentificationWorkflow( this )
            %Add FileImporter 'mzXML'
            mzFileImporter = biotracs.core.adapter.model.FileImporter();
            this.addNode( mzFileImporter, 'MzFileImporter' );

            
            %Add IdMerger
            idMerger = biotracs.openms.model.IDMerger();
            this.addNode( idMerger, 'IDMerger' );
            
            %Add ConsensusId
            consensusId = biotracs.openms.model.ConsensusID();
            this.addNode( consensusId, 'ConsensusID' );

           
            mzFileImporter.getOutputPort('DataFileSet').connectTo( idMerger.getInputPort('DataFileSet'));
            idMerger.getOutputPort('DataFileSet').connectTo(consensusId.getInputPort('DataFileSet'));
          
        end
        
    end
    
end

