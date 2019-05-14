% BIOASTER
% %> @file		FalseDiscoveryRateConfig.m
%> @class		biotracs.openms.model.FalseDiscoveryRateConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016


classdef FalseDiscoveryRateConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FalseDiscoveryRateConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
			this.updateParamValue('OutputFileExtension','idXML');
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end
    
end
