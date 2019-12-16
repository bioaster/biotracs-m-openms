% BIOASTER
%> @file		ProteinQuantifier.m
%> @class		biotracs.openms.model.ProteinQuantifier
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017

classdef ProteinQuantifier < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = ProteinQuantifier()
            %#function biotracs.openms.model.ProteinQuantifierConfig biotracs.data.model.DataFileSet biotracs.data.model.DataFileSet
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.ProteinQuantifierConfig';
            %this.outputFileExtension = 'csv';
            this.setDescription('Compute peptide and protein abundances from annotated feature/consensus maps.');
            
            this.setInputSpecs({...
                struct(...
                'name', 'FeatureFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                ),...
                struct(...
                'name', 'GroupProteinsFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                )...
                });
            
            this.setOutputSpecs({...
                struct(...
                'name', 'ProteinAbundanceFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                ),...
                struct(...
                'name', 'PeptideAbundanceFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                )...
                });
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function [ outputDataFilePaths] = doPrepareInputAndOutputFilePaths( this, iIndex )
            resourceSetFeatureFile = this.getInputPortData('FeatureFileSet');
            resourceSetProteinGroups = this.getInputPortData('GroupProteinsFileSet');
            
            %format input
            inputDataFile = resourceSetFeatureFile.getAt(iIndex);
            this.config.updateParamValue('InputFilePath', resourceSetFeatureFile.getElements{1}.getPath());
            this.config.updateParamValue('ProteinGroups', resourceSetProteinGroups.getElements{1}.getPath());
            
            %format Output
            outputFilePath = inputDataFile.getName();
            
            outputProteinDataFilePath = fullfile([this.config.getParamValue('WorkingDirectory'), ...
                '/', outputFilePath,  'ProteinAbundance.', this.config.getParamValue('OutputFileExtension')])
            outputPeptideDataFilePaths = fullfile([this.config.getParamValue('WorkingDirectory'), ...
                '/', outputFilePath,  'PeptideAbundance.', this.config.getParamValue('OutputFileExtension')])
            outputDataFilePaths = {outputProteinDataFilePath , outputPeptideDataFilePaths}

            this.config.updateParamValue('OutputFilePath', outputProteinDataFilePath);
            this.config.updateParamValue('PeptideOut', outputPeptideDataFilePaths);
        end
        
         function [ n ] = doComputeNbCmdToPrepare( this )
            dataFileSet = this.getInputPortData('GroupProteinsFileSet');
            n = dataFileSet.getLength();
        end

        function this = doSetResultAndWriteOutLog(this, numberOfOutFile, outputFileName, listOfCmd, cmdout, outputDataFilePaths)
            proteinsResults = this.getOutputPortData('ProteinAbundanceFileSet');
            peptidesResults = this.getOutputPortData('PeptideAbundanceFileSet');
            
           outputDataFilePaths'
			%store main log file name
            mainLogFileName = this.logger.getLogFileName();
            this.logger.closeLog(true); %silent = true
			
            for i=1:numberOfOutFile
                this.logger.setLogFileName(outputFileName{i});
                this.logger.openLog('w');
                this.logger.setShowOnScreen(false);

                this.logger.writeLog('# Command');
                this.logger.writeLog('%s', listOfCmd{i});
                this.logger.writeLog('# Command outputs');
                this.logger.writeLog('%s', cmdout{i});
				this.logger.closeLog();
				
                proteinsResults.allocate(numberOfOutFile);
                peptidesResults.allocate(numberOfOutFile);
                for j=1:numberOfOutFile
                    outputDataFilePeptides = biotracs.data.model.DataFile(outputDataFilePaths{2});
                    peptidesResults.setAt(j, outputDataFilePeptides);
                    outputDataFileProteins = biotracs.data.model.DataFile(outputDataFilePaths{1});
                    proteinsResults.setAt(j, outputDataFileProteins);
                end
            end
            
			%restore maim log stream
            this.logger.setLogFileName(mainLogFileName);
            this.logger.openLog('a');
            this.logger.setShowOnScreen(true);
            for i=1:numberOfOutFile
                this.logger.writeLog( 'Resource %s processed\n', outputFileName{i});
            end
			
            this.setOutputPortData('ProteinAbundanceFileSet', proteinsResults);
            this.setOutputPortData('PeptideAbundanceFileSet', peptidesResults);
        end
        
        
          function [listOfCmd, outputDataFilePaths, nbOut ] = doPrepareCommand (this)
            nbOut = this.doComputeNbCmdToPrepare();
            listOfCmd = cell(1,nbOut);
			outputDataFilePaths = cell(1,nbOut);
            for i=1:nbOut
                % -- prepare file paths
                [  outputDataFilePaths  ] = this.doPrepareInputAndOutputFilePaths( i );
outputDataFilePaths
                % -- config file export
                if this.config.getParamValue('UseShellConfigFile')
                    this.doUpdateConfigFilePath();
                    this.exportConfig( this.config.getParamValue('ShellConfigFilePath'), 'Mode', 'Shell' );
                end
                
                % -- exec
                [ listOfCmd{i} ] = this.doBuildCommand();
            end
            outputDataFilePaths
            %nbOut = length(listOfCmd);
        end

    end
    
end
