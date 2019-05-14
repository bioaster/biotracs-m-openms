% BIOASTER
%> @file		EngineIdentificationWorkflowConfig.m
%> @class		biotracs.openms.model.EngineIdentificationWorkflowConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef EngineIdentificationWorkflowConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties(SetAccess = protected)
    end
    
    methods
        % Constructor
        function this = EngineIdentificationWorkflowConfig( )
            this@biotracs.core.mvc.model.ProcessConfig();
             this.createParam('UseMascot', 'true', ...
                'Constraint', biotracs.core.constraint.IsInSet({'true', 'false'}), ...
                'Description', 'To be define if the engine Mascot is to be used for the identification, true or false (default: true)');
            this.createParam('UseXTandem', 'true', ...
                'Constraint', biotracs.core.constraint.IsInSet({'true', 'false'}), ...
                'Description', 'To be define if the engine XTandem is to be used for the identification, true or false (default: true)');
        end
    end
    
    methods(Access = protected)
        
        
    end
        
    
    
end