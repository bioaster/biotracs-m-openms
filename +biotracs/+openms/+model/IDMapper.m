% BIOASTER
%> @file		IDMapper.m
%> @class		biotracs.openms.model.IDMapper
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef IDMapper < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = IDMapper()
            %#function biotracs.openms.model.IDMapperConfig biotracs.data.model.DataFileSet
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.IDMapperConfig';
            %this.outputFileExtension = 'featureXML';
            
            % enhance inputs specs
            this.setInputSpecs({...
                struct(...
                'name', 'FeatureFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                ),...
                struct(...
                'name', 'IdFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                )...
                });
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function [ n ] = doComputeNbCmdToPrepare( this )
            dataFileSet = this.getInputPortData('FeatureFileSet');
            n = dataFileSet.getLength();
        end
        
        function [ outputDataFilePath ] = doPrepareInputAndOutputFilePaths( this, iIndex )               
            resourceSetFeatureFinder = this.getInputPortData('FeatureFileSet');
            resourceSetIdFilter = this.getInputPortData('IdFileSet');
           
     

            %format feature file path
            featureDataFile = resourceSetFeatureFinder.getAt(iIndex);
            this.config.updateParamValue('InputFilePath', featureDataFile.getPath());
            
            %format id file path
            idDataFile = resourceSetIdFilter.getAt(iIndex);
            this.config.updateParamValue('IdFilePath', idDataFile.getPath());
            
            if ~strcmp(featureDataFile.getName(),idDataFile.getName())
                error('Warning, the identified ''%s''idXML is being mapped to the mass trace ''%s'' featureXML',featureDataFile.getName(),idDataFile.getName()  )
            end
            
            %fomat output file path
            outputDataFilePath = fullfile(...
                [this.config.getParamValue('WorkingDirectory'), '/', featureDataFile.getName(),  ...
                '.', this.config.getParamValue('OutputFileExtension')] ...
                );
            
            this.config.updateParamValue('OutputFilePath', outputDataFilePath);
        end
        

    end
    
end
