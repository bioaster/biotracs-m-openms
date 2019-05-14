% BIOASTER
%> @file		FileFilterConfig.m
%> @class		biotracs.openms.model.FileFilterConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015


classdef FileFilterConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FileFilterConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );

            %@ToDo : constraint type overloading;
            constraintCharge = biotracs.core.constraint.IsRange( [1,10] );
            constraintCharge.setType('string');
            constraintRt = biotracs.core.constraint.IsRange( [1,Inf] );
            constraintRt.setType('string');
            
            constraintQuality = biotracs.core.constraint.IsRange( [0,1] );
            constraintQuality.setType('string');
           
           
            this.createParam('Charge', [1,1], ...
                'Constraint', constraintCharge,...
                'Description', 'Charge range to extract. (default: 1:1)');
            this.createParam('FeatureQuality', [0,1], ...
                'Constraint', constraintQuality,...
                'Description', 'Quality range to extract in a featureXML. (default: 0:1)');
            this.createParam('Rt', [], ...
                'Constraint', constraintRt,...
                'Description', 'Retention time range to extract. (default: :)');
           this.createParam('MinConsensusSize', [], ...
                'Constraint', constraintRt,...
                'Description', 'Minimum number of hit of each feature detected across maps  in a consensus. (default: :)');
            this.createParam('Snr', 0, ...
                'Constraint', biotracs.core.constraint.IsPositive(),...
                'Description', 'Signal To Noise ratio (default: 0)');
            this.createParam('MinimumRequiredElements', 1, ...
                'Constraint', biotracs.core.constraint.IsPositive('Type', 'integer', 'Strict', true),...
                'Description', 'Minimum Required Elements in a window, otherwise it is considered as sparse (default: 0)');
            
           
            
            
            rangeSetChargeCallback = @(x)(this.doFormatChargeRange(x));
            this.optionSet.addElements(...
                'Snr', biotracs.core.shell.model.Option('-peak_options:sn "%g"'), ...
                'MinimumRequiredElements', biotracs.core.shell.model.Option('-algorithm:SignalToNoise:min_required_elements "%g"'), ...
                'Charge',       biotracs.core.shell.model.Option('-f_and_c:charge "%s"', 'FormatFunction', rangeSetChargeCallback), ...
                'FeatureQuality',       biotracs.core.shell.model.Option('-feature:q "%s"', 'FormatFunction', rangeSetChargeCallback), ...
                'MinConsensusSize',     biotracs.core.shell.model.Option('-f_and_c:size "%s"', 'FormatFunction', rangeSetChargeCallback), ...
                'Rt',       biotracs.core.shell.model.Option('-rt "%s"', 'FormatFunction', rangeSetChargeCallback) ...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function strRange = doFormatChargeRange( ~, iRange1 )
            if isempty(iRange1)
                strRange = ':';
            else
                strRange = strcat( num2str(iRange1(1)), ':', num2str(iRange1(2)));
            end
        end
        
    end
    
end
