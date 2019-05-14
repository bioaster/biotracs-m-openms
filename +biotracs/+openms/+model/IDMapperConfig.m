% BIOASTER
%> @file		IDMapperConfig.m
%> @class		biotracs.openms.model.IDMapperConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015


classdef IDMapperConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
        
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = IDMapperConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
			this.updateParamValue('OutputFileExtension','featureXML');
            this.createParam('IdFilePath', '', ...
                'Constraint', biotracs.core.constraint.IsInputPath(), ...
                'Description', ' Protein/peptide identifications file (valid formats: mzid, idXML)');
            this.createParam('ToleranceRt',  60, ...
                'Constraint', biotracs.core.constraint.IsPositive(), ...
                'Description', 'RT tolerance (in seconds) for the matching of peptide identifications and (consensus) features. Tolerance is understood as plus or minus x, so the matching range increases by twice the given value. (default: 60 min: 0)');
            this.createParam('ToleranceMz',  10, ...
                'Constraint', biotracs.core.constraint.IsPositive(), ...
                'Description', 'M/z tolerance (in ppm or Da) for the matching of peptide identifications and (consensus) features. Tolerance is understood as plus or minus x, so the matching range increases by twice the given value. (default: 10 min: 0)');
            this.createParam('MzReference',  'precursor', ...
                'Constraint', biotracs.core.constraint.IsInSet({'peptide', 'precursor'}), ...
                'Description', '');
           this.createParam('UseCentroidMz',  true, ...
                'Constraint', biotracs.core.constraint.IsBoolean(), ...
                'Description', '');
           this.createParam('UseCentroidRt',  true, ...
                'Constraint', biotracs.core.constraint.IsBoolean(), ...
                'Description', '');
           
            this.optionSet.addElements(...
                'IdFilePath',     biotracs.core.shell.model.Option('-id "%s"'), ...
                'MzReference',  biotracs.core.shell.model.Option('-mz_reference "%s"'), ...
                'UseCentroidMz', biotracs.core.shell.model.Option('-feature:use_centroid_mz  "%s"', 'FormatFunction', @(x)this.doFormatBoolean(x)), ...
                'UseCentroidRt', biotracs.core.shell.model.Option('-feature:use_centroid_rt  "%s"', 'FormatFunction', @(x)this.doFormatBoolean(x)), ...
                'ToleranceRt',  biotracs.core.shell.model.Option('-rt_tolerance "%g"' ), ...
                'ToleranceMz',   biotracs.core.shell.model.Option('-mz_tolerance "%g"') ...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)         
    end

end
