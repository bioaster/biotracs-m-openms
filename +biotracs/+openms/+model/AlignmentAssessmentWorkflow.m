% BIOASTER
%> @file		AlignmentAssessmentWorkflow.m
%> @class		biotracs.openms.model.AlignmentAssessmentWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef AlignmentAssessmentWorkflow <biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        % Constructor
        function this = AlignmentAssessmentWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doBuildAlignWorkflow();
        end
    end
    
    methods(Access = protected)
        
        function this = doBuildAlignWorkflow( this )
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MzFileImporter' );
            
            %Add MapAlignerPoseClustering
            mapAlignerPoseClustering = biotracs.openms.model.MapAlignerPoseClustering();
            this.addNode( mapAlignerPoseClustering, 'MapAlignerPoseClustering' );
            
            %Add TextExporterMapAlignerPoseClustering
            textExporterMapAligner = biotracs.openms.model.TextExporter();
            this.addNode( textExporterMapAligner, 'TextExporterMapAligner' );
            
            %Add MapStatistics
            mapStatistics = biotracs.openms.model.MapStatistics();
            this.addNode( mapStatistics, 'MapStatistics' );
            
            % TableParser
            mapAlignerParser = biotracs.openms.model.MapAlignerParser();
            this.addNode( mapAlignerParser, 'MapAlignerTableParser' );
            
%             % TableParser
            mapStatisticsParser =  biotracs.openms.model.MapStatisticsParser();
            this.addNode( mapStatisticsParser, 'MapStatisticsTableParser' );
            
            inputAdapter.getOutputPort('DataFileSet').connectTo( mapAlignerPoseClustering.getInputPort('DataFileSet') );
            mapAlignerPoseClustering.getOutputPort('DataFileSet').connectTo(textExporterMapAligner.getInputPort('DataFileSet'));
            textExporterMapAligner.getOutputPort('DataFileSet').connectTo(mapAlignerParser.getInputPort('DataFile'));
            mapAlignerPoseClustering.getOutputPort('DataFileSet').connectTo(mapStatistics.getInputPort('DataFileSet'));
            mapStatistics.getOutputPort('DataFileSet').connectTo(mapStatisticsParser.getInputPort('DataFile'));
        end
        
    end
    
    methods(Access = protected)
    end
end

