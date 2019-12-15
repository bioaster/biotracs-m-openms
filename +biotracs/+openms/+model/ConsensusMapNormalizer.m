% BIOASTER
%> @file		ConsensusMapNormalizer.m
%> @class		biotracs.openms.model.ConsensusMapNormalizer
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef ConsensusMapNormalizer < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = ConsensusMapNormalizer()
            %#function biotracs.openms.model.ConsensusMapNormalizerConfig
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.ConsensusMapNormalizerConfig';
            %this.outputFileExtension = 'consensusXML';
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end

end
