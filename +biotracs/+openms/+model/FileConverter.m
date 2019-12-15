% BIOASTER
%> @file		FileConverter.m
%> @class		biotracs.openms.model.FileConverter
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef FileConverter < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FileConverter()
            %#function biotracs.openms.model.FileConverterConfig
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.FileConverterConfig';
            %this.outputFileExtension = 'mzml';
            this.setDescription('Converts between different MS file formats.');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end

end
