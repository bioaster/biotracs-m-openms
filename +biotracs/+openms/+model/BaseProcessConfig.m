% BIOASTER
%> @file		BaseProcessConfig.m
%> @class		biotracs.openms.model.BaseProcessConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017


classdef (Abstract)BaseProcessConfig < biotracs.core.shell.model.ShellConfig
    
    
    properties(Constant)
        
    end
    
    properties(Access = protected)
        processName;
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = BaseProcessConfig( )
            this@biotracs.core.shell.model.ShellConfig( );
            this.optionSet.addElements(...
                'InputFilePath',        biotracs.core.shell.model.Option('-in "%s"', 'ProtectValueWithQuotes', true), ...
                'OutputFilePath',       biotracs.core.shell.model.Option('-out "%s"', 'ProtectValueWithQuotes', true), ...
                'ShellConfigFilePath',  biotracs.core.shell.model.Option('-ini "%s"', 'ProtectValueWithQuotes', true) ...
                );
            this.updateParamValue('UseShellConfigFile', true);
            
            openMsBinPath = biotracs.core.env.Env.vars('OpenMSBinPath');
            processName = regexprep(class(this),'.*\.([^\.]*)Config$', '$1');
            if ispc
                processName = strcat(processName,'.exe');
            end
            this.updateParamValue('ExecutableFilePath', fullfile(openMsBinPath,processName));
        end
        
        %-- E --

        %-- F --
        
        function listOfFilePathStr = formatFilePathAsString( ~, filePathCell )
            listOfFilePathStr = '';
            filesNumber = length(filePathCell);
            for i=1:filesNumber
                fileName = filePathCell{i};
                listOfFilePathStr = strcat( listOfFilePathStr, ' "', fileName ,'"' );
            end
        end
        
        %-- G --
        
        function name = getProcessName( this )
            name = this.processName;
        end
        
        
        %overload parent method
        function [ docNode, paramNode ] = getShellParamsAsXml( this, varargin )
            p = inputParser();
            p.addParameter('DocNode', [], @(x)(isa(x, 'org.apache.xerces.dom.DocumentImpl')));
            p.addParameter('Label', this.getProcessName(), @ischar);
            p.addParameter('Description', this.getDescription, @ischar);
            p.addParameter('Version', '1.6.2', @ischar);
            p.addParameter('XMLSchemaInstance', 'http://www.w3.org/2001/XMLSchema-instance', @ischar);
            p.addParameter('XMLNoNamespaceSchemaLocation', 'https://raw.githubusercontent.com/OpenMS/OpenMS/develop/share/OpenMS/SCHEMAS/Param_1_6_2.xsd', @ischar);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            if isempty(p.Results.DocNode)
                docNode = com.mathworks.xml.XMLUtils.createDocument('PARAMETERS');
            end
            
            docRootNode = docNode.getDocumentElement;
            docRootNode.setAttribute('version',p.Results.Version);
            docRootNode.setAttribute('xmlns:xsi',p.Results.XMLSchemaInstance);
            docRootNode.setAttribute('xsi:noNamespaceSchemaLocation',p.Results.XMLNoNamespaceSchemaLocation);
            
            %> parametrable node
            paramNode = docNode.createElement('NODE');
            paramNode.setAttribute('name', p.Results.Label);
            paramNode.setAttribute('description', p.Results.Description);
            
            %> version item
            t = datetime('now','TimeZone','local','Format','yyyy-MM-dd''T''HH:mm:ssZZZZZ');            
            item = docNode.createElement('ITEM');
            item.setAttribute('name', 'version');
            item.setAttribute('datetime', sprintf('%s',t));
            item.setAttribute('value', '2.4.0');
            item.setAttribute('type','string');
            item.setAttribute('description', [ 'Generated by ' biotracs.core.env.Env.version(true)]);
            item.setAttribute('required', 'false');
            item.setAttribute('advanced', 'true');
            paramNode.appendChild(item);
            
            %> parameters' section
            sectionNode = docNode.createElement('NODE');
            sectionNode.setAttribute('name', '1');
            sectionNode.setAttribute('description', ['Instance 1; section for ', p.Results.Label]);

            this.doAppendShellParamItemsToXmlNode( docNode, sectionNode );
            paramNode.appendChild(sectionNode);
            docRootNode.appendChild( paramNode );
        end
        
        %-- S --
        
        function setProcessName( this, iName )
            this.processName = iName;
        end
        
    end

    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)

        function this = doAppendShellParamItemsToXmlNode( this, docNode, sectionNode )
            optionNames = this.optionSet.getElementNames();
            optStruct = this.formatOptionsAsStruct();
            optShellPrefixes = fieldnames(optStruct);

            nodeMap = containers.Map();
            for i=1:length(optShellPrefixes)
                opt = optStruct.(optShellPrefixes{i});
                optionNameParts = strsplit(opt.name, ':');
                nbParts = length(optionNameParts);
                parentNode = sectionNode;

                if nbParts >= 1
                    parentNode = this.doAppendShellParamHierarchyToXmlNode( docNode, parentNode, optionNameParts, nodeMap );
                    name = optionNameParts{end};
                else
                    name = opt.name;
                end
                %is regular parameter
                param = this.getParam( optionNames{i} );
                c = param.getConstraint();
                value = opt.value;
                
                if isempty(c)
                    error('Constraint not found for parameter %s', name);
                elseif isa(c, 'biotracs.core.constraint.IsInputPath')
                    this.doAppendShellInputItemsToXmlNode( name, value, docNode, parentNode );
                elseif isa(c, 'biotracs.core.constraint.IsOutputPath')
                    this.doAppendShellOutputItemsToXmlNode( name, value, docNode, parentNode );
                else
                
                        if isa(c, 'biotracs.core.constraint.IsRange')
                            type = c.type;
                        elseif isa(c, 'biotracs.core.constraint.IsNumeric')
                            if strcmp(c.type, 'integer')
                                type = 'int';
                            else
                                type = 'double';
                            end
                        elseif isa(c, 'biotracs.core.constraint.IsText')
                            if strcmp(c.type, 'string list')
                                type = 'string list';
                            else
                                type= 'string';
                            end
                        else
                            type='string';
                        end

                    this.doAppendShellItemToXml( name, value, type , docNode, parentNode); 
                end
            end
        end
        
        function this = doAppendShellItemToXml( this, name, value, type, docNode, parentNode )
            node = docNode.createElement('ITEM');
            node.setAttribute('name', name);
            node.setAttribute('value', value);
            node.setAttribute('type', type);
            parentNode.appendChild(node);
        end
        
        function [ parentNode ] = doAppendShellParamHierarchyToXmlNode( ~, docNode, parentNode, optionNameParts, nodeMap )
            nbParts = length(optionNameParts);
            %create node hierarchy
            fullName = '';
            for j=1:nbParts-1
                subName = optionNameParts{j};
                fullName = strcat(fullName, '_', subName);
                nodeHierarchyExists = isKey(nodeMap, fullName);
                if ~nodeHierarchyExists
                    node = docNode.createElement('NODE');
                    node.setAttribute('name', subName);
                    nodeMap(fullName) = node;
                    parentNode.appendChild(node);
                    %move parent node to the current node
                    parentNode = node;
                else
                    parentNode = nodeMap(fullName);
                end
            end
            
        end
        
        function this = doAppendShellOutputItemsToXmlNode( this, name, filePathStr, docNode, parentNode )
     
            isQuoted = biotracs.core.utils.isQuoted(filePathStr);
            %@ToDo : use delimiter
            if isQuoted
                filePathsCell = regexp( filePathStr, '"([^"]*)"', 'tokens' );
            else
                filePathsCell = { filePathStr };
            end
            this.doAppendShellItemsToXmlNode( name, 'output-file', filePathsCell, docNode, parentNode );
        end
        
        function this = doAppendShellInputItemsToXmlNode( this, name, filePathStr, docNode, parentNode )
            %@ToDo : use delimiter
            isQuoted = biotracs.core.utils.isQuoted(filePathStr);
            if isQuoted
                filePathsCell = regexp( filePathStr, '"([^"]*)"', 'tokens' );
            else
                filePathsCell = { filePathStr };
            end
            this.doAppendShellItemsToXmlNode( name, 'input-file', filePathsCell, docNode, parentNode );
        end
        
        
        function this = doAppendShellItemsToXmlNode( this, itemName, itemType, itemValues, docNode, parentNode )
            if ischar(itemValues)
                itemValues = { itemValues };
            end
            
            if isempty(itemValues)
                return;
            end
            
            if length(itemValues) == 1
                node = docNode.createElement('ITEM');
                node.setAttribute('name', itemName);
                node.setAttribute('type', itemType);
                node.setAttribute('value', itemValues{1});
            else
                node = docNode.createElement('ITEMLIST');
                node.setAttribute('name', itemName);
                node.setAttribute('type', itemType);
                
                for i=1:length(itemValues)
                    val = itemValues{i};
                    item = docNode.createElement('LISTITEM');
                    item.setAttribute('value', val);
                    node.appendChild(item);
                end
            end
            
            parentNode.appendChild(node);
        end
        
    end
    
end
