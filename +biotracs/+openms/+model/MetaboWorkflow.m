% BIOASTER
%> @file		MetaboWorkflow.m
%> @class		biotracs.openms.model.MetaboWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef MetaboWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
        workflow;
    end
    
    methods
        % Constructor
        function this = MetaboWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doBuildMetaboWorkflow();
        end
    end
    
    methods(Access = protected)
        
        function this = doBuildMetaboWorkflow( this )
            mzFileImporter = biotracs.core.adapter.model.FileImporter();
            this.addNode( mzFileImporter, 'MzFileImporter' );
            this.doExtractionWorkflow();
            this.doLinkingWorkflow();
            this.doConnectWorkflows();
        end
        
        function this = doExtractionWorkflow(this)
           metaboExtractionWorkflow = biotracs.openms.model.MetaboExtractionWorkflow();
           this.addNode(metaboExtractionWorkflow, 'FeatureExtraction');
           metaboExtractionWorkflow.createInputPortInterface('FileConverter', 'DataFileSet');
           metaboExtractionWorkflow.createOutputPortInterface('FileFilter', 'DataFileSet');
        end
        
        function this = doLinkingWorkflow(this)
           metaboLinkingWorkflow = biotracs.openms.model.MetaboLinkingWorkflow();
           this.addNode(metaboLinkingWorkflow, 'FeatureLinking');
           metaboLinkingWorkflow.createInputPortInterface('MapAlignerPoseClustering', 'DataFileSet');
           metaboLinkingWorkflow.createOutputPortInterface('TextExporter', 'DataFileSet');
        end
        
        function this = doConnectWorkflows(this)
            mzFileImporter = this.getNode('MzFileImporter');
            metaboExtractionWorkflow = this.getNode('FeatureExtraction');
            metaboLinkingWorkflow = this.getNode('FeatureLinking');
            
            mzFileImporter.getOutputPort('DataFileSet').connectTo( metaboExtractionWorkflow.getInputPort('FileConverter:DataFileSet') );
            metaboExtractionWorkflow.getOutputPort('FileFilter:DataFileSet').connectTo( metaboLinkingWorkflow.getInputPort('MapAlignerPoseClustering:DataFileSet') );
        end

    end
    
end

