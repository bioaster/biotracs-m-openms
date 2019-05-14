% BIOASTER
% %> @file		FidoAdapterConfig.m
%> @class		biotracs.openms.model.FidoAdapterConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017


classdef FidoAdapterConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant) 
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FidoAdapterConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
            
			this.updateParamValue('OutputFileExtension','idXML');
            this.createParam('GreedyGroupResolution', true , ...
                'Constraint', biotracs.core.constraint.IsBoolean(),...
                'Description', 'Post-process Fido output with greedy resolution of shared peptides based on the protein probabilities. Also adds the resolved ambiguity groups to output. (default: true) ');
            this.createParam('KeepZeroGroup', true , ...
                'Constraint',  biotracs.core.constraint.IsBoolean(),...
                'Description', 'Keep the group of proteins with estimated probability of zero, which is otherwise removed (it may be very large). (default: true) ');
            this.createParam('AllPsms', true , ...
                'Constraint', biotracs.core.constraint.IsBoolean(), ... 
                'Description', 'Consider all PSMs of each peptide, instead of only the best one. (default: true)');
            
            this.optionSet.addElements(...
                'GreedyGroupResolution', biotracs.core.shell.model.Option('-greedy_group_resolution "%s"', 'FormatFunction', @(x)this.doFormatBoolean(x)), ...
                'KeepZeroGroup',  biotracs.core.shell.model.Option('-keep_zero_group "%s"', 'FormatFunction', @(x)this.doFormatBoolean(x)), ...
                'AllPsms',  biotracs.core.shell.model.Option('-all_PSMs "%s"', 'FormatFunction', @(x)this.doFormatBoolean(x) ) ...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
       
    end
    
end
