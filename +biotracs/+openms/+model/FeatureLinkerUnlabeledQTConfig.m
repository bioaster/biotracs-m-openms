% BIOASTER
%> @file		FeatureLinkerUnlabeledQTConfig.m
%> @class		biotracs.openms.model.FeatureLinkerUnlabeledQTConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015


classdef FeatureLinkerUnlabeledQTConfig < biotracs.openms.model.BaseProcessConfig
    

    properties(Constant)
        
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FeatureLinkerUnlabeledQTConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
            
            param = this.getParam('InputFilePath');
            param.getConstraint().setCheckValidity(false);
            
			this.updateParamValue('OutputFileExtension','consensusXML');
            this.createParam('OutputFileName', '', ...
                'Constraint', biotracs.core.constraint.IsText(), ...
                'Description', 'Give a name for the output file');
            this.createParam('RtMaxDifference', 100, ...
                'Constraint', biotracs.core.constraint.IsPositive(), ...
                'Description', 'Maximum allowed difference in RT in seconds. (default: 100)');
            this.createParam('MzMaxDifference', 5, ...
                'Constraint', biotracs.core.constraint.IsPositive(), ...
                'Description', 'Maximum allowed difference in m/z (unit defined by MzUnit). (default: 5)');
            this.createParam('MzUnit', 'ppm', ...
                'Constraint', biotracs.core.constraint.IsText(), ...
                'Description', 'Unit of the MzMaxDifference parameter. Values: ppm or Da. (default: ppm)');

            this.optionSet.addElements(...
                'RtMaxDifference',      biotracs.core.shell.model.Option('-algorithm:distance_RT:max_difference "%g"'), ...
                'MzMaxDifference',      biotracs.core.shell.model.Option('-algorithm:distance_MZ:max_difference "%g"'), ...
                'MzUnit',               biotracs.core.shell.model.Option('-algorithm:distance_MZ:unit "%s"') ...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
                
    end
    
end
