% BIOASTER
%> @file		FeatureFinderMetabo.m
%> @class		biotracs.openms.model.FeatureFinderMetabo
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef FeatureFinderMetabo < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FeatureFinderMetabo()
            %#function biotracs.openms.model.FeatureFinderMetaboConfig
            
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.FeatureFinderMetaboConfig';
            %this.outputFileExtension = 'featureXML';
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end

end
