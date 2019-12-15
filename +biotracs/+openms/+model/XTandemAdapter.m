% BIOASTER
%> @file		XTandemAdapter.m
%> @class		biotracs.openms.model.XTandemAdapter
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef XTandemAdapter < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = XTandemAdapter()
            %#function biotracs.openms.model.XTandemAdapterConfig biotracs.data.model.DataFileSet biotracs.data.model.DataFile
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.XTandemAdapterConfig';
            %this.outputFileExtension = 'idXML';
            
            % enhance inputs specs
            this.setInputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                ),...
                struct(...
                'name', 'DatabaseFile',...
                'class', 'biotracs.data.model.DataFile' ...
                )...
                });
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)

        function [ outputDataFilePath ] = doPrepareInputAndOutputFilePaths( this, iIndex )               
            dataFileSet = this.getInputPortData('DataFileSet');
            databaseFile = this.getInputPortData('DatabaseFile');
            
            %format feature file path
            featureDataFile = dataFileSet.getAt(iIndex);
            this.config.updateParamValue('InputFilePath', featureDataFile.getPath());
            
            %format database file path
            this.config.updateParamValue('DatabaseDecoy', databaseFile.getPath());

            %fomat output file path
            outputDataFilePath = fullfile(...
                [this.config.getParamValue('WorkingDirectory'), '/', featureDataFile.getName(),  ...
                '.', this.config.getParamValue('OutputFileExtension')] ...
                );
            
            this.config.updateParamValue('OutputFilePath', outputDataFilePath);
        end
    end

end
