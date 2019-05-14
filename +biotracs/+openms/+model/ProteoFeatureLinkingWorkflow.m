% BIOASTER
%> @file		ProteoFeatureLinkingWorkflow.m
%> @class		biotracs.openms.model.ProteoFeatureLinkingWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef ProteoFeatureLinkingWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        
        % Constructor
        function this = ProteoFeatureLinkingWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doProteoFeatureLinkingWorkflow();
        end
        
    end
    
    methods(Access = protected)

        function this = doProteoFeatureLinkingWorkflow( this )
            %Add FileImporter 'mzXML'
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MzFileImporter' );
            
            %Add MapAlignerPoseClustering
            mapAlignerPoseClustering = biotracs.openms.model.MapAlignerPoseClustering();
            this.addNode( mapAlignerPoseClustering, 'MapAlignerPoseClustering' );
            
            %Add TextExporterMapAlignerPoseClustering
            textExporterMapAligner = biotracs.openms.model.TextExporter();
            this.addNode( textExporterMapAligner, 'TextExporterMapAligner' );
            
            %Add MapAlignerParser
            mapAlignerParser = biotracs.openms.model.MapAlignerParser();
            this.addNode(mapAlignerParser, 'MapAlignerParser');
            
            %Add MapStatistics
            mapStatistics = biotracs.openms.model.MapStatistics();
            this.addNode( mapStatistics, 'MapStatistics' );
            
            %Add MapStatisticParser
            mapStatisticsParser = biotracs.openms.model.MapStatisticsParser();
            this.addNode( mapStatisticsParser, 'MapStatisticsParser' );
            
            %Add FeatureLinkerUnlabeledQT
            featureLinkerUnlabeledQT = biotracs.openms.model.FeatureLinkerUnlabeledQT();
            this.addNode( featureLinkerUnlabeledQT, 'FeatureLinkerUnlabeledQT' );
            
            featureLinkerTextExporter = biotracs.openms.model.TextExporter();
            this.addNode( featureLinkerTextExporter, 'FeatureLinkerUnlabeledQTTextExporter' );
            
            % Add File Filter Quality 
            qualityFileFilter = biotracs.openms.model.FileFilter();
            qualityFileFilter.getConfig() ...
                .updateParamValue('MinConsensusSize', [2, Inf]) ...
                .updateParamValue('Charge', [2,5]);
            this.addNode( qualityFileFilter, 'QualityFileFilter' );
            
            %Add ConsensusMapNormalizer
            consensusMapNormalizer = biotracs.openms.model.ConsensusMapNormalizer();
            this.addNode( consensusMapNormalizer, 'ConsensusMapNormalizer' );
            
            %Add TextExporter
            textExporterConsensusNormalizer = biotracs.openms.model.TextExporter();
            this.addNode( textExporterConsensusNormalizer, 'ConsensusNormalizerTextExporter' );
            
            inputAdapter.getOutputPort('DataFileSet').connectTo(mapAlignerPoseClustering.getInputPort('DataFileSet'));
            mapAlignerPoseClustering.getOutputPort('DataFileSet').connectTo(textExporterMapAligner.getInputPort('DataFileSet'));
            mapAlignerPoseClustering.getOutputPort('DataFileSet').connectTo(mapStatistics.getInputPort('DataFileSet'));
            mapAlignerPoseClustering.getOutputPort('DataFileSet').connectTo(featureLinkerUnlabeledQT.getInputPort('DataFileSet'));
            featureLinkerUnlabeledQT.getOutputPort('DataFileSet').connectTo( featureLinkerTextExporter.getInputPort('DataFileSet'));
            textExporterMapAligner.getOutputPort('DataFileSet').connectTo(mapAlignerParser.getInputPort('DataFile'));
            mapStatistics.getOutputPort('DataFileSet').connectTo(mapStatisticsParser.getInputPort('DataFile'));
            featureLinkerUnlabeledQT.getOutputPort('DataFileSet').connectTo(qualityFileFilter.getInputPort('DataFileSet'));
            qualityFileFilter.getOutputPort('DataFileSet').connectTo( consensusMapNormalizer.getInputPort('DataFileSet'));
            consensusMapNormalizer.getOutputPort('DataFileSet').connectTo( textExporterConsensusNormalizer.getInputPort('DataFileSet'));
        end
        
    end
    
end

