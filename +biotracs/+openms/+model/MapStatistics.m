% BIOASTER
%> @file		MapStatistics.m
%> @class		biotracs.openms.model.MapStatistics
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		22017

classdef MapStatistics < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = MapStatistics()
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.MapStatisticsConfig';
            %this.outputFileExtension = 'txt';
            this.setDescription('Statistics for each map');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function [ outputDataFilePath ] = doPrepareInputAndOutputFilePaths( this, iIndex )
            [ ~, dataFileSet ] = this.doComputeNbCmdToPrepare ();
            inputDataFile = dataFileSet.getAt(iIndex);
            outputFileExtension = this.config.getParamValue('OutputFileExtension');
            if strcmpi(outputFileExtension, '?inherit?')
                outputFileExtension = inputDataFile.getExtension();
            end
            
            outputDataFilePath = fullfile([this.config.getParamValue('WorkingDirectory'), '/', inputDataFile.getName(),  '.', outputFileExtension]);
            this.config.updateParamValue('InputFilePath', inputDataFile.getPath());
            this.config.updateParamValue('OutputFilePath', outputDataFilePath);
            
        end
        
         function [listOfCmd, outputDataFilePaths, nbOut ] = doPrepareCommand (this)
            [nbOut, ~] = this.doComputeNbCmdToPrepare();
            outputDataFilePaths = cell(1,nbOut);
            listOfCmd = cell(1,nbOut);
            for i=1:nbOut
                % -- prepare file paths
                [  outputDataFilePaths{i} ] = this.doPrepareInputAndOutputFilePaths( i );
                % -- config file export
                if this.config.getParamValue('UseShellConfigFile')
                    this.doUpdateConfigFilePath();
                    this.exportConfig( this.config.getParamValue('ShellConfigFilePath'), 'Mode', 'Shell' );
                end
                % -- exec
                [ listOfCmd{i} ] = this.doBuildCommand();
            end
            %nbOut = length(listOfCmd);
        end
        
        
        function [ nbOut, dataFileSet ] = doComputeNbCmdToPrepare( this )
            originalDataFileSet = this.getInputPortData('DataFileSet');
            nbFiles = originalDataFileSet.getLength();
            dataFileSet = biotracs.data.model.DataFileSet();
            typeOfFiles = this.config.getParamValue('TypeOfFiles');
            if isempty(typeOfFiles)
                nbOut = nbFiles;
                dataFileSet = originalDataFileSet;
            else
                nbOut = 0;
                for i= 1:nbFiles
                    name = originalDataFileSet.elements{i}.label;
                    if ~isempty(regexp(name, typeOfFiles, 'once'))
                        dataFileSet = dataFileSet.add(originalDataFileSet.elements{i});
                        nbOut = nbOut+1;
                    end
                end
            end
        end

    end

end
