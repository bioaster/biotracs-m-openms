% BIOASTER
%> @file		FidoAdapter.m
%> @class		biotracs.openms.model.FidoAdapter
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017

classdef FidoAdapter < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FidoAdapter()
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.FidoAdapterConfig';
            %this.outputFileExtension = 'idXML';
            this.setDescription('Runs the protein inference engine Fido.');
      
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end

end
