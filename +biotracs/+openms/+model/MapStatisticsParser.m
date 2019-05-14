% BIOASTER
%> @file		MapStatisticsParser.m
%> @class		biotracs.openms.model.MapStatisticsParser
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date        2017

classdef MapStatisticsParser < biotracs.parser.model.TableParser
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = MapStatisticsParser()
            this@biotracs.parser.model.TableParser();
        end
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
     
        function doRun( this )
            this.doRun@biotracs.parser.model.TableParser();
            resourceSet = this.getOutputPortData( 'ResourceSet' );
            resourceSet = biotracs.openms.model.MapStatisticsResult.fromResourceSet(resourceSet);
            this.setOutputPortData( 'ResourceSet', resourceSet );
        end
%         
        function [ featureData ] = doParse( this, iFilePath )
            data = this.doParse@biotracs.parser.model.TableParser( iFilePath );
            
            %Select the 3 first columns
            featureData = data.selectByColumnName('^(RT_begin|RT_end|number_of_features)$');
            
            % Replace column Names
            featureData = featureData.setColumnNames ({ 'RtBegin', 'RtEnd', 'NumberOfFeatures'});
            featureData = biotracs.data.model.DataMatrix.fromDataTable(featureData);

        end
    end
    
end
