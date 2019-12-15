% BIOASTER
%> @file		AccurateMassSearch.m
%> @class		biotracs.openms.model.AccurateMassSearch
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef AccurateMassSearch < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = AccurateMassSearch()
            %#function biotracs.openms.model.AccurateMassSearchConfig biotracs.data.model.DataFileSet biotracs.data.model.DataFile
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.AccurateMassSearchConfig';
            %this.outputFileExtension = 'csv';
            this.setDescription('Find potential HMDB/LipidMaps ids within the given mass error window.');
            
            % enhance inputs specs
            this.setInputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                ),...
                struct(...
                'name', 'NegativeAdductsFile',...
                'class', 'biotracs.data.model.DataFile' ...
                ),...
                struct(...
                'name', 'PositiveAdductsFile',...
                'class', 'biotracs.data.model.DataFile' ...
                ),...
                struct(...
                'name', 'MappingDatabase',...
                'class', 'biotracs.data.model.DataFile' ...
                ),...
                struct(...
                'name', 'StructureDatabase',...
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
            mappingDatabaseFile = this.getInputPortData('MappingDatabase');
            structureDatabaseFile = this.getInputPortData('StructureDatabase');
            positiveAdductsFile = this.getInputPortData('PositiveAdductsFile');
            negativeAdductsFile = this.getInputPortData('NegativeAdductsFile');
            
            %format feature file path
            featureDataFile = dataFileSet.getAt(iIndex);
            this.config.updateParamValue('InputFilePath', featureDataFile.getPath());
            this.config.updateParamValue('PositiveAdductsFilePath', positiveAdductsFile.getPath());
            this.config.updateParamValue('NegativeAdductsFilePath', negativeAdductsFile.getPath());
            this.config.updateParamValue('MappingDataBase', mappingDatabaseFile.getPath());
            this.config.updateParamValue('StructureDataBase', structureDatabaseFile.getPath());
            outputDataFilePath = fullfile(...
                [this.config.getParamValue('WorkingDirectory'), '/', featureDataFile.getName(),  ...
                '.', this.config.getParamValue('OutputFileExtension')] ...
                );
            this.config.updateParamValue('OutputFilePath', outputDataFilePath);
        end
        
    
    end
  
end
