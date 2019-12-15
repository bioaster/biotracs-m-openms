% BIOASTER
% %> @file		IDPosteriorErrorProbability.m
%> @class		biotracs.openms.model.IDPosteriorErrorProbability
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef IDPosteriorErrorProbability < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = IDPosteriorErrorProbability()
            %#function biotracs.openms.model.IDPosteriorErrorProbabilityConfig
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.IDPosteriorErrorProbabilityConfig';
            %this.outputFileExtension = 'idXML';
            this.setDescription('Estimates probabilities for incorrectly assigned peptide sequences and a set of search engine scores using a mixture model.');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end

end
