% BIOASTER
%> @file		MapStatisticsParserConfig.m
%> @class		biotracs.openms.model.MapStatisticsParserConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date        2017

classdef MapStatisticsParserConfig < biotracs.parser.model.TableParserConfig
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = MapStatisticsParserConfig( )
            this@biotracs.parser.model.TableParserConfig();
            this.setDescription('Configuration parameters of the Map Statistics Table parser');
            this.updateParamValue('FileExtensionFilter', '.txt');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        
    end
    
end
