% BIOASTER
%> @file		MapAlignerParser.m
%> @class		biotracs.openms.model.MapAlignerParser
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date        2017

classdef MapAlignerParser < biotracs.parser.model.TableParser
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = MapAlignerParser()
            this@biotracs.parser.model.TableParser();
        end
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
     
        function doRun( this )
            this.doRun@biotracs.parser.model.TableParser();
            resourceSet = this.getOutputPortData( 'ResourceSet' );
            resourceSet = biotracs.openms.model.MapAlignerResult.fromResourceSet(resourceSet);
            this.setOutputPortData( 'ResourceSet', resourceSet );
        end
        
        %@ToDo : Automatic class cast !
        function [ featureData ] = doParse( this, iFilePath )
            data = this.doParse@biotracs.parser.model.TableParser( iFilePath );
            featureData = data.getElementByName('FEATURE');
            featureData = featureData.setColumnNames ({'Rt','Mz', 'Intensity', 'Charge', 'FWHM','Quality', 'RtQuality', 'MzQuality', 'RtBegin', 'RtEnd'});
            featureData = biotracs.data.model.DataMatrix.fromDataTable(featureData);

        end
    end
    
end
