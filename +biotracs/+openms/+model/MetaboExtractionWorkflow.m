% BIOASTER
%> @file		MetaboExtractionWorkflow.m
%> @class		biotracs.openms.model.MetaboExtractionWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017

classdef MetaboExtractionWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        % Constructor
        function this = MetaboExtractionWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doMetaboExtractionWorkflow();
        end
    end
    
    methods(Access = protected)
        function this = doMetaboExtractionWorkflow( this )
            %Add FileImporter 'mzXML'
            mzFileImporter = biotracs.core.adapter.model.FileImporter();
            this.addNode( mzFileImporter, 'MzFileImporter' );
            
            %Add FileConverter Experiment 'mzXML' => 'mzML
            fileConverter = biotracs.openms.model.FileConverter();
            this.addNode( fileConverter, 'FileConverter' );
            
            %Add FeatureFinder 'mzML' => 'featureXML'
            featureFinderMetabo = biotracs.openms.model.FeatureFinderMetabo();
            this.addNode( featureFinderMetabo, 'FeatureFinderMetabo' );
            
            %Add FileFilter 'featureXML' => 'featureXML'
            fileFilter = biotracs.openms.model.FileFilter();
            fileFilter.getConfig() ...
                .updateParamValue('FeatureQuality', [1e-5, 1]);
            this.addNode( fileFilter, 'FileFilter' );

            mzFileImporter.getOutputPort('DataFileSet').connectTo( fileConverter.getInputPort('DataFileSet') );
            fileConverter.getOutputPort('DataFileSet').connectTo( featureFinderMetabo.getInputPort('DataFileSet') );
            featureFinderMetabo.getOutputPort('DataFileSet').connectTo( fileFilter.getInputPort('DataFileSet') );
        end
    end
    
end

