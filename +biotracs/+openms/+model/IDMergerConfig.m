% BIOASTER
%> @file		IDMergerConfig.m
%> @class		biotracs.openms.model.IDMergerConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015


classdef IDMergerConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
        
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = IDMergerConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
            this.getParam('InputFilePath')...
                .getConstraint()...
                .setCheckValidity(false);
			this.updateParamValue('OutputFileExtension','idXML');
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)      
    end
    
end
