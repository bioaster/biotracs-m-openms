% BIOASTER
%> @file		FeatureFinderCentroided.m
%> @class		biotracs.openms.model.FeatureFinderCentroided
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef FeatureFinderCentroided < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FeatureFinderCentroided()
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.FeatureFinderCentroidedConfig';
            %this.outputFileExtension = 'featureXML';
            
                       % enhance inputs specs
            this.setInputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                ),...
                struct(...
                'name', 'SeedList',...
                'class', 'biotracs.data.model.DataFileSet', ...
                'required', false ...
                )...
                });
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function [ outputDataFilePath ] = doPrepareInputAndOutputFilePaths( this, iIndex )
            resourceSetFeatureFinder = this.getInputPortData('DataFileSet');
            resourceSetSeedList = this.getInputPortData('SeedList');
           
            if ~isEmpty(resourceSetSeedList)
                %format feature file path
                featureDataFile = resourceSetFeatureFinder.getAt(iIndex);
                this.config.updateParamValue('InputFilePath', featureDataFile.getPath());
                
                %format id file path
                seedDataFile = resourceSetSeedList.getAt(iIndex);
                this.config.updateParamValue('SeedList', seedDataFile.getPath());
                
                %fomat output file path
                outputDataFilePath = fullfile(...
                    [this.config.getParamValue('WorkingDirectory'), '/', featureDataFile.getName(),  ...
                    '.', this.config.getParamValue('OutputFileExtension')] ...
                    );
                
                this.config.updateParamValue('OutputFilePath', outputDataFilePath);
            else
                dataFileSet = this.getInputPortData('DataFileSet');
                inputDataFile = dataFileSet.getAt(iIndex);
                
                outputFileExtension = this.config.getParamValue('OutputFileExtension');
                if strcmpi(outputFileExtension, '?inherit?')
                    outputFileExtension = inputDataFile.getExtension();
                end
                
                outputDataFilePath = fullfile([this.config.getParamValue('WorkingDirectory'), '/', inputDataFile.getName(),  '.', outputFileExtension]);
                this.config.updateParamValue('InputFilePath', inputDataFile.getPath());
                this.config.updateParamValue('OutputFilePath', outputDataFilePath);
            end
        end
    end

end
