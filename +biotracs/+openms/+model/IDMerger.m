% BIOASTER
%> @file		IDMerger.m
%> @class		biotracs.openms.model.IDMerger
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef IDMerger < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = IDMerger()
            %#function biotracs.openms.model.IDMergerConfig biotracs.core.mvc.model.ResourceSet
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.IDMergerConfig';
            %this.outputFileExtension = 'idXML';
            this.setDescription('Merges several protein/peptide identification files into one file.');
            
            % redifine inputs specs
            this.updateInputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', 'biotracs.core.mvc.model.ResourceSet' ...
                )...
                });
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function [listOfCmd, outputDataFilePaths, nbOut ] = doPrepareCommand (this)
            dataFileSet = this.getInputPortData('DataFileSet');
            numberOfFiles = getLength( dataFileSet.elements{1} );
            outputDataFilePaths = cell(1,numberOfFiles);
            numberOfFolders = getLength( dataFileSet );
            if numberOfFolders == 1
                listOfCmd = cell(1,1);
            else
                listOfCmd = cell(1,numberOfFiles);
            end
            
            for i=1:numberOfFiles
                
                % -- prepare file paths
                [ outputDataFilePaths{i} ] = this.doPrepareInputAndOutputFilePaths( i );
                
                % -- config file export
                if this.config.getParamValue('UseShellConfigFile')
                    this.doUpdateConfigFilePath();
                    this.exportConfig( this.config.getParamValue('ShellConfigFilePath'), 'Mode', 'Shell' );
                end
                
                % -- exec
                [ listOfCmd{i} ] = this.doBuildCommand();
            end
            nbOut = length(listOfCmd);
        end
        
        
        function [ outputDataFilePath ] = doPrepareInputAndOutputFilePaths( this, iIndex )
            dataFileSet = this.getInputPortData('DataFileSet');
            numberOfFiles = getLength( dataFileSet.elements{1} );
            numberOfFolders = getLength( dataFileSet );
            listOfFilePathsStr = '';
            if numberOfFolders == 1
                
                for i=1:numberOfFiles
                    folderDataFileSet = dataFileSet.getAt(1);
                    dataFile = folderDataFileSet.getAt(i);
                    
                    listOfFilePathsStr = strcat( listOfFilePathsStr, ' "', dataFile.getPath() ,'"' );
                end
                outputDataFilePath = fullfile([this.config.getParamValue('WorkingDirectory'), '/', dataFile.getName(),  '.', this.config.getParamValue('OutputFileExtension')]);
            else
                for j=1:numberOfFolders
                    folderDataFileSet = dataFileSet.getAt(j);
                    dataFile = folderDataFileSet.getAt(iIndex);
                    listOfFilePathsStr = strcat( listOfFilePathsStr, ' "', dataFile.getPath() ,'"' );
                    outputDataFilePath = fullfile([this.config.getParamValue('WorkingDirectory'), '/', dataFile.getName(),  '.', this.config.getParamValue('OutputFileExtension')]);
                end
            end
            this.config.updateParamValue('InputFilePath', listOfFilePathsStr);
            this.config.updateParamValue('OutputFilePath', outputDataFilePath);
        end
        
    end
    
end
