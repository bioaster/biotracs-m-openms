% BIOASTER
% %> @file		FalseDiscoveryRate.m
%> @class		biotracs.openms.model.FalseDiscoveryRate
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef FalseDiscoveryRate < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FalseDiscoveryRate()
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.FalseDiscoveryRateConfig';
            %this.outputFileExtension = 'idXML';
            this.setDescription('Estimates the false discovery rate on peptide and protein level using decoy searches.');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end

end
