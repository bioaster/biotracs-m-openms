% BIOASTER
% %> @file		IDPosteriorErrorProbabilityConfig.m
%> @class		biotracs.openms.model.IDPosteriorErrorProbabilityConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016


classdef IDPosteriorErrorProbabilityConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = IDPosteriorErrorProbabilityConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
			this.updateParamValue('OutputFileExtension','idXML');
			this.createParam('IgnoreBadData', false , ...
                'Constraint', biotracs.core.constraint.IsBoolean(),...
                'Description', 'If set errors will be written but ignored. Useful for pipeline with many datasets where only a few are bad, but the pipeline should run through. (Default: false)');

            this.optionSet.addElements(...
                'IgnoreBadData',  biotracs.core.shell.model.Option('-ignore_bad_data  "%s"', 'FormatFunction', @(x)this.doFormatBoolean(x)) ...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end
    
end
