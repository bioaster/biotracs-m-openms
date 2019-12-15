% BIOASTER
%> @file		FileFilter.m
%> @class		biotracs.openms.model.FileFilter
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef FileFilter < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FileFilter()
            %#function biotracs.openms.model.FileFilterConfig
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.FileFilterConfig';
            %this.outputFileExtension = 'mzML';
            this.setDescription('Extracts or manipulates portions of data from peak, feature or consensus-feature files.');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        % override the extension of the output file
        function [ outputDataFilePath ] = doPrepareInputAndOutputFilePaths( this, iIndex )
            dataFileSet = this.getInputPortData('DataFileSet');
            inputDataFile = dataFileSet.getAt(iIndex);			
            this.config.updateParamValue('OutputFileExtension', inputDataFile.getExtension());
            [ outputDataFilePath ] = this.doPrepareInputAndOutputFilePaths@biotracs.openms.model.BaseProcess(iIndex);
        end
        
    end

end
