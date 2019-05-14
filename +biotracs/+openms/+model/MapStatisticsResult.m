% BIOASTER
%> @file		MapStatisticsResult.m
%> @class		biotracs.openms.model.MapStatisticsResult
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date        2017

classdef MapStatisticsResult < biotracs.core.mvc.model.ResourceSet
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = MapStatisticsResult( varargin )
            this@biotracs.core.mvc.model.ResourceSet( varargin{:} );
            this.bindView( biotracs.openms.view.MapStatisticsResult() );
        end

        function this = setLabel( this, iLabel )
            this.setLabel@biotracs.core.mvc.model.ResourceSet(iLabel);
            this.setLabelsOfElements(iLabel);
        end
        
    end
    
    % -------------------------------------------------------
    % Static
    % -------------------------------------------------------
    
    methods(Static)
        
        function this = fromResourceSet( iResourceSet )
            if ~isa( iResourceSet, 'biotracs.core.mvc.model.ResourceSet' )
                error('A ''biotracs.core.mvc.model.ResourceSet'' is required');
            end
            this = biotracs.openms.model.MapStatisticsResult();
            this.doCopy( iResourceSet );
        end
        
    end
    
end
