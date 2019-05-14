% BIOASTER
%> @file		ConsensusIdConfig.m
%> @class		biotracs.openms.model.ConsensusIdConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015

classdef ConsensusIDConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
        
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = ConsensusIDConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
			this.updateParamValue('OutputFileExtension','idXML');
            this.createParam('DeltaRt', 0.01, ...
                'Constraint', biotracs.core.constraint.IsPositive(), ...
                'Description', 'Maximum allowed precursor RT deviation between identifications. (default: 0.01, min:0)');
            this.createParam('DeltaMz', 0.01, ...
                'Constraint', biotracs.core.constraint.IsPositive(), ...
                'Description', 'Maximum allowed precursor m/z deviation between identifications. (default: 0.01, min:0)');
            this.optionSet.addElements(...
                'DeltaRt',       biotracs.core.shell.model.Option('-rt_delta "%g"'), ...
                'DeltaMz',       biotracs.core.shell.model.Option('-mz_delta "%g"') ...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)        
    end

end
