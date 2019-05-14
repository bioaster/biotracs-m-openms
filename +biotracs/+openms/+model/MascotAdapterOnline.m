% BIOASTER
%> @file		MascotAdapterOnline.m
%> @class		biotracs.openms.model.MascotAdapterOnline
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017

classdef MascotAdapterOnline < biotracs.openms.model.BaseProcess
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = MascotAdapterOnline()
            this@biotracs.openms.model.BaseProcess();
            this.configType = 'biotracs.openms.model.MascotAdapterOnlineConfig';
            %this.outputFileExtension = 'idXML';
            this.setDescription('Annotates MS/MS spectra using Mascot.');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
%            function doBeforeRun( this )
%             if ~this.getConfig.getParamValue('UseMascot')
%                  this.setIsPhantom( true );
%             end
        
    end

end
