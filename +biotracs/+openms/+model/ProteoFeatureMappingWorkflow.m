% BIOASTER
%> @file		ProteoFeatureMappingWorkflow.m
%> @class		biotracs.openms.model.ProteoFeatureMappingWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef ProteoFeatureMappingWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
        workflow;
    end
    
    methods
        % Constructor
        function this = ProteoFeatureMappingWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doProteoFeatureMappingWorkflow();
        end
    end
    
    methods(Access = protected)
        function this = doProteoFeatureMappingWorkflow( this )
            %Add FileImporter 'mzXML'
            inputFeatureFinderAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputFeatureFinderAdapter, 'FeatureFinderCentroidedImporter' );
             
            %Add FileImporter 'mzXML'
            inputFileFilterAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputFileFilterAdapter, 'IdFilterImporter' );
               
            %Add IdMapper
            idMapper = biotracs.openms.model.IDMapper();
            this.addNode( idMapper, 'IDMapper' );
            
            inputFeatureFinderAdapter.getOutputPort('DataFileSet').connectTo( idMapper.getInputPort('FeatureFileSet'));
            inputFileFilterAdapter.getOutputPort('DataFileSet').connectTo( idMapper.getInputPort('IdFileSet'));
        end
 
    end
    
end

