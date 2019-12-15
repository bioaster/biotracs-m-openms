% BIOASTER
%> @file		IDFilter.m
%> @class		biotracs.openms.model.IDFilter
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef IDFilter < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = IDFilter()
            %#function biotracs.openms.model.IDFilterConfig
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.IDFilterConfig';
            %this.outputFileExtension = 'idXML';
            this.setDescription('Filters results from protein or peptide identification engines based on different criteria.');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        
    end

end
