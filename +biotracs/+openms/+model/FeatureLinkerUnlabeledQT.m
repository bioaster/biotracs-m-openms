% BIOASTER
%> @file		FeatureLinkerUnlabeledQT.m
%> @class		biotracs.openms.model.FeatureLinkerUnlabeledQT
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef FeatureLinkerUnlabeledQT < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FeatureLinkerUnlabeledQT()
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.FeatureLinkerUnlabeledQTConfig';
            %this.outputFileExtension = 'consensusXML';
            this.setDescription('Groups corresponding features from multiple maps.');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function [ outputDataFilePath ] = doPrepareInputAndOutputFilePaths( this )
            dataFileSet = this.getInputPortData('DataFileSet');
            nbOut = dataFileSet.getLength();
            outputDataFilePath = cell(1,nbOut);
            if nbOut > 0
                %format input
                inputFilePathCell = dataFileSet.getFilePaths();
                this.config.updateParamValue('InputFilePath', this.config.formatFilePathAsString(inputFilePathCell));
                
                %format output
                firstDataFile = dataFileSet.getAt(1);
                outputFileName = this.config.getParamValue('OutputFileName');
                if isempty(outputFileName)
                    outputFileName = firstDataFile.getName();
                end
                outputDataFilePath{1} = fullfile([this.config.getParamValue('WorkingDirectory'), '/', outputFileName, '.', this.config.getParamValue('OutputFileExtension')]);
                this.config.updateParamValue('OutputFilePath', outputDataFilePath{1});
            end
        end
        
        
     
        %@ToDo : 
        % Run conversion
        function doRun( this )
            % -- prepare file paths
            [ outputDataFilePath ] = this.doPrepareInputAndOutputFilePaths();
            
            if ~isempty(outputDataFilePath)
                % -- config file export
                if this.config.getParamValue('UseShellConfigFile')
                    this.doUpdateConfigFilePath();
                    this.exportConfig( this.config.getParamValue('ShellConfigFilePath'), 'Mode', 'Shell' );
                end
                
                % -- exec
                cmd = this.doBuildCommand();
                [~, cmdout] = system( cmd );
                
                %set output port data
                results = this.getOutputPortData('DataFileSet');
                results.allocate(1);
                outputDataFile = biotracs.data.model.DataFile(outputDataFilePath{1});
                results.setAt(1, outputDataFile);
                
				this.setOutputPortData('DataFileSet', results);
				[~, outputFileName, ~] = fileparts( outputDataFilePath{1} );
                % -- log
                this.doSetResultAndWriteOutLog(1, {outputFileName}, {cmd}, {cmdout}, outputDataFilePath);  

                
%                 openLog(this, outputFileName);
%                 writeLog(this, '# BIOASTER');
%                 writeLog(this, ['# ', class(this)]);
%                 writeLog(this, '');
%                 writeLog(this, '# Command');
%                 writeLog(this, cmd);
%                 writeLog(this, '');
%                 writeLog(this, '# Command outputs');
%                 writeLog(this, cmdout);
%                 closeLog(this);

            end
        end

    end

end
