% BIOASTER
%> @file		MapStatisticsConfig.m
%> @class		biotracs.openms.model.MapStatisticsConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017


classdef MapStatisticsConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = MapStatisticsConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
			this.updateParamValue('OutputFileExtension','txt');
            this.createParam('NumberOfSlice', 4, ...
                'Constraint', biotracs.core.constraint.IsPositive('Type', 'integer'), ...
                'Description', 'Report separate statistics for each of n RT slices of the map');
            this.createParam('TypeOfFiles', '', ...
                'Constraint', biotracs.core.constraint.IsText(), ...
                'Description', 'Choose the type of files for plotting, QC or all. For all, type ".*" ');
            this.optionSet.addElements(...
                'NumberOfSlice',    biotracs.core.shell.model.Option('-n "%d"'));
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)

    end
    
end
