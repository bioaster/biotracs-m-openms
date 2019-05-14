% BIOASTER
%> @file		ProteoFeatureExtractionWorkflow.m
%> @class		biotracs.openms.model.ProteoFeatureExtractionWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef ProteoFeatureExtractionWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
        workflow;
    end
    
    methods
        
        % Constructor
        function this = ProteoFeatureExtractionWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doProteoFeatureExctractionWorkflow();
        end
        
    end
    
    methods(Access = protected)
        
        function this = doProteoFeatureExctractionWorkflow( this )
            %Add FileImporter 'mzXML'
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MzFileImporter' );
            
            %Add FileFilter for SNR
            fileFilterSnr = biotracs.openms.model.FileFilter();
            fileFilterSnr.getConfig()...
                .updateParamValue('Charge', [])...
                .updateParamValue('FeatureQuality', [])...
                .updateParamValue('Snr', 1);...
                this.addNode( fileFilterSnr, 'SnrFileFilter' );
            
            %Add SeedListGenerator
%             seedListGenerator = biotracs.openms.model.SeedListGenerator();
%             this.addNode(seedListGenerator, 'SeedListGenerator');
           
            %Add FeatureFinderCentroided
            featureFinderCentroided = biotracs.openms.model.FeatureFinderCentroided();
            this.addNode( featureFinderCentroided, 'FeatureFinderCentroided' );
            
            %Add FileFilter 'featureXML' => 'featureXML'
            fileFilter = biotracs.openms.model.FileFilter();
            fileFilter.getConfig() ...
                .updateParamValue('FeatureQuality', [0.1e-5, 1]) ...
                .updateParamValue('Charge', [2,5]);
            this.addNode( fileFilter, 'FeatureQualityFileFilter' );
            
            inputAdapter.getOutputPort('DataFileSet').connectTo( fileFilterSnr.getInputPort('DataFileSet') );
%             fileFilterSnr.getOutputPort('DataFileSet').connectTo( seedListGenerator.getInputPort('DataFileSet') );
%             seedListGenerator.getOutputPort('DataFileSet').connectTo( featureFinderCentroided.getInputPort('SeedList') );
            fileFilterSnr.getOutputPort('DataFileSet').connectTo( featureFinderCentroided.getInputPort('DataFileSet') );
            featureFinderCentroided.getOutputPort('DataFileSet').connectTo( fileFilter.getInputPort('DataFileSet') );

        end
        
    end
    
end

