% BIOASTER
%> @file		XTandemAdapterConfig.m
%> @class		biotracs.openms.model.XTandemAdapterConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015


classdef XTandemAdapterConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
        
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = XTandemAdapterConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
            
			this.updateParamValue('OutputFileExtension','idXML');
            this.createParam('XtandemExecPath', biotracs.core.env.Env.vars('XtandemExecPath'),...
                'Constraint', biotracs.core.constraint.IsInputPath(),...
                'Description', 'X! Tandem executable of the installation e.g. tandem.exe' ...
                );
%             this.createParam('UseXTandem', true, ...
%                 'Constraint', biotracs.core.constraint.IsBoolean(), ...
%                 'Description', 'To be define if the engine XTandem is to be used for the identification, true or false (default: true)');
            this.createParam('DatabaseDecoy',  '', ...
                'Constraint', biotracs.core.constraint.IsInputPath(),...
                'Description', 'FASTA file or pro file. Non-existing relative file-names are looked up via OpenMS.ini:id_db_dir (valid formats: FASTA)');
            this.createParam('Enzyme', 'Trypsin',...
                'Constraint', biotracs.core.constraint.IsText(),...
                'Description', 'Enzyme used for digestion, (default: Trypsin)' );
            this.createParam('MissedCleavages', 1,...
                'Constraint', biotracs.core.constraint.IsPositive( 'Type', 'integer', 'Strict', true ),...
                'Description', 'Missed Cleavages, (default: 1)' );
            this.createParam('PrecursorMassTolerance',  10,...
                'Constraint', biotracs.core.constraint.IsPositive(),...
                'Description', 'Precursor mass tolerance. (default: 10)' );
            this.createParam('FragmentMassTolerance',  0.5,...
                'Constraint', biotracs.core.constraint.IsPositive(),...
                'Description', 'Fragment mass error (default: 0.5)');
            this.createParam('MaxPrecursorCharge',  5,...
                'Constraint', biotracs.core.constraint.IsPositive( 'Type', 'integer', 'Strict', true ),...
                'Description', 'Maximum precursor charge. (default: 5)' );
            this.createParam('FixedModifications', 'Carbamidomethyl (C)',...
                'Constraint', biotracs.core.constraint.IsText(),...
                'Description', 'Fixed modifications, specified using UniMod (www.unimod.org) terms, (default: Carbamidomethyl (C))' );
            this.createParam('VariableModifications',  'Oxidation (M)',...
                'Constraint', biotracs.core.constraint.IsText(),...
                'Description', 'Variable modifications, specified using UniMod (www.unimod.org) terms, (default: Oxidation (M))' );
            
            
            this.optionSet.addElements(...
                'XtandemExecPath',     biotracs.core.shell.model.Option('-xtandem_executable "%s"'), ...
                'Enzyme', biotracs.core.shell.model.Option('-enzyme %s'), ...
                'DatabaseDecoy'    , biotracs.core.shell.model.Option('-database "%s"'), ...
                'MissedCleavages',  biotracs.core.shell.model.Option('-missed_cleavages "%d"' ), ...
                'PrecursorMassTolerance',  biotracs.core.shell.model.Option('-precursor_mass_tolerance "%g"' ), ...
                'FragmentMassTolerance',   biotracs.core.shell.model.Option('-fragment_mass_tolerance "%g"'), ...
                'MaxPrecursorCharge',  biotracs.core.shell.model.Option('-max_precursor_charge "%g"' ), ...
                'FixedModifications', biotracs.core.shell.model.Option('-fixed_modifications [%s]'), ...
                'VariableModifications', biotracs.core.shell.model.Option('-variable_modifications [%s]') ...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function this = doAppendShellItemToXml( this, name, value, type, docNode, parentNode )
            if ~strcmp(name, 'fixed_modifications') && ~strcmp(name, 'variable_modifications')
                node = docNode.createElement('ITEM');
                node.setAttribute('name', name);
                node.setAttribute('value', value);
                node.setAttribute('type', type);
                parentNode.appendChild(node);
            else
                node = docNode.createElement('ITEMLIST');
                node.setAttribute('name', name);
                node.setAttribute('value', value);
                node.setAttribute('type', type);
                parentNode.appendChild(node);
            end
        end

    end
    
    
    
end
