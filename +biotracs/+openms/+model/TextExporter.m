% BIOASTER
%> @file		TextExporter.m
%> @class		biotracs.openms.model.TextExporter
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef TextExporter < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = TextExporter()
            %#function biotracs.openms.model.TextExporterConfig
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.TextExporterConfig';
            %this.outputFileExtension = 'csv';
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end

end
