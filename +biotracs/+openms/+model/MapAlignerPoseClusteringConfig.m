% BIOASTER
%> @file		MapAlignerPoseClusteringConfig.m
%> @class		biotracs.openms.model.MapAlignerPoseClusteringConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015


classdef MapAlignerPoseClusteringConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
       
    end
    
    properties(Access = public)
         refPath; 
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = MapAlignerPoseClusteringConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
            this.getParam('InputFilePath')...
                .getConstraint()...
                .setCheckValidity(false);
      
            this.getParam('OutputFilePath')...
                .getConstraint()...
                .setCheckValidity(false);
      
			this.updateParamValue('OutputFileExtension','featureXML');
            this.createParam('MaxNumPeaks',  -1, ...
                'Constraint', biotracs.core.constraint.IsNumeric( 'Type', 'integer', 'Strict', true ),...
                'Description', 'The maximal number of peaks/features to be considered per map. To use all, set to -1. (default: -1)');
            this.createParam('MaxDistanceMzPair',  0.01, ...
                'Constraint', biotracs.core.constraint.IsPositive( 'Type', 'double' ), ...
                'Description', 'Maximum of m/z deviation of corresponding elements in different maps. This condition applies to the pairs considered in hashing. (default: 0.001)');
            this.createParam('NumUsedPoints',  2000, ...
                'Constraint', biotracs.core.constraint.IsPositive( 'Type', 'integer', 'Strict', true ), ...
                'Description', 'Maximum number of elements considered in each map (selected by intensity). Use this to reduce the running time and to disregard weak signals during alignment. For using all points, set this to -1. (default: 1000)');
            this.createParam('MaxDifferenceRtDistance',  60, ...
                'Constraint', biotracs.core.constraint.IsPositive( 'Type', 'double', 'Strict', true ), ...
                'Description', 'Maximum allowed difference in RT in seconds. (default: 60)');
            this.createParam('MaxDifferenceMzDistance',  5, ...
                'Constraint', biotracs.core.constraint.IsPositive( 'Type', 'double', 'Strict', true ),...
                'Description', 'Maximum allowed difference in m/z, (unit defined by unit parameter). (default: 10)');
            this.createParam('Unit',  'ppm', ...
                'Constraint', biotracs.core.constraint.IsText( 'Type', 'string'),...
                'Description', 'Unit of the MaxDifferenceMzDistance parameter. Values: ppm or Da. (default: ppm)');
%             this.createParam('ReferencePath', ''); 
            this.createParam('Reference',  [], ...
                'Constraint', biotracs.core.constraint.IsText(),...
                'Description', 'Name of the sample or Qc used for aligning on all the samples.');
          
            referenceFormatCallback = @(x)(this.doFormatReference(x));
            this.optionSet.addElements(...
                'Reference',  biotracs.core.shell.model.Option('-reference:file "%s"' , 'FormatFunction', referenceFormatCallback), ...
                'MaxNumPeaks',     biotracs.core.shell.model.Option('-algorithm:max_num_peaks_considered "%g"'), ...
                'MaxDistanceMzPair',  biotracs.core.shell.model.Option('-algorithm:superimposer:mz_pair_max_distance "%g"' ), ...
                'NumUsedPoints',   biotracs.core.shell.model.Option('-algorithm:superimposer:num_used_points "%g"'), ...
                'MaxDifferenceRtDistance',     biotracs.core.shell.model.Option('-algorithm:pairfinder:distance_RT:max_difference "%g"'), ...
                'MaxDifferenceMzDistance',  biotracs.core.shell.model.Option('-algorithm:pairfinder:distance_MZ:max_difference "%g"' ), ...
                'Unit',   biotracs.core.shell.model.Option('-algorithm:pairfinder:distance_MZ:unit "%s"') ...
                );
            

        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        
        function oReference = doFormatReference( this, iReference )
            oReference = strcat( this.refPath,'\',  iReference, '.featureXML');
            
        end
        
       function this = doAppendShellItemsToXmlNode( this, itemName, itemType, itemValues, docNode, parentNode )
            if ischar(itemValues)
                itemValues = { itemValues };
            end
            
            if isempty(itemValues)
                return;
            end
            
            if strcmp(itemName, 'in') == 0 && strcmp(itemName, 'out') == 0
                node = docNode.createElement('ITEM');
                node.setAttribute('name', itemName);
                node.setAttribute('type', itemType);
                node.setAttribute('value', itemValues{1});
            else
                node = docNode.createElement('ITEMLIST');
                node.setAttribute('name', itemName);
                node.setAttribute('type', itemType);
                
                for i=1:length(itemValues)
                    val = itemValues{i};
                    item = docNode.createElement('LISTITEM');
                    item.setAttribute('value', val);
                    node.appendChild(item);
                end
            end
            
            parentNode.appendChild(node);
        end
       

    end
    
end
