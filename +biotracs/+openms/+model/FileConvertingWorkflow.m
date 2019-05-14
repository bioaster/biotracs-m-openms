% BIOASTER
%> @file		FileConvertingWorkflow.m
%> @class		biotracs.openms.model.FileConvertingWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef FileConvertingWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        % Constructor
        function this = FileConvertingWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doFileConvertingWorkflow();
        end
    end
    
    methods(Access = protected)
        
        function this = doFileConvertingWorkflow( this )
            %Add FileImporter 'mzXML'
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MzFileImporter' );
            
            %Add FileConverter Experiment 'mzXML' => 'mzML
            fileConverter = biotracs.openms.model.FileConverter();
            this.addNode( fileConverter, 'FileConverter' );
            
%            Add File Filter for retention time 
            fileFilter = biotracs.openms.model.FileFilter();
            fileFilter.getConfig()...
                .updateParamValue('Charge', [])...
                .updateParamValue('FeatureQuality', []);
            this.addNode( fileFilter, 'RtFileFilter' );
            
            inputAdapter.getOutputPort('DataFileSet').connectTo( fileConverter.getInputPort('DataFileSet') );
            fileConverter.getOutputPort('DataFileSet').connectTo( fileFilter.getInputPort('DataFileSet'));
        end
        
    end
    
end

