% BIOASTER
%> @file		PeptideIndexer.m
%> @class		biotracs.openms.model.PeptideIndexer
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef PeptideIndexer < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = PeptideIndexer()
            %#function biotracs.openms.model.PeptideIndexerConfig biotracs.data.model.DataFileSet biotracs.data.model.DataFile
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.PeptideIndexerConfig';
            %this.outputFileExtension = 'idXML';
            this.setDescription('Refreshes the protein references for all peptide hits.');
            
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
            
            %format Fasta file path
            this.config.updateParamValue('FastaFilePath', databaseFile.getPath());
            
            %fomat output file path
            outputDataFilePath = fullfile(...
                [this.config.getParamValue('WorkingDirectory'), '/', featureDataFile.getName(),  ...
                '.', this.config.getParamValue('OutputFileExtension')] ...
                );
            
            this.config.updateParamValue('OutputFilePath', outputDataFilePath);
        end
        
    end
    
end
