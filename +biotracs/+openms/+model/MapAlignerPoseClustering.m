% BIOASTER
%> @file		MapAlignerPoseClustering.m
%> @class		biotracs.openms.model.MapAlignerPoseClustering
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef MapAlignerPoseClustering < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    properties( Access = protected)
    end
    
    methods
        
        % Constructor
        function this = MapAlignerPoseClustering()
            %#function biotracs.openms.model.MapAlignerPoseClusteringConfig
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.MapAlignerPoseClusteringConfig';
            %this.outputFileExtension = 'featureXML';
            this.setDescription('Corrects retention time distortions between maps using a pose clustering approach.');
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        function [ outputDataFilePath ] = doPrepareInputAndOutputFilePaths( this, iIndex )
            dataFileSet = this.getInputPortData('DataFileSet');
            
            nbFiles = dataFileSet.getLength();
            for  i = 1:nbFiles
                dataFile = dataFileSet.getAt(i);
                [filePath , name,~]= fileparts(dataFile.getPath());
                
                if strcmp(name, this.config.getParamValue('Reference'))
                    this.config.refPath = filePath;
                end
            end
            inputDataFile = dataFileSet.getAt(iIndex);
            
            outputFileExtension = this.config.getParamValue('OutputFileExtension');
            if strcmpi(outputFileExtension, '?inherit?')
                outputFileExtension = inputDataFile.getExtension();
            end
            
            outputDataFilePath = biotracs.core.utils.regularizepath([this.config.getParamValue('WorkingDirectory'), '/', inputDataFile.getName(),  '.', outputFileExtension]);
            this.config.updateParamValue('InputFilePath', inputDataFile.getPath());
            this.config.updateParamValue('OutputFilePath', outputDataFilePath);
        end
        
       
    end
end
