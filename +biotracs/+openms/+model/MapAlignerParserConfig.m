% BIOASTER
%> @file		MapAlignerParserConfig.m
%> @class		biotracs.openms.model.MapAlignerParserConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date        2017

classdef MapAlignerParserConfig < biotracs.parser.model.TableParserConfig
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods

        function this = MapAlignerParserConfig( )
				this@biotracs.parser.model.TableParserConfig( );
                this.setDescription('Configuration parameters of the Extended Table parser');
                this.updateParamValue('Mode', 'extended');
                this.updateParamValue('FileExtensionFilter', '.csv');
		  end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)

    end
    
end
