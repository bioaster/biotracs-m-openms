% BIOASTER
%> @file		ConsensusID.m
%> @class		biotracs.openms.model.ConsensusID
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef ConsensusID < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = ConsensusID()
            %#function biotracs.openms.model.ConsensusIDConfig
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.ConsensusIDConfig';
            %this.outputFileExtension = 'idXML';
            this.setDescription('Computes a consensus of peptide identifications of several identification engines.');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        
    end

end
