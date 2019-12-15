% BIOASTER
%> @file		MapAlignerResult.m
%> @class		biotracs.openms.model.MapAlignerResult
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date        2017

classdef MapAlignerResult < biotracs.core.mvc.model.ResourceSet
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = MapAlignerResult( varargin )
            %#function biotracs.openms.view.MapAlignerResult
            
            this@biotracs.core.mvc.model.ResourceSet( varargin{:} );
            this.bindView( biotracs.openms.view.MapAlignerResult() );
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
            this = biotracs.openms.model.MapAlignerResult();
            this.doCopy( iResourceSet );
        end
        
    end
    
end
