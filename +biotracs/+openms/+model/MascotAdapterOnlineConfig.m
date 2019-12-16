% BIOASTER
% %> @file		MascotAdapterOnlineConfig.m
%> @class		biotracs.openms.model.MascotAdapterOnlineConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015


classdef MascotAdapterOnlineConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
        
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = MascotAdapterOnlineConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
     
%             this.createParam('UseMascot', true, ...
%                 'Constraint', biotracs.core.constraint.IsBoolean(), ...
%                 'Description', 'To be define if the engine Mascot is to be used for the identification, true or false (default: true)');
  
            constraint =  biotracs.core.constraint.IsRange( [1,15] );
            constraint.setType('string');
            this.createParam('Charges',  [2,5], ...
                'Constraint', constraint,...
                'Description', 'Allowed charge states, given as a comma separated list of integers. (default: 2,3,4,5)');
            modifications = biotracs.core.constraint.IsText();
            modifications.setType('string list');
            this.createParam('FixedModifications',  'Carbamidomethyl (C)', ...
                'Constraint', modifications,...
                'Description', 'Fixed modifications, specified using UniMod (www.unimod.org) terms, (default: Carbamidomethyl (C))' );
            this.createParam('VariableModifications', 'Oxidation (M)' , ...
                'Constraint', modifications,...
                'Description', 'Variable modifications, specified using UniMod (www.unimod.org) terms, (default: Oxidation (M))');
            

			this.updateParamValue('OutputFileExtension','idXML');
            this.createParam('Database', 'SwissProt' , ...
                'Constraint', biotracs.core.constraint.IsText(),...
                'Description', 'Name of the sequence database. (default: SwissProt)');
             this.createParam('Enzyme', 'Trypsin' , ...
                'Constraint', biotracs.core.constraint.IsText(),...
                'Description', 'The enzyme used for digestion (default: Trypsin)');
            this.createParam('SearchType', 'MIS' , ...
                'Constraint', biotracs.core.constraint.IsText(), ...
                'Description', 'Name of the search type for the query. values: MIS, SQ, PMF. (default: MIS)');
            this.createParam('MassToleranceofPrecursor', 10 , ...
                'Constraint', biotracs.core.constraint.IsPositive(), ...
                'Description', 'Tolerance of the precursor peaks. (default: 10)');
            this.createParam('ErrorUnitOfPrecursor', 'ppm' , ...
                'Constraint', biotracs.core.constraint.IsText(), ...
                'Description', 'Units of the precursor mass tolerance. Values: %, mmu, Da or ppm. (default: ppm)');
            this.createParam('MassToleranceOfFragment',  0.5, ...
                'Constraint', biotracs.core.constraint.IsPositive(),...
                'Description', 'Tolerance of the peaks in the fragment spectrum. (default: 0.5)');
            this.createParam('Taxonomy', 'All entries' , ...
                'Constraint', biotracs.core.constraint.IsText(),...
                'Description', 'Taxonomy specification of the sequences. (default: All entries)');
            this.createParam('NumberOfHits',  10 , ...
                'Constraint', biotracs.core.constraint.IsPositive( 'Type', 'integer', 'Strict', true ),...
                'Description', 'Number of hits which should be returned, if 0 AUTO mode is enabled. (default: 10)');
            this.createParam('ServerHostName', biotracs.core.env.Env.vars('MascotServerHostName') , ...
                'Constraint', biotracs.core.constraint.IsText(),...
                'Description', 'Address of the host where Mascot listens, e.g. mascot-server or 127.0.0.1. (default: 10.69.20.18) ');
            this.createParam('ServerPort', 80 , ...
                'Constraint', biotracs.core.constraint.IsPositive('Type', 'integer', 'Strict', true ),...
                'Description', 'Port where the Mascot server listens, 80 should be a good guess. (default: 80)');
            this.createParam('ServerPath', biotracs.core.env.Env.vars('MascotServerPath') , ...
                'Constraint', biotracs.core.constraint.IsPath(),...
                'Description', 'Path on the server where Mascot server listens, mascot should be a good guess. (default: /mascot)');

            this.createParam('UseProxy',  false, ...
                'Constraint', biotracs.core.constraint.IsBoolean(),...
                'Description', 'Flag which enables the proxy usage for the http requests, please specify at least proxy_host and proxy_port. Values: true or false. (default: false)');
%              biotracs.core.env.Env.vars('MascotLogin')
            this.createParam('Login',  false, ...
                'Constraint', biotracs.core.constraint.IsBoolean(),...
                'Description', 'Flag which should be set true if Mascot security is enabled; also set username and password then. Values: true or false. (default: false)');
           
            
            
            
            
            
            this.createParam('MissedCleavages',  1 , ...
                'Constraint', biotracs.core.constraint.IsPositive( 'Type', 'integer', 'Strict', true ),...
                'Description', 'Number of MissedCleavages. (default: 1)');
          
            rangeSetChargeCallback = @(x)(this.doFormatChargeRange(x));

            this.optionSet.addElements(...
                'Database',  biotracs.core.shell.model.Option('-Mascot_parameters:database "%s"'), ...
                'Enzyme', biotracs.core.shell.model.Option('-Mascot_parameters:enzyme "%s"'), ...
                'SearchType',  biotracs.core.shell.model.Option('-Mascot_parameters:search_type "%s"' ), ...
                'MassToleranceofPrecursor',  biotracs.core.shell.model.Option('-Mascot_parameters:precursor_mass_tolerance "%g"'), ...
                'ErrorUnitOfPrecursor',  biotracs.core.shell.model.Option('-Mascot_parameters:precursor_error_units "%s"'), ...
                'MassToleranceOfFragment',  biotracs.core.shell.model.Option('-Mascot_parameters:fragment_mass_tolerance "%g"' ), ...
                'Charges',  biotracs.core.shell.model.Option('-Mascot_parameters:charges "%s"', 'FormatFunction', rangeSetChargeCallback), ...
                'Taxonomy',  biotracs.core.shell.model.Option('-Mascot_parameters:taxonomy "%s"'), ...
                'FixedModifications',  biotracs.core.shell.model.Option('-Mascot_parameters:fixed_modifications "%s"' ), ...
                'MissedCleavages',  biotracs.core.shell.model.Option('-Mascot_parameters:missed_cleavages "%g"'), ...
                'VariableModifications',  biotracs.core.shell.model.Option('-Mascot_parameters:variable_modifications "%s"'), ...
                'NumberOfHits',  biotracs.core.shell.model.Option('-Mascot_parameters:number_of_hits "%g"'), ...
                'ServerHostName',  biotracs.core.shell.model.Option('-Mascot_server:hostname "%s"' ), ...
                'ServerPort',  biotracs.core.shell.model.Option('-Mascot_server:host_port "%g"'), ...
                'ServerPath',  biotracs.core.shell.model.Option('-Mascot_server:server_path "%s"'), ...
                'UseProxy',  biotracs.core.shell.model.Option('-Mascot_server:use_proxy  "%s"', 'FormatFunction', @(x)this.doFormatBoolean(x)), ...
                'Login',  biotracs.core.shell.model.Option('-Mascot_server:login  "%s"' ,  'FormatFunction', @(x)this.doFormatBoolean(x)) ...
                );
        end
      
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function strRange = doFormatChargeRange( ~, iRange1 )
            strRange = strjoin(arrayfun(@(x) num2str(x),iRange1(1):iRange1(2) ,'UniformOutput',false),',');
        end
        
        function this = doAppendItemToXml( this, name, value, type, docNode, parentNode )
            if strcmp(name, 'fixed_modifications') == 0 && strcmp(name, 'variable_modifications')==0
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
