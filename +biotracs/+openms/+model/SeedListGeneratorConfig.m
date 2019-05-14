% BIOASTER
%> @file		SeedListGeneratorConfig.m
%> @class		biotracs.openms.model.SeedListGeneratorConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015

classdef SeedListGeneratorConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
        
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = SeedListGeneratorConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
            this.updateParamValue('OutputFileExtension','featureXML');
            %             this.createParam('DeltaRt', 0.01, ...
            %                 'Constraint', biotracs.core.constraint.IsPositive(), ...
            %                 'Description', 'Maximum allowed precursor RT deviation between identifications. (default: 0.01, min:0)');
            %             this.createParam('DeltaMz', 0.01, ...
            %                 'Constraint', biotracs.core.constraint.IsPositive(), ...
            %                 'Description', 'Maximum allowed precursor m/z deviation between identifications. (default: 0.01, min:0)');
            %             this.optionSet.addElements(...
            %                 'DeltaRt',       biotracs.core.shell.model.Option('-rt_delta "%g"'), ...
            %                 'DeltaMz',       biotracs.core.shell.model.Option('-mz_delta "%g"') ...
            %                 );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        function this = doAppendShellOutputItemsToXmlNode( this, name, filePathStr, docNode, parentNode )
            %@ToDo : use delimiter
            isQuoted = biotracs.core.utils.isQuoted(filePathStr);
            if isQuoted
                filePathsCell = regexp( filePathStr, '"([^"]*)"', 'tokens' );
            else
                filePathsCell = { filePathStr };
            end
        
            if strcmp(name, 'out') == 1
                node = docNode.createElement('ITEMLIST');
                node.setAttribute('name', name);
                node.setAttribute('type', 'output-file');
                item = docNode.createElement('LISTITEM');
                item.setAttribute('value', filePathsCell);
                node.appendChild(item);
                parentNode.appendChild(node);
            end
        end
    end
    
end
