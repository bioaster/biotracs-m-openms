% BIOASTER
%> @file		IDFilterConfig.m
%> @class		biotracs.openms.model.IDFilterConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		23  Nov 2015


classdef IDFilterConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
        
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = IDFilterConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
			this.updateParamValue('OutputFileExtension','idXML');
            this.createParam('PeptideScore', 0.01, ...
                'Constraint', biotracs.core.constraint.IsPositive(), ...
                'Description', 'The score which should be reached by a peptide hit to be kept. The score is dependent on the most recent(!) preprocessing - it could be Mascot scores (if a MascotAdapter was applied before), or an FDR (if FalseDiscoveryRate was applied before), etc. (default: 0.01)');
            
            this.optionSet.addElements(...
                'PeptideScore',       biotracs.core.shell.model.Option('-score:pep "%g"') ...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)

    end
    
end
