% BIOASTER
%> @file		AccurateMassSearchConfig.m
%> @class		biotracs.openms.model.AccurateMassSearchConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016


classdef AccurateMassSearchConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor        
        function this = AccurateMassSearchConfig( )
            this@biotracs.openms.model.BaseProcessConfig();
			this.updateParamValue('OutputFileExtension','tsv');
            this.createParam('PositiveAdductsFilePath', '', ...
                'Constraint', biotracs.core.constraint.IsInputPath( 'PathMustExist', true ), ...
                'Description', 'This file contains the list of potential positive adducts that will be looked for in the database (valid format .tsv)');
            this.createParam('NegativeAdductsFilePath', '', ...
                'Constraint', biotracs.core.constraint.IsInputPath( 'PathMustExist', true ), ...
                'Description', 'This file contains the list of potential negative adducts that will be looked for in the database (valid format .tsv)');
            this.createParam('IonizationMode', 'positive', ...
                'Constraint', biotracs.core.constraint.IsText(), ...
                'Description', 'Choose ionisation mode (positive or negative)');
            this.createParam('MappingDataBase', 'C:\Program Files\OpenMS-2.3.0\share\OpenMS\CHEMISTRY\HMDBMappingFile.tsv', ...
                'Constraint', biotracs.core.constraint.IsInputPath( 'PathMustExist', true ), ...
                'Description', 'Database input file(s), containing three tab-separated columns of mass, formula, identifier. If mass is 0, it is re-computed from the molecular sum formula. By default CHEMISTRY/HMDBMappingFile.tsv in OpenMS/share is used! If empty, the default will be used. (valid formats: tsv)');
            this.createParam('StructureDataBase', 'C:\Program Files\OpenMS-2.3.0\share\OpenMS\CHEMISTRY\HMDB2StructMapping.tsv', ...
                'Constraint', biotracs.core.constraint.IsInputPath( 'PathMustExist', true ), ...
                'Description', 'Database input file(s), containing four tab-separated columns of identifier , name, SMILES, INCHI.The identifier should match with mapping file. SMILES and INCHI are reported in the output, but not used otherwise. By default CHEMISTRY/HMDB2StructMapping.tsv in OpenMS/share is used! If empty, the default will be used. (valid formats: tsv)');
            this.createParam('KeepUnidentifiedMasses', true, ...
                'Constraint', biotracs.core.constraint.IsBoolean(), ...
                'Description', 'Keep features that did not yield any DB hit. Values: True or False (default: True)');
            this.optionSet.addElements(...
                'PositiveAdductsFilePath',	biotracs.core.shell.model.Option('-positive_adducts "%s"'), ...
                'NegativeAdductsFilePath',	biotracs.core.shell.model.Option('-negative_adducts "%s"'), ...
                'IonizationMode',           biotracs.core.shell.model.Option('-algorithm:ionization_mode "%s"'), ...
                'MappingDataBase',          biotracs.core.shell.model.Option('-db:mapping "%s"'), ...
                'StructureDataBase',        biotracs.core.shell.model.Option('-db:struct "%s"'), ...
                'KeepUnidentifiedMasses',   biotracs.core.shell.model.Option('-algorithm:keep_unidentified_masses "%s"', 'FormatFunction', @(x)this.doFormatBoolean(x))...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
            function this = doAppendShellInputItemsToXmlNode( this, name, filePathStr, docNode, parentNode )
            %@ToDo : use delimiter
            isQuoted = biotracs.core.utils.isQuoted(filePathStr);
            if isQuoted
                filePathsCell = regexp( filePathStr, '"([^"]*)"', 'tokens' );
            else
                filePathsCell = { filePathStr };
            end

            if strcmp(name, 'mapping') == 0 && strcmp(name, 'struct') == 0
                node = docNode.createElement('ITEM');
                node.setAttribute('name', name);
                node.setAttribute('type', 'input-file');
                node.setAttribute('value', filePathsCell);
                parentNode.appendChild(node);
            else
                node = docNode.createElement('ITEMLIST');
                node.setAttribute('name', name);
                node.setAttribute('type', 'input-file');
                item = docNode.createElement('LISTITEM');
                item.setAttribute('value', filePathsCell);
                node.appendChild(item);
                parentNode.appendChild(node);
            end
            
        end
             
    end
    
end
