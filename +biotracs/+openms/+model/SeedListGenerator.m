% BIOASTER
%> @file		SeedListGenerator.m
%> @class		biotracs.openms.model.SeedListGenerator
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef SeedListGenerator < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = SeedListGenerator()
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.SeedListGeneratorConfig';
            %this.outputFileExtension = 'idXML';
            this.setDescription('Seed List Generator for MS1 mass trace from precursors.');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
  
    end

end
