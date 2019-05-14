% BIOASTER
%> @file		ConsensusMapNormalizerConfig.m
%> @class		biotracs.openms.model.ConsensusMapNormalizerConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017


classdef ConsensusMapNormalizerConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = ConsensusMapNormalizerConfig( )
            this@biotracs.openms.model.BaseProcessConfig();            
            this.updateParamValue('OutputFileExtension','consensusXML');
            this.createParam('TypeOfAlgorithm', 'quantile',...
                'Constraint', biotracs.core.constraint.IsInSet({'robust_regression', 'median', 'median_shift', 'quantile'}),...
                'Description', 'The normalization algorithm that is applied. robust_regression scales each map by a fator computed from the ratios of non-differential background features (as determined by the ratio_threshold parameter), quantile performs quantile normalization, median scales all maps to the same median intensity, median_shift shifts the median instead of scaling (WARNING: if you have regular, log-normal MS data, median_shift is probably the wrong choice. Use only if you know what you are doing!) (default: robust_regression)');
            this.createParam('ThresholdOfRatio', 0.67, ...
                'Constraint', biotracs.core.constraint.IsPositive(),...
                'Description', 'Only for robust_regression: the parameter is used to distinguish between non-outliers (ratio_threshold < intensity ratio < 1/ratio_threshold) and outliers. (default: 0.67)');
            this.createParam('AccessionFilter', {}, ...
                'Constraint', biotracs.core.constraint.IsText(),...
                'Description', 'Use only features with accessions (partially) matching this regular expression for computing the normalization factors. Useful, e.g., if you have known house keeping proteins in your samples. When this parameter is empty or the regular expression matches the empty string, all features are used (even those without an ID). No effect if quantile normalization is used.');
            this.createParam('DescriptionFilter', {}, ...
                'Constraint', biotracs.core.constraint.IsText(),...
                'Description', 'Use only features with description (partially) matching this regular expression for computing the normalization factors. Useful, e.g., if you have known house keeping proteins in your samples. When this parameter is empty or the regular expression matches the empty string, all features are used (even those without an ID). No effect if quantile normalization is used.');

            this.optionSet.addElements(...
                'TypeOfAlgorithm',    biotracs.core.shell.model.Option('-algorithm_type "%s"'), ...
                'ThresholdOfRatio',    biotracs.core.shell.model.Option('-ratio_threshold "%g"'), ...
                'AccessionFilter',    biotracs.core.shell.model.Option('-accession_filter "%s"'), ...
                'DescriptionFilter',    biotracs.core.shell.model.Option('-description_filter "%s"') ...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end
    
end
