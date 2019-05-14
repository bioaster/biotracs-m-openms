% BIOASTER
%> @file		MetaboLinkingWorkflow.m
%> @class		biotracs.openms.model.MetaboLinkingWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef MetaboLinkingWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        
        % Constructor
        function this = MetaboLinkingWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doMetaboLinkingWorkflow();
        end
        
    end
    
    methods(Access = protected)
        
        function this = doMetaboLinkingWorkflow( this )
            %Add FileImporter 'mzXML'
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MzFileImporter' );
            
            %Add MapAlignerPoseClustering
            mapAlignerPoseClustering = biotracs.openms.model.MapAlignerPoseClustering();
            this.addNode( mapAlignerPoseClustering, 'MapAlignerPoseClustering' );
            
            %Add TextExporterMapAlignerPoseClustering
%             textExporterMapAligner = biotracs.openms.model.TextExporter();
%             this.addNode( textExporterMapAligner, 'TextExporterMapAligner' );
            
            %Add MapAlignerParser
%             mapAlignerParser = biotracs.openms.model.MapAlignerParser();
%             this.addNode(mapAlignerParser, 'MapAlignerParser'); 
%             
            %Add MapStatistics
            mapStatistics = biotracs.openms.model.MapStatistics();
            this.addNode( mapStatistics, 'MapStatistics' );
            
            %Add MapStatisticParser
            mapStatisticsParser = biotracs.openms.model.MapStatisticsParser();
            this.addNode( mapStatisticsParser, 'MapStatisticsParser' );
            
            %Add FeatureLinkerUnlabeledQT
            featureLinkerUnlabeledQT = biotracs.openms.model.FeatureLinkerUnlabeledQT();
            this.addNode( featureLinkerUnlabeledQT, 'FeatureLinkerUnlabeledQT' );
            
            % Add File Filter Quality 
            qualityFileFilter = biotracs.openms.model.FileFilter();
            qualityFileFilter.getConfig() ...
                .updateParamValue('MinConsensusSize', [2, Inf]);
            this.addNode( qualityFileFilter, 'QualityFileFilter' );
            
            %Add TextExporter
            textExporter = biotracs.openms.model.TextExporter();
            this.addNode( textExporter, 'TextExporter' );
            
            %Add AccurateMassSearch
            accurateMassSearch = biotracs.openms.model.AccurateMassSearch();
            accurateMassSearch.setIsPhantom(true);
            this.addNode( accurateMassSearch, 'AccurateMassSearch' );

            inputAdapter.getOutputPort('DataFileSet').connectTo( mapAlignerPoseClustering.getInputPort('DataFileSet') );
%             mapAlignerPoseClustering.getOutputPort('DataFileSet').connectTo(textExporterMapAligner.getInputPort('DataFileSet'));
%             textExporterMapAligner.getOutputPort('DataFileSet').connectTo(mapAlignerParser.getInputPort('DataFile'));
            mapAlignerPoseClustering.getOutputPort('DataFileSet').connectTo(mapStatistics.getInputPort('DataFileSet'));
            mapStatistics.getOutputPort('DataFileSet').connectTo(mapStatisticsParser.getInputPort('DataFile'));
            mapAlignerPoseClustering.getOutputPort('DataFileSet').connectTo(featureLinkerUnlabeledQT.getInputPort('DataFileSet'));
            featureLinkerUnlabeledQT.getOutputPort('DataFileSet').connectTo(qualityFileFilter.getInputPort('DataFileSet'));
            qualityFileFilter.getOutputPort('DataFileSet').connectTo(textExporter.getInputPort('DataFileSet'));
            qualityFileFilter.getOutputPort('DataFileSet').connectTo(accurateMassSearch.getInputPort('DataFileSet'));
        end

    end
    
end
